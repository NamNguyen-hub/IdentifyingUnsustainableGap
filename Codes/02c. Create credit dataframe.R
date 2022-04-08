# Decomposition Codes
## 1. Load library ----
rm(list=ls())

library('rstudioapi')
setwd(dirname(getActiveDocumentContext()$path))
getwd()

filepath = "../Data/Processed/countrylist.txt"
countrylist <- read.table(filepath, header=TRUE, sep=",")
countrylist = countrylist[-1,]

startdate="2000-01-01"
#datef = seq(as.Date("2000-01-01"), by="quarter", length.out=nrow(c.df))
#c.df$date = datef
#c.df$date <- as.Date(c.df$date)


country='AR'
df0 = read.table(sprintf("../Data/Processed/GeneratedCycles_%s.csv",country), header=TRUE, sep=",")
df0<-df0[c("combined.cycle","date")]
df0$date <- as.Date(df0$date)
df0<-na.omit(df0)
df0 = subset(df0, date >= as.Date(startdate)) 
names(df0) <- c(country,"date")


for(i in 1:length(countrylist)){
  country = countrylist[i]
  df1 = read.table(sprintf("../Data/Processed/GeneratedCycles_%s.csv",country), header=TRUE, sep=",")
  df1<-df1[c("combined.cycle","date")]
  df1$date <- as.Date(df1$date)
  df1<-na.omit(df1)
  df1 = subset(df1, date >= as.Date(startdate)) 
  names(df1) <- c(country,"date")
  df0 <- merge(df0, df1, by=c("date"), all=TRUE)
}

write.table(df0, "../Data/input/credit_gap_combined14.csv", sep=',', row.names=FALSE)

for (y in 1:4){
  country='AR'
  df0 = read.table(sprintf("../Data/Processed/GeneratedCycles_%s.csv",country), header=TRUE, sep=",")
  cyclevar = sprintf("combined.cycle%s",y)
  df0<-df0[c(cyclevar,"date")]
  df0$date <- as.Date(df0$date)
  df0<-na.omit(df0)
  df0 = subset(df0, date >= as.Date(startdate)) 
  names(df0) <- c(country,"date")
  
  
  for(i in 1:length(countrylist)){
    country = countrylist[i]
    df1 = read.table(sprintf("../Data/Processed/GeneratedCycles_%s.csv",country), header=TRUE, sep=",")
    df1<-df1[c(cyclevar,"date")]
    df1$date <- as.Date(df1$date)
    df1<-na.omit(df1)
    df1 = subset(df1, date >= as.Date(startdate)) 
    names(df1) <- c(country,"date")
    df0 <- merge(df0, df1, by=c("date"), all=TRUE)
  }
  
  filepath = sprintf("../Data/input/credit_gap_combined%s.csv", y)
  write.table(df0, filepath, sep=',', row.names=FALSE)
  
}

## Melt df
df0 <- melt(df0, id=c("date"))
names(df0)<- c("date","id","credit_gap")


df2 <- read.table("../data/Input/crisis_h8.csv", header=TRUE, sep=",")
df2$date <- as.Date(df2$date)
df2 = subset(df2, date >= as.Date(startdate)) 
df2 <- melt(df2, id=c("date"))
names(df2)<- c("date","id","crisis")

## Merge with crisis data
df <- merge(df0, df2, by=c("id","date"), all=TRUE)
df$date<-as.Date(df$date)
dfh2<- df %>%
  group_by(id) %>%
  #mutate(gap= dplyr::lag(credit_gap, n=2)) #%>%
  na.omit()

## ready for regression