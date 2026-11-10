#!/bin/bash
set -e

# ========= 字体颜色 =========
STEPS="[\033[95m 步骤 \033[0m]"
INFO="[\033[94m 信息 \033[0m]"
SUCCESS="[\033[92m 成功 \033[0m]"
ERROR="[\033[91m 错误 \033[0m]"

# ========= 创建临时目录并清理 =========
TMPDIR="$(mktemp -d)"
cleanup() {
  rm -rf "${TMPDIR}"
}
trap cleanup EXIT
cd "${TMPDIR}"

# ========= 标题 =========
echo -e "${INFO} Armbian (ARM64) 安装 Pxvirt (Proxmox VE)"
echo -e "${INFO} 临时目录 [\033[92m ${TMPDIR} \033[0m]"

# ========= 下载文件 =========
echo -e "${STEPS} 正在下载 [\033[92m install-pve \033[0m] [\033[92m armbian-apt \033[0m]"
timeout 10 wget --tries=3 --timeout=3 -q https://raw.githubusercontent.com/Zane-E/Armbian-Actions/main/patch/sbin/install-pve -O install-pve || {
  echo -e "${ERROR} 无法下载 [\033[92m install-pve \033[0m] 请检查网络！"
  exit 1
}

timeout 10 wget --tries=3 --timeout=3 -q https://raw.githubusercontent.com/Zane-E/Armbian-Actions/main/patch/sbin/armbian-apt -O armbian-apt || {
  echo -e "${ERROR} 无法下载 [\033[92m armbian-apt \033[0m] 请检查网络！"
  exit 1
}

chmod +x install-pve armbian-apt

# ========= 执行主安装 =========
echo -e "${STEPS} 执行命令 [\033[92m install-pve \033[0m]"
exec ./install-pve
