---
name: request-refactor-plan
description: >
  通过用户访谈创建微小提交的详细重构计划，保存为项目本地文档。
  Create detailed refactor plan with tiny commits via user interview, save as project-local document.
  触发 / Triggers: "重构计划", "refactor plan", "重构 RFC", "refactoring RFC", "安全增量步骤", "safe incremental steps".
---

当用户想创建重构请求时调用。

## 步骤 / Steps

1. **收集问题** — 让用户详细描述问题 + 潜在方案
2. **探索仓库** — 验证断言，理解代码库现状
3. **展示替代方案** — 问是否考虑过其他选项
4. **层层追问** — 极其详细、彻底地追问实现细节
5. **敲定范围** — 明确改什么、不改什么
6. **检查测试覆盖** — 不足时问测试计划
7. **拆分微小提交** — 每步尽可能小，代码库始终可工作。Martin Fowler："让每个重构步骤尽可能小，这样你总能看到程序在工作。"
8. **创建重构计划文档** — 将计划保存到 `docs/设计文档/重构计划/` 目录，用下方模板

<refactor-plan-template>

## 问题陈述 / Problem Statement

开发者面临的问题。

## 解决方案 / Solution

问题的解决方案。

## 提交 / Commits

详细实现计划，通俗语言，拆成最小提交。每提交保持代码库可工作。

## 决策文档 / Decision Document

实现决策列表：

- 构建/修改的模块
- 接口如何修改
- 技术澄清
- 架构决策
- Schema 变更
- API 契约
- 特定交互

不要具体文件路径或代码片段。易过时。

## 测试决策 / Testing Decisions

测试决策列表：

- 好测试标准（只测外部行为，不测实现细节）
- 哪些模块将被测试
- 先例（代码库中类似测试）

## 超出范围 / Out of Scope

此重构不改的事项。

## 进一步说明（可选）/ Further Notes (Optional)

任何进一步说明。

</refactor-plan-template>
