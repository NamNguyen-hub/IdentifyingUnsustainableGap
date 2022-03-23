## Set up
rm(list=ls())


#library(DataCombine)
library(reshape2)
library(dplyr)
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))

startdate="2000-01-01"
enddate="2017-10-01"
#Merge Data

df1 <- read.table("../data/Input/credit_gap.csv", header=TRUE, sep=",")
df1$date<-as.Date(df1$date)
min(as.Date((df1$date)))
names(df1)    

df2 <- read.table("../data/Input/crisis.csv", header=TRUE, sep=",")
    # df3 <- read.table("HHCredit_GDP_gap.txt", header=TRUE, sep=",")
    # df4 <- read.table("NFECredit_GDP_gap.txt", header=TRUE, sep=",")
    # df5 <- read.table("GDP_gap.txt", header=TRUE, sep=",")
    # df6 <- read.table("HP_inc_gap.txt", header=TRUE, sep=",")
names2 <- names(df2)
names2
## Limit df1 year and countries here
Reduce(intersect, list(names(df1),names(df2)))
df1 = subset(df1, date>= as.Date(startdate) & date<=as.Date(enddate)) 
df1 <- df1[names2]


df1 <- melt(df1, id=c("date"))
names(df1)<- c("date","id","credit_gap")
    
    
## Limit df2 year and countries here
df2 = subset(df2, date >= as.Date(startdate)) 
df2 <- melt(df2, id=c("date"))
names(df2)<- c("date","id","crisis")

# Merge the two df by ID and date
df <- merge(df1, df2, by=c("id","date"), all=TRUE)

# pglm Panel probit regression

library(pglm)
model1 <- pglm(crisis ~ credit_gap, df, family = "binomial",
                           model = "random", method = "bfgs")

    # View(df)
    # df <- merge(df2, df3, by=c("ID","date"), all.x=TRUE)
    # df <- merge(df, df4, by=c("ID","date"), all.x=TRUE)
    # df <- merge(df, df5, by=c("ID","date"), all.x=TRUE)
    # df <- merge(df, df6, by=c("ID","date"), all.x=TRUE)
    # df <- merge(df, df1, by=c("ID","date"), all.x=TRUE)
    # 
    # write.table(df, "MergedData-Raw.txt", sep=",")
    # 
    # #Read raw data
    # df1 <- read.table("MergedData-Raw.txt", header=TRUE, sep=",")
    # 
    # df1 <- na.omit(df) 
    # 
    # #table(df1$date)
    # #df2 <- df1["date">="1999-01-01"]
    # 
    # #Reorder data
    # df1 <- df1[order(df1$ID, df1$date),]
    # 
    # df1<-na.omit(df1)