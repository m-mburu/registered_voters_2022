
library(tidyverse)
library(googlesheets4)
library(data.table)
library(janitor)
form34b_result<- read_sheet("https://docs.google.com/spreadsheets/d/1yqi02EUCweAXdo-yu_Cn_bV_kzjZqiQx3SWPk7yZPjg/edit#gid=0", sheet = "Data")

form34b_result <- nms_clean(form34b_result)

cols_interest <- c("county", "constituency", "code", "registered_voters", 
                   "raila", "ruto", "mwaura", "wajackoyah", "iebc_total", "auto_sum", 
                   "rejected_ballots")

form34b_result <- form34b_result[, ..cols_interest]

form34b_result <- form34b_result[!is.na(county)]


cols_id_vars <- c("county", "constituency", 
                  "code", "registered_voters", 
                   "iebc_total", "auto_sum")


form34b_resultm <- melt(form34b_result,
                        id.vars = cols_id_vars)


tab_president <- form34b_resultm[!is.na(value), .(freq = sum(value)),
                by = variable] %>%
    .[, Percentage := round(freq/sum(freq) * 100, 1)]

setorder(tab_president,-Percentage )

tab_president <- tab_president %>%
    adorn_totals(where = "row")

setDT(tab_president)

cand_lev <- c("raila", "ruto", "mwaura", 
              "wajackoyah", "rejected_ballots", "Total")

cand_lab <- c("Raila", "Ruto", "Mwaura", 
              "Wajackoyah", "Rejected Ballots", "Total")
old_nms <- c("variable", "freq", "Percentage")
new_nms <- c("Candidate", "Votes", "%")

tab_president[, variable := factor(variable, levels = cand_lev, labels = cand_lab)]

setnames(tab_president, old_nms, new_nms)