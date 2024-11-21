#!/bin/bash

## 脚本说明：递归遍历当前目录，生成目录结构，并输出到文件。
## 使用说明：
#     - 目录：查看 comment.txt 文件，作为注释
#     - 文件：读取文件的第一行数据，并去除行首的 # 符号（如果存在），作为注释。

# 初始化开始时间
start_time=$(date +%s)

# 定义常量
readonly OUTPUT_DIR_NAME="directory.md"
filtered_files=("pictures" "aa.md" "comment.txt")   # 过滤文件列表（跳过不扫描）

# 定义一个函数来打印目录结构
print_dir_structure() {
    local path="$1"
    local indent="$2"


#    if [[ "$(basename "$path")" == "pictures" ]]; then
#        return
#    fi
    # 过滤掉需要过滤的 目录 or 文件
    for file in "${filtered_files[@]}"; do
        # 判断当前文件是否存在于当前目录
         if [[ "$(basename "$path")" == "$file"  ]]; then
            echo "文件 '$path' 存在，并且已被过滤。"
            return
         fi
    done

    # 输出进度信息
    echo "正在扫描 $path ..."

    # 检查是否为目录
    if [[ -d "$path" ]]; then
        local comment=""
        # 尝试读取目录下的commend.txt文件来获取注释
        if [[ -f "$path/COMMENT.txt" ]]; then
            comment=$(cat "$path/COMMENT.txt" | head -n1)
        else
            comment="No comment provided"
        fi

        # 构建目录或文件的输出字符串，并计算空格数以对齐注释
        local name_output="${indent}└─ $(basename "$path")"
        local spaces=$((100 - ${#name_output} - ${#comment}))
        local padding=$(printf '%*s' "$spaces")

        # 打印目录和注释
        echo -e "${name_output}${padding}# ${comment}" >> $OUTPUT_DIR_NAME

        # 遍历目录中的所有项
        local sub_indent="${indent}    "
        for item in "$path"/*; do
            if [[ -d "$item" ]]; then
                # 递归打印子目录
                print_dir_structure "$item" "$sub_indent"
            elif [[ -f "$item" ]]; then
              found=false
                for file in "${filtered_files[@]}"; do
                    # 判断是否为过滤文件
                    if [[ "$(basename "$item")" == "$file"  ]]; then
                        found=true
                        break
                    fi
                done
                if $found; then
                    echo "文件 '$item' 存在，并且已被过滤。"
                else
                    # 打印文件和第一行注释
                    local file_comment=$(head -n1 "$item" | cut -c2-) # 去除行首的#
                    if [[ -z "$file_comment" ]]; then
                       # 如果 file_comment 为空，则设置为 "No comment provided"
                       file_comment="No comment provided"
                    fi
                    local file_output="${sub_indent}|- $(basename "$item")"
                    spaces=$((100 - ${#file_output} - ${#file_comment}))
                    padding=$(printf '%*s' "$spaces")
                    echo -e "${file_output}${padding}# ${file_comment}" >> $OUTPUT_DIR_NAME
                fi
            fi
        done
    fi
}

# 删除现有的directory.md文件，如果存在
if [[ -f $OUTPUT_DIR_NAME ]]; then
    echo "删除旧的 $OUTPUT_DIR_NAME ..."
    rm $OUTPUT_DIR_NAME
fi

# 创建directory.md文件
echo "创建新的 $OUTPUT_DIR_NAME ..."
touch $OUTPUT_DIR_NAME

# 打印目录结构到directory.md文件
echo "# Directory Structure" > $OUTPUT_DIR_NAME
echo '```' >> $OUTPUT_DIR_NAME
print_dir_structure "$(pwd)" ""
echo '```' >> $OUTPUT_DIR_NAME

# 计算并输出整个过程的耗时
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "整个过程耗时：${elapsed_time} 秒"

# 输出完成提示
echo "目录结构扫描完成，并已写入到 $OUTPUT_DIR_NAME。"