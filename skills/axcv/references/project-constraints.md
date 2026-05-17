# 项目统一约束

> 根据项目实际情况更新此文件。所有 Agent 在执行任务前须阅读此文件。

## 技术栈

- 框架：Astro（SSR），组件使用 `.astro` 格式，遵循 Islands 架构
- 数据库：CloudBase 云开发（NoSQL + 云函数）
- 部署：Vercel / CloudBase

## 代码规范

- 移动端优先：所有 UI 决策优先考虑手机端体验
- 禁用下拉框：移动端使用按钮点选替代下拉框，避免遮挡输入内容
- 图片格式：统一使用 `.webp`
- 文件行数限制：单个代码文件和文档文件不超过 500 行
- Git commit 格式：`[类型] <描述>`，类型包括 feat/fix/refactor/test/docs/style/perf

## 开发流程

- 文档先行：开发/修复前必读 `docs\文档索引.md`
- 变更同步：增删改功能时同步更新 `docs` 目录，确保内容绝对真实有效
- 禁止操作：`prisma db push`
