# TasksFromTodoist

A Windows desktop application that fetches your Todoist tasks and displays them as a beautiful desktop widget using Rainmeter. Perfect for keeping your tasks visible and accessible right on your desktop!

## 🎯 What It Does

1. **Fetches Tasks** - Automatically retrieves tasks from your Todoist Inbox
2. **Saves to File** - Creates a text file with your tasks in a clean format
3. **Desktop Display** - Shows tasks on your desktop using Rainmeter (optional)
4. **Wallpaper Effects** - Creates blurred wallpaper backgrounds for better visibility (optional)

## 🚀 Quick Start

**New to this?** Start here: [`GETTING_STARTED.md`](GETTING_STARTED.md)

**Need installation help?** See: [`INSTALLATION.md`](INSTALLATION.md)

### Super Quick Setup
1. **Download**: `git clone https://github.com/mvbrahmam33/TaskFromTodoist.git`
2. **Setup**: `.\scripts\setup.ps1`
3. **Configure**: Add your Todoist API token to `config\config.local.json`
4. **Run**: `.\scripts\todoistRefresh.ps1`

That's it! Your tasks will be in `output\tasks.txt`

## 📸 What You Get

### Simple Text Output
```
TASKS:
1) Complete project documentation
2) Review pull requests  
3) Update website content
4) Call dentist
```

### Desktop Widget (with Rainmeter)
A beautiful, always-visible widget on your desktop showing your tasks with refresh buttons and custom styling.

## 🛠️ Requirements

### Essential
- **Windows 10/11**
- **PowerShell** (included with Windows)
- **Internet connection** (to fetch tasks)

### For Building (handled by setup script)
- **C++ compiler** (MinGW-w64)
- **vcpkg** (C++ package manager)

### Optional (for desktop widget)
- **Rainmeter** (desktop customization)
- **ImageMagick** (wallpaper effects)

**Don't worry!** The setup script will guide you through installing everything you need.

## Project Structure

```
TasksFromTodoist/
├── src/                      # Source code
│   ├── main.cpp             # Main application
│   └── todoist_fetcher.hpp  # Header definitions
├── scripts/                  # Automation scripts
│   ├── todoistRefresh.ps1   # Main automation script
│   └── setup.ps1            # Project setup script
├── build/                    # Build output (generated)
├── output/                   # Task output files (generated)
├── config/                   # Configuration files
│   └── config.example.json  # Configuration template
├── docs/                     # Documentation
│   └── BUILD.md             # Detailed build instructions
├── makefile                 # Build configuration
├── .gitignore               # Git exclusions
└── README.md                # This file
```

## 📚 Documentation

- **[🚀 Getting Started](GETTING_STARTED.md)** - Complete beginner's guide with 5-minute setup
- **[📦 Installation Guide](INSTALLATION.md)** - Step-by-step installation help for all components
- **[💡 Usage Examples](USAGE_EXAMPLES.md)** - Different ways to use the application  
- **[❓ FAQ](FAQ.md)** - Common questions and troubleshooting
- **[🔧 Build Instructions](docs/BUILD.md)** - Detailed build and troubleshooting guide
- **[📝 Changelog](CHANGELOG.md)** - Version history and changes

## 🤔 Which Guide Do I Need?

- **Brand new to this?** → Start with [`GETTING_STARTED.md`](GETTING_STARTED.md)
- **Having installation issues?** → Check [`INSTALLATION.md`](INSTALLATION.md)
- **Want to see what's possible?** → Browse [`USAGE_EXAMPLES.md`](USAGE_EXAMPLES.md)
- **Have a quick question?** → Check [`FAQ.md`](FAQ.md)
- **Need to customize/build manually?** → See [`docs/BUILD.md`](docs/BUILD.md)

## 🎮 Usage Examples

### Just Get Your Tasks (No Desktop Widget)
```powershell
# Get tasks and save to a text file
.\scripts\todoistRefresh.ps1 -SkipWallpaper -SkipRainmeter
# Your tasks are now in: output\tasks.txt
```

### Full Desktop Widget Experience
```powershell
# Complete setup with wallpaper effects and desktop display
.\scripts\todoistRefresh.ps1
```

### Custom Options
```powershell
# Use different API key
.\scripts\todoistRefresh.ps1 -ApiKey "your_different_token"

# Skip wallpaper processing (faster)
.\scripts\todoistRefresh.ps1 -SkipWallpaper

# Use custom config file
.\scripts\todoistRefresh.ps1 -ConfigPath "my_config.json"
```

## ⚙️ How It Works

1. **C++ Application** (`src/main.cpp`) - Connects to Todoist API and fetches tasks
2. **PowerShell Script** (`scripts/todoistRefresh.ps1`) - Orchestrates the whole process
3. **Configuration** (`config/config.local.json`) - Stores your settings and API key
4. **Output File** - Tasks saved in text format for display
5. **Rainmeter** (optional) - Reads the text file and displays it on desktop

## Building

### Quick Build
```bash
make
```

### Available Commands
- `make` - Build main executable
- `make debug` - Build debug version  
- `make install` - Install to startup directory
- `make test` - Run with test parameters
- `make clean` - Clean build artifacts
- `make help` - Show all available targets

### Manual Build
See [`docs/BUILD.md`](docs/BUILD.md) for detailed build instructions and troubleshooting.

## Usage

### Automated Execution (Recommended)
```powershell
# Full automation with configuration file
.\scripts\todoistRefresh.ps1

# Skip wallpaper processing
.\scripts\todoistRefresh.ps1 -SkipWallpaper

# Skip Rainmeter operations  
.\scripts\todoistRefresh.ps1 -SkipRainmeter

# Use different API key
.\scripts\todoistRefresh.ps1 -ApiKey "your_token"
```

### Direct Execution
```bash
# Basic usage
.\build\TodoistTaskFetcher.exe <API_KEY> <OUTPUT_PATH>

# With custom filter
.\build\TodoistTaskFetcher.exe <API_KEY> <OUTPUT_PATH> <FILTER>

# Example
.\build\TodoistTaskFetcher.exe "your_api_token" "output\tasks.txt" "#Inbox"
```

## Output Format

The application generates a numbered task list:
```
TASKS:
1) Complete project documentation
2) Review code changes
3) Schedule team meeting
```

## Task Filtering

The application filters tasks based on:
- **Source**: Only tasks from the Inbox (#Inbox filter)
- **Due Date**: Tasks with no due date, or due today/overdue
- **Status**: Only incomplete tasks

## Rainmeter Integration

The PowerShell script integrates with Rainmeter by:
- Creating a blurred wallpaper background at 16:10 aspect ratio
- Saving image dimensions for proper scaling
- Activating Todoist skins (`Todoist` and `Todoist\Mail`)
- Refreshing skins with new task data

## Error Handling

The application includes error handling for:
- Invalid API tokens (HTTP 401/403 responses)
- Network connectivity issues
- File I/O operations
- Missing command-line arguments

## Development

### Adding Features

To extend functionality:
1. Modify `todoistArg.cpp` for API changes
2. Update the PowerShell script for additional Rainmeter integration
3. Adjust the makefile for new dependencies

### Debugging

- Check API response codes for authentication issues
- Verify file paths exist and are writable
- Ensure ImageMagick is properly installed
- Test Rainmeter commands manually if automation fails

## License

This project is provided as-is for personal use and automation of Todoist task display on Windows desktops.

## Contributing

Feel free to submit issues and enhancement requests. When contributing:
1. Test changes on Windows 10/11
2. Ensure compatibility with current Todoist API
3. Maintain backwards compatibility with existing Rainmeter skins
