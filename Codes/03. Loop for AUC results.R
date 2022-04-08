rm(list=ls())

## Library
library(reshape2)
library(dplyr)
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))
library(readxl)
library('RStata')
options("RStata.StataPath" = "\"C:\\Program Files\\Stata16\\StataMP-64\"")
options("RStata.StataVersion" = 16)

## Set up
startdate="2000-01-01"
enddate="2017-10-01"

## Stata command
stata_src = "
xtset id date
rocreg crisis credit_gap, cluster(id)

estat nproc, auc
matrix A = r(b)'
matrix B = r(V)'
matrix C = r(ci_bc)'
putexcel set myresults, replace
putexcel A1 = matrix(A)
putexcel B1 = matrix(B)
putexcel C1 = matrix(C)
"

tabresults0 = matrix(NA, 4, 12)
tabresults14 = matrix(NA, 4, 12)
tabresults1 = matrix(NA, 4, 12)
tabresults2 = matrix(NA, 4, 12)
tabresults3 = matrix(NA, 4, 12)
tabresults4 = matrix(NA, 4, 12)


## BIS credit
### Import data
#### Credit gap data
df1 <- read.table("../Data/Input/credit_gap.csv", header=TRUE, sep=",")
df1$date<-as.Date(df1$date)
names(df1)    
df1 = subset(df1, date>= as.Date(startdate) & date<=as.Date(enddate)) 
df1 <- melt(df1, id=c("date"))
names(df1)<- c("date","id","credit_gap")


for (h in 1:12){
  # Import crisis data
  filepath = sprintf("../data/Input/crisis_h%s.csv", h)
  df2 <- read.table(filepath, header=TRUE, sep=",")
  df2$date <- as.Date(df2$date)
  df2 = subset(df2, date>= as.Date(startdate) & date<=as.Date(enddate)) 
  df2 <- melt(df2, id=c("date"))
  names(df2)<- c("date","id","crisis")
  #Merge Data
  df <- merge(df1, df2, by=c("id","date"), all=TRUE)
  #Call Stata regression
  stata(stata_src, data.in=df)
  x <- read_xlsx("myresults.xlsx", col_names=FALSE)
  tabresults0[,h]=t(x)
  print(h)
}


## Combined gap results 1
df1 <- read.table("../Data/Input/credit_gap_combined1.csv", header=TRUE, sep=",")
df1$date<-as.Date(df1$date)
names(df1)    
df1 = subset(df1, date>= as.Date(startdate) & date<=as.Date(enddate)) 
df1 <- melt(df1, id=c("date"))
names(df1)<- c("date","id","credit_gap")
for (h in 1:12){
  # Import crisis data
  filepath = sprintf("../data/Input/crisis_h%s.csv", h)
  df2 <- read.table(filepath, header=TRUE, sep=",")
  df2$date <- as.Date(df2$date)
  df2 = subset(df2, date>= as.Date(startdate) & date<=as.Date(enddate)) 
  df2 <- melt(df2, id=c("date"))
  names(df2)<- c("date","id","crisis")
  #Merge Data
  df <- merge(df1, df2, by=c("id","date"), all=TRUE)
  #Call Stata regression
  stata(stata_src, data.in=df)
  x <- read_xlsx("myresults.xlsx", col_names=FALSE)
  tabresults1[,h]=t(x)
  print(h)
}

## Combined gap results 2
df1 <- read.table("../Data/Input/credit_gap_combined2.csv", header=TRUE, sep=",")
df1$date<-as.Date(df1$date)
names(df1)    
df1 = subset(df1, date>= as.Date(startdate) & date<=as.Date(enddate)) 
df1 <- melt(df1, id=c("date"))
names(df1)<- c("date","id","credit_gap")
for (h in 1:12){
  # Import crisis data
  filepath = sprintf("../data/Input/crisis_h%s.csv", h)
  df2 <- read.table(filepath, header=TRUE, sep=",")
  df2$date <- as.Date(df2$date)
  df2 = subset(df2, date>= as.Date(startdate) & date<=as.Date(enddate)) 
  df2 <- melt(df2, id=c("date"))
  names(df2)<- c("date","id","crisis")
  #Merge Data
  df <- merge(df1, df2, by=c("id","date"), all=TRUE)
  #Call Stata regression
  stata(stata_src, data.in=df)
  x <- read_xlsx("myresults.xlsx", col_names=FALSE)
  tabresults2[,h]=t(x)
  print(h)
}

## Combined gap results 3
df1 <- read.table("../Data/Input/credit_gap_combined3.csv", header=TRUE, sep=",")
df1$date<-as.Date(df1$date)
names(df1)    
df1 = subset(df1, date>= as.Date(startdate) & date<=as.Date(enddate)) 
df1 <- melt(df1, id=c("date"))
names(df1)<- c("date","id","credit_gap")
for (h in 1:12){
  # Import crisis data
  filepath = sprintf("../data/Input/crisis_h%s.csv", h)
  df2 <- read.table(filepath, header=TRUE, sep=",")
  df2$date <- as.Date(df2$date)
  df2 = subset(df2, date>= as.Date(startdate) & date<=as.Date(enddate)) 
  df2 <- melt(df2, id=c("date"))
  names(df2)<- c("date","id","crisis")
  #Merge Data
  df <- merge(df1, df2, by=c("id","date"), all=TRUE)
  #Call Stata regression
  stata(stata_src, data.in=df)
  x <- read_xlsx("myresults.xlsx", col_names=FALSE)
  tabresults3[,h]=t(x)
  print(h)
}

## Combined gap results 4
df1 <- read.table("../Data/Input/credit_gap_combined4.csv", header=TRUE, sep=",")
df1$date<-as.Date(df1$date)
names(df1)    
df1 = subset(df1, date>= as.Date(startdate) & date<=as.Date(enddate)) 
df1 <- melt(df1, id=c("date"))
names(df1)<- c("date","id","credit_gap")
for (h in 1:12){
  # Import crisis data
  filepath = sprintf("../data/Input/crisis_h%s.csv", h)
  df2 <- read.table(filepath, header=TRUE, sep=",")
  df2$date <- as.Date(df2$date)
  df2 = subset(df2, date>= as.Date(startdate) & date<=as.Date(enddate)) 
  df2 <- melt(df2, id=c("date"))
  names(df2)<- c("date","id","crisis")
  #Merge Data
  df <- merge(df1, df2, by=c("id","date"), all=TRUE)
  #Call Stata regression
  stata(stata_src, data.in=df)
  x <- read_xlsx("myresults.xlsx", col_names=FALSE)
  tabresults4[,h]=t(x)
  print(h)
}

## Combined gap results 14
df1 <- read.table("../Data/Input/credit_gap_combined14.csv", header=TRUE, sep=",")
df1$date<-as.Date(df1$date)
names(df1)    
df1 = subset(df1, date>= as.Date(startdate) & date<=as.Date(enddate)) 
df1 <- melt(df1, id=c("date"))
names(df1)<- c("date","id","credit_gap")
for (h in 1:12){
  # Import crisis data
  filepath = sprintf("../data/Input/crisis_h%s.csv", h)
  df2 <- read.table(filepath, header=TRUE, sep=",")
  df2$date <- as.Date(df2$date)
  df2 = subset(df2, date>= as.Date(startdate) & date<=as.Date(enddate)) 
  df2 <- melt(df2, id=c("date"))
  names(df2)<- c("date","id","crisis")
  #Merge Data
  df <- merge(df1, df2, by=c("id","date"), all=TRUE)
  #Call Stata regression
  stata(stata_src, data.in=df)
  x <- read_xlsx("myresults.xlsx", col_names=FALSE)
  tabresults14[,h]=t(x)
  print(h)
}

## Merge table
tabresults = rbind(tabresults0,tabresults1, tabresults2,tabresults3,tabresults4,tabresults14)

write.table(tabresults0, "../Data/Output/results_2000_BIS.csv", sep=',', row.names=FALSE)
write.table(tabresults1, "../Data/Output/results_2000_1.csv", sep=',', row.names=FALSE)
write.table(tabresults2, "../Data/Output/results_2000_2.csv", sep=',', row.names=FALSE)
write.table(tabresults3, "../Data/Output/results_2000_3.csv", sep=',', row.names=FALSE)
write.table(tabresults4, "../Data/Output/results_2000_4.csv", sep=',', row.names=FALSE)
write.table(tabresults14, "../Data/Output/results_2000_14.csv", sep=',', row.names=FALSE)
write.table(tabresults, "../Data/Output/results_2000_compare.csv", sep=',', row.names=FALSE)
