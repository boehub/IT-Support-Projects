@echo off
setlocal EnableExtensions
title Tech Club Backup
color 0E

:: Self-elevate to admin (needed to read other users' profile folders)
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator rights...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Backup.ps1"
echo.
pause
endlocal
