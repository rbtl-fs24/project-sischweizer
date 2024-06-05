library(tidyverse)
library(googlesheets4)
library(dplyr)

data_raw <- read_sheet("https://docs.google.com/spreadsheets/d/1oKJt8kaRYJOm2kGwmz2Aph74URNqbdDViVdKyAoLeyo/edit?usp=drive_link")

glimpse(data_raw)
write_csv(data_raw, "data/raw/waste-characterisation-raw.csv")

data_test <- read_csv("data/raw/waste-characterisation-raw.csv")
glimpse(data_test)
