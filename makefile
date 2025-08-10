CXX = g++
CXXFLAGS = -std=c++17 -mconsole -static -static-libgcc -static-libstdc++
TARGETPATH = C:\Users\timet\Desktop\terminal\startup
TARGETPATH2 = C:\Users\timet\Desktop\projects\todoist
INCLUDES = -IC:\dev\vcpkg\installed\x64-mingw-static\include
LIBDIRS = -LC:\dev\vcpkg\installed\x64-mingw-static\lib
LIBS = -lcpr -lcurl -lssl -lcrypto -lz -lws2_32 -lwinmm -lcrypt32 -lbcrypt

TARGET = todoist.exe
SOURCE = todoistArg.cpp
TARGET2 = todoistArg.exe
SOURCE2 = todoistArg.cpp

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(CXX) $(SOURCE) -o $(TARGETPATH)\$(TARGET) $(CXXFLAGS) $(INCLUDES) $(LIBDIRS) $(LIBS)

arg:
	$(CXX) $(SOURCE2) -o $(TARGETPATH2)\$(TARGET2) $(CXXFLAGS) $(INCLUDES) $(LIBDIRS) $(LIBS)


.PHONY: all clean