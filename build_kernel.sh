#!/bin/bash
# Build kernel Samsung A20s no Ubuntu
# Gera: out/arch/arm64/boot/Image

set -e

# Cria pasta de saída
OUT_DIR=$(pwd)/out
mkdir -p "$OUT_DIR"



# Variáveis de compilação
export PATH="$(pwd)/aarch64-linux-android-4.9-toolchain/bin:$PATH"
export CROSS_COMPILE=aarch64-linux-android-
export ARCH=arm64
export KCFLAGS=-mno-android

# Defconfig do dispositivo
DEFCONFIG=a20s_eur_open_defconfig

echo "=== Configurando kernel ==="
make -C $(pwd) O="$OUT_DIR" "$DEFCONFIG"

echo "=== Compilando kernel ==="
make -C $(pwd) O="$OUT_DIR" -j$(nproc) \
    KCFLAGS="$KCFLAGS" CONFIG_BUILD_ARM64_DT_OVERLAY=y

# Copia o kernel final para raiz do repo
cp "$OUT_DIR/arch/arm64/boot/Image" "$(pwd)/arch/arm64/boot/Image"

echo "=== Build concluído com sucesso! Kernel pronto em arch/arm64/boot/Image ==="
