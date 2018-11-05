@echo off
:: **************************************************
:: This is compile script for Windows
:: **************************************************

call "toolpath.bat"

:: Settings
set PROJECTDIR=%CD%
set FILENAME=%~n0
set OUTPUT_FILE=%FILENAME%.dll
set SOURCES=%SOURCES% string-conversion.c 
set SOURCES=%SOURCES% RMCIOS-Labjack-module\ljm_channels.c 
set SOURCES=%SOURCES% RMCIOS-interface\RMCIOS-functions.c
set OUTPUT_DIR=..\modules

:: compiler flags
set CFLAGS=%CFLAGS% -s -Os -flto
set CFLAGS=%CFLAGS% -static-libgcc 
set CFLAGS=%CFLAGS% -shared -Wl,--subsystem,windows 
set CFLAGS=%CFLAGS% -I %PROJECTDIR%\RMCIOS-interface
set CFLAGS=%CFLAGS% -D API_ENTRY_FUNC="__declspec(dllexport) __cdecl"
set CFLAGS=%CFLAGS% -I %PROJECTDIR%\RMCIOS-Labjack-module\labjack-ljm-library RMCIOS-Labjack-module\labjack-ljm-library\LabJackM.lib
call "version_str.bat"

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

