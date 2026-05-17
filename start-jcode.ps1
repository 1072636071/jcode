$env:JCODE_NO_TELEMETRY = "1"
$env:JCODE_PROVIDER_CUSTOM_QWEN3_6_API_KEY = "l"
$env:JCODE_FORCE_PROVIDER = "1"
$env:JCODE_ACTIVE_PROVIDER = "openai-compatible"

# 提示用户输入工作目录
Write-Host "`n请输入工作目录路径（直接回车使用当前目录）:" -ForegroundColor Yellow
$workDir = Read-Host

if ($workDir) {
    if (-not (Test-Path $workDir)) {
        Write-Host "错误: 目录不存在 '$workDir'" -ForegroundColor Red
        exit 1
    }
} else {
    $workDir = Get-Location
}

Write-Host "`n启动 jcode，工作目录: $(Get-Item $workDir | Select-Object -ExpandProperty Name)" -ForegroundColor Green

Start-Process -FilePath "D:\app\jcode\target\release\jcode.exe" -ArgumentList "-C", "$workDir", "--provider-profile", "custom-qwen3-6", "--model", "qwen3.6"
