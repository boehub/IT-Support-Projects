# Run Commands and Shortcuts

Press **Win+R**, type the command, press Enter.

## Windows tools

| Command | Opens |
|---|---|
| `devmgmt.msc` | Device Manager (driver problems show a yellow warning icon) |
| `diskmgmt.msc` | Disk Management (partitions, drive letters, uninitialised disks) |
| `services.msc` | Services |
| `eventvwr.msc` | Event Viewer |
| `taskschd.msc` | Task Scheduler |
| `compmgmt.msc` | Computer Management |
| `lusrmgr.msc` | Local Users and Groups (Pro and higher) |
| `gpedit.msc` | Group Policy Editor (Pro and higher) |
| `wf.msc` | Windows Firewall with Advanced Security |
| `taskmgr` | Task Manager |
| `resmon` | Resource Monitor |
| `perfmon` | Performance Monitor |
| `msconfig` | System Configuration (boot options, startup, Safe Mode) |
| `msinfo32` | System Information |
| `dxdiag` | DirectX Diagnostic Tool (graphics and sound details) |
| `winver` | Windows version and build |
| `mdsched` | Windows Memory Diagnostic |
| `cleanmgr` | Disk Cleanup |
| `regedit` | Registry Editor. Export the key before editing it |
| `cmd` / `powershell` | Command Prompt / PowerShell |

## Control panel pages

| Command | Opens |
|---|---|
| `ncpa.cpl` | Network Connections |
| `appwiz.cpl` | Programs and Features (uninstall programs) |
| `sysdm.cpl` | System Properties |
| `powercfg.cpl` | Power Options |
| `mmsys.cpl` | Sound devices |
| `timedate.cpl` | Date and Time |
| `inetcpl.cpl` | Internet Options (proxy settings) |
| `control` | Control Panel |

## Folders

| Command | Opens |
|---|---|
| `%temp%` | Current user's temp folder |
| `%appdata%` | Roaming app data |
| `%localappdata%` | Local app data |
| `shell:startup` | Current user's startup folder |
| `shell:common startup` | Startup folder for all users |

## Keyboard shortcuts

| Keys | Action |
|---|---|
| Win+X | Quick-link menu: Device Manager, Disk Management, Terminal (Admin) |
| Ctrl+Shift+Esc | Task Manager directly |
| Ctrl+Alt+Del | Security screen: lock, sign out, Task Manager |
| Win+I | Settings |
| Win+L | Lock the PC |
| Win+Ctrl+Shift+B | Restart the graphics driver. Fixes a black or frozen screen without losing work |
| Win+P | Choose display mode (duplicate, extend, second screen only) |
| Win+Shift+S | Screenshot to clipboard |
| Win+V | Clipboard history (if turned on) |
| Ctrl+Shift+Enter in Win+R | Run the command as administrator |

## Boot, Safe Mode, and recovery

| Method | How |
|---|---|
| Safe Mode from Windows | Hold **Shift** while clicking Restart, then Troubleshoot, Advanced options, Startup Settings, Restart, then press 4 |
| Safe Mode with `msconfig` | Boot tab, tick Safe boot. **Untick it afterwards** or the PC keeps booting into Safe Mode |
| Recovery environment when Windows will not start | Power on and force it off (hold the power button) during the Windows logo three times in a row. Windows then opens recovery on the next start |
| Boot menu | Tap the manufacturer's key at power-on. Commonly F12, F9, F10, Esc or F2, but it varies by brand |
| BIOS/UEFI setup | Tap the manufacturer's key at power-on. Commonly F2, Del, F10 or Esc |
