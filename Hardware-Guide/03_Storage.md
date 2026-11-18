# Storage (HDD, SSD, NVMe)

## What it does

Storage keeps Windows, programs, and files permanently, even with the power off. When you open something, it is copied from storage into RAM. Storage speed decides how fast the PC starts and how fast programs open.

## Types

| Type | How it works | Rough speed | Notes |
|---|---|---|---|
| **HDD** (hard disk drive) | Spinning magnetic platters and a moving read head | About 80 to 200 MB/s | Cheap per GB, large, slow, sensitive to knocks. Moving parts wear out |
| **SATA SSD** | Flash memory, no moving parts, SATA connection | Up to about 550 MB/s | A big improvement over an HDD. Comes as a 2.5-inch drive |
| **NVMe SSD** | Flash memory over PCIe | About 3,500 MB/s (PCIe 3.0) to 7,000 MB/s or more (PCIe 4.0 and above) | Usually a small M.2 stick that plugs straight into the motherboard |

Speeds are approximate and vary by model. For everyday use, the jump from HDD to any SSD matters far more than the difference between SATA and NVMe.

## Connections and shapes

| Name | What it is |
|---|---|
| **SATA** | The data cable standard for 2.5-inch and 3.5-inch drives. Separate power cable from the power supply |
| **M.2** | A small stick form factor. The slot can carry **SATA or NVMe**, depending on the drive and slot |
| **PCIe** | The fast connection NVMe drives use |
| **2.5-inch / 3.5-inch** | Laptop-size / desktop-size drive bodies |

M.2 is only the **shape**. An M.2 SATA drive and an M.2 NVMe drive look similar but are not interchangeable in every slot. Check what the slot supports and the length (2280 means 22 mm wide and 80 mm long).

## Partition styles

| Style | Notes |
|---|---|
| **GPT** | Required for UEFI boot on modern PCs and for drives over 2 TB. Windows 11 needs UEFI with Secure Boot capability |
| **MBR** | Older, limited to 2 TB per drive. Used with legacy BIOS boot |

## File systems

| | Max single file | Good for |
|---|---|---|
| **NTFS** | Very large | Windows drives and large external drives |
| **exFAT** | Very large | USB sticks used with both Windows and Mac. Used for the Toolkit USB |
| **FAT32** | **4 GB** | Old devices only. Backups with large files fail on FAT32 |

## Health and wear

- **SMART** is the drive's built-in self-report. Windows exposes a summary through `Get-PhysicalDisk | Select FriendlyName, HealthStatus`. Tools such as CrystalDiskInfo show the full attributes.
- SSDs wear with writes and are rated in TBW (terabytes written). Ordinary use rarely reaches the limit before the PC is retired.
- Keep SSDs from being filled to the brim; some free space helps performance.

## Checking it

| Task | How |
|---|---|
| Type and size | Task Manager > Performance > Disk (shows SSD or HDD) |
| Health | `Get-PhysicalDisk`, or CrystalDiskInfo |
| Free space | `Get-Volume \| Where DriveLetter` or File Explorer |
| File system errors | `chkdsk C: /scan` |

## Upgrading and cloning

1. Check what the PC supports: 2.5-inch SATA, M.2 SATA, or M.2 NVMe, and the free slot or bay.
2. **Back up first.** Cloning tools copy the whole drive to the new one so Windows and programs carry over. Check the new drive boots before wiping the old one.
3. If the new drive is larger, extend the partition in Disk Management afterwards.
4. Replacing an HDD with an SSD is the single biggest speed-up on an older PC.

## Failure signs

| Sign | Possible cause |
|---|---|
| Clicking, grinding, or very slow HDD | Mechanical failure. Stop using it, copy data off at once, or take it to a recovery service |
| Files disappear or will not open, errors in Event Viewer | File system damage or a failing drive |
| Disk at 100% in Task Manager | Slow HDD, failing drive, or heavy background work |
| PC does not see the drive in BIOS | Loose connection, or a dead drive |
| SSD suddenly vanishes or becomes read-only | Controller failure or reached end of life. Data may still be readable; do not keep rewriting |

Do not run `chkdsk /r` on a drive that is making noises or reporting unhealthy. Back up first. The [No-boot runbook](../Runbooks/02_PC_Wont_Boot.md) covers what to do when a drive is not detected.
