#### Preamble ####
# Purpose: Simulate a dataset where the chance that a person supports Trump depends on their gender and employment status.
# Author: Daisy Huo
# Date: 8 March 2024
# Contact: daisy.huo@mail.utoronto.ca
# License: MIT
# Pre-requisites: N/A

#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
# Refer to code from: https://tellingstorieswithdata.com/13-ijaglm.html#political-support-in-the-united-states

set.seed(312)

num_obs <- 1000

sim_us_political_preferences <- 
  tibble(
    employment = sample(0:7, size = num_obs, replace = TRUE),
    gender = sample(0:1, size = num_obs, replace = TRUE),
    support_prob = ((employment + gender) / 8),
  ) |>
  mutate(
    support_trump = if_else(runif(n = num_obs) < support_prob, "yes", "no"),
    employment = case_when(
      employment == 0 ~ "Full-time",
      employment == 1 ~ "Part-time",
      employment == 2 ~ "Temporarily laid off",
      employment == 3 ~ "Unemployed",
      employment == 4 ~ "Retired",
      employment == 5 ~ "Permanently disabled",
      employment == 6 ~ "Homemaker",
      employment == 7 ~ "Student"
    ),
    gender = if_else(gender == 0, "Male", "Female")
  ) |>
  select(-support_prob, support_trump, gender, employment)

sim_us_political_preferences

### Tests ###

sim_us_political_preferences$employment |>
  unique() |>
  length() == 8

sim_us_political_preferences$gender |>
  unique() |>
  length() == 2

sim_us_political_preferences$support_trump |>
  unique() == c("yes", "no")

sim_us_political_preferences$employment |>
  class() == "character"

sim_us_political_preferences$gender |>
  class() == "character"

sim_us_political_preferences$support_trump |>
  class() == "character"
