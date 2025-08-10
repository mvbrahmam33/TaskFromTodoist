# Build Instructions

## Prerequisites

1. **C++ Compiler**: MinGW-w64 or Visual Studio Build Tools
2. **vcpkg**: Package manager for C++ dependencies
3. **Make**: Build system (included with MinGW)
4. **ImageMagick**: For wallpaper processing
5. **Rainmeter**: Desktop customization platform

## Setup Dependencies

### 1. Install vcpkg
```bash
git clone https://github.com/Microsoft/vcpkg.git C:\dev\vcpkg
cd C:\dev\vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg integrate install
```

### 2. Install Required Packages
```bash
.\vcpkg install cpr:x64-mingw-static
.\vcpkg install nlohmann-json:x64-mingw-static
.\vcpkg install curl:x64-mingw-static
```

### 3. Install ImageMagick
- Download from: https://imagemagick.org/script/download.php#windows
- Install to default location: `C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\`

### 4. Install Rainmeter
- Download from: https://www.rainmeter.net/
- Install to default location

## Configuration

1. Copy configuration template:
   ```powershell
   Copy-Item config\config.example.json config\config.local.json
   ```

2. Edit `config\config.local.json` with your settings:
   - Replace `YOUR_TODOIST_API_TOKEN_HERE` with your actual Todoist API token
   - Update paths to match your system
   - Adjust Rainmeter skin names if different

## Building

### Quick Build
```bash
make
```

### Available Make Targets
- `make` or `make all`: Build main executable
- `make debug`: Build debug version
- `make install`: Install to startup directory
- `make test`: Run with test parameters
- `make clean`: Clean build artifacts
- `make clean-all`: Clean all generated files
- `make help`: Show available targets

### Manual Build (if Make is not available)
```bash
g++ -std=c++17 -Wall -Wextra -O2 -mconsole -static -static-libgcc -static-libstdc++ ^
    -IC:\dev\vcpkg\installed\x64-mingw-static\include -Isrc ^
    -LC:\dev\vcpkg\installed\x64-mingw-static\lib ^
    src\main.cpp -o build\TodoistTaskFetcher.exe ^
    -lcpr -lcurl -lssl -lcrypto -lz -lws2_32 -lwinmm -lcrypt32 -lbcrypt
```

## Usage

### Command Line
```bash
# Basic usage
.\build\TodoistTaskFetcher.exe "your_api_token" "output\tasks.txt"

# With custom filter
.\build\TodoistTaskFetcher.exe "your_api_token" "output\tasks.txt" "#Inbox"
```

### PowerShell Script (Recommended)
```powershell
# Full automation
.\scripts\todoistRefresh.ps1

# Skip wallpaper processing
.\scripts\todoistRefresh.ps1 -SkipWallpaper

# Skip Rainmeter operations
.\scripts\todoistRefresh.ps1 -SkipRainmeter

# Use different API key
.\scripts\todoistRefresh.ps1 -ApiKey "your_token"

# Use different config file
.\scripts\todoistRefresh.ps1 -ConfigPath "path\to\config.json"
```

## Troubleshooting

### Build Issues
- **vcpkg not found**: Update paths in Makefile
- **Linker errors**: Ensure all libraries are installed for the correct triplet
- **Permission denied**: Run as administrator if installing to system directories

### Runtime Issues
- **API authentication failed**: Check your Todoist API token
- **ImageMagick not found**: Verify installation path in configuration
- **Rainmeter commands fail**: Ensure Rainmeter is running and skins exist

### Configuration Issues
- **Config file not found**: Copy and edit the example configuration
- **Invalid JSON**: Use a JSON validator to check your config file
- **Path not found**: Use absolute paths in configuration

## Development

### Project Structure
```
TasksFromTodoist/
├── src/                    # Source code
├── scripts/               # PowerShell automation scripts
├── build/                 # Build output (generated)
├── output/                # Task output files (generated)
├── config/                # Configuration files
├── docs/                  # Documentation
├── makefile               # Build configuration
└── README.md             # Main documentation
```

### Adding Features
1. Modify `src/main.cpp` for core functionality changes
2. Update `src/todoist_fetcher.hpp` for new classes/functions
3. Extend `scripts/todoistRefresh.ps1` for automation features
4. Update configuration schema in `config/config.example.json`

### Testing
```bash
# Build and test
make test

# Manual testing
.\build\TodoistTaskFetcher.exe "test_token" "output\test.txt" "#Inbox"
```
