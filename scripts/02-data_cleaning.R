#### Preamble ####
# Purpose: Clean the dataset with respondents who are registered to vote and voted for Trump or Clinton.
# Author: Daisy Huo
# Date: 8 March 2024
# Contact: daisy.huo@mail.utoronto.ca
# License: MIT
# Pre-requisites: N/A

#### Workspace setup ####
library(tidyverse)
library(arrow)
library(janitor)
library(readr)

#### Read data ####
# Refer to code from: https://tellingstorieswithdata.com/13-ijaglm.html#political-support-in-the-united-states

cces2016 <-
  read_csv(
    "inputs/data/cces2016.csv",
    col_types =
      cols(
        "votereg" = col_integer(),
        "CC16_410a" = col_integer(),
        "gender" = col_integer(),
        "employ" = col_integer()
      )
  )

cces2016

### Clean data ###

cleaned_cces2016 <-
  cces2016 |>
  filter(votereg == 1,
         CC16_410a %in% c(1, 2),
         employ %in% c(1, 2, 3, 4, 5, 6, 7, 8)) |>
  mutate(
    voted_for = if_else(CC16_410a == 1, "Trump", "Clinton"),
    voted_for = as_factor(voted_for),
    gender = if_else(gender == 1, "Male", "Female"),
    employment = case_when(
      employ == 1 ~ "Full-time",
      employ == 2 ~ "Part-time",
      employ == 3 ~ "Temporarily laid off",
      employ == 4 ~ "Unemployed",
      employ == 5 ~ "Retired",
      employ == 6 ~ "Permanently disabled",
      employ == 7 ~ "Homemaker",
      employ == 8 ~ "Student"
    ),
    employment = factor(
      employment,
      levels = c(
        "Full-time",
        "Part-time",
        "Temporarily laid off",
        "Unemployed",
        "Retired",
        "Permanently disabled",
        "Homemaker",
        "Student"
      )
    )
  ) |>
  select(voted_for, gender, employment)

cleaned_cces2016

### Save data ###

write_parquet(
  x = cleaned_cces2016, 
  sink = 
    "cces2016_analysis.parquet"
)

### Test data ###

cleaned_cces2016$voted_for |>
  unique() == c("Trump", "Clinton")

cleaned_cces2016$employment |>
  unique() |>
  length() == 8

cleaned_cces2016$gender |>
  unique() |>
  length() == 2

cleaned_cces2016$employment |>
  class() == "factor"

cleaned_cces2016$gender |>
  class() == "character"

cleaned_cces2016$voted_for |>
  class() == "factor"

