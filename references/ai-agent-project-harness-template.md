---
created: 2026-05-26
tags:
  - AI
  - Agents
  - Harness
  - Project-Template
  - Engineering
---

# 新项目 AI Agent 开发 Harness 模板

## 一句话原则

新项目如果希望长期使用 AI 参与开发，不要只依赖 prompt。应该把项目设计成一个 **AI 可读、可运行、可验证、可接力** 的工程系统。

AI 应该能够从仓库本身完成这条闭环：

```txt
理解产品 -> 理解架构 -> 找到任务上下文 -> 修改代码 -> 运行验证 -> 记录进度 -> 交接下一轮
```

这份模板适合在新建项目时直接参考，用来初始化项目文档、规则、脚本和 AI 工作流。

## 推荐目录结构

```txt
your-project/
  AGENTS.md
  docs/
    PRODUCT.md
    ARCHITECTURE.md
    AI_WORKFLOW.md
    ENGINEERING_STANDARDS.md
    TESTING.md
    FRONTEND.md
    SECURITY.md
    exec-plans/
      active/
      completed/
      template.md
    decisions/
    references/
      agent-harness-principles.md
  scripts/
    dev.sh
    typecheck.sh
    lint.sh
    test.sh
    smoke.sh
```

最小版本可以先只建立：

```txt
AGENTS.md
docs/PRODUCT.md
docs/ARCHITECTURE.md
docs/AI_WORKFLOW.md
docs/TESTING.md
docs/exec-plans/
scripts/smoke.sh
```

## 核心设计思想

### 1. `AGENTS.md` 是地图，不是百科全书

`AGENTS.md` 应该短小，告诉 AI：

- 项目是什么。
- 开发前必须读哪些文档。
- 常用命令是什么。
- 做任务的标准流程是什么。
- 完成任务前必须如何验证。

不要把所有规则都塞进 `AGENTS.md`。详细内容应该放到 `docs/` 中。

### 2. 仓库是记录系统

AI 看不到人的隐性知识、聊天记录、会议结论、Slack/飞书讨论。凡是会影响未来开发判断的内容，都应该进入仓库：

- 产品目标。
- 架构决策。
- 业务约束。
- 设计规范。
- 测试策略。
- 技术债务。
- 执行计划。
- 已完成任务的记录。

### 3. 长任务必须有执行计划

复杂任务不要只存在于聊天上下文里。应该创建 `docs/exec-plans/active/*.md`，把目标、范围、步骤、验证方式和进度写清楚。

下一轮 AI 接手时，先读计划，再继续推进。

### 4. 完成标准必须可验证

不要让 AI 用“看起来完成了”作为结束标准。每个任务都应该尽量绑定可执行验证：

- typecheck
- lint
- unit test
- integration test
- e2e test
- smoke test
- manual/browser validation

### 5. 反复出现的问题要升级成规则

如果 AI 经常犯同类错误，不要只在 prompt 里反复提醒。应该把问题沉淀为：

- 文档规则。
- lint 规则。
- 测试用例。
- 结构检查脚本。
- 架构约束。
- 项目模板。

## `AGENTS.md` 模板

```md
# AGENTS.md

## Role

You are working as an implementation agent for this project.

Your job is to make small, verifiable changes, keep the repository clean, and update project knowledge when needed.

## Project Map

Read these files before making changes:

1. `docs/PRODUCT.md`
2. `docs/ARCHITECTURE.md`
3. `docs/AI_WORKFLOW.md`
4. `docs/ENGINEERING_STANDARDS.md`
5. `docs/TESTING.md`

For frontend work, also read:

- `docs/FRONTEND.md`

For security-sensitive work, also read:

- `docs/SECURITY.md`

## Working Rules

- Check `git status` before editing.
- Prefer small, incremental changes.
- Do not make unrelated refactors.
- Do not overwrite user changes.
- Do not mark work complete without running validation.
- Update docs when behavior, architecture, or workflow changes.
- If a task spans multiple sessions, create or update an execution plan in `docs/exec-plans/active/`.
- If existing docs conflict with code, trust the code first, then update the docs.

## Long-Running Tasks

For complex or multi-step work:

1. Create an execution plan under `docs/exec-plans/active/`.
2. Break the task into verifiable steps.
3. Update the progress log after each meaningful change.
4. Move the plan to `docs/exec-plans/completed/` when done.

## Commands

Use these scripts when available:

```bash
./scripts/dev.sh
./scripts/typecheck.sh
./scripts/lint.sh
./scripts/test.sh
./scripts/smoke.sh
```

## Validation

Before finishing, run the relevant checks.

At minimum:

```bash
./scripts/typecheck.sh
./scripts/lint.sh
./scripts/test.sh
```

For user-facing or workflow changes, also run:

```bash
./scripts/smoke.sh
```

If a command cannot run, explain why and describe the remaining risk.

## Completion Report

At the end, report:

- What changed.
- What validation was run.
- What remains risky or unverified.
- Which files are most relevant for review.
```

## `docs/PRODUCT.md` 模板

```md
# Product

## Purpose

Describe what this product does and why it exists.

## Target Users

- User type 1
- User type 2

## Core Workflows

1. Workflow A
2. Workflow B
3. Workflow C

## In Scope

- Feature area 1
- Feature area 2

## Out of Scope

- Explicit non-goal 1
- Explicit non-goal 2

## Product Principles

- Principle 1
- Principle 2
- Principle 3

## Important Terms

| Term | Meaning |
| --- | --- |
| Example | Definition |
```

## `docs/ARCHITECTURE.md` 模板

```md
# Architecture

## Overview

Describe the high-level architecture in a few paragraphs.

## Tech Stack

- Frontend:
- Backend:
- Database:
- Auth:
- Deployment:
- Observability:

## Directory Map

```txt
src/
  ...
```

## Module Boundaries

Describe major modules and what each owns.

## Data Flow

Describe how data moves through the system.

## Dependency Rules

- Rule 1
- Rule 2
- Rule 3

## External Services

| Service | Purpose | Integration Point |
| --- | --- | --- |
| Example | Example | Example |

## Known Tradeoffs

- Tradeoff 1
- Tradeoff 2
```

## `docs/AI_WORKFLOW.md` 模板

```md
# AI Workflow

## Goal

This repository is designed for agent-assisted development.

The agent should be able to:

1. Understand the product from local docs.
2. Understand the architecture from local docs.
3. Run the project locally.
4. Make a small change.
5. Validate the change.
6. Leave clear progress notes.
7. Continue work across sessions.

## Standard Task Flow

1. Read `AGENTS.md`.
2. Read relevant docs.
3. Check `git status`.
4. Create an execution plan for complex work.
5. Make one small, verifiable change.
6. Run relevant validation.
7. Update docs or execution plans if needed.
8. Report changes, validation, and risk.

## Long Task Rules

- Do not rely on chat history for task state.
- Keep task state in `docs/exec-plans/active/`.
- Keep progress logs concise and factual.
- Mark a step complete only after validation.

## Handoff Rules

Before ending a long task session:

- Update the active execution plan.
- Record what was changed.
- Record what was validated.
- Record what should happen next.
```

## `docs/ENGINEERING_STANDARDS.md` 模板

```md
# Engineering Standards

## General Rules

- Prefer simple, explicit code.
- Follow existing project patterns.
- Do not introduce new abstractions without clear benefit.
- Keep changes scoped to the task.
- Do not mix feature work with unrelated refactors.

## Error Handling

- Define expected errors explicitly.
- Surface actionable error messages.
- Do not swallow errors silently.

## Logging

- Use structured logs where possible.
- Include request or job identifiers when available.
- Do not log secrets or sensitive user data.

## Data Validation

- Validate external inputs at system boundaries.
- Prefer typed schemas for API contracts.
- Do not infer unknown data shapes by guesswork.

## Review Standards

Before considering work complete:

- Code is readable.
- Behavior matches product docs.
- Relevant tests pass.
- Docs are updated if behavior changed.
```

## `docs/TESTING.md` 模板

```md
# Testing

## Commands

```bash
./scripts/typecheck.sh
./scripts/lint.sh
./scripts/test.sh
./scripts/smoke.sh
```

## Test Strategy

- Unit tests cover pure logic.
- Integration tests cover module boundaries.
- E2E or smoke tests cover critical user workflows.

## Critical Workflows

These workflows should not regress:

1. Workflow A
2. Workflow B
3. Workflow C

## When To Add Tests

Add or update tests when:

- Adding user-facing behavior.
- Fixing a bug.
- Changing API contracts.
- Changing data models.
- Changing auth, billing, permissions, or security-sensitive code.

## Manual Validation

For UI changes, validate in a real browser when possible.
Record the browser, route, and workflow tested.
```

## `docs/FRONTEND.md` 模板

```md
# Frontend

## Design Principles

- Prioritize clarity and task completion.
- Match the product domain and user expectations.
- Use existing design tokens and components.
- Avoid one-off visual patterns unless intentionally introduced.

## Layout Rules

- Keep controls predictable and easy to scan.
- Avoid text overflow on small screens.
- Use stable dimensions for fixed-format UI elements.
- Do not use decorative complexity without product value.

## Interaction Rules

- Use standard controls for standard interactions.
- Provide loading, empty, error, and success states.
- Make important actions discoverable.

## Validation

For frontend changes:

- Run typecheck and tests.
- Start the app.
- Validate the affected user path in browser.
- Check responsive behavior when relevant.
```

## `docs/SECURITY.md` 模板

```md
# Security

## Sensitive Areas

- Authentication
- Authorization
- User data
- Payments
- Secrets
- Admin functionality

## Rules

- Never commit secrets.
- Do not log sensitive user data.
- Validate all external input.
- Enforce authorization server-side.
- Prefer deny-by-default access rules.

## Required Review

Security-sensitive changes require explicit human review before merge.
```

## `docs/exec-plans/template.md`

```md
# Execution Plan: <task-name>

## Goal

Describe the outcome.

## Context

Link relevant docs, files, issues, or decisions.

## Scope

- In scope item 1
- In scope item 2

## Non-goals

- Non-goal 1
- Non-goal 2

## Implementation Steps

- [ ] Step 1
- [ ] Step 2
- [ ] Step 3

## Validation

- [ ] `./scripts/typecheck.sh`
- [ ] `./scripts/lint.sh`
- [ ] `./scripts/test.sh`
- [ ] `./scripts/smoke.sh`

## Progress Log

- YYYY-MM-DD: Plan created.

## Open Questions

- Question 1

## Completion Notes

Record final behavior, validation results, and follow-up work.
```

## `docs/references/agent-harness-principles.md` 模板

```md
# Agent Harness Principles

## Core Idea

This repository is designed for agent-assisted development.

The agent should be able to:

1. Understand the product from local docs.
2. Understand the architecture from local docs.
3. Run and validate the project locally.
4. Make small, reviewable changes.
5. Continue work across sessions.

## Principles

- The repository is the source of truth.
- `AGENTS.md` is a map, not a manual.
- Long tasks require execution plans.
- Progress must be written down, not kept in chat memory.
- Validation must be executable.
- Architecture rules should be enforced by tools where possible.
- Repeated review feedback should become lint rules, tests, scripts, or docs.
- AI should not rely on hidden human context.

## Inspired By

- Anthropic: effective harnesses for long-running agents.
- Anthropic: harness design for long-running application development.
- OpenAI: harness engineering for Codex.
```

## `scripts/` 模板

脚本的具体命令应根据项目技术栈调整。即使只是包装现有命令，也建议统一入口。

### `scripts/dev.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# Replace with the project's dev command.
pnpm dev
```

### `scripts/typecheck.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

pnpm typecheck
```

### `scripts/lint.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

pnpm lint
```

### `scripts/test.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

pnpm test
```

### `scripts/smoke.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# Keep this fast and focused.
# It should verify that the app can start and critical paths still work.

pnpm test:smoke
```

## 新项目初始化清单

创建新项目时，按这个顺序落地：

1. 建立 `AGENTS.md`。
2. 建立 `docs/PRODUCT.md`，写清楚产品目标和范围。
3. 建立 `docs/ARCHITECTURE.md`，写清楚技术栈和模块边界。
4. 建立 `docs/AI_WORKFLOW.md`，写清楚 AI 如何接任务、验证、交接。
5. 建立 `docs/TESTING.md`，写清楚测试策略和命令。
6. 建立 `docs/exec-plans/template.md`。
7. 建立 `scripts/` 下的统一命令入口。
8. 在第一个复杂功能前创建 active execution plan。
9. 每次 AI 犯重复错误，把修正升级为文档、脚本、lint 或测试。
10. 定期清理过时文档和执行计划。

## 给 AI 的推荐任务提示

新项目启动时，可以这样要求 AI：

```txt
请先阅读 AGENTS.md 和 docs/ 下的项目文档。
如果当前任务较复杂，请先在 docs/exec-plans/active/ 下创建执行计划。
实现时保持小步提交思路，优先复用现有模式。
完成后运行相关验证，并在最终回复中说明修改内容、验证结果和未验证风险。
```

具体开发任务可以这样写：

```txt
请按照仓库中的 AI 工作流实现 <功能名称>。
要求：
1. 先确认相关产品和架构文档。
2. 如果范围超过一个文件或一个步骤，创建 execution plan。
3. 实现后运行 typecheck、lint、test 和 smoke。
4. 如有行为或架构变化，更新 docs。
5. 最终说明变更、验证和剩余风险。
```

## 何时升级 Harness

先从轻量版本开始。只有当你遇到真实问题时，再逐步增加复杂度。

适合升级的信号：

- AI 经常忘记项目背景。
- AI 经常改错模块。
- AI 经常声明完成但没有验证。
- 多轮任务无法顺利接力。
- 相同 review 意见反复出现。
- 文档和代码经常不一致。
- UI 或关键流程经常回归。

对应升级方式：

- 忘记背景：补充 `docs/` 和 `AGENTS.md` 链接。
- 改错模块：补充架构边界和目录说明。
- 不验证：增加脚本和完成标准。
- 接力失败：使用 execution plan 和 progress log。
- 重复 review：升级成 lint、测试或文档规则。
- 文档腐烂：增加文档维护任务。
- 关键流程回归：增加 smoke/e2e 测试。

## 最终原则

AI 开发能力的上限，不只取决于模型，也取决于工程环境。

一个适合 AI 长期参与的新项目，应该让仓库自己回答这些问题：

- 这个产品要做什么？
- 哪些东西不做？
- 系统如何组织？
- 什么是正确的实现方式？
- 什么是不允许破坏的边界？
- 如何启动和验证？
- 当前任务进展到哪里？
- 下一轮 AI 应该从哪里继续？

当这些答案都能在仓库中找到，并且尽可能可执行、可检查、可验证，AI 才能稳定地参与长期工程开发。
