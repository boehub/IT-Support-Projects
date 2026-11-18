# Data Analysis: Hardware Comparisons

Spreadsheet-based comparisons for choosing and explaining PC hardware. Both workbooks start from the same data (a Ryzen 7 4800U laptop chip against a Ryzen 9 5950X desktop chip, plus four related laptop chips), so you can see how a one-off comparison turns into a reusable tool.

| File | What it is | Use it when |
|---|---|---|
| [`Hardware_Comparison_Dashboard.xlsx`](Hardware_Comparison_Dashboard.xlsx) | **Refined version.** Interactive dashboard: pick any baseline and challenger chip from dropdowns, choose a priority profile, and everything recalculates | Comparing chips for a customer, or adding new chips and benchmarks |
| [`Ryzen_7_4800U_vs_Ryzen_9_5950X_Original.xlsx`](Ryzen_7_4800U_vs_Ryzen_9_5950X_Original.xlsx) | **Original version.** Fixed two-chip comparison with one tab per topic and charts on most tabs | Seeing the raw numbers laid out simply, or as a starting point for a new comparison |

## Refined dashboard: how it is built

| Sheet | Purpose |
|---|---|
| Dashboard | Dropdowns, headline tiles (overall score, metrics won, performance per watt, data confidence), category table, performance ladder, charts |
| Read Me | Instructions, scoring method, and the honest limits of the data |
| Specs | **Input.** Up to 8 chips: cores, threads, clocks, TDP, cache, integrated graphics |
| Scores | **Input.** Up to 15 metrics with category, direction (higher or lower is better), and per-chip scores |
| Calc | Working sheet that does the maths. No inputs go here |

**Scoring method.** Each metric becomes a ratio against the baseline chip (baseline = 100). Metrics in a category are combined with a geometric mean, and the overall score is a weighted geometric mean of the categories. A metric is used only when both chips have a score for it.

**Adding a chip or metric.** Type it into the next blank slot on Specs or Scores (yellow cells with blue text are inputs). Keep slots consecutive with no gaps so the dropdowns work.

## Original workbook: tabs

Dashboard (indexed headline chart), Overview (spec table), CPU Benchmarks (Cinebench R23, Geekbench 5 and 6, six chips), Rendering (Blender), Gaming & Graphics (integrated graphics frame rates).

## Limits to keep in mind

- Benchmark scores come from cpu-monkey.com and community Blender Open Data submissions, collected September 2026.
- Per-watt figures use **rated TDP**, not measured power, and runs were not normalised to the same power limit.
- The 4800U Blender median rests on only 12 submissions. The dashboard flags low sample sizes.
- Gaming figures are approximate readings of review text such as "60+ FPS".
- The 5950X has no integrated graphics, so it is not "slower" at games; it needs a discrete GPU.

## Sources

cpu-monkey.com CPU database; opendata.blender.org device pages; TechSpot reviews of the Ryzen 7 4800U and Ryzen 9 5950X; Notebookcheck processor comparison pages (cross-check of the extra laptop chips).

## Why this lives in an IT support repo

Recommending a replacement, upgrade, or build means defending the choice with numbers. These workbooks are the method: collect scores, normalise them, weigh them by what the customer cares about, and be clear about how reliable the data is. Background on what each spec means is in the [Hardware Guide](../Hardware-Guide/).
