@echo off
setlocal EnableExtensions
title Tech Club Auto-Fix
color 0A

:: ============================================================
::  TECH CLUB AUTO-FIX  -  fire-and-forget Windows repair/diagnostic
::  Run from USB. Needs admin (it will ask). Logs saved back to USB.
::  Non-destructive: no formatting, no registry edits, no uninstalls.
:: ============================================================

:: ---- 1. Self-elevate to admin ----
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator rights...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: ---- 2. Set up log folder on the USB ----
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set STAMP=%%i
for %%I in ("%~dp0..\Logs") do set "LOGROOT=%%~fI"
set "LOGDIR=%LOGROOT%\%COMPUTERNAME%_%STAMP%"
mkdir "%LOGDIR%" >nul 2>&1
set "REPORT=%LOGDIR%\00_summary.txt"

cls
echo ==========================================================
echo   TECH CLUB AUTO-FIX
echo   Machine : %COMPUTERNAME%
echo   Logs    : %LOGDIR%
echo ==========================================================
echo.
echo This will run diagnostics, repairs and updates. It can take
echo 30-90 minutes. Do NOT unplug the USB or power off the PC.
echo.
echo This CHANGES the PC: it repairs Windows files, updates apps and
echo Windows, and clears temp files. Run Backup first.
echo.
choice /c YN /n /m "Start Auto-Fix now? (Y/N): "
if errorlevel 2 exit /b 0

echo Tech Club Auto-Fix report > "%REPORT%"
echo Machine: %COMPUTERNAME%   User: %USERNAME%   Started: %DATE% %TIME% >> "%REPORT%"
echo. >> "%REPORT%"

:: ============================================================
:: PHASE 1 - INFORMATION GATHERING
:: ============================================================
echo [1/9] Collecting system information...
systeminfo > "%LOGDIR%\01_systeminfo.txt" 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_ComputerSystem,Win32_BIOS,Win32_Processor | Format-List *" > "%LOGDIR%\01_hardware.txt" 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_PhysicalMemory | Select BankLabel,Capacity,Speed,Manufacturer,PartNumber | Format-Table -Auto" >> "%LOGDIR%\01_hardware.txt" 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Select Name,DriverVersion,DriverDate | Format-Table -Auto" >> "%LOGDIR%\01_hardware.txt" 2>&1
echo - System info saved (01_systeminfo.txt, 01_hardware.txt) >> "%REPORT%"

echo [2/9] Checking drive health and free space...
powershell -NoProfile -Command "Get-PhysicalDisk | Select FriendlyName,MediaType,HealthStatus,OperationalStatus,@{n='SizeGB';e={[math]::Round($_.Size/1GB)}} | Format-Table -Auto" > "%LOGDIR%\02_disks.txt" 2>&1
powershell -NoProfile -Command "Get-Volume | Where DriveLetter | Select DriveLetter,FileSystemLabel,@{n='SizeGB';e={[math]::Round($_.Size/1GB)}},@{n='FreeGB';e={[math]::Round($_.SizeRemaining/1GB)}} | Format-Table -Auto" >> "%LOGDIR%\02_disks.txt" 2>&1
echo - Disk health saved (02_disks.txt) >> "%REPORT%"
powershell -NoProfile -Command "if (Get-PhysicalDisk | Where HealthStatus -ne 'Healthy') {'!! WARNING: a drive is reporting unhealthy status'}" >> "%REPORT%" 2>&1

echo [3/9] Looking for devices with driver problems...
powershell -NoProfile -Command "Get-PnpDevice -PresentOnly | Where Status -eq 'Error' | Select FriendlyName,Class,InstanceId | Format-Table -Auto" > "%LOGDIR%\03_driver_problems.txt" 2>&1
echo - Driver problems saved (03_driver_problems.txt, empty = none) >> "%REPORT%"

echo [4/9] Pulling recent critical/error events...
powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='System','Application';Level=1,2;StartTime=(Get-Date).AddDays(-3)} -MaxEvents 100 -ErrorAction SilentlyContinue | Select TimeCreated,ProviderName,Id,LevelDisplayName,Message | Format-List" > "%LOGDIR%\04_recent_errors.txt" 2>&1
echo - Event log errors, last 3 days (04_recent_errors.txt) >> "%REPORT%"

echo Generating battery report (if this is a laptop)...
powercfg /batteryreport /output "%LOGDIR%\05_battery_report.html" >nul 2>&1
if exist "%LOGDIR%\05_battery_report.html" echo - Battery report saved (05_battery_report.html) >> "%REPORT%"

:: ============================================================
:: PHASE 2 - NETWORK
:: ============================================================
echo [5/9] Testing and refreshing network...
(
    ipconfig /all
    echo.
    echo --- Ping gateway-independent test (8.8.8.8) ---
    ping -n 4 8.8.8.8
    echo.
    echo --- DNS test (google.com) ---
    ping -n 4 google.com
) > "%LOGDIR%\06_network.txt" 2>&1
ipconfig /flushdns >> "%LOGDIR%\06_network.txt" 2>&1
ping -n 2 8.8.8.8 | find "TTL=" >nul
if not errorlevel 1 (
    set "ONLINE=1"
    echo - Internet: CONNECTED >> "%REPORT%"
) else (
    set "ONLINE=0"
    echo - Internet: NOT CONNECTED - updates will be skipped >> "%REPORT%"
)

:: ============================================================
:: PHASE 3 - REPAIRS
:: ============================================================
echo [6/9] Repairing Windows image and system files (slow)...
echo       DISM RestoreHealth...
DISM /Online /Cleanup-Image /RestoreHealth > "%LOGDIR%\07_dism.txt" 2>&1
echo - DISM finished, exit code %errorlevel% (07_dism.txt) >> "%REPORT%"
echo       SFC scannow...
sfc /scannow > "%LOGDIR%\08_sfc.txt" 2>&1
echo - SFC finished, exit code %errorlevel% (08_sfc.txt) >> "%REPORT%"

echo [7/9] Scanning system drive for file system errors (online, no reboot)...
chkdsk %SystemDrive% /scan > "%LOGDIR%\09_chkdsk.txt" 2>&1
echo - CHKDSK online scan finished, exit code %errorlevel% (09_chkdsk.txt) >> "%REPORT%"

:: ============================================================
:: PHASE 4 - UPDATES + SECURITY
:: ============================================================
echo [8/9] Updates and malware scan...
if "%ONLINE%"=="1" (
    where winget >nul 2>&1
    if not errorlevel 1 (
        echo       Updating installed apps with winget...
        winget upgrade --all --silent --accept-package-agreements --accept-source-agreements > "%LOGDIR%\10_winget.txt" 2>&1
        echo - winget app updates attempted - see 10_winget.txt >> "%REPORT%"
    ) else (
        echo - winget not found, app updates skipped >> "%REPORT%"
    )
    echo       Triggering Windows Update...
    UsoClient StartScan
    UsoClient StartDownload
    UsoClient StartInstall
    echo - Windows Update requested via UsoClient - not honored on every Windows 11 build - confirm in Settings ^> Windows Update >> "%REPORT%"
    echo       Updating Defender signatures...
    powershell -NoProfile -Command "Update-MpSignature" > "%LOGDIR%\11_defender.txt" 2>&1
) else (
    echo - No internet: winget / Windows Update / Defender signature update skipped >> "%REPORT%"
)
echo       Running Defender quick scan...
powershell -NoProfile -Command "Start-MpScan -ScanType QuickScan; Get-MpThreatDetection | Format-List" >> "%LOGDIR%\11_defender.txt" 2>&1
echo - Defender quick scan done (11_defender.txt) >> "%REPORT%"

:: ============================================================
:: PHASE 5 - CLEANUP
:: ============================================================
echo [9/9] Cleaning temp files...
del /q /f /s "%TEMP%\*" >nul 2>&1
del /q /f /s "%SystemRoot%\Temp\*" >nul 2>&1
DISM /Online /Cleanup-Image /StartComponentCleanup >nul 2>&1
echo - Temp files and component store cleaned >> "%REPORT%"

:: ---- Pending reboot check ----
set "REBOOT=No"
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" >nul 2>&1 && set "REBOOT=YES"
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" >nul 2>&1 && set "REBOOT=YES"
echo. >> "%REPORT%"
echo Reboot recommended: %REBOOT% >> "%REPORT%"
echo Finished: %DATE% %TIME% >> "%REPORT%"

:: ---- Done ----
cls
echo ==========================================================
echo   ALL DONE  -  %COMPUTERNAME%
echo   Reboot recommended: %REBOOT%
echo   Report: %REPORT%
echo ==========================================================
echo.
type "%REPORT%"
echo.
start "" notepad "%REPORT%"
pause
endlocal
