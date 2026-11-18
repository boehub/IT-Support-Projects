# Power Supply (PSU)

## What it does

The power supply converts mains AC from the wall into the low-voltage DC (mainly 12 V, 5 V, and 3.3 V) that the parts need. A weak, failing, or undersized power supply causes strange faults that look like other parts failing.

## The specs that matter

| Spec | Meaning |
|---|---|
| **Wattage** | Maximum it can deliver. Choose by the parts' total draw with some headroom, not by the biggest number |
| **Efficiency (80 Plus)** | Ratings from Bronze up through Silver, Gold, Platinum, and Titanium show how little power is wasted as heat. Higher is more efficient and usually better built |
| **Modularity** | Non-modular (all cables fixed), semi-modular, or fully modular. Modular is tidier to install |
| **Form factor** | ATX is standard; SFX is for small cases |
| **Connectors** | Must include what the parts need |

## Connectors

| Connector | Powers |
|---|---|
| **24-pin ATX** | The motherboard |
| **4+4 or 8-pin EPS (CPU)** | The CPU's power circuit. Do **not** plug a graphics-card cable into the CPU socket or the reverse; they are similar but wired differently |
| **PCIe 6+2 pin** | Graphics cards |
| **12VHPWR / 12V-2x6** | Newer high-power graphics cards. Seat fully |
| **SATA power** | 2.5-inch and 3.5-inch drives, some fans and lighting |
| **Molex (4-pin)** | Older devices and some fans |

## Sizing

Add up the parts' power use. The CPU's TDP and the graphics card's rated power are the biggest items. For example, the Ryzen 9 5950X in the [comparison data](../Data-Analysis/) has a rated TDP of 105 W, and a modern graphics card can use far more than that. Check the graphics card maker's recommended power supply and leave headroom, which also keeps the supply running cooler and quieter.

## Laptop adapters

A laptop's charger is its power supply. It must match the voltage and have at least the wattage the maker specifies. A wrong or worn charger causes "plugged in, not charging", battery drain under load, or slow performance. Use a charger from the maker or a trusted match with the same connector.

## Checking it

| Task | How |
|---|---|
| Confirm the supply's rating | The label on the unit |
| Check a laptop battery | `powercfg /batteryreport` |
| Quick check of a desktop supply | Swap in a known-good one |

A multimeter or a PSU tester can check voltages, but a swap with a known-good unit is quicker and more reliable.

## Failure signs

| Sign | Possible cause |
|---|---|
| Nothing happens when you press power | Dead supply, switch off at the supply, loose 24-pin or power switch connector |
| Random shutdowns or restarts, especially under load | Overloaded or failing supply, or overheating |
| Blue screens with no clear pattern | Unstable power |
| Burning smell, smoke, or a loud bang | Unplug at once and replace the supply |
| Coil whine or buzzing | Often harmless, but can come with an overworked supply |
| Laptop does not charge | Charger, cable, port, or battery |

## Safety

- **Never open a power supply.** Capacitors inside can hold a dangerous charge long after it is unplugged.
- Turn the switch off and unplug before touching cables.
- Replace a failed supply with a new unit from a reputable maker. A cheap supply that fails can damage other parts.
- A power surge can damage parts. Recommend a surge protector or UPS for important PCs.
