# Building our LLVM Toolchain

In order to support as many different platforms as possible with our toolchain, we use a two-stage bootstrap build on CentOS 7.

We use the LLVM Docker builder provided in [build/docker/builders](../../build/docker/builders/llvm.Dockerfile).

Run the following command from this directory in order to build the toolchain.
This uses the GCC 7 software collection, because GCC 5 cannot build current LLVM.

```
docker run -e LLVM_RELEASE=10.0.0 -it \
           --mount type=bind,source=$(pwd),target=/llvmbuild \
           --workdir /llvmbuild \
           registry.gitlab.com/code-intelligence/core/builders/llvm:latest \
           scl enable devtoolset-7 /llvmbuild/build_llvm.sh
```

Currently we are on Release 10.0.0 and apply a patch to enable [`-fsanitize-coverage-blacklist`](https://reviews.llvm.org/D63616#change-etRjnj8jVNTo) functionality. The patch is in master already, so there is hope for Release 11.
