# 🚀 Getting Started with TodoistTaskFetcher

Welcome to **TodoistTaskFetcher** - a powerful tool that displays your Todoist tasks directly on your Windows desktop using Rainmeter!

## 📋 What This Project Does

This project creates a **desktop widget** that:
1. **Fetches your tasks** from Todoist automatically
2. **Processes your wallpaper** to create a beautiful blurred background
3. **Displays tasks on your desktop** using Rainmeter with a modern, clean interface
4. **Updates automatically** - just click refresh to get the latest tasks

### 🖼️ Visual Example

Your desktop will show something like this:
```
┌─────────────────────────────┐
│  📝 TASKS:                  │
│  1) Complete project docs   │
│  2) Review pull requests    │
│  3) Update website content  │
│  4) Call dentist           │
│  [🔄 Refresh]              │
└─────────────────────────────┘
```

## ⚡ Quick Start (5 Minutes Setup)

### Step 1: Download the Project
```bash
git clone https://github.com/mvbrahmam33/TaskFromTodoist.git
cd TaskFromTodoist
```

### Step 2: Get Your Todoist API Token
1. Go to [Todoist Settings](https://todoist.com/app/settings/integrations/developer)
2. Copy your **API Token**
3. Keep it handy - you'll need it in Step 4!

### Step 3: Run the Setup Script
Open PowerShell in the project folder and run:
```powershell
.\scripts\setup.ps1
```

This script will:
- ✅ Check if you have all required software
- ✅ Create necessary folders
- ✅ Set up configuration templates
- ✅ Build the project automatically

### Step 4: Configure Your Settings
Edit `config\config.local.json` and replace:
```json
{
    "todoist": {
        "api_token": "PUT_YOUR_TODOIST_API_TOKEN_HERE",
        "filter": "#Inbox"
    }
}
```

### Step 5: Test It!
```powershell
.\scripts\todoistRefresh.ps1
```

You should see your tasks in the `output\tasks.txt` file!

## 🎯 Full Desktop Integration (Optional)

To get the **full desktop widget experience**, you'll need Rainmeter:

### Install Rainmeter
1. Download from [rainmeter.net](https://www.rainmeter.net/)
2. Install with default settings

### Set Up the Desktop Widget
1. Copy your Rainmeter skin files to: `C:\Users\YourName\Documents\Rainmeter\Skins\Todoist\`
2. Update paths in `config\config.local.json`:
```json
{
    "paths": {
        "tasks_file": "C:\\Users\\YourName\\Documents\\Rainmeter\\Skins\\Todoist\\@Resources\\todoistTasks.txt"
    }
}
```

3. Run the full script:
```powershell
.\scripts\todoistRefresh.ps1
```

Now you'll have a beautiful desktop widget showing your tasks!

## 🛠️ Prerequisites

### Required (Auto-checked by setup script)
- **Windows 10/11**
- **PowerShell** (included with Windows)
- **MinGW-w64** or Visual Studio Build Tools
- **vcpkg** (C++ package manager)

### Optional (for desktop widget)
- **Rainmeter** (for desktop display)
- **ImageMagick** (for wallpaper effects)

Don't worry - the setup script will guide you through installing what you need!

## 🔧 Troubleshooting

### "API token not configured"
- Make sure you copied your Todoist API token correctly
- Check that `config\config.local.json` exists and has your token

### "Executable not found"
- Run `make` in the project folder to build the application
- Or run `.\scripts\setup.ps1` again

### "Permission denied"
- Run PowerShell as Administrator
- Make sure your antivirus isn't blocking the executable

### Still having issues?
- Check the detailed guide: [`docs/BUILD.md`](docs/BUILD.md)
- Look at the troubleshooting section in the main README

## 🎨 Customization

### Change Task Filter
Edit `config\config.local.json`:
```json
{
    "todoist": {
        "filter": "@work"  // Show only work tasks
    }
}
```

### Skip Wallpaper Processing
```powershell
.\scripts\todoistRefresh.ps1 -SkipWallpaper
```

### Use Without Rainmeter
```powershell
.\scripts\todoistRefresh.ps1 -SkipRainmeter
```

Your tasks will be saved to `output\tasks.txt` which you can open with any text editor.

## 📱 Daily Usage

### Automatic Updates
Set up a Windows scheduled task to run:
```
.\scripts\todoistRefresh.ps1
```
Every 15-30 minutes for automatic task updates.

### Manual Refresh
- Click the refresh button in your desktop widget, or
- Run `.\scripts\todoistRefresh.ps1` in PowerShell

## 🤝 Need Help?

1. **Check the logs** - The script shows detailed status messages
2. **Read the docs** - [`README.md`](README.md) and [`docs/BUILD.md`](docs/BUILD.md)
3. **Open an issue** - [GitHub Issues](https://github.com/mvbrahmam33/TaskFromTodoist/issues)

## 🎉 You're All Set!

Congratulations! You now have a powerful desktop task management system that:
- ✅ Automatically fetches your Todoist tasks
- ✅ Displays them beautifully on your desktop
- ✅ Updates with a single click
- ✅ Works seamlessly with your workflow

Enjoy your productivity boost! 🚀
