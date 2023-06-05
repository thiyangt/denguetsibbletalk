library(tidyverse)
library(tsibble)
library(denguedatahub)
library(tsibbletalk)
#devtools::install_github("thiyangt/denguedatahub")

#-------------------------------
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
#-------------------------------

is_duplicated(srilanka_weekly_data, 
            index = yw, key = district)

dupli <- duplicates(srilanka_weekly_data, 
              index = yw, key = district)
View(dupli)

# identify duplicates
#duprw <- which(srilanka_weekly_data$year==2020 &
#        srilanka_weekly_data$week ==52)
#srilanka_weekly_data <- srilanka_weekly_data[-duprw, ]
#dupli <- duplicates(srilanka_weekly_data, 
#                    index = yw, key = district)
#dupli

# 17655 17656 17657 17658 17659 17660 17661
# 17662 17663 17664 17665 17666 17667 17668
# 17669 17670 17671 17672 17673 17674 17675
# 17676 17677 17678 17679 17680

# Reinstall the package using github
# install.packages("devtools")

