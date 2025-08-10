#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Todoist Task Fetcher and Rainmeter Integration Script

.DESCRIPTION
    This script automates the process of:
    1. Processing wallpaper (crop and blur)
    2. Fetching tasks from Todoist
    3. Managing Rainmeter skins

.PARAMETER ConfigPath
    Path to configuration file (default: config/config.local.json)

.PARAMETER ApiKey
    Todoist API key (overrides config file)

.PARAMETER SkipWallpaper
    Skip wallpaper processing

.PARAMETER SkipRainmeter
    Skip Rainmeter operations

.EXAMPLE
    .\scripts\todoistRefresh.ps1
    
.EXAMPLE
    .\scripts\todoistRefresh.ps1 -ApiKey "your_token" -SkipWallpaper
#>

param(
    [string]$ConfigPath = "config\config.local.json",
    [string]$ApiKey = "",
    [switch]$SkipWallpaper,
    [switch]$SkipRainmeter
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Function to write colored output
function Write-Status {
    param(
        [string]$Message,
        [string]$Color = "Green"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "ERROR: $Message" -ForegroundColor Red
}

# Function to load configuration
function Load-Configuration {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        if (Test-Path "config\config.example.json") {
            Write-Status "Configuration file not found. Using fallback values." "Yellow"
            # Return fallback configuration
            return @{
                todoist = @{ api_token = "c4726a7570b8c5f0aa36ba0718907a650a9eda53"; filter = "#Inbox" }
                output = @{ file_path = "output\tasks.txt" }
                rainmeter = @{ enabled = $true; executable_path = "C:\Program Files\Rainmeter\Rainmeter.exe" }
                imagemagick = @{ executable_path = "C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\magick.exe"; blur_radius = "0x4"; crop_ratio = "16:10" }
                paths = @{ 
                    wallpaper_output = "C:\Users\timet\Documents\Rainmeter\Skins\Todoist\@Resources\Images\blurImage.jpg"
                    dimensions_file = "C:\Users\timet\Documents\Rainmeter\Skins\Todoist\@Resources\dimensions.txt"
                    tasks_file = "C:\Users\timet\Documents\Rainmeter\Skins\Todoist\@Resources\todoistTasks.txt"
                }
            }
        } else {
            Write-Error-Custom "Configuration file not found: $Path"
            return $null
        }
    }
    
    try {
        $config = Get-Content $Path | ConvertFrom-Json
        return $config
    } catch {
        Write-Error-Custom "Failed to parse configuration file: $($_.Exception.Message)"
        return $null
    }
}

# Main execution
try {
    Write-Status "Starting Todoist Task Fetcher and Rainmeter Integration..."
    
    # Load configuration
    $config = Load-Configuration $ConfigPath
    if (-not $config) {
        exit 1
    }
    
    # Use provided API key or config file
    $todoistToken = if ($ApiKey) { $ApiKey } else { $config.todoist.api_token }
    
    if (-not $todoistToken -or $todoistToken -eq "YOUR_TODOIST_API_TOKEN_HERE") {
        Write-Error-Custom "Todoist API token not configured. Please set it in $ConfigPath or use -ApiKey parameter."
        exit 1
    }

    # Process wallpaper if not skipped
    if (-not $SkipWallpaper -and $config.rainmeter.enabled) {
        Write-Status "Processing wallpaper..."
        
        # Get wallpaper path - SIMPLIFIED
        $wallpaper = (Get-ItemProperty 'HKCU:\Control Panel\Desktop').WallPaper
        if (-not $wallpaper) {
            Write-Error-Custom "Wallpaper path not found."
        }
        else{
            Write-Status "Wallpaper path retrieved: $wallpaper"
        }
        
        # Define paths from config
        $magick = $config.imagemagick.executable_path
        $output = $config.paths.wallpaper_output
        
        # Create output directory if it doesn't exist
        $outputDir = Split-Path $output -Parent
        if (-not (Test-Path $outputDir)) {
            New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
        }
        
        # Build ImageMagick command with configurable crop ratio
        $cropRatio = $config.imagemagick.crop_ratio + "+0+0"
        $blurRadius = $config.imagemagick.blur_radius
        $arguments = @($wallpaper, '-gravity', 'center', '-crop', $cropRatio, '-blur', $blurRadius, '+repage', $output)

        # Execute ImageMagick
        & $magick $arguments 
        if ($LASTEXITCODE -ne 0) {
            Write-Error-Custom "ImageMagick command failed with exit code $LASTEXITCODE"
        }
        else {
            Write-Status "Wallpaper cropped and blurred successfully."
        }

        # Get dimensions of the cropped image
        $identifyArgs = @('-format', '%w %h', $output)
        $dimensions = & $magick identify $identifyArgs
        $dimFile = $config.paths.dimensions_file
        
        # Write only the dimensions in WxH format
        $dimensionsOnly = $dimensions.Trim() -replace '[^0-9 ]', ''
        $parts = $dimensionsOnly -split '\s+'
        if ($parts.Length -eq 2) {
            $dimString = "$($parts[0])x$($parts[1])"
            Set-Content -Path $dimFile -Value $dimString
        } else {
            Set-Content -Path $dimFile -Value $dimensionsOnly
        }
        Write-Status "Image dimensions saved to $dimFile"
    }

    # Fetch Todoist tasks
    Write-Status "Fetching Todoist tasks..."
    
    # Use new executable path or fallback to old one
    $executablePath = "build\TodoistTaskFetcher.exe"
    if (-not (Test-Path $executablePath)) {
        $executablePath = "todoistArg.exe"  # Fallback to old name
        if (-not (Test-Path $executablePath)) {
            Write-Error-Custom "Todoist fetcher executable not found. Please run 'make' to build the project."
            exit 1
        }
    }
    
    $outputPath = if ($config.paths.tasks_file) { $config.paths.tasks_file } else { $config.output.file_path }
    $outputDir = Split-Path $outputPath -Parent
    if (-not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }
    
    $filter = $config.todoist.filter
    & $executablePath $todoistToken $outputPath $filter
    
    if ($LASTEXITCODE -eq 0) {
        Write-Status "Tasks retrieved successfully."
    } else {
        Write-Error-Custom "Failed to retrieve tasks. Exit code: $LASTEXITCODE"
    }

    # Handle Rainmeter operations if not skipped
    if (-not $SkipRainmeter -and $config.rainmeter.enabled) {
        Write-Status "Managing Rainmeter skins..."
        
        $rainmeterPath = $config.rainmeter.executable_path
        if (-not (Test-Path $rainmeterPath)) {
            Write-Error-Custom "Rainmeter not found at: $rainmeterPath"
        } else {
            # Activate both skins with proper delays
            & $rainmeterPath "!ActivateConfig" "Todoist" "Todoist.ini"
            Start-Sleep -Seconds 2
            & $rainmeterPath "!ActivateConfig" "Todoist\Mail" "Mail.ini"
            Start-Sleep -Seconds 2
            Write-Status "Rainmeter skins activated"
            
            # Refresh both skins with proper syntax
            & $rainmeterPath "!Refresh" "Todoist\Main"
            Start-Sleep -Seconds 1
            & $rainmeterPath "!Refresh" "Todoist\Mail"
            Start-Sleep -Seconds 1
            & $rainmeterPath "!CommandMeasure" "MeasureLuaScript" "RefreshButton()" "Todoist\Main"
            & $rainmeterPath "!CommandMeasure" "MeasureLuaMailScript" "RefreshMailButton()" "Todoist\Mail"
            Write-Status "Rainmeter skins refreshed successfully"
        }
    }

    Write-Status "Script completed successfully!" "Cyan"

}
catch {
    Write-Error-Custom "Script execution failed: $($_.Exception.Message)"
    Write-Host "Stack Trace:" -ForegroundColor Yellow
    Write-Host $_.ScriptStackTrace -ForegroundColor Yellow
    exit 1
}

