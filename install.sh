#!/usr/bin/env bash
# harness-kit 安装脚本（macOS / Linux）。幂等：重复运行结果一致。
# 用法：./install.sh
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BEGIN="<!-- harness-kit:BEGIN -->"
END="<!-- harness-kit:END -->"

# 1. Claude skills（覆盖式，跟随仓库为准）
mkdir -p "$HOME/.claude/skills"
for s in harness-init harness-task harness-maintain; do
  rm -rf "$HOME/.claude/skills/$s"
  cp -R "$KIT_DIR/claude-skills/$s" "$HOME/.claude/skills/$s"
  echo "skill: $s"
done

# 2. Codex prompts（覆盖式）
mkdir -p "$HOME/.codex/prompts"
cp "$KIT_DIR"/codex-prompts/harness-*.md "$HOME/.codex/prompts/"
echo "codex prompts: harness-init / harness-task / harness-maintain"

# 3. 全局文件的 marker 块 upsert：
#    删除已有 BEGIN..END 块，把仓库里的最新片段追加到文件末尾。
#    块以外的内容（机器专属备注等）原样保留。
upsert_block() {
  local file="$1" snippet="$2"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  local tmp="${file}.harness-kit.tmp"
  awk -v b="$BEGIN" -v e="$END" '$0==b{skip=1;next} $0==e{skip=0;next} !skip{print}' "$file" > "$tmp"
  local local_part
  local_part="$(cat "$tmp")"   # 命令替换会去掉末尾空行，防止重复运行时空行累积
  {
    if [ -n "$local_part" ]; then
      printf '%s\n\n' "$local_part"
    fi
    printf '%s\n' "$BEGIN"
    cat "$snippet"
    printf '%s\n' "$END"
  } > "$file"
  rm -f "$tmp"
  echo "block: $file"
}

upsert_block "$HOME/.claude/CLAUDE.md" "$KIT_DIR/global/claude-global.md"
upsert_block "$HOME/.codex/AGENTS.md"  "$KIT_DIR/global/codex-global.md"

echo "harness-kit installed. 验证：Claude Code 里输 /skills、Codex 里输 /har 看补全。"
