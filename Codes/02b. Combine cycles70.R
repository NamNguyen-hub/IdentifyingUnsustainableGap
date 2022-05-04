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

## 
library(forecast)
library(vars)
library(tseries)


## 2. Load data
## Set working directory
library('rstudioapi')
setwd(dirname(getActiveDocumentContext()$path))
getwd()

## One sided HP filter function / STM function
source("HPfilters/OneSidedHPfilterfunc.R")
source("HPfilters/OneSidedSTMfilterfunc.R")


# Window of sample data
enddate ='2017-10-01'

# Importing file

filepath = "../Data/input/credit_fullsample.csv"
df0 <- read.csv(filepath, header=TRUE, sep=",")
df0$date <- as.Date(df0$date)


df1 = subset(df0, date >= as.Date('1985-01-01')) 
dropList <- names(which(colSums(is.na(df1))>0))
df0 <- df0[, !colnames(df0) %in% dropList] #drop countries without data before 1985
countrylist <- names(df0)
countrylist <- countrylist[-which(countrylist == "date")]

for(i in 1:length(countrylist)){
  country = countrylist[i]

df <- df0[c('date',country)]
names(df) <- c('date','credit')
df<-na.omit(df)
df1<-df
df1 = subset(df1, date <= as.Date(enddate)) # Limit series data to before 2018
startdate<-df1$date[1] #Start date of available data
credit0<-df1$credit

credit0 <- xts(df1[,-c(1)], order.by=as.Date(df1[,"date"], "%Y-%m-%d"))
credit1 <- ts_ts(credit0)
c.hp=filterHP(credit1)[,"cycle"]
c.hp3k=filterHP(credit1, lambda=3000)[,"cycle"]
c.hp25k=filterHP(credit1, lambda=25000)[,"cycle"]
c.hp125k=filterHP(credit1, lambda=125000)[,"cycle"]
c.hp221k=filterHP(credit1, lambda=221000)[,"cycle"]
c.hp400k=filterHP(credit1, lambda=400000)[,"cycle"]

#x<-list(c.hp,c.hp3k,c.hp25k,c.hp125k,c.hp221k,c.hp400k)

burn=15*4 #15 yrs|60 periods before created cycles are stored
t=nrow(df1)-burn  
y=nrow(df1)
#! add check if t is positive - for countries with shorter than 15 periods
  
# store of 1 sided cycle decomp
  c.linear2=rep(0,t)
  c.quad2=rep(0,t)
  c.poly3=rep(0,t)
  c.poly4=rep(0,t)
  c.poly5=rep(0,t)
  c.poly6=rep(0,t)
#  c.bn1=rep(0,t)
  c.bn2=rep(0,t)
  c.bn3=rep(0,t)
  c.bn4=rep(0,t)
  c.hamilton28t1=rep(0,t)
  c.hamilton24t1=rep(0,t)
  c.hamilton20t1=rep(0,t)
  c.hamilton13t1=rep(0,t)
  
  
for(i in 1:t){
  credit = ts(credit1[1:(i+burn)])
    credit_xts = ts_xts(credit)
    
   c.hamilton28t <- yth_filter(credit_xts, h = 28, p = 2)$value.cycle # Drehman
   c.hamilton24t <- yth_filter(credit_xts, h = 24, p = 4)$value.cycle # Hamilton filter
   c.hamilton20t <- yth_filter(credit_xts, h = 20, p = 4)$value.cycle # author recommendation
   c.hamilton13t <- yth_filter(credit_xts, h = 13, p = 4)$value.cycle # Beltran
   c.hamilton28t1[i]=c.hamilton28t[i+burn]
   c.hamilton24t1[i]=c.hamilton24t[i+burn]
   c.hamilton20t1[i]=c.hamilton20t[i+burn]
   c.hamilton13t1[i]=c.hamilton13t[i+burn]
    # credit.bw <- bwfilter(credit1, drift=FALSE)  # Butterworth filter
    credit.linear <- tslm(credit ~ trend) # Linear trend decomp
    c.linear <- credit - fitted(credit.linear)
    c.linear2[1+i-1]=c.linear[i]
    
    credit.quad <- tslm(credit ~ trend + I(trend^2)) # Quadratic trend decomp
    c.quad <- credit - fitted(credit.quad)
    c.quad2[1+i-1]=c.quad[i+burn]

    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly3[1+i-1]=c.poly[i+burn]

    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)
                                   + I(trend^4)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly4[1+i-1]=c.poly[i+burn]

    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)
                        + I(trend^4) + I(trend^5)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly5[1+i-1]=c.poly[i+burn]

    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)
                        + I(trend^4) + I(trend^5) + I(trend^6)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly6[1+i-1]=c.poly[i+burn]

    bn.decomp <- bnd(credit, nlag = 2) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn2[1+i-1]=c.bn[i+burn]

    bn.decomp <- bnd(credit, nlag = 3) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn3[1+i-1]=c.bn[i+burn]

    bn.decomp <- bnd(credit, nlag = 4) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn4[1+i-1]=c.bn[i+burn]
}
  
  c.ma1 = rep(0,t)
  c.ma = rep(0,t+burn)
  q=16
  ## Moving average decomp
  for(i in q:(t+burn)){
    credit = ts(credit1[1:i])
    c.ma[i]= credit[i]-(sum(credit[(i-q+1):i]))/q
  }
  
  c.ma1[1:t]= c.ma[(burn+1):(t+burn)]
  
  
  ## Bayesian STM
  ### dlm package
  c.stm<- filterSTM(credit1)[,"cycle"]
  #plot(c.stm)
  c.stm1<-c.stm[(burn+1):(burn+t)]
  
  c.hp1=c.hp[(burn+1):y]
  c.hp3k1=c.hp3k[(burn+1):y]
  c.hp25k1=c.hp25k[(burn+1):y]
  c.hp125k1=c.hp125k[(burn+1):y]
  c.hp221k1=c.hp221k[(burn+1):y]
  c.hp400k1=c.hp400k[(burn+1):y]
  

  
  #cbind all series
  x<- cbind(c.hp1,c.hp3k1,c.hp25k1,c.hp125k1,c.hp221k1,c.hp400k1,
            c.hamilton13t1, c.hamilton20t1, c.hamilton24t1, c.hamilton28t1,
            c.linear2,c.quad2,c.poly3,c.poly4,c.poly5,c.poly6,
            c.bn2, c.bn3, c.bn4, c.stm1, c.ma1)
  #append date column
  date<-subset(df1, date>=as.Date(as.yearqtr(startdate)+burn/4))
  date<-as.data.frame(date$date)
  names(date)<-"date"
  x<-cbind(date,x)
  x$date<-as.Date(x$date)
  x<-subset(x, date>as.Date(as.yearqtr(startdate)+burn/4))
  
  
  filepath = sprintf('../Data/Processed/GeneratedCycles_%s.csv',country)
  write.table(x, filepath, sep=',' , row.names = FALSE)
}

  #x=list(c.hp1,c.hp3k1,c.hp400k1,c.uc1,c.hamilton2, c.linear2 , c.quad2, c.bn2)
  # x<-lapply(x, function(x) x=x[1:(n.end+i-1)])
  #x<-lapply(x, ts, start=startdate_diff, frequency=4)
  
  # c.hp=x[1][[1]]
  # c.hp3k=x[2][[1]]
  # c.hp400k=x[3][[1]]
  # c.uc=x[4][[1]]
  # c.hamilton = x[5][[1]]
  # c.linear = x[6][[1]]
  # c.quad = x[7][[1]]
  # c.bn = x[8][[1]]
  
  
  ## Save data into csv file
#   

  #   filepath = sprintf('../Data/Processed/GeneratedCycles_%s.csv',country)
  #   c.df$HP<-c.hp
  #   c.df$HP3k<-c.hp3k
  #   c.df$HP400k<-c.hp400k
  #   c.df$Hamilton<-c.hamilton
  #   c.df$linear<-c.linear
  #   c.df$quad<-c.quad
  #   c.df$BN<-c.bn
  #   c.df$UC<-c.uc
  #   write.table(c.df, filepath, sep=',' , row.names = FALSE)
  
  
#   #write.table append
#   if (country=="AR"){
#     write.table(df_rmse1, "../Data/Processed/RMSE_fullsample.csv", sep=',', row.names=FALSE)
#   }else {
#     write.table(df_rmse1, "../Data/Processed/RMSE_fullsample.csv", sep=',', append=TRUE, row.names=FALSE, col.names = FALSE)
#   }
# }
  
  