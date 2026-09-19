# -----------------------------------------------------------------------------
# Author: Simone Machetti
# SPDX-License-Identifier: Apache-2.0
# -----------------------------------------------------------------------------
#
# Wire resistance and capacitance per unit length of the smic-n3 stack, in the
# units of ASAP7's own file. Nothing here is measured: SMIC publishes no wire
# data, so every value above M2 is derived from ASAP7's.
#
# Resistance: R = rho / (width x thickness), and thickness follows width, so
# R scales as 1 / width^2. The law reproduces ASAP7's own numbers to within ten
# percent across its width classes (18 -> 24 nm: 1 %, 24 -> 32 nm: 8 %,
# 32 -> 40 nm: 5 %), which is the scatter of those numbers themselves.
#
#   M1, M2      18 nm   ASAP7, unchanged
#   M3          22 nm   ASAP7 M3 (18 nm) x (18/22)^2 = x 0.669
#   M4 to M6    40 nm   ASAP7's own 40 nm wire: the M8 resistance of its
#                       extraction rules, which its setRC.tcl does not list
#   M7 to M10   64 nm   the 40 nm value x (40/64)^2 = x 0.391
#   M11         74 nm   the 40 nm value x (40/74)^2 = x 0.292
#
# The coarse layers take exactly the resistances of rcx_patterns.rules, so the
# estimate before routing and the extraction after it agree, as they do on
# ASAP7's M6 and M7.
#
# Resistivity is held at the value of the layer scaled from. A wider wire is in
# fact slightly less resistive per unit of cross-section, so the scaled values
# are high by about ten percent: pessimistic, the safe side.
#
# Capacitance per unit length is invariant when width, spacing and thickness
# scale together, and ASAP7's values show no trend with pitch, so M3 keeps its
# own, M4 to M6 take ASAP7's M7 and the layers above take 1.40E-01.
#
# Vias follow the same law on the cut width: V1 and V2 unchanged (18 nm cut),
# V3 from them (22 nm), the 40 nm cuts take ASAP7's V8, the 64 nm cuts scale it.
#
# The default wire RC, used before the routing layers of a net are known, is
# ASAP7's, multiplied by the ratio between the two per-layer tables averaged
# over the wire length per layer of the same routed design (on both stacks
# about 42 % M2, 43 % M3, 15 % above): x 0.814 on resistance, x 0.971 on
# capacitance.
#
# Two consequences that look wrong and are not: every layer above M2 is wider
# than ASAP7's, so the wires are less resistive; and every layer above M2 is
# coarser, so there are fewer of them. Fewer, fatter wires: more congestion
# without worse wire delay is the expected outcome.
# -----------------------------------------------------------------------------

set_layer_rc -layer M1  -resistance 7.04175E-02 -capacitance 1e-10
set_layer_rc -layer M2  -resistance 4.62311E-02 -capacitance 1.84542E-01
set_layer_rc -layer M3  -resistance 2.43168E-02 -capacitance 1.53955E-01
set_layer_rc -layer M4  -resistance 8.44656E-03 -capacitance 1.47030E-01
set_layer_rc -layer M5  -resistance 8.44656E-03 -capacitance 1.47030E-01
set_layer_rc -layer M6  -resistance 8.44656E-03 -capacitance 1.47030E-01
set_layer_rc -layer M7  -resistance 3.29944E-03 -capacitance 1.40000E-01
set_layer_rc -layer M8  -resistance 3.29944E-03 -capacitance 1.40000E-01
set_layer_rc -layer M9  -resistance 3.29944E-03 -capacitance 1.40000E-01
set_layer_rc -layer M10 -resistance 3.29944E-03 -capacitance 1.40000E-01
set_layer_rc -layer M11 -resistance 2.46795E-03 -capacitance 1.40000E-01
set_wire_rc -signal -resistance 2.63182E-02 -capacitance 1.68258E-01
set_wire_rc -clock -resistance 4.18591E-02 -capacitance 1.40325E-01

set_layer_rc -via V1  -resistance 1.72E-02
set_layer_rc -via V2  -resistance 1.72E-02
set_layer_rc -via V3  -resistance 1.15E-02
set_layer_rc -via V4  -resistance 6.30E-03
set_layer_rc -via V5  -resistance 6.30E-03
set_layer_rc -via V6  -resistance 6.30E-03
set_layer_rc -via V7  -resistance 2.46E-03
set_layer_rc -via V8  -resistance 2.46E-03
set_layer_rc -via V9  -resistance 2.46E-03
set_layer_rc -via V10 -resistance 2.46E-03
