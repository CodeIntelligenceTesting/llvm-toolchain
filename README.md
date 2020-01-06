# Building our LLVM Toolchain

In order to support as many different platforms as possible with our toolchain, we use a two-stage bootstrap build on CentOS 7.

We use the CentOS Docker builder provided in [build/docker/builders](../../build/docker/centos.Dockerfile).

Run the following command from this directory in order to build the toolchain.
This uses the GCC 7 software collection, because GCC 5 cannot build current LLVM.

```
docker run -e LLVM_RELEASE=9.0.1 -it \
           -mount type=bind,source=$(pwd),target=/llvmbuild \
           --workdir /llvmbuild \
           registry.gitlab.com/code-intelligence/core/builders/centos:latest \
           scl enable devtoolset-7 /llvmbuild/build_llvm.sh
```

Currently we are on Release 9.0.1 and apply a patch to enable [`-fsanitize-coverage-blacklist`](https://reviews.llvm.org/D63616#change-etRjnj8jVNTo) functionality.
