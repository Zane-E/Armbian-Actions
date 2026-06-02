#!/bin/bash
set -euo pipefail

LINUXFAMILY="${LINUX_FAMILY}"
REPO="${GITHUB_REPOSITORY}"
MAX_RETRIES="${SHA256_MAX_RETRIES:-3}"
RETRY_DELAY="${SHA256_RETRY_DELAY:-5}"

extract_all_versions_with_sha() {
    awk '
        BEGIN { RS="<li"; ORS="\n" }
        {
            match($0, /kernel-[0-9]+\.[0-9]+\.[0-9]+-[^"]+\.tar\.gz/, file)
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
    if ! html=$(curl -fsSL --retry 3 --retry-delay 1 --max-time 5 "${url}"); then
        return 1
    fi
    echo "${html}" | extract_all_versions_with_sha
}

echo "🔍 正在提取内核文件 SHA256 信息"
for attempt in $(seq 1 "${MAX_RETRIES}"); do
    if fetch_and_extract | sort -t '-' -k2V -u > sha256.txt; then
        total=$(wc -l < sha256.txt | tr -d ' ')
        if [[ "${total}" -gt 0 ]]; then
            echo "✅ 提取完成，共找到 ${total} 个内核文件，已保存到 sha256.txt"
            exit 0
        fi
    fi

    if [[ "${attempt}" -lt "${MAX_RETRIES}" ]]; then
        echo "⚠️ 第 ${attempt}/${MAX_RETRIES} 次未获取到 SHA256 信息，${RETRY_DELAY}s 后重试..."
        sleep "${RETRY_DELAY}"
    fi
done

echo "❌ 提取失败，未找到匹配的内核文件或无法访问 GitHub Release！"
exit 1
