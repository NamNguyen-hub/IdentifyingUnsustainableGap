---
title: "Identify Sustainable Credit Gap"
author: "Nam Nguyen"
institute: "UWM"
short-institute: "UWM"
date: 'May 23, 2022'
output: 
  beamer_presentation:
    theme: "Dresden"
    colortheme: "whale"
    fonttheme: "default"
    keep_tex: true
    slide_level: 2
    includes:
      in_header: preamble.tex
    toc: FALSE
---

# Introduction
### Introduction
- Motivation
- Contribution
<!-- - Literature Review -->

### Methodology
- Data
- Empirical Model
- Results

## Motivation
- To overcome model uncertainty in using credit gap as an early warning indicator (EWI) of systemic financial crises, we propose using model averaging of different credit gap measurements. The method is based on Bayesian Model Average - Raftery (1995)


## Motivation
- Area under the curve of operating characteristic (AUROC or AUC) has been widely used as a criterion to determine the performance of a EWI. But it has received some criticism regarding the lower left area of the curve representing low predictive ability of the indicator.
- Borio and Drehmann (2009) and Beltran et al (2021) proposed a policy loss function constraining the relevance of the curve measurement to to just a portion where Type II error rate is less than 1/3 or at least 2/3 of the crises are predicted.    
- Detken (2014) proposed using partial standardized area under the curve (psAUC) as an alternative measurement of the performance of a EWI.

## Contribution
- Compare different credit gap measurements' performance as EWIs using a new criterion - partial AUC (psAUC or pAUC) contraining Type II error < 1/3.
- Overcome model uncertainty by implementing model averaging. We incoporated pAUC values in the model selection and weighting process, instead of AUC or BIC values.
- For ease of policy implication, we propose a single credit gap measurement from weighted averaging other popularly studied credit gap measurements.


## Literature Review
Beltran (2021) - measured and the performance of BIS Basel credit gap, Structural Time Series model (STM) gap, Moving average, Hamilton filter gap, and optimized the parameter in those filters to minimize policy loss function.

Galán (2019) proposed rolling sample of 15 and 20 years when creating one sided cycle.

Drehmann (2021) created hamilton filter in a panel setting with fixed coefficients on independent variable across countries.

## Data
Sample data periods: 1970-Q3 - 2017-Q4 across 43 countries. We omit periods for countries with shorter credit measurement.

Crisis data:
- European Systemic Risk Board crisis data set (Lo Duca et al. 2017)
- Laeven and Valencia (2018)

Credit/GDP ratio data:
- Bank of International Settlement (BIS)

# Model
## Credit gap creation

\begin{align}
	100*\frac{Credit}{GDP} &= y_t = \tau_{yt} + c_{yt}
\end{align}

We created 90 candidate one-sided credit gap measurements based on the literature.

## logit regression:

\begin{align}
  pre.crisis_{it} \sim credit.gap_{itj}
\end{align}

- where $pre.crisis_{it}=$  1 or 0 
	
- $i$ is country indicator. $j$ is credit gap filter type
	
- The pre-crisis indicator is set to 1 when t is between 5-12 quarters before a systemic crisis. 
	
- We discard measurements between 1-4 quarters before a crisis, periods during a crisis and post-crisis periods identified in Lo Duca et al. (2017) and Laeven and Valencia (2018). 
  + The indicator is set to 0 at other periods.

## Model selection
### Comparing performance of individual credit gaps
Using partial area under the curve (pAUC) values

### Test for gap combination performance
Using Markov Chain Monte Carlo Model Comparison ($MC^3$) developed by Madigan and York (1995). The method assign posterior probability for different credit gaps being selected in most likely models/combinations. Babecky (2014) used the method to identify potential variables in EWI models.

### Model selection
-We selected 29 credit gap measurements based on the previous 2 criteria.

## Model selection
<!-- - Insert table comparing pAUC values here -->

<!-- # ```{r, echo=FALSE, message=FALSE} -->
# options(kableExtra.latex.load_packages = FALSE)
# options(knitr.table.format = "pandoc")
# library('kableExtra')
# library(dplyr)
# library(knitr)
# library(rstudioapi)
# setwd(dirname(getActiveDocumentContext()$path))
# getwd()
# 
# filepath='../Data/Output/052219_Thu_BIC_unrestricted/Modelselection_512.csv'
# df<-read.csv(filepath, sep = ",", header=TRUE)
# 
# rownames(df) <- df[,1]
# df<-df[,-1]
# df<-df[-c(31:nrow(df)),-c(8:ncol(df))]
# #colnames(df) <- c("Median", "10pct", "90pct", "Median", "10pct", "90pct", "Median", "10pct", "90pct")
# 
# #options(knitr.kable.NA = '')
# 
# #df = df %>% mutate_if(is.numeric, format, digits=4)
# 
# #kbl(data.frame(x=rnorm(10), y=rnorm(10), x= rnorm(10)), digits = c(1, 4, 4))
# 
# kbl(df, "latex", booktabs = T, digits = c(4, 4, 4, 4, 4, 4, 4, 4), caption ='Variable selection', escape=FALSE, linesep=c("","", "", "", "\\addlinespace")) %>%
#   kable_paper("striped") %>%
#   #add_header_above(c("Parameters" = 1, "VAR2" = 3, "VAR2 1-cross lag" = 3, "VAR2 2-cross lags" = 3)) %>%
#   #footnote(general="UK Bayesian regression results") %>%
#   kable_styling(latex_options="scale_down") %>%
#   column_spec(4, bold = TRUE)#c(0,0,1,0,0,0,1,0,0,0,0,0,0,0,0))
<!-- ```-->


# Model averaging

## Model posterior probability
### Bayesian Model Averging
The Bayesian Model Average method is formalized in Raftery (1995).

equation (33): Model posterior probability:
\begin{align}
  P(M_k|D) = \frac{P(D|M_k)P(M_k)}{\sum\nolimits_{l=1}^K P(D|M_l)P(M_l)} 
  \approx \frac{exp(-\frac{1}{2}BIC_k)}{\sum\nolimits_{l=1}^K exp(-\frac{1}{2}BIC_l)}
\end{align}

- Where $P(M_k)$ is model prior probability and can be ignored if all models are assumed equal prior weights. 

- $P(D|M_k)$ is marginal likehood. And $P(D|M_k) \propto exp(-\frac{1}{2}BIC_k)$

- In which $BIC_k = 2log (Bayesfactor_{sk}) = \chi^2_{sk} - df_klog(n)$. s indicates saturated model.

## Model posterior probability
- $BIC_k = 2log (Bayesfactor_{sk}) = \chi^2_{sk} - df_klog(n)$
- $\chi^2_{sk}$ is the deviance of model K from the the saturated model
  + $\chi^2_{sk} = 2(ll(Ms) - ll(Mk))$
  + $ll(Mk)$ is the log-likelihood of model Mk given data D

###  Alternate deviance measurement
We propose using pAUC instead of log-likelihood in the measurement of deviance. Hence, an alternative BIC value can be estimated at:

\begin{align}
BIC_{alt,k} &= 2log (Bayesfactor_{alt,sk}) \\
&= 2(1000*(pAUC_s-pAUC_k)) - df_klog(n)
\end{align}
- We scaled the pAUC value by 1000 since $0<pAUC<1$. Also, by design, $pAUC_s=1$.

## Posterior distribution of coefficients of interest:
\begin{align*}
p(\beta_1|D, B_1\ne 0) = \sum\nolimits_{A_1} p(\beta_1|D,M_k)p'(M_k|D)
\end{align*}


- where $p'(M_k|D)=p(M_k|D)/ pr[\beta_1 \ne 0|D]$
- and $pr[\beta_1 \ne 0|D] = \sum\limits_{A_1} P(M_k|D)$
  + this is the probability that $\beta_1$ is in the model
  + $A_1= \{M_k: k=1,...,K; \beta_1 \ne 0\}$, that is the set of model that includes $\beta_1$

## Approximation of Bayesian point estimate:

\begin{align}
E[\beta_1|D, B_1\ne 0] = \sum\limits_{A_1} \hat{\beta}_1(k)p'(M_k|D)
\end{align}

$SD^2[\beta_1|D, B_1\ne 0] =[\sum\limits_{A_1}[se_1^2(k)+]+\hat{\beta_1}(k)]p'(M_k|D)
- E[\beta_1|D, B_1\ne 0]^2$

- Where $\hat{\beta}_1(k)$ and $se_1^2(k)$ are respectively the MLE and standard error of $\beta_1$ under the model $M_k$. (Leamer 1978, p.118; Raftery 1993a)


# Weighted credit gap creation
## Weighted credit gap motivation
GLM binomial estimation: 
$\widehat{pre.crisis}_{ti} = \widehat{response}_{ti} = \frac {1}{1-exp(a+\sum\nolimits_j \hat{\beta}_j c_{tij})}$

- With $\hat{\beta}_j$ = $E[\beta_j|D, B_j\ne 0] = \sum\limits_{A_j} \hat{\beta}_j(k)p'(M_k|D)$


We propose a single weighted credit gap $\hat{c}_{ti}$ that satisfy:
\begin{align*}
\frac {1}{1-exp(a+\hat{\beta} \hat{c}_{ti})}= \frac {1}{1-exp(a+\sum\nolimits_j \hat{\beta}_j c_{tij})} \\
\end{align*}
OR
\begin{align}
\sum\limits_j \hat{\beta}_j c_{tij} = \hat{\beta} \hat{c}_{ti}
\end{align}

## Weighted gap creation
\begin{align*}
\sum\limits_j \hat{\beta}_j c_{tij} = \hat{\beta} \hat{c}_{ti}
\end{align*}

We then propose $\hat{\beta} = \sum\nolimits_j \hat{\beta}_j$

Therefore, 

\begin{align}
\hat{c}_{ti} = \frac{\sum\nolimits_j (\hat{\beta}_j c_{tij})}{\sum\nolimits_j\hat{\beta}_j} = \sum\nolimits_j w_j c_{tij}
\end{align}

The weight of each candidate cycle will be $w_j = \frac{\hat{\beta}_j}{\sum\nolimits_j\hat{\beta}_j}$

# Empirical Results
## Comparing pAUC of weighted gap

## Plot weighted gap against BIS gap

<!-- ## Emprical Results - Baseline Model VAR(2): UK and US -->

<!-- ```{=latex} -->
<!-- \resizebox{\linewidth}{!}{ -->
<!-- 			\begin{threeparttable} -->
<!-- 				\caption {\label{tab:table1} parsimony VAR(2) model} -->
<!-- 				%\rowcolors{2}{gray!10}{white}  -->
<!-- 				\begin{tabular}{@{}llSSSS@{}} -->
<!-- 					\toprule -->
<!-- 					\multirow{1}{*}{Parameters} & \multicolumn{2}{c}{UK Results} & \multicolumn{2}{c}{US Results} \\ -->
<!-- 					& \multicolumn{1}{l}{Estimate}     & \multicolumn{1}{l}{Std. Error}  & \multicolumn{1}{l}{Estimate}            & \multicolumn{1}{l}{Std. Error}               \\ \midrule -->
<!-- 					Log-likelihood value & $llv$ & -454.6450 & &-339.7258 &\\[2pt]  -->
<!-- 					Credit to household & \\ -->
<!-- 					\quad Credit to household 1st AR parameter  & $\phi^1_{y}$ & 1.9725 &0.0234 &1.8497 &0.0645\\[2pt]  -->
<!-- 					\quad Credit to household 2nd AR parameter  & $\phi^2_{y}$ & -0.9827 &0.0263 &-0.8917 &0.0639 \\[2pt]  -->
<!-- 					\quad Credit to household 1st cross cycle AR parameter  & $\phi^{x1}_{y}$ & & & &\\[2pt]  -->
<!-- 					\quad Credit to household 2nd cross cycle AR parameter  & $\phi^{x2}_{y}$ & & & &\\[2pt]  -->
<!-- 					\quad S.D. of permanent shocks to Credit to household & $\sigma_{ny}$ & 0.7063 &0.0600 &0.4793 &0.0244\\[2pt]  -->
<!-- 					\quad S.D. of transitory shocks to Credit to household & $\sigma_{ey}$ & 0.0004 &0.0104 &0.0281 &0.0154\\[2pt] -->
<!-- 					Housing Price Index & \\ -->
<!-- 					\quad Housing Price Index 1st AR parameter  & $\phi^1_{h}$ &1.5048 &0.1019 &1.7847 &0.0345\\[2pt]  -->
<!-- 					\quad Housing Price Index 2nd AR parameter  & $\phi^2_{h}$ &-0.5608 &0.1252 &-0.8034 &0.0345\\[2pt]  -->
<!-- 					\quad Housing Price Index 1st cross cycle AR parameter  & $\phi^{x1}_{h}$ & & & &\\[2pt]  -->
<!-- 					\quad Housing Price Index 2nd cross cycle AR parameter  & $\phi^{x2}_{h}$ & & & &\\[2pt]  -->
<!-- 					\quad S.D. of permanent shocks to Housing Price Index & $\sigma_{nh}$ &1.8676 &0.1617 &0.4549 &0.0440\\[2pt]  -->
<!-- 					\quad S.D. of permanent shocks to Housing Price Index & $\sigma_{eh}$ &0.6568 &0.2583 &0.02566 &0.0323\\[2pt] -->
<!-- 					Cross-series correlations & \\ -->
<!-- 					\quad Correlation: Permanent credit to household/Permanent Housing Price Index  & $\sigma_{nynh}$ &0.5680 &0.1125 &0.3974 &0.0721\\[2pt]  -->
<!-- 					\quad Correlation: Transitory credit to household/Transitory Housing Price Index  & $\sigma_{nynh}$ &0.6888 &13.1231 &-1.0000 &0.0001\\[2pt]  -->

<!-- 					\bottomrule -->
<!-- 				\end{tabular} -->
<!-- %				\begin{tablenotes} -->
<!-- %					\small -->
<!-- %					\item $y_t$ is credit to household series, $h_t$ is housing price index series. Both are log transformed. \\ -->
<!-- %				\end{tablenotes} -->
<!-- 			\end{threeparttable} -->
<!-- } -->
<!-- ``` -->

<!-- ## Empirical Results -->

<!-- ### Extended Models Regression Results: United States -->


<!-- \resizebox{\linewidth}{!}{ -->
<!-- \begin{threeparttable} -->
<!-- 	\begin{tabular}{@{}lSSSSSS@{}} -->
<!-- 		\toprule -->
<!-- 		\multirow{1}{*}{Parameters} & \multicolumn{2}{c}{VAR(2)} & \multicolumn{2}{c}{VAR(2) 1st-cross-lag} & \multicolumn{2}{c}{VAR(2) 2-cross-lags} \\ -->
<!-- 		& \multicolumn{1}{l}{Estimate}     & \multicolumn{1}{l}{Std. Error}  & \multicolumn{1}{l}{Estimate}            & \multicolumn{1}{l}{Std. Error}         & \multicolumn{1}{c}{Estimate}            & \multicolumn{1}{c}{Std. Error}        \\ \midrule -->
<!-- 						$\phi^1_{y}$ & 1.84966219148423 & 0.0644676313866302 & 1.3049851733765 & 0.104750302567286 & 1.55023948671664 & 0.0621673748460661 \\[2pt]  -->

<!-- 						$\phi^2_{y}$ & -0.891729894865282 & 0.0639404413297913 & -0.509866573496016 & 0.069617976248189 & -0.575429145279164 & 0.0642314985800815 \\[2pt]  -->

<!-- 						$\phi^{x1}_{y}$ &  &  & \textbf{0.0332} & \textbf{0.0026} & \textbf{0.0141} & \textbf{0.0083} \\[2pt]  -->

<!-- 						$\phi^{x2}_{y}$ &  &  &  &  & \textbf{0.0036} & \textbf{0.0113} \\[2pt]  -->

<!-- 						$\phi^1_{h}$ & 1.78470130468539 & 0.0344716924207026 & 2.05291126214826 & 0.0420850279485188 & 1.83380271755234 & 0.0658209041054138 \\[2pt]  -->

<!-- 						$\phi^2_{h}$ & -0.803434089401448 & 0.0344748867950664 & -1.24693155894687 & 0.0730767847110221 & -0.935812307687759 & 0.0611374033703922 \\[2pt]  -->

<!-- 						$\phi^{x1}_{h}$ &  &  & \textbf{1.0795} & \textbf{0.2918} & \textbf{1.7429} & \textbf{0.4406} \\[2pt]  -->

<!-- 						$\phi^{x2}_{h}$ &  &  &  &  & \textbf{-1.6544} & \textbf{0.4175} \\[2pt]  -->

<!-- 						$\sigma_{ny}$ & 0.479256554775164 & 0.024356073491864 & 0.471764807847753 & 0.0240668275640588 & 0.419468168735488 & 0.0205969049394897 \\[2pt]  -->

<!-- 						$\sigma_{ey}$ & 0.0281304866214994 & 0.015423818330929 & 0.0256204974500183 & 0.0136254798281635 & 0.0375254711433971 & 0.0132294877888843 \\[2pt]  -->

<!-- 						$\sigma_{nh}$ & 0.454891152005456 & 0.0439608378398243 & 0.474208630734516 & 0.0382694791792356 & 0.493724545052865 & 0.0367094830752408 \\[2pt]  -->

<!-- 						$\sigma_{eh}$ & 0.256618222235034 & 0.0323339473241677 & 0.0876133859992021 & 0.075599690650887 & 0.0965865013366302 & 0.0477727959889094 \\[2pt]  -->

<!-- 						$\sigma_{eyeh}$ & -0.999999981277929 & 0.00012954480904903 & 0.999999998244551 & 8.59389213308525e-05 & 0.999999999996535 & 2.57431114995605e-06 \\[2pt]  -->

<!-- 						$\sigma_{nynh}$ & 0.397394222344986 & 0.0720586265329286 &  &  &  &  \\[2pt]  -->

<!-- 						Log-likelihood value & -339.725810225008 &  & -346.91597902411 &  & -332.070599830711 &  \\[2pt]  \bottomrule -->
<!-- \end{tabular} -->
<!-- \begin{tablenotes} -->
<!--             \footnotesize -->
<!--             \item {Weights of likelihood function: w1 = 0.6, w2 = 0.4, w3 = 0.004, w4 = 0.003\\ -->
<!-- 				$l(\theta) = -w1\sum_{t=1}^{T}ln\lbrack(2\pi)^2|f_{t|t-1}|\rbrack -->
<!-- 				-w2\sum_{t=1}^{T}\eta'_{t|t-1}f^{-1}_{t|t-1}\eta_{t|t-1} -->
<!-- 				- w3*\sum_{t=1}^{T}(c_{yt}^2) - w4*\sum_{t=1}^{T}(c_{ht}^2)$} -->
<!--         \end{tablenotes} -->
<!-- \end{threeparttable}} -->

<!-- ## Empirical Results -->

<!-- ### Extended Models Regression Results: United Kingdom  -->


<!-- \resizebox{\linewidth}{!}{ -->
<!-- \begin{threeparttable} -->
<!-- 	\begin{tabular}{@{}lSSSSSS@{}} -->
<!-- 		\toprule -->
<!-- 		\multirow{1}{*}{Parameters} & \multicolumn{2}{c}{VAR(2)} & \multicolumn{2}{c}{VAR(2) 1st-cross-lag} & \multicolumn{2}{c}{VAR(2) 2-cross-lags} \\ -->
<!-- 		& \multicolumn{1}{l}{Estimate}     & \multicolumn{1}{l}{Std. Error}  & \multicolumn{1}{l}{Estimate}            & \multicolumn{1}{l}{Std. Error}         & \multicolumn{1}{c}{Estimate}            & \multicolumn{1}{c}{Std. Error}        \\ \midrule -->
<!-- $\phi^1_{y}$ & 1.9724669930757 & 0.0234468079641688 & 1.88197173053092 & 0.000523125515915717 & 1.88953015161501 & 0.000183792455813221 \\[2pt]  -->

<!-- $\phi^2_{y}$ & -0.982683577200677 & 0.0263416186406314 & -0.815982512675866 & 0.00223671725855314 & -0.874307021294592 & 0.00255445094151967 \\[2pt]  -->

<!-- $\phi^{x1}_{y}$ &  &  & \textbf{-0.0240} & \textbf{0.0004} & \textbf{0.1756} & \textbf{0.0008} \\[2pt]  -->

<!-- $\phi^{x2}_{y}$ &  &  &  &  & \textbf{-0.1964} & \textbf{0.0034} \\[2pt]  -->

<!-- $\phi^1_{h}$ & 1.50478963225312 & 0.101880883082685 & 1.57483174602634 & 0.00564601795054225 & 1.57420604076636 & 0.0642716927922472 \\[2pt]  -->

<!-- $\phi^2_{h}$ & -0.560771136941685 & 0.125238824672495 & -0.709427180268352 & 0.00767038778223485 & -0.736359754267049 & 0.0585703755604665 \\[2pt]  -->

<!-- $\phi^{x1}_{h}$ &  &  & \textbf{0.3783} & \textbf{0.0170} & \textbf{0.7213} & \textbf{0.0492} \\[2pt]  -->

<!-- $\phi^{x2}_{h}$ &  &  &  &  & \textbf{-0.5958} & \textbf{0.0442} \\[2pt]  -->

<!-- $\sigma_{ny}$ & 0.706260098775181 & 0.0599943989318998 & 0.701703618546321 & 0.0352951761051411 & 0.603955648517265 & 0.0374077642345331 \\[2pt]  -->

<!-- $\sigma_{ey}$ & 0.000426758587731293 & 0.0103570158509057 & 0.11272451354988 & 0.00521152792358025 & 0.0160160963024367 & 0.0062789472885429 \\[2pt]  -->

<!-- $\sigma_{nh}$ & 1.86757774805953 & 0.161705655819894 & 1.64285780217825 & 0.102292598525495 & 1.90382148717739 & 0.111540211251835 \\[2pt]  -->

<!-- $\sigma_{eh}$ & 0.656751391241774 & 0.258262683575022 & 0.63234948433104 & 0.0192668720356221 & 0.12891726400829 & 0.0268555883325836 \\[2pt]  -->

<!-- $\sigma_{eyeh}$ & 0.688777773046045 & 13.1231225529083 & 0.999999986940504 & 7.05800130005596e-06 & 0.999771604778545 & 0.00609274849523753 \\[2pt]  -->

<!-- $\sigma_{nynh}$ & 0.568004544830427 & 0.112515260783059 &  &  &  &  \\[2pt]  -->

<!-- Log-likelihood value & -454.645000317534 &  & -464.079327351476 &  & -456.56846781196 &  \\[2pt]  -->
<!-- \bottomrule -->
<!-- \end{tabular} -->
<!-- \begin{tablenotes} -->
<!--             \footnotesize -->
<!--             \item {Weights of likelihood function: w1 = 0.8, w2 = 0.2, w3 = 0.003, w4 = 0.004 \\ -->
<!-- 						$l(\theta) = -w1\sum_{t=1}^{T}ln\lbrack(2\pi)^2|f_{t|t-1}|\rbrack -->
<!-- 						-w2\sum_{t=1}^{T}\eta'_{t|t-1}f^{-1}_{t|t-1}\eta_{t|t-1} -->
<!-- 						- w3*\sum_{t=1}^{T}(c_{yt}^2) - w4*\sum_{t=1}^{T}(c_{ht}^2)$} -->
<!--         \end{tablenotes} -->
<!-- \end{threeparttable}} -->


<!-- ## Results Regression Graphs: United States VAR(2) -->
<!-- ```{r, echo=FALSE} -->
<!-- knitr::include_graphics('../../HPCredit/Regression/VAR_2/Output/Graphs/HP_Credit_4graphs_US.pdf') -->
<!-- ``` -->

<!-- ## Results Regression Graphs: United Kingdom VAR(2) -->
<!-- ```{r, echo=FALSE} -->
<!-- knitr::include_graphics('../../HPCredit/Regression/VAR_2/Output/Graphs/HP_Credit_4graphs_GB.pdf') -->
<!-- ``` -->

<!-- ## Comparison with other decomposition methods: US -->
<!-- ```{r UKrobust, echo=FALSE, out.width='70%'} -->
<!-- knitr::include_graphics('../../HPCredit/Regression/AR_2/Output/graphs/HP_Credit_2graphs_US.pdf') -->
<!-- ``` -->

<!-- ## Comparison with other decomposition methods: UK -->
<!-- ```{r USrobust, echo=FALSE, out.width='70%'} -->
<!-- knitr::include_graphics('../../HPCredit/Regression/AR_2/Output/graphs/HP_Credit_2graphs_GB.pdf') -->
<!-- ``` -->


<!-- ## Conclusion -->
<!-- Dynamics of temporary components in housing and credit -->

<!-- - Evidence showing that past movement of a cycle has predictive power over the other cycle -->
<!-- - Extracting temporary and permanent components information gave insights on the dynamics of the two series -->
