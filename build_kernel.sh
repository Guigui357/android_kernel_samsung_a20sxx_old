#!/bin/bash
set -e

mkdir -p out
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

# Defconfig
make -C $(pwd) O=$(pwd)/out KCFLAGS=-mno-android a20s_eur_open_defconfig

# Desativa Stack Protector no config correto
scripts/config -C out --disable CC_STACKPROTECTOR_STRONG
scripts/config -C out --disable CC_STACKPROTECTOR
scripts/config -C out --disable CC_STACKPROTECTOR_REGULAR
make O=out olddefconfig

# Compilação
make -C $(pwd) O=$(pwd)/out KCFLAGS=-mno-android DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y -j4

# Copia o Image
cp out/arch/arm64/boot/Image $(pwd)/arch/arm64/boot/Image
