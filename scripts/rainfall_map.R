# Map of the five G2F 2023 sites with a daily rainfall time series for each
#
# Run chunk by chunk from the repository root. Writes figures/rainfall_map.png.

library(tidyverse)
library(patchwork)
library(ggrepel)

# ---- Read data ----

weather <- read_csv("data/g2f_2023_weather_5sites.csv") |>
  rename(site = `Field Location`, rain_mm = `Rainfall [mm]`) |>
  mutate(date = as_date(mdy_hm(Date_key)))

sites <- read_csv("data/sites.csv")
sites

# ---- Fill in the missing MNH1 coordinates ----

# sites.csv has no station coordinates for MNH1. These are approximate
# coordinates for the University of Minnesota research station at Waseca,
# good enough to place the point on a national map.
sites <- sites |>
  mutate(
    station_lat = if_else(site == "MNH1", 44.07, station_lat),
    station_lon = if_else(site == "MNH1", -93.53, station_lon)
  )

# ---- Daily rainfall totals ----

# Drop the two impossible MOH1 readings (>100 mm in 30 minutes on 2023-06-04).
rain_daily <- weather |>
  filter(!is.na(rain_mm), rain_mm <= 100) |>
  group_by(site, date) |>
  summarise(rain_mm = sum(rain_mm), .groups = "drop")

# ---- Site labels, ordered north to south ----

# The same label is used on the map and as the panel title, so the two
# halves of the figure match by name.
site_labels <- rain_daily |>
  group_by(site) |>
  summarise(total_mm = sum(rain_mm), first_day = min(date), last_day = max(date)) |>
  left_join(sites, by = "site") |>
  mutate(label = str_glue("{site} · {city}, {state}  ({round(total_mm)} mm)")) |>
  arrange(desc(station_lat)) |>
  mutate(label = fct_inorder(label))

site_labels

rain_daily <- rain_daily |>
  left_join(select(site_labels, site, label), by = "site")

# ---- Map ----

states <- map_data("state")

map_plot <- ggplot() +
  geom_polygon(data = states, aes(long, lat, group = group),
               fill = "grey95", colour = "grey75", linewidth = 0.25) +
  geom_point(data = site_labels, aes(station_lon, station_lat),
             colour = "#2a78d6", size = 3) +
  geom_text_repel(data = site_labels,
                  aes(station_lon, station_lat,
                      label = str_glue("{site}\n{city}, {state}")),
                  size = 3.2, lineheight = 0.9, colour = "grey20",
                  min.segment.length = 0, seed = 1) +
  coord_quickmap() +
  theme_void()

map_plot

# ---- Daily rainfall time series ----

# Shared x and y axes, so differences in rainfall and in each station's
# recording period are both visible at a glance. The grey band marks the dates
# a station was recording, so a dry day reads differently from a missing one.
rain_plot <- ggplot(rain_daily, aes(date, rain_mm)) +
  geom_rect(data = site_labels,
            aes(xmin = first_day - 0.5, xmax = last_day + 0.5,
                ymin = -Inf, ymax = Inf),
            inherit.aes = FALSE, fill = "grey93") +
  geom_col(fill = "#2a78d6", width = 1) +
  facet_wrap(~label, ncol = 1) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b") +
  coord_cartesian(xlim = as_date(c("2023-05-01", "2023-12-01"))) +
  labs(x = NULL, y = "Daily rainfall (mm)") +
  theme_minimal(base_size = 10) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    strip.text = element_text(hjust = 0, face = "bold")
  )

rain_plot

# ---- Combine and save ----

rainfall_figure <- map_plot + rain_plot +
  plot_layout(widths = c(1.4, 1)) +
  plot_annotation(
    title = "Daily rainfall at five Genomes to Fields maize sites, 2023",
    caption = str_c(
      "Grey band: dates each station was recording. Totals cover that period only. ",
      "Two implausible MOH1 readings (6/4/2023) removed. TXH1 was irrigated.\n",
      "Data: Genomes to Fields 2023 dataset, doi:10.25739/rzzy-3n27."
    )
  )

rainfall_figure

dir.create("figures", showWarnings = FALSE)
ggsave("figures/rainfall_map.png", rainfall_figure,
       width = 12, height = 6.5, dpi = 200, bg = "white")
