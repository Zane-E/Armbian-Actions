#!/bin/bash
set -euo pipefail

LINUXFAMILY="${LINUX_FAMILY}"
REPO="${GITHUB_REPOSITORY}"
TARGET_FILE="${TARGET_FILE:-}"
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
    if ! html=$(curl -fsSL --max-time 5 "${url}"); then
        return 1
    fi
    echo "${html}" | extract_all_versions_with_sha
}

echo "ℹ️ 开始提取 GitHub Release 内核文件 SHA256 信息"
[[ -n "${TARGET_FILE}" ]] && echo "ℹ️ 目标文件：${TARGET_FILE}"
for attempt in $(seq 1 "${MAX_RETRIES}"); do
    if fetch_and_extract | sort -t '-' -k2V -u > sha256.txt; then
        total=$(wc -l < sha256.txt | tr -d ' ')
        if [[ "${total}" -gt 0 ]]; then
            if [[ -z "${TARGET_FILE}" ]] || grep -Fq "${TARGET_FILE} " sha256.txt; then
                echo "✅ SHA256 信息已生成：sha256.txt，共 ${total} 条记录"
                exit 0
            fi

            echo "⚠️ 已获取 ${total} 条记录，但目标文件尚未同步：${TARGET_FILE}"
        fi
    fi

    if [[ "${attempt}" -lt "${MAX_RETRIES}" ]]; then
        echo "⚠️ 第 ${attempt}/${MAX_RETRIES} 次检查未获取到完整 SHA256 信息，${RETRY_DELAY}s 后重试"
        sleep "${RETRY_DELAY}"
    fi
done

echo "❌ 未能生成完整 SHA256 信息；目标文件可能尚未同步到 GitHub Release"
exit 1
