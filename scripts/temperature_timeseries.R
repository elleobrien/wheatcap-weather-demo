# Daily air temperature at each G2F 2023 site
#
# Run chunk by chunk from the repository root. Writes
# figures/temperature_timeseries.png.
#
# Raw readings come every 15-60 minutes depending on the site, so plotting
# them directly shows mostly the day/night cycle. Instead we summarise each
# day as its minimum, mean and maximum temperature.

library(tidyverse)

# ---- Read data ----

weather <- read_csv("data/g2f_2023_weather_5sites.csv") |>
  rename(site = `Field Location`, temp_c = `Temperature [C]`) |>
  mutate(timestamp = mdy_hm(Date_key), date = as_date(timestamp))

sites <- read_csv("data/sites.csv")

# ---- Look at the raw readings for one week ----

# The day/night cycle dominates the raw data. Change the site or dates to look
# at others.
weather |>
  filter(site == "NEH1", date >= as_date("2023-07-01"), date < as_date("2023-07-08")) |>
  ggplot(aes(timestamp, temp_c)) +
  geom_line(colour = "#2a78d6") +
  labs(x = NULL, y = "Temperature (°C)") +
  theme_minimal()

# ---- Readings per day ----

# Expected readings per day: 96 at NEH1 (15 min), 48 at MOH1 and TXH1
# (30 min), 24 at MNH1 and NYH2 (60 min). A day with far fewer readings has a
# misleading min and max, so flag days with under 75% of the site's usual count.
readings_per_day <- weather |>
  filter(!is.na(temp_c)) |>
  count(site, date) |>
  group_by(site) |>
  mutate(partial_day = n < 0.75 * median(n)) |>
  ungroup()

readings_per_day |> filter(partial_day)

# ---- Daily min, mean and max ----

temp_daily <- weather |>
  filter(!is.na(temp_c)) |>
  semi_join(filter(readings_per_day, !partial_day), by = c("site", "date")) |>
  group_by(site, date) |>
  summarise(
    temp_min  = min(temp_c),
    temp_mean = mean(temp_c),
    temp_max  = max(temp_c),
    .groups = "drop"
  )

temp_daily |>
  group_by(site) |>
  summarise(across(c(temp_min, temp_mean, temp_max), list(lowest = min, highest = max)))

# ---- Site labels, ordered north to south ----

site_labels <- sites |>
  mutate(label = str_glue("{site} · {city}, {state}")) |>
  arrange(desc(replace_na(station_lat, 44.07))) |>  # MNH1 has no lat; Waseca ~44.07
  mutate(label = fct_inorder(label)) |>
  select(site, label)

temp_daily <- temp_daily |>
  left_join(site_labels, by = "site")

# ---- Plot ----

# Shaded band: daily low to daily high. Line: daily mean.
# Shared axes so the sites can be compared directly; dashed line at 0 °C.
temp_plot <- ggplot(temp_daily, aes(date)) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60", linewidth = 0.3) +
  geom_ribbon(aes(ymin = temp_min, ymax = temp_max), fill = "#b7d3f6") +
  geom_line(aes(y = temp_mean), colour = "#2a78d6", linewidth = 0.6) +
  facet_wrap(~label, ncol = 1) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b") +
  coord_cartesian(xlim = as_date(c("2023-05-01", "2023-12-01"))) +
  labs(
    title = "Daily air temperature at five Genomes to Fields maize sites, 2023",
    subtitle = "Band: daily low to high. Line: daily mean.",
    x = NULL, y = "Temperature (°C)",
    caption = str_c(
      "Days with under 75% of the usual number of readings are left out. ",
      "Data: Genomes to Fields 2023 dataset, doi:10.25739/rzzy-3n27."
    )
  ) +
  theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    strip.text = element_text(hjust = 0, face = "bold"),
    plot.title.position = "plot"
  )

temp_plot

dir.create("figures", showWarnings = FALSE)
ggsave("figures/temperature_timeseries.png", temp_plot,
       width = 9, height = 9, dpi = 200, bg = "white")
