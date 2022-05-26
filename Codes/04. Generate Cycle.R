## Set up
rm(list=ls())
library(dplyr)
library(zoo)
library(reshape2)

source("testcode/summary.bic.R")

library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))

filepath = '../Data/Processed/512fullsamplecreditgap.csv'
df0 <- read.csv(filepath, header=TRUE, sep=",")
df0$date <- as.Date(df0$date)

startdate = as.Date("1970-10-01") # Begin of crisis data
enddate = as.Date("2017-10-01") # End of LV crisis data
df0 <- subset(df0, date>=startdate)

## Create list of selected cycles (p=29+intercept)
#names(df0)
cyclelist = c( "ID", "date", "crisis",
               "c.hp400k1", "c.hp400k15", "c.hp400k20", "c.hp3k1", 
               "c.hp3k20", "c.hp25k15", "c.hp25k1", "c.hp221k1", "c.hp125k1", 
               "c.hamilton28_panel", "c.hamilton28_panelr15", "c.hamilton28_panelr20", 
               "c.hamilton13t1", "c.hamilton13_panelr15", "c.hamilton13_panel", 
               "c.ma1", "c.stm1", "c.stm15", "c.stm20", "c.bn215", "c.bn220" , 
               "c.bn315", "c.bn4", "c.bn620", "c.bn6",  "c.linear2", 
               "c.quad2" , "c.poly420", "c.poly3")

df0<-df0[,cyclelist]

names(df0) <- c( "ID", "date", "crisis",
                 "c.hp400k", "c.hp400k_r15", "c.hp400k_r20", "c.hp3k",  
                 "c.hp3k_r20", "c.hp25k_r15", "c.hp25k", "c.hp221k", "c.hp125k", 
                 "c.hamilton28_panel", "c.hamilton28_panelr15", "c.hamilton28_panelr20", 
                 "c.hamilton13t", "c.hamilton13_panelr15", "c.hamilton13_panel", 
                 "c.ma", "c.stm", "c.stm_r15", "c.stm_r20", "c.bn2_r15", "c.bn2_r20" , 
                 "c.bn3_r15", "c.bn4", "c.bn6_r20", "c.bn6",  "c.linear", 
                 "c.quad" , "c.poly4_r20", "c.poly3")

#### Test codes
df1<- df0
df1<-na.omit(df1)

#source("testcode/bic.glm.pauc.test2.R")
rm(bic.glm.pauc)
source("testcode/bic.glm.pauc.test1.R")

#glm.out.FT<-bic.glm.pauc(df1[4:ncol(df1)], df1$crisis, strict = TRUE, OR=(10^20),
glm.out.FT<-bic.glm.pauc(df1[4:ncol(df1)], df1$crisis, strict = TRUE, OR=(20),
                          glm.family="binomial", factor.type=FALSE)
summary.bic.glm.pauc(glm.out.FT)
weight = glm.out.FT$postmean[-1] / sum(glm.out.FT$postmean[-1])


## Start with 1st 15 years (1970:q4-> 1985:q3)
df1<- df0 %>%
  subset(date <= as.Date(as.yearqtr(startdate)+15-1/4))
df1<- na.omit(df1)
glm.out.FT2<-bic.glm.pauc(df1[4:ncol(df1)], df1$crisis, strict = TRUE, OR=(20),
                          glm.family="binomial", factor.type=FALSE)
summary.bic.glm.pauc(glm.out.FT2)

weight = glm.out.FT2$postmean[-1] / sum(glm.out.FT2$postmean[-1])
#weightedcycle = weight%*%t(df1[4:ncol(df1)])
c.hat=as.numeric(t(glm.out.FT2$postmean[-1]%*%t(glm.out.FT2$x))/sum(glm.out.FT2$postmean[-1]))
glm.out <- glm(df1$crisis~c.hat, family = "binomial")
test_prob = predict(glm.out, type = "response")
test_roc = pROC::roc(df1$crisis ~ test_prob, plot = FALSE, print.auc = FALSE,
                     levels = c(1,0) , direction = ">")
pauc0=as.numeric(pROC::auc(test_roc, partial.auc=c(1, 2/3), partial.auc.focus="se",
                           partial.auc.correct=TRUE))

coo1=coords(test_roc,ret=c('se','threshold','fpr','fnr','c'))
coo1<-subset(coo1,coo1$sensitivity>=2/3)
coo2<-coo1[which(coo1$closest.topleft==min(coo1$closest.topleft)),]
matx=as.numeric(coo2[1,c(2:5)])
dfy<-as.data.frame(cbind(df1$crisis,test_prob,c.hat))
thresh<-matx[1]
minabs<-abs(dfy$test_prob-thresh)
dfy<-cbind(dfy,minabs)
dfy<-dfy[which(dfy$minabs==min(dfy$minabs)),]
matx=cbind(dfy[1,3],t(matx))
matx<-matx[-2]
matx<-cbind(pauc0,t(matx))

### Store weights
weight_mat = matrix(0, (ncol(df1)-4+1), length(dimnames(sort(table(df0$date)))[[1]]))
rownames(weight_mat)=names(df1)[4:ncol(df0)]
colnames(weight_mat)=dimnames(sort(table(df0$date)))[[1]]
weight_mat[,1:60]=rep(weight, 60)
# weight_mat[,c("1970-10-01")] # access weight_mat col by date
### store pAUC, and optimized threshold
thres_mat = matrix(0, 5, length(dimnames(sort(table(df0$date)))[[1]]))
rownames(thres_mat)=c("pAUC","Threshold","TypeI error", "TypeII error", "loss function:closest TL")
colnames(thres_mat)=dimnames(sort(table(df0$date)))[[1]]
thres_mat[,1:60]=rep(matx, 60)


### iterate additional quarters until 2017-10-01

length.data = (as.yearqtr(enddate)-(as.yearqtr(startdate)+15-1/4))*4

for(i in 1:length.data){
  
  df1<- df0 %>%
  subset(date <= as.Date(as.yearqtr(startdate)+15-1/4+i/4))
  date.iter <- as.Date(as.yearqtr(startdate)+15-1/4+i/4)
  print(date.iter)
  
  df1<- na.omit(df1)
  glm.out.FT2<-bic.glm.pauc(df1[4:ncol(df1)], df1$crisis, strict = TRUE, OR=(20),
                            glm.family="binomial", factor.type=FALSE)
  #summary.bic.glm.pauc(glm.out.FT2)
  
  weight = glm.out.FT2$postmean[-1] / sum(glm.out.FT2$postmean[-1])
  #weightedcycle = weight%*%t(df1[4:ncol(df1)])
  c.hat=as.numeric(t(glm.out.FT2$postmean[-1]%*%t(glm.out.FT2$x))/sum(glm.out.FT2$postmean[-1]))
  glm.out <- glm(df1$crisis~c.hat, family = "binomial")
  test_prob = predict(glm.out, type = "response")
  test_roc = pROC::roc(df1$crisis ~ test_prob, plot = FALSE, print.auc = FALSE,
                       levels = c(1,0) , direction = ">")
  pauc0=as.numeric(pROC::auc(test_roc, partial.auc=c(1, 2/3), partial.auc.focus="se",
                             partial.auc.correct=TRUE))
  
  coo1=coords(test_roc,ret=c('se','threshold','fpr','fnr','c'))
  coo1<-subset(coo1,coo1$sensitivity>=2/3)
  coo2<-coo1[which(coo1$closest.topleft==min(coo1$closest.topleft)),]
  matx=as.numeric(coo2[1,c(2:5)])
  dfy<-as.data.frame(cbind(df1$crisis,test_prob,c.hat))
  thresh<-matx[1]
  minabs<-abs(dfy$test_prob-thresh)
  dfy<-cbind(dfy,minabs)
  dfy<-dfy[which(dfy$minabs==min(dfy$minabs)),]
  matx=cbind(dfy[1,3],t(matx))
  matx<-matx[-2]
  matx<-cbind(pauc0,t(matx))

  weight_mat[,60+i]=weight
  thres_mat[,60+i]=matx
  
}

### extend weights to end of sample ()
k = (as.yearqtr(max(df0$date))-as.yearqtr(enddate))*4
weight_mat[,(ncol(weight_mat)-k+1):ncol(weight_mat)]=rep(weight, k)



#### Export matrices to csv file
filepath = '../Data/Output/weight_mat_fullsample.csv'
write.table(weight_mat, filepath, sep=',' , row.names = TRUE)

filepath = '../Data/Output/thresh_mat_fullsample.csv'
write.table(thres_mat, filepath, sep=',' , row.names = TRUE)





#### Calculate weighted cycle
##### Loop to calculate cycles
filepath = '../Data/Processed/512fullsamplecreditgapincNA.csv'
df0 <- read.csv(filepath, header=TRUE, sep=",")
df0$date <- as.Date(df0$date)

startdate = as.Date("1970-10-01") # Begin of crisis data
enddate = as.Date("2017-10-01") # End of LV crisis data
df0 <- subset(df0, date>=startdate)

## Create list of selected cycles (p=29+intercept)
#names(df0)
cyclelist = c( "ID", "date", "crisis",
               "c.hp400k1", "c.hp400k15", "c.hp400k20", "c.hp3k1", 
               "c.hp3k20", "c.hp25k15", "c.hp25k1", "c.hp221k1", "c.hp125k1", 
               "c.hamilton28_panel", "c.hamilton28_panelr15", "c.hamilton28_panelr20", 
               "c.hamilton13t1", "c.hamilton13_panelr15", "c.hamilton13_panelr20", 
               "c.ma1", "c.stm1", "c.stm15", "c.stm20", "c.bn215", "c.bn220" , 
               "c.bn315", "c.bn4", "c.bn715", "c.bn8",  "c.linear2", 
               "c.quad2" , "c.poly320", "c.poly3")

df0<-df0[,cyclelist]

names(df0) <- c( "ID", "date", "crisis",
                 "c.hp400k", "c.hp400k_r15", "c.hp400k_r20", "c.hp3k",  
                 "c.hp3k_r20", "c.hp25k_r15", "c.hp25k", "c.hp221k", "c.hp125k", 
                 "c.hamilton28_panel", "c.hamilton28_panelr15", "c.hamilton28_panelr20", 
                 "c.hamilton13t", "c.hamilton13_panelr15", "c.hamilton13_panelr20", 
                 "c.ma", "c.stm", "c.stm_r15", "c.stm_r20", "c.bn2_r15", "c.bn2_r20" , 
                 "c.bn3_r15", "c.bn4", "c.bn7_r15", "c.bn8",  "c.linear", 
                 "c.quad" , "c.poly3_r20", "c.poly3")


countrylist = dimnames(table(df0$ID))[[1]]
weightedcycles_mat = matrix(NA, length(dimnames(sort(table(df0$date)))[[1]]), length(countrylist))
colnames(weightedcycles_mat)=countrylist  
rownames(weightedcycles_mat)=dimnames(sort(table(df0$date)))[[1]]

##### Loop through country
for (j in 1:length(countrylist)) {
  
countryi=countrylist[j]
df2<-subset(df0, ID==countryi)
###### Loop through time
for(i in 1:nrow(weightedcycles_mat)){
  df3<-df2 %>%
    subset(date <= as.Date(as.yearqtr(startdate)-1/4+i/4))
  weightedcycle=as.matrix(df3[i,4:ncol(df3)])%*%weight_mat[,i]
  weightedcycles_mat[i,which(colnames(weightedcycles_mat)==countryi)]=weightedcycle
}
}
  
filepath = '../Data/Output/weightedcycle_fullsample.csv'
write.table(weightedcycles_mat, filepath, sep=',' , row.names = TRUE)


### plug weighted cycle back to crisis data, calculate pAUC
weightedcycle_mat2 <- as.data.frame(weightedcycles_mat)
weightedcycle_mat2$date <- rownames(weightedcycle_mat2)

weightedcycle_mat2 <- reshape2::melt(weightedcycle_mat2, id=c("date"))
names(weightedcycle_mat2)<-c("date","ID","weightedcycle")
df0<-merge(df0, weightedcycle_mat2, by=c("ID","date"))
df1<-na.omit(df0)
glm.out <- glm(df1$crisis~df1$weightedcycle, family = "binomial")
test_prob = predict(glm.out, type = "response")
test_roc = pROC::roc(df1$crisis ~ test_prob, plot = FALSE, print.auc = FALSE,
                     levels = c(0,1) , direction = "<")
pauc0=as.numeric(pROC::auc(test_roc, partial.auc=c(1, 2/3), partial.auc.focus="se",
                           partial.auc.correct=TRUE))

coo1=coords(test_roc,ret=c('se','threshold','fpr','fnr','c'))
coo1<-subset(coo1,coo1$sensitivity>=2/3)
coo2<-coo1[which(coo1$closest.topleft==min(coo1$closest.topleft)),]
matx<-data.frame()
matx=as.numeric(coo2[1,c(2:5)])
dfy<-as.data.frame(cbind(df1$crisis,test_prob,c.hat))
thresh<-matx[1]
minabs<-abs(dfy$test_prob-thresh)
dfy<-cbind(dfy,minabs)
dfy<-dfy[which(dfy$minabs==min(dfy$minabs)),]
matx=cbind(dfy[1,3],t(matx))
matx<-matx[-2]
matx<-cbind(pauc0,t(matx))
matx<-cbind(test_roc$auc ,matx)
AIC1<-AIC(glm.out)
BIC1<-BIC(glm.out)
glm.out0 <- glm(df1$crisis~1, family = "binomial")
AIC0<-AIC(glm.out0)
BIC0<-BIC(glm.out0)
matx<-cbind(AIC1 -AIC0 ,matx)
matx<-cbind(BIC1 -BIC0,matx)

### Export weigted cycle

filepath = '../Data/Output/crisis_weightedcycle_fullsample.csv'
write.table(df0, filepath, sep=',' , row.names = TRUE)


### Testcodes



# BIC(glm(df1$crisis~1, family = "binomial"))
# AIC(glm(df1$crisis~1, family = "binomial"))

### Plot combined cycle for the US,  optimized threshold, (and crisis horizon) 

## Plot weights of each cycles

## Plot pAUC in 20yrs rolling sample


