ping example.com -n 1 | Out-Null
ping misdepatrment.com -n 1 | Out-Null

ipconfig /all | Out-Null
arp -a | Out-Null
wmic useraccount get /ALL | Out-Null

$desktopPath = [Environment]::GetFolderPath("Desktop")

try {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile("https://github.com/choro511/detection-testing/raw/refs/heads/main/Malcon.exe", "$desktopPath\Malcon.exe")
} catch {}

try {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile("https://github.com/choro511/detection-testing/raw/refs/heads/main/calc.exe", "$desktopPath\calc.exe")
} catch {}

Start-Sleep -Seconds 10

if (Test-Path "$desktopPath\Malcon.exe") {
    Remove-Item "$desktopPath\Malcon.exe" -Force -ErrorAction SilentlyContinue
}

if (Test-Path "$desktopPath\calc.exe") {
    Remove-Item "$desktopPath\calc.exe" -Force -ErrorAction SilentlyContinue
}
