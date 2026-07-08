---
name: agent-worklog-memory
description: Use when an AI coding agent completes code, config, docs, tests, style, OpenSpec work, or when the user asks to record, retrieve, summarize, or explain AI worklog memory across branches or projects.
---

# Agent Worklog Memory

Use the explicit shared memory protocol, not private model memory.

Protocol home defaults to `~/ai-memory`; honor `AI_MEMORY_HOME` when set. Read `README.md` only when the protocol details are needed. Do not preload historical project logs unless the user asks about history, rationale, work summaries, requirements, or decisions.

## After Changes

After completing any code/config/docs/tests/style/OpenSpec change:

1. Determine project: Git root basename, otherwise cwd basename.
2. Determine branch: `git branch --show-current`; detached HEAD becomes `detached:<short-sha>`; outside Git is `无 Git 仓库`.
3. Append to `$AI_MEMORY_HOME/projects/<project>/worklog/YYYY-MM-DD.md`.
4. Include exact local write time (`时间：YYYY-MM-DD HH:mm`), type, project, branch, actor, related item, reason, changes, files, verification, and risks.
5. Keep it short: title under 80 characters; reason/changes/verification/risks are 1-3 bullets each; each bullet should state one fact and stay near 120 characters. Put long rationale in decisions or OpenSpec and link it from related item.

Prefer the bundled script:

```bash
AI_MEMORY_ACTOR=Codex ~/ai-memory/scripts/append-worklog.sh \
  --type Bugfix \
  --title "Short title" \
  --reason "Why this changed" \
  --changes "What changed" \
  --files "path/to/file" \
  --verification "What was verified" \
  --risks "Known risks or none"
```

## On Demand Retrieval

When asked about prior work, search in order:

1. `$AI_MEMORY_HOME/projects/<project>/worklog/`
2. `$AI_MEMORY_HOME/projects/<project>/decisions/`
3. `openspec/changes/`
4. `openspec/changes/archive/`
5. Git history

For branch-specific questions, filter by `分支：` first.

## Do Not

- Do not store secrets, tokens, passwords, private customer data, or sensitive personal data.
- Do not rewrite old entries except to fix formatting or remove sensitive data.
- Do not read all historical logs at task start.
