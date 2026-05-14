while ($true) {
    Get-Variable | Remove-Variable -Force -ErrorAction SilentlyContinue
    Clear-Host

    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host "      FILE NAME REPLACER TOOL" -ForegroundColor Cyan
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""

    # Ask user for folder path
    $folderPath = Read-Host "Enter the exact folder path"
    $folderPath = $folderPath.Replace('"','')

    # Ask what text should be replaced
    $findText = Read-Host "Enter the text to replace (FROM)"

    # Ask replacement text
    $replaceText = Read-Host "Enter the replacement text (TO)"

    # Get files
    Get-ChildItem -Path $folderPath -File | ForEach-Object {

        $newName = $_.Name -replace $findText, $replaceText

        if ($newName -ne $_.Name) {
            Rename-Item -Path $_.FullName -NewName $newName
            Write-Host "Renamed:" $_.Name "->" $newName
        }
    }

    Write-Host ""
    Write-Host "Process completed!" -ForegroundColor Green

    # Ask if user wants to run again
    $again = Read-Host "Do you want to run again? (Y/N)"

    if ($again -ne "Y" -and $again -ne "y") {
        break
    }
}