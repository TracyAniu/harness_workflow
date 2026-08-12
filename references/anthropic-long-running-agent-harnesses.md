---
created: 2026-05-26
tags:
  - AI
  - Agents
  - Harness
  - Engineering
source:
  - https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents
  - https://www.anthropic.com/engineering/harness-design-long-running-apps
---

# Anthropic Long-running Agent Harnesses

## 一句话总结

长程 agent 的核心不是让模型“更努力”，而是给它一个能跨上下文、跨会话、可恢复、可验证、可接力的工作环境。有效 harness 要把任务拆小，把状态写成结构化工件，把完成标准变成可测试契约，并把“做事”和“评价”尽量分离。

## 文章一：Effective harnesses for long-running agents

### 核心问题

长程 agent 会被上下文窗口切断。复杂任务往往无法在一个 context window 内完成，新一轮 agent 会话又天然缺少前一轮的完整记忆。仅靠 compaction 不够，因为压缩后的上下文可能遗漏关键状态，也不能保证下一轮 agent 明确知道当前代码是否干净、哪些功能已完成、下一步该做什么。

Anthropic 观察到几个典型失败模式：

- Agent 试图一次性完成太多，做到一半上下文耗尽，留下半成品。
- 下一轮 agent 不知道前一轮具体改了什么，只能重新摸索，甚至先修基础问题。
- 做到后期时，agent 看到已有进展就过早宣布项目完成。
- Agent 容易把功能标记为完成，但没有做真正的端到端验证。

### 两段式 harness

Anthropic 的基础方案分成两个角色：

- Initializer agent：首次运行时搭环境，创建 `init.sh`、进度文件、结构化功能清单、初始 git commit。
- Coding agent：后续每个会话只做增量进展，完成后留下清晰工件，方便下一轮接手。

这里的关键不是角色名字，而是“首轮建轨道，后续沿轨道推进”。

### 关键工件

- `feature_list.json`：把用户的高层需求展开为大量端到端功能项，每项都有步骤和 `passes` 状态。初始全部设为 failing，避免 agent 因目标模糊而过早收工。
- `claude-progress.txt`：记录每轮做了什么、验证了什么、还剩什么问题。
- `init.sh`：统一启动开发环境，减少每轮 agent 重新摸索运行方式的成本。
- Git history：每轮以干净状态提交，便于回滚坏改动，也让下一轮快速理解近期变化。

Anthropic 特别强调功能清单适合用 JSON，因为模型比编辑 Markdown 时更不容易随意改写结构或删除测试项。

### 每轮 coding agent 的工作方式

推荐的会话启动流程：

1. 确认当前目录和可编辑范围。
2. 读取 git log、进度文件和功能清单。
3. 读取 `init.sh` 并启动应用。
4. 先跑基础端到端 smoke test，确认当前主流程没坏。
5. 选择一个最高优先级、尚未通过的功能。
6. 实现并验证该功能。
7. 只有经过人工用户路径式的端到端验证后，才把功能标为 passing。
8. 写进度记录并提交 git。

### 重点启发

- 长程任务必须强制增量化。一次只做一个功能比“大步推进”更可靠。
- “干净状态”是交接契约。每轮结束时应像准备合入主分支一样：没有明显 bug，有测试记录，有提交，有说明。
- 自动化浏览器测试很重要。代码层测试和 `curl` 不足以证明 Web App 真的可用；让 agent 像用户一样操作页面，能发现代码静态检查看不到的问题。
- 进度文件和 git 不是辅助记录，而是跨上下文记忆系统。

## 文章二：Harness design for long-running application development

### 新问题：自评不可靠

第二篇文章在第一篇的基础上继续推进。Anthropic 发现，复杂任务中还有两个明显问题：

- 长任务中模型会失去连贯性，或者产生 “context anxiety”，在接近上下文限制时提前收尾。
- Agent 自己评价自己的工作时往往过于乐观，尤其是前端设计这类主观质量任务。

解决方向是把“生成”和“评估”拆开：让 generator 负责产出，让 evaluator 负责挑错和打分。单独调一个更怀疑、更严格的 evaluator，比要求 generator 自己变得足够自我批判更可控。

### 把主观质量变成可评分标准

在前端设计任务里，Anthropic 用四类标准约束 generator 和 evaluator：

- Design quality：整体是否有统一气质，而不是组件拼贴。
- Originality：是否有定制设计决策，还是模板化、默认组件化、AI 味太重。
- Craft：排版、间距、层级、对比度、颜色协调等基本功。
- Functionality：用户能否理解并完成任务。

重点权重放在 design quality 和 originality，因为模型默认在 craft 和 functionality 上相对容易合格，但容易产出安全、平庸、模板化的界面。

Evaluator 不是只看截图，而是用 Playwright 进入页面、操作页面、截图、观察，再给出评分和具体批评。Generator 根据反馈迭代 5 到 15 轮，有时会从平庸方案跳到更大胆的设计方向。

### 三 agent 架构

面向完整应用开发时，Anthropic 使用了：

- Planner：把 1 到 4 句用户 prompt 扩展成完整产品规格，包含范围、产品目标、设计语言和高层技术方向。
- Generator：根据 spec 构建应用。
- Evaluator / QA：根据契约和测试标准操作真实应用，发现偏离 spec 的行为、stub 功能、交互缺口和边界问题。

Planner 的价值是防止 generator 从一句话需求直接开写，导致范围过小或功能遗漏。Evaluator 的价值是把“看起来不错”拉回到“核心功能是否真的可用”。

### Sprint、context reset 与模型能力的关系

早期 harness 需要 sprint 分解和 context reset，因为旧模型在长上下文中更容易失去连贯性或提前收尾。随着模型能力提升，某些 scaffolding 可能不再必要。

Anthropic 后续在更强模型上移除了 sprint 结构，把 evaluator 改成阶段性或末尾 QA，而不是每个 sprint 都评审。结果是：

- Planner 仍然有价值，因为没有 planner 时 generator 容易 under-scope。
- Evaluator 不是永远必需；当任务已经在模型可靠能力范围内时，它可能只是成本和延迟。
- 但当任务处在模型能力边界时，QA 仍能抓到 generator 遗漏的核心交互、stub 功能和最后一公里问题。

这说明 harness 组件不是固定答案，而是对当前模型能力缺口的补偿。模型升级后，应重新验证哪些组件还“承重”。

## 可操作清单

如果要设计自己的长程 coding agent harness，可以这样落地：

1. 首轮 initializer 负责建立工作轨道，而不是直接开写大量功能。
2. 把需求展开成结构化功能清单，最好每项都有用户路径、验收标准和状态。
3. 每轮 agent 只选一个明确功能推进。
4. 开工前必须读进度、读 git log、跑 smoke test。
5. 完成前必须做端到端验证，尤其是 UI 应用要用浏览器自动化。
6. 每轮结束必须更新进度文件，并提交一个可理解的 git commit。
7. 对主观质量或复杂验收，引入独立 evaluator，而不是让 generator 自评。
8. Evaluator prompt 要经过校准，默认模型 QA 容易过宽、过浅。
9. Harness 复杂度要定期回收：新模型上线后，逐个移除组件验证是否真的还需要。
10. 判断 evaluator 是否值得用，看任务是否处在当前模型能力边界，而不是机械固定启用。

## 我的理解

这两篇文章的底层思想是：长程 agent 的性能很大一部分来自工作制度，而不只是模型智力。人类工程团队靠 issue、测试、commit、review、handoff notes 保持协作连续性；agent 也需要类似机制。

最值得复用的模式是：

- 用结构化文件替代口头记忆。
- 用端到端验收替代“模型觉得完成了”。
- 用 git commit 和进度日志作为跨上下文记忆。
- 用独立 QA 抵消自评偏差。
- 用最小必要 harness 匹配当前模型能力，而不是迷信复杂 orchestration。

## Sources

- [Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents), Anthropic Engineering, 2025-11-26.
- [Harness design for long-running application development](https://www.anthropic.com/engineering/harness-design-long-running-apps), Anthropic Engineering, 2026-03-24.
