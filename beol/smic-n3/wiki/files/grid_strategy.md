# Power grid

`openRoad/pdn/grid_strategy-M1-M2-M5-M6.tcl`

## What the file is for

It is the recipe a power-grid generator follows for a flat design: which nets are power and ground, which layers carry rails and straps, how wide and how far apart they are, and which pairs of layers are connected by vias.

## What ASAP7's version contains

Rails on M1 and M2 that follow the cell rows, vertical straps on M5, horizontal straps on M6, connections M1 to M2, M2 to M5 and M5 to M6, and block pins on M6. Two further sections connect M4 to M5 over hard macros whose power pins are on M4, as memories usually have them. The M2-to-M5 connection is a via stack that passes through M3 and M4 at every crossing of a rail and a strap.

## What changed and why

**The layers and the structure are ASAP7's.** The rails cannot move, because the cells define them. The rails are horizontal, so the first mesh layer has to be vertical to cross them all and tie them together. On this stack the first coarse layer is M4, but M4 is horizontal: it runs parallel to the rails and can only reach the rails that happen to lie under it. The first coarse vertical layer is M5, here as on ASAP7, so the straps stay on M5 and M6 and the file keeps its name.

**The strap geometry is ASAP7's scaled by the pitch ratio of each layer**, so that the same fraction of each layer is spent on power. A strap quoted in microns really means a number of tracks, and an unscaled strap would take almost twice the share of an 80 nm layer that it takes of a 48 nm one.

| Layer | Stack                  | Width (µm) | Spacing (µm) | Pitch (µm) | Offset (µm) |
| ----- | ---------------------- | ---------- | ------------ | ---------- | ----------- |
| M5    | ASAP7, 48 nm pitch     | 0.12       | 0.072        | 5.4        | 0.300       |
| M5    | `smic-n3`, times 80/48 | 0.2        | 0.12         | 9.0        | 0.5         |
| M6    | ASAP7, 64 nm pitch     | 0.288      | 0.096        | 5.4        | 0.513       |
| M6    | `smic-n3`, times 80/64 | 0.36       | 0.12         | 6.75       | 0.641       |

The wider straps on thicker metal are less resistive than ASAP7's even at the wider pitch, so the grid is electrically no weaker.

**The via stacks are built from the new LEF.** Between M2 and M3 the generator arrays the fixed via at a 36 nm pitch, the cut plus its spacing; from M3 up it uses the via-generation rules. It sizes the M3 patch of the stack from the M3-M4 rule, as [tech_lef.md](tech_lef.md) explains. One imperfection is known: that M3 patch is as wide as its row of cuts, 166 nm under a 0.2 µm strap, which is not one of M3's legal widths. On ASAP7 the same construction lands on a legal width by coincidence of its numbers. A router does not check the shapes of a power grid against the width table, so routing is unaffected.

**The macro sections are unchanged.**

## How to change it again

Keep the rails as they are. If a strap layer moves, the first mesh layer must stay vertical, and every connected pair needs its vias and via rules in the technology LEF; a missing one shows up as "no via inserted" warnings from the generator. Scale strap dimensions with the layer's pitch.
