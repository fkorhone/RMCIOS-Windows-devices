@echo off
:: **************************************************
:: This is compile script for Windows
:: **************************************************
call "toolpath.bat"

:: Settings
set PROJECTDIR=%CD%
set FILENAME=%~n0
set OUTPUT_FILE=%FILENAME%.dll
set SOURCES=RMCIOS-NI-DAQmx-module\RMCIOS-NI-DAQmx-module.c 
set SOURCES=%SOURCES% string-conversion.c 
set SOURCES=%SOURCES% RMCIOS-interface\RMCIOS-functions.c
call "version_str.bat"
set NIDAQ_include="C:\Program Files (x86)\National Instruments\Shared\ExternalCompilerSupport\C\include"
set NIDAQ_libdir="C:\Program Files (x86)\National Instruments\Shared\ExternalCompilerSupport\C\lib32\msvc"

set OUTPUT_DIR=..\modules

:: compiler flags
set CFLAGS=%CFLAGS% -static-libgcc 
set CFLAGS=%CFLAGS% -shared -Wl,--subsystem,windows 
set CFLAGS=%CFLAGS% -I %PROJECTDIR%\RMCIOS-interface
set CFLAGS=%CFLAGS% -I %NIDAQ_include%
set CFLAGS=%CFLAGS% -L %NIDAQ_libdir%
set CFLAGS=%CFLAGS% -lNIDAQmx
set CFLAGS=%CFLAGS% -D API_ENTRY_FUNC="__declspec(dllexport) __cdecl"
set CFLAGS=%CFLAGS% -Wno-switch

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

echo running ..\test_%FILENAME%.bat
cd ..

timeout /T 5
exit


