# 标准 AI 开发流 dev-harness（与 Claude Code 共用一套）

三个标准流程命令（自定义 prompts，输入 `/名字` 调用，文件在 `~/.codex/prompts/`）：

- `/harness-init`：给项目初始化 agent 工程环境（AGENTS.md 地图 + docs/ + exec-plans + scripts 统一验证入口），轻量起步分 L0/L1/L2。
- `/harness-task`：每轮任务标准流（开工检查 → 计划 → 小步实现 → 可执行验证 → 记录进度 → 干净交接）。
- `/harness-maintain`：熵回收（文档园艺、归档 exec-plans、把反复出现的教训沿"文档→模板→lint→CI"阶梯升级为机制）。

**中文触发语**（用户没输斜杠命令时同样生效）：

- 「开工 / 按开发流做 / 接手任务 / 继续 <任务名>」→ 读 `~/.codex/prompts/harness-task.md` 并按其流程执行。
- 「给这个项目搭 harness / 初始化开发流 / harness init」→ 读 `~/.codex/prompts/harness-init.md` 并执行。
- 「harness 维护 / 清理技术债 / 把教训固化成规则」→ 读 `~/.codex/prompts/harness-maintain.md` 并执行。

# 记录与工作约定（Working Style）

- 非平凡任务先给出可勾选的计划，经用户确认再实现；计划与现实不符时停下改计划，不硬推。
- 用最小变更完整解决问题；优先根因修复而非临时补丁。
- 未验证不得报告完成：跑相关测试/检查，用户可见改动走端到端真实路径；某项验证跑不了就如实说明剩余风险。
- 单会话小任务：计划写 `tasks/todo.md`（checkbox），完成后补 Review 小节。
- 跨会话/多步骤大任务：用 `docs/exec-plans/active/*.md` + Progress Log 接力，状态写文件和 git，不依赖聊天记忆。
- 用户纠正过的错误：以可复用规则的形式记入 `tasks/lessons.md`。
- 项目地图以仓库根目录的 AGENTS.md 为正典；项目 CLAUDE.md 只是指向它的一行导入。

本区块由 harness-kit 管理（https://github.com/TracyAniu/harness_workflow ）：改流程改仓库后各机 `git pull` + 重跑安装脚本；不要手改本区块内容。
