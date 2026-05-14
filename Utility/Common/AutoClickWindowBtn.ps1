Clear-Host

Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "     Tool to Keep Windows Active During Idle Time" -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host ""

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Keyboard {
    [DllImport("user32.dll")]
    public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);
}
"@

$VK_LWIN = 0x5B  # Left Windows key virtual code
$KEYEVENTF_KEYUP = 0x0002

while ($true) {
    # Press Windows key down and release
    [Keyboard]::keybd_event($VK_LWIN, 0, 0, 0)
    Start-Sleep -Milliseconds 200
    [Keyboard]::keybd_event($VK_LWIN, 0, $KEYEVENTF_KEYUP, 0)
    Write-Host "Waiting for 30 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30  # wait 5 minutes before pressing again
}