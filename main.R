## ---- packages
library(denguedatahub)
library(tsibbletalk)
library(tsibble)
library(lubridate)
library(tidyverse)
library(magrittr)
library(feasts)

## ---- tsibbletalk
data(srilanka_weekly_data)
# code the data to province
srilanka_weekly_data <- srilanka_weekly_data %>%
  mutate(Province = case_when(
    district %in% c("Colombo", "Gampaha", "Kalutara") ~ "Western", 
    district %in% c("Kandy", "Matale", "NuwaraEliya") ~ "Central", 
    district %in% c("Galle","Hambanthota", "Matara") ~ "Southern", 
    district %in% c("Jaffna", "Kilinochchi", "Mannar", "Vavuniya", "Mullaitivu" ) ~ "Nothern", 
    district %in% c("Batticaloa", "Ampara", "Trincomalee", "Kalmune") ~ "Eastern", 
    district %in% c("Kurunegala", "Puttalam") ~ "North Western", 
    district %in% c("Anuradhapura", "Polonnaruwa") ~ "North Central", 
    district %in% c("Badulla", "Monaragala") ~ "Uva", 
    district %in% c("Ratnapura", "Kegalle") ~ "Sabaragamuwa"
  ))


srilanka_weekly_data$yw <- yearweek(srilanka_weekly_data$start.date)

srilanka_weekly_data_tsibble <- srilanka_weekly_data %>%
  tsibble(index = "yw", 
          key= c("district", "Province"), value = "cases")

dh_shared <- srilanka_weekly_data_tsibble %>%
  as_shared_tsibble(spec = (Province/district))

p0 <- plotly_key_tree(dh_shared, height = 800, width = 1000)

p1 <- dh_shared %>%
  ggplot(aes(x = start.date, y = cases)) +
  geom_line(aes(group = district),
            alpha = 0.5) + 
  xlab("Time") + ylab("Cases") 

dengue_feat <- dh_shared %>%
  features(cases, feat_stl)
p2 <- dengue_feat %>%
  ggplot(aes(x = trend_strength, y = seasonal_strength_year)) +
  geom_point(aes(group = district)) + 
  xlab("Strength of trend") + ylab("Strength of seasonality")


library(plotly)
subplot(p0,
        subplot(
          ggplotly(p1, tooltip = "District", width = 900),
          ggplotly(p2, tooltip = "District", width = 900),
          nrows = 2),
        widths = c(.4, .6)) %>%
  highlight(dynamic = TRUE)
