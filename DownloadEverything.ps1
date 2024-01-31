# Check if Chocolatey is installed
if (-not (Test-Path 'C:\ProgramData\chocolatey\choco.exe')) {
    # Install Chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Set-ExecutionPolicy Restricted -Scope Process -Force
}

# Install 7-Zip using Chocolatey
choco install 7zip -y

# Create a folder to store the downloaded files
$downloadFolder = "C:\Temp\DownloadedFiles"
New-Item -ItemType Directory -Force -Path $downloadFolder | Out-Null

# Specify the base URL and range for the .zip.00# files
$baseUrl = "https://github.com/angelblaisassoc/Installations/blob/5f48f1528d349a83f15705a78da313ac6b5e6767/BAInstallers.zip."
$fileRange = 1..13

# Download and save each file
foreach ($index in $fileRange) {
    $url = $baseUrl + ("{0:D3}" -f $index)
    $filename = Join-Path $downloadFolder ("BAInstallers.zip.{0:D3}" -f $index)
    Invoke-WebRequest -Uri $url -OutFile $filename
}

# Extract the files using 7-Zip
$extractedFolder = "C:\Temp\ExtractedFiles"
New-Item -ItemType Directory -Force -Path $extractedFolder | Out-Null

$zipFiles = Get-ChildItem $downloadFolder -Filter "BAInstallers.zip.*" | Sort-Object
foreach ($zipFile in $zipFiles) {
    $extractCommand = "7z x `"$($zipFile.FullName)`" -o`"$extractedFolder`" -r -y"
    Invoke-Expression $extractCommand
}

# Clean up: Remove the downloaded .zip.00# files
Remove-Item $downloadFolder -Recurse -Force

Write-Host "Extraction and installation completed."
