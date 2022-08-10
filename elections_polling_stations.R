
library(tidyverse)
library(data.table)
library(tabulizer)
library(here)
library(foreach)
polling_folder <- here("data", "polling_stations")

stations_files <- list.files(polling_folder)

stations_files_path <- here(polling_folder,stations_files )

df <- fread(stations_files_path[1])


stations_dfs <- foreach(i = 1:no_files) %do%{
    
    x = stations_files_path[i]
    df <- fread(x)
    col_nms <- df[1, ] %>% as.character() %>% nms_clean_vec()
    df <- df[-1,]
    names(df) <- col_nms
    df
    
}

station_voters <- rbindlist(stations_dfs)
station_voters[, registered_voters := str_replace_all(registered_voters, "\\s", "") ]
station_voters[, registered_voters := str_replace_all(registered_voters, "[A-Z]{1,20}|[a-z]{1,20}|\\)|\\(|,|'|-", "") ]
#station_voters[, voters := str_extract(registered_voters, "[0-9]{1,7}")]

station_voters[, registered_voters := as.numeric(registered_voters)]
df  <- station_voters[is.na(registered_voters)]
total <- station_voters[county_code == "Total"]
station_voters <- station_voters[county_code != "Total"]
station_voters[, sum(registered_voters)]

station_voters[, `:=` (Raila = "", Ruto = "", Wajackoyah = "", Waihiga = "", Turnout = "")]


write_csv(station_voters, file = here("data", "polling_stations.csv"))
