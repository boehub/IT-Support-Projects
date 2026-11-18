# Cooling and Case

## What it does

Every part turns the electricity it uses into heat. Cooling carries that heat away. If it cannot, the CPU and GPU **throttle** (slow down on purpose) to stay safe, and in the worst case the PC shuts off. Heat is behind a large share of "slow" and "crashes under load" complaints.

## How heat moves

1. A **heatsink** (metal fins) sits on the chip. **Thermal paste** fills the tiny gaps between the chip and the heatsink so heat transfers well.
2. **Fans** push air through the heatsink and carry the heat away.
3. In a desktop case, **case fans** bring cool air in and push hot air out.
4. In a laptop, **heat pipes** move heat from the chip to a fan and vents.

## Types of CPU cooler

| Type | Notes |
|---|---|
| **Stock (box) cooler** | Supplied with many CPUs. Fine for modest use; can be loud under load |
| **Tower air cooler** | Large heatsink with a fan. Quiet and effective, no liquid to leak |
| **AIO liquid cooler** | Sealed loop with a pump, radiator, and fans. Good for high-end CPUs and some cases. Pumps and fans can fail |
| **Passive** | No fan; relies on airflow. Used in some small or silent builds |

The cooler must fit the **socket** and be rated for the CPU's heat output (TDP). The Ryzen 9 5950X in the [comparison data](../Data-Analysis/) is rated at 105 W, which needs a substantial cooler. The 15 W Ryzen 7 4800U needs far less, which is why it fits in a thin laptop, though thin laptops have little room to cool even that for long.

## Case airflow

- **Front and bottom intake, rear and top exhaust** is the usual pattern. Air flows from front to back and bottom to top.
- A case with solid panels and few fans traps heat. Mesh fronts breathe better.
- Keep cables tidy so they do not block airflow.
- Keep vents clear. A PC pushed against a wall or placed on carpet runs hotter.

## Temperatures (rough guide)

| Situation | Typical range |
|---|---|
| CPU idle | 30 to 50 °C |
| CPU under heavy load | 60 to 85 °C |
| CPU limit where throttling starts | Often the 90s °C, depends on the model |
| GPU under load | 60 to 85 °C |
| Hard drive | Under about 45 to 50 °C |

Check the maker's rated maximum for the exact part. A reading that keeps hitting the limit means a cooling problem.

## Maintenance

| Task | How often | Notes |
|---|---|---|
| Clear dust from vents, filters, and fans | Every 6 to 12 months, more with pets or carpets | Use short bursts of compressed air. Hold the fan blades still so they do not over-spin. Do not use a vacuum on electronics without anti-static care |
| Replace thermal paste | When temperatures are high and dust is not the cause, often after 3 to 5 years | Clean off the old paste with isopropyl alcohol, use a **pea-sized** dot, and mount the cooler evenly |
| Replace a failed fan | When it is noisy, wobbly, or does not spin | Match the size and connector |

On laptops, opening the case may void the warranty and the parts are cramped and delicate. Look up the model's service guide first.

## Checking it

| Task | How |
|---|---|
| Temperatures | HWiNFO, Core Temp, or the BIOS/UEFI hardware monitor |
| Fan speeds | BIOS/UEFI or the same tools |
| Throttling | Watch the CPU clock speed under load. If it falls sharply as the temperature rises, the PC is throttling |

## Failure signs

| Sign | Possible cause |
|---|---|
| Loud fans at idle | Dust, a failing fan, or high background load |
| Shuts down suddenly, especially during games or renders | Overheating |
| Hot to the touch on a laptop, slow performance | Blocked vents, dust, dried paste |
| Grinding or ticking from a fan | Failing fan bearing |
| CPU fan error on start-up | Fan unplugged or failed |

## The case

The case holds and protects the parts and shapes the airflow. Check it supports the motherboard size, the graphics card length, the cooler height, and the power supply size before buying or building.
