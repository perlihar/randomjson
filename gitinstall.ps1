# Ensure the script runs with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to run this script as an administrator."
    exit
}

# Set the URL for the Git installer (64-bit version)
$gitInstallerUrl = "https://github.com/git-for-windows/git/releases/latest/download/Git-64-bit.exe"
$installerPath = "$env:TEMP\Git-Installer.exe"

# Download Git installer
Write-Output "Downloading Git installer..."
Invoke-WebRequest -Uri $gitInstallerUrl -OutFile $installerPath

# Run the installer silently
Write-Output "Installing Git silently..."
Start-Process -FilePath $installerPath -ArgumentList "/VERYSILENT", "/NORESTART" -Wait

# Clean up installer
Remove-Item -Path $installerPath

# Confirm installation
$gitVersion = git --version
if ($LASTEXITCODE -eq 0) {
    Write-Output "Git installed successfully: $gitVersion"
} else {
    Write-Error "Git installation failed."
}
