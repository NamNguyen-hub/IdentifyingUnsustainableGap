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



## BMA


df1 <- read.table("../Data/Input/credit_gaps_allcountry.csv", header=TRUE, sep=",")
df1$date<-as.Date(df1$date)
names(df1)    
df1 = subset(df1, date>= as.Date(startdate) & date<=as.Date(enddate)) 
varlist = colnames(df1)
varlist = varlist[-c((length(varlist)-6):(length(varlist)-2))]
df1=df1[varlist]

#df1 <- melt(df1, id=c("date"))
#names(df1)<- c("date","id","credit_gap")

  h=8
  # Import crisis data
  filepath = sprintf("../data/Input/crisis_h%s.csv", h)
  df2 <- read.table(filepath, header=TRUE, sep=",")
  df2$date <- as.Date(df2$date)
  df2 = subset(df2, date>= as.Date(startdate) & date<=as.Date(enddate)) 
  df2 <- melt(df2, id=c("date"))
  names(df2)<- c("date","ID","crisis")
  #Merge Data
  df <- merge(df1, df2, by=c("ID","date"), all=TRUE)
  df <- na.omit(df)
  
#Call BMA
y= as.factor(df$crisis)
x=df[colnames(df)[-c(1:2, ncol(df))]]
#x<-x[,-which(names(x) == "combined.cycle")]
library(BMA)
glm.out.FT<-bic.glm(x, y, strict = TRUE, OR=20, 
              glm.family="binomial", factor.type=FALSE)
summary(glm.out.FT)
imageplot.bma(glm.out.FT)

## Calculate weight
# !!!!Coefficient weight does not work
# glm.out.FT$bic
# glm.out.FT$postmean[-1]
# avgweight=matrix(0,1,8)
# coefsum = sum(glm.out.FT$postmean[-1])
## Compute Averaged cycle
# avgweight=as.matrix(glm.out.FT$postmean[-1]/coefsum)
# avgcycle=rowSums(df[,3:10]*avgweight)
## Calculate weight

## Compute Averaged cycle
glm.out.FT$size
w_bic=glm.out.FT$bic*glm.out.FT$size
bicweight=matrix(0,1,length(glm.out.FT$bic))
bicsum=sum(exp(-1/(2*1000)*w_bic))
bicweight=as.matrix(exp(-1/(2*1000)*w_bic)/bicsum)
#avgweight=matrix(0,length(glm.out.FT$bic),8)
glm.out.FT$mle[-1]

yhat=-4.720+x$BN*0.19
yhat2=1/(1+exp(-yhat))
plot(exp(yhat))
plot(x$BN,exp(yhat))
plot(x$BN,yhat2))

plot(x$BN,(as.numeric(y)-1))


xBN = (yhat-(-4.720))/0.19

thetaest=glm.out.FT$postmean
thetaest=thetaest[-1]
#thetaest=thetaest[which(thetaest!=0)]

thetaest=sum(thetaest)

#mean(na.omit(thetaest))

xhat=as.matrix(cbind(matrix(1,nrow(x),1),x))
thetahat=as.matrix(glm.out.FT$postmean)
yhat=xhat%*%thetahat
chat=(yhat-glm.out.FT$postmean[1])/thetaest
plot(chat,exp(yhat))

x1=cbind(x,chat)
## 0.19 is the weighted theta
xBN = (yhat-(-4.720))/0.19


h=8
# Import crisis data
filepath = sprintf("../data/Input/crisis_h%s.csv", h)
df2 <- read.table(filepath, header=TRUE, sep=",")
df2$date <- as.Date(df2$date)
df2 = subset(df2, date>= as.Date(startdate) & date<=as.Date(enddate)) 
df2 <- melt(df2, id=c("date"))
names(df2)<- c("date","ID","crisis")
#Merge Data
df <- merge(df1, df2, by=c("ID","date"), all=TRUE)
df <- na.omit(df)
df<- cbind(df,avgcycle)

#Call BMA
y= as.factor(df$crisis)
x=df[colnames(df)[-c(1:2, (ncol(df)-1))]]
#x<-x[,-which(names(x) == "combined.cycle")]
library(BMA)
glm.out.FT<-bic.glm(x, y, strict = TRUE, OR=20, 
                    glm.family="binomial", factor.type=FALSE)
summary(glm.out.FT)


imageplot.bma(glm.out.FT)

glm.out.FT<-bic.glm(chat, y, strict = TRUE, OR=20, 
                    glm.family="binomial", factor.type=FALSE)
summary(glm.out.FT)


imageplot.bma(glm.out.FT)