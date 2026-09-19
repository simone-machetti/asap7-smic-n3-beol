# Wire resistance and capacitance

`setRC.tcl`

## What the file is for

It gives a tool one resistance and one capacitance per unit length for every metal layer, one resistance per via, and a default pair used before the routing layers of a net are known. Every timing number computed before extraction rests on these values.

## What ASAP7's version contains

Values for M1 to M7 and for V1 to V8, and a default pair for signals and for clocks. Its header states that they are a correlation result, fitted against four routed designs, not pure geometry: layers of identical width differ from one another by about five percent. It lists nothing for M8 and M9.

## What changed and why

Nothing is measured for the new stack, so ASAP7's values are scaled. The scaling is by dimensionless ratios, which also sidesteps the question of units: the file stays in ASAP7's.

**Resistance scales as one over the width squared.** Resistance per unit length is resistivity over the cross-section, the cross-section is width times thickness, and thickness follows width through a roughly constant height-to-width ratio. The law can be checked before it is used, because ASAP7 spans several width classes itself.

| Step within ASAP7      | Width ratio | Predicted | Actual                             | Error |
| ---------------------- | ----------- | --------- | ---------------------------------- | ----- |
| M3, 18 nm to M4, 24 nm | 0.75        | 2.04e-2   | 2.03e-2                            | 1 %   |
| M5, 24 nm to M6, 32 nm | 0.75        | 1.09e-2   | 1.19e-2                            | 8 %   |
| M7, 32 nm to M8, 40 nm | 0.80        | 8.01e-3   | 8.45e-3, from its extraction rules | 5 %   |

The law reproduces ASAP7's table to within the table's own scatter.

| Layers    | Width | Resistance | Taken from                                                       | Capacitance |
| --------- | ----- | ---------- | ---------------------------------------------------------------- | ----------- |
| M1, M2    | 18 nm | unchanged  | ASAP7                                                            | unchanged   |
| M3        | 22 nm | 2.43e-2    | ASAP7's M3 times (18/22)²                                        | ASAP7's M3  |
| M4 to M6  | 40 nm | 8.45e-3    | ASAP7's own 40 nm wire, the M8 value of its extraction rules     | ASAP7's M7  |
| M7 to M10 | 64 nm | 3.30e-3    | The 40 nm value times (40/64)²                                   | 1.40e-1     |
| M11       | 74 nm | 2.47e-3    | The 40 nm value times (40/74)²                                   | 1.40e-1     |

The 40 nm layers take the resistance that ASAP7's extraction rules give its own 40 nm wire, which its `setRC.tcl` does not list. It is a better source than scaling from M7, and it makes the estimate before routing agree with the extraction after it, as the two already agree on ASAP7's M6 and M7.

**Capacitance is reused.** When width, spacing and thickness all scale together, the cross-section stays similar and the capacitance per micron barely moves. ASAP7's own values wander between 1.4e-1 and 1.9e-1 with no trend in pitch, which supports reusing the value of the nearest class over inventing a scaling.

**Vias follow the same law on the cut width.** V1 and V2 are unchanged at an 18 nm cut; V3, at 22 nm, scales from them to 1.15e-2; the 40 nm cuts take ASAP7's V8 value, 6.30e-3; the 64 nm cuts scale it to 2.46e-3.

**The default pair is ASAP7's times a ratio.** ASAP7's defaults are close to its per-layer table averaged over the wire length a routed design puts on each layer. The same average over the new table, with the same layer usage of about 42 percent on M2, 43 on M3 and 15 above, is 0.814 times ASAP7's in resistance and 0.971 in capacitance, and the defaults are multiplied by those two factors.

**Two assumptions are deliberate.** Resistivity is held at the value of the layer scaled from. A wider wire is in fact slightly less resistive per unit of cross-section, because the barrier liner and the scattering of electrons off the wire walls matter less as the wire grows, and every new layer is wider than its source. The scaled resistances are therefore high by something like ten percent, the safe side. And the constant height-to-width ratio is an assumption; if real layer thicknesses ever become available, they replace it.

## How to change it again

Give every metal and every cut of the technology LEF a line here. When a width changes, rescale its resistance from the nearest width class by the square of the width ratio, keep the capacitance, and put the same factor in the stack description of `make_rcx_rules.py`, so that the two files stay in step.
