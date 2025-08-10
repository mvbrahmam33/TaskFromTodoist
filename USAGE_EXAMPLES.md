# 💡 Usage Examples

Here are different ways to use TodoistTaskFetcher based on your needs:

## 🎯 Scenario 1: Just Want Your Tasks in a Text File

Perfect if you just want to extract your Todoist tasks without any desktop widgets.

### Setup
```powershell
# 1. Clone and setup
git clone https://github.com/mvbrahmam33/TaskFromTodoist.git
cd TaskFromTodoist
.\scripts\setup.ps1

# 2. Add your API token to config\config.local.json
# 3. Run without desktop features
.\scripts\todoistRefresh.ps1 -SkipWallpaper -SkipRainmeter
```

### Result
- Your tasks appear in `output\tasks.txt`
- No desktop widget, no wallpaper changes
- Perfect for automation or simple task extraction

### Use Cases
- ✅ Export tasks for other applications
- ✅ Backup your task list
- ✅ Simple automation scripts
- ✅ Integration with other tools

---

## 🎨 Scenario 2: Full Desktop Widget Experience

Get the complete experience with a beautiful desktop widget showing your tasks.

### Setup
```powershell
# 1. Complete setup (installs Rainmeter if needed)
.\scripts\setup.ps1

# 2. Configure everything in config\config.local.json
# 3. Copy your Rainmeter skin files to the correct location
# 4. Run the full experience
.\scripts\todoistRefresh.ps1
```

### Result
- Tasks displayed as desktop widget
- Blurred wallpaper background
- Click-to-refresh functionality
- Beautiful, always-visible task display

### Use Cases
- ✅ Constant task visibility
- ✅ Beautiful desktop integration
- ✅ Quick task overview
- ✅ Productivity-focused desktop

---

## ⚡ Scenario 3: Automated Task Updates

Set up automatic task refreshing throughout the day.

### Setup Windows Task Scheduler
```powershell
# Create a scheduled task to run every 30 minutes
schtasks /create /tn "TodoistRefresh" /tr "powershell.exe -File C:\path\to\TodoistTaskFetcher\scripts\todoistRefresh.ps1" /sc minute /mo 30
```

### Result
- Tasks update automatically every 30 minutes
- No manual intervention needed
- Always current task list

---

## 🛠️ Scenario 4: Development & Customization

Want to modify the code or add features?

### Setup Development Environment
```powershell
# 1. Clone and setup
git clone https://github.com/mvbrahmam33/TaskFromTodoist.git
cd TaskFromTodoist
.\scripts\setup.ps1

# 2. Build in debug mode
make debug

# 3. Test your changes
.\build\TodoistTaskFetcher_debug.exe "your_token" "test.txt"
```

### Customization Examples

#### Change Task Filter
Edit `config\config.local.json`:
```json
{
    "todoist": {
        "filter": "@work & today"  // Only work tasks due today
    }
}
```

#### Add Custom Output Format
Modify `src\main.cpp` to change how tasks are formatted.

#### Create Custom Rainmeter Skin
Design your own widget appearance by modifying the Rainmeter `.ini` files.

---

## 📅 Daily Usage Patterns

### Morning Setup
```powershell
# Quick morning task check
.\scripts\todoistRefresh.ps1
# Tasks now visible on desktop for the day
```

### Throughout the Day
- Click refresh button in desktop widget, or
- Tasks auto-update if you set up scheduling

### End of Day Review
```powershell
# Get final task status
.\scripts\todoistRefresh.ps1
# Review completed/remaining tasks
```

---

## 🔧 Troubleshooting Common Usage

### "No tasks found"
```powershell
# Test with verbose output
.\build\TodoistTaskFetcher.exe "your_token" "debug.txt" "#Inbox"
# Check debug.txt for results
```

### "Desktop widget not updating"
```powershell
# Force Rainmeter refresh
.\scripts\todoistRefresh.ps1 -SkipWallpaper
```

### "Want different task filter"
Edit your config file:
```json
{
    "todoist": {
        "filter": "@urgent | today"  // Urgent tasks OR due today
    }
}
```

---

## 🎯 Pro Tips

### 1. Multiple Configurations
Create different config files for different use cases:
```powershell
# Work tasks only
.\scripts\todoistRefresh.ps1 -ConfigPath "config\work.json"

# Personal tasks only  
.\scripts\todoistRefresh.ps1 -ConfigPath "config\personal.json"
```

### 2. Quick Manual Refresh
Create a desktop shortcut:
```
Target: powershell.exe
Arguments: -WindowStyle Hidden -File "C:\path\to\scripts\todoistRefresh.ps1"
```

### 3. Combine with Other Tools
```powershell
# Export tasks and open in notepad
.\scripts\todoistRefresh.ps1 -SkipWallpaper -SkipRainmeter
notepad output\tasks.txt
```

### 4. Backup Your Configuration
```powershell
# Keep your config safe
Copy-Item config\config.local.json config\config.backup.json
```

---

## 🚀 Advanced Usage

### Command Line Power User
```powershell
# Direct executable usage with custom parameters
.\build\TodoistTaskFetcher.exe "token" "custom_output.txt" "@work & p1"

# Batch processing multiple filters
$filters = @("#Inbox", "@work", "@personal")
foreach ($filter in $filters) {
    .\build\TodoistTaskFetcher.exe "token" "tasks_$filter.txt" $filter
}
```

### Integration with Other Scripts
```powershell
# Use in your own PowerShell scripts
.\scripts\todoistRefresh.ps1 -SkipWallpaper -SkipRainmeter
$tasks = Get-Content "output\tasks.txt"
# Process tasks with your custom logic
```

Choose the scenario that fits your needs and enjoy productive task management! 🎉
