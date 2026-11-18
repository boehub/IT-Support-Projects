# CPU (Processor)

## What it does

The CPU runs the instructions that programs are made of: arithmetic, comparisons, and moving data around. Everything you do on a PC goes through it. It also coordinates the other parts.

## The specs that matter

| Spec | Meaning | Why it matters |
|---|---|---|
| **Cores** | Independent processing units inside one chip | More cores help when many tasks run at once, or one task can be split (rendering, video export) |
| **Threads** | Instruction streams the cores can handle. Many CPUs run 2 per core (SMT/Hyper-Threading) | An 8-core, 16-thread CPU appears as 16 processors in Task Manager |
| **Base clock** | Speed the CPU is designed to hold under sustained load (GHz) | Not the full story: see boost |
| **Boost clock** | Highest speed a core can reach briefly, power and temperature permitting | Drives single-core feel: app launches, browsing, many games |
| **Cache (L1, L2, L3)** | Tiny, very fast memory built into the CPU | Keeps frequently used data close. Larger L3 helps many workloads |
| **TDP** | Rated power and heat target, in watts | Shows the class of the chip, and how much cooling it needs. It is **not** measured power use |
| **Architecture / generation** | The design of the cores (for example, Zen 2, Zen 3) | A newer generation often does more at the same clock |
| **Integrated graphics** | A small graphics unit built into the CPU | Some CPUs have it; some need a separate graphics card |
| **Socket** | The physical connection to the motherboard | Decides which motherboards the CPU fits |

## Clock speed is not performance

Two CPUs with similar clocks can perform very differently. Cores, cache, architecture, and power limits all change the result, which is why people measure with benchmarks. The [comparison dashboard](../Data-Analysis/) in this repo shows this with real figures:

| | Ryzen 7 4800U (laptop) | Ryzen 9 5950X (desktop) |
|---|---|---|
| Cores / threads | 8 / 16 | 16 / 32 |
| Boost clock | 4.2 GHz | 4.9 GHz |
| TDP | 15 W | 105 W |
| Cinebench R23 multi-core | 9,974 | 28,577 |
| Integrated graphics | Radeon Vega 8 | None |

Single-core scores are close in feel (1,227 vs. 1,644 in Cinebench R23), while multi-core is nearly 3 times higher on the desktop chip, which has twice the cores and seven times the power budget. For everyday web and office use, both are quick; the difference shows in heavy work such as 3D rendering.

## Laptop and desktop CPUs

- **Laptop chips** are tuned for lower power and less heat. The same chip can perform differently in different laptops, depending on the cooling and the power limit the maker sets.
- **Desktop chips** can use more power and cooling to sustain higher speeds.
- Laptop CPUs are usually **soldered** to the board. Desktop CPUs sit in a **socket** and can be replaced, within the limits of the motherboard.

## Checking it

| Task | How |
|---|---|
| See model, cores, speed | Task Manager > Performance > CPU, or `Get-CimInstance Win32_Processor \| Select Name, NumberOfCores, NumberOfLogicalProcessors` |
| See live load | Task Manager > Performance, Resource Monitor (`resmon`) |
| See temperature | BIOS/UEFI, or a tool such as HWiNFO or Core Temp. Windows does not show it by default |

## Upgrading

- Desktop: the new CPU must fit the **socket**, be supported by the **motherboard's chipset and BIOS version**, and be within what the **cooler** can handle. Check the motherboard maker's CPU support list before buying.
- Laptop: usually not possible.
- Often a drive or RAM upgrade gives a bigger real-world gain than a CPU upgrade.

## Failure signs

| Sign | Possible cause |
|---|---|
| Random shutdowns under load | Overheating (cooler, paste, dust, fan) |
| CPU speed drops under load (throttling) | Heat or a power limit |
| 100% CPU at idle | A runaway process or malware (see [Slow PC](../Runbooks/03_Slow_PC.md)) |
| No POST, no picture | RAM, motherboard, or CPU; test in order |
| Bent pins (older sockets) | Damaged in handling. Do not force it |

True CPU failure is rare. Check heat, power, RAM, and software first.
