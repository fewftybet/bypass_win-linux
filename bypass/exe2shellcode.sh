#!/bin/bash

clear
echo "========================================"
echo "  EXE转Shellcode工具 - Linux版"
echo "========================================"

DEFAULT_KEY=170

# 获取当前脚本目录
script_dir="$(cd "$(dirname "$0")" && pwd)"
tool_dir="${script_dir}/EXEToshellcode"
xor_dir="${script_dir}/xor"

# 检查目录是否存在
if [ ! -d "$tool_dir" ]; then
    echo "错误: EXEToshellcode目录不存在"
    exit 1
fi

if [ ! -d "$xor_dir" ]; then
    echo "错误: xor目录不存在"
    exit 1
fi

# 输入EXE路径
while true; do
    echo "请输入EXE文件路径:"
    read -r exe_file

    if [ ! -f "$exe_file" ]; then
        echo "错误: 文件不存在 - $exe_file"
        continue
    fi

    # 获取扩展名
    file_ext="${exe_file##*.}"
    if [[ "${file_ext,,}" != "exe" ]]; then
        echo "错误: 请选择 .exe 文件"
        continue
    fi

    break
done

# 获取文件名和目录
filename="$(basename "$exe_file" .exe)"
source_dir="$(dirname "$exe_file")"

# 输入密钥
echo "请输入加密密钥（默认 $DEFAULT_KEY）："
read -r encrypt_key

if [ -z "$encrypt_key" ]; then
    encrypt_key=$DEFAULT_KEY
fi

echo "[1/2] 正在将EXE转换为Shellcode..."

"$tool_dir/EXEToShellcode.exe" -e "$exe_file" -o "$tool_dir/$filename.bin"
if [ $? -ne 0 ]; then
    echo "错误: EXE转换失败"
    exit 1
fi

echo "[2/2] 正在加密Shellcode文件..."

python3 "$xor_dir/xor.py" \
    "$tool_dir/$filename.bin" \
    "$source_dir/output.bin" \
    "$encrypt_key"

if [ $? -ne 0 ]; then
    echo "错误: 加密过程失败"
    exit 1
fi

# 删除临时文件
if [ -f "$tool_dir/$filename.bin" ]; then
    rm "$tool_dir/$filename.bin"
fi

echo
echo "========================================"
echo "操作成功完成!"
echo
echo "原始EXE文件: $exe_file"
echo "生成输出文件: $source_dir/output.bin"
echo "使用的XOR密钥: $encrypt_key"
echo "========================================"
echo