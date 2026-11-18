@echo off
setlocal EnableExtensions
title Tech Club Quick Check
color 0B

:: Self-elevate to admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator rights...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0QuickCheck.ps1"
echo.
pause
endlocal
