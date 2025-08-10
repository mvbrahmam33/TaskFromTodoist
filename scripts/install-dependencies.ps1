#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Automated dependency installer for TodoistTaskFetcher

.DESCRIPTION
    This script helps install the required dependencies for TodoistTaskFetcher:
    - Checks for and installs Chocolatey
    - Installs MinGW-w64 compiler
    - Installs vcpkg and required packages
    - Optionally installs ImageMagick and Rainmeter

.PARAMETER SkipOptional
    Skip installation of optional components (ImageMagick, Rainmeter)

.PARAMETER VcpkgPath
    Custom path for vcpkg installation (default: C:\dev\vcpkg)

.EXAMPLE
    .\scripts\install-dependencies.ps1
    
.EXAMPLE
    .\scripts\install-dependencies.ps1 -SkipOptional
#>

param(
    [switch]$SkipOptional,
    [string]$VcpkgPath = "C:\dev\vcpkg"
)

# Require Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ This script requires Administrator privileges!" -ForegroundColor Red
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Yellow
    exit 1
}

$ErrorActionPreference = "Continue"

function Write-Step {
    param([string]$Message)
    Write-Host "`n🔧 $Message" -ForegroundColor Cyan
    Write-Host "=" * ($Message.Length + 3) -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

Write-Host @"
🚀 TodoistTaskFetcher Dependency Installer
==========================================

This script will install the required dependencies:
✅ Chocolatey (package manager)
✅ MinGW-w64 (C++ compiler) 
✅ Make (build system)
✅ Git (version control)
✅ vcpkg (C++ package manager)
✅ Required C++ libraries

Optional components (if not using -SkipOptional):
🎨 ImageMagick (wallpaper processing)
🖥️ Rainmeter (desktop integration)

"@ -ForegroundColor White

Read-Host "Press Enter to continue or Ctrl+C to cancel"

# Step 1: Install Chocolatey
Write-Step "Installing Chocolatey Package Manager"
if (Test-Command "choco") {
    Write-Success "Chocolatey is already installed"
} else {
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Write-Success "Chocolatey installed successfully"
    } catch {
        Write-Error-Custom "Failed to install Chocolatey: $($_.Exception.Message)"
        exit 1
    }
}

# Step 2: Install basic development tools
Write-Step "Installing Development Tools"

$tools = @{
    "mingw" = "MinGW-w64 C++ Compiler"
    "make" = "Make Build System"
    "git" = "Git Version Control"
}

foreach ($tool in $tools.Keys) {
    if (Test-Command $tool) {
        Write-Success "$($tools[$tool]) is already installed"
    } else {
        Write-Host "Installing $($tools[$tool])..."
        try {
            & choco install $tool -y
            Write-Success "$($tools[$tool]) installed successfully"
        } catch {
            Write-Error-Custom "Failed to install $($tools[$tool]): $($_.Exception.Message)"
        }
    }
}

# Step 3: Install vcpkg
Write-Step "Installing vcpkg Package Manager"
if (Test-Path "$VcpkgPath\vcpkg.exe") {
    Write-Success "vcpkg is already installed at $VcpkgPath"
} else {
    try {
        Write-Host "Cloning vcpkg to $VcpkgPath..."
        if (-not (Test-Path (Split-Path $VcpkgPath -Parent))) {
            New-Item -ItemType Directory -Path (Split-Path $VcpkgPath -Parent) -Force | Out-Null
        }
        
        & git clone https://github.com/Microsoft/vcpkg.git $VcpkgPath
        Set-Location $VcpkgPath
        .\bootstrap-vcpkg.bat
        .\vcpkg integrate install
        
        Write-Success "vcpkg installed and integrated successfully"
    } catch {
        Write-Error-Custom "Failed to install vcpkg: $($_.Exception.Message)"
        exit 1
    }
}

# Step 4: Install required C++ packages
Write-Step "Installing Required C++ Libraries"
Set-Location $VcpkgPath

$packages = @(
    "cpr:x64-mingw-static",
    "nlohmann-json:x64-mingw-static", 
    "curl:x64-mingw-static"
)

foreach ($package in $packages) {
    Write-Host "Installing $package..."
    try {
        & .\vcpkg install $package
        Write-Success "$package installed successfully"
    } catch {
        Write-Error-Custom "Failed to install ${package}: $($_.Exception.Message)"
    }
}

# Step 5: Install optional components
if (-not $SkipOptional) {
    Write-Step "Installing Optional Components"
    
    $optionalTools = @{
        "imagemagick" = "ImageMagick (wallpaper processing)"
        "rainmeter" = "Rainmeter (desktop widgets)"
    }
    
    foreach ($tool in $optionalTools.Keys) {
        Write-Host "Installing $($optionalTools[$tool])..."
        try {
            & choco install $tool -y
            Write-Success "$($optionalTools[$tool]) installed successfully"
        } catch {
            Write-Warning-Custom "Failed to install $($optionalTools[$tool]): $($_.Exception.Message)"
            Write-Host "You can install this manually later if needed." -ForegroundColor Gray
        }
    }
} else {
    Write-Warning-Custom "Skipping optional components (ImageMagick, Rainmeter)"
}

# Final steps
Write-Step "Final Setup"
Write-Host "Refreshing environment variables..."
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host @"

🎉 Installation Complete!

Next Steps:
1. Close and reopen your PowerShell window
2. Navigate back to your project directory
3. Run: .\scripts\setup.ps1
4. Configure your Todoist API token
5. Build and run the project!

If you encounter any issues:
- Check the troubleshooting section in GETTING_STARTED.md
- Make sure to run PowerShell as Administrator for builds
- Verify all paths in your makefile match your vcpkg installation

Happy coding! 🚀
"@ -ForegroundColor Green
