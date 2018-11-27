@echo off
:: **************************************************
:: This is compile script for Windows
:: **************************************************
call "toolpath.bat"

:: Settings
set PROJECTDIR=%CD%
set FILENAME=Labjack-u12-module

:: Output
set OUTPUT_DIR=..\modules
set OUTPUT_FILE=%FILENAME%.dll

:: Directories and sources:
set SRC_DIR=RMCIOS-Labjack-module\
set INTERFACE_DIR=RMCIOS-interface\
set SOURCES=%SRC_DIR%%FILENAME%.c 
set SOURCES=%SOURCES% string-conversion.c 
set SOURCES=%SOURCES% %INTERFACE_DIR%RMCIOS-functions.c
call "version_str.bat"

:: Compiler flags
set CFLAGS=%CFLAGS% -static-libgcc
set CFLAGS=%CFLAGS% -shared 
set CFLAGS=%CFLAGS% -Wl,--subsystem,windows 
set CFLAGS=%CFLAGS% -I %PROJECTDIR%\%INTERFACE_DIR% 
set CFLAGS=%CFLAGS% -D API_ENTRY_FUNC="__declspec(dllexport) __cdecl"

:: Remove earlier produced file. (clean)
IF EXIST %OUTPUT_DIR%\%OUTPUT_FILE% (del %OUTPUT_DIR%\%OUTPUT_FILE%)

:: Compile the program
echo compiling %FILENAME%.c
gcc %SOURCES% -o %OUTPUT_DIR%\%OUTPUT_FILE% %CFLAGS%

IF NOT EXIST %OUTPUT_DIR%\%OUTPUT_FILE% (
    echo COMPILE ERROR!
    pause
    exit
)
echo %OUTPUT_DIR%\%OUTPUT_FILE% ready
timeout /T 5
exit


