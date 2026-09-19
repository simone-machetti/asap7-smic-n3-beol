# Routing tracks

`openRoad/make_tracks.tcl`

## What the file is for

It tells the floorplan where wires may sit: for every layer, an offset and a pitch in each direction. A router places wires on these lines and vias on their crossings.

## What ASAP7's version contains

One line per layer, except M2. M2 has seven lines, staggered inside the 270 nm cell row, so that its tracks line up with the rows of pins inside the standard cells. On every layer the preferred direction carries the layer's own pitch, and the other direction the pitch of a neighbouring layer, so that vias between the two fall on crossings.

## What changed and why

M1 and M2 are ASAP7's, line for line, since the cells depend on them. From M3 up:

- **Preferred direction:** the pitch of the technology LEF, offset by half the wire width, so that the first wire sits with its edge on the die boundary.
- **Other direction:** the pitch and offset of the layer below, as in ASAP7.

| Layer     | Direction  | x offset, pitch (µm) | y offset, pitch (µm) |
| --------- | ---------- | -------------------- | -------------------- |
| M3        | vertical   | 0.011, 0.044         | 0.009, 0.036         |
| M4        | horizontal | 0.011, 0.044         | 0.020, 0.080         |
| M5, M6    | alternate  | 0.020, 0.080         | 0.020, 0.080         |
| M7        | vertical   | 0.032, 0.128         | 0.020, 0.080         |
| M8 to M10 | alternate  | 0.032, 0.128         | 0.032, 0.128         |
| M11       | vertical   | 0.037, 0.148         | 0.032, 0.128         |
| Pad       |            | ASAP7's, unchanged   |                      |

One consequence is built into the numbers. M3 at 44 nm no longer lines up with the 36 nm grid of M1 below it: the two grids coincide only every 396 nm. A connection from an M1 pin up to M3 therefore usually takes a short jog on M2, where on ASAP7 the two vias could stack.

## How to change it again

Change a pitch here only together with the same layer's `PITCH` in the technology LEF. Add one line for each new layer. Never touch the seven M2 lines.
