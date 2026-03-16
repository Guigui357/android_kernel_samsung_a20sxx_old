#!/bin/bash
# Build kernel Samsung A20s no Ubuntu
# Gera: out/arch/arm64/boot/Image

set -e

# Cria pasta de saída
OUT_DIR=$(pwd)/out
mkdir -p "$OUT_DIR"

# Variáveis de compilação
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export KCFLAGS=-mno-android

# Defconfig do dispositivo
DEFCONFIG=a20s_eur_open_defconfig

echo "=== Configurando kernel ==="
make -C $(pwd) O="$OUT_DIR" "$DEFCONFIG"

# Desativa stack protector que dá erro
scripts/config --disable CC_STACKPROTECTOR_STRONG
scripts/config --disable CC_STACKPROTECTOR
scripts/config --disable CC_STACKPROTECTOR_REGULAR

# Atualiza o .config depois de mudar opções
make -C $(pwd) O="$OUT_DIR" olddefconfig

echo "=== Compilando kernel ==="
make -C $(pwd) O="$OUT_DIR" -j$(nproc) \
    KCFLAGS="$KCFLAGS" CONFIG_BUILD_ARM64_DT_OVERLAY=y

# Copia o kernel final para raiz do repo
cp "$OUT_DIR/arch/arm64/boot/Image" "$(pwd)/arch/arm64/boot/Image"

echo "=== Build concluído com sucesso! Kernel pronto em arch/arm64/boot/Image ==="
