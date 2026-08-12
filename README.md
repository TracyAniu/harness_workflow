# harness_workflow

一套可移植的 **AI 长期开发工作流**（agent harness）：把「建轨道 → 跑轨道 → 养轨道」的闭环同时封装为 **Claude Code skills** 和 **Codex 自定义 prompts**，一条命令装到任意机器，多台机器用 git 保持一致。

```txt
理解产品 → 理解架构 → 找到任务上下文 → 修改代码 → 运行验证 → 记录进度 → 交接下一轮
```

## 包含什么

| 目录 | 内容 |
|---|---|
| `claude-skills/` | Claude Code 三件套：`harness-init`（项目初始化，含 5 份模板）/ `harness-task`（每轮任务六步标准流）/ `harness-maintain`（熵回收与规则升级） |
| `codex-prompts/` | 同一套流程的 Codex 版：`/harness-init` `/harness-task` `/harness-maintain` 斜杠命令 |
| `global/` | 写入全局配置的片段：`claude-global.md` → `~/.claude/CLAUDE.md`，`codex-global.md` → `~/.codex/AGENTS.md`（含中文触发语映射） |
| `references/` | 方法论来源的三篇笔记：project-harness 模板、Anthropic 长时程 agent harness、OpenAI Codex harness engineering |
| `install.sh` / `install.ps1` | 幂等安装脚本（macOS/Linux / Windows） |

## 安装

```bash
# macOS / Linux
git clone https://github.com/TracyAniu/harness_workflow.git
cd harness_workflow && ./install.sh
```

```powershell
# Windows
git clone https://github.com/TracyAniu/harness_workflow.git
cd harness_workflow
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

安装脚本做三件事：

1. 复制三个 skills 到 `~/.claude/skills/`（覆盖式，以仓库为准）。
2. 复制三个 prompts 到 `~/.codex/prompts/`。
3. 在 `~/.claude/CLAUDE.md` 与 `~/.codex/AGENTS.md` 里维护一个 `<!-- harness-kit:BEGIN/END -->` 标记块——只更新块内内容，**块外的机器专属配置原样保留**。重复运行安全。

## 更新流程

改流程只改本仓库，然后各机器：

```bash
git pull && ./install.sh        # Windows: git pull; powershell -File install.ps1
```

标记块内的内容会被安装脚本覆盖，不要手改；机器专属的规则写在块外。

## 使用

| 场景 | Claude Code | Codex |
|---|---|---|
| 项目接入（一次性） | 「给这个项目搭 harness」 | `/harness-init` |
| 日常开发 | 「开工」/「按开发流实现 X」 | `/harness-task [任务]` 或「开工」 |
| 跨会话大任务接力 | 「继续 <任务名>」 | 「继续 <任务名>」 |
| 定期维护 | 「harness 维护」 | `/harness-maintain` |

约定：单会话小任务用 `tasks/todo.md`；跨会话大任务用 `docs/exec-plans/active/*.md` + Progress Log；项目地图以 AGENTS.md 为正典（Claude 和 Codex 共读一份），项目 CLAUDE.md 只放一行 `@AGENTS.md`。

## 验证安装

- Claude Code：输 `/skills`，应看到 `harness-init` / `harness-task` / `harness-maintain`。
- Codex：输 `/har`，补全应列出三个命令。
