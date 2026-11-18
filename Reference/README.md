# Reference Sheets

Quick lookups for the commands and shortcuts used on repair visits. Each sheet is one page you can scan during a job.

| Sheet | What it covers |
|---|---|
| [pc_cmd_health_checks.txt](pc_cmd_health_checks.txt) | Original plain-text cheat sheet: repair, drive checks, network resets, cleanup, performance, Windows Update |
| [Windows_Repair_Commands.md](Windows_Repair_Commands.md) | Repair and health commands with the correct order, what each one changes, and a safe Windows Update reset |
| [PowerShell_Equivalents.md](PowerShell_Equivalents.md) | The same jobs in PowerShell, including replacements for deprecated `wmic` |
| [Network_Commands.md](Network_Commands.md) | Network diagnostics, IP ranges, subnet sizes, and common ports |
| [Run_Commands_and_Shortcuts.md](Run_Commands_and_Shortcuts.md) | Win+R commands for Windows tools, keyboard shortcuts, and ways into Safe Mode and recovery |

## How to read these sheets

- **Read-only** commands only look at the PC. **Changes** commands alter settings, files, or services. Run the read-only ones first.
- Most repair commands need an **administrator** Command Prompt or PowerShell (right-click, Run as administrator).
- Back up the customer's files before running anything marked **Changes**. The [Toolkit](../TechClub-Toolkit/) does this with its Backup tool.
- Commands are written for English-language Windows 10 and 11.
