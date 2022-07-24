## https://stackoverflow.com/questions/66000977/roc-with-cross-validation-for-linear-regression-in-r

library(dplyr)
library(pROC)
data(USArrests)
library(caret)
library(MLeval)
library(rsample)
library(purrr)
library(tidyverse)

USArrests <- USArrests %>% 
  mutate(Murder01 = as.numeric(Murder > mean(Murder, na.rm=TRUE)))

# create train and test sets
set.seed(2021)
cvfun <- function(split, ...){
  mod <- glm(Murder01 ~ Assault, data=analysis(split), family=binomial)
  fit <- predict(mod, newdata=assessment(split), type="response")
  data.frame(fit = fit, y = model.response(model.frame(formula(mod), data=assessment(split))))
}

cv_out <- vfold_cv(USArrests, v=10, repeats = 5) %>% 
    mutate(fit = map(splits, cvfun)) %>% 
    unnest(fit) %>% 
    group_by(id) %>% 
    summarise(auc = roc(y, fit, plot=FALSE)$auc[1])

cv_out

######

cvfun2 <- function(split, ...){
  mod <- glm(Murder01 ~ poly(Assault, 2),  data=analysis(split), family=binomial)
  fit <- predict(mod, newdata=assessment(split), type="response")
  data.frame(fit = fit, y = model.response(model.frame(formula(mod), data=assessment(split))))
}

cv_out2 <- vfold_cv(USArrests, v=10, repeats = 5) %>% 
    mutate(fit = map(splits, cvfun2)) %>% 
    unnest(fit) %>% 
    group_by(id) %>% 
    summarise(auc = roc(y, fit, plot=FALSE)$auc[1])

mean(cv_out2$auc)
# [1] 0.9123994
mean(cv_out$auc)
# [1] 0.9320451

sd(cv_out2$auc)