#!/bin/bash
set -euo pipefail

: "${GITHUB_WORKSPACE:?GITHUB_WORKSPACE is required}"
BRANCH="${BRANCH:-}"
RELEASE="${RELEASE:-}"

# General patches
echo "Copying General patches..."
cp -f ${GITHUB_WORKSPACE}/patch/config/* config/kernel/
cp -f ${GITHUB_WORKSPACE}/patch/boards/* config/boards/
if [[ "${RELEASE}" =~ ^(bookworm|trixie)$ ]]; then
  rsync -a --quiet "${GITHUB_WORKSPACE}/patch/sbin/" packages/bsp/common/usr/sbin/
else
  rsync -a --quiet --exclude='install-pve' "${GITHUB_WORKSPACE}/patch/sbin/" packages/bsp/common/usr/sbin/
fi

# T4 Patches
echo "Copying T4 patches..."
cp -f ${GITHUB_WORKSPACE}/patch/T4/fix-CPU-information-6.16.patch patch/kernel/archive/rockchip64-6.18/
cp -f ${GITHUB_WORKSPACE}/patch/T4/fix-CPU-information-6.16.patch patch/kernel/archive/rockchip64-7.3/
cp -f ${GITHUB_WORKSPACE}/patch/T4/t4.patch patch/kernel/archive/rockchip64-6.18/
cp -f ${GITHUB_WORKSPACE}/patch/T4/t4.patch patch/kernel/archive/rockchip64-7.3/

# 5C Patches
echo "Copying 5C patches..."
cp -f ${GITHUB_WORKSPACE}/patch/5C/reopen_disabled_nodes.patch patch/u-boot/legacy/u-boot-radxa-rk35xx/board_rock-5c/
cp -f ${GITHUB_WORKSPACE}/patch/T4/fix-CPU-information.patch patch/kernel/rk35xx-vendor-6.1/
cp -f ${GITHUB_WORKSPACE}/patch/T4/fix-CPU-information.patch patch/kernel/rk35xx-vendor-6.12/
cp -f ${GITHUB_WORKSPACE}/patch/5C/diyfan-5c.patch patch/kernel/rk35xx-vendor-6.1/

# 5T Patches
echo "Copying 5T patches..."
cp -f ${GITHUB_WORKSPACE}/patch/5T/* patch/kernel/rk35xx-vendor-6.1/
sed -i 's|https://github.com/armbian/linux-rockchip.git|https://github.com/zane-e/linux-rockchip.git|g' config/sources/families/include/rockchip_vendor_common.inc

# N1 Patches
echo "Copying N1 patches..."
cp -f ${GITHUB_WORKSPACE}/patch/N1/fix-n1.patch patch/kernel/archive/meson64-6.18/
cp -f ${GITHUB_WORKSPACE}/patch/N1/fix-n1.patch patch/kernel/archive/meson64-7.3/
cp -f ${GITHUB_WORKSPACE}/patch/N1/u-boot.ext config/optional/boards/aml-s9xx-box/_packages/bsp-cli/boot/

# X2 Patches
echo "Copying X2 patches..."
rm -f config/boards/panther-x2.eos
cp -f ${GITHUB_WORKSPACE}/patch/X2/rk3566-panther-x2.dts patch/kernel/archive/rockchip64-6.18/dt/
cp -f ${GITHUB_WORKSPACE}/patch/X2/rk3566-panther-x2.dts patch/kernel/archive/rockchip64-7.3/dt/

# JP Patches
echo "Copying JP patches..."
cp -f ${GITHUB_WORKSPACE}/patch/JP/rk3566-jp-tvbox.dts patch/kernel/archive/rockchip64-6.18/dt/
cp -f ${GITHUB_WORKSPACE}/patch/JP/rk3566-jp-tvbox.dts patch/kernel/archive/rockchip64-7.3/dt/

# TVI3315A Patches
cp -f ${GITHUB_WORKSPACE}/patch/TVI/rk3399-tvi3315a.dts patch/kernel/archive/rockchip64-6.18/dt/
cp -f ${GITHUB_WORKSPACE}/patch/TVI/rk3399-tvi3315a.dts patch/kernel/archive/rockchip64-7.3/dt/

# Radxa-dragon-q8b
sed -i '32d' config/sources/families/sc8280xp.conf
rm -f patch/kernel/archive/sc8280xp-edge/0066-PCI-qcom-Only-check-bridge-nodes-for-PERST-GPIOs.patch
rm -f patch/kernel/archive/sc8280xp-edge/0070-soc-qcom-pmic_glink-Fix-device-access-from-worker-du.patch
rm -f patch/kernel/archive/sc8280xp-edge/0072-ASoC-qcom-q6apm-dai-wrap-the-position-of-a-full-ring.patch
rm -f patch/kernel/archive/sc8280xp-edge/0073-ASoC-qcom-q6apm-reset-the-hw-pointer-with-the-fragme.patch
rm -f patch/kernel/archive/sc8280xp-edge/0074-ASoC-qcom-q6apm-Fix-unmap-regions-response-handling.patch
rm -f patch/kernel/archive/sc8280xp-edge/0075-ASoC-qcom-q6apm-Clear-the-right-handle-on-pos-buffer.patch
rm -f patch/kernel/archive/sc8280xp-edge/0076-ASoC-qcom-q6apm-Unmap-DSP-buffers-before-removing-th.patch
rm -f patch/kernel/archive/sc8280xp-edge/0077-media-iris-avoid-bit-depth-validation-for-capture-fo.patch
rm -f patch/kernel/archive/sc8280xp-edge/0078-media-iris-Fix-power-off-ordering-to-disable-power-d.patch
rm -f patch/kernel/archive/sc8280xp-edge/0079-media-iris-Fix-frame-interval-enumeration-for-non-di.patch
rm -f patch/kernel/archive/sc8280xp-edge/0085-scsi-ufs-core-Fix-a-deadlock-between-clock-scaling-a.patch
rm -f patch/kernel/archive/sc8280xp-edge/0086-scsi-ufs-core-Remove-an-always-false-WARN_ONCE.patch
rm -f patch/kernel/archive/sc8280xp-edge/0087-scsi-ufs-core-Add-a-helper-for-clearing-hba-outstand.patch
rm -f patch/kernel/archive/sc8280xp-edge/0088-scsi-ufs-core-Fix-double-completion-in-ufshcd_clear_.patch
rm -f patch/kernel/archive/sc8280xp-edge/0089-scsi-ufs-core-Fix-double-release-in-ufshcd_eh_timed_.patch
rm -f patch/kernel/archive/sc8280xp-edge/0090-scsi-ufs-core-Remove-completed-without-interrupt-pat.patch
rm -f patch/kernel/archive/sc8280xp-edge/0091-scsi-ufs-core-Do-not-release-a-reserved-request-in-u.patch
rm -f patch/kernel/archive/sc8280xp-edge/0092-scsi-ufs-core-Clear-stale-UIC-result-byte-before-pee.patch
rm -f patch/kernel/archive/sc8280xp-edge/0093-drm-msm-Fix-vm_bo-use-after-free-in-with_vm_locks.patch
rm -f patch/kernel/archive/sc8280xp-edge/0094-misc-fastrpc-fix-double-free-in-fastrpc_map_attach-e.patch
rm -f patch/kernel/archive/sc8280xp-edge/0099-media-iris-reset-AHB-bridge-before-enabling-HW-mode.patch
rm -f patch/kernel/archive/sc8280xp-edge/0101-ASoC-qcom-audioreach-fix-module-cfg-blob-size-handli.patch

# Re-enable Meson for the new kernel
sed -i '28s/^/#/' config/sources/families/include/meson_common.inc
rm -f patch/kernel/archive/meson-6.12/0052-drm-meson-Describe-the-HDMI-PHY-frequency-limits-of-.patch

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

# Append TZ environment variable to Docker (e.g. Asia/Shanghai)
sed -i '/"--env" "TERM=\${TERM}"/a\		"--env" "TZ=${TZ:-Asia/Shanghai}"' lib/functions/host/docker.sh

# Remove Actions warnings
sed -i '252{/else/s/^/#/}' lib/functions/cli/utils-cli.sh
sed -i '253{/display_alert/s/^/#/}' lib/functions/cli/utils-cli.sh
sed -i '272{/display_alert/s/^/#/}' lib/functions/cli/utils-cli.sh
sed -i '384{/display_alert/s/^/#/}' lib/functions/main/config-prepare.sh
sed -i '58{/display_alert/s/^/#/}' lib/functions/general/git-oras-tree.sh
sed -i '/display_alert "ORAS manifest fetch error"/c\		:' lib/functions/general/oci-oras.sh
[ ! -d userpatches/extensions ] && mkdir -p userpatches/extensions

# Set custom version automatically based on date
# Format: YY.MM.1 (e.g. 25.11.1)
echo "$(date +%y).$(date +%m).1" > VERSION

echo "Patches applied successfully."
