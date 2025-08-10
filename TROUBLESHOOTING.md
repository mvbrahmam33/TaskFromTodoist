# 🛠️ Troubleshooting Guide

Having issues? Don't worry! This guide covers the most common problems and their solutions.

## 🚨 Common Issues & Solutions

### 1. "vcpkg not found" or Build Errors

**Problem**: `make` fails with vcpkg-related errors.

**Solutions**:
```powershell
# Option 1: Check if vcpkg is installed
Test-Path C:\dev\vcpkg\vcpkg.exe

# Option 2: Install vcpkg using our script
.\scripts\install-dependencies.ps1

# Option 3: Manual vcpkg installation
git clone https://github.com/Microsoft/vcpkg.git C:\dev\vcpkg
cd C:\dev\vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg integrate install
```

**Fix Makefile Paths** (if vcpkg is installed elsewhere):
Edit `makefile` and update the `VCPKG_ROOT` variable:
```makefile
VCPKG_ROOT = C:\your\custom\path\to\vcpkg
```

### 2. "Configuration file not found"

**Problem**: Script says configuration file is missing.

**Solution**:
```powershell
# Copy the example configuration
Copy-Item config\config.example.json config\config.local.json

# Edit with your settings
notepad config\config.local.json
```

**Make sure to replace**:
- `YOUR_TODOIST_API_TOKEN_HERE` with your actual token
- `YOUR_USERNAME` with your Windows username

### 3. "Todoist API authentication failed"

**Problem**: HTTP 401/403 errors when fetching tasks.

**Solutions**:
1. **Get a fresh API token**:
   - Go to [Todoist Settings → Integrations](https://todoist.com/prefs/integrations)
   - Scroll to "Developer" section
   - Copy the API token (should be ~40 characters)

2. **Check your configuration**:
   ```powershell
   # Verify your token is correctly set
   Get-Content config\config.local.json | ConvertFrom-Json | Select-Object -ExpandProperty todoist
   ```

3. **Test manually**:
   ```powershell
   # Replace YOUR_TOKEN with your actual token
   .\build\TodoistTaskFetcher.exe "YOUR_TOKEN" "test_output.txt"
   ```

### 4. "ImageMagick not found"

**Problem**: Wallpaper processing fails.

**Solutions**:
```powershell
# Option 1: Install ImageMagick
choco install imagemagick

# Option 2: Skip wallpaper processing
.\scripts\todoistRefresh.ps1 -SkipWallpaper

# Option 3: Update path in config
# Edit config\config.local.json and update imagemagick.executable_path
```

### 5. "Rainmeter not found"

**Problem**: Rainmeter integration fails.

**Solutions**:
```powershell
# Option 1: Install Rainmeter
choco install rainmeter

# Option 2: Skip Rainmeter operations
.\scripts\todoistRefresh.ps1 -SkipRainmeter

# Option 3: Update path in config
# Edit config\config.local.json and update rainmeter.executable_path
```

### 6. "Permission denied" or "Access is denied"

**Problem**: Build or file operations fail due to permissions.

**Solutions**:
```powershell
# Run PowerShell as Administrator
# Right-click PowerShell → "Run as Administrator"

# Or check if files are read-only
Get-ChildItem -Recurse | Where-Object { $_.IsReadOnly } | Set-ItemProperty -Name IsReadOnly -Value $false
```

### 7. "make: command not found"

**Problem**: Make is not installed or not in PATH.

**Solutions**:
```powershell
# Option 1: Install make via Chocolatey
choco install make

# Option 2: Use manual build command (see docs\BUILD.md)
g++ -std=c++17 -Wall -Wextra -O2 -mconsole -static -static-libgcc -static-libstdc++ -IC:\dev\vcpkg\installed\x64-mingw-static\include -Isrc -LC:\dev\vcpkg\installed\x64-mingw-static\lib src\main.cpp -o build\TodoistTaskFetcher.exe -lcpr -lcurl -lssl -lcrypto -lz -lws2_32 -lwinmm -lcrypt32 -lbcrypt
```

### 8. "No tasks found" or Empty Output

**Problem**: Tasks file is empty or shows "No tasks found."

**Solutions**:
1. **Check your filter**:
   ```json
   // In config\config.local.json
   "filter": "#Inbox"  // Try different filters like "today", "overdue", "p1"
   ```

2. **Verify you have tasks**:
   - Open Todoist web/app
   - Make sure you have tasks in your inbox
   - Try adding a test task

3. **Test with verbose output**:
   ```powershell
   .\build\TodoistTaskFetcher.exe "YOUR_TOKEN" "debug_output.txt" "#Inbox"
   Get-Content debug_output.txt
   ```

### 9. PowerShell Execution Policy Errors

**Problem**: PowerShell blocks script execution.

**Solution**:
```powershell
# Allow script execution (run as Administrator)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# Or bypass for current session
powershell.exe -ExecutionPolicy Bypass -File .\scripts\todoistRefresh.ps1
```

### 10. "JSON parsing error"

**Problem**: Configuration file has syntax errors.

**Solutions**:
1. **Validate JSON**:
   ```powershell
   # Test if your config is valid JSON
   Get-Content config\config.local.json | ConvertFrom-Json
   ```

2. **Common JSON mistakes**:
   - Missing commas between items
   - Extra comma after last item
   - Unescaped backslashes in paths (use `\\` instead of `\`)
   - Missing quotes around strings

3. **Reset to default**:
   ```powershell
   # Start over with clean config
   Copy-Item config\config.example.json config\config.local.json -Force
   ```

## 🔍 Diagnostic Commands

Run these to gather information for debugging:

```powershell
# Check system information
Write-Host "=== System Info ===" -ForegroundColor Cyan
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion

# Check installed tools
Write-Host "`n=== Installed Tools ===" -ForegroundColor Cyan
@("g++", "make", "git", "choco") | ForEach-Object {
    $version = try { & $_ --version 2>$null | Select-Object -First 1 } catch { "Not installed" }
    Write-Host "${_}: $version"
}

# Check vcpkg
Write-Host "`n=== vcpkg Status ===" -ForegroundColor Cyan
if (Test-Path "C:\dev\vcpkg\vcpkg.exe") {
    Write-Host "vcpkg: Installed at C:\dev\vcpkg"
} else {
    Write-Host "vcpkg: Not found at C:\dev\vcpkg"
}

# Check configuration
Write-Host "`n=== Configuration ===" -ForegroundColor Cyan
if (Test-Path "config\config.local.json") {
    Write-Host "config.local.json: Exists"
} else {
    Write-Host "config.local.json: Missing (run setup.ps1)"
}

# Check build output
Write-Host "`n=== Build Status ===" -ForegroundColor Cyan
if (Test-Path "build\TodoistTaskFetcher.exe") {
    Write-Host "Executable: Built successfully"
} else {
    Write-Host "Executable: Not built (run 'make')"
}
```

## 🆘 Still Need Help?

If none of these solutions work:

1. **Check the full documentation**:
   - [`GETTING_STARTED.md`](GETTING_STARTED.md) - Complete setup guide
   - [`docs/BUILD.md`](docs/BUILD.md) - Detailed build instructions

2. **Run diagnostics**:
   ```powershell
   # Get detailed error information
   .\scripts\todoistRefresh.ps1 -Verbose
   ```

3. **Ask for help**:
   - 🐛 [Open an issue on GitHub](https://github.com/mvbrahmam33/TaskFromTodoist/issues)
   - 💬 Include your error messages and diagnostic output
   - 📋 Mention your Windows version and what you were trying to do

4. **Common search terms for web research**:
   - "vcpkg install mingw static libraries"
   - "PowerShell execution policy Windows 11"
   - "Todoist API authentication C++"
   - "ImageMagick Windows installation"

## 🎯 Prevention Tips

To avoid future issues:

- ✅ Always run setup scripts as Administrator
- ✅ Keep your configuration file backed up
- ✅ Update your API token if it stops working
- ✅ Check for Windows updates regularly
- ✅ Use absolute paths in configuration files

Happy troubleshooting! 🔧
