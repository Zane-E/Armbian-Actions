#!/bin/bash

# General patches
echo "Copying General patches..."
cp -f ${GITHUB_WORKSPACE}/patch/config/* config/kernel/
cp -f ${GITHUB_WORKSPACE}/patch/boards/* config/boards/
# cp -f ${GITHUB_WORKSPACE}/patch/sbin/* packages/bsp/common/usr/sbin/
if [[ "${RELEASE}" == "bookworm" ]]; then
  echo "执行完整复制（包含 install-pve）"
  rsync -av "${GITHUB_WORKSPACE}/patch/sbin/" packages/bsp/common/usr/sbin/
else
  echo "排除 install-pve 进行复制"
  rsync -av --exclude='install-pve' "${GITHUB_WORKSPACE}/patch/sbin/" packages/bsp/common/usr/sbin/
fi

# T4 Patches
echo "Copying T4 patches..."
cp -f ${GITHUB_WORKSPACE}/patch/test/meson64/general-fix-Kodi-sysinfo-CPU-information.patch patch/kernel/archive/rockchip64-6.16/
cp -f ${GITHUB_WORKSPACE}/patch/T4/fix-CPU-information.patch patch/kernel/archive/rockchip64-6.12/
cp -f ${GITHUB_WORKSPACE}/patch/T4/t4.patch patch/kernel/archive/rockchip64-6.16/
cp -f ${GITHUB_WORKSPACE}/patch/T4/t4.patch patch/kernel/archive/rockchip64-6.12/

# 5C Patches
echo "Copying 5C patches..."
cp -f ${GITHUB_WORKSPACE}/patch/5C/reopen_disabled_nodes.patch patch/u-boot/legacy/u-boot-radxa-rk35xx/board_rock-5c/
cp -f ${GITHUB_WORKSPACE}/patch/5C/fix-CPU-information.patch patch/kernel/rk35xx-vendor-6.1/
cp -f ${GITHUB_WORKSPACE}/patch/5C/diyfan.patch patch/kernel/rk35xx-vendor-6.1/

# N1 Patches
echo "Copying N1 patches..."
cp -f ${GITHUB_WORKSPACE}/patch/N1/fix-n1-1.patch patch/kernel/archive/meson64-6.12/
cp -f ${GITHUB_WORKSPACE}/patch/N1/fix-n1-2.patch patch/kernel/archive/meson64-6.12/
cp -f ${GITHUB_WORKSPACE}/patch/N1/fix-n1-1.patch patch/kernel/archive/meson64-6.15/
cp -f ${GITHUB_WORKSPACE}/patch/N1/fix-n1-2.patch patch/kernel/archive/meson64-6.15/
cp -f ${GITHUB_WORKSPACE}/patch/N1/u-boot.ext config/optional/boards/aml-s9xx-box/_packages/bsp-cli/boot/

# X2 Patches
echo "Copying X2 patches..."
cp -f ${GITHUB_WORKSPACE}/patch/X2/rk3566-panther-x2.dts patch/kernel/archive/rockchip64-6.12/dt/
cp -f ${GITHUB_WORKSPACE}/patch/X2/rk3566-panther-x2.dts patch/kernel/archive/rockchip64-6.16/dt/
cp -r ${GITHUB_WORKSPACE}/patch/X2/dt patch/kernel/rk35xx-vendor-6.1/

# JP Patches
echo "Copying JP patches..."
cp -f ${GITHUB_WORKSPACE}/patch/JP/rk3566-jp-tvbox.dts patch/kernel/archive/rockchip64-6.12/dt/
cp -f ${GITHUB_WORKSPACE}/patch/JP/rk3566-jp-tvbox.dts patch/kernel/archive/rockchip64-6.16/dt/
cp -f ${GITHUB_WORKSPACE}/patch/JP/dt/rk3566-jp-tvbox.dts patch/kernel/rk35xx-vendor-6.1/dt/

# Remove '-unofficial' from the VENDOR name
sed -i 's|Armbian-unofficial|Armbian|g' lib/functions/configuration/main-config.sh

# Remove the suffix information from 'uname -r' in LOCALVERSION
sed -i 's|LOCALVERSION=-${BRANCH}-${LINUXFAMILY}|LOCALVERSION=|g' lib/functions/compilation/kernel-make.sh
sed -i 's|${kernel_version}-${BRANCH}-${LINUXFAMILY}|${kernel_version}|g' lib/functions/compilation/kernel-debs.sh

# Remove branch information from linux debs packages name in kernel-debs.sh
sed -i 's|linux-image-${BRANCH}-${LINUXFAMILY}|linux-image-${LINUXFAMILY}|g' lib/functions/compilation/kernel-debs.sh
sed -i 's|linux-dtb-${BRANCH}-${LINUXFAMILY}|linux-dtb-${LINUXFAMILY}|g' lib/functions/compilation/kernel-debs.sh
sed -i 's|linux-headers-${BRANCH}-${LINUXFAMILY}|linux-headers-${LINUXFAMILY}|g' lib/functions/compilation/kernel-debs.sh
sed -i 's|linux-libc-dev-${BRANCH}-${LINUXFAMILY}|linux-libc-dev-${LINUXFAMILY}|g' lib/functions/compilation/kernel-debs.sh

# Remove branch information from linux debs packages name in artifact-kernel.sh
sed -i 's|linux-image-${BRANCH}-${LINUXFAMILY}|linux-image-${LINUXFAMILY}|g' lib/functions/artifacts/artifact-kernel.sh
sed -i 's|linux-dtb-${BRANCH}-${LINUXFAMILY}|linux-dtb-${LINUXFAMILY}|g' lib/functions/artifacts/artifact-kernel.sh
sed -i 's|linux-headers-${BRANCH}-${LINUXFAMILY}|linux-headers-${LINUXFAMILY}|g' lib/functions/artifacts/artifact-kernel.sh
sed -i 's|linux-libc-dev-${BRANCH}-${LINUXFAMILY}|linux-libc-dev-${LINUXFAMILY}|g' lib/functions/artifacts/artifact-kernel.sh

# Change IMAGE_TYPE from user-built to stable
sed -i 's|IMAGE_TYPE=user-built|IMAGE_TYPE=stable|g' lib/functions/main/config-prepare.sh

# Change the maximum frequency of RK3566 from 1800000 to 1992000
sed -i 's|1800000|1992000|g' config/sources/families/include/rockchip64_common.inc

# Remove Actions warnings
sed -i '252{/else/s/^/#/}' lib/functions/cli/utils-cli.sh
sed -i '253{/display_alert/s/^/#/}' lib/functions/cli/utils-cli.sh
sed -i '272{/display_alert/s/^/#/}' lib/functions/cli/utils-cli.sh
sed -i '398{/display_alert/s/^/#/}' lib/functions/main/config-prepare.sh
sed -i '53{/display_alert/s/^/#/}' config/sources/families/include/meson64_common.inc

# Set custom version
echo "25.8.1" > VERSION

echo "Patches applied successfully."
