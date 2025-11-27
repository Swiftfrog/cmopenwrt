#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/10.9.0.1/g' package/base-files/files/bin/config_generate

#  modify NO.
# 23.05.2
#echo '47964456485559d992fe6f536131fc64' > vermagic
# 23.05.3
#echo 'e496746edd89318b9810e48e36a8bd9c' > vermagic
# 23.05.4
#echo '59d1431675acc6823a33c7eb2323daeb' > vermagic
# 23.05.5
#echo '59d1431675acc6823a33c7eb2323daeb' > vermagic
# 24.10.0
#echo 'a21259e4f338051d27a6443a3a7f7f1f' > vermagic
# 24.10.1
#echo 'af351158cfb5febf5155a3aa53785982' > vermagic
# 24.10.2
# echo '1745ebad77278f5cdc8330d17a3f43d6' > vermagic
# 24.10.3
# echo '3505295dd1edf1c0eda57c9ce372bf57' > vermagic
# 24.10.4
# echo '484466e2719a743506c36b4bb2103582' > vermagic

# # pass the modify NO.
# wget -O include/kernel-defaults.mk https://raw.githubusercontent.com/Swiftfrog/Build-Openwrt/main/Version/kernel-defaults.mk
# wget -O package/kernel/linux/Makefile https://raw.githubusercontent.com/Swiftfrog/Build-Openwrt/main/Version/Makefile
# #curl -s https://downloads.openwrt.org/releases/23.05.2/targets/x86/64/openwrt-23.05.2-x86-64.manifest | grep kernel | awk '{print $3}' | awk -F- '{print $3}' > vermagic

# === 1. 从 manifest 提取 vermagic ===
VERSION="24.10.4"
TARGET_BOARD="x86"
TARGET_SUBTARGET="64"
MANIFEST_URL="https://downloads.openwrt.org/releases/${VERSION}/targets/${TARGET_BOARD}/${TARGET_SUBTARGET}/openwrt-${VERSION}-${TARGET_BOARD}-${TARGET_SUBTARGET}.manifest"

VERMAGIC=$(curl -sf "$MANIFEST_URL" | grep 'kernel.*~.*-r' | sed -n 's/.*~\([0-9a-f]\{32\}\)-r.*/\1/p')
if [ -z "$VERMAGIC" ] || [ ${#VERMAGIC} -ne 32 ]; then
    echo "❌ Failed to extract vermagic"
    exit 1
fi

# === 2. 写入 vermagic 文件 ===
echo "$VERMAGIC" > vermagic

# === 3. 自动修订 kernel-defaults.mk ===
sed -i '/grep.*LC_ALL.*sort.*MKHASH.*md5/s/^/# /' include/kernel-defaults.mk
sed -i '/headers_install/a\\tcp $(TOPDIR)/vermagic $(LINUX_DIR)/.vermagic' include/kernel-defaults.mk

echo "✅ vermagic = $VERMAGIC"
echo "✅ kernel-defaults.mk patched"

# update golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang
