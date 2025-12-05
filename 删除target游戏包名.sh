#!/bin/bash

# 定义目标文件路径
TARGET_FILE="/data/adb/tricky_store/target.txt"

# 定义需要删除的包名列表（后续添加直接在这里加元素即可）
PACKAGES=(
    "com.tencent.tmgp.pubgmhd"
    "com.tencent.tmgp.sgame"
    "com.lilithgames.solarland.android.cn"
    #"com.tencent.tmgp.dfm"
    # 这里可以继续添加新的包名，例如：
    # "com.example.newpackage"
)

# 检查文件是否存在
if [ ! -f "$TARGET_FILE" ]; then
    echo "错误：目标文件 $TARGET_FILE 不存在"
    exit 1
fi

# 处理包名中的点号（正则中转义），并拼接成用|分隔的模式字符串
ESCAPED_PACKAGES=()
for pkg in "${PACKAGES[@]}"; do
    # 转义点号为\.，确保精确匹配包名
    ESCAPED_PACKAGES+=("${pkg//./\.}")
done
PATTERN=$(IFS="|"; echo "${ESCAPED_PACKAGES[*]}")

# 使用sed删除包含任何目标包名的行，并创建备份
sed -i.bak -E "/$PATTERN/d" "$TARGET_FILE"

# 检查命令执行结果
if [ $? -eq 0 ]; then
    echo "成功删除包含以下包名的行："
    for pkg in "${PACKAGES[@]}"; do
        echo "- $pkg"
    done
    echo "原始文件已备份为：$TARGET_FILE.bak"
    echo "如需恢复原始文件，可执行：mv $TARGET_FILE.bak $TARGET_FILE"
else
    echo "操作失败，请检查文件权限或内容格式"
    exit 1
fi
