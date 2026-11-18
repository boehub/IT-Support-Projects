# IT Support Projects

Tools, scripts, and guides for PC repair and IT support. Batch, PowerShell, Windows 11 diagnostics, backup, and network fixes.

This repo is a growing collection of things I use and build for hands-on support work: scripts that run from a USB stick on a customer's PC, plus reference material for the commands behind them.

## Projects

| Project | Description | Stack |
|---|---|---|
| [TechClub-Toolkit](TechClub-Toolkit/) | USB-ready Windows 11 repair toolkit: menu launcher, quick check (activation, Wi-Fi, sound), file backup, network fix, and a full repair/update run | Batch, PowerShell |
| [Reference](Reference/) | Command cheat sheet: DISM, SFC, CHKDSK, network resets, update fixes, cleanup | Text |

## Quick start: TechClub Toolkit

1. Copy the `TechClub-Toolkit` folder to a USB stick formatted exFAT or NTFS (not FAT32).
2. On the target Windows 11 PC, double-click `TechClub_Toolkit.bat` and approve the admin prompt.
3. Pick a tool from the menu. Logs and backups are written back to the USB.

Suggested order for a repair visit: **Quick Check → Backup → Network Fix (if needed) → Auto-Fix**. Always back up before changing anything.

See the [toolkit README](TechClub-Toolkit/README.txt) for what each tool does and what it changes.

## Safety notes

- Only run these tools on PCs you own or have permission to work on.
- Quick Check, Backup, and Network Fix "Diagnose" are read-only. Network Fix "Full reset" and Auto-Fix change settings and repair Windows.
- Backup copies files only and never copies browser passwords.
- The `Logs/` and `Backups/` folders contain customer data and are git-ignored. Do not commit them.
- Scripts assume an English-language Windows install.

## Repo layout

```
IT-Support-Projects/
├── TechClub-Toolkit/    USB toolkit (launcher, Tools/, Logs/, Backups/)
├── Reference/           Command cheat sheets
└── README.md
```

## Author

Built and maintained by [Ryan (@boehub)](https://github.com/boehub).
