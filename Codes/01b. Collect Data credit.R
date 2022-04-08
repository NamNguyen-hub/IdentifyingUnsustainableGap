## Set up
rm(list=ls())


#library(DataCombine)
library(reshape2)
library(dplyr)
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))
#library(time)

startdate="1985-01-01"
enddate="2018-10-01"
#Merge Data

df1 <- read.table("../data/Input/credit.csv", header=TRUE, sep=",")
df1$date<-as.Date(df1$date)
min(as.Date((df1$date)))
names(df1)    


## Limit df1 year and countries here
df1 = subset(df1, date>= as.Date(startdate) & date<=as.Date(enddate)) 


