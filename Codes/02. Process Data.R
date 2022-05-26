## Set up
rm(list=ls())

library(mombf)
library(reshape2)
library(dplyr)
library(rstudioapi)
library(BAS)
library(pracma)
library(pROC)
# library(miceadds)
# library(texreg)



setwd(dirname(getActiveDocumentContext()$path))

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


## Loop through countries
## Full sample
# df1 <- read.table("../data/Input/credit_gap.csv", header=TRUE, sep=",")
# df1$date<-as.Date(df1$date)
# min(as.Date((df1$date)))
# names(df1)    

##Crisis data
filepath = "../Data/input/crisis_h512.csv"
df.crisis <- read.csv(filepath, header=TRUE, sep=",")
df.crisis$date <- as.Date(df.crisis$date)
name1<-Reduce(intersect,(list(countrylist,names(df.crisis)))) #32 countries

df.crisis <- df.crisis[c(name1,"date")] 


## Reduced country name
## Drop Greece because of on-going crisis
#name1<-name1[-which(name1=="GR")] #31 countries
countrylist<-name1

## Hamilton Panel data gap
filepath = sprintf('../Data/Processed/GeneratedCycles_hamiltonpanel.csv')
dfh<-read.csv(filepath, header=TRUE, sep=",")
paste(countrylist, collapse="|")
dfh<-dfh[grepl(paste(countrylist, collapse="|"), dfh$ID),]
dfh$date<-as.Date(dfh$date)
dfh<-dfh %>%
        subset(dfh$date<=enddate)

filepath = sprintf('../Data/Processed/GeneratedCycles_hamiltonpanel_r15.csv')
dfhr<-read.csv(filepath, header=TRUE, sep=",")
paste(countrylist, collapse="|")
dfhr<-dfhr[grepl(paste(countrylist, collapse="|"), dfh$ID),]
dfhr$date<-as.Date(dfhr$date)
dfhr15<-dfhr %>%
  subset(dfhr$date<=enddate)

filepath = sprintf('../Data/Processed/GeneratedCycles_hamiltonpanel_r20.csv')
dfhr<-read.csv(filepath, header=TRUE, sep=",")
paste(countrylist, collapse="|")
dfhr<-dfhr[grepl(paste(countrylist, collapse="|"), dfh$ID),]
dfhr$date<-as.Date(dfhr$date)
dfhr20<-dfhr %>%
  subset(dfhr$date<=enddate)

## Full sample gap

### for loop

df00 = data.frame()

for(i in 1:length(countrylist)){
  country = countrylist[i]
  filepath = sprintf('../Data/Processed/GeneratedCycles_%s.csv',country)
  df0 <- read.csv(filepath, header=TRUE, sep=",")
  
  matID <- as.matrix(rep(country, nrow(df0)))
  df0= cbind(matID,df0)
  names(df0)[1] <- "ID"
  df<-df0
  
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
  df <- merge(df,dfh0, by=c("ID","date"), all=TRUE)
  
  dfh0<-dfhr15%>%
    subset(dfh$ID==country)
  dfh0$date<-as.Date(dfh0$date)
  df$date<-as.Date(df$date)
  df <- merge(df,dfh0, by=c("ID","date"), all=TRUE)
  
  dfh0<-dfhr20%>%
    subset(dfh$ID==country)
  dfh0$date<-as.Date(dfh0$date)
  df$date<-as.Date(df$date)
  df <- merge(df,dfh0, by=c("ID","date"), all=TRUE)

  df00 <- rbind(df00,df)
}


# Merge with crisis data
df.crisis <- read.table("../data/Input/crisis_h512.csv", header=TRUE, sep=",")
df.crisis$date <- as.Date(df.crisis$date)
df.crisis <- reshape2::melt(df.crisis, id=c("date"))
names(df.crisis)<- c("date","ID","crisis")

df000<-merge(df.crisis,df00, by=c("ID","date"))
df0000<-merge(df.crisis,df00, by=c("ID","date"), all=TRUE)

df000000<-merge(df.crisis,df00, by=c("ID","date"), all=TRUE)
filepath = '../Data/Processed/512fullsamplecreditgapincNA.csv'
write.table(df000000, filepath, sep=',' , row.names = FALSE)

df.export <- merge(df.crisis, df00, by=c("ID", "date"), all.y=TRUE)
filepath = '../Data/Processed/512fullsamplecreditgap.csv'
write.table(df.export, filepath, sep=',' , row.names = FALSE)
## 5-12 horizon

## Variable selection
df<-df000
df<-na.omit(df000)
y=df$crisis
x=df[-c(1:3)]
dfx<- df[,-which(names(df)=="date")]


matx=matrix(NA,24,ncol(x))
colnames(matx)<-names(x)
glm.x <- glm(y ~ 1, family = binomial)
test_prob = predict(glm.x, type = "response")
test_roc = roc(y ~ test_prob, plot = FALSE, print.auc = FALSE, levels = c(0,1)
               , direction = "<")
bic0=BIC(glm.x)
aic0=AIC(glm.x)
roc0=as.numeric(test_roc$auc)
c.thresh0<-NA
coo1=coords(test_roc,ret=c('se','threshold','fpr','fnr'))
coo1$l05=0.5*coo1$fpr+(1-0.5)*coo1$fnr
coo1$l03=0.3*coo1$fpr+(1-0.3)*coo1$fnr
coo1$l07=0.7*coo1$fpr+(1-0.7)*coo1$fnr
coo1<-subset(coo1,coo1$sensitivity>=2/3)
coo1<-coo1[which(coo1$l05==min(coo1$l05)),]
threshold0<-coo1$threshold
t10<-coo1$fpr
t20<-coo1$fnr
dis0<-coo1$l05
proc0=auc(test_roc, partial.auc=c(1, 2/3), partial.auc.focus="se", partial.auc.correct=TRUE)
for (i in 1:ncol(x)){
  glm.x <- glm(y ~ x[,i], family = binomial)
  matx[1,i]=BIC(glm.x)-bic0
  matx[2,i]=AIC(glm.x)-aic0
  test_prob = predict(glm.x, type = "response")
  test_roc = roc(y ~ test_prob, plot = FALSE, print.auc = FALSE, levels = c(0,1)
                 , direction = "<")
  matx[3,i]=as.numeric(test_roc$auc)
  matx[4,i]=auc(test_roc, partial.auc=c(1, 2/3), partial.auc.focus="se", partial.auc.correct=TRUE)
  coo1=coords(test_roc,ret=c('se','threshold','fpr','fnr','c'))
  coo1$l05=0.5*coo1$fpr+(1-0.5)*coo1$fnr
  coo1$l03=0.3*coo1$fpr+(1-0.3)*coo1$fnr
  coo1$l07=0.7*coo1$fpr+(1-0.7)*coo1$fnr
  coo1<-subset(coo1,coo1$sensitivity>=2/3)
  coo2<-coo1[which(coo1$l05==min(coo1$l05)),]
  matx[6:9,i]=as.numeric(coo2[1,c(2:4,6)])
  dfy<-as.data.frame(cbind(y,test_prob,x[,i]))
  thresh<-matx[6,i]
  minabs<-abs(dfy$test_prob-thresh)
  dfy<-cbind(dfy,minabs)
  dfy<-dfy[which(dfy$minabs==min(dfy$minabs)),]
  matx[5,i]=dfy[1,3]
  
  coo2<-coo1[which(coo1$l03==min(coo1$l03)),]
  matx[11:14,i]=as.numeric(coo2[1,c(2:4,7)])
  dfy<-as.data.frame(cbind(y,test_prob,x[,i]))
  thresh<-matx[11,i]
  minabs<-abs(dfy$test_prob-thresh)
  dfy<-cbind(dfy,minabs)
  dfy<-dfy[which(dfy$minabs==min(dfy$minabs)),]
  matx[10,i]=dfy[1,3]
  
  coo2<-coo1[which(coo1$l07==min(coo1$l07)),]
  matx[16:19,i]=as.numeric(coo2[1,c(2:4,8)])
  dfy<-as.data.frame(cbind(y,test_prob,x[,i]))
  thresh<-matx[16,i]
  minabs<-abs(dfy$test_prob-thresh)
  dfy<-cbind(dfy,minabs)
  dfy<-dfy[which(dfy$minabs==min(dfy$minabs)),]
  matx[15,i]=dfy[1,3]
  
  coo2<-coo1[which(coo1$closest.topleft==min(coo1$closest.topleft)),]
  matx[21:24,i]=as.numeric(coo2[1,c(2:5)])
  dfy<-as.data.frame(cbind(y,test_prob,x[,i]))
  thresh<-matx[21,i]
  minabs<-abs(dfy$test_prob-thresh)
  dfy<-cbind(dfy,minabs)
  dfy<-dfy[which(dfy$minabs==min(dfy$minabs)),]
  matx[20,i]=dfy[1,3]
}
matx<-t(matx)
matx<-as.data.frame(matx)
matx<-matx %>% arrange(desc(matx[,4]))
colnames(matx)<-c("BIC","AIC","AUC","psAUC",
                  "c.Threshold","r.Threshold","Type I","Type II","Policy Loss Function",
                  "c.Threshold","r.Threshold","Type I","Type II","Policy Loss Function",
                  "c.Threshold","r.Threshold","Type I","Type II","Policy Loss Function",
                  "c.Threshold","r.Threshold","Type I","Type II","Policy Loss Function")
matx<-matx[,-which(names(matx)=="r.Threshold")]
matx<-rbind(c(0,0,roc0,proc0,c.thresh0,t10,t20,dis0,c.thresh0,t10,t20,dis0,c.thresh0,t10,t20,dis0,c.thresh0,t10,t20,dis0),matx)
rownames(matx)[1]<-"null"
write.table(matx, "../Data/Output/Modelselection_512.csv", sep=',', row.names=TRUE, col.names=TRUE)



df1<-df[-c(1:2)]

lm.obj1<-glm(crisis ~ ., data=df1, family = "binomial")
eplogprob1 <- eplogprob(lm.obj1)

tic()
pima.robust = bas.glm(crisis ~ ., data=df1,
                      method="MCMC", MCMC.iterations=400000,
                      betaprior=robust(), family=binomial(),
                      modelprior=beta.binomial(1,1), force.heredity=FALSE, 
                      bigmem=TRUE, initprob=eplogprob1,
                      laplace=TRUE, thin=50000)
toc()
diagnostics(pima.robust)
summary(pima.robust)
image(pima.robust)
#plot(pima.robust)

#View(summary(pima.robust))
sum0<-cbind(as.matrix(pima.robust$namesx), as.matrix(pima.robust$probne0))
sum1<-as.data.frame(as.numeric(sum0[,2]))
rownames(sum1)<-sum0[,1]

sum1<-sum1 %>% arrange(desc(sum1))
sum1
View(sum1)

#### BAS + MCMC

df1<-df[-c(1:2)]

lm.obj1<-glm(crisis ~ ., data=df1, family = "binomial")
eplogprob1 <- eplogprob(lm.obj1)

tic()
pima.robust = bas.glm(crisis ~ ., data=df1,
                      MCMC.iterations=5000,
                      betaprior=robust(), family=binomial(),
                      modelprior=beta.binomial(1,1), force.heredity=FALSE, 
                      bigmem=TRUE, initprob=eplogprob1,
                      method ="MCMC+BAS", laplace=TRUE)
toc()
diagnostics(pima.robust)
summary(pima.robust)
image(pima.robust)
#plot(pima.robust)

View(summary(pima.robust))
sum0<-cbind(as.matrix(pima.robust$namesx), as.matrix(pima.robust$probne0))
sum1<-as.data.frame(as.numeric(sum0[,2]))
rownames(sum1)<-sum0[,1]

sum1<-sum1 %>% arrange(desc(sum1))
sum1



##mombf package

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

fit2marg<-as.data.frame(fit2$margpp)

## Variable selection
df<-df000
df<-na.omit(df000)
y=df$crisis
x=df[-c(1:3)]
# packageurl <- "https://cran.r-project.org/src/contrib/Archive/BMS/BMS_0.3.4.tar.gz"
# install.packages(packageurl, repos=NULL, type="source")

## eplogprob.marg
#eplog1<-eplogprob.marg(y, x, thresh = 0.5, max = 0.99, int = TRUE)
#eplog1$


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

## One sided HP filter function / STM function
rm("bic.glm.pauc")
rm("summary.bic.glm.pauc")
source("testcode/bic.glm.pauc.test2.R")
source("testcode/summary.bic.R")

rm(glm.out.FT2)
glm.out.FT2<-bic.glm.pauc(x[1:30], y, strict = TRUE, OR=20,
                         glm.family="binomial", factor.type=FALSE)
summary.bic.glm.pauc(glm.out.FT2)

c.hat=as.numeric(t(glm.out.FT2$postmean[-1]%*%t(glm.out.FT2$x))/sum(glm.out.FT2$postmean[-1]))
glm.out <- glm(y~c.hat, family = "binomial")
test_prob = predict(glm.out, type = "response")
test_roc = pROC::roc(y ~ test_prob, plot = FALSE, print.auc = FALSE,
                     levels = c(1,0) , direction = ">")
pauc0=as.numeric(pROC::auc(test_roc, partial.auc=c(1, 2/3), partial.auc.focus="se",
                           partial.auc.correct=TRUE))


glm.out.FT<-bic.glm.pauc(x[1:30], y, strict = FALSE, OR=20,
                         glm.family="binomial", factor.type=FALSE)
summary.bic.glm.pauc(glm.out.FT)

glm.out.F1 <- glm(paste("crisis ~", paste(paste0(names(x[1:30])), collapse="+")), data = df1, family = "binomial")
glm.out.F1$deviance
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


matx=matrix(NA,24,ncol(x))
colnames(matx)<-names(x)
glm.x <- glm(y ~ 1, family = binomial)
test_prob = predict(glm.x, type = "response")
test_roc = roc(y ~ test_prob, plot = FALSE, print.auc = FALSE, levels = c(1,0)
               , direction = ">")
bic0=BIC(glm.x)
aic0=AIC(glm.x)
roc0=as.numeric(test_roc$auc)
c.thresh0<-NA
coo1=coords(test_roc,ret=c('se','threshold','fpr','fnr'))
coo1$l05=0.5*coo1$fpr+(1-0.5)*coo1$fnr
coo1$l03=0.3*coo1$fpr+(1-0.3)*coo1$fnr
coo1$l07=0.7*coo1$fpr+(1-0.7)*coo1$fnr
coo1<-subset(coo1,coo1$sensitivity>=2/3)
coo1<-coo1[which(coo1$l05==min(coo1$l05)),]
threshold0<-coo1$threshold
t10<-coo1$fpr
t20<-coo1$fnr
dis0<-coo1$l05
proc0=auc(test_roc, partial.auc=c(1, 2/3), partial.auc.focus="se", partial.auc.correct=TRUE)
for (i in 1:ncol(x)){
  glm.x <- glm(y ~ x[,i], family = binomial)
  matx[1,i]=BIC(glm.x)-bic0
  matx[2,i]=AIC(glm.x)-aic0
  test_prob = predict(glm.x, type = "response")
  test_roc = roc(y ~ test_prob, plot = FALSE, print.auc = FALSE, levels = c(1,0)
                 , direction = ">")
  matx[3,i]=as.numeric(test_roc$auc)
  matx[4,i]=auc(test_roc, partial.auc=c(1, 2/3), partial.auc.focus="se", partial.auc.correct=TRUE)
  coo1=coords(test_roc,ret=c('se','threshold','fpr','fnr','c'))
  coo1$l05=0.5*coo1$fpr+(1-0.5)*coo1$fnr
  coo1$l03=0.3*coo1$fpr+(1-0.3)*coo1$fnr
  coo1$l07=0.7*coo1$fpr+(1-0.7)*coo1$fnr
  coo1<-subset(coo1,coo1$sensitivity>=2/3)
  coo2<-coo1[which(coo1$l05==min(coo1$l05)),]
  matx[6:9,i]=as.numeric(coo2[1,c(2:4,6)])
  dfy<-as.data.frame(cbind(y,test_prob,x[,i]))
  thresh<-matx[6,i]
  minabs<-abs(dfy$test_prob-thresh)
  dfy<-cbind(dfy,minabs)
  dfy<-dfy[which(dfy$minabs==min(dfy$minabs)),]
  matx[5,i]=dfy[1,3]
  
  coo2<-coo1[which(coo1$l03==min(coo1$l03)),]
  matx[11:14,i]=as.numeric(coo2[1,c(2:4,7)])
  dfy<-as.data.frame(cbind(y,test_prob,x[,i]))
  thresh<-matx[11,i]
  minabs<-abs(dfy$test_prob-thresh)
  dfy<-cbind(dfy,minabs)
  dfy<-dfy[which(dfy$minabs==min(dfy$minabs)),]
  matx[10,i]=dfy[1,3]
  
  coo2<-coo1[which(coo1$l07==min(coo1$l07)),]
  matx[16:19,i]=as.numeric(coo2[1,c(2:4,8)])
  dfy<-as.data.frame(cbind(y,test_prob,x[,i]))
  thresh<-matx[16,i]
  minabs<-abs(dfy$test_prob-thresh)
  dfy<-cbind(dfy,minabs)
  dfy<-dfy[which(dfy$minabs==min(dfy$minabs)),]
  matx[15,i]=dfy[1,3]
  
  coo2<-coo1[which(coo1$closest.topleft==min(coo1$closest.topleft)),]
  matx[21:24,i]=as.numeric(coo2[1,c(2:5)])
  dfy<-as.data.frame(cbind(y,test_prob,x[,i]))
  thresh<-matx[21,i]
  minabs<-abs(dfy$test_prob-thresh)
  dfy<-cbind(dfy,minabs)
  dfy<-dfy[which(dfy$minabs==min(dfy$minabs)),]
  matx[20,i]=dfy[1,3]
  }
matx<-t(matx)
matx<-as.data.frame(matx)
matx<-matx %>% arrange(desc(matx[,4]))
colnames(matx)<-c("BIC","AIC","AUC","psAUC",
                  "c.Threshold","r.Threshold","Type I","Type II","Policy Loss Function",
                  "c.Threshold","r.Threshold","Type I","Type II","Policy Loss Function",
                  "c.Threshold","r.Threshold","Type I","Type II","Policy Loss Function",
                  "c.Threshold","r.Threshold","Type I","Type II","Policy Loss Function")
matx<-matx[,-which(names(matx)=="r.Threshold")]
matx<-rbind(c(0,0,roc0,proc0,c.thresh0,t10,t20,dis0,c.thresh0,t10,t20,dis0,c.thresh0,t10,t20,dis0,c.thresh0,t10,t20,dis0),matx)
rownames(matx)[1]<-"null"
write.table(matx, "../Data/Output/Modelselection_512.csv", sep=',', row.names=TRUE, col.names=TRUE)




##testcode
coo1=coords(test_roc ,ret=c('se',
        'threshold','fpr','fnr','c'))
coo1<-subset(coo1,coo1[,1]>=2/3)
coo1<-coo1[which(coo1$closest.topleft==min(coo1$closest.topleft)),]

coords(test_roc, "best", ret="threshold", transpose = FALSE,
       best.method="youden")


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

