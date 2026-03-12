Add-Type -AssemblyName System.Windows.Forms
 
while ($true) {
    [System.Windows.Forms.SendKeys]::SendWait("^{TAB}")
    Start-Sleep -Seconds 10
}