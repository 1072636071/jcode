---
name: axcv
description: 当用户提出复杂的开发需求、功能修复或需要多 Agent 协作的任务时，此技能应被触发。它驱动 XCV（A开发组系列 Agent 团队）自动创建团队、制定计划并执行解决问题。整合决策树追问（grill-me）和五类结构化 Prompt（Spec/Plan/Diff/Test/Review），无需用户在计划阶段确认，且强制同步更新项目文档。
---

# AXCV - XCV 团队驱动技能

## Overview

AXCV 技能将用户的复杂开发任务自动转化为 XCV 团队的协同执行流程。XCV 指由 A开发组开头的多个专业 Agent（开发者、架构师、代码审查、测试头头、测试执行者等）组成的团队。

本技能整合：
- **决策树追问机制**（来自 `grill-me`）：在需求分析阶段层层剖析，覆盖所有决策分支
- **五类结构化 Prompt**：Spec（规范）、Plan（计划）、Diff（最小化变更）、Test（测试）、Review（审查）

## When to Use

以下场景无条件优先使用此技能：
- 用户要求开发新功能、修改现有功能或修复缺陷
- 任务涉及多个步骤、多个文件或需要架构设计/代码审查/测试
- 用户提及 "XCV"、"A开发组"、"创建团队"、"制定计划并执行" 等关键词
- 任何复杂到需要拆分为多步骤执行计划的需求

## When NOT to Use

以下场景不使用此技能，由主 Agent 直接处理：
- 简单单文件修改（如改一个字符串、调一个样式值）
- 纯文档编辑（不涉及代码变更）
- 无需代码审查和测试的微小变更

## Main Agent Responsibilities

主 Agent（即当前使用此技能的 CodeBuddy 实例）承担以下职责：

1. **读取文档**：读取 `docs\文档索引.md` 及相关模块文档
2. **决策树分析**：对需求进行自动分析，生成决策树结果
3. **生成规范**：输出 Spec 文件到 `docs/规范/`
4. **生成计划**：输出 Plan 文件到 `docs/执行计划/`
5. **创建团队**：使用 `team_create` 创建 XCV 团队
6. **协调通信**：通过 `send_message` 在各 Agent 之间传递状态
7. **汇总结果**：收集各 Agent 产出，整合最终交付物
8. **文档同步**：确保 `docs/` 目录与代码变更保持一致
9. **解散团队**：向所有成员发送 `shutdown_request`，确认后调用 `team_delete`

**Agent 执行顺序**：
1. 架构师首先完成，输出文件依赖图
2. 开发者获取文件锁，按依赖顺序修改代码
3. 测试 Agent 收到开发者完成通知后执行测试
4. 审查 Agent 收到测试通过通知后开始审查

## Workflow

### Step 1: 阅读项目文档

- 制定任何计划前，首先读取 `docs\文档索引.md`（或项目对应的文档索引）
- 根据任务涉及的功能模块，进一步读取相关的架构文档、组件设计文档、测试文档等
- 记录关键约束。完整约束清单见 `references/project-constraints.md`

### Step 2: 决策树需求分析

使用决策树机制对需求进行自动剖析：

1. **遍历分支**：沿着设计树的每个分支走下去，逐个解决决策之间的依赖关系
2. **探索代码库**：对可通过代码库验证的问题，优先读取相关文件获取答案
3. **生成推荐**：对每个决策点，生成推荐答案并记录依据

**输出**：决策树分析结果（Markdown 格式）

```markdown
## 决策树分析结果
### 分支1：[决策点描述]
- 问题：[具体问题]
- 推荐答案：[推荐]
- 依赖：[依赖的其他决策]
```

**决策冲突处理规则**：
1. 需求 vs 项目约束冲突 → 优先项目约束，记录到 Spec 的"已知陷阱"
2. 多分支歧义 → 选择最符合移动端优先原则的分支
3. 无法自动决策 → 记录到 `docs/规范/[任务名]-待确认.md`，继续执行其他明确部分
4. 探索代码库后仍无法回答 → 给出 2-3 个选项供用户选择，标注"推荐"

**注意**：此阶段以自动分析为主，将决策树结果直接作为 Spec Prompt 的输入，无需逐一向用户确认。

### Step 3: 生成结构化规范

根据决策树分析结果，使用 **Spec Prompt** 将需求转化为结构化规范。

Spec Prompt 模板见 `references/prompts/spec-prompt.md`。

- 将生成的结构化规范保存到 `docs/规范/` 目录下
- 规范文件作为后续 Plan Prompt 的输入

### Step 4: 生成实施计划

使用 **Plan Prompt** 根据结构化规范生成详细的实施计划。

Plan Prompt 模板见 `references/prompts/plan-prompt.md`。

- 将生成的实施计划保存到 `docs/执行计划/` 目录下
- 计划制定完成后，无需用户确认，立即进入执行阶段

### Step 5: 创建 XCV 团队

- 使用 `team_create` 工具创建团队，团队名使用小写连字符格式（如 `feature-alpha`、`bugfix-team`）
- 团队描述中简述本次目标、涉及的功能模块、以及引用规范文件和计划文件路径

### Step 6: 并行启动 Agent

根据任务需要，使用 `task` 工具并行启动以下 Agent。使用 `subagent_path` 引用本技能 bundled 的 Agent 定义文件（位于 `references/agents/` 目录）。

| 角色 | subagent_path | 职责 |
|------|---------------|------|
| 架构师 | `references/agents/架构师Agent.md` | 负责系统架构设计、技术选型、数据库设计和 API 规范定义 |
| 开发者 | `references/agents/开发者.md` | 根据设计文档实现代码、编写测试、重构优化和修复缺陷 |
| 代码审查 | `references/agents/代码审查.md` | 代码质量保障、安全漏洞扫描、性能优化建议和最佳实践检查 |
| 测试负责 | `references/agents/测试Agent.md` | 测试策略制定、用例生成、执行管理、结果分析和报告生成 |
| 测试执行 | `references/agents/A测试执行者.md` | 执行功能测试、界面/UI测试、兼容性测试、性能测试并记录结果 |

启动时：
- 为每个 Agent 分配清晰的 `description` 和 `prompt`
- 使用 `subagent_path` 参数（而非 `subagent_name`）指向 bundled 的 Agent 定义文件
- `prompt` 中包含：任务背景、规范文件路径、计划文件路径、需要修改的文件范围、以及输出要求
- 若任务不需要某角色，直接省略

**文件锁机制（避免并发冲突）**：
1. 架构师首先输出文件依赖图（哪些文件被依赖，哪些文件依赖其他文件）
2. 开发者按依赖顺序获取"文件锁"：
   - 先修改被依赖的文件（如 `config/priceMap.ts`）
   - 再修改依赖它的文件（如 `components/ProductCard.astro`）
3. 修改前，使用 `read_file` 确认文件当前内容；若与预期不符，发送消息请求主 Agent 重新协调
4. 使用 `send_message` 协调机制：
   - 开发者 → 测试者：`"文件 X 已修改完成，可以开始测试"`
   - 测试者 → 审查者：`"测试通过，请审查"`
5. **禁止操作**：
   - 多个 Agent 同时修改同一文件
   - 在未收到前置文件完成通知前修改依赖文件

### Step 7: 使用结构化 Prompt 指导 Agent 执行

各 Prompt 模板存放于 `references/prompts/` 目录：

| Prompt 类型 | 用途 | 使用阶段 | 模板路径 |
|-------------|------|----------|----------|
| Diff Prompt | 最小化代码变更 | 开发者 Agent | `references/prompts/diff-prompt.md` |
| Test Prompt | 生成针对性测试 | 测试 Agent | `references/prompts/test-prompt.md` |
| Review Prompt | AI 辅助审查 | 代码审查 Agent | `references/prompts/review-prompt.md` |

### Step 8: 监控执行与团队协调

- 通过 `send_message` 与各 Agent teammate 沟通，获取进展
- 收集各 Agent 的执行结果

**进度反馈机制**：
每完成一个 Step，向用户发送简报：
```
[进展] Step X/Y 完成 - [角色名] 已完成 [具体产出]
```

**容错机制与失败判定标准**：

失败判定标准：
- **开发者 Agent**：
  - 失败1：代码无法编译（`read_lints` 报错）
  - 失败2：修改后的代码不符合 Spec 验收检查
- **测试 Agent**：
  - 失败1：Playwright 测试无法运行
  - 失败2：生成的测试用例覆盖不了 Spec 中的验收检查
- **审查 Agent**：
  - 失败1：无法读取 Diff（文件已被其他 Agent 修改）
  - 失败2：审查报告发现 critical 级别问题未修复

失败处理流程：
- Agent 连续失败 2 次 → 终止该 Agent，通知主进程手动处理
- 多 Agent 输出冲突 → 以 Spec Prompt 的验收检查为准，开发者与审查分歧时优先安全/正确性
- 文档同步失败 → 记录到执行日志，不阻塞功能交付

### Step 9: 功能完成后的文档同步

- 开发/修复/测试工作完成后，同步修改 `docs/` 目录下相关的文档
- 确保所有变更（新增、删除、修改的功能）都在文档中有准确反映
- 保证文档的绝对有效和绝对真实
- 更新 `docs/文档索引/10-更新日志.md` 等变更记录文档

### Step 10: 团队解散

- 向所有活跃的 team member 发送 `shutdown_request`
- 等待所有 `shutdown_response` 确认后，调用 `team_delete` 解散团队

## Key Rules

1. **文档优先**：任何开发/修复任务开始前，读取 `docs\文档索引.md`
2. **决策树分析**：需求分析阶段使用决策树自动分析，覆盖所有决策分支
3. **规范先行**：使用 Spec Prompt 生成结构化规范，作为计划的基础
4. **计划落盘**：执行计划必须写入 `docs/执行计划/*.md`，不能只存在于对话中
5. **自动执行**：计划制定完成后，无需用户确认，立即进入执行阶段
6. **最小化变更**：开发者 Agent 使用 Diff Prompt，生成最小补丁
7. **针对性测试**：测试 Agent 使用 Test Prompt，覆盖边界情况
8. **AI 辅助审查**：代码审查 Agent 使用 Review Prompt，检查关键问题
9. **文档同步**：功能变更（增删改）同步更新 docs 目录下的对应文档
10. **项目约束**：完整约束清单见 `references/project-constraints.md`

## 辅助文件索引

| 文件 | 用途 |
|------|------|
| `references/project-constraints.md` | 统一项目约束（技术栈、代码规范、开发流程） |
| `references/prompts/spec-prompt.md` | Spec Prompt 模板 |
| `references/prompts/plan-prompt.md` | Plan Prompt 模板 |
| `references/prompts/diff-prompt.md` | Diff Prompt 模板 |
| `references/prompts/test-prompt.md` | Test Prompt 模板 |
| `references/prompts/review-prompt.md` | Review Prompt 模板 |
| `references/templates/prompt-cheatsheet.md` | Prompt 类型速查表 |
| `references/templates/file-naming-convention.md` | 文件命名规范 |
| `references/examples/complete-workflow.md` | 完整流程示例 |
| `references/agents/架构师Agent.md` | 架构师 Agent 定义 |
| `references/agents/开发者.md` | 开发者 Agent 定义 |
| `references/agents/代码审查.md` | 代码审查 Agent 定义 |
| `references/agents/测试Agent.md` | 测试头头 Agent 定义 |
| `references/agents/A测试执行者.md` | 测试执行者 Agent 定义 |

## 与 Grill-Me 技能的协同

本技能在 Step 2（决策树需求分析）阶段借鉴了 `grill-me` 技能的核心机制：
- 层层剖析设计树的每个分支
- 探索代码库来回答可验证的问题
- 给出推荐答案

**区别**：
- `grill-me`：用于审核计划、澄清设计、对齐决策（交互式，需要用户回答）
- `axcv` 的 Step 2：用于自动化需求分析，将决策树分析结果作为 Spec Prompt 的输入（非交互式，自动推进）
