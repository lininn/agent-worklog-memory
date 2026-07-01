#!/usr/bin/env bash
set -euo pipefail

AI_MEMORY_HOME="${AI_MEMORY_HOME:-$HOME/ai-memory}"
DRY_RUN=0
INSTALL_SKILLS=1

usage() {
  cat <<'EOF'
Usage: bash install.sh [--dry-run] [--skip-skills]

Installs the shared AI memory protocol into global Codex, Claude, Gemini, and Cursor instruction files.

Environment:
  AI_MEMORY_HOME  Override the protocol directory. Default: ~/ai-memory
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --skip-skills) INSTALL_SKILLS=0; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

render_template() {
  local template="$1"
  sed "s|{{AI_MEMORY_HOME}}|$AI_MEMORY_HOME|g" "$template"
}

install_managed_block() {
  local file="$1"
  local template="$2"
  local dir
  dir="$(dirname "$file")"
  mkdir -p "$dir"
  touch "$file"

  local tmp
  tmp="$(mktemp)"
  awk '
    /<!-- AI-MEMORY:START -->/ { skip=1; next }
    /<!-- AI-MEMORY:END -->/ { skip=0; next }
    skip != 1 { print }
  ' "$file" > "$tmp"

  if [ "$DRY_RUN" -eq 1 ]; then
    echo "Would update $file from $template"
    rm -f "$tmp"
    return
  fi

  {
    sed -e '${/^$/d;}' "$tmp"
    printf '\n\n'
    render_template "$template"
    printf '\n'
  } > "$tmp.next"
  mv "$tmp.next" "$file"
  rm -f "$tmp"
  echo "Updated $file"
}

write_rendered_file() {
  local file="$1"
  local template="$2"
  local dir
  dir="$(dirname "$file")"
  mkdir -p "$dir"

  if [ "$DRY_RUN" -eq 1 ]; then
    echo "Would write $file from $template"
    return
  fi

  render_template "$template" > "$file"
  echo "Wrote $file"
}

link_skill() {
  local target_dir="$1"
  local source="$repo_dir/skills/agent-worklog-memory"
  local dest="$target_dir/agent-worklog-memory"
  mkdir -p "$target_dir"

  if [ "$DRY_RUN" -eq 1 ]; then
    echo "Would link skill $dest -> $source"
    return
  fi

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "Skip skill $dest: path exists and is not a symlink" >&2
    return
  fi

  if [ -L "$dest" ]; then
    unlink "$dest"
  fi
  ln -s "$source" "$dest"
  echo "Linked skill $dest"
}

mkdir -p "$AI_MEMORY_HOME/projects"

install_managed_block "$HOME/.codex/AGENTS.md" "$repo_dir/adapters/codex/AGENTS-snippet.md"
install_managed_block "$HOME/.claude/CLAUDE.md" "$repo_dir/adapters/claude/CLAUDE-snippet.md"
install_managed_block "$HOME/.gemini/GEMINI.md" "$repo_dir/adapters/gemini/GEMINI-snippet.md"

write_rendered_file "$HOME/.codex/rules/ai-memory.md" "$repo_dir/adapters/codex/AGENTS-snippet.md"
write_rendered_file "$HOME/.cursor/rules/ai-memory.mdc" "$repo_dir/adapters/cursor/ai-memory.mdc"

if [ "$INSTALL_SKILLS" -eq 1 ]; then
  link_skill "$HOME/.codex/skills"
  link_skill "$HOME/.claude/skills"
fi

echo "AI memory protocol installed. Protocol home: $AI_MEMORY_HOME"
