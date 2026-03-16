#!/bin/bash

mkdir out

export ARCH=arm64

export CROSS_COMPILE=aarch64-linux-gnu-

make -C $(pwd) O=$(pwd)/out KCFLAGS=-mno-android a20s_eur_open_defconfig
scripts/config --disable CC_STACKPROTECTOR_STRONG
scripts/config --disable CC_STACKPROTECTOR
scripts/config --disable CC_STACKPROTECTOR_REGULAR
make olddefconfig
make -j16 -C $(pwd) O=$(pwd)/out KCFLAGS=-mno-android DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y
 
cp out/arch/arm64/boot/Image $(pwd)/arch/arm64/boot/Image
