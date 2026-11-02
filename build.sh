#!/bin/bash
set -e

echo "=== 1. Клонирование исходников ядра ==="
git clone -b lineage-22.2 https://github.com/LineageOS/android_kernel_xiaomi_sm6250.git kernel
cd kernel

echo "=== 2. Интеграция SukiSU Ultra (nongki) ==="
curl -LSs "https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh" | bash -s nongki

echo "=== 3. Настройка конфигурации (Manual Hook) ==="
DEFCONFIG="arch/arm64/configs/vendor/miatoll_defconfig"
echo "CONFIG_KSU_MANUAL_HOOK=y" >> $DEFCONFIG
echo "CONFIG_KALLSYMS=y" >> $DEFCONFIG
echo "CONFIG_KALLSYMS_ALL=y" >> $DEFCONFIG
echo "CONFIG_KPROBES=y" >> $DEFCONFIG

echo "=== 4. Сборка ядра ==="
make ARCH=arm64 O=out vendor/miatoll_defconfig
make ARCH=arm64 O=out -j$(nproc)

echo "=== 5. Готово! ==="
ls -la out/arch/arm64/boot/