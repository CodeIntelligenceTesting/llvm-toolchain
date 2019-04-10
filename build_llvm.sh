#!/bin/bash

export CC=clang
export CXX=clang++

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
fi

OUT_DIR=llvm-${LLVM_RELEASE}

mkdir -p build
mkdir -p ${OUT_DIR}

pushd build

cmake ../${SRC_DIR}/llvm \
      -DCMAKE_BUILD_TYPE="Release" \
      -DLLVM_TARGETS_TO_BUILD="X86" \
      -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;libcxx;libcxxabi;compiler-rt;libunwind;lld" \
      -DLLVM_BUILD_TOOLS=ON \
      -DBUILD_SHARED_LIBS=ON \
      -DLLVM_INCLUDE_EXAMPLES=OFF \
      -DLLVM_INCLUDE_TESTS=ON \
      -DLLVM_BUILD_TESTS=ON \
      -DLLVM_ENABLE_BINDINGS=OFF \
      -DLLVM_ENABLE_OCAMLDOC=OFF \
      -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON \
      -DLIBCXXABI_USE_LLVM_UNWINDER=YES \
      -DLIBCXXABI_USE_COMPILER_RT=YES \
      -DLIBCXX_USE_COMPILER_RT=YES \
      -DCMAKE_INSTALL_PREFIX=../${OUT_DIR}


make -j8
cmake --build . --target install

popd

tar cJf llvm.tar.xz ${OUT_DIR}
