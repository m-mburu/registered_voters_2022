library(tidyverse)
library(data.table)
library(tabulizer)
library(here)

voters_per_county <-here("https___www.iebc.or.ke_docs_rov_per_county.pdf") 

page1 <- extract_tables(voters_per_county,
                       pages = 1, guess = T, output = "data.frame")


page2 <- extract_tables(voters_per_county,
                        pages = 2, guess = T, output = "data.frame")


page1_df <- page1[[1]] %>% setDT()

page2_df <- page2[[1]] %>% setDT()

names(page1_df)[1] <- "col1"

col_nms <- page1_df[grepl("County Code", col1)]	 %>%
   as.character() %>% nms_clean_vec()

page1_df <- page1_df[!grepl("County Code", col1)]	

page1_df[, county_code := str_extract(col1, "^[0-9]{1,3}")]

page1_df[, registered_voters := str_extract(col1, " \\d.*$")]

ibc_col_nms <- c("county_code","county_name", "registered_voters")

page1_df[, county_name := str_replace_all(col1, "^[0-9]{1,3}| \\d.*$", "")]

page1_df[, (ibc_col_nms) := lapply(.SD, str_trim), .SDcols = ibc_col_nms]

names(page2_df)

setDF(page2_df)
page2_df[nrow(page2_df)+1, ] <- names(page2_df)

setDT(page2_df)

page2clnms <- c("county_name", "registered_voters")

names(page2_df) <-page2clnms

page2_df[, (page2clnms) := lapply(.SD, str_replace, "^X", ""), .SDcols =page2clnms ]

page2_df[, (page2clnms) := lapply(.SD, str_replace_all, "\\.\\.|\\.", " "), .SDcols =page2clnms ]

page2_df[, county_code := str_extract(county_name, "^[0-9]{1,3}")]
page2_df[, county_name := str_replace_all(county_name, "^[0-9]{1,3}| \\d.*$", "")]

registered_voters22 <- rbind(page1_df, page2_df, fill = T)

registered_voters22 <- registered_voters22[, ..ibc_col_nms]

registered_voters22[, (ibc_col_nms) := lapply(.SD, str_trim), .SDcols = ibc_col_nms]

registered_voters22 <- registered_voters22[!is.na(county_code)]

registered_voters22[, registered_voters := str_replace_all(registered_voters, ",|\\s", "")]

registered_voters22[, registered_voters := as.numeric(registered_voters)]

setorder(registered_voters22, county_code)

write_csv(registered_voters22, file = here("data", "county_registered_voters22.csv"))

