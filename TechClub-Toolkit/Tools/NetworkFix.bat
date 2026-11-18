@echo off
setlocal EnableExtensions
title Tech Club Network Fix
color 0B

:: Self-elevate to admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator rights...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "STAMP=%%i"
for %%I in ("%~dp0..\Logs") do set "LOGROOT=%%~fI"
set "LOGDIR=%LOGROOT%\%COMPUTERNAME%_%STAMP%"
mkdir "%LOGDIR%" >nul 2>&1
set "LOG=%LOGDIR%\NetworkFix.txt"
set "TMPOUT=%TEMP%\techclub_net_%STAMP%.tmp"
set "NEEDREBOOT=0"
>"%LOG%" echo Tech Club Network Fix - %COMPUTERNAME% - %DATE% %TIME%

:menu
cls
echo ==========================================================
echo   TECH CLUB NETWORK FIX            %COMPUTERNAME%
echo ==========================================================
echo.
echo   [1] Diagnose           - read-only, tells you what is wrong
echo   [2] Standard fix       - flush DNS and caches, renew the IP address
echo   [3] Restart adapters   - restart network cards and the WLAN service
echo   [4] FULL RESET         - reset Winsock, TCP/IP and proxy (needs restart)
echo   [5] Wi-Fi tools        - driver details, saved networks, Wi-Fi report
echo   [6] Do it all          - 1, 2, 3 and then diagnose again
echo   [Q] Quit
echo.
choice /c 123456Q /n /m "Choose: "
if errorlevel 7 goto quit
if errorlevel 6 goto doall
if errorlevel 5 goto wifi
if errorlevel 4 goto fullreset
if errorlevel 3 goto restartmenu
if errorlevel 2 goto standardmenu
if errorlevel 1 goto diagmenu
goto menu

:diagmenu
call :do_diag
echo.
pause
goto menu

:standardmenu
call :do_standard
echo.
pause
goto menu

:restartmenu
call :do_restart
echo.
pause
goto menu

:doall
call :do_diag
call :do_standard
call :do_restart
echo.
echo Waiting 10 seconds for the network to settle...
timeout /t 10 /nobreak >nul
call :do_diag
echo.
echo Full log: %LOG%
pause
goto menu

:fullreset
echo.
echo FULL RESET will put Winsock, the TCP/IP stack, IPv6 and the WinHTTP proxy
echo back to Windows defaults. Static IP/DNS settings may be cleared. Saved
echo Wi-Fi networks are kept. A restart is required afterwards.
echo.
choice /c YN /n /m "Continue? (Y/N): "
if errorlevel 2 goto menu
call :run netsh winsock reset
call :run netsh int ip reset
call :run netsh int ipv6 reset
call :run netsh winhttp reset proxy
call :run ipconfig /flushdns
set "NEEDREBOOT=1"
echo.
echo A restart is needed to finish the reset.
choice /c YN /n /m "Restart now? (Y/N): "
if errorlevel 2 goto fullreset_later
shutdown /r /t 20 /c "Tech Club Network Fix: restarting to finish the network reset"
echo Restarting in 20 seconds. To cancel, run:  shutdown /a
pause
goto menu
:fullreset_later
echo Remember to restart this PC before testing the network again.
pause
goto menu

:wifi
cls
echo ==========================================================
echo   WI-FI TOOLS
echo ==========================================================
echo.
echo   [1] Wi-Fi adapter and driver details
echo   [2] List saved Wi-Fi networks
echo   [3] Create the Wi-Fi connection report and save it to the USB
echo   [B] Back
echo.
choice /c 123B /n /m "Choose: "
if errorlevel 4 goto menu
if errorlevel 3 goto wlanreport
if errorlevel 2 goto wlanprofiles
call :run netsh wlan show drivers
call :run netsh wlan show interfaces
pause
goto wifi
:wlanprofiles
call :run netsh wlan show profiles
pause
goto wifi
:wlanreport
call :run netsh wlan show wlanreport
copy /y "%ProgramData%\Microsoft\Windows\WlanReport\wlan-report-latest.html" "%LOGDIR%\wlan-report.html" >nul 2>&1
if not exist "%LOGDIR%\wlan-report.html" goto noreport
echo.
echo Saved to the USB: %LOGDIR%\wlan-report.html
start "" "%LOGDIR%\wlan-report.html"
pause
goto wifi
:noreport
echo.
echo Could not create the report - this PC may have no Wi-Fi adapter.
pause
goto wifi

:quit
del "%TMPOUT%" >nul 2>&1
echo.
echo Log saved to: %LOG%
endlocal
exit /b 0


:: ============================================================
::  SUBROUTINES
:: ============================================================

:: Run a command, show the output and append it to the log
:run
>>"%LOG%" echo.
>>"%LOG%" echo ^> %*
%* > "%TMPOUT%" 2>&1
type "%TMPOUT%"
type "%TMPOUT%" >> "%LOG%"
exit /b 0

:do_diag
echo.
echo ---- DIAGNOSE ----
>>"%LOG%" echo.
>>"%LOG%" echo ---- DIAGNOSE ----
call :run powershell -NoProfile -Command "Get-NetAdapter -Physical | Format-Table Name,Status,LinkSpeed,InterfaceDescription -AutoSize"
call :run ipconfig
call :run netsh winhttp show proxy

set "GW="
for /f "usebackq" %%g in (`powershell -NoProfile -Command "(Get-NetRoute -DestinationPrefix 0.0.0.0/0 -ErrorAction SilentlyContinue | Where-Object { $_.NextHop -ne '0.0.0.0' } | Sort-Object RouteMetric | Select-Object -First 1).NextHop"`) do set "GW=%%g"

set "APIPA=0"
powershell -NoProfile -Command "if (Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -like '169.254.*' }) { exit 1 } else { exit 0 }"
if errorlevel 1 set "APIPA=1"

set "GW_OK=0"
if defined GW (
    ping -n 2 -w 1500 %GW% | find "TTL=" >nul && set "GW_OK=1"
)
set "NET_OK=0"
ping -n 2 -w 2000 1.1.1.1 | find "TTL=" >nul && set "NET_OK=1"
if "%NET_OK%"=="0" (
    ping -n 2 -w 2000 8.8.8.8 | find "TTL=" >nul && set "NET_OK=1"
)
set "DNS_OK=0"
powershell -NoProfile -Command "try { Resolve-DnsName google.com -DnsOnly -ErrorAction Stop | Out-Null; exit 0 } catch { exit 1 }"
if not errorlevel 1 set "DNS_OK=1"
set "DNS2_OK=0"
powershell -NoProfile -Command "try { Resolve-DnsName google.com -Server 1.1.1.1 -DnsOnly -ErrorAction Stop | Out-Null; exit 0 } catch { exit 1 }"
if not errorlevel 1 set "DNS2_OK=1"

echo.
if defined GW (echo   Default gateway : %GW%) else (echo   Default gateway : NONE)
echo   Reach router    : %GW_OK%      (1 = yes)
echo   Reach internet  : %NET_OK%      (1 = yes, tested by IP address)
echo   DNS works       : %DNS_OK%      (1 = yes, using this PC's DNS server)
echo   Public DNS works: %DNS2_OK%      (1 = yes, using 1.1.1.1)
echo   DHCP failed     : %APIPA%      (1 = yes, got a 169.254.x.x address)
>>"%LOG%" echo Gateway=%GW% GW_OK=%GW_OK% NET_OK=%NET_OK% DNS_OK=%DNS_OK% DNS2_OK=%DNS2_OK% APIPA=%APIPA%

set "VERDICT=Network looks healthy."
if "%DNS_OK%"=="0" if "%DNS2_OK%"=="1" set "VERDICT=DNS PROBLEM: this PC's DNS server fails but public DNS works. Run Standard fix, or set DNS to 1.1.1.1 / 8.8.8.8."
if "%DNS_OK%"=="0" if "%DNS2_OK%"=="0" if "%NET_OK%"=="1" set "VERDICT=Internet works by IP but names will not resolve. Try Standard fix, then Full Reset."
if "%NET_OK%"=="0" if "%GW_OK%"=="1" set "VERDICT=Router is reachable but there is NO internet. Check modem/ISP, reboot the modem and router."
if "%GW_OK%"=="0" set "VERDICT=Cannot reach the router. Check the cable or Wi-Fi connection, adapter status, and DHCP."
if "%APIPA%"=="1" set "VERDICT=No IP address from DHCP. Router/DHCP problem, or a bad cable or weak Wi-Fi link."
echo.
echo   RESULT: %VERDICT%
>>"%LOG%" echo RESULT: %VERDICT%
exit /b 0

:do_standard
echo.
echo ---- STANDARD FIX ----
>>"%LOG%" echo.
>>"%LOG%" echo ---- STANDARD FIX ----
call :run ipconfig /flushdns
call :run ipconfig /registerdns
call :run arp -d *
call :run nbtstat -R
call :run nbtstat -RR
call :run ipconfig /release
call :run ipconfig /renew
timeout /t 3 /nobreak >nul
exit /b 0

:do_restart
echo.
echo ---- RESTART ADAPTERS ----
>>"%LOG%" echo.
>>"%LOG%" echo ---- RESTART ADAPTERS ----
call :run powershell -NoProfile -Command "Get-NetAdapter -Physical | Where-Object { $_.Status -ne 'Disabled' } | Restart-NetAdapter -Confirm:$false"
call :run powershell -NoProfile -Command "Restart-Service WlanSvc -Force -ErrorAction SilentlyContinue"
echo Waiting 8 seconds for adapters to come back...
timeout /t 8 /nobreak >nul
exit /b 0
