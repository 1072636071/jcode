# 示例：完整流程

## 用户请求

修复产品详情页的价格显示问题，价格没有正确格式化。

## Step 1：阅读项目文档

读取 `docs\文档索引.md` 和 `docs\组件设计\product-card.md`。

## Step 2：决策树分析

- 问题1：价格格式化是指哪种格式？（货币符号、小数点、千位分隔符？）
  - 推荐：货币符号 + 千位分隔符
- 问题2：涉及哪些文件？
  - 推荐：`src/components/ProductCard.astro`、`src/utils/priceFormatter.ts`
- 继续追问，直到所有分支明确。

## Step 3：生成 Spec

保存为 `docs/规范/price-display-fix-spec.md`。
包含：范围、约束、已知陷阱、验收检查。

## Step 4：生成 Plan

保存为 `docs/执行计划/price-display-fix-plan.md`。
包含：涉及文件、步骤、测试变更、回滚备注。

## Step 5-10

创建团队、启动 Agent、执行、审查、测试、文档同步、解散团队。
