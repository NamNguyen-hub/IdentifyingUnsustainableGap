## Set up
rm(list=ls())
library(dplyr)
library(zoo)
library(reshape2)
library(BMA)

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
               "c.hp400k", "c.hp400k_r15", "c.hp400k_r20", "c.hp3k", 
               "c.hp3k_r20", "c.hp25k_r15", "c.hp25k", "c.hp221k", "c.hp125k", 
               "c.hamilton28_panel", "c.hamilton28_panelr15", "c.hamilton28_panelr20", 
               "c.hamilton13", "c.hamilton13_panelr15", "c.hamilton13_panel", 
               "c.ma", "c.stm", "c.stm_r15", "c.stm_r20", "c.bn2_r15", "c.bn2_r20" , 
               "c.bn3_r15", "c.bn4", "c.bn6_r20", "c.bn6",  "c.linear", 
               "c.quad" , "c.poly4_r20", "c.poly3")

df0<-df0[,cyclelist]

# names(df0) <- c( "ID", "date", "crisis",
#                  "c.hp400k", "c.hp400k_r15", "c.hp400k_r20", "c.hp3k",  
#                  "c.hp3k_r20", "c.hp25k_r15", "c.hp25k", "c.hp221k", "c.hp125k", 
#                  "c.hamilton28_panel", "c.hamilton28_panelr15", "c.hamilton28_panelr20", 
#                  "c.hamilton13", "c.hamilton13_panelr15", "c.hamilton13_panel", 
#                  "c.ma", "c.stm", "c.stm_r15", "c.stm_r20", "c.bn2_r15", "c.bn2_r20" , 
#                  "c.bn3_r15", "c.bn4", "c.bn6_r20", "c.bn6",  "c.linear", 
#                  "c.quad" , "c.poly4_r20", "c.poly3")

#### Test codes
df1<- df0
df1<-na.omit(df1)

#source("testcode/bic.glm.pauc.test2.R")
# source("testcode/bic.glm.pauc.test1.R")
rm(bic.glm.pauc)
rm(summary.bic.glm.pauc)
source("testcode/bic.glm.pauc.test3.R")
source("testcode/summary.bic.R")


#glm.out.FT<-bic.glm.pauc(df1[4:ncol(df1)], df1$crisis, strict = TRUE, OR=(10^20),
glm.out.FT<-bic.glm.pauc(df1[4:ncol(df1)], df1$crisis, strict = TRUE, OR=(2000),
                          glm.family="binomial", factor.type=FALSE)
summary.bic.glm.pauc(glm.out.FT)
#weight = glm.out.FT$postmean[-1] / sum(glm.out.FT$postmean[-1])


## Start with 1st 15 years (1970:q4-> 1985:q3)
df1<- df0 %>%
  subset(date <= as.Date(as.yearqtr(startdate)+15-1/4))
df1<- na.omit(df1)
rownames(df1)<- NULL
glm.out.FT2<-bic.glm.pauc(df1[4:ncol(df1)], df1$crisis, strict = TRUE, OR=(2000),
                          glm.family="binomial", factor.type=FALSE)
summary.bic.glm.pauc(glm.out.FT2)

weight = glm.out.FT2$postmean[-1] / sum(glm.out.FT2$postmean[-1])
#weightedcycle = weight%*%t(df1[4:ncol(df1)])
c.hat=as.numeric(t(glm.out.FT2$postmean[-1]%*%t(glm.out.FT2$x))/sum(glm.out.FT2$postmean[-1]))
glm.out <- glm(df1$crisis~c.hat, family = "binomial")
test_prob = predict(glm.out, type = "response")
test_roc = pROC::roc(df1$crisis ~ test_prob, plot = FALSE, print.auc = FALSE,
                     levels = c(0,1) , direction = "<")
pauc0=as.numeric(pROC::auc(test_roc, partial.auc=c(1, 2/3), partial.auc.focus="se",
                           partial.auc.correct=TRUE, allow.invalid.partial.auc.correct=TRUE))

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
  rownames(df1)<- NULL
  
  glm.out.FT2<-bic.glm.pauc(df1[4:ncol(df1)], df1$crisis, strict = TRUE, OR=(2000),
                            glm.family="binomial", factor.type=FALSE)
  #summary.bic.glm.pauc(glm.out.FT2)
  
  weight = glm.out.FT2$postmean[-1] / sum(glm.out.FT2$postmean[-1])
  #weightedcycle = weight%*%t(df1[4:ncol(df1)])
  c.hat=as.numeric(t(glm.out.FT2$postmean[-1]%*%t(glm.out.FT2$x))/sum(glm.out.FT2$postmean[-1]))
  glm.out <- glm(df1$crisis~c.hat, family = "binomial")
  test_prob = predict(glm.out, type = "response")
  test_roc = pROC::roc(df1$crisis ~ test_prob, plot = FALSE, print.auc = FALSE,
                       levels = c(0,1) , direction = "<")
  pauc0=as.numeric(pROC::auc(test_roc, partial.auc=c(1, 2/3), partial.auc.focus="se",
                             partial.auc.correct=TRUE, allow.invalid.partial.auc.correct=TRUE))
  
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
  print(sum(weight<0)>0)
  
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
               "c.hp400k", "c.hp400k_r15", "c.hp400k_r20", "c.hp3k", 
               "c.hp3k_r20", "c.hp25k_r15", "c.hp25k", "c.hp221k", "c.hp125k", 
               "c.hamilton28_panel", "c.hamilton28_panelr15", "c.hamilton28_panelr20", 
               "c.hamilton13", "c.hamilton13_panelr15", "c.hamilton13_panel", 
               "c.ma", "c.stm", "c.stm_r15", "c.stm_r20", "c.bn2_r15", "c.bn2_r20" , 
               "c.bn3_r15", "c.bn4", "c.bn6_r20", "c.bn6",  "c.linear", 
               "c.quad" , "c.poly4_r20", "c.poly3")

df0<-df0[,cyclelist]

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





#filepath = '../Data/Output/weight_mat_fullsample.csv'
#weightedcycle_mat2 <- read.csv(filepath, header=TRUE, sep=",")
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
dfy<-as.data.frame(cbind(df1$crisis,test_prob,df1$weightedcycle))
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

### Plot combined cycle for the US,  optimized threshold, (and crisis horizon) 

## Plot pAUC in 20yrs rolling sample


# pAUC table
## EME countrylist and AE countrylist
filepath = '../Data/Output/weightedcycle_fullsample.csv'
df0 <- read.csv(filepath, header=TRUE, sep=",")

countrylist_full=names(df0)
### IMF-2015 Emerging market country list
countrylist_EME = c("AR","BR","CL","CN","CO","HU","IN","ID","MY","MX","RU","ZA","TH","TR")
countrylist_AE = countrylist_full

for (i in 1:length(countrylist_EME)){
  countrylist_AE<-countrylist_AE[-which(countrylist_AE==countrylist_EME[i])]
} ## Remove EME country from LV crisis name list


filepath = '../Data/Output/crisis_weightedcycle_fullsample.csv'
df0 <- read.csv(filepath, header=TRUE, sep=",")

# pAUC table for EME

countrylist = list(countrylist_full, countrylist_AE, countrylist_EME)
names(countrylist) <- c("countrylist_full", "countrylist_AE", "countrylist_EME")

for (j in 1:length(countrylist)){
df1 <-df0[grepl(paste(countrylist[[j]], collapse="|"), df0$ID),]
  
df1<-na.omit(df1)
y=df1$crisis
x=df1[-c(1:3)]
#dfx<- df1[,-which(names(df)=="date")]

matx=matrix(NA,24,ncol(x))
colnames(matx)<-names(x)
#matx<-rbind(t(as.matrix(names(x))),matx)
glm.x <- glm(y ~ 1, family = binomial)
test_prob = predict(glm.x, type = "response")
test_roc = roc(y ~ test_prob, plot = FALSE, print.auc = FALSE, levels = c(0,1)
               , direction = "<")
bic0=BIC(glm.x)
aic0=AIC(glm.x)
roc0=as.numeric(test_roc$auc)
c.thresh0<-NA
coo1=coords(test_roc,ret=c('se','threshold','fpr','fnr','c'))
coo1$l05=0.5*coo1$fpr+(1-0.5)*coo1$fnr
coo1$l03=0.3*coo1$fpr+(1-0.3)*coo1$fnr
coo1$l07=0.7*coo1$fpr+(1-0.7)*coo1$fnr
coo1<-subset(coo1,coo1$sensitivity>=2/3)
coo1<-coo1[which(coo1$l05==min(coo1$l05)),]
threshold0<-coo1$threshold
t10<-coo1$fpr
t20<-coo1$fnr
dis1<-coo1$l05
dis0<-coo1$closest.topleft
proc0=auc(test_roc, partial.auc=c(1, 2/3), partial.auc.focus="se", partial.auc.correct=TRUE, allow.invalid.partial.auc.correct=TRUE)
for (i in 1:ncol(x)){
  glm.x <- glm(y ~ x[,i], family = binomial)
  matx[1,i]=BIC(glm.x)-bic0
  matx[2,i]=AIC(glm.x)-aic0
  test_prob = predict(glm.x, type = "response")
  test_roc = roc(y ~ test_prob, plot = FALSE, print.auc = FALSE, levels = c(0,1)
                 , direction = "<")
  matx[3,i]=as.numeric(test_roc$auc)
  matx[4,i]=auc(test_roc, partial.auc=c(1, 2/3), partial.auc.focus="se", partial.auc.correct=TRUE, allow.invalid.partial.auc.correct=TRUE)
  coo1=coords(test_roc,ret=c('se','threshold','fpr','fnr','c'))
  coo1$l05=0.5*coo1$fpr+(1-0.5)*coo1$fnr
  coo1$l03=0.3*coo1$fpr+(1-0.3)*coo1$fnr
  coo1$l07=0.7*coo1$fpr+(1-0.7)*coo1$fnr
  coo1<-subset(coo1,coo1$sensitivity>=2/3)
  
  coo2<-coo1[which(coo1$closest.topleft==min(coo1$closest.topleft)),]
  matx[6:9,i]=as.numeric(coo2[1,c(2:5)])
  dfy<-as.data.frame(cbind(y,test_prob,x[,i]))
  thresh<-matx[6,i]
  minabs<-abs(dfy$test_prob-thresh)
  dfy<-cbind(dfy,minabs)
  dfy<-dfy[which(dfy$minabs==min(dfy$minabs)),]
  matx[5,i]=dfy[1,3]
  
  
  coo2<-coo1[which(coo1$l05==min(coo1$l05)),]
  matx[11:14,i]=as.numeric(coo2[1,c(2:4,6)])
  dfy<-as.data.frame(cbind(y,test_prob,x[,i]))
  thresh<-matx[11,i]
  minabs<-abs(dfy$test_prob-thresh)
  dfy<-cbind(dfy,minabs)
  dfy<-dfy[which(dfy$minabs==min(dfy$minabs)),]
  matx[10,i]=dfy[1,3]
  
  coo2<-coo1[which(coo1$l03==min(coo1$l03)),]
  matx[16:19,i]=as.numeric(coo2[1,c(2:4,7)])
  dfy<-as.data.frame(cbind(y,test_prob,x[,i]))
  thresh<-matx[16,i]
  minabs<-abs(dfy$test_prob-thresh)
  dfy<-cbind(dfy,minabs)
  dfy<-dfy[which(dfy$minabs==min(dfy$minabs)),]
  matx[15,i]=dfy[1,3]
  
  coo2<-coo1[which(coo1$l07==min(coo1$l07)),]
  matx[21:24,i]=as.numeric(coo2[1,c(2:4,8)])
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
matx<-rbind(c(0,0,roc0,proc0,c.thresh0,t10,t20,dis0,c.thresh0,t10,t20,dis1,c.thresh0,t10,t20,dis1,c.thresh0,t10,t20,dis1),matx)
rownames(matx)[1]<-"null"
matx<-cbind(as.matrix(rownames(matx)),matx)
colnames(matx)[1]<-"Cycles"
matx[["Cycles"]][which(matx$Cycles=="weightedcycle")]="1_sided weighted_cycle"
filepath=sprintf("../Data/Output/Modelcomparison_512_weighted_%s.csv",names(countrylist)[j])
write.table(matx, filepath, sep=',', row.names=FALSE, col.names=TRUE)
}



# Plot time series of weights
library(ggplot2)
filepath = '../Data/Output/weightedcycle_fullsample.csv'
df0 <- read.csv(filepath, header=TRUE, sep=",")
dates <- as.Date(rownames(df0))

filepath = '../Data/Output/weight_mat_fullsample.csv'
weight_mat <- read.csv(filepath, header=TRUE, sep=",")
weight_mat = as.data.frame(t(weight_mat))
weight_mat$date = dates

df1<-melt(weight_mat,id.vars=c("date"))
names(df1)[3]="Cycleweight"

library(ggrepel)
df2<-df1 %>%
  subset(date==max(df1$date))
p1<-ggplot(data=df1, aes(x=date, y=Cycleweight, group=variable)) +
  #geom_rect(data = rects, aes(ymin = -Inf, ymax = Inf, xmin = ystart, xmax = yend, fill=periods), alpha = 0.3) +
  #scale_fill_manual(values=fillss)+
  geom_area(aes(fill = variable)) +
  geom_text_repel(data=df2,aes(label = variable), position = "fill",
            size=8*0.36, max.overlaps = 20)+
  #coord_cartesian(ylim = c(min(df1$value), max(df1$value))) +
  theme_light() +
  theme(panel.grid = element_blank()) +
  # geom_hline(aes(yintercept= 3.06, linetype = "BIS gap = 3.06"), colour= 'lightsalmon') +
  # geom_hline(aes(yintercept= 2.92, linetype = "weighted gap  = 2.92"), colour= 'mediumturquoise') +
  # scale_linetype_manual(name = "threshold", values = c(2,2),
  #                       guide = guide_legend(override.aes = list(color = c("lightsalmon","mediumturquoise"))))+
  #geom_hline(aes(yintercept= 3, linetype = "optimized threshold  = 3.00"), colour= 'blue') +
  #scale_linetype_manual(name = "threshold", values = c(2),
  #                      guide = guide_legend(override.aes = list(color = c("blue"))))+
  #
  theme(legend.position = "bottom") +
  labs(x = NULL, y = NULL,
       title = sprintf("Credit gaps weights"))
ggsave("../Data/Output/Graphs/Weights_stack.pdf", width=8, height=5)


p2<-ggplot() +
  #geom_rect(data = rects, aes(ymin = -Inf, ymax = Inf, xmin = ystart, xmax = yend, fill=periods), alpha = 0.3) +
  #scale_fill_manual(values=fillss)+
  geom_line(data=df1, aes(x=date, y=Cycleweight, color=variable)) +
  geom_text_repel(data=df2,aes(x=date, y=Cycleweight,label = variable), position = "identity",
                  size=8*0.36, max.overlaps = 29)+
  #geom_text(aes(label = variable), position = "fill")
  #coord_cartesian(ylim = c(min(df1$value), max(df1$value))) +
  theme_light() +
  theme(panel.grid = element_blank()) +
  # geom_hline(aes(yintercept= 3.06, linetype = "BIS gap = 3.06"), colour= 'lightsalmon') +
  # geom_hline(aes(yintercept= 2.92, linetype = "weighted gap  = 2.92"), colour= 'mediumturquoise') +
  # scale_linetype_manual(name = "threshold", values = c(2,2),
  #                       guide = guide_legend(override.aes = list(color = c("lightsalmon","mediumturquoise"))))+
  #geom_hline(aes(yintercept= 3, linetype = "optimized threshold  = 3.00"), colour= 'blue') +
  #scale_linetype_manual(name = "threshold", values = c(2),
  #                      guide = guide_legend(override.aes = list(color = c("blue"))))+
  #
  theme(legend.position="bottom") +
  labs(x = NULL, y = NULL,
       title = sprintf("Credit gaps weights"))
ggsave("../Data/Output/Graphs/Weights_series.pdf", width=8, height=5)

library(patchwork)
(p1)/(p2)
ggsave("../Data/Output/Graphs/Weights_combined.pdf" , width=8, height=10)


# ## Output pAUC table
# 
# options(kableExtra.latex.load_packages = FALSE)
# options(knitr.table.format = "pandoc")
# library('kableExtra')
# library(dplyr)
# library(knitr)
# library(rstudioapi)
# setwd(dirname(getActiveDocumentContext()$path))
# getwd()
# 
# filepath='../Data/Output/Modelcomparison_512_weighted_countrylist_full.csv'
# df<-read.csv(filepath, sep = ",", header=TRUE)
# 
# #rownames(df) <- df[,1]
# name1<- df[,1]
# name1<- gsub("_", ".", name1)
# name1[which(name1=="c.hp400k")]<-"BIS Basel gap"
# df[,1]<-name1
# 

# ## Selection table
# df<-df[-c(27:nrow(df)),-c(10:ncol(df))]
# df<-df[-2,]
# 
# kbl(df, "latex", booktabs = T, digits = c(4, 4, 4, 4, 4, 4, 4, 4), caption ='Variable selection', escape=FALSE, linesep=c("","", "", "", "\\addlinespace")
#     , row.names = FALSE) %>%
#   kable_paper("striped") %>%
#   #add_header_above(c("Parameters" = 1, "VAR2" = 3, "VAR2 1-cross lag" = 3, "VAR2 2-cross lags" = 3)) %>%
#   #footnote(general="UK Bayesian regression results") %>%
#   kable_styling(latex_options="scale_down") %>%
#   column_spec(5, bold = TRUE) #c(0,0,1,0,0,0,1,0,0,0,0,0,0,0,0))

# 
# ##  Fullsample
# filepath='../Data/Output/Modelcomparison_512_weighted_countrylist_full.csv'
# df<-read.csv(filepath, sep = ",", header=TRUE)
# 
# #rownames(df) <- df[,1]
# name1<- df[,1]
# name1<- gsub("_", ".", name1)
# name1[which(name1=="c.hp400k")]<-"BIS Basel gap"
# df[,1]<-name1
# 
# df<-df[,-c(10:ncol(df))]
# 
# kbl(df, "latex", booktabs = T, digits = c(4, 4, 4, 4, 4, 4, 4, 4), caption ='Variable selection', escape=FALSE, linesep=c("","", "", "", "\\addlinespace")) %>%
#   kable_paper("striped") %>%
#   #add_header_above(c("Parameters" = 1, "VAR2" = 3, "VAR2 1-cross lag" = 3, "VAR2 2-cross lags" = 3)) %>%
#   #footnote(general="UK Bayesian regression results") %>%
#   kable_styling(latex_options="scale_down") %>%
#   column_spec(5, bold = TRUE) %>% #c(0,0,1,0,0,0,1,0,0,0,0,0,0,0,0)) 
#   row_spec(c(2,which(df$Cycle=="BIS Basel gap")), bold=TRUE)
# 
# 
# ## AE
# filepath='../Data/Output/Modelcomparison_512_weighted_countrylist_AE.csv'
# df<-read.csv(filepath, sep = ",", header=TRUE)
# 
# #rownames(df) <- df[,1]
# name1<- df[,1]
# name1<- gsub("_", ".", name1)
# name1[which(name1=="c.hp400k")]<-"BIS Basel gap"
# df[,1]<-name1
# 
# df<-df[,-c(10:ncol(df))]
# 
# kbl(df, "latex", booktabs = T, digits = c(4, 4, 4, 4, 4, 4, 4, 4), caption ='Variable selection', escape=FALSE, linesep=c("","", "", "", "\\addlinespace")) %>%
#   kable_paper("striped") %>%
#   #add_header_above(c("Parameters" = 1, "VAR2" = 3, "VAR2 1-cross lag" = 3, "VAR2 2-cross lags" = 3)) %>%
#   #footnote(general="UK Bayesian regression results") %>%
#   kable_styling(latex_options="scale_down") %>%
#   column_spec(5, bold = TRUE) %>% #c(0,0,1,0,0,0,1,0,0,0,0,0,0,0,0)) 
#   row_spec(c(2,which(df$Cycle=="BIS Basel gap")), bold=TRUE)
# 
# 
# ## EME
# filepath='../Data/Output/Modelcomparison_512_weighted_countrylist_EME.csv'
# df<-read.csv(filepath, sep = ",", header=TRUE)
# 
# #rownames(df) <- df[,1]
# name1<- df[,1]
# name1<- gsub("_", ".", name1)
# name1[which(name1=="c.hp400k")]<-"BIS Basel gap"
# df[,1]<-name1
# 
# df<-df[,-c(10:ncol(df))]
# 
# kbl(df, "latex", booktabs = T, digits = c(4, 4, 4, 4, 4, 4, 4, 4), caption ='Variable selection', escape=FALSE, linesep=c("","", "", "", "\\addlinespace")) %>%
#   kable_paper("striped") %>%
#   #add_header_above(c("Parameters" = 1, "VAR2" = 3, "VAR2 1-cross lag" = 3, "VAR2 2-cross lags" = 3)) %>%
#   #footnote(general="UK Bayesian regression results") %>%
#   kable_styling(latex_options="scale_down") %>%
#   column_spec(5, bold = TRUE) %>% #c(0,0,1,0,0,0,1,0,0,0,0,0,0,0,0)) 
#   row_spec(c(which(df$Cycle=="1.sided weighted.cycle"),which(df$Cycle=="BIS Basel gap")), bold=TRUE)

