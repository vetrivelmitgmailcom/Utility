# Load .NET class for sending keystrokes
Add-Type -AssemblyName System.Windows.Forms
 
# Characters pool: letters (upper/lower) + numbers
$chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
 
Write-Host "Focus your VS Code tab. Typing will start in 5 seconds..."
Start-Sleep -Seconds 5
 
Write-Host "Typing started. Press Ctrl + C in this PowerShell window to stop."
 
while ($true) {
    # Pick a random character
    $char = $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)]
    # Type the character into the active window
    [System.Windows.Forms.SendKeys]::SendWait($char)
    # Wait 30 seconds before typing the next character
    Start-Sleep -Seconds 15
}