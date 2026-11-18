# Runbook: PC Won't Boot

**Version:** 1.0

## When to use this

The PC does not turn on, turns on but shows nothing, stops before Windows, or loops (restarts repeatedly, "Preparing Automatic Repair", blue screen on every start).

## What you need

- A known-good power adapter or power cable
- A Windows 11 installation USB (made with Microsoft's Media Creation Tool) for repair options
- The Toolkit USB (for backup if the drive can be reached)
- A screwdriver if it is a desktop

## Steps

### A. No power, no lights, no fans

1. Check the wall socket and power strip with something else plugged in.
2. **Laptop:** try a known-good charger, hold the power button 30 seconds with the charger unplugged, then plug in and try again.
3. **Desktop:** check the cable, the switch on the back of the power supply, and the front panel power connector.
4. If still nothing, the power supply, motherboard, or battery has failed. Escalate. See [Hardware Guide: Power Supply](../Hardware-Guide/06_Power_Supply.md).

### B. Power and fans, but no picture

1. Check the monitor cable and input. Try another cable or monitor.
2. **Desktop:** plug the monitor into the graphics card if there is one, not the motherboard.
3. Reseat the RAM (power off and unplug first). Try one stick at a time, in the first slot.
4. Look for beep codes or a diagnostic light; the motherboard manual lists their meaning.
5. Try clearing CMOS (remove the coin cell for a minute with power unplugged).

### C. Picture, but "No bootable device" or similar

1. Enter BIOS/UEFI (see [Run_Commands_and_Shortcuts.md](../Reference/Run_Commands_and_Shortcuts.md)).
2. Check the drive is **detected**. If it is not, reseat its cable or connector. A drive that still does not appear has probably failed.
3. Check the boot order puts the Windows drive first.
4. If the drive is detected but will not boot, continue to D.

### D. Windows starts but fails or loops

1. Force off three times during the Windows logo to reach the recovery environment.
2. Choose **Troubleshoot > Advanced options > Startup Repair**.
3. If that fails, try **Uninstall Updates** (latest quality update, then feature update).
4. Try **Safe Mode** (Startup Settings, option 4). If Windows works there, a driver or startup program is the cause.
5. From Safe Mode or the recovery Command Prompt, run:
   - `sfc /scannow /offbootdir=C:\ /offwindir=C:\Windows`
   - `DISM /Image:C:\ /Cleanup-Image /RestoreHealth` (the drive letter in recovery can differ from C:; check with `diskpart` then `list vol`)
   - `chkdsk C: /f`
6. **Before any reset or reinstall,** copy the customer's files out. From the recovery Command Prompt, `notepad` > File > Open lets you browse the drive and copy files to the USB.
7. Last resort, with the customer's agreement: **Troubleshoot > Reset this PC > Keep my files**, or reinstall from the installation USB.

## How to confirm it worked

The PC restarts three times in a row and reaches the desktop, with no repair loop.

## If it did not work

- A drive that is not detected, clicks, or is extremely slow: stop. Tell the customer their data may need professional recovery. Do not keep powering it on.
- A bad motherboard or power supply: quote the repair or replacement.

## Notes

- Do not run `chkdsk /r` on a drive that is clicking or very slow. Copy the data first.
- BitLocker: if the recovery key is asked for, the customer or their Microsoft account holds it. Do not guess.
