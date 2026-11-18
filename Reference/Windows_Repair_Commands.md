# Windows Repair Commands

Run from an **administrator** Command Prompt. "Changes" means the command alters the PC.

## Order of operations

1. Back up the customer's files.
2. `DISM` to repair the Windows image.
3. `sfc /scannow` to repair system files from that image.
4. `chkdsk` to check the drive.
5. Restart, then test.

DISM goes before SFC because SFC repairs files using the component store that DISM fixes.

## System file repair

| Command | Effect | What it does |
|---|---|---|
| `DISM /Online /Cleanup-Image /CheckHealth` | Read-only | Quick check for a flag saying the image is damaged. Does not scan |
| `DISM /Online /Cleanup-Image /ScanHealth` | Read-only | Full scan of the component store. Takes several minutes |
| `DISM /Online /Cleanup-Image /RestoreHealth` | Changes | Repairs the image, downloading good files from Windows Update. Needs internet. Can sit at one percentage for a long time, so let it finish |
| `sfc /scannow` | Changes | Scans protected system files and replaces damaged ones. Results are in `C:\Windows\Logs\CBS\CBS.log` |

If SFC reports it could not fix some files, run DISM RestoreHealth, then SFC again.

## Drive checks

| Command | Effect | What it does |
|---|---|---|
| `chkdsk C: /scan` | Read-only | Online scan of the drive with no restart |
| `chkdsk C:` | Read-only | Reports problems without fixing them |
| `chkdsk C: /f` | Changes | Fixes file system errors. On the system drive it is scheduled for the next restart |
| `chkdsk C: /f /r` | Changes | Also locates bad sectors and recovers readable data. Can take hours on a large or failing drive |
| `wmic diskdrive get model,status` | Read-only | Quick drive status. **Deprecated**: missing on newer Windows 11 builds. Use `Get-PhysicalDisk` instead (see [PowerShell_Equivalents.md](PowerShell_Equivalents.md)) |

`/r` on a failing drive adds stress to it. If the drive is clicking, very slow, or reporting unhealthy, copy the customer's data off first and consider replacing it rather than repairing it.

## Battery and hardware reports

| Command | Effect | What it does |
|---|---|---|
| `powercfg /batteryreport` | Read-only | Writes `battery-report.html` with design capacity vs. current full-charge capacity and usage history |
| `powercfg /energy` | Read-only | 60-second power efficiency report |
| `mdsched.exe` | Changes | Schedules the Windows Memory Diagnostic for the next restart |
| `systeminfo` | Read-only | OS version, install date, uptime, hardware summary, hotfixes |

## Cleanup

| Command | Effect | What it does |
|---|---|---|
| `cleanmgr /sageset:1` | Changes (settings only) | Opens Disk Cleanup so you can tick what the preset should clear |
| `cleanmgr /sagerun:1` | Changes | Runs the cleanup using preset 1. **Deletes** the ticked items |
| `DISM /Online /Cleanup-Image /AnalyzeComponentStore` | Read-only | Shows how much space the component store can reclaim |
| `DISM /Online /Cleanup-Image /StartComponentCleanup` | Changes | Removes superseded update files. Installed updates can no longer be uninstalled after this |

## Reset Windows Update

Use when updates fail repeatedly or are stuck downloading.

```
net stop wuauserv
net stop bits
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old
net start bits
net start wuauserv
```

Renaming the folders instead of deleting them keeps a way back. Windows recreates them. Delete the `.old` copies after updates work again.

## Performance and processes

| Command | Effect | What it does |
|---|---|---|
| `tasklist` | Read-only | Lists running processes with memory use |
| `taskkill /im name.exe` | Changes | Asks a process to close |
| `taskkill /f /im name.exe` | Changes | Forces a process to close. **Unsaved work in it is lost** |
| `perfmon /report` | Read-only | 60-second performance and health report |
| `shutdown /r /t 0` | Changes | Restarts immediately |
| `shutdown /r /f /t 0` | Changes | Restarts and force-closes apps. Unsaved work is lost |
| `shutdown /a` | Changes | Cancels a pending shutdown or restart during the countdown |

## Network resets (summary)

`netsh winsock reset` and `netsh int ip reset` restore the network stack to defaults and need a restart. Static IP settings may be cleared. The full set is in [Network_Commands.md](Network_Commands.md).
