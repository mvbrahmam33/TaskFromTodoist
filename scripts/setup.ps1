#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Setup script for TodoistTaskFetcher project

.DESCRIPTION
    This script helps set up the TodoistTaskFetcher project by:
    1. Checking for required dependencies
    2. Creating necessary directories
    3. Copying configuration templates
    4. Building the project

.PARAMETER SkipBuild
    Skip the build process

.PARAMETER ConfigureOnly
    Only set up configuration, don't check dependencies

.EXAMPLE
    .\scripts\setup.ps1
    
.EXAMPLE
    .\scripts\setup.ps1 -SkipBuild
#>

param(
    [switch]$SkipBuild,
    [switch]$ConfigureOnly
)

$ErrorActionPreference = "Stop"

function Write-Status {
    param(
        [string]$Message,
        [string]$Color = "Green"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "WARNING: $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "ERROR: $Message" -ForegroundColor Red
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

function Test-Path-Safe {
    param([string]$Path)
    try {
        return Test-Path $Path
    } catch {
        return $false
    }
}

Write-Status "TodoistTaskFetcher Setup Script" "Cyan"
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "This script will help you set up TodoistTaskFetcher in just a few steps!" -ForegroundColor White
Write-Host ""

# Check if we're in the right directory
if (-not (Test-Path "makefile") -or -not (Test-Path "src")) {
    Write-Error-Custom "Please run this script from the project root directory."
    Write-Host "Example: cd TaskFromTodoist; .\scripts\setup.ps1" -ForegroundColor Gray
    exit 1
}

# Create necessary directories
Write-Status "Creating project directories..."
$directories = @("build", "output", "config", "docs")
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Status "  Created: $dir"
    } else {
        Write-Status "  Exists: $dir" "Gray"
    }
}

# Set up configuration
Write-Status "Setting up configuration..."
$configExample = "config\config.example.json"
$configLocal = "config\config.local.json"

if (Test-Path $configExample) {
    if (-not (Test-Path $configLocal)) {
        Copy-Item $configExample $configLocal
        Write-Status "  ✅ Copied configuration template to config.local.json"
        Write-Host ""
        Write-Host "🔧 IMPORTANT: You need to configure your Todoist API token!" -ForegroundColor Yellow
        Write-Host "   1. Get your token from: https://todoist.com/prefs/integrations" -ForegroundColor Cyan
        Write-Host "   2. Edit config\config.local.json" -ForegroundColor Cyan  
        Write-Host "   3. Replace YOUR_TODOIST_API_TOKEN_HERE with your actual token" -ForegroundColor Cyan
        Write-Host ""
        
        $response = Read-Host "Would you like to open the config file now? (y/n)"
        if ($response -match '^[Yy]') {
            try {
                & notepad $configLocal
                Write-Status "  📝 Opened configuration file in Notepad"
            } catch {
                Write-Warning-Custom "Could not open Notepad. Please edit $configLocal manually."
            }
        }
    } else {
        Write-Status "  ✅ Configuration file already exists: $configLocal" "Gray"
    }
} else {
    Write-Warning-Custom "Configuration example not found: $configExample"
}

if (-not $ConfigureOnly) {
    # Check dependencies
    Write-Status "Checking dependencies..."

    $dependencies = @{
        "g++" = "MinGW-w64 C++ compiler"
        "make" = "Make build system"
    }

    $missingDeps = @()
    foreach ($dep in $dependencies.Keys) {
        if (Test-Command $dep) {
            Write-Status "  ✓ $($dependencies[$dep])" "Green"
        } else {
            Write-Error-Custom "  ✗ $($dependencies[$dep]) not found"
            $missingDeps += $dep
        }
    }

    # Check vcpkg
    $vcpkgPaths = @(
        "C:\dev\vcpkg\vcpkg.exe",
        "C:\vcpkg\vcpkg.exe",
        "vcpkg.exe"
    )

    $vcpkgFound = $false
    foreach ($path in $vcpkgPaths) {
        if (Test-Path-Safe $path) {
            Write-Status "  ✓ vcpkg found at: $path" "Green"
            $vcpkgFound = $true
            break
        } elseif (Test-Command $path) {
            Write-Status "  ✓ vcpkg found in PATH" "Green"
            $vcpkgFound = $true
            break
        }
    }

    if (-not $vcpkgFound) {
        Write-Error-Custom "  ✗ vcpkg not found. Please install vcpkg and update the Makefile paths."
        $missingDeps += "vcpkg"
    }

    # Check optional dependencies
    Write-Status "Checking optional dependencies..."
    
    $optionalDeps = @{
        "C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\magick.exe" = "ImageMagick (for wallpaper processing)"
        "C:\Program Files\Rainmeter\Rainmeter.exe" = "Rainmeter (for desktop integration)"
    }

    foreach ($path in $optionalDeps.Keys) {
        if (Test-Path-Safe $path) {
            Write-Status "  ✓ $($optionalDeps[$path])" "Green"
        } else {
            Write-Warning-Custom "  ? $($optionalDeps[$path]) not found at expected location"
            Write-Host "    You may need to update paths in your configuration." -ForegroundColor Gray
        }
    }

    if ($missingDeps.Count -gt 0) {
        Write-Host ""
        Write-Error-Custom "❌ Missing required dependencies. You have two options:"
        Write-Host ""
        Write-Host "Option 1 - Automated Installation (Recommended):" -ForegroundColor Cyan
        Write-Host "  Run: .\scripts\install-dependencies.ps1" -ForegroundColor White
        Write-Host ""
        Write-Host "Option 2 - Manual Installation:" -ForegroundColor Cyan
        foreach ($dep in $missingDeps) {
            Write-Host "  - Install $dep" -ForegroundColor White
        }
        Write-Host ""
        Write-Host "See GETTING_STARTED.md or TROUBLESHOOTING.md for detailed instructions." -ForegroundColor Yellow
        
        $response = Read-Host "Would you like to run the automated installer now? (y/n)"
        if ($response -match '^[Yy]') {
            Write-Host "Starting automated installation..." -ForegroundColor Green
            try {
                & .\scripts\install-dependencies.ps1
                Write-Status "Dependencies installed! Please restart PowerShell and run setup again."
                exit 0
            } catch {
                Write-Error-Custom "Automated installation failed. Please install dependencies manually."
            }
        }
        
        exit 1
    }

    # Build project if not skipped
    if (-not $SkipBuild) {
        Write-Status "Building project..."
        
        try {
            & make all
            if ($LASTEXITCODE -eq 0) {
                Write-Status "  ✓ Build completed successfully!" "Green"
            } else {
                Write-Error-Custom "  ✗ Build failed with exit code: $LASTEXITCODE"
                Write-Host "Check the build output above for details." -ForegroundColor Gray
                exit 1
            }
        } catch {
            Write-Error-Custom "Build process failed: $($_.Exception.Message)"
            exit 1
        }
    }
}

Write-Status "🎉 Setup completed successfully!" "Green"
Write-Host ""
Write-Host "🚀 Next steps:" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Cyan

if (Test-Path "config\config.local.json") {
    # Check if API token is configured
    try {
        $config = Get-Content "config\config.local.json" | ConvertFrom-Json
        if ($config.todoist.api_token -eq "YOUR_TODOIST_API_TOKEN_HERE") {
            Write-Host "1. 🔑 Configure your Todoist API token:" -ForegroundColor Yellow
            Write-Host "   - Get token from: https://todoist.com/prefs/integrations" -ForegroundColor Gray
            Write-Host "   - Edit: config\config.local.json" -ForegroundColor Gray
            Write-Host "   - Replace: YOUR_TODOIST_API_TOKEN_HERE" -ForegroundColor Gray
            Write-Host ""
            Write-Host "2. 🔨 Build the project:" -ForegroundColor Cyan
            Write-Host "   make" -ForegroundColor White
            Write-Host ""  
            Write-Host "3. 🚀 Run the automation:" -ForegroundColor Cyan
            Write-Host "   .\scripts\todoistRefresh.ps1" -ForegroundColor White
        } else {
            Write-Host "1. 🔨 Build the project:" -ForegroundColor Cyan
            Write-Host "   make" -ForegroundColor White
            Write-Host ""
            Write-Host "2. 🚀 Run the automation:" -ForegroundColor Cyan  
            Write-Host "   .\scripts\todoistRefresh.ps1" -ForegroundColor White
            Write-Host ""
            Write-Host "✅ Your API token appears to be configured!" -ForegroundColor Green
        }
    } catch {
        Write-Host "1. 🔧 Fix your configuration file (JSON syntax error)" -ForegroundColor Yellow
        Write-Host "2. 🔨 Build: make" -ForegroundColor Cyan
        Write-Host "3. 🚀 Run: .\scripts\todoistRefresh.ps1" -ForegroundColor Cyan
    }
} else {
    Write-Host "1. 🔧 Set up configuration:" -ForegroundColor Yellow
    Write-Host "   Copy-Item config\config.example.json config\config.local.json" -ForegroundColor White
    Write-Host "2. 🔑 Add your Todoist API token to config\config.local.json" -ForegroundColor Yellow  
    Write-Host "3. 🔨 Build: make" -ForegroundColor Cyan
    Write-Host "4. 🚀 Run: .\scripts\todoistRefresh.ps1" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "📚 Need help? Check:" -ForegroundColor Magenta
Write-Host "   - GETTING_STARTED.md (complete guide)" -ForegroundColor Gray
Write-Host "   - TROUBLESHOOTING.md (if you have issues)" -ForegroundColor Gray  
Write-Host "   - docs\BUILD.md (detailed build info)" -ForegroundColor Gray
Write-Host ""
Write-Status "Happy task fetching! 🚀" "Green"
