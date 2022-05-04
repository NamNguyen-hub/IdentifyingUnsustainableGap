# Decomposition Codes
## 1. Load library ----
rm(list=ls())

library(mFilter)
library(xts)
library(tsbox) # Convert time series types

library(neverhpfilter)  #Hamilton filter

library(smooth) # MA forecast
library(Mcomp)
library(dplyr)
## BN decomposition filter
# library(devtools)
# devtools::install_github("KevinKotze/tsm")
library(tsm)
library(zoo)
library(dplyr)
library(plm)
## 
library(forecast)
library(vars)
library(tseries)


## 2. Load data
## Set working directory
library('rstudioapi')
setwd(dirname(getActiveDocumentContext()$path))
getwd()


# Window of sample data
enddate ='2017-10-01'

# Importing file

filepath = "../Data/input/credit_fullsample.csv"
df0 <- read.csv(filepath, header=TRUE, sep=",")
df0$date <- as.Date(df0$date)
dropList <- c("IE","LU","NZ","XM")
df0<-df0 <- df0[, !colnames(df0) %in% dropList] 


#df1 = subset(df0, date >= as.Date('1985-01-01')) 
#dropList <- names(which(colSums(is.na(df1))>0))
#df0 <- df0[, !colnames(df0) %in% dropList] #drop countries without data before 1985
countrylist <- names(df0)
countrylist <- countrylist[-which(countrylist == "date")]

burn=4*15


## Set up data frame for first country
country="AR"
df1<- df0[c(country,"date")]
df1<-na.omit(df1)
matID <- as.matrix(rep(country, nrow(df1)))
df1= cbind(df1,matID)
names(df1)[length(names(df1))] <- "ID"
names(df1)[1]<-"credit"
### Create 14 lags 
#df1$credit<-ts(df1$credit)
df1 <- pdata.frame(df1, index=c("ID","date"))
df1$creditL13<-plm::lag(df1$credit,k=13L)
df1$creditL14<-plm::lag(df1$credit,k=14L)
df1$creditL15<-plm::lag(df1$credit,k=15L)
df1$creditL16<-plm::lag(df1$credit,k=16L)

df1$creditL20<-plm::lag(df1$credit,k=20L)
df1$creditL21<-plm::lag(df1$credit,k=21L)
df1$creditL22<-plm::lag(df1$credit,k=22L)
df1$creditL23<-plm::lag(df1$credit,k=23L)
df1$creditL24<-plm::lag(df1$credit,k=24L)
df1$creditL25<-plm::lag(df1$credit,k=25L)
df1$creditL26<-plm::lag(df1$credit,k=26L)
df1$creditL27<-plm::lag(df1$credit,k=27L)
df1$creditL28<-plm::lag(df1$credit,k=28L)
df1$creditL29<-plm::lag(df1$credit,k=29L)

df<-df1

## Merge other country into the dataframe
for(i in 2:length(countrylist)){
  country = countrylist[i]
  
  df1<- df0[c(country,"date")]
  df1<-na.omit(df1)
  matID <- as.matrix(rep(country, nrow(df1)))
  df1= cbind(df1,matID)
  names(df1)[length(names(df1))] <- "ID"
  names(df1)[1]<-"credit"
  ### Create 14 lags 
  df1 <- pdata.frame(df1, index=c("ID","date"))
  df1$creditL13<-plm::lag(df1$credit,k=13L)
  df1$creditL14<-plm::lag(df1$credit,k=14L)
  df1$creditL15<-plm::lag(df1$credit,k=15L)
  df1$creditL16<-plm::lag(df1$credit,k=16L)
  
  df1$creditL20<-plm::lag(df1$credit,k=20L)
  df1$creditL21<-plm::lag(df1$credit,k=21L)
  df1$creditL22<-plm::lag(df1$credit,k=22L)
  df1$creditL23<-plm::lag(df1$credit,k=23L)
  df1$creditL24<-plm::lag(df1$credit,k=24L)
  df1$creditL25<-plm::lag(df1$credit,k=25L)
  df1$creditL26<-plm::lag(df1$credit,k=26L)
  df1$creditL27<-plm::lag(df1$credit,k=27L)
  df1$creditL28<-plm::lag(df1$credit,k=28L)
  df1$creditL29<-plm::lag(df1$credit,k=29L)
  
  df<-rbind(df,df1)
}


df<-as.data.frame(df)
hamilton_13 <- plm(credit ~ creditL13 + creditL14 + creditL15 + creditL16,
          data = df, index = c("ID","date"), model = "within", effect="individual")
summary(hamilton_13)
df.h13 <- df[,c("ID","date","credit","creditL13","creditL14","creditL15","creditL16")]
df.h13 <- na.omit(df.h13)
df.h13 <- cbind(df.h13,hamilton_13$residuals)
names(df.h13)[length(names(df.h13))] <- "c.hamilton13_panel"
#fixef(hamilton_13)  #show coefficient for each country level intercept
#https://stats.stackexchange.com/questions/538847/finding-intercept-term-in-fixed-effects-model
#row.names(df.h13)  #NULL reset row number
df.h13<-df.h13[c("ID","date","c.hamilton13_panel")]


#df<-as.data.frame(df)
hamilton_20 <- plm(credit ~ creditL20 + creditL21 + creditL22 + creditL23,
                   data = df, index = c("ID","date"), model = "within", effect="individual")
summary(hamilton_20)
df.h20 <- df[,c("ID","date","credit","creditL20","creditL21","creditL22","creditL23")]
df.h20 <- na.omit(df.h20)
df.h20 <- cbind(df.h20,hamilton_20$residuals)
names(df.h20)[length(names(df.h20))] <- "c.hamilton20_panel"
df.h20<-df.h20[c("ID","date","c.hamilton20_panel")]


hamilton_24 <- plm(credit ~ creditL24 + creditL25 + creditL26 + creditL27,
                   data = df, index = c("ID","date"), model = "within", effect="individual")
summary(hamilton_24)
df.h24 <- df[,c("ID","date","credit","creditL24","creditL25","creditL26","creditL27")]
df.h24 <- na.omit(df.h24)
df.h24 <- cbind(df.h24,hamilton_24$residuals)
names(df.h24)[length(names(df.h24))] <- "c.hamilton24_panel"
df.h24<-df.h24[c("ID","date","c.hamilton24_panel")]

hamilton_28 <- plm(credit ~ creditL28 + creditL29,
                   data = df, index = c("ID","date"), model = "within", effect="individual")
summary(hamilton_28)
df.h28 <- df[,c("ID","date","credit","creditL28","creditL29")]
df.h28 <- na.omit(df.h28)
df.h28 <- cbind(df.h28,hamilton_28$residuals)
names(df.h28)[length(names(df.h28))] <- "c.hamilton28_panel"
df.h28<-df.h28[c("ID","date","c.hamilton28_panel")]


## Merge all 4 data frames
df2 <- merge(df.h13, df.h20, by=c("ID","date"), all=TRUE)
df2 <- merge(df2, df.h24, by=c("ID","date"), all=TRUE)
df2 <- merge(df2, df.h28, by=c("ID","date"), all=TRUE)

filepath = sprintf('../Data/Processed/GeneratedCycles_hamiltonpanel.csv')
write.table(df2, filepath, sep=',' , row.names = FALSE)