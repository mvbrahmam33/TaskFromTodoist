# ❓ Frequently Asked Questions (FAQ)

## 🚀 Getting Started

### Q: I'm completely new to this. Where do I start?
**A:** Start with [`GETTING_STARTED.md`](GETTING_STARTED.md) - it has a 5-minute setup guide that walks you through everything step by step.

### Q: What exactly does this application do?
**A:** It fetches your tasks from Todoist and saves them to a text file. Optionally, it can display them as a beautiful desktop widget using Rainmeter.

### Q: Do I need to be a programmer to use this?
**A:** Not at all! We provide scripts that do everything for you. You just need to:
1. Run the setup script
2. Add your Todoist API token
3. Run the refresh script

## 🔧 Installation & Setup

### Q: The setup script failed. What should I do?
**A:** Check [`INSTALLATION.md`](INSTALLATION.md) for manual installation steps. The most common issues are:
- Missing C++ compiler (install MinGW-w64)
- Missing vcpkg (follow the vcpkg installation guide)
- Permission issues (run PowerShell as Administrator)

### Q: Where do I get my Todoist API token?
**A:** 
1. Go to https://todoist.com/app/settings/integrations/developer
2. Copy the API token shown there
3. Paste it into `config\config.local.json` replacing `YOUR_TODOIST_API_TOKEN_HERE`

### Q: What if I don't have all the required software?
**A:** The setup script will check what's missing and guide you. If you prefer manual installation, see [`INSTALLATION.md`](INSTALLATION.md) for download links and instructions.

### Q: Is my API token secure?
**A:** Your API token stays on your computer in the `config\config.local.json` file. The `.gitignore` file ensures it won't be accidentally shared if you contribute to the project.

## 🎯 Usage

### Q: Can I use this without the desktop widget?
**A:** Absolutely! Run: `.\scripts\todoistRefresh.ps1 -SkipWallpaper -SkipRainmeter`
Your tasks will be saved to `output\tasks.txt` which you can open with any text editor.

### Q: How do I get tasks from a specific project instead of Inbox?
**A:** Edit `config\config.local.json` and change the filter:
```json
{
    "todoist": {
        "filter": "Project Name"
    }
}
```

### Q: Can I get tasks from multiple projects?
**A:** Yes! Use Todoist's filter syntax:
```json
{
    "todoist": {
        "filter": "#Work | #Personal"
    }
}
```

### Q: How often should I refresh my tasks?
**A:** It's up to you! Options:
- Manual: Run the script when you want updates
- Automatic: Set up Windows Task Scheduler to run every 15-30 minutes
- On-demand: Click the refresh button in the Rainmeter widget

### Q: My tasks aren't showing up. What's wrong?
**A:** Common causes:
1. **Wrong API token** - Double-check your token from Todoist settings
2. **Wrong filter** - Make sure your filter matches actual projects/labels
3. **No tasks match criteria** - The app only shows tasks due today or overdue
4. **Network issue** - Check your internet connection

## 🎨 Desktop Widget & Rainmeter

### Q: Do I need Rainmeter for this to work?
**A:** No! Rainmeter is optional. Without it, you still get your tasks in a text file that you can view however you like.

### Q: I installed Rainmeter but don't see the widget
**A:** You need to:
1. Copy the Rainmeter skin files to your Rainmeter skins folder
2. Update the paths in `config\config.local.json` 
3. Run `.\scripts\todoistRefresh.ps1` to activate the skin

### Q: Can I customize how the desktop widget looks?
**A:** Yes! The Rainmeter skin files (`.ini` files) control the appearance. You can modify colors, fonts, sizes, and layout.

### Q: The wallpaper blurring isn't working
**A:** Make sure ImageMagick is installed:
1. Download from https://imagemagick.org/script/download.php#windows
2. Install to the default location
3. Update the path in `config\config.local.json` if needed

## 🛠️ Technical Issues

### Q: I get "command not found" errors
**A:** This usually means:
- **g++ not found**: Install MinGW-w64 and add it to your PATH
- **make not found**: Install MSYS2 or add make to your PATH
- **vcpkg not found**: Install vcpkg and update the makefile paths

### Q: Build fails with library errors
**A:** Run these commands:
```powershell
cd C:\vcpkg
.\vcpkg install cpr:x64-mingw-static
.\vcpkg install nlohmann-json:x64-mingw-static
.\vcpkg install curl:x64-mingw-static
```

### Q: "Permission denied" when running scripts
**A:** 
1. Run PowerShell as Administrator
2. Enable script execution: `Set-ExecutionPolicy RemoteSigned`
3. Add the project folder to antivirus exclusions

### Q: The executable was built but doesn't run
**A:** Check:
1. Antivirus isn't blocking the .exe file
2. All required DLLs are available (our build uses static linking to avoid this)
3. You're using the correct API token

## 🔄 Updates & Maintenance  

### Q: How do I update to a new version?
**A:**
```powershell
git pull origin main
.\scripts\setup.ps1
```
Your configuration in `config\config.local.json` will be preserved.

### Q: Can I contribute to this project?
**A:** Yes! Feel free to:
- Report bugs in GitHub Issues
- Suggest features
- Submit pull requests
- Share your custom Rainmeter skins

### Q: How do I backup my setup?
**A:** Save these files:
- `config\config.local.json` (your settings)
- Any custom Rainmeter skin files you've modified
- Your Rainmeter skin folder if you've customized it

## 🆘 Still Need Help?

### Q: I followed everything but it's still not working
**A:** 
1. **Check the detailed guides**: [`INSTALLATION.md`](INSTALLATION.md) and [`docs/BUILD.md`](docs/BUILD.md)
2. **Look at examples**: [`USAGE_EXAMPLES.md`](USAGE_EXAMPLES.md) 
3. **Open an issue**: [GitHub Issues](https://github.com/mvbrahmam33/TaskFromTodoist/issues)

When reporting issues, please include:
- Your Windows version
- What you were trying to do
- The exact error message
- What you've already tried

### Q: This seems complicated. Is there an easier way?
**A:** The setup script automates most of the complexity! Just run:
```powershell
.\scripts\setup.ps1
```
And follow the prompts. It's designed to be as simple as possible while giving you powerful features.

---

**💡 Pro Tip**: Most issues are solved by running the setup script as Administrator and making sure you have the correct Todoist API token in your config file.

**🎯 Remember**: You can always start simple (just getting tasks in a text file) and add the desktop widget features later!
