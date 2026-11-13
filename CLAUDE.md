# Project notes

## R scripting conventions

- Write scripts to be run interactively, chunk by chunk. Split them into sections with `# ---- Section name ----` headers, and end each chunk by printing or plotting what it made so it can be checked before moving on.
- Use the tidyverse (dplyr, readr, tidyr, stringr, forcats, lubridate, ggplot2) wherever possible, with the native pipe `|>`.
- Don't add error handling (`stop()`, `file.exists()` checks, `tryCatch()`, and so on).
- Don't define functions unless they are used more than once.
- Put scripts in `scripts/` and write file paths relative to the repository root. Save figures to `figures/`.
