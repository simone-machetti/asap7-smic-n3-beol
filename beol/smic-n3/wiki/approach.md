# Approach

## What the cells freeze

The ASAP7 standard cells draw their pins, their internal wiring and their power rails on M1 and M2, and on no layer above. The library is fixed, since a shorter cell with fewer fins would be a redesign of every cell, so those two layers are fixed with it: their pitch, their direction and their track pattern have to stay exactly as they are, or every cell breaks. Everything above M2 is touched by no cell and is therefore free.

That single fact shapes the whole port. The stack is rebuilt from M3 upward on SMIC's pitches, and ASAP7's M1 and M2 stand in for SMIC's three lowest layers, which they approximate to within about ten percent: 36 nm against 32.5, 38 and 40 nm.

## Five kinds of change

The work divides into five kinds, which carry very different confidence and are worth keeping apart.

| Kind                                | What it means                                              | Where it lands                                     |
| ----------------------------------- | ---------------------------------------------------------- | -------------------------------------------------- |
| Transcribing measured numbers       | The teardown states it; it is typed in                     | Pitches in the technology LEF and the track file   |
| Deciding which layer does what      | An engineering choice, as it already was for ASAP7         | Power grid                                         |
| Computing what nobody published     | Derived from geometry and from ASAP7's own data            | Wire resistance and capacitance                    |
| Imitating what cannot be derived    | No input data, so ASAP7's is scaled and declared as such   | Design rules around the pitches, extraction rules  |
| Accepting what cannot be modelled   | Needs a different cell library or device data              | Cell area, absolute timing and power               |

## Decisions

- **Widths are half the pitch.** It is the usual convention and, on spacer-patterned layers, close to exact, because the process builds line and space from the same spacer.
- **Directions keep alternating** from ASAP7's M1 vertical and M2 horizontal, which a router requires. M3 is vertical, M4 horizontal, up to M11 vertical.
- **The stack stops at M11.** SMIC's M12 and M13, at about 1.9 and 4.6 µm pitch, are package-scale metal that no block-level experiment reaches, and each added layer costs an entry in five files.
- **M11 stays although nothing needs it today.** The stack describes the technology, not one use of it, and M11 is where a chip-wide power grid would go. ASAP7 sets the precedent: it defines upper layers and a pad layer that its own default flow never routes on.
- **ASAP7's Pad layer stays**, moved above M11 with its cut. It has no user and costs nothing.
- **Coarse layers take a simple rule set.** ASAP7 writes its fine layers with end-of-line, corner and keep-out rules that encode multiple patterning, and its two coarsest layers with a plain spacing table. Every layer from M4 up takes the plain style. A wrong fine-layer rule on a coarse layer does not produce an error; it produces thousands of routing violations at the end of a long run.
- **Wire data is scaled from ASAP7's, never invented.** Resistance follows one law, checked against ASAP7's own table before it is extrapolated; capacitance is reused; extraction tables are transformed rather than recomputed, because no field solver is available.
- **No power grid above M6.** The flat strategy keeps ASAP7's structure and adds nothing on the upper layers, since sizing a grid there would mean inventing a width and a pitch.
- **File names and relative paths are ASAP7's.** A flow switches stack by switching folder, with no other change.

## The resulting stack

| Layer     | Pitch (nm) | Width (nm) | Direction  | Stands for       | Tracks/µm | Origin of its rules              |
| --------- | ---------- | ---------- | ---------- | ---------------- | --------- | -------------------------------- |
| M1        | 36         | 18         | vertical   | SMIC M0 and M1   | 27.8      | ASAP7, frozen by the cells       |
| M2        | 36         | 18         | horizontal | SMIC M1 and M2   | 27.8      | ASAP7, frozen by the cells       |
| M3        | 44         | 22         | vertical   | SMIC M3          | 22.7      | ASAP7's M3, scaled by 44/36      |
| M4        | 80         | 40         | horizontal | SMIC M4          | 12.5      | ASAP7's M8, verbatim             |
| M5        | 80         | 40         | vertical   | SMIC M5          | 12.5      | ASAP7's M8, verbatim             |
| M6        | 80         | 40         | horizontal | SMIC M6          | 12.5      | ASAP7's M8, verbatim             |
| M7        | 128        | 64         | vertical   | SMIC M7          | 7.8       | ASAP7's M8, scaled by 1.6        |
| M8        | 128        | 64         | horizontal | SMIC M8          | 7.8       | ASAP7's M8, scaled by 1.6        |
| M9        | 128        | 64         | vertical   | SMIC M9          | 7.8       | ASAP7's M8, scaled by 1.6        |
| M10       | 128        | 64         | horizontal | SMIC M10         | 7.8       | ASAP7's M8, scaled by 1.6        |
| M11       | 148        | 74         | vertical   | SMIC M11         | 6.8       | ASAP7's M8, scaled by 1.85       |
| Pad       |            |            |            |                  |           | ASAP7's, unused                  |

From M4 up the stack offers 75.5 tracks per micron, against SMIC's measured 75.2 and ASAP7's 97.8. Every layer above M2 is wider and coarser than ASAP7's: fewer, fatter wires. More congestion without worse wire delay is the expected behaviour of a design on it.

## Order of the work

Each step depends on the ones before it.

1. **Technology LEF**, [files/tech_lef.md](files/tech_lef.md): the layers, from which everything else takes its names and widths.
2. **Tracks**, [files/make_tracks.md](files/make_tracks.md): must agree with the LEF pitch exactly.
3. **Layer map and display**, [files/asap7_lyt.md](files/asap7_lyt.md) and [files/asap7_lyp.md](files/asap7_lyp.md): one entry per new layer.
4. **Wire RC**, [files/setRC.md](files/setRC.md): one value per layer and per cut of the LEF.
5. **Extraction rules**, [files/rcx_patterns.md](files/rcx_patterns.md): one table set per routing layer of the LEF, with the resistances of step 4.
6. **Power grid**, [files/grid_strategy.md](files/grid_strategy.md): needs the vias and via rules of step 1 to connect its layers.
