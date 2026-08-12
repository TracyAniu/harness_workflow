# AGENTS.md

<项目名>：<一句话说明项目是什么、给谁用>。

本文件是地图不是说明书：告诉你去哪里找信息、用什么命令、按什么流程做事、什么才算完成。

## 必读

动手前按任务需要阅读：

1. `docs/PRODUCT.md` — 产品目标、范围、明确不做的事
2. `docs/ARCHITECTURE.md` — 架构、模块边界、依赖规则
3. `docs/TESTING.md` — 测试策略与验证命令

<按项目实际增删；前端任务加 docs/FRONTEND.md，安全敏感任务加 docs/SECURITY.md>

## 常用命令

```bash
./scripts/dev.sh     # 启动开发环境
./scripts/check.sh   # typecheck + lint
./scripts/test.sh    # 测试
./scripts/smoke.sh   # 冒烟：应用能起、关键路径能走
```

## 工作规则

- 动手前先 `git status`，从干净状态开始。
- 小步、可验证的变更；不做与任务无关的重构。
- 复用仓库既有模式；不引入无明确收益的新抽象。
- 文档与代码冲突时，以代码为准，然后修文档。
- 行为、架构或工作流变化时，同步更新 docs。

## 任务流程

1. 读本文件与相关 docs；读 `git log` 与进度记录。
2. 单会话小任务 → `tasks/todo.md` 写带 checkbox 的计划；跨会话复杂任务 → 按 `docs/exec-plans/template.md` 在 `docs/exec-plans/active/` 建执行计划。
3. 一次只推进一个明确目标。
4. 实现后运行相关验证；用户可见改动要走真实端到端路径。
5. 更新进度与文档，验证通过后 commit。

## 完成标准

声称完成前必须：

- [ ] `./scripts/check.sh` 通过
- [ ] `./scripts/test.sh` 通过
- [ ] 用户可见改动跑过 `./scripts/smoke.sh` 或真实路径验证
- [ ] 进度记录已更新（todo.md 勾选或 exec-plan 的 Progress Log）

某项验证无法运行时，说明原因与剩余风险，不要静默跳过。

## 完成汇报

- 改了什么、为什么。
- 跑了哪些验证、结果如何。
- 什么还有风险、什么没验证。
- 建议 review 的关键文件。
