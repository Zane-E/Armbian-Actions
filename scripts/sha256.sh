#!/bin/bash
set -euo pipefail

LINUXFAMILY="${LINUX_FAMILY}"
REPO="${GITHUB_REPOSITORY}"
TARGET_FILE="${TARGET_FILE:-}"
MAX_RETRIES="${SHA256_MAX_RETRIES:-3}"
RETRY_DELAY="${SHA256_RETRY_DELAY:-5}"
TARGET_SHA256=""

extract_all_versions_with_sha() {
    awk '
        BEGIN { RS="<li"; ORS="\n" }
        {
            file = ""
            sha = ""
            if (match($0, /kernel-[0-9]+\.[0-9]+\.[0-9]+-[^"]+\.tar\.gz/)) {
                file = substr($0, RSTART, RLENGTH)
            }
            if (match($0, /sha256:[a-f0-9]{64}/)) {
                sha = substr($0, RSTART + 7, 64)
            }
            if (length(file) && length(sha)) {
                print file " " sha
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

get_target_sha256_from_file() {
    awk -v target="${TARGET_FILE}" '
        $1 == target {
            print $2
            found = 1
            exit
        }
        END {
            if (!found) {
                exit 1
            }
        }
    ' sha256.txt
}

echo "ℹ️ 开始提取 GitHub Release 内核文件 SHA256 信息"
if [[ -n "${TARGET_FILE}" ]]; then
    echo "ℹ️ 目标文件：${TARGET_FILE}"
    if [[ ! -f "${TARGET_FILE}" ]]; then
        echo "❌ 目标文件不存在：${TARGET_FILE}"
        exit 1
    fi
    TARGET_SHA256="$(sha256sum "${TARGET_FILE}" | awk '{print $1}')"
    echo "ℹ️ 本地文件 SHA256：${TARGET_SHA256}"
fi

for attempt in $(seq 1 "${MAX_RETRIES}"); do
    if fetch_and_extract | sort -t '-' -k2V -u > sha256.txt; then
        total=$(wc -l < sha256.txt | tr -d ' ')
        if [[ "${total}" -gt 0 ]]; then
            if [[ -z "${TARGET_FILE}" ]]; then
                echo "✅ SHA256 信息已生成：sha256.txt，共 ${total} 条记录"
                exit 0
            fi

            if release_sha256=$(get_target_sha256_from_file); then
                if [[ "${release_sha256}" == "${TARGET_SHA256}" ]]; then
                    echo "✅ SHA256 信息已生成并通过校验：sha256.txt，共 ${total} 条记录"
                    exit 0
                fi

                echo "⚠️ 目标文件 SHA256 不一致，Release 页面可能尚未同步"
                echo "ℹ️ Release 页面 SHA256：${release_sha256}"
                echo "ℹ️ 本地文件 SHA256：${TARGET_SHA256}"
            else
                echo "⚠️ 已获取 ${total} 条记录，但目标文件尚未同步：${TARGET_FILE}"
            fi
        fi
    fi

    if [[ "${attempt}" -lt "${MAX_RETRIES}" ]]; then
        echo "⚠️ 第 ${attempt}/${MAX_RETRIES} 次检查未获取到完整 SHA256 信息，${RETRY_DELAY}s 后重试"
        sleep "${RETRY_DELAY}"
    fi
done

if [[ -n "${TARGET_FILE}" ]]; then
    echo "❌ 未能生成与本地目标文件一致的 SHA256 信息；目标文件可能尚未同步到 GitHub Release"
else
    echo "❌ 未能生成完整 SHA256 信息；GitHub Release 页面可能尚未同步"
fi
exit 1
