# PowerShell Equivalents

Run in PowerShell as administrator where noted. PowerShell commands return objects, so you can filter and format them with `Where-Object`, `Select-Object`, and `Format-Table`.

## Hardware and system information

| Job | Command |
|---|---|
| Computer model and manufacturer | `Get-CimInstance Win32_ComputerSystem \| Select Manufacturer, Model` |
| Serial number and BIOS version | `Get-CimInstance Win32_BIOS \| Select SerialNumber, SMBIOSBIOSVersion` |
| Windows version and build | `Get-CimInstance Win32_OperatingSystem \| Select Caption, BuildNumber` |
| CPU | `Get-CimInstance Win32_Processor \| Select Name, NumberOfCores, NumberOfLogicalProcessors` |
| RAM modules | `Get-CimInstance Win32_PhysicalMemory \| Select BankLabel, Capacity, Speed` |
| Graphics adapters and driver | `Get-CimInstance Win32_VideoController \| Select Name, DriverVersion` |
| Everything at once | `Get-ComputerInfo` |
| Installed updates | `Get-HotFix \| Sort InstalledOn -Descending` |

## Drives

| Job | Command |
|---|---|
| Drive health (replaces `wmic diskdrive`) | `Get-PhysicalDisk \| Select FriendlyName, MediaType, HealthStatus` |
| Volumes and free space | `Get-Volume \| Where DriveLetter` |
| Scan a volume (like `chkdsk /scan`) | `Repair-Volume -DriveLetter C -Scan` |
| Repair a volume | `Repair-Volume -DriveLetter C -OfflineScanAndFix` |

## System repair

| Job | Command |
|---|---|
| Check the Windows image | `Repair-WindowsImage -Online -ScanHealth` |
| Repair the Windows image | `Repair-WindowsImage -Online -RestoreHealth` |
| System file check | `sfc /scannow` (no PowerShell version) |

## Processes and services

| Job | Command |
|---|---|
| Top memory users | `Get-Process \| Sort WorkingSet -Descending \| Select -First 10 Name, @{n='MB';e={[int]($_.WorkingSet/1MB)}}` |
| Stop a process | `Stop-Process -Name notepad` (add `-Force` to force) |
| Service status | `Get-Service wuauserv` |
| Restart a service | `Restart-Service wuauserv` |
| Set a service to start automatically | `Set-Service -Name WlanSvc -StartupType Automatic` |

## Event logs

| Job | Command |
|---|---|
| Errors and criticals, last 3 days | `Get-WinEvent -FilterHashtable @{LogName='System','Application'; Level=1,2; StartTime=(Get-Date).AddDays(-3)} -MaxEvents 50` |
| Devices with driver problems | `Get-PnpDevice -PresentOnly \| Where Status -eq 'Error'` |

## Network

| Job | Command |
|---|---|
| Adapters | `Get-NetAdapter -Physical` |
| IP configuration | `Get-NetIPConfiguration` |
| Flush DNS cache | `Clear-DnsClientCache` |
| DNS lookup | `Resolve-DnsName example.com` |
| Test a port | `Test-NetConnection example.com -Port 443` |
| Trace the route | `Test-NetConnection example.com -TraceRoute` |
| Restart an adapter | `Restart-NetAdapter -Name "Wi-Fi"` |

## Security

| Job | Command |
|---|---|
| Update Defender signatures | `Update-MpSignature` |
| Quick scan | `Start-MpScan -ScanType QuickScan` |
| Threats found | `Get-MpThreatDetection` |
| Defender status | `Get-MpComputerStatus` |

## Script execution

If a `.ps1` will not run, check `Get-ExecutionPolicy`. For a single script without changing the system setting:

```
powershell -NoProfile -ExecutionPolicy Bypass -File .\script.ps1
```

This is what the Toolkit's `.bat` launchers do. Work and school PCs may block it through Group Policy, so do not try to get around a policy on a machine that is not yours.
