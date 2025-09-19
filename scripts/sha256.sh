#!/bin/bash
set -euo pipefail

LINUXFAMILY="${LINUX_FAMILY}"
REPO="${GITHUB_REPOSITORY}"

extract_all_versions_with_sha() {
    awk '
        BEGIN { RS="<li"; ORS="\n" }
        {
            match($0, /kernel-[^"]+\.tar\.gz/, file)
            match($0, /sha256:([a-f0-9]{64})/, sha)
            if (length(file[0]) && length(sha[1])) {
                print file[0] " " sha[1]
            }
        }
    '
}

fetch_and_extract() {
    local url="https://github.com/${REPO}/releases/expanded_assets/Kernel-${LINUXFAMILY}"
    local html
    if ! html=$(curl -fsSL --retry 3 --retry-delay 1 --max-time 5 "$url"); then
        echo "❌ 无法访问 GitHub，请检查网络或代理设置！"
        exit 1
    fi
    echo "$html" | extract_all_versions_with_sha
}

echo "🔍 正在提取内核文件及 SHA256 信息"
if fetch_and_extract | sort -t '-' -k2V -u > sha256.txt; then
    echo "✅ 提取完成，已保存到 sha256.txt"
else
    echo "❌ 提取失败！"
fi
