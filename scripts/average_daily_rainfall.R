# Average daily rainfall at each G2F 2023 site
#
# Run chunk by chunk from the repository root (e.g. open the folder as an
# RStudio project). Sites log at different intervals (15, 30 or 60 min), so
# we sum rainfall within each day first, then average the daily totals.

library(tidyverse)

# ---- Read data ----

weather <- read_csv("data/g2f_2023_weather_5sites.csv") |>
  rename(site = `Field Location`, rain_mm = `Rainfall [mm]`) |>
  mutate(date = as_date(mdy_hm(Date_key)))

weather |> count(site)

# ---- Look for implausible readings ----

# Anything over 100 mm in a single 15-60 minute reading is a sensor error.
# This turns up two MOH1 readings on 2023-06-04 (222 mm and 875 mm).
weather |>
  filter(rain_mm > 100) |>
  select(site, Date_key, rain_mm)

# ---- Daily rainfall totals ----

rain_daily <- weather |>
  filter(!is.na(rain_mm), rain_mm <= 100) |>
  group_by(site, date) |>
  summarise(rain_mm = sum(rain_mm), .groups = "drop")

rain_daily

# ---- Average daily rainfall per site ----

# Note: sites cover different date ranges, so these averages are not for a
# common calendar window.
rain_summary <- rain_daily |>
  group_by(site) |>
  summarise(
    first_day       = min(date),
    last_day        = max(date),
    days_with_data  = n(),
    total_mm        = sum(rain_mm),
    mean_mm_per_day = mean(rain_mm),
    rainy_days      = sum(rain_mm > 0.25)  # 0.25 mm ~ 0.01 in, trace threshold
  ) |>
  arrange(desc(mean_mm_per_day))

rain_summary
