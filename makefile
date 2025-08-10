# Todoist Task Fetcher Makefile
# Improved build system with better structure and configurability

# Compiler and flags
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -O2 -mconsole -static -static-libgcc -static-libstdc++
DEBUG_FLAGS = -g -DDEBUG -O0

# Directories
SRC_DIR = src
BUILD_DIR = build
OUTPUT_DIR = output
SCRIPTS_DIR = scripts

# vcpkg paths (adjust as needed)
VCPKG_ROOT = C:\dev\vcpkg
VCPKG_TRIPLET = x64-mingw-static
VCPKG_INSTALLED = $(VCPKG_ROOT)\installed\$(VCPKG_TRIPLET)

INCLUDES = -I$(VCPKG_INSTALLED)\include -I$(SRC_DIR)
LIBDIRS = -L$(VCPKG_INSTALLED)\lib
LIBS = -lcpr -lcurl -lssl -lcrypto -lz -lws2_32 -lwinmm -lcrypt32 -lbcrypt

# Targets
TARGET = TodoistTaskFetcher.exe
DEBUG_TARGET = TodoistTaskFetcher_debug.exe
SOURCE = $(SRC_DIR)\main.cpp

# Installation paths
INSTALL_PATH = C:\Users\timet\Desktop\terminal\startup
PROJECT_PATH = C:\Users\timet\Desktop\projects\TasksFromTodoist

# Default target
all: directories $(BUILD_DIR)\$(TARGET)

# Create necessary directories
directories:
	@if not exist "$(BUILD_DIR)" mkdir "$(BUILD_DIR)"
	@if not exist "$(OUTPUT_DIR)" mkdir "$(OUTPUT_DIR)"

# Main build target
$(BUILD_DIR)\$(TARGET): $(SOURCE)
	$(CXX) $(SOURCE) -o $(BUILD_DIR)\$(TARGET) $(CXXFLAGS) $(INCLUDES) $(LIBDIRS) $(LIBS)
	@echo Build complete: $(BUILD_DIR)\$(TARGET)

# Debug build
debug: directories $(BUILD_DIR)\$(DEBUG_TARGET)

$(BUILD_DIR)\$(DEBUG_TARGET): $(SOURCE)
	$(CXX) $(SOURCE) -o $(BUILD_DIR)\$(DEBUG_TARGET) $(CXXFLAGS) $(DEBUG_FLAGS) $(INCLUDES) $(LIBDIRS) $(LIBS)
	@echo Debug build complete: $(BUILD_DIR)\$(DEBUG_TARGET)

# Install to startup directory
install: $(BUILD_DIR)\$(TARGET)
	@if not exist "$(INSTALL_PATH)" mkdir "$(INSTALL_PATH)"
	copy "$(BUILD_DIR)\$(TARGET)" "$(INSTALL_PATH)\"
	@echo Installed to: $(INSTALL_PATH)\$(TARGET)

# Run the application with example parameters
test: $(BUILD_DIR)\$(TARGET)
	$(BUILD_DIR)\$(TARGET) "test_token" "$(OUTPUT_DIR)\test_output.txt" "#Inbox"

# Clean build artifacts
clean:
	@if exist "$(BUILD_DIR)" rmdir /s /q "$(BUILD_DIR)"
	@echo Cleaned build directory

# Clean all generated files
clean-all: clean
	@if exist "$(OUTPUT_DIR)\*.txt" del /q "$(OUTPUT_DIR)\*.txt"
	@echo Cleaned all generated files

# Show help
help:
	@echo Available targets:
	@echo   all        - Build the main executable (default)
	@echo   debug      - Build debug version
	@echo   install    - Install to startup directory
	@echo   test       - Run with test parameters
	@echo   clean      - Clean build directory
	@echo   clean-all  - Clean all generated files
	@echo   help       - Show this help message

# Legacy compatibility targets
$(TARGET): $(BUILD_DIR)\$(TARGET)
	copy "$(BUILD_DIR)\$(TARGET)" "$(PROJECT_PATH)\"

arg: $(BUILD_DIR)\$(TARGET)
	copy "$(BUILD_DIR)\$(TARGET)" "$(PROJECT_PATH)\todoistArg.exe"

.PHONY: all debug install test clean clean-all help directories