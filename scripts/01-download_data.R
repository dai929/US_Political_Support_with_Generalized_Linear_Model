#### Preamble ####
# Purpose: Access the CCES dataset, save the data that are of interest to us, and then refer to that saved dataset.
# Author: Daisy Huo
# Date: 8 March 2024
# Contact: daisy.huo@mail.utoronto.ca
# License: MIT
# Pre-requisites: N/A

#### Workspace setup ####
library(tidyverse)
library(dataverse)
library(arrow)

#### Download data ####
# Refer to code from: https://tellingstorieswithdata.com/13-ijaglm.html#political-support-in-the-united-states

cces2016 <-
  get_dataframe_by_name(
    filename = "CCES16_Common_OUTPUT_Feb2018_VV.tab",
    dataset = "10.7910/DVN/GDF6Z0",
    server = "dataverse.harvard.edu"
  ) |>
  select(votereg, CC16_410a, gender, employ)
  
### Save data ###

write_csv(cces2016, "cces2016.csv")

write_parquet(
  x = cces2016, 
  sink = 
    "cces2016.parquet"
)

cces2016