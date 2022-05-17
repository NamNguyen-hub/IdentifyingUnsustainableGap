## Set up
rm(list=ls())


library(mombf)
library(reshape2)
library(dplyr)
library(rstudioapi)
library(BAS)
library(pracma)

setwd(dirname(getActiveDocumentContext()$path))

startdate="1985-01-01"
enddate="2017-10-01"
#Merge Data

## Define countrylist (with credit data available >1985)
filepath = "../Data/input/credit_fullsample.csv"
df0 <- read.csv(filepath, header=TRUE, sep=",")
df0$date <- as.Date(df0$date)


df1 = subset(df0, date >= as.Date('1985-01-01')) 
dropList <- names(which(colSums(is.na(df1))>0))
df1 <- df1[, !colnames(df1) %in% dropList] #drop countries without data before 1985
countrylist <- names(df1)
countrylist <- countrylist[-which(countrylist == "date")]

## Loop through countries
## Full sample
# df1 <- read.table("../data/Input/credit_gap.csv", header=TRUE, sep=",")
# df1$date<-as.Date(df1$date)
# min(as.Date((df1$date)))
# names(df1)    

##Crisis data
filepath = "../Data/input/crisis_h8.csv"
df.crisis <- read.csv(filepath, header=TRUE, sep=",")
df.crisis$date <- as.Date(df.crisis$date)
name1<-Reduce(intersect,(list(countrylist,names(df.crisis)))) #32 countries


df.crisis <- df.crisis[c(name1,"date")] 


## Reduced country name
## Drop Greece because of on-going crisis
#name1<-name1[-which(name1=="GR")] #31 countries
countrylist<-name1
df1<-df1[c(name1,"date")]


## Hamilton Panel data gap
filepath = sprintf('../Data/Processed/GeneratedCycles_hamiltonpanel.csv')
dfh<-read.csv(filepath, header=TRUE, sep=",")
paste(countrylist, collapse="|")
dfh<-dfh[grepl(paste(countrylist, collapse="|"), dfh$ID),]
dfh$date<-as.Date(dfh$date)
dfh<-dfh %>%
        subset(dfh$date>=startdate) %>%
        subset(dfh$date<=enddate)

## Full sample gap



## for loop

country=countrylist[1]
filepath = sprintf('../Data/Processed/GeneratedCycles_%s.csv',country)
df0 <- read.csv(filepath, header=TRUE, sep=",")

matID <- as.matrix(rep(country, nrow(df0)))
df0= cbind(matID,df0)
names(df0)[1] <- "ID"
df<-df0

filepath = sprintf('../Data/Processed/GeneratedCycles_rolling10yrs_%s.csv',country)
df0 <- read.csv(filepath, header=TRUE, sep=",")
df <- merge(df,df0, by=c("date"), all=TRUE)

filepath = sprintf('../Data/Processed/GeneratedCycles_rolling15yrs_%s.csv',country)
df0 <- read.csv(filepath, header=TRUE, sep=",")
df <- merge(df,df0, by=c("date"), all=TRUE)

filepath = sprintf('../Data/Processed/GeneratedCycles_rolling20yrs_%s.csv',country)
df0 <- read.csv(filepath, header=TRUE, sep=",")
df <- merge(df,df0, by=c("date"), all=TRUE)

dfh0<-dfh%>%
        subset(dfh$ID==country)
dfh0$date<-as.Date(dfh0$date)
df$date<-as.Date(df$date)
df00 <- merge(df,dfh0, by=c("ID","date"))


for(i in 2:length(countrylist)){
  country = countrylist[i]
  filepath = sprintf('../Data/Processed/GeneratedCycles_%s.csv',country)
  df0 <- read.csv(filepath, header=TRUE, sep=",")
  
  matID <- as.matrix(rep(country, nrow(df0)))
  df0= cbind(matID,df0)
  names(df0)[1] <- "ID"
  df<-df0
  
  filepath = sprintf('../Data/Processed/GeneratedCycles_rolling10yrs_%s.csv',country)
  df0 <- read.csv(filepath, header=TRUE, sep=",")
  df <- merge(df,df0, by=c("date"), all=TRUE)
  
  filepath = sprintf('../Data/Processed/GeneratedCycles_rolling15yrs_%s.csv',country)
  df0 <- read.csv(filepath, header=TRUE, sep=",")
  df <- merge(df,df0, by=c("date"), all=TRUE)
  
  filepath = sprintf('../Data/Processed/GeneratedCycles_rolling20yrs_%s.csv',country)
  df0 <- read.csv(filepath, header=TRUE, sep=",")
  df <- merge(df,df0, by=c("date"), all=TRUE)
  
  dfh0<-dfh%>%
    subset(dfh$ID==country)
  dfh0$date<-as.Date(dfh0$date)
  df$date<-as.Date(df$date)
  df <- merge(df,dfh0, by=c("ID","date"))

  df00 <- rbind(df00,df)
}


# Merge with crisis data
library(reshape2)
df.crisis <- read.table("../data/Input/crisis_h58.csv", header=TRUE, sep=",")
df.crisis$date <- as.Date(df.crisis$date)
df.crisis <- reshape2::melt(df.crisis, id=c("date"))
names(df.crisis)<- c("date","ID","crisis")

df000<-merge(df.crisis,df00, by=c("ID","date"))
df0000<-merge(df.crisis,df00, by=c("ID","date"), all=TRUE)



## Variable selection
df<-df000
df<-na.omit(df000)
y=df$crisis
x=df[-c(1:3)]
#x<-x[,-which(names(x) == "combined.cycle")]
# packageurl <- "https://cran.r-project.org/src/contrib/Archive/BMS/BMS_0.3.4.tar.gz"
# install.packages(packageurl, repos=NULL, type="source")

## eplogprob.marg
#eplog1<-eplogprob.marg(y, x, thresh = 0.5, max = 0.99, int = TRUE)
#eplog1$

# library(forecast)
# library(vars)
# library(tseries)
# library(dynlm)
# library(zoo)
# library(dyn)
library(pROC)

matx=matrix(NA,3,ncol(x))
colnames(matx)<-names(x)
rownames(matx)<-c("BIC","AIC","AUC")
glm.x <- glm(y ~ 1, family = binomial)
test_prob = predict(glm.x, type = "response")
test_roc = roc(y ~ test_prob, plot = TRUE, print.auc = FALSE, levels = c(0,1)
               , direction = "<")
bic0=BIC(glm.x)
aic0=AIC(glm.x)
roc0=as.numeric(test_roc$auc) 
for (i in 1:ncol(x)){
glm.x <- glm(y ~ x[,i], family = binomial)
matx[1,i]=BIC(glm.x)-bic0
matx[2,i]=AIC(glm.x)-aic0
test_prob = predict(glm.x, type = "response", )
test_roc = roc(y ~ test_prob, plot = TRUE, print.auc = FALSE, levels = c(0,1)
               , direction = "<")
matx[3,i]=as.numeric(test_roc$auc)
}
matx<-t(matx)
matx<-as.data.frame(matx)
matx<-matx %>% arrange(desc(matx[,3]))
matx<-rbind(c(0,0,roc0),matx)
rownames(matx)[1]<-"null"
write.table(matx, "../Data/Output/Modelselection_58.csv", sep=',', row.names=TRUE, col.names=TRUE)



dfx<- df[,-which(names(df)=="date")]
matx=matrix(NA,3,ncol(x))
colnames(matx)<-names(x)
rownames(matx)<-c("BIC","AIC")
glm.x <- glm.cluster(crisis ~ 1, data=dfx, cluster="ID", family = binomial)

ext1<-extract(glm.x)
bic0=ext1@gof[2]
aic0=ext1@gof[1]
for (i in 1:ncol(x)){
  glm.x <- glm.cluster(crisis ~ dfx[,(i+2)], data=dfx, cluster="ID", family = binomial)
  matx[1,i]=extract(glm.x)@gof[2]-bic0
  matx[2,i]=extract(glm.x)@gof[1]-aic0

  }
matx<-t(matx)
matx<-as.data.frame(matx)
matx<-matx %>% arrange(matx[,1])


# library(BMA)
# glm.out.FT<-bic.glm(x, y, strict = TRUE, OR=20,
#                     glm.family="binomial", factor.type=FALSE)
# summary(glm.out.FT)

# 
# 
# imageplot.bma(glm.out.FT)
# 
# glm.out.FT<-bic.glm(chat, y, strict = TRUE, OR=20, 
#                     glm.family="binomial", factor.type=FALSE)
# summary(glm.out.FT)
# 
# 
# imageplot.bma(glm.out.FT)



priorCoef <- momprior(taustd=1)
#Beta-Binomial prior for model space
priorDelta <- modelbbprior(1,1)
#ybin= y>0 
fit2<-modelSelection(y, x,priorCoef=priorCoef,priorDelta=priorDelta,
                     family="binomial") 
#postProb(fit2)
for (i in 1:length(postProb(fit2)$modelid)){
  if(grepl(",",postProb(fit2)$modelid[i])){
    h=unlist(strsplit(postProb(fit2)$modelid[i], ","))
    print("--")
    for(j in 1:length(h)){
      print(c(h[j],names(x)[as.numeric(h[j])]))
    }
    print("--")
  }
  else{
  print(c(postProb(fit2)$modelid[i], names(x)[as.numeric(postProb(fit2)$modelid[i])]))
  }
}


## Test 4
#data(Pima.tr)
# enumeration  with default method="BAS"
# pima.cch = bas.glm(type ~ ., data=Pima.tr, n.models= 2^7,
#                    method="BAS",
#                    betaprior=CCH(a=1, b=532/2, s=0), family=binomial(),
#                    modelprior=beta.binomial(1,1))
# summary(pima.cch)
# image(pima.cch)
# Note MCMC.iterations are set to 1000 for illustration purposes
# Please check convergence diagnostics and run longer in practice
# pima.robust = bas.glm(type ~ ., data=Pima.tr, n.models= 2^7,
#                       method="MCMC", MCMC.iterations=5000,
#                       betaprior=robust(), family=binomial(),
#                       modelprior=beta.binomial(1,1))
# summary(pima.robust)
# image(pima.robust)
# 
# pima.robust = bas.glm(type ~ ., data=Pima.tr, n.models= 2^7,
#                       method="MCMC+BAS", MCMC.iterations=5000,
#                       betaprior=robust(), family=binomial(),
#                       modelprior=beta.binomial(1,1))
# summary(pima.robust)
# image(pima.robust)
# 
# pima.BIC = bas.glm(type ~ ., data=Pima.tr, n.models= 2^7,
#                    method="MCMC+BAS", MCMC.iterations=5000,
#                    betaprior=bic.prior(), family=binomial(),
#                    modelprior=uniform())
# summary(pima.BIC)
# image(pima.BIC)
# 
# 
#df<-df[-c(1:2)]
# pima.BIC = bas.glm(crisis ~ ., data=df,
#                    method="MCMC", MCMC.iterations=1000000,
#                    betaprior=bic.prior(), family=binomial(),
#                    modelprior=uniform(), bigmem=TRUE)
# diagnostics(pima.BIC)
# summary(pima.BIC)
# image(pima.BIC)

df<-df[-c(1:2)]
tic
pima.robust = bas.glm(crisis ~ ., data=df,
                      method="MCMC", MCMC.iterations=2000000,
                      betaprior=robust(), family=binomial(),
                      modelprior=beta.binomial(1,1), force.heredity=FALSE, 
                      bigmem=TRUE)
toc
diagnostics(pima.robust)
summary(pima.robust)
image(pima.robust)

View(summary(pima.robust))
sum0<-cbind(as.matrix(pima.robust$namesx), as.matrix(pima.robust$probne0))
sum1<-as.data.frame(as.numeric(sum0[,2]))
rownames(sum1)<-sum0[,1]

sum1<-sum1 %>% arrange(desc(sum1))
sum1






## Crisis 9-12
# Merge with crisis data
df.crisis <- read.table("../data/Input/crisis_h912.csv", header=TRUE, sep=",")
df.crisis$date <- as.Date(df.crisis$date)
df.crisis <- reshape2::melt(df.crisis, id=c("date"))
names(df.crisis)<- c("date","ID","crisis")

df000<-merge(df.crisis,df00, by=c("ID","date"))
df0000<-merge(df.crisis,df00, by=c("ID","date"), all=TRUE)

#eplog1<-eplogprob.marg(y, x, thresh = 0.5, max = 0.99, int = TRUE)
#eplog1$

## Variable selection
df<-df000
df<-na.omit(df000)
y=df$crisis
x=df[-c(1:3)]
dfx<- df[,-which(names(df)=="date")]


library(miceadds)
library(texreg)
library(pROC)

matx=matrix(NA,3,ncol(x))
colnames(matx)<-names(x)
rownames(matx)<-c("BIC","AIC","AUC")
glm.x <- glm(y ~ 1, family = binomial)
test_prob = predict(glm.x, type = "response")
test_roc = roc(y ~ test_prob, plot = TRUE, print.auc = FALSE, levels = c(0,1)
               , direction = "<")
bic0=BIC(glm.x)
aic0=AIC(glm.x)
roc0=as.numeric(test_roc$auc) 
for (i in 1:ncol(x)){
  glm.x <- glm(y ~ x[,i], family = binomial)
  matx[1,i]=BIC(glm.x)-bic0
  matx[2,i]=AIC(glm.x)-aic0
  test_prob = predict(glm.x, type = "response", )
  test_roc = roc(y ~ test_prob, plot = TRUE, print.auc = FALSE, levels = c(0,1)
                 , direction = "<")
  matx[3,i]=as.numeric(test_roc$auc)
}
matx<-t(matx)
matx<-as.data.frame(matx)
matx<-matx %>% arrange(desc(matx[,3]))
matx<-rbind(c(0,0,roc0),matx)
rownames(matx)[1]<-"null"
write.table(matx, "../Data/Output/Modelselection_912.csv", sep=',', row.names=TRUE, col.names=TRUE)



glm.x <- glm.cluster(crisis ~ 1, data=dfx, cluster="ID", family = binomial)
ext1<-extract(glm.x)
bic0=ext1@gof[2]
aic0=ext1@gof[1]

matx=matrix(NA,2,ncol(x))
colnames(matx)<-names(x)
rownames(matx)<-c("BIC","AIC")
for (i in 1:ncol(x)){
  glm.x <- glm.cluster(crisis ~ df[,(i+2)], data=dfx, cluster="ID", family = binomial)
  matx[1,i]=extract(glm.x)@gof[2]-bic0
  matx[2,i]=extract(glm.x)@gof[1]-aic0
}
matx<-t(matx)

priorCoef <- momprior(taustd=1)
#Beta-Binomial prior for model space
priorDelta <- modelbbprior(1,1)
#ybin= y>0 
fit2<-modelSelection(y, x,priorCoef=priorCoef,priorDelta=priorDelta,
                     family="binomial") 
postProb(fit2)
for (i in 1:length(postProb(fit2)$modelid)){
  if(grepl(",",postProb(fit2)$modelid[i])){
    h=unlist(strsplit(postProb(fit2)$modelid[i], ","))
    print("--")
    for(j in 1:length(h)){
      print(c(h[j],names(x)[as.numeric(h[j])]))
    }
    print("--")
  }
  else{
    print(c(postProb(fit2)$modelid[i], names(x)[as.numeric(postProb(fit2)$modelid[i])]))
  }
}
library(pracma)

df<-df[-c(1:2)]

tic()
bas.robust912 = bas.glm(crisis ~ ., data=df,
                      method="MCMC", MCMC.iterations=2000000,
                      betaprior=robust(), family=binomial(),
                      modelprior=beta.binomial(1,1), force.heredity=FALSE, 
                      bigmem=TRUE)
toc()
bas.robust912=pima.robust
diagnostics(bas.robust912)
summary(bas.robust912)
image(bas.robust912)

#View(summary(bas.robust912))
sum0<-cbind(as.matrix(bas.robust912$namesx), as.matrix(bas.robust912$probne0))
sum1<-as.data.frame(as.numeric(sum0[,2]))
rownames(sum1)<-sum0[,1]

sum1<-sum1 %>% arrange(desc(sum1))

sum1




## Crisis 1-12
# Merge with crisis data
df.crisis <- read.table("../data/Input/crisis_h112.csv", header=TRUE, sep=",")
df.crisis$date <- as.Date(df.crisis$date)
df.crisis <- reshape2::melt(df.crisis, id=c("date"))
names(df.crisis)<- c("date","ID","crisis")

df000<-merge(df.crisis,df00, by=c("ID","date"))
df0000<-merge(df.crisis,df00, by=c("ID","date"), all=TRUE)

#eplog1<-eplogprob.marg(y, x, thresh = 0.5, max = 0.99, int = TRUE)
#eplog1$

## Variable selection
df<-df000
df<-na.omit(df000)
y=df$crisis
x=df[-c(1:3)]
dfx<- df[,-which(names(df)=="date")]


matx=matrix(NA,3,ncol(x))
colnames(matx)<-names(x)
rownames(matx)<-c("BIC","AIC","AUC")
glm.x <- glm(y ~ 1, family = binomial)
test_prob = predict(glm.x, type = "response")
test_roc = roc(y ~ test_prob, plot = TRUE, print.auc = FALSE, levels = c(0,1)
               , direction = "<")
bic0=BIC(glm.x)
aic0=AIC(glm.x)
roc0=as.numeric(test_roc$auc) 
for (i in 1:ncol(x)){
  glm.x <- glm(y ~ x[,i], family = binomial)
  matx[1,i]=BIC(glm.x)-bic0
  matx[2,i]=AIC(glm.x)-aic0
  test_prob = predict(glm.x, type = "response", )
  test_roc = roc(y ~ test_prob, plot = TRUE, print.auc = FALSE, levels = c(0,1)
                 , direction = "<")
  matx[3,i]=as.numeric(test_roc$auc)
}
matx<-t(matx)
matx<-as.data.frame(matx)
matx<-matx %>% arrange(desc(matx[,3]))
matx<-rbind(c(0,0,roc0),matx)
rownames(matx)[1]<-"null"
write.table(matx, "../Data/Output/Modelselection_112.csv", sep=',', row.names=TRUE, col.names=TRUE)




## Crisis 5-12
# Merge with crisis data
df.crisis <- read.table("../data/Input/crisis_h512.csv", header=TRUE, sep=",")
df.crisis$date <- as.Date(df.crisis$date)
df.crisis <- reshape2::melt(df.crisis, id=c("date"))
names(df.crisis)<- c("date","ID","crisis")

df000<-merge(df.crisis,df00, by=c("ID","date"))
df0000<-merge(df.crisis,df00, by=c("ID","date"), all=TRUE)

#eplog1<-eplogprob.marg(y, x, thresh = 0.5, max = 0.99, int = TRUE)
#eplog1$

## Variable selection
df<-df000
df<-na.omit(df000)
y=df$crisis
x=df[-c(1:3)]
dfx<- df[,-which(names(df)=="date")]


matx=matrix(NA,3,ncol(x))
colnames(matx)<-names(x)
rownames(matx)<-c("BIC","AIC","AUC")
glm.x <- glm(y ~ 1, family = binomial)
test_prob = predict(glm.x, type = "response")
test_roc = roc(y ~ test_prob, plot = TRUE, print.auc = FALSE, levels = c(0,1)
               , direction = "<")
bic0=BIC(glm.x)
aic0=AIC(glm.x)
roc0=as.numeric(test_roc$auc) 
for (i in 1:ncol(x)){
  glm.x <- glm(y ~ x[,i], family = binomial)
  matx[1,i]=BIC(glm.x)-bic0
  matx[2,i]=AIC(glm.x)-aic0
  test_prob = predict(glm.x, type = "response", )
  test_roc = roc(y ~ test_prob, plot = TRUE, print.auc = FALSE, levels = c(0,1)
                 , direction = "<")
  matx[3,i]=as.numeric(test_roc$auc)
}
matx<-t(matx)
matx<-as.data.frame(matx)
matx<-matx %>% arrange(desc(matx[,3]))
matx<-rbind(c(0,0,roc0),matx)
rownames(matx)[1]<-"null"
write.table(matx, "../Data/Output/Modelselection_512.csv", sep=',', row.names=TRUE, col.names=TRUE)

tic()
priorCoef <- momprior(taustd=1)
#Beta-Binomial prior for model space
priorDelta <- modelbbprior(1,1)
#ybin= y>0 
fit2<-modelSelection(y, x,priorCoef=priorCoef,priorDelta=priorDelta,
                     family="binomial") 
postProb(fit2)
for (i in 1:length(postProb(fit2)$modelid)){
  if(grepl(",",postProb(fit2)$modelid[i])){
    h=unlist(strsplit(postProb(fit2)$modelid[i], ","))
    print("--")
    for(j in 1:length(h)){
      print(c(h[j],names(x)[as.numeric(h[j])]))
    }
    print("--")
  }
  else{
    print(c(postProb(fit2)$modelid[i], names(x)[as.numeric(postProb(fit2)$modelid[i])]))
  }
}
toc()


df1<-df[-c(1:2)]

tic()
bas.robust512 = bas.glm(crisis ~ ., data=df1,
                        method="MCMC", MCMC.iterations=4000000,
                        betaprior=robust(), family=binomial(),
                        modelprior=beta.binomial(1,1), force.heredity=FALSE, 
                        bigmem=TRUE)
toc()
#bas.robust512=pima.robust
diagnostics(bas.robust512)
summary(bas.robust512)
image(bas.robust512)

#View(summary(bas.robust912))
sum0<-cbind(as.matrix(bas.robust512$namesx), as.matrix(bas.robust512$probne0))
sum1<-as.data.frame(as.numeric(sum0[,2]))
rownames(sum1)<-sum0[,1]

sum1<-sum1 %>% arrange(desc(sum1))

sum1

