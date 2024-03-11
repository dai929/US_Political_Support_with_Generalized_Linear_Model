#### Preamble ####
# Purpose: Build a generalized linear model and estimate the parameters for the 2016 CCES dataset.
# Author: Daisy Huo
# Date: 8 March 2024
# Contact: daisy.huo@mail.utoronto.ca
# License: MIT
# Pre-requisites: N/A

#### Workspace setup ####
library(tidyverse)
library(dataverse)
library(arrow)
library(modelsummary)
library(rstanarm)
library(marginaleffects)

#### Build model ####
# Refer to code from: https://tellingstorieswithdata.com/13-ijaglm.html#political-support-in-the-united-states

set.seed(312)

cces2016_reduced <- 
  cleaned_cces2016 |> 
  slice_sample(n = 2000)

political_preferences <-
  stan_glm(
    voted_for ~ gender + employment,
    data = cces2016_reduced,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = 
      normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 312
  )

saveRDS(
  political_preferences,
  file = "political_preferences.rds"
)

political_preferences <-
  readRDS(file = "outputs/data/political_preferences.rds")
