# EMPIRICAL MODEL

## Credit gaps decompositions

\begin{align}
	100*\frac{Credit}{GDP} &= y_t = \tau_{yt} + c_{yt}
\end{align}

We created 90 candidate one-sided credit gap measurements based on the literature. Once a country has more than 15 years of credit measurement available, we start storing its one-sided credit gap values onward. Our decomposition methods include one sided Hodrick-Prescott filter, Hamilton filter (panel and non-panel setting), Moving Average, Structural Time-series model, linear, quadratic and polynomial decompositions, all are decomposed with full sample, rolling 15 years and 20 years rolling window settings.



## Early Warning Indicator - Logistic regression:

\begin{align}****
  pre.crisis_{ti} \sim credit.gap_{tij}
\end{align}

- $i$ is country indicator. $j$ is credit gap filter type

- where $pre.crisis_{it}=$  1 or 0 

- The pre-crisis indicator is set to 1 when t is between 5-12 quarters before a systemic crisis. 
	
- We discard measurements between 1-4 quarters before a crisis, periods during a crisis and post-crisis periods identified in Lo Duca et al. (2017) and Laeven and Valencia (2018). 
  + The indicator is set to 0 at other periods.
  + pre-crisis periods of imported crises identified in the dataset are also set to 0. However, we still discard measurements of periods during and post-crisis for imported  crises.

## AUROC 
Each logistic regression with a different gap measurement yields a Area Under Curve (AUC) of receiver operating characteristic value. There is an underlying assumption that the higher the AUC value is the better overall performance of a credit gap is as an EWI. 

- However, the AUC value received some criticism regarding the area on its lower left corner, where the predictive power of the threshold (TPR) is low.

\begin{align*}
AUC = \int_0^1 TPR d(FPR)
\end{align*}

A ROC curve in the EWI setting represents True Positive Rate (TPR) and False Positive Rate (FPR) of different credit gap thresholds indicating a pre-crisis period. The thresholds are determined by the logistic regression predicted probability values.

## partial standardised AUROC (psAUROC)
To overcome the issue of unnecessary information included in the full AUC. An approach to estimate partial AUC was proposed.

Detken (2014) on partial standardized AUC:

>"Instead of considering only the full AUROC (e.g. Drehmann and Juselius, 2014), this paper also presents a partial standardised AUROC (psAUROC) that cuts off the area associated with a preference parameter of $\theta<0.5$."... 

>"While the psAUROC has been used extensively in the area of medical statistics to assess the performance of a classifier only in specific regions of the ROC curve (e.g. McClish, 1989 and Jiang et al., 1996), it is a new approach in the literature evaluating EWMs"...

>"The results reported in this paper show that the psAUROC can reveal useful additional information as long as the partial area does not become too restricted."

## pAUROC (or pAUC)

Beltran (2021) constrainted the policy loss function to TPR $\ge 2/3$ or Type II error rate $< 1/3$. They then estimated the policy loss function value at different points on the ROC curve by assigning different policy preferences $\alpha$.

$\Rightarrow$ In this paper, we propose to restrict the consideration of the ROC curve to TPR $\ge 2/3$, then estimate the psAUC of the restricted ROC curve region instead. *Our notation of Type I and Type II error follows Beltran (2021) which deviated from previous literature.

\begin{align}
pAUROC = \int_{\frac{2}{3}}^1 TNR \, d(TPR) = \int_{\frac{2}{3}}^1 specificity \, d(sensitivity)
\end{align}

- TNR = 1- FPR
- FPR = Type I error rate, FNR = Type II error rate

## standardize psAUROC - Detken (2014)


\begin{center}\includegraphics[width=0.7\linewidth]{../metadata/pAUC} \end{center}

\begin{align}
psAUROC = \frac{1}{2}\left[ 1+ \frac{pAUROC - min}{max - min}\right]
\end{align}

# Model selection and averaging
## Variable selection
### Comparing performance of individual credit gaps
Using partial area under the curve (psAUC) values

### Test for gaps combination performance
Using Markov Chain Monte Carlo Model Comparison ($MC^3$) developed by Madigan and York (1995). The method assigns posterior probability for different credit gaps being selected in most likely models/combinations. Babecky (2014) used this $MC^3$ method to identify potential variables in EWI models.

\begin{align*}
Model_k :  pre.crisis_{ti} \sim \sum\nolimits_j \beta_j * credit.gap_{tij}
\end{align*}

### Variable selection
We selected 29 credit gap measurements based on these 2 criteria.


## Variable selection (top 23 gaps ranked by psAUC)

\begin{table}[H]
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{lrrr>{}rrrrr}
\toprule
Cycles & BIC & AIC & AUC & psAUC & c.Threshold & Type.I & Type.II & Policy.Loss.Function\\
\midrule
null & 0.0000 & 0.0000 & 0.5000 & \textbf{0.5000} & NA & 1.0000 & 0.0000 & 1.0000\\
c.bn6.r20 & -108.0679 & -114.4506 & 0.7048 & \textbf{0.6379} & 0.6581 & 0.3962 & 0.3019 & 0.2481\\
c.hamilton28.panel & -149.8518 & -156.2346 & 0.7107 & \textbf{0.6359} & 9.7674 & 0.3912 & 0.3066 & 0.2470\\
c.hamilton13.panelr20 & -150.2442 & -156.6269 & 0.7036 & \textbf{0.6333} & 5.9895 & 0.4261 & 0.2547 & 0.2464\\
c.hamilton24.panel & -134.4093 & -140.7920 & 0.6991 & \textbf{0.6322} & 7.1794 & 0.4383 & 0.2689 & 0.2644\\
\addlinespace
c.hamilton20.panelr20 & -151.5617 & -157.9445 & 0.7048 & \textbf{0.6313} & 7.9350 & 0.4321 & 0.3066 & 0.2807\\
c.ma & -120.8108 & -127.1936 & 0.6922 & \textbf{0.6313} & 5.7813 & 0.3989 & 0.3160 & 0.2590\\
c.hamilton20.panelr15 & -135.3713 & -141.7540 & 0.6985 & \textbf{0.6312} & 7.5244 & 0.4616 & 0.2689 & 0.2854\\
c.hamilton13.panelr15 & -126.2968 & -132.6796 & 0.6924 & \textbf{0.6311} & 6.5289 & 0.4297 & 0.2830 & 0.2647\\
c.hamilton28.panelr20 & -164.6015 & -170.9842 & 0.7158 & \textbf{0.6302} & 10.8558 & 0.3948 & 0.2925 & 0.2414\\
\addlinespace
c.hamilton24.panelr20 & -155.8638 & -162.2466 & 0.7096 & \textbf{0.6301} & 9.1672 & 0.4251 & 0.2830 & 0.2608\\
c.hamilton24.panelr15 & -143.2235 & -149.6062 & 0.7033 & \textbf{0.6299} & 10.4963 & 0.3984 & 0.3160 & 0.2586\\
c.hamilton20.panel & -126.8625 & -133.2452 & 0.6907 & \textbf{0.6288} & 5.6212 & 0.4686 & 0.2830 & 0.2997\\
c.hamilton28.panelr15 & -154.4533 & -160.8361 & 0.7091 & \textbf{0.6270} & 11.5510 & 0.3854 & 0.2972 & 0.2369\\
c.hamilton13.panel & -133.9347 & -140.3175 & 0.6922 & \textbf{0.6250} & 4.9769 & 0.4285 & 0.2877 & 0.2664\\
\addlinespace
c.bn2.r20 & -109.3128 & -115.6955 & 0.6963 & \textbf{0.6218} & 0.2776 & 0.4080 & 0.3255 & 0.2724\\
c.linear & -135.4069 & -141.7896 & 0.6879 & \textbf{0.6204} & 3.9989 & 0.4616 & 0.2925 & 0.2986\\
c.bn2 & -135.9914 & -142.3741 & 0.6842 & \textbf{0.6165} & 0.1864 & 0.4530 & 0.3113 & 0.3021\\
c.bn6 & -132.7915 & -139.1742 & 0.6835 & \textbf{0.6113} & 0.4710 & 0.4371 & 0.2830 & 0.2712\\
c.bn6.r15 & -54.9953 & -61.3781 & 0.6756 & \textbf{0.6070} & 0.5680 & 0.4179 & 0.3255 & 0.2806\\
\addlinespace
c.bn2.r15 & -83.9469 & -90.3297 & 0.6749 & \textbf{0.6047} & 0.1349 & 0.4761 & 0.3302 & 0.3357\\
c.poly4.r20 & 3.5738 & -2.8090 & 0.5772 & \textbf{0.6011} & 0.1651 & 0.4980 & 0.3302 & 0.3570\\
BIS Basel gap & -121.5910 & -127.9738 & 0.6733 & \textbf{0.5960} & 3.0578 & 0.4441 & 0.3255 & 0.3032\\
c.bn4 & -169.1186 & -175.5014 & 0.6892 & \textbf{0.5943} & 1.2840 & 0.3837 & 0.3255 & 0.2532\\
c.bn4.r15 & -89.6147 & -95.9975 & 0.6669 & \textbf{0.5929} & 0.4435 & 0.4792 & 0.2925 & 0.3152\\
\addlinespace
c.bn5.r20 & -99.7674 & -106.1501 & 0.6744 & \textbf{0.5928} & 0.5016 & 0.4234 & 0.3302 & 0.2883\\
\bottomrule
\end{tabular}}
\end{table}


## Variable Selection (MC3)
\tiny
\begin{table}[H]
\centering
\begin{tabular}[t]{lllr}
\toprule
Variable & Pr(B!=0) & Variable & Pr(B!=0)\\
\midrule
Intercept & 1 & c.bn2 & 0.3721\\
c.hamilton28\_panel & 0.999968 & c.bn3\_r10 & 0.2478\\
c.bn7\_r15 & 0.93097125 & c.hp400k & 0.2309\\
c.poly3 & 0.915792 & c.hamilton24\_r20 & 0.2175\\
c.hamilton13\_panel & 0.733247 & c.hamilton13\_r20 & 0.1958\\
\addlinespace
c.hamilton13\_r10 & 0.70601225 & c.bn2\_r10 & 0.1916\\
c.hamilton28 & 0.65141375 & c.stm & 0.1894\\
c.hamilton13 & 0.6438865 & c.hamilton28\_r20 & 0.1799\\
c.bn3\_r15 & 0.514728 & c.hp\_r20 & 0.1794\\
c.hp3k & 0.4888055 & c.hp & 0.1761\\
\addlinespace
c.hp3k\_r20 & 0.4887615 & c.bn8\_r20 & 0.1561\\
c.poly6 & 0.39826475 & c.linear\_r20 & 0.1526\\
 &  & c.hp221k & 0.1440\\
\bottomrule
\end{tabular}
\end{table}
\normalsize

# Model Averaging

# Model averaging

## Bayesian Model Averging
The Bayesian Model Average method is formalized in Raftery (1995) to account for model uncertainty.

### Model posterior probability
equation (33): Model k posterior probability (weight):
\begin{align}
  P(M_k|D) = \frac{P(D|M_k)P(M_k)}{\sum\nolimits_{l=1}^K P(D|M_l)P(M_l)} 
  \approx \frac{exp(-\frac{1}{2}BIC_k)}{\sum\nolimits_{l=1}^K exp(-\frac{1}{2}BIC_l)}
\end{align}

- Where $P(M_k)$ is model prior probability and can be ignored if all models are assumed equal prior weights. 

- $P(D|M_k)$ is marginal likehood. And $P(D|M_k) \propto exp(-\frac{1}{2}BIC_k)$

- In which $BIC_k = 2log (Bayesfactor_{sk}) = \chi^2_{sk} - df_klog(n)$. s indicates the saturated model.

## Model posterior probability
- $BIC_k = 2log (Bayesfactor_{sk}) = \chi^2_{sk} - df_klog(n)$
- $\chi^2_{sk}$ is the deviance of model K from the the saturated model
  + $\chi^2_{sk} = 2(ll(Ms) - ll(Mk))$
  + $ll(Mk)$ is the log-likelihood of model Mk given data D

###  Alternate deviance measurement
We propose using psAUC instead of log-likelihood in the measurement of deviance. Hence, an alternative BIC value can be estimated at:

\begin{align}
BIC_{alt,k} &= 2log (Bayesfactor_{alt,sk}) \\
&= 2(1000*(psAUC_s-psAUC_k)) - df_klog(n)
\end{align}
- We scaled the psAUC value by 1000 since $0<psAUC<1$. Also, by design, $psAUC_s=1$.

## Posterior distribution of coefficients of interest:

$\beta_j$ is the coefficient of credit gap j ($c_j$) in a logistic regression model k against pre-crisis indicator. When considering a particular $\beta_1$ :

\begin{align*}
p(\beta_1|D, \beta_1\ne 0) = \sum\nolimits_{A_1} p(\beta_1|D,M_k)p'(M_k|D)
\end{align*}


- where $p'(M_k|D)=p(M_k|D)/ pr[\beta_1 \ne 0|D]$
- and $pr[\beta_1 \ne 0|D] = \sum\limits_{A_1} p(M_k|D)$
  + this is the probability that $\beta_1$ is in the averaged model
  + $A_1= \{M_k: k=1,...,K; \beta_1 \ne 0\}$, is the set of models that includes $\beta_1$

## Approximation of Bayesian point estimate:

\begin{align}
\hat{\beta}_1 = E[\beta_1|D, \beta_1\ne 0] = \sum\limits_{A_1} \hat{\beta}_1(k)p'(M_k|D)
\end{align}

$SD^2[\beta_1|D, \beta_1\ne 0] =[\sum\limits_{A_1}[se_1^2(k)+]+\hat{\beta_1}(k)]p'(M_k|D)
- E[\beta_1|D, \beta_1\ne 0]^2$

- Where $\hat{\beta}_1(k)$ and $se_1^2(k)$ are respectively the MLE and standard error of $\beta_1$ under the model $M_k$. (Leamer 1978, p.118; Raftery 1993a)


# Weighted credit gap creation
## Weighted averaged credit gap - motivation
GLM binomial estimation: 
\begin{align*}
\widehat{pre.crisis}_{ti} = \widehat{probability}_{ti} = \frac {1}{1+exp(-(a+\sum\nolimits_j \hat{\beta}_j c_{tij}))}
\end{align*}

- With $\hat{\beta}_j$ = $E[\beta_j|D, \beta_j\ne 0] = \sum\limits_{A_j} \hat{\beta}_j(k)p'(M_k|D)$


$\Rightarrow$ We propose a single weighted credit gap $\hat{c}_{ti}$ that satisfies:
\begin{align*}
\frac {1}{1+exp(-(a+\hat{\beta} \hat{c}_{ti}))}= \frac {1}{1+exp(-(a+\sum\nolimits_j \hat{\beta}_j c_{tij}))} \\
\end{align*}
OR
\begin{align}
\sum\limits_j \hat{\beta}_j c_{tij} = \hat{\beta} \hat{c}_{ti}
\end{align}

## Weighted averaged credit gap - creation
\begin{align*}
\sum\limits_j \hat{\beta}_j c_{tij} = \hat{\beta} \hat{c}_{ti}
\end{align*}

We then propose $\hat{\beta} = \sum\nolimits_j \hat{\beta}_j$

Therefore, 

\begin{align}
\hat{c}_{ti} = \frac{\sum\nolimits_j (\hat{\beta}_j c_{tij})}{\sum\nolimits_j\hat{\beta}_j} = \sum\nolimits_j w_j c_{tij}
\end{align}

The weight of each candidate credit gap j is $w_j = \frac{\hat{\beta}_j}{\sum\nolimits_j\hat{\beta}_j}$

## One-sided crisis weighted averaged credit gap

- The weight of each candidate credit gap j is $w_j = \frac{\hat{\beta}_j}{\sum\nolimits_j\hat{\beta}_j}$

- We save the weights $w_j$ at every incremental period $t$ of available data to create a one-sided weight vector $w_{tj}$. 

$\Rightarrow$ To create one-sided crisis weighted averaged credit gap for each country $i$ ($\hat{c}_{ti}$), we compute:
\begin{align}
\hat{c}_{ti,one-sided} = \sum\nolimits_{j} w_{tj} * c_{tij}
\end{align}

## Weights stacked graph
Weights are restricted to be positive to ensure stability

\begin{center}\includegraphics[width=1\linewidth]{../Data/Output/Graphs/Weights_stack} \end{center}

## Weights series graph

\begin{center}\includegraphics[width=1\linewidth]{../Data/Output/Graphs/Weights_series} \end{center}
