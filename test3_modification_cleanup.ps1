# EDR Test Script 3: Simple Detection Test (Silent)

# ネットワーク通信テスト
ping example.com -n 1 | Out-Null
ping misdepatrment.com -n 1 | Out-Null

# コマンドライン実行テスト
ipconfig /all | Out-Null
arp -a | Out-Null
wmic useraccount get /ALL | Out-Null

# ファイル書き込みテスト
$desktopPath = [Environment]::GetFolderPath("Desktop")

try {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile("https://github.com/choro511/detection-testing/raw/refs/heads/main/calc.exe", "$desktopPath\cs_maltest.exe")
} catch {}

try {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile("https://github.com/choro511/detection-testing/raw/refs/heads/main/calc.exe", "$desktopPath\calc.exe")
} catch {}
