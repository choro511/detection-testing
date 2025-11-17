# EDR Test Script 3+4: System Modification and Cleanup (Test Version)
$testPath = "$env:TEMP\edrtest"

# ディレクトリ作成
try {
    New-Item -Path $testPath -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Host "Directory created: $testPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to create directory" -ForegroundColor Red
}

# 情報収集
Write-Host "Running system commands..." -ForegroundColor Yellow
ipconfig /all | Out-Null
arp -a | Out-Null
ping misdepatrment.com -n 1 | Out-Null

# スケジュールタスク作成（現在のユーザーで）
try {
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-Command ipconfig"
    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration (New-TimeSpan -Days 1)
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
    
    Register-ScheduledTask -TaskName "edrtest" -Action $action -Trigger $trigger -Settings $settings -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Host "Scheduled task created" -ForegroundColor Green
} catch {
    Write-Host "Failed to create scheduled task: $_" -ForegroundColor Red
}

# ファイルダウンロード
try {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile("https://github.com/choro511/detection-testing/raw/refs/heads/main/calc.exe", "$testPath\calc.exe")
    Write-Host "File downloaded to $testPath\calc.exe" -ForegroundColor Green
} catch {
    Write-Host "Failed to download file: $_" -ForegroundColor Red
}

# 5秒スリープ（テスト用に短縮）
Write-Host "Sleeping for 5 seconds..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# クリーンアップ開始
Write-Host "Starting cleanup..." -ForegroundColor Yellow
if (Test-Path $testPath) {
    try {
        Remove-Item -Path $testPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Directory deleted" -ForegroundColor Green
    } catch {
        Write-Host "Failed to delete directory" -ForegroundColor Red
    }
}

try {
    Unregister-ScheduledTask -TaskName "edrtest" -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
    Write-Host "Scheduled task deleted" -ForegroundColor Green
} catch {
    Write-Host "Failed to delete scheduled task" -ForegroundColor Red
}

Write-Host "Test completed!" -ForegroundColor Green
