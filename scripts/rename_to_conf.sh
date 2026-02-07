#!/bin/bash

TARGET_DIR="config/boards"
count=0

if [ ! -d "${TARGET_DIR}" ]; then
    echo "❌ 目录不存在：${TARGET_DIR}"
    exit 1
fi

while read -r file; do
    new_file="${file%.*}.conf"
    if [ -e "${new_file}" ]; then
        echo "⚠️ 已存在目标文件，跳过：${new_file}"
    else
        mv "${file}" "${new_file}"
        echo "✅ 重命名：${file} → ${new_file}"
        ((count++))
    fi
done < <(find "${TARGET_DIR}" -type f \( -name "*.tvb" -o -name "*.csc" \))

echo "📊 共重命名 ${count} 个文件！"
