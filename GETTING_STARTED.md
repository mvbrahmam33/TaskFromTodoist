# 🚀 Getting Started with TodoistTaskFetcher

Welcome! This guide will help you get TodoistTaskFetcher up and running in just a few minutes.

## 📋 What This Project Does

TodoistTaskFetcher is a desktop automation tool that:
- ✅ Fetches your tasks from Todoist
- 🎨 Processes your wallpaper for a beautiful desktop background
- 🖥️ Integrates with Rainmeter for live task display on your desktop

## 🎯 Quick Start (5 Minutes!)

### Step 1: Clone the Repository
```bash
git clone https://github.com/mvbrahmam33/TaskFromTodoist.git
cd TaskFromTodoist
```

### Step 2: Get Your Todoist API Token
1. Go to [Todoist Settings](https://todoist.com/prefs/integrations) → Integrations
2. Scroll down to "Developer" section
3. Copy your API token (it looks like: `a1b2c3d4e5f6...`)

### Step 3: Run the Setup Script
```powershell
# This will check dependencies and create configuration files
.\scripts\setup.ps1
```

### Step 4: Configure Your Settings
```powershell
# Copy the example configuration
Copy-Item config\config.example.json config\config.local.json

# Edit the configuration file (opens in notepad)
notepad config\config.local.json
```

**Replace this line:**
```json
"api_token": "YOUR_TODOIST_API_TOKEN_HERE"
```
**With your actual token:**
```json
"api_token": "a1b2c3d4e5f6your_actual_token_here"
```

### Step 5: Build and Run!
```powershell
# Build the project
make

# Run the automation
.\scripts\todoistRefresh.ps1
```

That's it! Your tasks should now be fetched and displayed. 🎉

## 📦 System Requirements

### Required (Must Have)
- ✅ **Windows 10/11**
- ✅ **PowerShell** (usually pre-installed)
- ✅ **Git** (for cloning)
- ✅ **MinGW-w64** or **Visual Studio Build Tools** (C++ compiler)
- ✅ **vcpkg** (C++ package manager)

### Optional (For Full Features)
- 🎨 **ImageMagick** (for wallpaper processing)
- 🖥️ **Rainmeter** (for desktop widgets)

## 🛠️ Detailed Setup Instructions

### Install C++ Build Tools

#### Option A: MinGW-w64 (Recommended)
```bash
# Using Chocolatey (recommended)
choco install mingw

# Or download from: https://www.mingw-w64.org/downloads/
```

#### Option B: Visual Studio Build Tools
```bash
# Using Chocolatey
choco install visualstudio2022buildtools --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools"

# Or download from: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
```

### Install vcpkg
```bash
# Clone vcpkg
git clone https://github.com/Microsoft/vcpkg.git C:\dev\vcpkg
cd C:\dev\vcpkg

# Bootstrap vcpkg
.\bootstrap-vcpkg.bat

# Integrate with your system
.\vcpkg integrate install

# Install required packages
.\vcpkg install cpr:x64-mingw-static
.\vcpkg install nlohmann-json:x64-mingw-static
.\vcpkg install curl:x64-mingw-static
```

### Install Optional Components

#### ImageMagick (for wallpaper processing)
```bash
# Using Chocolatey
choco install imagemagick

# Or download from: https://imagemagick.org/script/download.php#windows
```

#### Rainmeter (for desktop integration)
```bash
# Using Chocolatey
choco install rainmeter

# Or download from: https://www.rainmeter.net/
```

## ⚙️ Configuration Guide

Your `config\config.local.json` file controls everything. Here's what each setting does:

```json
{
    "_comment": "Your personal configuration file",
    "todoist": {
        "api_token": "PUT_YOUR_TOKEN_HERE",    // 👈 Your Todoist API token
        "filter": "#Inbox"                    // Which tasks to fetch
    },
    "output": {
        "file_path": "output/tasks.txt"       // Where to save tasks
    },
    "rainmeter": {
        "enabled": true,                      // Enable/disable Rainmeter
        "executable_path": "C:\\Program Files\\Rainmeter\\Rainmeter.exe"
    },
    "imagemagick": {
        "executable_path": "C:\\Program Files\\ImageMagick-7.1.1-Q16-HDRI\\magick.exe",
        "blur_radius": "0x4",                 // How blurry the wallpaper
        "crop_ratio": "16:10"                 // Aspect ratio for cropping
    }
}
```

### Common Filters You Can Use:
- `"#Inbox"` - Only inbox tasks
- `"today"` - Tasks due today
- `"overdue"` - Overdue tasks
- `"p1"` - Priority 1 tasks
- `"@work"` - Tasks with @work label

## 🎮 Usage Examples

### Basic Usage
```powershell
# Run everything (wallpaper + tasks + Rainmeter)
.\scripts\todoistRefresh.ps1
```

### Skip Wallpaper Processing
```powershell
# Just fetch tasks and update Rainmeter
.\scripts\todoistRefresh.ps1 -SkipWallpaper
```

### Skip Rainmeter Integration
```powershell
# Just process wallpaper and fetch tasks
.\scripts\todoistRefresh.ps1 -SkipRainmeter
```

### Use Different API Key
```powershell
# Override the config file API key
.\scripts\todoistRefresh.ps1 -ApiKey "different_token_here"
```

### Use Custom Configuration
```powershell
# Use a different config file
.\scripts\todoistRefresh.ps1 -ConfigPath "path\to\other\config.json"
```

## 🚨 Troubleshooting

### "vcpkg not found" Error
1. Make sure vcpkg is installed at `C:\dev\vcpkg`
2. Update the path in `makefile` if you installed it elsewhere
3. Run `vcpkg integrate install`

### "ImageMagick not found" Error
1. Install ImageMagick from the official website
2. Update the path in your `config.local.json`
3. Or skip wallpaper processing: `.\scripts\todoistRefresh.ps1 -SkipWallpaper`

### "Rainmeter not found" Error
1. Install Rainmeter from rainmeter.net
2. Update the path in your `config.local.json`
3. Or skip Rainmeter: `.\scripts\todoistRefresh.ps1 -SkipRainmeter`

### "Build failed" Error
1. Make sure you have a C++ compiler installed
2. Check that vcpkg packages are installed
3. Try running `make clean` then `make`

### "API authentication failed" Error
1. Double-check your Todoist API token
2. Make sure you copied it exactly (no extra spaces)
3. Try getting a new token from Todoist settings

## 🤝 Getting Help

- 📖 **Check the docs**: Look in the `docs/` folder for detailed guides
- 🐛 **Found a bug?**: Open an issue on GitHub
- 💡 **Have an idea?**: Open a feature request
- 🗣️ **Need help?**: Ask in the GitHub discussions

## 🎉 Success!

If you see "Script completed successfully!" in green text, everything worked! Your tasks are now:
- 📝 Saved to a text file
- 🎨 Displayed on your desktop (if using Rainmeter)
- 🔄 Ready to be refreshed whenever you run the script

Welcome to automated task management! 🚀
