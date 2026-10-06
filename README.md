# WheatCAP weather demo data

A small subset of in-field weather station data from five U.S. field sites in 2023, prepared for live demonstrations in the WheatCAP short course *Generative AI Agents for R* (Elle O'Brien, University of Michigan School of Information, November 2026).

## Data source and attribution

All data in `data/` come from the **Genomes to Fields (G2F) Initiative 2023 dataset**, published on the CyVerse Data Commons.

**Please cite the original dataset if you use these data:**

> Genomes to Fields. (2025). *Genomes to Fields 2023 dataset* [Data set]. CyVerse Data Commons. https://doi.org/10.25739/rzzy-3n27

- Dataset page: https://dc.cyverse.org/dataset/genomes_to_fields_2023_dataset
- Genomes to Fields Initiative: https://www.genomes2fields.org/
- Credit for collecting these data belongs to the G2F Initiative and its field cooperators at each site. The course and its author did not collect any of these data.

### License

The original dataset is released under the **Open Data Commons Public Domain Dedication and License (ODC-PDDL) v1.0**: https://opendatacommons.org/licenses/pddl/1-0/

This subset is redistributed under the same terms. The PDDL places the data in the public domain and does not legally require attribution, but we ask that you cite the dataset as above, following scholarly norms and the G2F citation request.

This repository is not affiliated with, reviewed by, or endorsed by the Genomes to Fields Initiative or CyVerse.

## Files

| File | Contents |
|---|---|
| `data/g2f_2023_weather_5sites.csv` | Sub-daily weather station readings (35,190 rows, 18 columns) |
| `data/sites.csv` | One row per site: location, station coordinates, irrigation, planting and harvest dates |
| `data/source_docs/` | Original G2F documentation, including column definitions for the weather data |

## Sites

The original G2F trials at these sites are maize hybrid trials. Logging intervals differ by site: 15 min (NEH1), 30 min (TXH1, MOH1), 60 min (MNH1, NYH2).
