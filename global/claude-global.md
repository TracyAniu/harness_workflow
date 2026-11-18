# Working Style

## Planning
- For any non-trivial task, enter plan mode first.
- Write a checkable plan before implementation.
- If the plan stops matching reality, stop and re-plan.

## Execution
- Make the smallest change that fully solves the problem.
- Prefer root-cause fixes over temporary patches.
- For non-trivial changes, consider whether there is a simpler or more elegant design.

## Verification
- Do not mark work complete until it is verified.
- Run relevant tests, inspect logs, and confirm behavior.
- When relevant, compare old vs new behavior.

## Task Tracking
- Write the plan to `tasks/todo.md` with checkboxes.
- Update progress as work proceeds.
- Add a short review section after implementation.

## Lessons
- After user corrections, record the lesson in `tasks/lessons.md`.
- Write lessons as reusable rules that prevent the same mistake.

## Autonomy
- When given a bug report, investigate, identify evidence, and fix it end-to-end.
- Avoid asking for unnecessary step-by-step guidance when the repository already contains enough context.

# dev-harness workflow kit

- The standard AI dev-workflow skills are installed in `~/.claude/skills/`:
  - `harness-init`: sets up an agent engineering environment for a project (an AGENTS.md map + docs/ + exec-plans + a single scripts entry point for verification). It starts light, at level L0/L1/L2; templates are in `harness-init/assets/`.
  - `harness-task`: the standard flow for each round of work (start-up check → plan → small-step implementation → executable verification → progress record → clean handoff).
  - `harness-maintain`: entropy cleanup (keeping start-up files such as `tasks/todo.md` and `tasks/lessons.md` short, doc gardening, archiving exec-plans and finished todo blocks, and promoting lessons that keep recurring up the "docs → template → lint → CI" ladder into mechanisms).
- Convention: small single-session tasks use `tasks/todo.md` (as in Working Style), and a finished task block moves to `tasks/todo-archive.md`; **multi-session or multi-step tasks** use `docs/exec-plans/active/*.md` with a Progress Log. The two don't conflict; choose by how long the task runs.
- CLAUDE.md vs AGENTS.md: the project-level map goes in AGENTS.md (Codex and other tools can read it too); the project's CLAUDE.md holds only a one-line `@AGENTS.md` import.
- The kit's scripts templates are bash (.sh). When running harness-init on a Windows project, prefer Git Bash, or generate PowerShell/bat equivalents that fit the project. Never generate placeholder scripts that can't run.
- Codex uses the same workflow: the same three skills are installed as Codex skills in `~/.agents/skills/` (list them with `/skills`, or call one with `$harness-init`, `$harness-task` or `$harness-maintain`), each with its own copy of the assets. Codex's global rules are in `~/.codex/AGENTS.md`.
- **This block is managed by harness-kit** (https://github.com/TracyAniu/harness_workflow ): to change the workflow, change the repo, then on each machine `git pull` and rerun the installer. Don't edit this block by hand; the installer overwrites it.
