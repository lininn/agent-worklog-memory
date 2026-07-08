<!-- AI-MEMORY:START -->
## Shared AI Memory

Follow the shared protocol at `{{AI_MEMORY_HOME}}/README.md`.

After completing any code, config, docs, tests, style, or OpenSpec-related change, append a concise worklog entry to:

`{{AI_MEMORY_HOME}}/projects/<project-name>/worklog/YYYY-MM-DD.md`

Use the current Git repository root directory name as `<project-name>`; outside Git, use the current working directory name. Every worklog entry must include exact local write time as `时间：YYYY-MM-DD HH:mm` and the current branch from `git branch --show-current`; for detached HEAD, record `detached:<short-sha>`, and outside Git record `无 Git 仓库`.

Do not preload historical worklogs by default. Query `{{AI_MEMORY_HOME}}/projects/<project-name>/`, OpenSpec, and Git history only when the user asks about prior changes, rationale, work summaries, requirement history, or decisions. For branch-specific questions, filter by the `分支：` field first.
<!-- AI-MEMORY:END -->
