# Motherboard

## What it does

The motherboard is the main circuit board. Every other part plugs into it or connects through it, and it holds the **firmware** (BIOS/UEFI) that starts the PC. It decides which CPU, RAM, and drives you can use.

## What is on it

| Part | Purpose |
|---|---|
| **CPU socket** | Holds the processor. Must match the CPU (for example, AM4 for the Ryzen 9 5950X) |
| **Chipset** | Controls how the CPU talks to storage, USB, and expansion slots. Decides features like how many ports and PCIe lanes |
| **RAM slots** | Hold memory. DDR4 and DDR5 boards are different |
| **PCIe slots** | For graphics cards and other expansion cards. The long one (x16) is usually for graphics |
| **M.2 and SATA ports** | For storage drives |
| **Power connectors** | A large 24-pin connector, plus a 4 or 8-pin connector near the CPU |
| **Front-panel headers** | Connect the case's power switch, reset switch, lights, and front USB and audio |
| **Fan headers** | Power and control the CPU and case fans |
| **VRMs** | Circuits that turn the power supply's 12 V into the CPU's low voltage. Often under heatsinks near the CPU |
| **Rear I/O** | USB, video out, network, audio |
| **CMOS battery** | A coin cell (usually CR2032) that keeps the BIOS clock and settings |
| **Firmware chip** | Stores the BIOS/UEFI |

## Form factors

| Size | Typical use |
|---|---|
| **ATX** | Standard full-size desktop board, most slots |
| **Micro-ATX (mATX)** | Smaller, fewer slots |
| **Mini-ITX** | Very small, usually one PCIe slot, for compact builds |

The case must support the board's form factor. A smaller board fits in a larger case but not the other way around.

## BIOS and UEFI

The firmware runs first. It tests the hardware (POST), sets up the parts, and hands over to the operating system. **UEFI** is the modern replacement for the older BIOS, with a graphical menu, support for large drives, and Secure Boot.

Common things set here: the boot order, the XMP/EXPO memory profile, virtualization support, Secure Boot, and TPM.

**Updating the BIOS** can fix compatibility with new CPUs or bugs, but a power cut during an update can leave the board unusable. Only update with a reason, on stable power, following the maker's instructions.

## Windows 11 requirements the motherboard affects

| Requirement | Where it comes from |
|---|---|
| UEFI with Secure Boot capability | Motherboard firmware |
| TPM 2.0 | A chip on the board, or firmware TPM in the CPU (shown as fTPM, Intel PTT, or AMD fTPM). Often disabled by default in BIOS |
| A compatible 64-bit CPU | See Microsoft's supported processor list |
| 4 GB RAM and 64 GB storage minimum | RAM and storage |

Check TPM status with `tpm.msc` (Win+R).

## Checking it

| Task | How |
|---|---|
| Make and model, BIOS version | `msinfo32` (System Information), or `Get-CimInstance Win32_BaseBoard` and `Win32_BIOS` |
| Check for BIOS updates | The motherboard or PC maker's support page for the exact model |

## Failure signs

| Sign | Possible cause |
|---|---|
| Clock resets and BIOS settings reset each time | Dead CMOS battery. Replace the coin cell |
| No power, no lights | Power supply, power switch connector, or board |
| Power but no picture, beep codes | RAM, CPU, graphics, or board. Check the manual for the code meanings |
| USB ports or network port stopped working | Driver, a damaged port, or the board |
| Swollen or leaking capacitors, burn marks | Board damage. Replace the board |

Diagnose the cheaper parts first. A board is rarely the problem until power, RAM, and the drive have been ruled out.
