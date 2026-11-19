TECH CLUB TOOLKIT
=================
For Windows 11 PCs. Runs from a USB stick. Double-click TechClub_Toolkit.bat.
It asks for administrator rights once and then shows a menu.

WHAT IS ON THE USB
  TechClub_Toolkit.bat      Menu launcher - start here
  Tools\QuickCheck.bat      Windows activation, Wi-Fi card, sound test (read-only)
  Tools\Backup.bat          Copies a user's files to the USB (copy only)
  Tools\NetworkFix.bat      Diagnose and repair network problems
  Tools\TechClub_AutoFix.bat  Full repair + update run (DISM, SFC, CHKDSK scan,
                            winget, Windows Update, Defender)
  Logs\                     One folder per run: <PCNAME>_<date>_<time>
  Backups\                  One folder per backup: <PCNAME>_<date>_<time>

Each tool can also be double-clicked on its own.

SUGGESTED ORDER FOR A REPAIR VISIT
  1. Quick Check   - is Windows activated, does the Wi-Fi card and sound work?
  2. Backup        - copy the customer's files BEFORE changing anything
  3. Network Fix   - if the machine has internet problems
  4. Auto-Fix      - repairs and updates (30-90 minutes, leave it running)
  Menu option 5 runs 1, 2 and 4 in that order.

NOTES
  - Quick Check, Backup and Network Fix "Diagnose" change nothing on the PC.
  - Network Fix "Full reset" and Auto-Fix DO change settings/repair Windows.
    Full reset can clear static IP settings and needs a restart.
  - Backup never copies browser passwords. Bookmarks are copied.
  - Backup uses the USB's free space. Use exFAT or NTFS, not FAT32
    (FAT32 cannot store a single file larger than 4 GB).
  - Keep the USB plugged in while a tool is running.
  - Windows may show a SmartScreen warning the first time. Right-click the
    downloaded .zip > Properties > Unblock before extracting to avoid it.
  - The scripts expect an English version of Windows (some output is parsed).
  - If a work/school PC blocks scripts through Group Policy, the PowerShell
    based tools (Quick Check, Backup) may refuse to run.
  - Only run these on PCs you have permission to work on.
  - Windows activation: Quick Check only REPORTS the state. If a PC is not
    activated, use Settings > System > Activation > Troubleshoot or a valid key.

WHAT AUTO-FIX CHANGES
  It asks Y/N before starting. Once started, it:
  - repairs the Windows image and system files (DISM, SFC)
  - scans the system drive with CHKDSK /scan (no repair, no restart)
  - updates installed apps with winget, if winget is present
  - asks Windows Update to scan, download and install updates
  - updates Defender signatures and runs a quick scan
  - DELETES the contents of the current user's temp folder and
    C:\Windows\Temp, then cleans the Windows component store. After the
    component store cleanup, installed Windows updates can no longer be
    uninstalled.
  It does not format, uninstall programs or edit the registry.

KNOWN LIMITS
  - Windows Update: Auto-Fix uses UsoClient, which Microsoft has deprecated.
    It does nothing on some Windows 11 builds. After a run, open Settings >
    Windows Update to confirm updates are really installing.
  - winget updates every app it can, silently. That can restart or close
    programs the customer has open.
  - CHKDSK /scan only checks. Fixing a drive needs chkdsk /f (see the
    Reference folder) and a restart.
  - Output is parsed in English, so other Windows languages may show wrong
    results or blank fields.
  - Group Policy on managed PCs can block PowerShell scripts, winget, or
    Windows Update changes. Do not try to get around a policy on a PC that
    is not yours.
  - Menu option 5 asks Y/N before Auto-Fix, and Auto-Fix asks again. This is
    deliberate.
