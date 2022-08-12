from tabula import read_pdf
from tabulate import tabulate
import pandas as pd
#reads table from pdf file

df = read_pdf("form34a/Baringo/1_34_A_049292145106801_F230450M00209066_20220809_175926.PDF",pages="all") 
