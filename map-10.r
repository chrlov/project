########################### Introduction to R ###############################
################## Autumn 2020 - Term Paper - GROUP 32 #######################
# Caroline Charlotte Bjelland, Helle Sofie Bratsberg and Julie Isabelle Malmedal Tverfjell

## In this project we will look at events that can be linked directly to the covid-19 
## pandemic, such as demonstrations, riots and similar. We will map this and compare 
## it with the number of confirmed cases and/or number of covid-19 related deaths. 
## We start with looking at the data from all countries in Europe. We have a data frame 
## containing events and a data frame containing confirmed cases and deaths from covid-19.

# Clean up workplace
rm(list=ls())

# Run the necessary packages
library(readxl)
library(dplyr)
library(RCurl) # Needed in order to get the csv from a https 
library(ggplot2) # For plotting maps 
library(sf) # For plotting maps 
library(ggspatial) # For plotting maps (annotation scale)
library(rnaturalearth) # Provides world map data

####################################
####################################
# First data set on covid-19 confirmed cases and deaths.
# Source: World Health Organization (data may be incomplete for the current day or week)
# We download the data directly from an URL so its easier to update with new information. 
download <- getURL("https://covid19.who.int/WHO-COVID-19-global-data.csv?accessType=DOWNLOAD")
dataset <- read.csv(text = download, sep = ",")
rm(download)

# Then we start cleaning the dataset:
# - we select the variables we need
# - we select only countries from the Eurpean region
# - we reduce the number of observations by dropping the days where no death
#   was reported.

covid_deaths <- 
  dataset %>% 
  select(c(ï..Date_reported, Country_code, Country, WHO_region, New_deaths)) %>%
  rename(
    date = ï..Date_reported,
    iso_a2 = Country_code,
    country = Country,
    region = WHO_region,
    deaths = New_deaths
  ) %>%
  filter(region == "EURO") %>%
  filter(deaths > 0) %>%
  group_by(iso_a2) %>%
  mutate(totaldeaths = sum(deaths))

View(covid_deaths)

# We can now inspect the total reported number of covid-19 related deaths in each country.
# The country with the highest number of reported deaths is Great Britain with 41 623.
total_country <- covid_deaths %>%
  ungroup() %>%
  select(country, totaldeaths) %>%
  distinct() %>%
  arrange(desc(totaldeaths))

View(total_country)

# Selecting what we need for the plot.
covid_deaths <- covid_deaths %>%
  select(iso_a2, totaldeaths) %>%
  distinct()

####################################
####################################
# Second data set: "Direct Covid-19 Disorder Events"
# Source: The Armed Conflict Location and Event Data Project (ACLED)
eventscorona <- read_excel("coronavirus_Sep12.xlsx")

# With glimpse we can examine all columns and check the class at the same time. 
glimpse(eventscorona)

# Shows us how many observations we have per region.
# Our plan is to look at Europe and we see that there has been 650 events of unrest 
# due to COVID-19. Other regions have significantly more, for ecample Asia with 3000 and
# South America with 2493 but we will stick with Europe for now.
count(eventscorona, REGION) 

# Extracting only the columns we find interesting and might be useful in making the map.
# Also filtered to only contain the 650 events in Europe
eventsdf <- eventscorona %>%
  select(REGION, COUNTRY, ISO, EVENT_DATE, YEAR, EVENT_TYPE, SUB_EVENT_TYPE, 
         LOCATION, LATITUDE, LONGITUDE, NOTES, FATALITIES) %>% 
  rename(region = REGION, 
         country = COUNTRY, 
         iso = ISO, 
         date = EVENT_DATE, 
         year = YEAR,
         event_type = EVENT_TYPE, 
         sub_event_type =  SUB_EVENT_TYPE, 
         location = LOCATION,
         latitude = LATITUDE, 
         longitude = LONGITUDE, 
         notes = NOTES, 
         fatalities = FATALITIES
  ) %>% 
  filter(region == "Europe") %>%
  group_by(country)

# We now inspect how many events each country in Europe have
# the highets number of events is Ukraine with 118 and Greece with 88. 
count(eventsdf, country)

# Selecting what we need for the plot.
eventsdf <- 
  eventsdf %>% 
  ungroup() %>% 
  select(longitude, latitude)

####################################
####################################

# Load data and plot world map
world <- ne_countries(scale = "medium", returnclass = "sf")
ggplot(data = world) + geom_sf()

# We experience some difficulties along the way, where one is that Kosovo is not registered
# with an ISO Country Code in the "world"-dataset. A quick search on Google gives
# us the information that there is no ISO Country Code for Kosovo, but the country has a self 
# assigned code "XK" which is used by many international organisations. We see that this
# code is used in our second dataset "covid-deaths" and therefore decide to rename the 
# ISO Country Code for Kosovo in the dataset where it is missing.

world$iso_a2[world$sovereignt == "Kosovo"] <- "XK"

# Joining covid deaths data with world map data
world2 <- world %>%
  inner_join(covid_deaths, by = "iso_a2")

# Plotting heat map of covid-19 deaths with a plot of covid related events of unrest. 
# We had some problems combining these two datasets into one map, and tried multiple methods before finding a solution.
p <- ggplot(data = world2) +
  annotation_scale(location = "bl", width_hint = 0.5) +
  theme(panel.grid.major = element_line(linetype = "blank"), 
              panel.background = element_rect(fill = "aliceblue")) +
  geom_sf(aes(fill = (totaldeaths/(pop_est/1000000)))) +
  geom_point(data = eventsdf, aes(x = longitude, y = latitude), size = 2.5, 
             shape = 20, fill = "black", alpha = 0.3) +
  scale_fill_gradient(low = "white", high = "red", trans = "sqrt") + 
  coord_sf(xlim = c(-25, 50), ylim = c(35, 75))

# Changing legend titles, axis names and plot title.
p <- p + 
  labs(fill = "Deaths per 1 mill") + 
  ylab("") + xlab("") +
  ggtitle("Covid-19 deaths and events of unrest") + 
  theme(plot.title = element_text(hjust = 0.5))

# Running map
p

# KILDER
# https://www.r-spatial.org/r/2018/10/25/ggplot2-sf-2.html
# https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html
