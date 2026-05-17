# jcode 单行命令快捷脚本
# 用法: .\jcode-run.ps1 "你的问题"

$env:JCODE_NO_TELEMETRY = "1"
$env:JCODE_PROVIDER_CUSTOM_QWEN3_6_API_KEY = "l"

$prompt = $args -join " "
if (-not $prompt) {
    Write-Host "用法: .\jcode-run.ps1 `"你的问题`"" -ForegroundColor Yellow
    exit 1
}

& "$PSScriptRoot\target\release\jcode.exe" --provider-profile custom-qwen3-6 --model qwen3.6 run "$prompt"
