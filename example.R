library(tidyverse)
library(data.table)
library(tabulizer)
library(here)
library(animation)
library(pdftools)
voters_per_county <-here("form34a/Baringo/1_34_A_030162081013501_Y3KK10BB4HA00PB_20220809_190014.PDF") 

bitmap <- pdf_render_page(voters_per_county, page = 1)

png::writePNG(bitmap, "form34a/test.png")

im.convert(voters_per_county, output = "form34a/test.png", extra.opts="-density 150")

page1 <- extract_text(voters_per_county,
                      pages = 1)
page1

library(tesseract)
eng <- tesseract("eng")
text <- tesseract::ocr_data("form34a/1_34_A_030162081013501_Y3KK10BB4HA00PB_20220809_190014.PDF", engine = eng)
cat(text)
pngfile <- pdftools::pdf_convert(voters_per_county, dpi = 600)

text <- tesseract::ocr(pngfile)
cat(text)
