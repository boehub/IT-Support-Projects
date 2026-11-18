# Runbook: Slow PC

**Version:** 1.0

## When to use this

The customer says the PC is slow, freezes, takes a long time to start, or programs hang.

## What you need

- Task Manager (Ctrl+Shift+Esc)
- The Toolkit USB
- Knowledge of the PC's RAM and drive type (see [Hardware Guide](../Hardware-Guide/))

## Steps

1. **Ask when it is slow.** Only at startup? All the time? Only in one program? Only on the internet?
2. **Back up** the customer's files first ([Repair Visit Checklist](01_Repair_Visit_Checklist.md)).
3. **Open Task Manager > Performance.** Watch CPU, Memory, Disk, and network while it is slow.

| What you see | Likely cause | Go to |
|---|---|---|
| Disk at 100% on a spinning hard drive | The drive is the bottleneck, or it is failing | Step 4 |
| Memory above about 85% | Not enough RAM, or something using too much | Step 5 |
| CPU at 100% constantly | A runaway process, malware, or overheating | Step 6 |
| Everything low but still slow | Network, a bad app, or the browser | Step 7 |

4. **Disk.**
   - Check health: `Get-PhysicalDisk | Select FriendlyName, MediaType, HealthStatus`.
   - If the drive is a hard drive (HDD) running Windows 11, replacing it with an SSD is the single biggest speed-up.
   - Check free space. Under about 10% free slows Windows. Clear space with Storage Settings or `cleanmgr`.
   - Run `chkdsk C: /scan`.
5. **Memory.**
   - Sort Task Manager's Processes tab by Memory to see what is using it.
   - Many browser tabs and extensions are common culprits.
   - 8 GB is the practical minimum for Windows 11 today; 16 GB is more comfortable. Check whether the RAM can be upgraded (many thin laptops have it soldered).
6. **CPU.**
   - Sort by CPU. Identify the process before ending it.
   - If it is Windows itself (Update, search indexing, Defender), let it finish and see if it settles.
   - If it is unknown, go to [Suspected Malware](05_Suspected_Malware.md).
   - Check temperatures and fans on a laptop. Dust and old thermal paste cause throttling. See [Cooling and Case](../Hardware-Guide/07_Cooling_and_Case.md).
7. **Startup and apps.**
   - Task Manager > Startup apps: disable what the customer does not need at sign-in. This changes nothing about installed programs.
   - Uninstall unused programs through `appwiz.cpl`.
   - Update drivers, especially graphics and chipset, from the manufacturer.
8. **Run Auto-Fix** from the Toolkit to repair Windows files and install pending updates.
9. Restart and compare against what you saw in step 3.

## How to confirm it worked

Startup time and the original complaint have improved, and Task Manager no longer pins disk, memory, or CPU at idle.

## If it did not work

- Slow after all of this on an old HDD or 4 GB RAM machine: recommend a hardware upgrade (SSD, more RAM) with a quote.
- Reinstalling Windows is a last resort, and only with a verified backup and the customer's agreement.

## Notes

- Do not disable Windows services or run "registry cleaners" or "PC booster" tools. They rarely help and can cause damage.
- Do not ask the customer to disable antivirus to "speed things up".
