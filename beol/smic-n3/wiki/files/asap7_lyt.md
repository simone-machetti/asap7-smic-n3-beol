# Layer map

`KLayout/asap7.lyt`

## What the file is for

When a routed design is streamed out, its wires and vias are merged with the layouts of the standard cells into one GDS file. This file is the technology description KLayout uses for that: it maps every layer name of the design to a GDS layer and datatype number, and it lists which layers connect through which cuts.

## What ASAP7's version contains

A map for M1 to M9 and V0 to V9, each metal with separate numbers for its labels and its pins, and a connectivity list that ends with M9, V9, Pad. Metals sit on ten times their index from M3 up (M3 on 30, M9 on 90), cuts five above the metal below (V3 on 35, V9 on 95). The file also carries an entry naming the LEF files to read, which a flow replaces with its own list before use; that is unchanged.

## What changed and why

Four layers are added, each metal with its label and pin entries as the others have them.

| Layer | GDS layer |
| ----- | --------- |
| M10   | 120       |
| V10   | 125       |
| M11   | 130       |
| V11   | 135       |

ASAP7's numbering cannot simply continue, because 100 is its boundary layer and 101 and 110 are taken as well. The new numbers keep the pattern of a cut five above its metal. Every existing number is unchanged, which is what lets the cell layouts, drawn on ASAP7's numbers, still merge.

The connectivity list is extended the same way: M9, V9, M10; M10, V10, M11; M11, V11, Pad.

## How to change it again

Give every new metal and cut of the technology LEF an entry in the map, a line in the connectivity list and a symbol line, on GDS numbers that neither this file nor [asap7_lyp.md](asap7_lyp.md) uses. A missing entry does not necessarily stop the merge, so check after a change that the new layer's wires are present in the streamed result.
