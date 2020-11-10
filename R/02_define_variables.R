# Description of variables. Source: https://covid19datahub.io/articles/doc/data.html
explaination <- c(# id:
                  "unique identifier", 
                  #Country: 
                  "country", 
                  # Date:
                  "observation date", 
                  # Tests:
                  "the cumulative number of tests in a country.", 
                  # Tested / Population:
                  "the cumulative number of tests in a country divided by the respective 
                  country's population.", 
                  # Confirmed Cases:
                  "the cumulative number of confirmed cases in a country.", 
                  # Confirmed Cases / Population:
                  "the cumulative number of confirmed cases in a country divided by the 
                  country's population.", 
                  # Confirmed Cases / Tests:
                  "the cumulative number of confirmed cases in a country divided by the 
                  number of tests performed in the country.", 
                  # Recovered:
                  "the cumulative number of patients released from hospitals or reported 
                  recovered in a country.", 
                  # Currently Infected: 
                  "the cumulative number of confirmed cases in a country minus the 
                  cumulative number of patients released from hospitals or reported 
                  recovered in the country.", 
                  # Currently Infected / Population:
                  "the cumulative number of confirmed cases in a country minus the 
                  cumulative number of patients released from hospitals or reported 
                  recovered in the country, divided by the country's population.", 
                  # COVID-19 Deaths:
                  "the cumulative number of COVID-19 related deaths in a country.", 
                  # COVID-19 Deaths / Population:
                  "the cumulative number of COVID-19 related deaths in a country divided 
                  by the country's population.", 
                  # COVID-19 Deaths / Confirmed Cases:
                  "the cumulative number of COVID-19 related deaths in a country divided 
                  by the cumulative number of confirmed cases in the respective country.", 
                  # Closed: Schools:
                  "(0) No measures; (1) Recommend closing; (2) Require closing (only some 
                  levels or categories, eg just high school, or just public schools); (3) 
                  Require closing all levels", 
                  # Closed: Workplaces:
                  "(0) No measures; (1) Recommend closing (or work from home); (2) require 
                  closing for some sectors or categories of workers; (3) require closing 
                  (or work from home) all-but-essential workplaces (eg grocery stores, 
                  doctors)", 
                  # Closed: Transport:
                  "(0) No measures; (1) Recommend closing (or significantly reduce volume/
                  route/means of transport available); (2) Require closing (or prohibit 
                  most citizens from using it)", 
                  # Closed: Events:
                  "(0) No measures; (1) Recommend cancelling; (2) Require cancelling", 
                  # Restriction: Gathering:
                  "(0) No restrictions; (1) Restrictions on very large gatherings (the 
                  limit is above 1000 people); (2) Restrictions on gatherings between 
                  100-1000 people; (3) Restrictions on gatherings between 10-100 people; 
                                  (4) Restrictions on gatherings of less than 10 people", 
                  # Restriction: Stay Home
                  "(0) No measures; (1) recommend not leaving house; (2) require not 
                  leaving house with exceptions for daily exercise, grocery shopping, 
                  and “essential” trips; (3) Require not leaving house with minimal 
                  exceptions (e.g. allowed to leave only once every few days, or only 
                  one person can leave at a time, etc.)", 
                  # Restriction: Internal Movement:
                  "(0) No measures; (1) Recommend closing (or significantly reduce 
                  volume/route/means of transport); (2) Require closing (or prohibit 
                  most people from using it)", 
                  # Restriction: International Movement:
                  "(0) No measures; (1) Screening; (2) Quarantine arrivals from high-risk 
                  regions; (3) Ban on high-risk regions; (4) Total border closure", 
                  # ISO id:
                  "ISO ID" 
                  )
explainations <- reshape2::melt(data.frame(c(colnames(data)), explaination))
