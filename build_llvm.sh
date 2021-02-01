#!/bin/bash
#
# Build our LLVM distribution
#
# The build process is inspired by the "distribution example" in the LLVM
# sources (see clang/cmake/caches/DistributionExample{,-stage2}.cmake), with a
# few changes to match our specific requirements. The unmodified example would
# perform a two-stage build of clang to get a bootstrapped compiler that can
# target several architectures. We do the same (but targeting only x86),
# bootstrapping so that we can use LTO on the stage-2 compiler for performance.
# Additionally, we install several additional LLVM components via a distribution
# build instead of just the compiler, and we link the stage-2 compiler with our
# own libc++ for portability.
#
# A note on LLVM_ENABLE_PROJECTS vs LLVM_ENABLE_RUNTIMES: In a normal build,
# libc++ should be built as a runtime (which adds a dependency on clang, so that
# the library is built with the newly built compiler). However, runtime builds
# don't work well with two-stage builds, so we use the version of libc++
# produced by the stage-1 compiler (which is equivalent).
#
# Here is a rough guideline how to add to or remove components: The list of
# distribution components is in stage2.cmake. To figure out the name of the
# desired component, ninja -C build/tools/clang/stage2-bins help may be a good
# starting point; typically, things that qualify as components will have both a
# build target (say "X") and install targets ("install-X" and
# "install-X-stripped").
#
# Documentation on the build process
# - Configuration options: https://llvm.org/docs/CMake.html
# - Two-stage builds: https://llvm.org/docs/AdvancedBuilds.html
# - Distribution builds: https://llvm.org/docs/BuildingADistribution.html

set -eo pipefail

LLVM_RELEASE=${LLVM_RELEASE:-}

if [ -z ${LLVM_RELEASE} ]
then
  echo LLVM_RELEASE is not set
  exit -1
fi

SRC_DIR=llvm-project-llvmorg-${LLVM_RELEASE}
if [[ ! -e ${SRC_DIR} ]]
then
    wget https://github.com/llvm/llvm-project/archive/llvmorg-${LLVM_RELEASE}.tar.gz
    tar xf llvmorg-${LLVM_RELEASE}.tar.gz
    pushd ${SRC_DIR}
    git apply ../compiler-rt-llvm-fuzzer-mutate.patch
    git apply ../fix-stack-overflow-detection.patch
    popd
fi

DESTDIR=$PWD/llvm-${LLVM_RELEASE}

mkdir -p build
mkdir -p ${DESTDIR}

pushd build
cmake -G Ninja \
      -C ../stage1.cmake \
      -DCMAKE_INSTALL_PREFIX=${DESTDIR} \
      ../${SRC_DIR}/llvm
# First, build libc++ with the host compiler.
ninja cxx
export LD_LIBRARY_PATH=$PWD/lib
# Second, build the rest against it. This includes a new version of libc++, this
# time built with stage-1 clang, which replaces the one built with the host
# compiler.
ninja stage2-install-distribution
popd

# Copy the AFL driver. (It's not meant for distribution, so there's no build
# target for it.)
mkdir -p ${DESTDIR}/src/compiler-rt/lib/fuzzer/afl
cp ${SRC_DIR}/compiler-rt/lib/fuzzer/afl/afl_driver.cpp ${DESTDIR}/src/compiler-rt/lib/fuzzer/afl

tar cJf llvm-${LLVM_RELEASE}.tar.xz $(basename ${DESTDIR})
