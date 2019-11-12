# This file sets up a CMakeCache for the second stage of a simple distribution
# bootstrap build.

set(LLVM_ENABLE_PROJECTS "clang;clang-tools-extra;lld;libcxx;libcxxabi;compiler-rt;libunwind" CACHE STRING "")
# set(LLVM_ENABLE_RUNTIMES "compiler-rt;libcxx;libcxxabi" CACHE STRING "")

set(LLVM_TARGETS_TO_BUILD X86;ARM;AArch64 CACHE STRING "")

set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O3 -gline-tables-only -DNDEBUG" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -gline-tables-only -DNDEBUG" CACHE STRING "")

set(CMAKE_CXX_FLAGS "-stdlib=libc++ -pthread" CACHE STRING "")
set(CMAKE_SHARED_LINKER_FLAGS "-lc++ -lc++abi" CACHE STRING "")
set(CMAKE_MODULE_LINKER_FLAGS "-lc++ -lc++abi" CACHE STRING "")
set(CMAKE_EXE_LINKER_FLAGS "-lc++ -lc++abi" CACHE STRING "")

set(LIBCXX_INSTALL_LIBRARY ON CACHE BOOL "")
set(LIBCXX_INSTALL_HEADERS ON CACHE BOOL "")
set(LIBCXX_INCLUDE_TESTS OFF CACHE BOOL "")

set(LLVM_PARALLEL_LINK_JOBS "1" CACHE STRING "")

set(CMAKE_INSTALL_PREFIX "" CACHE STRING "")

# setup toolchain
set(LLVM_INSTALL_TOOLCHAIN_ONLY ON CACHE BOOL "")
set(LLVM_TOOLCHAIN_TOOLS
  dsymutil
  llvm-cov
  llvm-dwarfdump
  llvm-profdata
  llvm-objdump
  llvm-nm
  llvm-size
  CACHE STRING "")

set(LLVM_DISTRIBUTION_COMPONENTS
  clang
  LTO
  clang-format
  clang-resource-headers
  builtins
  # runtimes
  ${LLVM_TOOLCHAIN_TOOLS}
  CACHE STRING "")

