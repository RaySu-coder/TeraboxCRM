#!/usr/bin/env bash
set -euo pipefail

# 说明：
# 1) 在仓库根目录运行
# 2) 脚本会列出 public/images/assets/ 下所有文件，并在代码库中查找这些文件名（跳过 .git 目录和 assets 本身）。
# 3) 将匹配到的地方替换为 /images/assets/<filename>（若已经是 /images/assets/ 则跳过）。
# 4) 会为每个修改的文件创建 *.bak 备份，可在确认无误后删除备份或用 git 恢复。
# 5) 默认会直接在 main 分支上提交并 push。若不想直接 push，请把 PUSH_TO_MAIN=true 改为 false。

REPO_DIR="$(pwd)"
ASSETS_DIR="public/images/assets"
PUSH_TO_MAIN=true   # 如果你要先在分支上做修改，改为 false 并手动切换分支

if [ ! -d "$ASSETS_DIR" ]; then
  echo "错误：找不到 $ASSETS_DIR。请确认你已在仓库根目录并且已上传图片。"
  exit 1
fi

echo "当前仓库目录: $REPO_DIR"
echo "图片目录: $ASSETS_DIR"
echo

# 列出 assets 下的文件（不包含子目录名）
FILES=$(ls -1 "$ASSETS_DIR" | sed '/^\s*$/d')

if [ -z "$FILES" ]; then
  echo "警告：$ASSETS_DIR 下没有文件，脚本退出。"
  exit 0
fi

echo "将处理以下文件："
echo "$FILES"
echo

# 切换到 main（请确保 main 是你想直接修改的默认分支）
if $PUSH_TO_MAIN; then
  echo "切换到 main 分支并拉取最新..."
  git checkout main
  git pull origin main
else
  echo "PUSH_TO_MAIN=false（不会自动 push）"
fi

# 处理每个文件名
MODIFIED_FILES=()
for f in $FILES; do
  # 忽略目录
  if [ -d "$ASSETS_DIR/$f" ]; then
    echo "跳过目录: $f"
    continue
  fi

  echo "查找引用：$f"
  # 在仓库中查找包含该文件名但不位于 public/images/assets 目录内的文件
  MATCHES=$(grep -RIl --binary-files=without-match --exclude-dir=.git --exclude-dir="$ASSETS_DIR" --exclude="$ASSETS_DIR/*" -- "$f" . || true)

  if [ -z "$MATCHES" ]; then
    echo "  未找到引用：$f （可能没有需要替换的位置）"
    continue
  fi

  echo "  找到引用文件："
  echo "$MATCHES"

  # 对每个匹配文件进行替换（只有当该引用不是已经以 /images/assets/ 开头时才替换）
  # 使用 perl 的负向前置断言确保不替换已经正确的 /images/assets/<f>
  for mf in $MATCHES; do
    echo "    替换文件: $mf"
    # 备份
    cp "$mf" "${mf}.bak.before_replace"
    # 执行替换：只有当不是 /images/assets/<filename> 才替换
    perl -0777 -pe "s{(?<!/images/assets/)${f}}{/images/assets/${f}}g" -i "$mf"
    MODIFIED_FILES+=("$mf")
  done
done

if [ ${#MODIFIED_FILES[@]} -eq 0 ]; then
  echo "未修改任何文件。"
  exit 0
fi

# 显示已修改文件（去重）
echo
echo "已修改文件："
printf "%s\n" "${MODIFIED_FILES[@]}" | sort -u

# 添加并提交更改
git add -A
git commit -m "Fix image references → /images/assets/ (update image paths)"

if $PUSH_TO_MAIN; then
  echo "推送到 origin/main..."
  git push origin main
  echo "已推送到 main。请在 GitHub 上检查并部署（如需要）。"
else
  echo "PUSH_TO_MAIN=false，未自动 push。请在本地检视更改后执行 'git push origin <branch>'。"
fi

echo "完成。"
