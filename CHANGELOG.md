# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2025-08-10

### 🎯 Major Structure Overhaul

#### Added
- **Improved project structure** with organized directories (`src/`, `scripts/`, `build/`, `config/`, `docs/`)
- **JSON configuration system** for easy customization
- **Comprehensive build system** with multiple make targets
- **Setup script** (`scripts\setup.ps1`) for easy project initialization
- **Enhanced PowerShell script** with parameter support and better error handling
- **Detailed documentation** in `docs/BUILD.md`
- **Header file** (`src/todoist_fetcher.hpp`) for better code organization
- **Comprehensive .gitignore** with proper exclusions

#### Changed
- **Moved source files** to `src/` directory
- **Renamed main executable** to `TodoistTaskFetcher.exe`
- **Improved makefile** with better targets and configurability
- **Enhanced error handling** throughout the application
- **Better command-line interface** with optional filter parameter
- **Improved PowerShell script** with configuration file support

#### Improved
- **Build process** with debug and release configurations
- **Configuration management** with template and local files
- **Documentation** with quick start guide and detailed instructions
- **Code organization** with proper C++ structure
- **Dependency management** with vcpkg integration

### 🛠️ Technical Improvements

#### Features
- Configuration file support (JSON)
- Command-line parameter parsing
- Better error messages and status reporting
- Modular PowerShell script with skip options
- Automated setup process
- Multiple build targets

#### Code Quality
- Separated concerns with header file
- Improved function organization
- Better variable naming
- Enhanced comments and documentation
- Proper error handling throughout

## [1.0.0] - Previous Version

### Initial Implementation
- Basic Todoist API integration
- Simple PowerShell automation
- Rainmeter integration
- ImageMagick wallpaper processing
- Basic makefile build system

---

## Migration Guide from v1.0 to v2.0

If you're upgrading from the previous version:

1. **Backup your current settings** (API keys, paths)
2. **Run the setup script**: `.\scripts\setup.ps1`
3. **Update configuration**: Edit `config\config.local.json` with your settings
4. **Rebuild**: Run `make` to build with new structure
5. **Update automation**: Use `.\scripts\todoistRefresh.ps1` instead of the old script

### Breaking Changes
- **File locations changed**: Source moved to `src/`, scripts to `scripts/`
- **Executable name changed**: `todoistArg.exe` → `build\TodoistTaskFetcher.exe`
- **Configuration method**: Hard-coded values → JSON configuration file
- **Script parameters**: New PowerShell parameter system

### Benefits of Upgrade
- ✅ Easier configuration management
- ✅ Better error handling and debugging
- ✅ More flexible build system
- ✅ Improved maintainability
- ✅ Better documentation
- ✅ Automated setup process
