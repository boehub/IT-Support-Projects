# Memory (RAM)

## What it does

RAM (random-access memory) holds the programs and data in use right now, so the CPU can reach them far faster than from a drive. When the PC powers off, RAM is emptied. If Windows runs out of RAM, it starts using the drive as a slow overflow (the page file), and the PC feels slow.

## The specs that matter

| Spec | Meaning |
|---|---|
| **Capacity** | Total GB. 8 GB is a practical minimum for Windows 11 today; 16 GB is comfortable for general use; 32 GB or more suits heavy multitasking, rendering, and virtual machines |
| **Type** | DDR4 or DDR5. They are **not interchangeable**: the notches differ and they will not fit the wrong slot |
| **Form factor** | **DIMM** (desktop, full size) or **SO-DIMM** (laptop, about half the length) |
| **Speed** | MT/s (for example, DDR4-3200, DDR5-5600). The motherboard and CPU set the real limit |
| **Channels** | Two matched sticks (dual channel) give more memory bandwidth than one |
| **Latency (CL)** | Delay in clock cycles. Lower is better at the same speed |
| **XMP / EXPO** | A profile in BIOS/UEFI that runs RAM at its rated speed. Without it, RAM may run slower than advertised |

## Soldered and upgradeable RAM

Many thin laptops have RAM **soldered to the board**, with no slot. Others have one or two SO-DIMM slots, and some have a mix (some soldered, one slot). Check before promising an upgrade. The model's service manual or the maker's spec page will say.

## Checking it

| Task | How |
|---|---|
| Capacity and usage | Task Manager > Performance > Memory |
| Slots used, type, speed | Task Manager > Performance > Memory (shows "Slots used", "Speed", "Form factor") |
| Module details | `Get-CimInstance Win32_PhysicalMemory \| Select BankLabel, Capacity, Speed, Manufacturer, PartNumber` |
| Test for faults | `mdsched.exe` (Windows Memory Diagnostic, restarts the PC), or MemTest86 from a USB for a deeper test |

## Upgrading

1. Find out what the machine takes: DDR generation, DIMM or SO-DIMM, maximum capacity per slot and in total.
2. Buy **matched** sticks where possible, and fill slots in the order the manual says (usually the slots farthest from the CPU, and in pairs for dual channel).
3. Power off, unplug, and ground yourself. Open the retaining clips, line up the notch, and press down evenly until the clips click.
4. On first start the PC may take longer to POST while it trains the new memory.
5. Confirm the new total in Task Manager, and run the memory test.

## Failure signs

| Sign | Possible cause |
|---|---|
| Blue screens with different errors each time | Faulty RAM, or software and drivers |
| PC will not POST, beeps, or shows a memory diagnostic light | Not seated, incompatible, or faulty RAM |
| Reboots or crashes only under heavy use | Faulty RAM, overheating, or a power problem |
| Shows less than installed | Not seated, a bad slot, or a 32-bit OS (rare now), or graphics sharing some RAM |

Test sticks one at a time, in the first slot, to find a faulty one. If a stick fails MemTest86 even once, replace it.
