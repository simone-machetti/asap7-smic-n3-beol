# -----------------------------------------------------------------------------
# Author: Simone Machetti
# SPDX-License-Identifier: Apache-2.0
# -----------------------------------------------------------------------------
#
# Builds rcx_patterns.rules of the smic-n3 stack from ASAP7's.
#
# ASAP7's file was generated upstream with a field solver. None is available
# here, so its tables are transformed rather than recomputed. The tables are
# functions of the distance to the neighbouring wires, and capacitance per unit
# length does not change when every dimension of the cross-section scales
# together. So each table of the new stack is an ASAP7 table of the nearest
# width class, with its distance axis rescaled to the new wire width and its
# resistance rescaled as 1 / width^2. The resistance column of every table is
# that of the layer itself, whichever ASAP7 layer the capacitances come from:
#
#   M1, M2        ASAP7 M1, M2 tables, unchanged
#   M3  (22 nm)   ASAP7 M3 tables (18 nm), axis x 22/18, resistance x (18/22)^2
#   M4 to M6      ASAP7 M8 tables (40 nm), unchanged
#   M7 to M10     ASAP7 M8 tables, axis x 1.6,  resistance x (40/64)^2
#   M11           ASAP7 M8 tables, axis x 1.85, resistance x (40/74)^2
#   Pad           ASAP7 Pad tables (all zero), unchanged
#
# A table describes a wire over and under conducting planes at other layers. The
# new stack has twelve layers against ten, and its layers sit at other indices,
# so a context is matched by its vertical distance in layers: the table of the
# new M5 under M7 is the table of an ASAP7 layer under the layer two above it.
# Where the preferred source has no table at that distance, the nearest lower
# ASAP7 layer that has one supplies it; distances beyond ASAP7's reach are
# clamped to the farthest available plane, whose influence is already marginal.
# Tables that ASAP7 leaves empty (diagonal coupling beyond four layers, anything
# under the Pad layer) stay empty.
#
# Run with --self-test to regenerate ASAP7's own file from ASAP7's stack
# description; the result must match the input byte for byte.
#
#   python3 make_rcx_rules.py ../../vendor/asap7/rcx_patterns.rules rcx_patterns.rules
# -----------------------------------------------------------------------------

import re
import sys

HEADER = re.compile(r"^Metal (\d+) (RESOVER|OVER|UNDER|DIAGUNDER)(?: (\d+))?(?: UNDER (\d+))?$")
DIST = re.compile(r"^DIST count (\d+) width (\S+)$")

SMIC_N3 = {
    1: (1, "0.018", 1.0),
    2: (2, "0.018", 1.0),
    3: (3, "0.022", (18 / 22) ** 2),
    4: (8, "0.04", 1.0),
    5: (8, "0.04", 1.0),
    6: (8, "0.04", 1.0),
    7: (8, "0.064", (40 / 64) ** 2),
    8: (8, "0.064", (40 / 64) ** 2),
    9: (8, "0.064", (40 / 64) ** 2),
    10: (8, "0.064", (40 / 64) ** 2),
    11: (8, "0.074", (40 / 74) ** 2),
    12: (10, "0.04", 1.0),
}

ASAP7_TOP = 10
DIAG_REACH = 4

def parse(path):
    lines = open(path).read().split("\n")
    tables = {}
    for i, line in enumerate(lines):
        m = HEADER.match(line)
        if not m or m.group(3) is None:
            continue
        met, kind, a = int(m.group(1)), m.group(2), int(m.group(3))
        b = int(m.group(4)) if m.group(4) else None
        if b is not None:
            kind = "OVERUNDER"
        d = DIST.match(lines[i + 1])
        if not d:
            continue
        rows = [lines[i + 2 + k].split() for k in range(int(d.group(1)))]
        tables[(met, kind, a, b)] = (d.group(2), rows)
    return tables

def num(x):
    return "%g" % round(x, 9)

class Stack:
    def __init__(self, asap7, spec):
        self.src = asap7
        self.spec = spec
        self.top = max(spec)

    def table(self, s, kind, a, b=None):
        t = self.src.get((s, kind, a, b))
        return t if t and t[1] else None

    def over(self, m, n):
        p = self.spec[m][0]
        return self.table(p, "OVER", max(p - (m - n), 0))

    def resover(self, m, n):
        p = self.spec[m][0]
        return self.table(p, "RESOVER", 0) if n == 0 else None

    def under(self, m, n, kind="UNDER"):
        if n == self.top:
            return None
        p = self.spec[m][0]
        d = n - m
        if kind == "DIAGUNDER" and d > DIAG_REACH:
            return None
        while d >= 1:
            for s in range(min(p, ASAP7_TOP - 1 - d), 0, -1):
                t = self.table(s, kind, s + d)
                if t:
                    return t
            d -= 1
        return None

    def overunder(self, m, a, b):
        p = self.spec[m][0]
        da, db = m - a, b - m
        if b == self.top:
            if m != self.top - 1:
                return None
            s = ASAP7_TOP - 1
            return self.table(s, "OVERUNDER", max(s - da, 1), ASAP7_TOP)
        while da + db > ASAP7_TOP - 2:
            if da >= db:
                da -= 1
            else:
                db -= 1
        s = max(min(p, ASAP7_TOP - 1 - db), da + 1)
        return self.table(s, "OVERUNDER", s - da, s + db)

    def emit(self, out, title, m, kind, picked, axis_cols):
        p, width, rfac = self.spec[m]
        out.append(title)
        if picked is None:
            out.append("DIST count 0 width %s" % width)
        else:
            src_width, rows = picked
            k = float(width) / float(src_width)
            out.append("DIST count %d width %s" % (len(rows), width))
            for row in rows:
                row = list(row)
                if k != 1.0:
                    for c in axis_cols:
                        row[c] = num(float(row[c]) * k)
                if kind != "RESOVER":
                    row[3] = self.table(p, "OVER", 0)[1][0][3]
                if rfac != 1.0:
                    row[3] = num(float(row[3]) * rfac)
                out.append(" ".join(row))
        out.append("END DIST")
        out.append("")

    def section(self, out, m, kind, contexts, pick, axis_cols):
        p, width, rfac = self.spec[m]
        out.append("Metal %d %s" % (m, kind))
        picks = [(title, pick(*ctx)) for title, ctx in contexts]
        if contexts and all(t is None for _, t in picks) and m != self.top:
            out.append("WIDTH Table 0 entries: ")
            out.append("")
            for title, _ in picks:
                out.append(title)
                out.append("")
            return
        out.append("WIDTH Table 1 entries:  %s" % width)
        out.append("")
        for title, t in picks:
            self.emit(out, title, m, kind, t, axis_cols)

    def build(self):
        top = self.top
        out = ["Extraction Rules for OpenRCX", "", "DIAGMODEL ON", "",
               "LayerCount %d" % top, "DensityRate 1  0", "", "DensityModel 0", ""]
        for m in range(1, top + 1):
            below = range(0, m)
            above = range(m + 1, top + 1)
            self.section(out, m, "RESOVER",
                         [("Metal %d RESOVER %d" % (m, n), (m, n)) for n in below],
                         self.resover, (0, 1))
            self.section(out, m, "OVER",
                         [("Metal %d OVER %d" % (m, n), (m, n)) for n in below],
                         self.over, (0,))
            if m == top:
                out += ["Metal %d UNDER" % m, "WIDTH Table 0 entries: ", "",
                        "Metal %d DIAGUNDER" % m, "WIDTH Table 0 entries: "]
                break
            self.section(out, m, "UNDER",
                         [("Metal %d UNDER %d" % (m, n), (m, n)) for n in above],
                         self.under, (0,))
            self.section(out, m, "DIAGUNDER",
                         [("Metal %d DIAGUNDER %d" % (m, n), (m, n, "DIAGUNDER")) for n in above],
                         self.under, (0,))
            if m > 1:
                self.section(out, m, "OVERUNDER",
                             [("Metal %d OVER %d UNDER %d" % (m, a, b), (m, a, b))
                              for a in range(1, m) for b in above],
                             self.overunder, (0,))
        out.append("END DensityModel 0")
        return "\n".join(out) + "\n"

def main():
    args = [a for a in sys.argv[1:] if a != "--self-test"]
    asap7 = parse(args[0])
    if "--self-test" in sys.argv:
        widths = {m: asap7[(m, "OVER", 0, None)][0] for m in range(1, ASAP7_TOP + 1)}
        identity = {m: (m, widths[m], 1.0) for m in widths}
        same = Stack(asap7, identity).build() == open(args[0]).read()
        print("self-test: %s" % ("identical to ASAP7" if same else "DIFFERS from ASAP7"))
        sys.exit(0 if same else 1)
    open(args[1], "w").write(Stack(asap7, SMIC_N3).build())

if __name__ == "__main__":
    main()
