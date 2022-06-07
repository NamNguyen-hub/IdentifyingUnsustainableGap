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

filepath = "../Data/input/credit_fullsample.csv"
df0 <- read.csv(filepath, header=TRUE, sep=",")
df0$date <- as.Date(df0$date)

# Window of sample data
enddate =max(df0$date)
crisisdatadate=as.Date('2017-10-01')

df1 = subset(df0, date >= as.Date(as.yearqtr(crisisdatadate)-18)) 
dropList <- names(which(colSums(is.na(df1))>0))
dropList <- c(dropList,"XM")
df0 <- df0[, !colnames(df0) %in% dropList] #drop countries without data before 2000
#2017-(15burn+3yrprecrisis) window
countrylist <- names(df0)
countrylist <- countrylist[-which(countrylist == "date")]

burn=4*15

## Rolling 10 yrs
for(i in 1:length(countrylist)){
  country = countrylist[i]

df <- df0[c('date',country)]
names(df) <- c('date','credit')
df<-na.omit(df)
df1<-df
df1 = subset(df1, date <= as.Date(enddate)) # Limit series data to before 2020
startdate<-df1$date[1]
credit0<-df1$credit


credit0 <- xts(df1[,-c(1)], order.by=as.Date(df1[,"date"], "%Y-%m-%d"))
credit1 <- ts_ts(credit0)

## r = 40, 60 , 80 quarters equals 10, 15 and 20 years respectively
y=nrow(df1)
r=40
k=y-r+1

#burn=15*4 #15 yrs|60 periods before created cycles are stored

c.linear10=rep(0,y)
c.quad10=rep(0,y)
c.poly310=rep(0,y)
c.poly410=rep(0,y)
c.poly510=rep(0,y)
c.poly610=rep(0,y)
c.bn110=rep(0,y)
c.bn210=rep(0,y)
c.bn310=rep(0,y)
c.bn410=rep(0,y)
c.bn510=rep(0,y)
c.bn610=rep(0,y)
c.bn710=rep(0,y)
c.bn810=rep(0,y)

c.hp10=rep(0,y)
c.hp3k10=rep(0,y)
c.hp25k10=rep(0,y)
c.hp125k10=rep(0,y)
c.hp221k10=rep(0,y)
c.hp400k10=rep(0,y)
c.ma = rep(0,y)
c.ma10 = rep(0,y)
c.stm10 = rep(0,y)

c.hamilton28t10 = rep(0,y)
c.hamilton24t10 = rep(0,y)
c.hamilton20t10 = rep(0,y)
c.hamilton13t10 = rep(0,y)

## Start rolling sample
for(j in 1:k){
  
credit = credit1[(j):(j-1+r)]
credit = ts(credit)
  
c.hp=filterHP(credit)[,"cycle"]
c.hp3k=filterHP(credit, lambda=3000)[,"cycle"]
c.hp25k=filterHP(credit, lambda=25000)[,"cycle"]
c.hp125k=filterHP(credit, lambda=125000)[,"cycle"]
c.hp221k=filterHP(credit, lambda=221000)[,"cycle"]
c.hp400k=filterHP(credit, lambda=400000)[,"cycle"]
#Save cycles value at the end of rolling sample periods
c.hp10[j+r-1]=c.hp[r]
c.hp3k10[j+r-1]=c.hp3k[r]
c.hp25k10[j+r-1]=c.hp25k[r]
c.hp125k10[j+r-1]=c.hp125k[r]
c.hp221k10[j+r-1]=c.hp221k[r]
c.hp400k10[j+r-1]=c.hp400k[r]

credit_xts = ts_xts(credit)
    
   c.hamilton28t <- yth_filter(credit_xts, h = 28, p = 2)$value.cycle # Drehman
   c.hamilton24t <- yth_filter(credit_xts, h = 24, p = 4)$value.cycle # Hamilton filter
   c.hamilton20t <- yth_filter(credit_xts, h = 20, p = 4)$value.cycle # author recommendation
   c.hamilton13t <- yth_filter(credit_xts, h = 13, p = 4)$value.cycle # Beltran
   c.hamilton28t10[j+r-1]=c.hamilton28t[r]
   c.hamilton24t10[j+r-1]=c.hamilton24t[r]
   c.hamilton20t10[j+r-1]=c.hamilton20t[r]
   c.hamilton13t10[j+r-1]=c.hamilton13t[r]
    credit.linear <- tslm(credit ~ trend) # Linear trend decomp
    c.linear <- credit - fitted(credit.linear)
    c.linear10[j+r-1]=c.linear[r]
    
    credit.quad <- tslm(credit ~ trend + I(trend^2)) # Quadratic trend decomp
    c.quad <- credit - fitted(credit.quad)
    c.quad10[j+r-1]=c.quad[r]

    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly310[j+r-1]=c.poly[r]

    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)
                                   + I(trend^4)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly410[j+r-1]=c.poly[r]

    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)
                        + I(trend^4) + I(trend^5)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly510[j+r-1]=c.poly[r]

    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)
                        + I(trend^4) + I(trend^5) + I(trend^6)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly610[j+r-1]=c.poly[r]

    bn.decomp <- bnd(credit, nlag = 2) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn210[j+r-1]=c.bn[r]

    bn.decomp <- bnd(credit, nlag = 3) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn310[j+r-1]=c.bn[r]

    bn.decomp <- bnd(credit, nlag = 4) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn410[j+r-1]=c.bn[r]

    bn.decomp <- bnd(credit, nlag = 5) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn510[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 6) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn610[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 7) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn710[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 8) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn810[j+r-1]=c.bn[r]
  

  q=16
  ## Moving average decomp
  for(i in q:r){
    credit2 = ts(credit[1:i])
    c.ma[i+j-1]= credit2[i]-(sum(credit2[(i-q+1):i]))/q
  }
  c.ma1<-c.ma[j:(j+r-1)]
  c.ma10[j+r-1]=c.ma1[r]
  
  ## Bayesian STM
  c.stm<- filterSTM(credit)[,"cycle"]
  #plot(c.stm)
  c.stm10[j+r-1]<-c.stm[r]
} 
  
x<- cbind(c.hp10,c.hp3k10,c.hp25k10,c.hp125k10,c.hp221k10,c.hp400k10,
          c.hamilton13t10, c.hamilton20t10, c.hamilton24t10, c.hamilton28t10,
          c.linear10,c.quad10,c.poly310,c.poly410,c.poly510,c.poly610,
          c.bn210, c.bn310, c.bn410, c.bn510, c.bn610, c.bn710, c.bn810, c.stm10)
colnames(x)<- c("c.hp_r10","c.hp3k_r10","c.hp25k_r10","c.hp125k_r10","c.hp221k_r10","c.hp400k_r10",
          "c.hamilton13_r10","c.hamilton20_r10","c.hamilton24_r10","c.hamilton28_r10",
          "c.linear_r10","c.quad_r10","c.poly3_r10","c.poly4_r10","c.poly5_r10","c.poly6_r10",
          "c.bn2_r10","c.bn3_r10","c.bn4_r10","c.bn5_r10","c.bn6_r10","c.bn7_r10","c.bn8_r10","c.stm_r10")
x<- cbind(as.data.frame(df1$date), x)
colnames(x)[1]<-"date"
x<-subset(x, date>=as.Date(as.yearqtr(startdate)+burn/4))

## Save data
filepath = sprintf('../Data/Processed/GeneratedCycles_rolling10yrs_%s.csv',country)
write.table(x, filepath, sep=',' , row.names = FALSE)
}


## Rolling 15 yrs
for(i in 1:length(countrylist)){
  country = countrylist[i]
  
  df <- df0[c('date',country)]
  names(df) <- c('date','credit')
  df<-na.omit(df)
  df1<-df
  df1 = subset(df1, date <= as.Date(enddate)) # Limit series data to before 2020
  startdate<-df1$date[1]
  credit0<-df1$credit
  
  
  credit0 <- xts(df1[,-c(1)], order.by=as.Date(df1[,"date"], "%Y-%m-%d"))
  credit1 <- ts_ts(credit0)
  
  ## r = 40, 60 , 80 quarters equals 10, 15 and 20 years respectively
  y=nrow(df1)
  r=60
  k=y-r+1
  
  #burn=15*4 #15 yrs|60 periods before created cycles are stored
  
  c.linear10=rep(0,y)
  c.quad10=rep(0,y)
  c.poly310=rep(0,y)
  c.poly410=rep(0,y)
  c.poly510=rep(0,y)
  c.poly610=rep(0,y)
  c.bn110=rep(0,y)
  c.bn210=rep(0,y)
  c.bn310=rep(0,y)
  c.bn410=rep(0,y)
  c.bn410=rep(0,y)
  c.bn510=rep(0,y)
  c.bn610=rep(0,y)
  c.bn710=rep(0,y)
  c.bn810=rep(0,y)
  
  c.hp10=rep(0,y)
  c.hp3k10=rep(0,y)
  c.hp25k10=rep(0,y)
  c.hp125k10=rep(0,y)
  c.hp221k10=rep(0,y)
  c.hp400k10=rep(0,y)
  c.ma = rep(0,y)
  c.ma10 = rep(0,y)
  c.stm10 = rep(0,y)
  
  c.hamilton28t10 = rep(0,y)
  c.hamilton24t10 = rep(0,y)
  c.hamilton20t10 = rep(0,y)
  c.hamilton13t10 = rep(0,y)
  
  ## Start rolling sample
  for(j in 1:k){
    
    credit = credit1[(j):(j-1+r)]
    credit = ts(credit)
    
    c.hp=filterHP(credit)[,"cycle"]
    c.hp3k=filterHP(credit, lambda=3000)[,"cycle"]
    c.hp25k=filterHP(credit, lambda=25000)[,"cycle"]
    c.hp125k=filterHP(credit, lambda=125000)[,"cycle"]
    c.hp221k=filterHP(credit, lambda=221000)[,"cycle"]
    c.hp400k=filterHP(credit, lambda=400000)[,"cycle"]
    #Save cycles value at the end of rolling sample periods
    c.hp10[j+r-1]=c.hp[r]
    c.hp3k10[j+r-1]=c.hp3k[r]
    c.hp25k10[j+r-1]=c.hp25k[r]
    c.hp125k10[j+r-1]=c.hp125k[r]
    c.hp221k10[j+r-1]=c.hp221k[r]
    c.hp400k10[j+r-1]=c.hp400k[r]
    
    credit_xts = ts_xts(credit)
    
    c.hamilton28t <- yth_filter(credit_xts, h = 28, p = 2)$value.cycle # Drehman
    c.hamilton24t <- yth_filter(credit_xts, h = 24, p = 4)$value.cycle # Hamilton filter
    c.hamilton20t <- yth_filter(credit_xts, h = 20, p = 4)$value.cycle # author recommendation
    c.hamilton13t <- yth_filter(credit_xts, h = 13, p = 4)$value.cycle # Beltran
    c.hamilton28t10[j+r-1]=c.hamilton28t[r]
    c.hamilton24t10[j+r-1]=c.hamilton24t[r]
    c.hamilton20t10[j+r-1]=c.hamilton20t[r]
    c.hamilton13t10[j+r-1]=c.hamilton13t[r]
    credit.linear <- tslm(credit ~ trend) # Linear trend decomp
    c.linear <- credit - fitted(credit.linear)
    c.linear10[j+r-1]=c.linear[r]
    
    credit.quad <- tslm(credit ~ trend + I(trend^2)) # Quadratic trend decomp
    c.quad <- credit - fitted(credit.quad)
    c.quad10[j+r-1]=c.quad[r]
    
    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly310[j+r-1]=c.poly[r]
    
    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)
                        + I(trend^4)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly410[j+r-1]=c.poly[r]
    
    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)
                        + I(trend^4) + I(trend^5)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly510[j+r-1]=c.poly[r]
    
    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)
                        + I(trend^4) + I(trend^5) + I(trend^6)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly610[j+r-1]=c.poly[r]
    
    bn.decomp <- bnd(credit, nlag = 2) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn210[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 3) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn310[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 4) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn410[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 5) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn510[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 6) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn610[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 7) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn710[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 8) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn810[j+r-1]=c.bn[r]
    
    
    q=16
    ## Moving average decomp
    for(i in q:r){
      credit2 = ts(credit[1:i])
      c.ma[i+j-1]= credit2[i]-(sum(credit2[(i-q+1):i]))/q
    }
    c.ma1<-c.ma[j:(j+r-1)]
    c.ma10[j+r-1]=c.ma1[r]
    
    ## Bayesian STM
    c.stm<- filterSTM(credit)[,"cycle"]
    #plot(c.stm)
    c.stm10[j+r-1]<-c.stm[r]
  } 
  
  x<- cbind(c.hp10,c.hp3k10,c.hp25k10,c.hp125k10,c.hp221k10,c.hp400k10,
            c.hamilton13t10, c.hamilton20t10, c.hamilton24t10, c.hamilton28t10,
            c.linear10,c.quad10,c.poly310,c.poly410,c.poly510,c.poly610,
            c.bn210, c.bn310, c.bn410, c.bn510, c.bn610, c.bn710, c.bn810, c.stm10)
  colnames(x)<- c("c.hp_r15","c.hp3k_r15","c.hp25k_r15","c.hp125k_r15","c.hp221k_r15","c.hp400k_r15",
                  "c.hamilton13_r15","c.hamilton20_r15","c.hamilton24_r15","c.hamilton28_r15",
                  "c.linear_r15","c.quad_r15","c.poly3_r15","c.poly4_r15","c.poly5_r15","c.poly6_r15",
                  "c.bn2_r15","c.bn3_r15","c.bn4_r15","c.bn5_r15","c.bn6_r15","c.bn7_r15","c.bn8_r15","c.stm_r15")
  
  
  x<- cbind(as.data.frame(df1$date), x)
  colnames(x)[1]<-"date"
  

  x<-subset(x, date>=as.Date(as.yearqtr(startdate)+burn/4))
  
  ## Save data
  filepath = sprintf('../Data/Processed/GeneratedCycles_rolling15yrs_%s.csv',country)
  write.table(x, filepath, sep=',' , row.names = FALSE)
}

## 20 years rolling sample
for(i in 1:length(countrylist)){
  country = countrylist[i]
  
  df <- df0[c('date',country)]
  names(df) <- c('date','credit')
  df<-na.omit(df)
  df1<-df
  df1 = subset(df1, date <= as.Date(enddate)) # Limit series data to before 2020
  startdate<-df1$date[1]
  credit0<-df1$credit
  
  
  credit0 <- xts(df1[,-c(1)], order.by=as.Date(df1[,"date"], "%Y-%m-%d"))
  credit1 <- ts_ts(credit0)
  
  ## r = 40, 60 , 80 quarters equals 10, 15 and 20 years respectively
  y=nrow(df1)
  r=80
  k=y-r+1
  
  #burn=15*4 #15 yrs|60 periods before created cycles are stored
  
  c.linear10=rep(0,y)
  c.quad10=rep(0,y)
  c.poly310=rep(0,y)
  c.poly410=rep(0,y)
  c.poly510=rep(0,y)
  c.poly610=rep(0,y)
  c.bn110=rep(0,y)
  c.bn210=rep(0,y)
  c.bn310=rep(0,y)
  c.bn410=rep(0,y)
  c.bn510=rep(0,y)
  c.bn610=rep(0,y)
  c.bn710=rep(0,y)
  c.bn810=rep(0,y)
  
  c.hp10=rep(0,y)
  c.hp3k10=rep(0,y)
  c.hp25k10=rep(0,y)
  c.hp125k10=rep(0,y)
  c.hp221k10=rep(0,y)
  c.hp400k10=rep(0,y)
  c.ma = rep(0,y)
  c.ma10 = rep(0,y)
  c.stm10 = rep(0,y)
  
  c.hamilton28t10 = rep(0,y)
  c.hamilton24t10 = rep(0,y)
  c.hamilton20t10 = rep(0,y)
  c.hamilton13t10 = rep(0,y)
  
  ## Start rolling sample
  for(j in 1:k){
    
    credit = credit1[(j):(j-1+r)]
    credit = ts(credit)
    
    c.hp=filterHP(credit)[,"cycle"]
    c.hp3k=filterHP(credit, lambda=3000)[,"cycle"]
    c.hp25k=filterHP(credit, lambda=25000)[,"cycle"]
    c.hp125k=filterHP(credit, lambda=125000)[,"cycle"]
    c.hp221k=filterHP(credit, lambda=221000)[,"cycle"]
    c.hp400k=filterHP(credit, lambda=400000)[,"cycle"]
    #Save cycles value at the end of rolling sample periods
    c.hp10[j+r-1]=c.hp[r]
    c.hp3k10[j+r-1]=c.hp3k[r]
    c.hp25k10[j+r-1]=c.hp25k[r]
    c.hp125k10[j+r-1]=c.hp125k[r]
    c.hp221k10[j+r-1]=c.hp221k[r]
    c.hp400k10[j+r-1]=c.hp400k[r]
    
    credit_xts = ts_xts(credit)
    
    c.hamilton28t <- yth_filter(credit_xts, h = 28, p = 2)$value.cycle # Drehman
    c.hamilton24t <- yth_filter(credit_xts, h = 24, p = 4)$value.cycle # Hamilton filter
    c.hamilton20t <- yth_filter(credit_xts, h = 20, p = 4)$value.cycle # author recommendation
    c.hamilton13t <- yth_filter(credit_xts, h = 13, p = 4)$value.cycle # Beltran
    c.hamilton28t10[j+r-1]=c.hamilton28t[r]
    c.hamilton24t10[j+r-1]=c.hamilton24t[r]
    c.hamilton20t10[j+r-1]=c.hamilton20t[r]
    c.hamilton13t10[j+r-1]=c.hamilton13t[r]
    credit.linear <- tslm(credit ~ trend) # Linear trend decomp
    c.linear <- credit - fitted(credit.linear)
    c.linear10[j+r-1]=c.linear[r]
    
    credit.quad <- tslm(credit ~ trend + I(trend^2)) # Quadratic trend decomp
    c.quad <- credit - fitted(credit.quad)
    c.quad10[j+r-1]=c.quad[r]
    
    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly310[j+r-1]=c.poly[r]
    
    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)
                        + I(trend^4)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly410[j+r-1]=c.poly[r]
    
    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)
                        + I(trend^4) + I(trend^5)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly510[j+r-1]=c.poly[r]
    
    credit.poly <- tslm(credit ~ trend + I(trend^2) + I(trend^3)
                        + I(trend^4) + I(trend^5) + I(trend^6)) # Polynomial trend decomp
    c.poly <- credit - fitted(credit.poly)
    c.poly610[j+r-1]=c.poly[r]
    
    bn.decomp <- bnd(credit, nlag = 2) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn210[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 3) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn310[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 4) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn410[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 5) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn510[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 6) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn610[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 7) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn710[j+r-1]=c.bn[r]
    
    bn.decomp <- bnd(credit, nlag = 8) # Beveridge-Nelson decomposition
    c.bn <- ts(bn.decomp[, 2])
    c.bn810[j+r-1]=c.bn[r]
    
    
    q=16
    ## Moving average decomp
    for(i in q:r){
      credit2 = ts(credit[1:i])
      c.ma[i+j-1]= credit2[i]-(sum(credit2[(i-q+1):i]))/q
    }
    c.ma1<-c.ma[j:(j+r-1)]
    c.ma10[j+r-1]=c.ma1[r]
    
    ## Bayesian STM
    c.stm<- filterSTM(credit)[,"cycle"]
    #plot(c.stm)
    c.stm10[j+r-1]<-c.stm[r]
  } 
  
  x<- cbind(c.hp10,c.hp3k10,c.hp25k10,c.hp125k10,c.hp221k10,c.hp400k10,
            c.hamilton13t10, c.hamilton20t10, c.hamilton24t10, c.hamilton28t10,
            c.linear10,c.quad10,c.poly310,c.poly410,c.poly510,c.poly610,
            c.bn210, c.bn310, c.bn410, c.bn510, c.bn610, c.bn710, c.bn810, c.stm10)
  colnames(x)<- c("c.hp_r20","c.hp3k_r20","c.hp25k_r20","c.hp125k_r20","c.hp221k_r20","c.hp400k_r20",
                  "c.hamilton13_r20","c.hamilton20_r20","c.hamilton24_r20","c.hamilton28_r20",
                  "c.linear_r20","c.quad_r20","c.poly3_r20","c.poly4_r20","c.poly5_r20","c.poly6_r20",
                  "c.bn2_r20","c.bn3_r20","c.bn4_r20","c.bn5_r20","c.bn6_r20","c.bn7_r20","c.bn8_r20","c.stm_r20")
  
  x<- cbind(as.data.frame(df1$date), x)
  colnames(x)[1]<-"date"
  x<-subset(x, date>=as.Date(as.yearqtr(startdate)+20))
  

### Import full sample data
  filepath = sprintf('../Data/Processed/GeneratedCycles_%s.csv',country)
  df3 <- read.csv(filepath, header=TRUE, sep=",")
  df3$date <- as.Date(df3$date)
  df3<-df3[-which(names(df3)=="c.ma")]
### Merge  15-20year or 60-80 quarter in full sample with rolling 20 years 
  df3<-df3%>%
    subset(date>=as.Date(as.yearqtr(startdate)+15)) %>%
    subset(date<as.Date(as.yearqtr(startdate)+20))
  colnames(df3)<- c("date","c.hp_r20","c.hp3k_r20","c.hp25k_r20","c.hp125k_r20","c.hp221k_r20","c.hp400k_r20",
                  "c.hamilton13_r20","c.hamilton20_r20","c.hamilton24_r20","c.hamilton28_r20",
                  "c.linear_r20","c.quad_r20","c.poly3_r20","c.poly4_r20","c.poly5_r20","c.poly6_r20",
                  "c.bn2_r20","c.bn3_r20","c.bn4_r20","c.bn5_r20","c.bn6_r20","c.bn7_r20","c.bn8_r20","c.stm_r20")
  
  x= rbind(df3,x)
  
  ## Save data
  filepath = sprintf('../Data/Processed/GeneratedCycles_rolling20yrs_%s.csv',country)
  write.table(x, filepath, sep=',' , row.names = FALSE)
}
