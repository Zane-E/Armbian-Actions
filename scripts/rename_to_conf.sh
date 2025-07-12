#!/bin/bash

# 设置目标目录
TARGET_DIR="config/boards"

# 判断目录是否存在
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ 目录不存在：$TARGET_DIR"
    exit 1
fi

# 查找并重命名 .tvb 和 .csc 文件为 .conf
find "$TARGET_DIR" -type f \( -name "*.tvb" -o -name "*.csc" \) | while read -r file; do
    new_file="${file%.*}.conf"
    if [ -e "$new_file" ]; then
        echo "⚠️ 已存在目标文件，跳过：$new_file"
    else
        mv "$file" "$new_file"
        echo "✅ 重命名：$file → $new_file"
    fi
done