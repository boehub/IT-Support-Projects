# Screenshots

What the TechClub Toolkit looks like when it runs, so you know what to expect before you are standing at a customer's PC.

| Folder | What it contains |
|---|---|
| [`examples/`](examples/) | Example screens with **sample values**. Wording and layout come from the scripts; the PC name, serial, sizes, and counts are made up |
| [`real/`](real/) | Screenshots captured from actual runs of the toolkit (see the capture guide below) |

## Example screens

| Image | Shows |
|---|---|
| ![Main menu](examples/01_main_menu.png) | **Main menu.** `TechClub_Toolkit.bat`, the launcher |
| ![Quick Check](examples/02_quick_check.png) | **Quick Check.** Activation, Wi-Fi card and sound, each with PASS / WARN / FAIL / SKIP and a final RESULT line |
| ![Network Diagnose, healthy](examples/03a_network_diagnose_healthy.png) | **Network Fix, Diagnose (healthy).** The router, internet, DNS and DHCP checks, ending in a verdict |
| ![Network Diagnose, DNS problem](examples/03b_network_diagnose_dns_problem.png) | **Network Fix, Diagnose (DNS problem).** What a failing result looks like and the advice it gives |
| ![Backup selection](examples/04_backup_selection.png) | **Backup, selection screen.** Profiles, per-folder sizes, total against free USB space. Nothing has been copied at this point |

These screens were generated from the scripts' own text and output format rather than captured from a run. The values in them (`DEMO-PC`, `DemoUser`, the serial number, drive letter, sizes, file counts, network count, and speed) are samples. They show what the output looks like, not the result on any particular PC.

## Capture guide: real screenshots

Take these on a Windows 11 PC you own or have permission to work on.

1. Run `TechClub_Toolkit.bat` from the USB and approve the admin prompt.
2. Capture the screens that change nothing:
   - **Main menu** (the first screen)
   - **Quick Check** (menu option 1). Say `n` when it offers the speaker test if you want a quiet run
   - **Network Fix > Diagnose** (menu option 3, then 1)
   - **Backup selection screen** (menu option 2, choose a profile). **Stop at the "Press Enter to START" line and quit**, or the backup will run
3. Use **Win+Shift+S** and drag over the window, then save from the notification or paste into Paint.
4. Name files to match the examples, for example `01_main_menu.png`, so the two folders line up.

### Before you commit a real screenshot

Real runs contain details you probably should not publish. Check each image, and blur or crop:

| Where it appears | What to hide |
|---|---|
| Menu and Network Fix headers | The computer name, if it identifies you or a customer |
| Quick Check header | **Serial number**, and the "Key ends" characters |
| Quick Check and Network Fix | Wi-Fi network names, IP addresses, MAC addresses |
| Backup | The username and any folder names that show personal or customer files |
| Anywhere | Customer names, email addresses, file names |

Do not commit anything from a customer's PC without their permission. Logs and backups are git-ignored for the same reason (see the toolkit's `.gitignore`).

To blur in Windows, Paint's selection tool can fill a rectangle with a solid colour. A solid block is safer than a light blur.
