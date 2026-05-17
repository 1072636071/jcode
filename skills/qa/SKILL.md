---
name: qa
description: >
  交互式 QA 会话，用户以对话方式报告 bug 或问题，智能体创建项目本地 issue 文档。
  Interactive QA session where user reports bugs conversationally and agent creates project-local issue documents.
  触发 / Triggers: "QA", "QA session", "报告 bug", "report bugs",
  "做 QA", "do QA", "提交 issue", "file issues".

# ⚠️ 核心原则（强制执行）

1. **必须与用户结对核实**：所有判断和决定必须先与用户确认，禁止智能体自行决定。
2. **禁止自主决策**：范围评估、issue 拆分、优先级排序等任何判断，都必须询问用户意见。
3. **核实后才能行动**：创建文档、修改代码、确认复现步骤等，必须先得到用户明确确认。

---

# QA 会话 / QA Session

运行交互式 QA 会话。用户描述他们遇到的问题。你澄清、探索代码库获取上下文，并编写耐用、以用户为中心、使用项目领域语言的 issue 文档。
Run an interactive QA session. User describes problems. You clarify, explore codebase for context, and write durable, user-focused issue documents using the project's domain language.

## 对用户提出的每个 issue / For Each Issue

### 1. 倾听并轻度澄清 / Listen and Lightly Clarify

让用户用他们自己的话描述问题。问**最多 2-3 个简短的澄清问题**，聚焦：

- 他们期望发生什么 vs 实际发生了什么
- 复现步骤（如果不明显）
- 是稳定的还是间歇的

不要过度追问。如果描述足够清晰可以提交，继续。

### 2. 在后台探索代码库 / Explore Codebase in Background

与用户交谈时，在后台启动一个 Agent（subagent_type=Explore）来理解相关区域。目标**不是**找到修复——而是：

- 学习该区域使用的领域语言（检查 UBIQUITOUS_LANGUAGE.md）
- 理解功能应该做什么
- 识别面向用户的行为边界

这个上下文帮助你编写更好的 issue——但 issue 本身**不应该**引用特定文件、行号或内部实现细节。

### 3. 评估范围：单个 issue 还是拆分？（必须与用户核实）

> ⚠️ **禁止自行决定**：必须向用户确认范围，不能智能体自己拆分。

询问用户：
> "这个问题是一个独立问题，还是包含多个不同的问题？"

- 如果用户说"多个问题"，请用户逐一描述每个问题，再逐一创建 issue
- 如果用户说"一个独立问题"，则创建单个 issue

**参考准则（仅供用户参考，不自行判断）**：

在以下情况可能需要拆分：

- 修复跨越多个独立区域（例如"表单验证错了 AND 成功消息缺失 AND 重定向坏了"）
- 存在明显可分离的关注点，不同的人可以并行处理
- 用户描述的东西有多个不同的失败模式或症状

在以下情况保持单个 issue：

- 是一个行为在一个地方错了
- 症状都由同一个根行为导致

### 4. 创建项目本地 issue 文档 / Create Local Issue Documents

> ⚠️ **必须先与用户核实确认**：在创建 issue 文档前，必须向用户展示 issue 草稿并获得明确确认。

**流程**：
1. 先向用户口头描述 issue 草稿内容（标题、问题描述、期望行为、复现步骤）
2. 询问用户："这份 issue 描述是否准确？有需要补充或修改的地方吗？"
3. 用户确认后，才在 `docs/issues/` 目录下创建 Markdown issue 文档

Issues 必须是**耐用的**——它们应该在重大重构后仍然有意义。从用户视角书写。

文件命名格式：`YYYY-MM-DD-<简短描述>.md`

#### 单个 issue / Single Issue

使用此模板：

```markdown
# <标题>

## What happened

[用平实语言描述用户经历的实际行为]

## What I expected

[描述期望行为]

## Steps to reproduce

1. [开发者可以遵循的具体编号步骤]
2. [使用代码库的领域术语，不是内部模块名]
3. [包含相关输入、标志或配置]

## Additional context

[任何来自用户或代码库探索的额外观察，帮助框定 issue——使用领域语言但不要引用文件]
```

#### 拆分（多个 issues）/ Breakdown

按依赖顺序（先阻塞者）创建文档，以便你可以在 "Blocked by" 中引用其他 issue 文件名。

对每个子 issue 使用此模板：

```markdown
# <标题>

## Parent issue

`YYYY-MM-DD-<parent>.md`（如果你创建了跟踪 issue）或"QA 会话期间报告"

## What's wrong

[描述此特定行为问题——只是这个切片，不是整个报告]

## What I expected

[此特定切片的期望行为]

## Steps to reproduce

1. [专属于 THIS issue 的步骤]

## Blocked by

- `YYYY-MM-DD-<issue>.md` (如果此 issue 在另一个解决之前无法修复)
```

如果没有阻塞者，询问用户："这个 issue 有没有依赖其他 issue 需要先解决？"

## Additional context

[任何与此切片相关的额外观察]
```

创建拆分时：

- **偏好许多薄 issue 而非少数厚 issue**——每个应该独立可修复和可验证
- **诚实地标记阻塞关系**——如果 issue B 确实在 issue A 修复之前无法测试，说出来
- **按依赖顺序创建 issues** 以便你可以在 "Blocked by" 中引用其他 issue
- **最大化并行性**——目标是多个人（或智能体）可以同时处理不同 issues

#### 所有 issue 正文的规则 / Rules for All Issues

- **没有文件路径或行号**——它们会过时
- **使用项目的领域语言**（检查 UBIQUITOUS_LANGUAGE.md 是否存在）
- **描述行为，不是代码**——"the sync service fails to apply the patch" 不是 "applyPatch() throws on line 42"
- **复现步骤是强制的**——如果你无法确定，问用户
- **保持简洁**——开发者应该能在 30 秒内读完 issue

创建后，打印所有 issue 文件路径（附带阻塞关系摘要），然后**询问用户确认下一步**：

> "是否立即修复这个 issue？（是 / 否 / 修复全部）"

- **如果用户选择修复单个 issue**（是）：
  - 退出 QA 收集模式，针对该 issue 进入代码修复流程。
  - 使用 `read_file`、`search_content` 等工具定位相关代码，分析根因并实施修复。
  - 修复完成后，回到 QA 会话并问："下一个问题，还是我们结束了？"

- **如果用户选择不修复**（否）：
  - 直接问："下一个问题，还是我们结束了？"

- **如果用户选择修复全部**（适用于当前会话中已创建的多个 issues）：
  - **每个 issue 修复前，必须先向用户说明修复计划并获得确认**
  - 按依赖顺序逐个修复，每个修复完成后向用户说明改动内容
  - 全部修复完成后询问："还有新的问题要报告吗？"

### 5. 继续会话 / Continue Session

> ⚠️ **每一步都要与用户核实**：不要假设用户意图，不要批量处理问题。

继续直到用户明确说结束。每次询问用户确认：
> "还有其他问题要报告吗？还是有其他需要我核实的内容？"
