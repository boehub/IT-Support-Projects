# Graphics (GPU)

## What it does

The GPU (graphics processing unit) draws everything you see: the desktop, video, games, and 3D scenes. It is built to do huge numbers of simple calculations at once, which also suits 3D rendering, video editing, and machine learning.

## Integrated and dedicated

| | Integrated (iGPU) | Dedicated (discrete) |
|---|---|---|
| Where | Built into the CPU | A separate card in a PCIe slot (or a separate chip in a laptop) |
| Memory | Shares the PC's RAM | Has its own fast memory (VRAM) |
| Power and heat | Low | Much higher |
| Good for | Office, browsing, video, light and older games | Modern games, 3D work, video editing, AI work |
| Cost | Included | Extra cost |

Example from the [comparison data](../Data-Analysis/): the Ryzen 7 4800U includes Radeon Vega 8 graphics and plays older or light games at 1080p on low settings, such as roughly 60 FPS in GTA V on lowest settings, while the Ryzen 9 5950X has **no integrated graphics** and needs a separate card to show any picture at all. That is not a weakness of the 5950X; it is a different design for a desktop that gets a graphics card.

## The specs that matter

| Spec | Meaning |
|---|---|
| **VRAM** | The card's own memory. Holds textures and frame data. Too little causes stutter at high resolutions or detail |
| **GPU model / generation** | The design. Higher numbers within a generation are generally faster |
| **Power draw (TBP/TGP)** | Sets the power supply and cooling needed |
| **Outputs** | HDMI, DisplayPort, USB-C. Check they match the monitor |
| **Interface** | PCIe x16 in nearly all desktops |
| **Card length and slot width** | Must fit in the case |

## Connections and power

- Cards that draw more than the slot can supply (about 75 W) need **power cables** from the power supply: PCIe 6+2 pin, or a 12VHPWR / 12V-2x6 connector on newer cards. Push connectors in fully; a partly seated connector can overheat.
- **Plug the monitor into the card,** not the motherboard, when a dedicated card is installed. Using the motherboard port sends the picture through the weaker integrated graphics, or shows nothing.

## Drivers

Graphics drivers affect speed, stability, and features. Get them from the GPU maker (AMD, Intel, NVIDIA) or the laptop maker for laptops that use customised drivers. Use the maker's clean install option when changing from a driver that causes problems. **Win+Ctrl+Shift+B** restarts the graphics driver if the screen goes black.

## Checking it

| Task | How |
|---|---|
| Which GPU is in use | Task Manager > Performance > GPU, or `dxdiag` |
| Driver version and date | `Get-CimInstance Win32_VideoController \| Select Name, DriverVersion, DriverDate` |
| Temperature and load | Task Manager (GPU tab), or a tool such as HWiNFO |
| Which GPU an app uses (laptops with two) | Settings > System > Display > Graphics |

## Failure signs

| Sign | Possible cause |
|---|---|
| Artifacts: lines, flickering shapes, wrong colours | Overheating or a failing card or memory. Test with another card |
| Black screen with fans running | Wrong video port, loose cable, driver, or card |
| Crashes only in games or 3D work | Overheating, insufficient power supply, driver |
| Very high temperature, loud fan | Dust, a failed fan, dried thermal paste |
| No display at all on a desktop with no integrated graphics | No dedicated card installed, or the card is not seated or powered |
