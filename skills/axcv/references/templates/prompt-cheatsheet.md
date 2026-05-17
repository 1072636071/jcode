# Prompt 类型速查表

| Prompt 类型 | 用途 | 使用阶段 | 输出 |
|-------------|------|----------|------|
| Spec Prompt | 将需求转化为结构化规范 | Step 3 | `docs/规范/[任务名]-spec.md` |
| Plan Prompt | 生成实施计划 | Step 4 | `docs/执行计划/[任务名]-plan.md` |
| Diff Prompt | 最小化代码变更 | Step 7.1（开发者 Agent） | 统一 Diff 格式的补丁 |
| Test Prompt | 生成针对性测试 | Step 7.2（测试 Agent） | 单元测试/集成测试代码 |
| Review Prompt | AI 辅助审查 | Step 7.3（代码审查 Agent） | 审查报告（Markdown） |
