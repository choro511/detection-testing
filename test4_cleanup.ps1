# EDR Test Script 4: Cleanup
if (Test-Path "c:\edrtest") {
    Remove-Item -Path "c:\edrtest" -Recurse -Force -ErrorAction SilentlyContinue
}

try {
    Unregister-ScheduledTask -TaskName "edrtest" -Confirm:$false -ErrorAction SilentlyContinue
} catch {}

net user sh123 /delete 2>$null
