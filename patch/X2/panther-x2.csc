# Rockchip RK3566 quad core 4GB RAM SoC WIFI/BT eMMC USB2
BOARD_NAME="Panther X2"
BOARDFAMILY="rk35xx"
BOARD_MAINTAINER=""
BOOTCONFIG="rock-3c-rk3566_defconfig"
KERNEL_TARGET="vendor,current,edge"
KERNEL_TEST_TARGET="current"
FULL_DESKTOP="yes"
BOOT_LOGO="desktop"
BOOT_FDT_FILE="rockchip/rk3566-panther-x2.dtb"
IMAGE_PARTITION_TABLE="gpt"
BOOT_SCENARIO="spl-blobs"
BOOTFS_TYPE="fat"

function post_family_tweaks__panther-x2_naming_lan() {
	display_alert "$BOARD" "Renaming panther-x2 lan" "info"

	mkdir -p "${SDCARD}"/etc/udev/rules.d/
	echo 'SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", KERNEL=="end*", NAME="eth0"' > $SDCARD/etc/udev/rules.d/97-rename-lan.rules

	return 0
}
