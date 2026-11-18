# Laptops vs. Desktops

The parts do the same jobs in both, but laptops pack them tightly, share limited power and cooling, and often make parts impossible to replace. Knowing this before quoting a repair saves time and disappointment.

## Comparison

| | Desktop | Laptop |
|---|---|---|
| **CPU** | Socketed, replaceable within limits | Usually soldered |
| **RAM** | DIMM slots, easy to upgrade | SO-DIMM slots on some, soldered on many thin models |
| **Storage** | Several drive bays and M.2 slots | Often one M.2 slot, sometimes a spare |
| **Graphics** | Dedicated card can be swapped | Integrated, or a soldered dedicated chip |
| **Power** | Standard power supply, easily swapped | Charger plus battery, with a fixed power budget |
| **Cooling** | Large coolers and many fans | Small fans and heat pipes, limited headroom |
| **Display, keyboard, trackpad** | Separate, easy to replace | Part of the unit, each a separate repair |
| **Upgrade path** | Wide | Narrow |
| **Repair difficulty** | Lower | Higher, with clips, ribbon cables, and glued parts |

## What affects repair and upgrade decisions

1. **Find the exact model** (from the label or `Get-CimInstance Win32_ComputerSystem`). Service manuals and parts lists are by model.
2. **Check what is soldered.** RAM and sometimes the whole storage or wireless card can be fixed.
3. **Check the warranty.** Opening the case can void it.
4. **Weigh cost against value.** An older laptop with a worn battery and a failing drive may cost more to repair than its value. Say so honestly.

## Laptop-specific points

- **Battery.** Lithium-ion batteries wear out with use. `powercfg /batteryreport` shows design capacity against current full-charge capacity; well below about 60 to 70% of design is a worn battery. A **swollen battery** (case or trackpad lifting) is a safety risk: stop using it, do not charge it, and replace it.
- **Disconnect the battery** (internal connector) before swapping RAM, storage, or wireless cards, where the manual says to.
- **Wi-Fi card.** Often an M.2 card with antenna leads. A laptop that cannot see any networks may have an unplugged antenna, a disabled radio (Fn key, airplane mode), or a failed card.
- **Power limits.** The same CPU can run faster in one laptop than another, depending on the power limit and cooling the maker set. Benchmarks for the chip do not always match a specific laptop. The [comparison data](../Data-Analysis/) notes this limit.
- **Hybrid graphics.** Laptops with both integrated and dedicated graphics switch between them. Settings > System > Display > Graphics chooses per app.
- **Docking and external displays.** Check the ports: HDMI, DisplayPort over USB-C, and whether the USB-C port supports video and charging.

## Quick upgrade guide

| Upgrade | Usually possible? |
|---|---|
| Replace HDD with SSD | Yes in most older laptops |
| Add or replace RAM | Only with SO-DIMM slots |
| Replace the battery | Often yes, with the right part |
| Replace the Wi-Fi card | Often yes, if it is a socketed M.2 card |
| Replace the CPU or graphics chip | Almost never |
| Replace the screen | Yes, with the matching panel |

## All-in-one and mini PCs

All-in-one PCs (the computer is behind the screen) and mini PCs sit between laptops and desktops: more upgradable than a thin laptop, less than a tower, and with tight cooling. Check the service manual first.
