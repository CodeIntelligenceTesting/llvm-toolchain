#!/bin/bash

set -eo pipefail

LLVM_RELEASE=${LLVM_RELEASE:-}

if [ -z ${LLVM_RELEASE} ]
then
  echo LLVM_RELEASE is not set
  exit -1
fi

OUT_DIR=llvm-${LLVM_RELEASE}

gpg --import ../../gpg_keys/*.gpg

fetch_component () {
  COMPONENT=$1
  BASE_URL=http://releases.llvm.org/${LLVM_RELEASE}
  PKG=${COMPONENT}-${LLVM_RELEASE}.src.tar.xz
  SIG=${COMPONENT}-${LLVM_RELEASE}.src.tar.xz.sig

  if [ ! -e src/${COMPONENT} ]
  then
    wget ${BASE_URL}/${PKG}
    wget ${BASE_URL}/${SIG}
    gpg --verify ${SIG} ${PKG}
    tar xf ${PKG}
    mv ${COMPONENT}-${LLVM_RELEASE}.src src/${COMPONENT}
    rm -f ${PKG} ${SIG}
  fi
}

mkdir -p src
mkdir -p build
mkdir -p ${OUT_DIR}

fetch_component llvm
fetch_component compiler-rt
fetch_component cfe

pushd build

cmake ../src/llvm \
      -DCMAKE_BUILD_TYPE="Release" \
      -DLLVM_TARGETS_TO_BUILD="X86" \
      -DLLVM_BUILD_TOOLS=ON \
      -DBUILD_SHARED_LIBS=ON \
      -DLLVM_INCLUDE_EXAMPLES=OFF \
      -DLLVM_INCLUDE_TESTS=ON \
      -DCMAKE_INSTALL_PREFIX=../${OUT_DIR} \
      -DLLVM_EXTERNAL_CLANG_SOURCE_DIR=../src/cfe \
      -DLLVM_EXTERNAL_COMPILER_RT_SOURCE_DIR=../src/compiler-rt

# Use one third of available CPUs
make -j$(( ( $(nproc) + 2 ) / 3 ))
cmake --build . --target install

popd

tar cJf llvm.tar.xz ${OUT_DIR}
