# 📦 Installation Guide

This guide will help you install TodoistTaskFetcher step-by-step, even if you're new to development tools.

## 🎯 Overview

TodoistTaskFetcher needs these components:
1. **C++ Build Tools** - To compile the task fetcher
2. **vcpkg** - To manage C++ libraries
3. **PowerShell** - To run automation scripts (included with Windows)
4. **Rainmeter** (Optional) - For desktop widget display
5. **ImageMagick** (Optional) - For wallpaper effects

## 🚀 Automated Installation

### Option 1: Easy Setup (Recommended)
1. Download the project
2. Run our setup script
3. Follow the prompts

```powershell
# Clone the repository
git clone https://github.com/mvbrahmam33/TaskFromTodoist.git
cd TaskFromTodoist

# Run the automated setup
.\scripts\setup.ps1
```

The setup script will:
- Check what's already installed
- Guide you through installing missing components
- Set up the project automatically
- Build the application for you

## 🔧 Manual Installation

If you prefer to install components manually or the automated setup doesn't work:

### 1. Install Git (if not already installed)
Download from: https://git-scm.com/download/win
- Use default installation options
- This lets you download the project code

### 2. Install MinGW-w64 (C++ Compiler)

#### Option A: Using MSYS2 (Recommended)
1. Download MSYS2: https://www.msys2.org/
2. Install with default options
3. Open MSYS2 terminal and run:
```bash
pacman -S mingw-w64-x86_64-gcc
pacman -S mingw-w64-x86_64-make
```
4. Add to Windows PATH: `C:\msys64\mingw64\bin`

#### Option B: Standalone MinGW-w64
1. Download from: https://www.mingw-w64.org/downloads/
2. Choose "MingW-W64-builds"
3. Install to `C:\mingw64`
4. Add `C:\mingw64\bin` to Windows PATH

### 3. Install vcpkg (C++ Package Manager)
```powershell
# Clone vcpkg
git clone https://github.com/Microsoft/vcpkg.git C:\vcpkg
cd C:\vcpkg

# Bootstrap vcpkg
.\bootstrap-vcpkg.bat

# Integrate with system
.\vcpkg integrate install
```

### 4. Install Required C++ Libraries
```powershell
cd C:\vcpkg
.\vcpkg install cpr:x64-mingw-static
.\vcpkg install nlohmann-json:x64-mingw-static
.\vcpkg install curl:x64-mingw-static
```

### 5. Install Optional Components

#### Rainmeter (For Desktop Widget)
1. Download: https://www.rainmeter.net/
2. Install with default settings
3. Rainmeter will be at: `C:\Program Files\Rainmeter\`

#### ImageMagick (For Wallpaper Effects)
1. Download: https://imagemagick.org/script/download.php#windows
2. Choose "Win64 static at 16 bits-per-pixel component"
3. Install to default location: `C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\`

## 📋 Verify Installation

### Check C++ Compiler
```powershell
g++ --version
```
Should show version information.

### Check Make
```powershell
make --version
```
Should show version information.

### Check vcpkg
```powershell
C:\vcpkg\vcpkg version
```
Should show vcpkg version.

## 🔨 Build the Project

### 1. Download TodoistTaskFetcher
```powershell
git clone https://github.com/mvbrahmam33/TaskFromTodoist.git
cd TaskFromTodoist
```

### 2. Update Build Paths
Edit `makefile` and update these paths if different:
```makefile
VCPKG_ROOT = C:\vcpkg
```

### 3. Build
```powershell
make
```

If successful, you'll see:
```
Build complete: build\TodoistTaskFetcher.exe
```

## ⚙️ Configuration

### 1. Create Configuration File
```powershell
Copy-Item config\config.example.json config\config.local.json
```

### 2. Get Todoist API Token
1. Go to: https://todoist.com/app/settings/integrations/developer
2. Copy your API token
3. Keep it secure!

### 3. Edit Configuration
Edit `config\config.local.json`:
```json
{
    "_comment": "Replace YOUR_TODOIST_API_TOKEN_HERE with your actual token",
    "todoist": {
        "api_token": "YOUR_TODOIST_API_TOKEN_HERE",
        "filter": "#Inbox",
        "include_overdue": true
    },
    "output": {
        "file_path": "output/tasks.txt",
        "format": "numbered"
    },
    "rainmeter": {
        "enabled": true,
        "executable_path": "C:\\Program Files\\Rainmeter\\Rainmeter.exe"
    },
    "imagemagick": {
        "executable_path": "C:\\Program Files\\ImageMagick-7.1.1-Q16-HDRI\\magick.exe",
        "blur_radius": "0x4",
        "crop_ratio": "16:10"
    },
    "paths": {
        "wallpaper_output": "C:\\Users\\USERNAME\\Documents\\Rainmeter\\Skins\\Todoist\\@Resources\\Images\\blurImage.jpg",
        "dimensions_file": "C:\\Users\\USERNAME\\Documents\\Rainmeter\\Skins\\Todoist\\@Resources\\dimensions.txt",
        "tasks_file": "C:\\Users\\USERNAME\\Documents\\Rainmeter\\Skins\\Todoist\\@Resources\\todoistTasks.txt"
    }
}
```

**Important**: Replace `USERNAME` with your actual Windows username!

## 🧪 Test Your Installation

### Test 1: Basic Functionality
```powershell
.\build\TodoistTaskFetcher.exe "your_api_token" "test_output.txt"
```

### Test 2: Full Script
```powershell
.\scripts\todoistRefresh.ps1
```

### Test 3: Check Output
```powershell
Get-Content output\tasks.txt
```

You should see your Todoist tasks listed!

## 🆘 Common Installation Issues

### "g++ is not recognized"
- MinGW-w64 not in PATH
- **Fix**: Add `C:\mingw64\bin` (or your MinGW path) to Windows PATH

### "make is not recognized"  
- Make not installed or not in PATH
- **Fix**: Install MSYS2 or add make to PATH

### "vcpkg not found"
- vcpkg not installed or wrong path in makefile
- **Fix**: Install vcpkg to `C:\vcpkg` or update makefile paths

### "cpr library not found"
- vcpkg packages not installed
- **Fix**: Run `.\vcpkg install cpr:x64-mingw-static`

### "Permission denied"
- Antivirus blocking executable
- **Fix**: Add project folder to antivirus exclusions

### "API authentication failed"
- Wrong or expired Todoist API token
- **Fix**: Get new token from Todoist settings

## 🎯 Next Steps

Once installation is complete:

1. **Configure your settings** - Edit `config\config.local.json`
2. **Set up Rainmeter skin** - Copy skin files to Rainmeter folder
3. **Create scheduled task** - For automatic updates
4. **Customize appearance** - Modify Rainmeter skin as desired

See [`GETTING_STARTED.md`](GETTING_STARTED.md) for usage instructions!

## 💡 Tips for Success

1. **Use the automated setup first** - It handles most complexity
2. **Install to default paths** - Reduces configuration issues  
3. **Run PowerShell as Administrator** - Avoids permission problems
4. **Keep your API token secure** - Don't share it publicly
5. **Test each component** - Easier to troubleshoot step by step

## 🤝 Getting Help

If you run into issues:

1. **Check our troubleshooting** - See common solutions above
2. **Review the logs** - Scripts show detailed error messages
3. **Open an issue** - [GitHub Issues](https://github.com/mvbrahmam33/TaskFromTodoist/issues)
4. **Include details** - Your OS version, error messages, and what you tried

Happy installing! 🚀
