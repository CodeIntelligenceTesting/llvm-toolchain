#!/bin/bash

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
    git apply ../fsanitize-coverage-blacklist.patch
    popd
fi

export DESTDIR=$PWD/destdir
export PACKAGE_ROOT=$PWD/llvm-${LLVM_RELEASE}

mkdir -p build
mkdir -p ${DESTDIR}
mkdir -p ${PACKAGE_ROOT}

pushd build

cmake -G Ninja -C ../stage1.cmake ../${SRC_DIR}/llvm
ninja cxx
export LD_LIBRARY_PATH=$PWD/lib
ninja stage2-install
ninja install-llvm-headers
ninja install-clang-headers
popd

# Files are installed in /usr/local,  move them out.
mv ${DESTDIR}/usr/local/* ${PACKAGE_ROOT}

tar cJf llvm.tar.xz ${PACKAGE_ROOT}
