nms_clean <- function(data_set){
    nms_old <- names(data_set)
    nms_new <- nms_old %>% tolower() 
    nms_new <- gsub("\\s", "_", nms_new)
    nms_new <- gsub("\\.$", "", nms_new)
    nms_new <- gsub("\\(|\\)|%", "", nms_new)
    nms_new <- gsub("/", "", nms_new)
    nms_new <- gsub("-", "_", nms_new)
    setDT(data_set)
    setnames(data_set, nms_old, nms_new)
    data_set
}

nms_clean_vec <- function(nms_old){
    nms_new <- nms_old %>% tolower() 
    nms_new <- gsub("\\s", "_", nms_new)
    nms_new <- gsub("\\.$", "", nms_new)
    nms_new <- gsub("\\(|\\)|%", "", nms_new)
    nms_new <- gsub("/", "", nms_new)
    nms_new <- gsub("-|\\.", "_", nms_new)
    nms_new <- gsub("_{2,5}", "_", nms_new)
    nms_new
}

#targets = 1:ncol(df)
data_table <- function(df){
    library(DT)
    datatable(df,
              rownames = FALSE,
              style = "bootstrap4", class = 'cell-border stripe',
              options = list(scrollX = TRUE,
                             columnDefs = list(list(className = 'dt-center'))
              ) 
    )%>%
        formatStyle(names(df), textAlign = 'center')
}
