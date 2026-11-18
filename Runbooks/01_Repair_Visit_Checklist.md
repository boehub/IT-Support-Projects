# Runbook: Repair Visit Checklist

**Version:** 1.0

## When to use this

Every repair visit, from arrival to leaving. Individual problems have their own runbooks; this is the frame around them.

## What you need

- The Toolkit USB (exFAT or NTFS, with enough free space for a backup)
- A second USB or other way to download drivers if the PC has no internet
- Power adapter and any cables the customer's PC needs
- A way to write notes

## Steps

### 1. Arrive and agree the job

1. Confirm the owner has agreed you can work on this PC.
2. Ask what is wrong, when it started, and whether anything changed (new software, a drop, a power cut, an update).
3. Ask what matters most: usually the files, then getting the PC working.
4. Ask for sign-in details if needed. Do not write passwords in your notes.
5. Tell them if there is any risk to their data and what you will do about it.

### 2. Look before touching

1. Note the make, model, serial number, and Windows version.
2. Check the obvious: power, cables, battery, Wi-Fi switch, volume, a stuck key.
3. Run the Toolkit **Quick Check** (activation, Wi-Fi card, sound). It changes nothing.
4. Check the drive health with Task Manager's Performance tab or `Get-PhysicalDisk`.

### 3. Protect the data

1. Run the Toolkit **Backup** and select the user profiles.
2. Confirm every item says OK and that the log has no failures.
3. Spot-check by opening a few files from the backup folder.
4. If the drive is failing or the backup has problems, stop and tell the customer before going further.

### 4. Fix

1. Follow the matching runbook: [boot](02_PC_Wont_Boot.md), [slow](03_Slow_PC.md), [network](04_No_Internet.md), [malware](05_Suspected_Malware.md).
2. For general health, run **Network Fix** if there are connection problems, then **Auto-Fix** (30 to 90 minutes).
3. Change one thing at a time and test after each.
4. Restart when Windows asks, then check again.

### 5. Verify

1. Reproduce the original problem. Is it gone?
2. Check Windows Update shows no pending errors and Defender shows no active threats.
3. Check the things you did not touch still work: internet, sound, printer, sign-in.
4. Check **Settings > System > Activation**.

### 6. Hand over

Follow [06_Customer_Handoff.md](06_Customer_Handoff.md).

## How to confirm it worked

The customer's original complaint no longer happens, the backup is verified, and the PC restarts cleanly.

## If it did not work

Stop, tell the customer what you found, and recommend the next step (parts, a bench repair, or a reinstall with their backup). Do not start a reinstall without agreement.

## Notes

- Auto-Fix and Network Fix "Full reset" change the PC. Never run them before the backup.
- Do not enter or recover the customer's accounts, passwords, or licence keys unless they ask you to.
