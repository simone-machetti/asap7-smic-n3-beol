# Layer display

`KLayout/asap7.lyp`

## What the file is for

It tells KLayout how to draw each GDS layer: name, colour, fill pattern, visibility. It affects viewing only; nothing in an implementation run depends on it.

## What ASAP7's version contains

One entry per GDS layer and datatype in use. Every metal has five (drawing, pin, label, net, blockage) and every cut three (drawing, blockage, pin).

## What changed and why

Sixteen entries are added after V9's, for M10, V10, M11 and V11 on the numbers of [asap7_lyt.md](asap7_lyt.md). They are copies of the entries of M9 and V9, with the new numbers and names and, for the two metals, new colours. Without them the new layers would still be streamed out, but would show up unnamed in the viewer.

## How to change it again

Copy the block of entries of an existing metal or cut, and change the layer number, the name and, if wanted, the colour.
