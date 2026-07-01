#!/usr/bin/env bash
set -euo pipefail

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch="$(git branch --show-current 2>/dev/null || true)"
  if [ -n "$branch" ]; then
    printf '%s\n' "$branch"
  else
    sha="$(git rev-parse --short HEAD 2>/dev/null || true)"
    if [ -n "$sha" ]; then
      printf 'detached:%s\n' "$sha"
    else
      printf 'Git 状态未知\n'
    fi
  fi
else
  printf '无 Git 仓库\n'
fi

