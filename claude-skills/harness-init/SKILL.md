---
name: harness-init
description: 给项目初始化一套 AI 可长期开发的工程环境（agent harness）。用户说"初始化开发流 / 给项目搭 harness / harness init / 初始化 AGENTS.md / 让这个项目支持 AI 长期开发 / 新项目初始化 AI 工作流"时触发。按项目实际情况轻量起步：探测技术栈 → 生成 AGENTS.md 地图 + docs/ 知识库 + exec-plans 执行计划 + scripts 统一验证入口。
---

# harness-init：项目 AI 开发环境初始化

把项目初始化成一个 **AI 可读、可运行、可验证、可接力** 的工程系统，让后续每一轮 agent 都能从仓库本身完成闭环：

```txt
理解产品 → 理解架构 → 找到任务上下文 → 修改代码 → 运行验证 → 记录进度 → 交接下一轮
```

本 skill 是三件套之一：`harness-init`（建轨道，本 skill）→ `harness-task`（每轮任务沿轨道推进）→ `harness-maintain`（定期养轨道）。

## 核心原则

1. **AGENTS.md 是地图不是百科全书**：≤100 行，只写导航、规则、命令、完成标准；细节放 `docs/`，按需渐进披露。
2. **仓库是唯一记录系统**：agent 运行时读不到的知识等于不存在。产品目标、架构决策、业务约束都要进仓库，不能留在聊天记录里。
3. **完成标准必须可执行**：绑定 typecheck / lint / test / smoke，不接受"看起来完成了"。
4. **轻量起步**：只建当前真的需要的部分，遇到真实问题再升级（见文末"何时升级"）。
5. **从实际代码提炼，不编造**：已有项目的文档内容必须来自读代码/配置得到的事实；写不出来的留 `TODO(需用户补充)` 并在最终汇报中列出，绝不虚构。

## 第一步：探测项目实际情况

动手前先收集事实：

- **git**：是否 git 仓库？工作区是否干净？近期 commit 风格如何？（不是仓库 → 建议先 `git init`，git history 是 harness 的跨会话记忆之一）
- **技术栈**：package.json / pyproject.toml / Cargo.toml / go.mod / Makefile → 确定 dev / typecheck / lint / test 的**真实**命令。
- **已有约定**：CLAUDE.md、AGENTS.md、docs/、README、CI 配置——已有的内容要整合进新结构，不要另起炉灶覆盖。
- **规模与形态**：脚本 / 库 / 服务 / 带 UI 的应用（决定落地级别，以及是否需要浏览器端验证）。

## 第二步：选落地级别

| 级别 | 适用 | 建什么 |
|---|---|---|
| L0 最小 | 脚本、单人小工具 | AGENTS.md + `docs/exec-plans/{active,completed,template.md}` + `scripts/check.sh` |
| L1 标准（默认） | 正常开发的项目 | L0 + `docs/PRODUCT.md` + `docs/ARCHITECTURE.md` + `docs/TESTING.md` + scripts 全套 |
| L2 完整 | 长期多人/多 agent 项目 | L1 + `docs/FRONTEND.md`、`docs/SECURITY.md`、`docs/decisions/`（按实际需要挑选） |

在 L0 与 L1 之间拿不准时问用户一次；不要默认上 L2。

## 第三步：生成文件

模板在本 skill 的 `assets/` 下，复制后按第一步探测到的事实填充：

| 目标文件 | 模板 |
|---|---|
| `AGENTS.md` | `assets/AGENTS.template.md` |
| `docs/PRODUCT.md` | `assets/PRODUCT.template.md` |
| `docs/ARCHITECTURE.md` | `assets/ARCHITECTURE.template.md` |
| `docs/TESTING.md` | `assets/TESTING.template.md` |
| `docs/exec-plans/template.md` | `assets/exec-plan.template.md` |

关键动作：

1. `AGENTS.md` 填入真实命令与真实文档链接（没建的文档不要列）。
2. **CLAUDE.md 衔接**：项目没有 CLAUDE.md → 创建一个只含 `@AGENTS.md` 一行的 CLAUDE.md（Claude Code 会自动导入，Codex 等其他工具直接读 AGENTS.md，一份地图两边共用）；已有 CLAUDE.md → 在其开头加一行指向 AGENTS.md，不动既有内容。
3. `docs/exec-plans/active/` 与 `completed/` 建空目录（放 `.gitkeep`）。

## 第四步：scripts 统一入口

把项目**已有**的真实命令包装为统一入口（bash + `set -euo pipefail`，`chmod +x`）：

- `scripts/dev.sh` — 启动开发环境
- `scripts/check.sh` — typecheck + lint（项目能跑什么就写什么）
- `scripts/test.sh` — 测试
- `scripts/smoke.sh` — 快速冒烟：应用能启动、关键路径能走通

规则：项目没有的能力**不要造假脚本**——没有测试就不建 test.sh，改在 AGENTS.md 里写明"暂无自动化测试，验证方式为 X"。

## 第五步：验证与收尾

1. 逐个运行 scripts/ 下脚本，确认真的能跑；跑不了的修正或删掉。
2. 如是 git 仓库：展示变更清单，经用户确认后作一次独立 commit（如 `chore: init agent harness`）。
3. 汇报：建了哪些文件、选了什么级别、哪些 `TODO(需用户补充)` 待补、建议下一步（通常是用 `harness-task` 开始第一个任务）。

## 与用户全局规范的衔接

- 单会话小任务仍用 `tasks/todo.md`（既有习惯）；**跨会话/多步骤大任务**才建 `docs/exec-plans/active/*.md`。
- `tasks/lessons.md` 继续记教训；反复出现的教训由 `harness-maintain` 升级为规则/lint/测试。

## 何时升级 harness

出现真实信号才升级，对号入座：

- AI 经常忘项目背景 → 补 docs 内容与 AGENTS.md 链接。
- AI 经常改错模块 → 在 ARCHITECTURE.md 补模块边界与依赖规则。
- AI 声称完成但没验证 → 补 scripts 与 AGENTS.md 完成标准。
- 多轮任务接力失败 → 强制使用 exec-plan 与 Progress Log。
- 相同 review 意见反复出现 → 交给 `harness-maintain` 升级成 lint/测试。
- UI 或关键流程经常回归 → 补 smoke/e2e。
