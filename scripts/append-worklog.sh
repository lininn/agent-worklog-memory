#!/usr/bin/env bash
set -euo pipefail

AI_MEMORY_HOME="${AI_MEMORY_HOME:-$HOME/ai-memory}"
TYPE=""
TITLE=""
ACTOR="${AI_MEMORY_ACTOR:-AI}"
RELATED=""
REASON=""
CHANGES=""
FILES=""
VERIFICATION=""
RISKS=""
PROJECT=""
BRANCH=""

usage() {
  cat <<'EOF'
Usage:
  append-worklog.sh --type TYPE --title TITLE --reason TEXT --changes TEXT --files TEXT --verification TEXT --risks TEXT [options]

Options:
  --actor NAME       Actor name, e.g. Codex, Claude, Gemini, Cursor, Human.
  --related TEXT     OpenSpec change id, commit, issue, or user request.
  --project NAME     Override project name. Default: Git root basename or cwd basename.
  --branch NAME      Override branch. Default: current Git branch/detached state.

Environment:
  AI_MEMORY_HOME     Default: ~/ai-memory
  AI_MEMORY_ACTOR    Default actor when --actor is omitted.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --type) TYPE="${2:-}"; shift 2 ;;
    --title) TITLE="${2:-}"; shift 2 ;;
    --actor) ACTOR="${2:-}"; shift 2 ;;
    --related) RELATED="${2:-}"; shift 2 ;;
    --reason) REASON="${2:-}"; shift 2 ;;
    --changes) CHANGES="${2:-}"; shift 2 ;;
    --files) FILES="${2:-}"; shift 2 ;;
    --verification) VERIFICATION="${2:-}"; shift 2 ;;
    --risks) RISKS="${2:-}"; shift 2 ;;
    --project) PROJECT="${2:-}"; shift 2 ;;
    --branch) BRANCH="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

required=()
[ -n "$TYPE" ] || required+=("--type")
[ -n "$TITLE" ] || required+=("--title")
[ -n "$REASON" ] || required+=("--reason")
[ -n "$CHANGES" ] || required+=("--changes")
[ -n "$FILES" ] || required+=("--files")
[ -n "$VERIFICATION" ] || required+=("--verification")
[ -n "$RISKS" ] || required+=("--risks")

if [ "${#required[@]}" -gt 0 ]; then
  echo "Missing required arguments: ${required[*]}" >&2
  usage >&2
  exit 2
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -n "$PROJECT" ] || PROJECT="$("$script_dir/current-project.sh")"
[ -n "$BRANCH" ] || BRANCH="$("$script_dir/current-branch.sh")"

month="$(date '+%Y-%m')"
timestamp="$(date '+%Y-%m-%d %H:%M')"
target="$AI_MEMORY_HOME/projects/$PROJECT/worklog/$month.md"
mkdir -p "$(dirname "$target")"

if [ ! -f "$target" ]; then
  printf '# %s Worklog - %s\n\n' "$PROJECT" "$month" > "$target"
fi

format_lines() {
  local text="$1"
  while IFS= read -r line; do
    [ -n "$line" ] && printf -- '- %s\n' "$line"
  done <<< "$text"
}

{
  printf '\n## %s - %s\n\n' "$timestamp" "$TITLE"
  printf '类型：%s\n' "$TYPE"
  printf '项目：%s\n' "$PROJECT"
  printf '分支：%s\n' "$BRANCH"
  printf '执行者：%s\n' "$ACTOR"
  printf '关联：%s\n\n' "${RELATED:-无}"
  printf '原因：\n'
  format_lines "$REASON"
  printf '\n修改：\n'
  format_lines "$CHANGES"
  printf '\n影响文件：\n'
  format_lines "$FILES"
  printf '\n验证：\n'
  format_lines "$VERIFICATION"
  printf '\n风险：\n'
  format_lines "$RISKS"
  printf '\n'
} >> "$target"

echo "$target"

