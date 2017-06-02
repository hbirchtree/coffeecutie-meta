#!/bin/bash

CROSS="$1"
SRC_DIR="$2"

export CC=${CROSS}-gcc
export CXX=${CROSS}-g++
export AS=${CROSS}-as
export LD=${CROSS}-ld

${SRC_DIR}/configure \
	--host ${CROSS} \
	--disable-shared \
        --disable-atomic \
        --disable-filesystem \
        --disable-threads \
        --disable-timers \
        --disable-audio \
        --disable-loadso \
        --disable-cpuinfo \
	--prefix=$(pwd)/out

make -j$(nproc)
