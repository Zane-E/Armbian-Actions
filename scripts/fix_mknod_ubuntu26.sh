#!/bin/bash

# 修复 Armbian 构建中的 mknod 命令以兼容 Ubuntu 26.04
# 同时保持对 Ubuntu 22.04/24.04 的兼容性

LOOP_SH="lib/functions/image/loop.sh"

if [ ! -f "$LOOP_SH" ]; then
    echo "Error: $LOOP_SH not found"
    exit 1
fi

echo "Patching $LOOP_SH for Ubuntu 22.04/24.04/26.04 compatibility..."

# 替换 mknod 命令
python3 << 'PYTHON_SCRIPT'
import re

with open('lib/functions/image/loop.sh', 'r') as f:
    content = f.read()

# 找到并替换 mknod 命令
pattern = r'run_host_command_logged mknod -m0660 "\$\{device\}" b "0x\$\(stat -c \'%t\' "/tmp/\$\{device\}"\)" "0x\$\(stat -c \'%T\' "/tmp/\$\{device\}"\)"'

replacement = '''# Ubuntu 22.04/24.04//26.04 兼容的 mknod 命令
    local major_hex=$(stat -c '%t' "/tmp/${device}")
    local minor_hex=$(stat -c '%T' "/tmp/${device}")
    local major_dec=$((16#$major_hex))
    local minor_dec=$((16#$minor_hex))
    run_host_command_logged mknod -m0660 "${device}" b "$major_dec" "$minor_dec"'''

content = re.sub(pattern, replacement, content)

with open('lib/functions/image/loop.sh', 'w') as f:
    f.write(content)

print("Patch applied successfully")
PYTHON_SCRIPT

echo "Done!"
