# Install And Reuse

This repository is meant to be installed as a reusable AI memory protocol package.

## Standard Install

```bash
git clone <repo-url> ~/ai-memory
bash ~/ai-memory/install.sh
```

Dry run:

```bash
bash ~/ai-memory/install.sh --dry-run
```

Skip skill linking:

```bash
bash ~/ai-memory/install.sh --skip-skills
```

## Non-Default Location

```bash
git clone <repo-url> "$HOME/dev/ai-memory"
AI_MEMORY_HOME="$HOME/dev/ai-memory" bash "$HOME/dev/ai-memory/install.sh"
```

Teams should standardize the path if they want consistent instructions across tools.

## What The Installer Changes

The installer appends or replaces a managed block marked by:

```md
<!-- AI-MEMORY:START -->
...
<!-- AI-MEMORY:END -->
```

Managed files:

- `~/.codex/AGENTS.md`
- `~/.claude/CLAUDE.md`
- `~/.gemini/GEMINI.md`

Generated files:

- `~/.codex/rules/ai-memory.md`
- `~/.cursor/rules/ai-memory.mdc`

Optional skill links:

- `~/.codex/skills/agent-worklog-memory`
- `~/.claude/skills/agent-worklog-memory`

Repeated installs update the managed block instead of appending duplicates.

## Protocol vs Data

By default, `.gitignore` ignores:

```text
projects/
```

This means the GitHub repository shares the protocol, adapters, scripts, templates, and skill, but not a user's personal worklogs.

If a private team wants to share a specific project's worklog, adjust `.gitignore` deliberately:

```gitignore
/projects/*
!/projects/example-app/
!/projects/example-app/worklog/
!/projects/example-app/worklog/*.md
```

Only do this after deciding what information is safe to share.

## Validation

```bash
bash -n ~/ai-memory/install.sh
bash -n ~/ai-memory/scripts/append-worklog.sh
bash ~/ai-memory/install.sh --dry-run
```
