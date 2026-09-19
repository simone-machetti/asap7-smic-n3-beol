# Sources

## SMIC N+3

- SemiAnalysis, "Is SMIC N+3's Metal Pitch Smaller than Intel 18A's?", teardown of the Kirin 9030, June 2026: https://newsletter.semianalysis.com/p/steel-smic-n3-teardown. The source of every SMIC pitch, the fin and gate pitches, the cell height, the layer count and the density figure.
- TechInsights, "SMIC N+3 Confirmed: Kirin 9030 Analysis": https://www.techinsights.com/blog/smic-n3-confirmed-kirin-9030-analysis-reveals-how-close-smic-5nm. Confirms the node; publishes no dimensions.
- TechInsights, "HiSilicon Kirin 9030 Pro (SMIC N+3) Process Flow Analysis": https://www.techinsights.com/blog/smic-n3-kirin-9030-pro-process-flow-analysis. The process flow and materials, behind a paywall; not used here.
- SemiWiki / TechInsights, "Kirin 9030 Hints at SMIC's Possible Paths Toward >300 MTr/mm² Without EUV": https://semiwiki.com/semiconductor-services/techinsights/365118-forwarded-this-email-subscribe-here-for-more-kirin-9030-hints-at-smics-possible-paths-toward-300-mtr-mm2-without-euv/. Context on the node's density.

## ASAP7

- L. T. Clark, V. Vashishtha, et al., "ASAP7: A 7-nm finFET predictive process design kit", Microelectronics Journal 53, 2016, pages 105 to 115, and the design-rule manual shipped with the kit. The source of ASAP7's dimensions and of the meaning of its rules.
- OpenROAD-flow-scripts, `flow/platforms/asap7`: https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts. The seven stock stack files that the new ones are derived from, and the cells. Vendored under `vendor/asap7` at the revision recorded in `vendor/asap7.lock.hjson`.
- ASU cell library repository `asap7sc7p5t_27`: https://github.com/The-OpenROAD-Project/asap7sc7p5t_27. The source of one simulation model, vendored under `vendor/asap7sc7p5t_27`.

## Formats and methods

- LEF/DEF Language Reference, for the layer, spacing, via and via-rule syntax of the technology LEF.
- OpenROAD documentation, for the wire RC commands, the power-grid commands and the extraction rules format: https://openroad.readthedocs.io
- IEEE International Roadmap for Devices and Systems, More Moore tables, for interconnect pitches and height-to-width ratios per node generation, which support scaling thickness with width.
- D. Gall, "Electron mean free path in elemental metals", Journal of Applied Physics 119, 2016, for the rise of resistivity in narrow lines, which is why holding resistivity constant overestimates the resistance of the wider wires.
