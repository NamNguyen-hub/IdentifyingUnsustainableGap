library(rstudioapi)
library(bookdown)
setwd(dirname(getActiveDocumentContext()$path))
getwd()


bookdown::render_book("index.Rmd", "bookdown::pdf_document2", new_session = T)

page = 3
path <- paste0(getwd(),"/_book/_main.pdf")
system(paste0('osascript gotopage.scpt "', path, '" ', page))

# path <- "_book/_main.pdf"
# system(paste0('open "', path, '"'))


#osascript gotopage.scpt "/full/path/to/doc/mydoc.pdf" 99
