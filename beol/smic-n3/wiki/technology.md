# ASAP7 against SMIC N+3

What is publicly known about the target process, next to the kit the stack is built from. Everything here is input to the port; nothing here is a choice.

## The two technologies

**ASAP7** is a predictive 7 nm design kit from Arizona State University and Arm. No fab stands behind it, but it is complete: design rules, a standard-cell library with timing models, extraction data, and an open implementation flow that uses it.

**SMIC N+3** is the third generation of SMIC's 7 nm-class FinFET process, made without EUV lithography. The press calls it "5 nm-class"; by measured logic density it sits next to TSMC's N6. It is not a 3 nm node. Its design kit is not available, and SMIC publishes no dimensions. What is known comes from a teardown of one product, the Kirin 9030 Pro.

All SMIC numbers on this page are measurements published by SemiAnalysis in June 2026. TechInsights' public pages confirm the node and publish no dimensions. ASAP7's numbers come from its paper, its design-rule manual and its LEF files. See [sources.md](sources.md).

## Front end: transistors and cells

| Parameter              | ASAP7 (7.5-track, RVT)              | SMIC N+3                                             |
| ---------------------- | ----------------------------------- | ---------------------------------------------------- |
| Transistor             | FinFET, 3 fins per device           | FinFET, 2 fins per device                            |
| Fin pitch              | 27 nm                               | about 32 nm                                          |
| Contacted gate pitch   | 54 nm                               | 57 nm                                                |
| Standard cell height   | 270 nm = 7.5 tracks of 36 nm        | 228 nm = 5.7 tracks of 40 nm                         |
| Diffusion break        | double                              | single, which saves one gate pitch per cell boundary |
| Gate contact           | through a local-interconnect layer  | contact over the active gate                         |
| Lithography            | EUV assumed for the finest layers   | 193 nm immersion only, multiple patterning           |
| NAND2 footprint        | 4 gate pitches x 270 nm = 0.058 µm² | 3 gate pitches x 228 nm = 0.039 µm²                  |
| Logic density          | about 81 MTr/mm²                    | 113.4 MTr/mm²                                        |
| Area of the same logic | 1.0                                 | 0.67 to 0.71, in short 0.70                          |
| Nominal supply         | 0.70 V                              | not public                                           |

ASAP7's density figure is computed the way the SMIC figure was: the smallest NAND2 is 0.216 x 0.270 µm with 4 transistors (68.6 MTr/mm²), the scan flop is 1.35 x 0.270 µm (98.8 MTr/mm², assuming the conventional 36 transistors), and the usual 0.6 / 0.4 weighting gives about 81.

## Back end: metal layers

SMIC numbers its layers from M0 and ASAP7 from M1, so the rows align by number: ASAP7 has no M0, and its M1 and M2 together play the part of SMIC's three lowest layers. Tracks per micron is one micron divided by the pitch, the number of wires that fit side by side.

| Layer | SMIC N+3 pitch (nm) | SMIC N+3 tracks/µm | ASAP7 pitch (nm) | ASAP7 tracks/µm |
| ----- | ------------------- | ------------------ | ---------------- | --------------- |
| M0    | 32.5                | 30.8               |                  |                 |
| M1    | 38                  | 26.3               | 36               | 27.8            |
| M2    | 40                  | 25.0               | 36               | 27.8            |
| M3    | 44                  | 22.7               | 36               | 27.8            |
| M4    | 80 to 82            | 12.3               | 48               | 20.8            |
| M5    | 80 to 82            | 12.3               | 48               | 20.8            |
| M6    | 80 to 82            | 12.3               | 64               | 15.6            |
| M7    | 128                 | 7.8                | 64               | 15.6            |
| M8    | 128                 | 7.8                | 80               | 12.5            |
| M9    | 128                 | 7.8                | 80               | 12.5            |
| M10   | 128                 | 7.8                |                  |                 |
| M11   | 148                 | 6.8                |                  |                 |
| M12   | about 1920          |                    |                  |                 |
| M13   | about 4600          |                    |                  |                 |

The layers fall into three classes. The **local** layers, up to M3, are the finest and are made by multiple patterning; on SMIC they route in one direction only, with restrictive line-end rules. The **mid** layers, M4 to M6 on SMIC, are single-exposure 80 nm layers. The **upper** layers are coarser still, and the last two are package-scale power and redistribution metal.

From M4 up, where block and chip routing happens, ASAP7 offers 97.8 tracks per micron in total over six layers and SMIC 75.2 over eight. SMIC has more layers, each with fewer and fatter wires: about a quarter less routing capacity above the local layers, and lower resistance per wire. That difference is what the port exists to reproduce.

## What is not public

No source gives SMIC N+3's supply voltage, drive current or gate delay; the thickness, resistance or capacitance of any metal layer; the resistance of any via; or any design rule beyond the pitches. Those gaps decide what the port can transcribe and what it has to compute or imitate, as [approach.md](approach.md) lays out.
