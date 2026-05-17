---
name: ubiquitous-language
description: >
  从对话提取 DDD 统一语言词汇表，标记歧义，提规范术语。
  Extract DDD-style ubiquitous language glossary from conversation, flag ambiguities, propose canonical terms.
  触发 / Triggers: "统一语言", "ubiquitous language", "领域术语", "domain terms", "词汇表", "glossary", "DDD".
disable-model-invocation: true
---

# 统一语言 / Ubiquitous Language

从对话提取领域术语，存为 `UBIQUITOUS_LANGUAGE.md`。

## 流程 / Process

1. **扫描对话** — 找领域名词、动词、概念
2. **识别问题**：
   - 一词多义（歧义）
   - 多词一义（同义词）
   - 模糊/重载术语
3. **提出规范词汇表** — 有主见的术语选择
4. **写入 `UBIQUITOUS_LANGUAGE.md`** — 用下方格式
5. **对话中输出摘要**

## 输出格式 / Output Format

```md
# Ubiquitous Language

## Order lifecycle

| Term        | Definition                                         | Aliases to avoid      |
| ----------- | -------------------------------------------------- | --------------------- |
| **Order**   | A customer's request to purchase one or more items | Purchase, transaction |
| **Invoice** | A request for payment sent after delivery          | Bill, payment request |

## People

| Term         | Definition                               | Aliases to avoid       |
| ------------ | ---------------------------------------- | ---------------------- |
| **Customer** | A person or organization that places orders | Client, buyer, account |
| **User**     | An authentication identity in the system | Login, account         |

## Relationships

- An **Invoice** belongs to exactly one **Customer**
- An **Order** produces one or more **Invoices**

## Example dialogue

> **Dev:** "When a **Customer** places an **Order**, do we create the **Invoice** immediately?"
> **Domain expert:** "No — an **Invoice** is only generated once **Fulfillment** is confirmed."

## Flagged ambiguities

- "account" = both **Customer** and **User**. Distinct: **Customer** places orders, **User** is auth identity.
```

## 规则 / Rules

- **有主见。** 多词同概念 → 挑最好一个，其余列"应避免别名"。
- **显式标记冲突。** 歧义术语 → "Flagged ambiguities" 叫出来，给建议。
- **只包领域相关术语。** 跳过通用编程概念（array、function、endpoint），除非有领域特定含义。
- **定义紧凑。** 最多一句。定义它**是**什么，不是它**做**什么。
- **展示关系。** 粗体术语名，表达基数。
- **自然聚类 → 多表格。** 按子域/生命周期/参与者分组。内聚领域 → 单表，不强行分组。
- **写示例对话。** 3-5 轮 dev 与领域专家对话，展示术语交互，澄清边界。

## 重新运行 / Re-running

同一会话再次调用时：

1. 读取现有 `UBIQUITOUS_LANGUAGE.md`
2. 纳入新术语
3. 更新演变的定义
4. 重新标记新歧义
5. 重写示例对话纳入新术语
