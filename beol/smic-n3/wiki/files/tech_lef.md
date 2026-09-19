# Technology LEF

`lef/asap7_tech_1x_201209.lef`

## What the file is for

It describes the process as a router sees it: every layer with its direction, pitch, width and design rules, every cut layer, the vias that join two layers, and the rules for generating via arrays. It holds no thickness and no material data; a tool takes every electrical property from [setRC.md](setRC.md) and [rcx_patterns.md](rcx_patterns.md), never from here.

## What ASAP7's version contains

Implant and device layers, then nine metals M1 to M9 with their cuts, then a Pad layer. Two rule styles live in it.

- **Fine layers, M1 to M7**, carry rules written as LEF 5.8 properties: end-of-line spacing, end-of-line keep-out, corner spacing, a table of legal widths, wires on grid only, rectangles only. They encode the awkward geometry of multiple patterning, and a detailed router obeys them literally. Their cuts, V3 to V6, are written as cut classes with their own enclosure rules.
- **Coarse layers, M8 and M9**, carry a plain rule set: pitch, width, minimum area, a spacing table indexed by parallel run length, a minimum-cut rule, a maximum width, a minimum step. Their cuts have a width and a spacing, nothing else.

For every adjacent pair of layers it defines one fixed via, which a router uses as its default cut. For some pairs it also defines a via-generation rule, from which a power grid builds via arrays, plus several rules for wide power vias tied to its own strap widths.

## What changed and why

**Up to V2 nothing changes.** Units, manufacturing grid, implant and device layers, M1, M2 and their cuts are ASAP7's, because the cells are drawn on them.

**M3 keeps ASAP7's M3 rule set, scaled.** It is still a finely patterned layer, so it keeps the property style, with every length multiplied by the pitch ratio 44/36 and rounded to the 1 nm grid.

| Rule on M3                                   | ASAP7          | `smic-n3`      |
| -------------------------------------------- | -------------- | -------------- |
| Pitch, width, spacing                        | 36, 18, 18 nm  | 44, 22, 22 nm  |
| Minimum area                                 | 666 nm²        | 990 nm²        |
| Minimum segment (length x width)             | 37 x 18 nm     | 45 x 22 nm     |
| Line-end width threshold                     | 25 nm          | 31 nm          |
| End-to-end spacing                           | 31 nm          | 38 nm          |
| Corner-to-corner spacing                     | 20 nm          | 24 nm          |
| Legal widths                                 | 18 + 72 k nm   | 22 + 88 k nm   |

The minimum segment stays one nanometre longer than the pitch, as ASAP7 has it, and the minimum area is that segment. The scaled end-to-end spacing still lets two vias sit two M2 tracks apart on the same M3 track, which is the closest ASAP7 allows too.

**M4 to M11 take the plain rule set of ASAP7's M8**, verbatim where the width is the same and scaled by the width ratio elsewhere, with the area scaled by its square so that a minimum shape stays the same number of squares.

| Layers    | Pitch, width | Scale on ASAP7's M8 | Minimum area | Maximum width |
| --------- | ------------ | ------------------- | ------------ | ------------- |
| M4 to M6  | 80, 40 nm    | 1, verbatim         | 0.00752 µm²  | 2.0 µm        |
| M7 to M10 | 128, 64 nm   | 1.6                 | 0.01925 µm²  | 3.2 µm        |
| M11       | 148, 74 nm   | 1.85                | 0.02574 µm²  | 3.7 µm        |

ASAP7's fine-layer rules are deliberately not copied up. On a coarse layer a wrong end-of-line or corner rule does not fail to parse; it floods a routing run with violations.

**Cuts are square, at the width of the narrower of the two layers they join**, and spaced at 1.43 times their width, the ratio ASAP7 uses on V7 and V8.

| Cuts      | Joins        | Size  | Spacing                     |
| --------- | ------------ | ----- | --------------------------- |
| V3        | M3 to M4     | 22 nm | 32 nm                       |
| V4 to V6  | M4 up to M7  | 40 nm | 57 nm                       |
| V7 to V10 | M7 up to M11 | 64 nm | 92 nm                       |
| V11       | M11 to Pad   | 40 nm | 57 nm, ASAP7's V9 unchanged |

**Every adjacent pair has its fixed via.** On the coarse layers the metal is a square of the wire width around the cut, as in ASAP7's M8-to-M9 via. On M3 the metal runs 5 nm past the cut along the wire, as ASAP7's vias do.

**Every pair from M3-M4 upward has a via-generation rule**, with the cut, its enclosures, and a centre-to-centre spacing equal to the cut plus the cut spacing. The M3-M4 rule matters beyond its own pair. A power grid that connects rails on M2 to straps on M5 builds a via stack through M3 and M4, and it sizes the M3 patch in the middle from the enclosure it finds declared for the cuts that touch M3. Without that 5 nm enclosure the patch comes out too short for the fixed vias and no via is inserted at all. ASAP7's wide power-via rules are dropped, since they are tied to its strap widths.

**The Pad layer and its cut are ASAP7's**, moved above M11.

## How to change it again

- Keep everything up to V2 untouched.
- A layer's pitch must equal its line in [make_tracks.md](make_tracks.md) exactly. If they disagree, global routing plans on one grid and detailed routing works on another, which shows up as a slow, failing route and never as an error.
- A new layer needs eight things: the layer itself, the cut below it, a fixed via, a via-generation rule, a track line, resistance and capacitance in `setRC.tcl`, an entry in the stack description of `make_rcx_rules.py`, and an entry in the layer map.
- The number of routing layers here, Pad included, must equal the layer count of the extraction rules: twelve today.
