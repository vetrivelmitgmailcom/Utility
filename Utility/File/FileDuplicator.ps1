while ($true) {

Clear-Host

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "        File Generator Tool          " -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Ask Source File Path
$source = Read-Host "Enter the FULL source file path (Example: C:\Files\dummy.pdf)"
$source = $source.Replace('"','')

# Check file exists
if (!(Test-Path $source)) {
    Write-Host ""
    Write-Host "Source file not found. Please check the path." -ForegroundColor Red
    Read-Host "Press ENTER to continue"
    continue
}

Write-Host "Source file found." -ForegroundColor Green

# Get folder
$sourceFolder = Split-Path $source

# Extract extension
$extension = [System.IO.Path]::GetExtension($source)

Write-Host "Detected File Extension: $extension" -ForegroundColor Yellow
Write-Host ""

# Ask prefix
$prefix = Read-Host "Enter file name prefix (Example: TestJK)"

# Ask start number
$start = [int](Read-Host "Enter Start Number")

# Ask end number
$end = [int](Read-Host "Enter End Number")

# Ask ZIP option
Write-Host ""
$zipChoice = Read-Host "Do you want to create ZIP file? (Y/N)"

if ($zipChoice -match "^[Yy]$") {
    $zipRequired = $true
    $zipName = Read-Host "Enter ZIP file name (without .zip)"
    $zipName = "$zipName.zip"
}
else {
    $zipRequired = $false
}

Write-Host ""
Write-Host "Generating files..." -ForegroundColor Cyan

# Generate files
for ($i = $start; $i -le $end; $i++) {

    $filename = "$prefix$i$extension"
    $destFile = Join-Path $sourceFolder $filename

    Copy-Item $source $destFile -Force

    Write-Host "Created: $filename" -ForegroundColor Gray
}

Write-Host ""
Write-Host "All files generated successfully." -ForegroundColor Green

# ZIP if required
if ($zipRequired) {

    $zipPath = Join-Path $sourceFolder $zipName

    Write-Host ""
    Write-Host "Compressing files into ZIP..." -ForegroundColor Cyan

    Compress-Archive -Path "$sourceFolder\$prefix*$extension" -DestinationPath $zipPath -Force

    Write-Host "ZIP file created: $zipPath" -ForegroundColor Green

    Remove-Item "$sourceFolder\$prefix*$extension"

    Write-Host "Temporary generated files deleted." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "        Process Completed            " -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Ask to run again
$again = Read-Host "Do you want to generate another set? (Y/N)"

if ($again -notmatch "^[Yy]$") {
    Write-Host ""
    Write-Host "Exiting Tool..." -ForegroundColor Yellow
    break
}

}