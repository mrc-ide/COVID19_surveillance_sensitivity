## load dplyr to enable use of pipe operator (%>%)
library(dplyr)

## read data set
international <- readr::read_csv("exported_cases.csv")
exported <- dplyr::filter(
  international,
  local_transmission_y_n %in% c("n" , "n - implied", "no")
)

## total number of exported cases
overall <- nrow(exported)
## whether we want to include or exclude repatriated cases from our analysis or not. TRUE --> exclude
exclude_repatriated <- TRUE

## cases that weren't local transmission -- local = any transmission outside mainland china

## recoding ambiguous travel histories to correct meanings
exported$travel_history_to_hubei_y_n <- dplyr::case_when(
  exported$travel_history_to_hubei_y_n %in% c("y", "yes") ~ "y",
  exported$travel_history_to_hubei_y_n %in% c("no", "n", "n - implied") ~ "n",
  TRUE ~ exported$travel_history_to_hubei_y_n
)

## repatriated cases
repatriated <- dplyr::filter(
  exported,
  mode_of_transport_plain_train == "air - repatriated",
  ### check this as this line was missing from the Rmd file
  repatriated == "yes"
)

## countries and their travel history information
travel_history <-
  dplyr::count(exported, country, travel_history_to_hubei_y_n) %>%
  tidyr::spread(key = travel_history_to_hubei_y_n, n, fill = 0)

## rename column names
travel_history <- dplyr::rename(
  travel_history,
  Country = country,
  `No Travel History to Hubei` = n,
  `Travel History to Hubei` = y
)

## cases travelling by train
dplyr::count(exported, mode_of_transport_plain_train)

## which countries have cases from China with no mode of transport specified
unique(
  exported$country[is.na(exported$mode_of_transport_plain_train)]
)

## other options that imply travel by plane
air_codes <- c(
  "air",
  "air (inferred)",
  "air - repatriated",
  "air, train",
  "air, bus",
  "air - inferred", "air - implied"
)

## include only cases with a mode of transport matching one of the air codes
exported <- exported[exported$mode_of_transport_plain_train %in% air_codes, ]

## if we are excluding repatriation then remove them from the data set
if (exclude_repatriated) {
  exported <- exported[! (exported$mode_of_transport_plain_train %in% c("air - repatriated")), ]
}

## count the cases travelling by air, aggregated by country
by_air <- dplyr::count(exported, country, name = "Traveled by air")
## count the cases who were repatriates from Wuhan, aggregated by country
repats_by_country <- dplyr::count(repatriated, country, name = "Repatriation Flight")

## merge these data sets
dplyr::left_join(
  travel_history, by_air, by = c("Country" = "country")
) %>%
  dplyr::left_join(repats_by_country, by = c("Country" = "country")) %>%
  readr::write_csv("cdo_by_air.csv")










