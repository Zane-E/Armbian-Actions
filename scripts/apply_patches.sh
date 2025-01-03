#!/bin/bash

# Copying the patch files
echo "Copying patches..."

# General patches
cp -f $GITHUB_WORKSPACE/patch/fixdeb/* lib/functions/compilation/
cp -f $GITHUB_WORKSPACE/patch/fiximg/* lib/functions/configuration/
cp -f $GITHUB_WORKSPACE/patch/config/* config/kernel/
cp -f $GITHUB_WORKSPACE/patch/sbin/* packages/bsp/common/usr/sbin/
cp -f $GITHUB_WORKSPACE/patch/artifact/* lib/functions/artifacts/
cp -f $GITHUB_WORKSPACE/patch/VERSION ./

# T4 Patches
echo "Applying T4 patches..."
cp -f $GITHUB_WORKSPACE/patch/T4/fix-CPU-information.patch patch/kernel/archive/rockchip64-6.13/
cp -f $GITHUB_WORKSPACE/patch/T4/fix-CPU-information.patch patch/kernel/archive/rockchip64-6.12/
cp -f $GITHUB_WORKSPACE/patch/T4/fix-CPU-information.patch patch/kernel/archive/rockchip64-6.6/
cp -f $GITHUB_WORKSPACE/patch/T4/t4-6.13.patch patch/kernel/archive/rockchip64-6.13/
cp -f $GITHUB_WORKSPACE/patch/T4/t4-6.12.patch patch/kernel/archive/rockchip64-6.12/
cp -f $GITHUB_WORKSPACE/patch/T4/t4-6.6.patch patch/kernel/archive/rockchip64-6.6/
cp -f $GITHUB_WORKSPACE/patch/T4/rockchip64_common.inc config/sources/families/include/
cp -f $GITHUB_WORKSPACE/patch/T4/mainline-kernel.conf.sh config/sources/
cp -f $GITHUB_WORKSPACE/patch/T4/nanopct4.csc config/boards/

# 5C Patches
echo "Applying 5C patches..."
cp -f $GITHUB_WORKSPACE/patch/5C/rock-5c.conf config/boards/
cp -f $GITHUB_WORKSPACE/patch/5C/reopen_disabled_nodes.patch patch/u-boot/legacy/u-boot-radxa-rk35xx/board_rock-5c/
cp -f $GITHUB_WORKSPACE/patch/5C/fix-CPU-information.patch patch/kernel/rk35xx-vendor-6.1/
cp -f $GITHUB_WORKSPACE/patch/5C/diyfan.patch patch/kernel/rk35xx-vendor-6.1/

# N1 Patches
echo "Applying N1 patches..."
cp -f $GITHUB_WORKSPACE/patch/N1/* patch/kernel/archive/meson64-6.6/
cp -f $GITHUB_WORKSPACE/patch/N1/* patch/kernel/archive/meson64-6.12/

echo "Patches applied successfully."
