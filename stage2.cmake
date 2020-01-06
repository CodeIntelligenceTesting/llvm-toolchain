# This file sets up a CMakeCache for the second stage of a simple distribution
# bootstrap build.

set(LLVM_ENABLE_PROJECTS "clang;clang-tools-extra;lld;libcxx;libcxxabi;compiler-rt;libunwind" CACHE STRING "")
# set(LLVM_ENABLE_RUNTIMES "compiler-rt;libcxx;libcxxabi" CACHE STRING "")

set(LLVM_TARGETS_TO_BUILD X86;ARM;AArch64 CACHE STRING "")

set(CMAKE_BUILD_TYPE Release CACHE STRING "")

set(CMAKE_CXX_FLAGS "-stdlib=libc++ -pthread" CACHE STRING "")
set(CMAKE_SHARED_LINKER_FLAGS "-lc++ -lc++abi" CACHE STRING "")
set(CMAKE_MODULE_LINKER_FLAGS "-lc++ -lc++abi" CACHE STRING "")
set(CMAKE_EXE_LINKER_FLAGS "-lc++ -lc++abi" CACHE STRING "")

set(LIBCXX_INSTALL_LIBRARY ON CACHE BOOL "")
set(LIBCXX_INSTALL_HEADERS ON CACHE BOOL "")
set(LIBCXX_INCLUDE_TESTS OFF CACHE BOOL "")

set(SANITIZER_CXX_ABI "libc++" CACHE STRING "")
set(SANITIZER_TEST_CXX "libc++" CACHE STRING "")

set(LLVM_PARALLEL_LINK_JOBS "1" CACHE STRING "")

set(CMAKE_INSTALL_PREFIX "" CACHE STRING "")

set(PACKAGE_VENDOR "Code Intelligence GmbH" CACHE STRING "")

set(LLVM_BUILD_LLVM_DYLIB ON CACHE BOOL "")

# setup toolchain
set(LLVM_INSTALL_TOOLCHAIN_ONLY ON CACHE BOOL "")
set(LLVM_TOOLCHAIN_TOOLS
  dsymutil
  llvm-ar
  llvm-as
  llvm-cov
  llvm-config
  llvm-dwarfdump
  llvm-profdata
  llvm-objdump
  llvm-objcopy
  llvm-nm
  llvm-size
  llvm-strip
  llvm-dwp
  CACHE STRING "")

set(LLVM_DISTRIBUTION_COMPONENTS
  clang
  clang-libraries
  LTO
  clang-format
  clang-resource-headers
  builtins
  # runtimes
  ${LLVM_TOOLCHAIN_TOOLS}
  CACHE STRING "")

