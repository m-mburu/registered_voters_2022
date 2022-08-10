from tabula import read_pdf
from tabulate import tabulate
import pandas as pd
#reads table from pdf file
df = read_pdf("https___www.iebc.or.ke_docs_rov_per_polling_station .pdf",pages="all") 
len_df = len(df)

for i in range(len_df):
    file_name = ['data/polling_stations/', "page_", str(i), "_.csv"]
    file_name = "".join(file_name)
    df[i].to_csv(file_name, index=False)
    
    
