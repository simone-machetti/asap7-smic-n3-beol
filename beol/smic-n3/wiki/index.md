# The `smic-n3` stack: how it was ported

This wiki records how the `smic-n3` metal stack was built from ASAP7's: what is known about the target process, what could and could not be changed, and how each of the seven stack files was derived. Read it in this order.

| Page                                             | Content                                                                                        |
| ------------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| [technology.md](technology.md)                   | ASAP7 against SMIC N+3, cells and metal layers: what was measured, by whom, what is not public |
| [approach.md](approach.md)                       | What the cells freeze, the five kinds of change, the decisions taken, the order of the work    |
| [files/tech_lef.md](files/tech_lef.md)           | `lef/asap7_tech_1x_201209.lef`: layers, design rules, cuts, vias                               |
| [files/make_tracks.md](files/make_tracks.md)     | `openRoad/make_tracks.tcl`: routing tracks                                                     |
| [files/grid_strategy.md](files/grid_strategy.md) | `openRoad/pdn/grid_strategy-M1-M2-M5-M6.tcl`: power grid                                       |
| [files/setRC.md](files/setRC.md)                 | `setRC.tcl`: wire resistance and capacitance                                                   |
| [files/rcx_patterns.md](files/rcx_patterns.md)   | `rcx_patterns.rules` and `make_rcx_rules.py`: extraction rules and their generator             |
| [files/asap7_lyt.md](files/asap7_lyt.md)         | `KLayout/asap7.lyt`: layer map                                                                 |
| [files/asap7_lyp.md](files/asap7_lyp.md)         | `KLayout/asap7.lyp`: layer display                                                             |
| [sources.md](sources.md)                         | Every reference                                                                                |

Each page under `files/` has the same four parts: what the file is for, what ASAP7's version contains, what changed and why, and how to change it again. Exact numbers live in the files themselves and in their headers; the pages explain where they come from.
