# Load Packages -----------------------------------------------------------
library(readr)
library(readxl)
library(rjson)
library(dplyr)
library(tidyverse)
library(shiny)
library(shinythemes)

# Load Data ---------------------------------------------------------------
data <- read_xlsx("https://acleddata.com/download/2909/")
data2 <- read.csv("https://api.acleddata.com/{data}/{command}.csv")

## If .json-file
# Give the input file name to the function.
result <- fromJSON(file = "input.json",
                   simplify = TRUE)
# Convert JSON file to a data frame.
json_data_frame <- as.data.frame(result)


# Data Wrangling ----------------------------------------------------------



# Define UI ---------------------------------------------------------------

# Select type of trend to plot

# Select date range to be plotted

# Select whether to overlay smooth trend line

# Display only if the smoother is checked

# Output: Description, lineplot, and reference

# Define Server Function --------------------------------------------------

# Subset data

# Create scatterplot object the plotOutput function is expecting

# Pull in description of trend



# Create Shiny Object -----------------------------------------------------

