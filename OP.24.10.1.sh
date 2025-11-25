#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Modify BCM57810
# 23.05
#wget -O target/linux/x86/patches-5.15/600-bnx2x-warpcore-8727-2g5.patch https://raw.githubusercontent.com/Swiftfrog/Build-Openwrt/main/2.5G/bnx2x_warpcore_8727_2_5g_sgmii_txfault.patch
# 24.10
wget -O target/linux/x86/patches-6.6/600-bnx2x-warpcore-8727-2g5.patch https://raw.githubusercontent.com/Swiftfrog/Build-Openwrt/main/2.5G/bnx2x_warpcore_8727_2_5g_sgmii_txfault.patch
# master
#wget -O target/linux/x86/patches-6.6/600-bnx2x-warpcore-8727-2g5.patch https://raw.githubusercontent.com/JAMESMTL/snippets/master/bnx2x/patches/bnx2x_warpcore_8727_2_5g_sgmii_txfault.patch

# 添加argon主题
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon

# 添加edge主题
# git clone https://github.com/kiddin9/luci-theme-edge.git package/luci-theme-edge

# 添加passwall
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git package/passwall-packages
#git clone https://github.com/xiaorouji/openwrt-passwall.git package/passwall
git clone https://github.com/xiaorouji/openwrt-passwall2.git package/passwall2

# 添加mosdns
rm -rf feeds/packages/net/v2ray-geodata
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
