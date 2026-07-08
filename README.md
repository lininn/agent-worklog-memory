# Agent Worklog Memory

Agent Worklog Memory is an explicit, file-based memory protocol for AI coding agents.

It records why work changed, what changed, which branch it happened on, how it was verified, and what risks remain. It is designed for Codex, Claude, Gemini, Cursor, and other coding agents without relying on any single vendor's private memory.

## Why

AI coding agents often make small bug fixes, configuration tweaks, and OpenSpec/spec-driven changes that are hard to understand later from Git diffs alone. This project provides a shared worklog protocol that agents write after completing work and query only when the user asks about history, rationale, decisions, or work summaries.

## Install

```bash
git clone <repo-url> ~/ai-memory
bash ~/ai-memory/install.sh
```

Preview first:

```bash
bash ~/ai-memory/install.sh --dry-run
```

The installer writes managed rules to:

- `~/.codex/AGENTS.md`
- `~/.codex/rules/ai-memory.md`
- `~/.claude/CLAUDE.md`
- `~/.gemini/GEMINI.md`
- `~/.cursor/rules/ai-memory.mdc`

It also links the bundled skill into:

- `~/.codex/skills/agent-worklog-memory`
- `~/.claude/skills/agent-worklog-memory`

Use `AI_MEMORY_HOME` to install from a non-default location.

## Directory Layout

```text
~/ai-memory/
  README.md
  INSTALL.md
  install.sh
  adapters/                 # Tool-specific global instruction snippets
  scripts/                  # Deterministic helpers
  skills/                   # Optional AI skill package
  templates/                # Worklog and decision templates
  projects/                 # Local/private memory data, ignored by default
```

## Worklog Location

Agents append worklogs to:

```text
~/ai-memory/projects/<project-name>/worklog/YYYY-MM-DD.md
```

Project name defaults to the Git repository root directory name. Outside Git, it uses the current working directory name.

Every entry must include the current branch:

- Normal branch: `分支：feature/foo`
- Detached HEAD: `分支：detached:<short-sha>`
- Outside Git: `分支：无 Git 仓库`

## Worklog Format

Keep entries concise and scannable:

- Title: one line, ideally under 80 characters.
- `时间`: exact local write time in `YYYY-MM-DD HH:mm` format.
- `原因`, `修改`, `验证`, `风险`: 1-3 bullets each.
- Each bullet: one concrete fact, ideally under 120 characters.
- `影响文件`: list key files or directories only; avoid dumping a full diff.
- Long background, tradeoffs, or architectural rationale belongs in `decisions/` or OpenSpec, then link it from `关联`.

```md
## YYYY-MM-DD HH:mm - Short title

时间：YYYY-MM-DD HH:mm
类型：Bugfix / Feature / Refactor / Config / Style / Test / Docs / Investigation / OpenSpec / Cleanup
项目：<project-name>
分支：<branch-name 或 detached:<short-sha> 或 无 Git 仓库>
执行者：Codex / Claude / Gemini / Cursor / Human
关联：OpenSpec change id / Git commit / Issue / user request, or empty

原因：
- One concise reason.

修改：
- One concise change summary.

影响文件：
- path/to/file

验证：
- Commands or manual checks.
- If not verified, say why.

风险：
- Known risks, unverified cases, or "无已知风险".
```

## Append With Script

```bash
AI_MEMORY_ACTOR=Codex ~/ai-memory/scripts/append-worklog.sh \
  --type Bugfix \
  --title "Fix empty flight list state" \
  --reason "The UI assumed at least one item existed." \
  --changes "Added empty-array guard and empty state rendering." \
  --files "src/flights/List.tsx" \
  --verification "Ran targeted unit test and manually checked empty result." \
  --risks "No known risk."
```

## On-Demand Retrieval

Agents must not preload historical worklogs for every task.

Only query memory when the user asks about:

- Previous changes
- Why something changed
- Work summaries or workload
- Requirement history
- Bug fix rationale
- OpenSpec completion records
- Technical decisions

Search order:

1. `~/ai-memory/projects/<project-name>/worklog/`
2. `~/ai-memory/projects/<project-name>/decisions/`
3. Current project's `openspec/changes/`
4. Current project's `openspec/changes/archive/`
5. Git history

For branch-specific questions, filter by the `分支：` field first.

## Data Policy

The repository ignores `projects/` by default. Share the protocol, adapters, scripts, templates, and skill; keep personal worklogs local unless your team explicitly chooses to version them.

Do not record secrets, tokens, passwords, private customer data, or sensitive personal data.
