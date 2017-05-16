FROM ubuntu:trusty

ARGS CROSS "aarch64-linux-gnu"
ARGS ARCH "arm64"

# Add cross-compile libraries

RUN dpkg --add-architecture ${ARCH}

RUN echo "deb [arch=armhf,arm64,powerpc] http://ports.ubuntu.com/ubuntu-ports trusty main universe" \
    >> /etc/apt/sources.list

# Install base compilers and tools

RUN apt-get -q update && apt-get -qy install \
    cmake ninja-build git \
    g++-${CROSS} \
    gcc-${CROSS} &&
    apt-get -qy build-dep

