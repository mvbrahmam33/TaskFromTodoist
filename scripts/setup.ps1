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
Write-Host "================================" -ForegroundColor Cyan

# Check if we're in the right directory
if (-not (Test-Path "makefile") -or -not (Test-Path "src")) {
    Write-Error-Custom "Please run this script from the project root directory."
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
        Write-Status "  Copied configuration template to config.local.json"
        Write-Status "  IMPORTANT: Edit config\config.local.json with your settings!" "Yellow"
    } else {
        Write-Status "  Configuration file already exists: $configLocal" "Gray"
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
        Write-Error-Custom "Missing required dependencies. Please install:"
        foreach ($dep in $missingDeps) {
            Write-Host "  - $dep" -ForegroundColor Red
        }
        Write-Host "See docs\BUILD.md for detailed installation instructions." -ForegroundColor Yellow
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

Write-Status "Setup completed!" "Cyan"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Edit config\config.local.json with your Todoist API token and paths"
Write-Host "2. Run: .\scripts\todoistRefresh.ps1 to test the complete workflow"
Write-Host "3. Check docs\BUILD.md for detailed usage instructions"
Write-Host ""
Write-Status "Happy task fetching! 🚀" "Green"
