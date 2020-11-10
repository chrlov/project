#### Data --------------------------------------------------------------------
# COVID-19 data
data <- COVID19::covid19() %>% 
  transmute("Country"                             = administrative_area_level_1,
            "Date"                                = date,
            "Tests"                               = tests,
            "Tests / Population"                  = tests / population,
            "Confirmed Cases"                     = confirmed,
            "Confirmed Cases / Population"        = confirmed / population,
            "Confirmed Cases / Tests"             = confirmed / tests,
            "Recovered"                           = recovered,
            "Currently Infected"                  = confirmed - recovered, 
            "Currently Infected / Population"     = (confirmed - recovered) / population,
            "Deaths"                              = deaths,
            "Deaths / Population"                 = deaths / population,
            "Deaths / Confirmed Cases"            = deaths / confirmed,
            "Closed: Schools"                     = school_closing,
            "Closed: Workplaces"                  = workplace_closing,
            "Closed: Transport"                   = transport_closing,
            "Closed: Events"                      = cancel_events,
            "Restriction: Gathering"              = gatherings_restrictions,
            "Restriction: Stay Home"              = stay_home_restrictions,
            "Restriction: Internal Movement"      = internal_movement_restrictions,
            "Restriction: International Movement" = international_movement_restrictions,
            "iso_a2"                              = iso_alpha_2
  )
