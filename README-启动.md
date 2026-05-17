# jcode 启动方式

## 1. 交互式 TUI 模式（推荐）

```powershell
# 启动交互式会话
.\start-jcode.ps1
```

## 2. 单行命令模式

```powershell
# 执行单个命令
.\jcode-run.ps1 "用 Python 写个快速排序"

# 或
.\jcode-run.ps1 "解释什么是递归函数"
```

## 3. 手动启动

```powershell
# 设置环境变量
$env:JCODE_NO_TELEMETRY = "1"
$env:JCODE_PROVIDER_CUSTOM_QWEN3_6_API_KEY = "l"

# 启动 TUI
.\target\release\jcode.exe --provider-profile custom-qwen3-6 --model qwen3.6

# 或单行命令
.\target\release\jcode.exe --provider-profile custom-qwen3-6 --model qwen3.6 run "hello"
```

## 当前配置

| 配置项 | 值 |
|--------|-----|
| Provider | custom-qwen3-6 |
| 模型 | qwen3.6 |
| API 地址 | http://192.168.4.3:1234/v1 |
| 提示词风格 | 聪明原始人 |
