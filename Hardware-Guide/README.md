# Hardware Practical Guide

What the parts inside a PC are, what each one does, and what it looks like when it goes wrong. Written for hands-on support work, so each page ends with a practical section on **checking it, upgrading it, and failure signs**.

## The parts

| Guide | The part in one line |
|---|---|
| [01_CPU.md](01_CPU.md) | The processor: runs the instructions that every program is made of |
| [02_Memory_RAM.md](02_Memory_RAM.md) | Fast, temporary workspace for whatever is open right now |
| [03_Storage.md](03_Storage.md) | Permanent storage for Windows, programs, and files (HDD, SSD, NVMe) |
| [04_Motherboard.md](04_Motherboard.md) | The circuit board that connects everything and holds the firmware |
| [05_Graphics.md](05_Graphics.md) | Produces the picture; built into the CPU or a separate card |
| [06_Power_Supply.md](06_Power_Supply.md) | Converts wall power to the low voltages the parts use |
| [07_Cooling_and_Case.md](07_Cooling_and_Case.md) | Removes heat so the parts do not slow down or fail |
| [08_Laptops_vs_Desktops.md](08_Laptops_vs_Desktops.md) | What changes in a laptop: soldered parts, batteries, limited upgrades |
| [09_Glossary.md](09_Glossary.md) | Short definitions of common hardware terms |

## How it all fits together

When you press the power button:

1. The **power supply** sends power to the **motherboard**.
2. The **firmware** (BIOS/UEFI) on the motherboard starts, checks the CPU, RAM, and other parts (POST), then looks for a drive to boot from.
3. It hands over to **Windows on the storage drive**, which loads into **RAM**.
4. The **CPU** runs the instructions. Data it needs often is held in the CPU's own **cache**, then RAM, then storage, from fastest and smallest to slowest and largest.
5. The **graphics** hardware turns the results into the picture on the screen.
6. The **cooling** removes the heat all of this makes.

```
        Wall power
            |
      [Power supply] ---- powers everything
            |
       [Motherboard] ---- firmware, ports, slots
        |    |     |
     [CPU] [RAM] [Storage]      [Graphics]
        |                           |
     [Cooler]                    [Screen]
```

Because each step depends on the one before, a fault often looks like a different part's fault. A failing power supply can look like a bad motherboard; a failing drive can look like a "slow CPU". That is why the [runbooks](../Runbooks/) check in order and change one thing at a time.

## Memory vs storage, the most common confusion

| | RAM (memory) | Storage (drive) |
|---|---|---|
| Purpose | Working space for what is open now | Keeps everything permanently |
| Speed | Very fast | Slower (even SSDs) |
| When the PC is off | Emptied | Kept |
| Typical size | 8 to 32 GB | 256 GB to several TB |

A desk is a decent comparison. RAM is the desk surface, storage is the filing cabinet. A bigger desk lets you work on more at once, but it does not make the cabinet bigger.

## Before opening a PC

- **Shut down fully and unplug.** For laptops, also disconnect the battery if it is accessible.
- **Hold the power button for a few seconds** after unplugging to drain leftover charge.
- **Touch bare metal on the case** (or use an anti-static wrist strap) before touching parts. Static can damage components without any visible sign.
- **Handle cards and RAM by the edges.** Do not touch gold contacts.
- **Never open a power supply.** Its internal capacitors can hold a dangerous charge even when unplugged.
- **Photograph cables and screws before removing them,** and keep screws sorted by location.
- **Back up the customer's data first.** See the [Repair Visit Checklist](../Runbooks/01_Repair_Visit_Checklist.md).

## Related

- [Data Analysis](../Data-Analysis/): worked example of comparing two processors with real benchmark data
- [Reference sheets](../Reference/): commands for checking hardware from Windows
- [Runbooks](../Runbooks/): procedures that use this knowledge
