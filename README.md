# TasksFromTodoist

A C++ application that fetches tasks from Todoist's inbox and integrates with Rainmeter for desktop task display. This project includes a task retrieval utility and a PowerShell automation script for wallpaper processing and Rainmeter skin management.

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
├── todoistArg.cpp          # Main C++ application
├── todoistArg.exe          # Compiled executable
├── makefile               # Build configuration
├── todoistRefresh.ps1     # PowerShell automation script
├── todoistRefresh copy.ps1 # Backup of PowerShell script
├── output/                # Output directory for test files
│   └── test.txt          # Sample output
└── README.md             # This file
```

## Setup

### Prerequisites

1. **Install vcpkg** and set up the following packages:
   ```bash
   vcpkg install cpr:x64-mingw-static
   vcpkg install nlohmann-json:x64-mingw-static
   vcpkg install curl:x64-mingw-static
   ```

2. **Install ImageMagick** (for wallpaper processing):
   - Download and install from [ImageMagick website](https://imagemagick.org/script/download.php#windows)
   - Default path: `C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\`

3. **Get Todoist API Token**:
   - Go to Todoist Settings → Integrations → Developer
   - Copy your API token

### Configuration

1. **Update API Key**: Edit `todoistRefresh.ps1` and replace the API key:
   ```powershell
   $API_KEY = "your_todoist_api_token_here"
   ```

2. **Adjust Paths**: Update paths in `todoistRefresh.ps1` to match your system:
   - Rainmeter skin paths
   - Output file locations
   - ImageMagick installation path

3. **Build Configuration**: Update `makefile` paths if needed:
   - vcpkg installation directory
   - Target output directories

## Building

### Build the main executable:
```bash
make
```

### Build with argument support:
```bash
make arg
```

This creates `todoistArg.exe` which accepts command-line arguments for API key and output path.

## Usage

### Direct Execution
```bash
./todoistArg.exe <API_KEY> <OUTPUT_PATH>
```

**Example:**
```bash
./todoistArg.exe "your_api_token" "C:\path\to\output\tasks.txt"
```

### Automated Execution
Run the PowerShell script for full automation:
```powershell
.\todoistRefresh.ps1
```

This script will:
1. Process your current wallpaper (crop and blur)
2. Fetch tasks from Todoist
3. Activate and refresh Rainmeter skins
4. Save task output to the configured location

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
