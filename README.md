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

### What was changed from the original

The subset was made from the files `b._2023_weather_data/g2f_2023_weather_cleaned.csv`, `z._2023_supplemental_info/g2f_2023_field_metadata.csv`, and `a._2023_phenotypic_data/g2f_2023_phenotypic_clean_data.csv` in the original release. Changes:

1. **Rows:** kept only the five sites listed below. All rows for those sites are kept, in their original order.
2. **Columns:** removed four columns that are entirely empty for these five sites (`NWS Network`, `NWS Station`, `Soil EC [mS/cm]`, `UV Light [uM/m2s]`). Remaining column names and values are unchanged.
3. **`sites.csv`** is a new summary table assembled from the field metadata (city, weather station coordinates, irrigation) and the phenotype file (state; the most common planting and harvest date across plots at each site). Column names were shortened.
4. **`data/source_docs/`** contains two unmodified files from the original release: the weather data description (PDF) and the weather cleaning readme.

No values were corrected, imputed, or re-checked. The weather values are exactly as published in the G2F "cleaned" file; the G2F cleaning steps are described in `data/source_docs/g2f_2023_weather_readMe.txt`.

## Files

| File | Contents |
|---|---|
| `data/g2f_2023_weather_5sites.csv` | Sub-daily weather station readings (35,190 rows, 18 columns) |
| `data/sites.csv` | One row per site: location, station coordinates, irrigation, planting and harvest dates |
| `data/source_docs/` | Original G2F documentation for the weather data |

## Sites

| Site | City | State | Logging interval |
|---|---|---|---|
| TXH1 | College Station | TX | 30 min |
| MOH1 | Columbia | MO | 30 min |
| NEH1 | Lincoln | NE | 15 min |
| MNH1 | Waseca | MN | 60 min |
| NYH2 | Aurora | NY | 60 min |

The original G2F trials at these sites are maize hybrid trials. Weather station coordinates are missing for MNH1 in the source metadata.

## Weather columns

Column definitions are in `data/source_docs/g2f_2023_weather_data_description.pdf`. In brief: site code (`Field Location`), station ID, timestamp (`Date_key`, plus separate `Month`, `Day`, `Year`, `Time`), air temperature, dew point, relative humidity, solar radiation, rainfall, wind speed, direction and gust, soil temperature, soil moisture, and PAR. Units are in the column names.
