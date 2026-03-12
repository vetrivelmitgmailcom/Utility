$length = 16
$chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:,.<>?/\`''"'
$colors = [System.Enum]::GetValues([System.ConsoleColor])

while ($true) {
    $randomString = -join (1..$length | ForEach-Object { 
        $chars[(Get-Random -Maximum $chars.Length)] 
    })

    $randomColor = Get-Random -InputObject $colors
    Write-Host $randomString -ForegroundColor $randomColor

    Read-Host | Out-Null
}