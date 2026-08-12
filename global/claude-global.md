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

# dev-harness 开发流三件套

- 已安装标准 AI 开发流 skills（`~/.claude/skills/`）：
  - `harness-init`：给项目初始化 agent 工程环境（AGENTS.md 地图 + docs/ + exec-plans + scripts 统一验证入口），轻量起步分 L0/L1/L2，模板在 `harness-init/assets/`。
  - `harness-task`：每轮任务标准流（开工检查 → 计划 → 小步实现 → 可执行验证 → 记录进度 → 干净交接）。
  - `harness-maintain`：熵回收（文档园艺、归档 exec-plans、把 lessons 里反复出现的教训沿"文档→模板→lint→CI"阶梯升级为机制）。
- 约定：单会话小任务用 `tasks/todo.md`（沿用 Working Style）；**跨会话/多步骤大任务**用 `docs/exec-plans/active/*.md` + Progress Log。两者不冲突，按任务跨度选。
- CLAUDE.md 与 AGENTS.md 的关系：项目级地图写在 AGENTS.md（Codex 等工具也能读），项目 CLAUDE.md 只放一行 `@AGENTS.md` 导入。
- 三件套里的 scripts 模板是 bash（.sh）。在 Windows 项目上跑 harness-init 时，优先用 Git Bash 执行，或按项目实际生成 PowerShell/bat 等价脚本，不要生成跑不起来的假脚本。
- Codex 侧是同一套开发流：自定义 prompts 在 `~/.codex/prompts/`（命令 `/harness-init` `/harness-task` `/harness-maintain`），全局规范在 `~/.codex/AGENTS.md`；harness-init 模板与 Claude 共用 `~/.claude/skills/harness-init/assets/`。
- **本区块由 harness-kit 管理**（https://github.com/TracyAniu/harness_workflow ）：改流程改仓库后各机 `git pull` + 重跑安装脚本；不要手改本区块内容，会被安装脚本覆盖。
