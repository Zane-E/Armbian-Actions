# Allwinner Cortex-A55 octa core SoC 2/4GB-RAM, 2x GBe, WiFi/BT, M.2 2230/USB3, NPU
BOARD_NAME="Cubie A5E"
BOARD_VENDOR="radxa"
BOARDFAMILY="sun55iw3"
BOARD_MAINTAINER="juanesf"
INTRODUCED="2025"
BOOTCONFIG="radxa-cubie-a5e_defconfig"
OVERLAY_PREFIX="sun55i-a527"
#BOOT_LOGO="desktop"
KERNEL_TARGET="current,edge"
KERNEL_TEST_TARGET="current,edge"
BOOT_FDT_FILE="sun55i-a527-cubie-a5e.dtb"
HAS_VIDEO_OUTPUT="no" # quoted so the build-list inventory (it parses only quoted values) sees it

declare -g BOOTBRANCH="tag:v2026.01"
declare -g BOOTPATCHDIR="v2026.01"

PACKAGE_LIST_BOARD="rfkill bluetooth bluez bluez-tools"

# AIC8800
AIC8800_TYPE="sdio"
enable_extension "radxa-aic8800"

# AIC8800 Wireless
function post_family_tweaks_bsp__aic8800_wireless() {
	display_alert "$BOARD" "Installing AIC8800 Tweaks" "info"
	mkdir -p "${destination}"/etc/modprobe.d
	mkdir -p "${destination}"/etc/modules-load.d
	# Add wireless conf
	cat > "${destination}"/etc/modprobe.d/aic8800-radxa-cubie-a5e.conf <<- EOT
		options aic8800_fdrv_sdio aicwf_dbg_level=0 custregd=0 ps_on=0
		options aic8800_bsp aic_fw_path=/lib/firmware/aic8800/SDIO/aic8800D80
	EOT
	# Add needed bluetooth modules
	cat > "${destination}"/etc/modules-load.d/aic8800-btlpm.conf <<- EOT
		hidp
		rfcomm
		bnep
		aic8800_btlpm_sdio
	EOT
	# Add AIC8800 Bluetooth Service and Script
	if [[ -d "$SRC/packages/bsp/aic8800" ]]; then
		install -d -m 0755 "${destination}/usr/bin"
		install -m 0755 "$SRC/packages/bsp/aic8800/aic-bluetooth" "${destination}/usr/bin/aic-bluetooth"
		install -d -m 0755 "${destination}/usr/lib/systemd/system"
		install -m 0644 "$SRC/packages/bsp/aic8800/aic-bluetooth.service" "${destination}/usr/lib/systemd/system/aic-bluetooth.service"
	else
		display_alert "$BOARD" "Skipping AIC8800 BT assets (packages/bsp/aic8800 not found)" "warn"
	fi
}

# Enable AIC8800 Bluetooth Service
function post_family_tweaks__enable_aic8800_bluetooth_service() {
	display_alert "$BOARD" "Enabling AIC8800 Bluetooth Service" "info"
	if chroot_sdcard test -f /lib/systemd/system/aic-bluetooth.service || chroot_sdcard test -f /etc/systemd/system/aic-bluetooth.service; then
		chroot_sdcard systemctl --no-reload enable aic-bluetooth.service
	else
		display_alert "$BOARD" "aic-bluetooth.service not found in image; skipping enable" "warn"
	fi
}

# 自动在 armbianEnv.txt 中追加内置内核参数
function post_family_tweaks_bsp__add_extraargs() {
	display_alert "$BOARD" "Adding net.ifnames=0 to armbianEnv.txt" "info"
	
	# 确保 /boot 目录存在
	mkdir -p "${destination}"/boot
	
	# 检查文件中是否已有 extraargs，有则追加，没有则新建
	if grep -q "^extraargs=" "${destination}"/boot/armbianEnv.txt 2>/dev/null; then
		# 如果已有 extraargs，在末尾加空格并追加参数
		sed -i 's/^extraargs=\(.*\)/extraargs=\1 net.ifnames=0/' "${destination}"/boot/armbianEnv.txt
	else
		# 如果没有，直接写入新行
		echo "extraargs=net.ifnames=0" >> "${destination}"/boot/armbianEnv.txt
	fi
}
