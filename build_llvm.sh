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
fi

export DESTDIR=$PWD/llvm-${LLVM_RELEASE}

mkdir -p build
mkdir -p ${DESTDIR}

pushd build

cmake -G Ninja -C ../stage1.cmake ../${SRC_DIR}/llvm
ninja cxx
export LD_LIBRARY_PATH=$PWD/lib
ninja stage2-install

popd

tar cJf llvm.tar.xz ${DESTDIR}
