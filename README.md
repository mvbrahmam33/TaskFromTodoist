# 🚀 TodoistTaskFetcher

> **Automate your productivity!** Fetch tasks from Todoist and display them beautifully on your Windows desktop.

[![GitHub release](https://img.shields.io/github/v/release/mvbrahmam33/TaskFromTodoist)](https://github.com/mvbrahmam33/TaskFromTodoist/releases)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Windows](https://img.shields.io/badge/platform-Windows-blue.svg)](README.md)

## 🎯 What Does This Do?

TodoistTaskFetcher is a **desktop automation tool** that:

- ✅ **Fetches your tasks** from Todoist's inbox automatically
- 🎨 **Processes your wallpaper** to create a beautiful blurred background
- 🖥️ **Integrates with Rainmeter** to show tasks directly on your desktop
- ⚡ **Filters tasks** to show only what's due today or overdue
- 🔄 **Runs automatically** via PowerShell script

Perfect for productivity enthusiasts who want their tasks visible at all times!

## 🚀 Quick Start (5 Minutes!)

**New to this project?** 👉 **[Start here with our Getting Started Guide!](GETTING_STARTED.md)**

```powershell
# 1. Clone the project
git clone https://github.com/mvbrahmam33/TaskFromTodoist.git
cd TaskFromTodoist

# 2. Run setup (checks dependencies, creates config)
.\scripts\setup.ps1

# 3. Add your Todoist API token
Copy-Item config\config.example.json config\config.local.json
notepad config\config.local.json  # Add your API token here

# 4. Build and run!
make
.\scripts\todoistRefresh.ps1
```

**🎉 Done!** Your tasks are now fetched and displayed!

## Features

- **Todoist API Integration**: Fetches tasks from Todoist inbox using REST API
- **Due Date Filtering**: Only retrieves tasks that are due today or overdue
- **Wallpaper Processing**: Automatically crops and blurs wallpaper for Rainmeter background
- **Rainmeter Integration**: Activates and refreshes Rainmeter skins automatically
- **Cross-platform Build**: Uses vcpkg for dependency management

## Dependencies

### Required Libraries
- **libcpr**: HTTP client library for C++
- **nlohmann/json**: JSON parsing library
- **ImageMagick**: Image processing (for wallpaper manipulation)

### Build Tools
- **MinGW-w64**: C++ compiler
- **vcpkg**: Package manager for C++ libraries
- **Make**: Build system

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

## Quick Start

1. **Run the setup script**:
   ```powershell
   .\scripts\setup.ps1
   ```

2. **Configure your settings**:
   - Edit `config\config.local.json`
   - Add your Todoist API token
   - Update paths for your system

3. **Run the automation**:
   ```powershell
   .\scripts\todoistRefresh.ps1
   ```

For detailed instructions, see [`docs/BUILD.md`](docs/BUILD.md).

## Configuration

The project uses a JSON configuration file for easy customization. Copy `config\config.example.json` to `config\config.local.json` and update:

```json
{
    "todoist": {
        "api_token": "your_todoist_api_token_here",
        "filter": "#Inbox"
    },
    "output": {
        "file_path": "output/tasks.txt"
    },
    "rainmeter": {
        "enabled": true,
        "executable_path": "C:\\Program Files\\Rainmeter\\Rainmeter.exe"
    }
}
```

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
