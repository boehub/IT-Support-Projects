@echo off
setlocal EnableExtensions
title Tech Club Toolkit
color 0F

:: ============================================================
::  TECH CLUB TOOLKIT  -  menu launcher (Windows 11)
::  Run from the USB. Asks for admin once, then starts the tools.
::  All logs and backups are written back to this USB.
:: ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator rights...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:menu
cls
echo.
echo   ====================================================
echo     TECH CLUB TOOLKIT              %COMPUTERNAME%
echo   ====================================================
echo.
echo     [1] Quick Check  - Windows activation, Wi-Fi card, sound test
echo     [2] Backup       - copy the customer's files to this USB
echo     [3] Network Fix  - diagnose and repair internet problems
echo     [4] Auto-Fix     - full repair and update run (30-90 min)
echo     [5] Full visit   - Quick Check, then Backup, then Auto-Fix
echo     [6] Open the logs folder
echo     [Q] Quit
echo.
echo     Tip: always run Backup BEFORE Auto-Fix.
echo.
choice /c 123456Q /n /m "  Choose: "
if errorlevel 7 goto quit
if errorlevel 6 goto openlogs
if errorlevel 5 goto fullvisit
if errorlevel 4 goto autofix
if errorlevel 3 goto netfix
if errorlevel 2 goto backup
if errorlevel 1 goto quickcheck
goto menu

:quickcheck
call "%~dp0Tools\QuickCheck.bat"
goto menu

:backup
call "%~dp0Tools\Backup.bat"
goto menu

:netfix
call "%~dp0Tools\NetworkFix.bat"
goto menu

:autofix
call "%~dp0Tools\TechClub_AutoFix.bat"
goto menu

:fullvisit
call "%~dp0Tools\QuickCheck.bat"
call "%~dp0Tools\Backup.bat"
echo.
echo Backup finished. Check it said OK before continuing.
choice /c YN /n /m "Start Auto-Fix now? (Y/N): "
if errorlevel 2 goto menu
call "%~dp0Tools\TechClub_AutoFix.bat"
goto menu

:openlogs
if not exist "%~dp0Logs" mkdir "%~dp0Logs"
start "" explorer.exe "%~dp0Logs"
goto menu

:quit
endlocal
exit /b 0
