Get-Variable | Remove-Variable -Force -ErrorAction SilentlyContinue
Clear-Host

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "     Generate New GUID" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$length = 16
$chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:,.<>?/\`''"'
$colors = [System.Enum]::GetValues([System.ConsoleColor])

while ($true) {
    $randomString = -join (1..$length | ForEach-Object { 
        $chars[(Get-Random -Maximum $chars.Length)] 
    })

    $randomColor = Get-Random -InputObject $colors
    Write-Host $randomString -ForegroundColor $randomColor
    Write-Host "Press Enter to generate a new GUID..." -ForegroundColor Cyan
    Write-Host ""
    Read-Host | Out-Null
}