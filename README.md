# ASAP7 SMIC N+3 BEOL

ASAP7 with a replaceable metal stack. The standard cells are ASAP7's, vendored from OpenROAD-flow-scripts. The metal stack is either ASAP7's own or `smic-n3`, a stack rebuilt on the metal pitches measured on SMIC N+3, the process of the Kirin 9030 Pro. The same design can be placed and routed on both from one checkout, so that results obtained on ASAP7, a freely available kit, can be read against a process whose design kit is not available.

## Repository structure

```
.
├── LICENSE                                        # Apache License 2.0
├── setup.sh                                       # Rebuilds the vendored trees
├── vendor/                                        # Upstream copies
│   ├── vendor.py                                  # Vendoring tool
│   ├── asap7.vendor.hjson                         # OpenROAD-flow-scripts, flow/platforms/asap7
│   ├── asap7sc7p5t_27.vendor.hjson                # ASU cell-library repository
│   ├── *.lock.hjson                               # The upstream revisions
│   ├── asap7/                                     # Cells and the stock ASAP7 stack
│   └── asap7sc7p5t_27/                            # Source of the OA simulation model
└── beol/
    └── smic-n3/                                   # The variant metal stack
        ├── lef/
        │   └── asap7_tech_1x_201209.lef           # Technology LEF: layers, pitches, rules, vias
        ├── openRoad/
        │   ├── make_tracks.tcl                    # Routing tracks per layer
        │   └── pdn/
        │       └── grid_strategy-M1-M2-M5-M6.tcl  # Flat power-grid strategy
        ├── setRC.tcl                              # Per-layer wire resistance and capacitance
        ├── rcx_patterns.rules                     # Parasitic extraction rules (generated)
        ├── make_rcx_rules.py                      # Builds rcx_patterns.rules from ASAP7's
        ├── KLayout/
        │   ├── asap7.lyt                          # Layer map for the GDS merge
        │   └── asap7.lyp                          # Layer display properties
        └── wiki/                                  # How the stack was ported, page by page
```

## How to use it

Clone the repository. Nothing else has to be prepared: the vendored trees are committed complete, and the repository depends on no other.

A flow needs two paths into the checkout, kept as two separate settings so that the stack can change while the cells stay:


| Path        | Points at                                         | Supplies                                                       |
| ----------- | ------------------------------------------------- | -------------------------------------------------------------- |
| Cells       | `vendor/asap7`, always                            | Liberty, cell LEF, cell GDS, simulation models, synthesis maps |
| Metal stack | `vendor/asap7` for stock ASAP7, or `beol/smic-n3` | The seven stack files, at the same relative paths in both      |


Only place-and-route, parasitic extraction and the GDS merge read the metal stack; synthesis, simulation, timing and power analysis read the cells alone. Read all seven stack files from the same folder: mixing the two gives a technology LEF that disagrees with its tracks or its extraction rules.

On `smic-n3` signals can route from M2 up to M10. Its first coarse layer is M4 rather than M5, so a flow that reserves layers by name, for a block's top routing layer or its power pins, has to move them one layer down.

## The stack in brief

The cells are ASAP7's 7.5-track library, unchanged on both stacks. They draw their pins and wiring on M1 and M2 only, so those two layers are frozen at ASAP7's 36 nm pitch and everything above them is rebuilt on SMIC N+3's measured pitches: M3 at 44 nm, M4 to M6 at 80 nm, M7 to M10 at 128 nm and M11 at 148 nm, with widths at half the pitch. Every layer above M2 is wider and coarser than ASAP7's, so a design sees about a quarter less routing capacity above the local layers and less resistive wires.

Only the pitches are measurements. The design rules, the wire resistance and capacitance and the extraction tables around them are ASAP7's own, scaled, so timing on this stack compares two designs against each other correctly and is not a prediction of silicon. Cell area, absolute timing and power stay ASAP7's; SMIC's cells are about 30 percent smaller for the same logic.

## Documentation

The [wiki](beol/smic-n3/wiki/index.md) records the port: the two technologies side by side, what could and could not change, the decisions taken, and one page per stack file saying what it is for, what ASAP7's version contains, what changed and why, and how to change it again. The references are in its [sources](beol/smic-n3/wiki/sources.md) page.

## License

Released under the Apache License 2.0, see [LICENSE](LICENSE). The vendored trees `vendor/asap7` and `vendor/asap7sc7p5t_27` keep their upstream BSD 3-Clause license, and the technology LEF of `beol/smic-n3`, derived from ASAP7's, keeps its BSD 3-Clause notice. `vendor/vendor.py` carries its own license header.
