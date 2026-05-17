# Review Prompt 模板

审查此 Diff，检查以下项目：

1. 缺失的空值检查
2. 类型假设破坏（TypeScript 类型安全）
3. 安全风险（XSS、SQL 注入、权限绕过等）
4. 与 Spec 意图的偏差（对照规范文件检查）
5. 是否符合项目代码规范（详见 `references/project-constraints.md`）：
   - Astro SSR 正确性（无客户端 JS 混入服务端逻辑）
   - CloudBase DB 操作安全（权限/注入/并发）
   - 移动端优先验证（布局在窄屏下正常）
   - 图片 `.webp` 格式
   - 文档同步完成

## 占位符

- Diff：[Diff 内容]
- 规范文件：[规范文件路径]
