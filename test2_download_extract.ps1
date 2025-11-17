# EDR Test Script 2: Download to Desktop
$downloadUrl = "https://github.com/choro511/detection-testing/raw/refs/heads/main/Malcon.zip"
$desktopPath = [Environment]::GetFolderPath("Desktop")
$outputPath = Join-Path $desktopPath "Malcon.zip"

certutil -urlcache -split -f $downloadUrl $outputPath | Out-Null
