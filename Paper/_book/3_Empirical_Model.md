# Empirical Methodology {#model}
## Overview



The total credit series is nonstationary. In order to extract a useful stationary credit signal to use as an early warning indicator for future financial crises, we first decompose the series into a nonstationary trend and a stationary cycle using various popularly studied filters in subsection \@ref(decomp). 

The idea behind using the credit gap as an early warning indicator is that a prolonged period of excessive credit growth could be linked to future financial crises. Therefore, we can use logistic regression to identify pre-crisis periods with unsustainable high credit gap values over a certain threshold.

In subsection \@ref(logistic-regression), we discuss strategies for identifying the dependent variable (pre-crisis periods) and the logistic regression empirical method. In subsection \@ref(metrics) we then discuss the metrics to determine the performance of a credit gap as an early warning indicator EWI model such as BIC, AIC values, Area Under Curve (AUC) of receiver operating characteristic, how we determine a policy loss function, optimize credit gap threshold and estimate the minimized Type I and Type II error rates. We will then propose a novel metric - partial standardized AUC (psAUC) that, when used in conjunction with other metrics, will provide more desirable properties in terms of policy implication and overcome some of the criticism that the traditional AUC metric receives.

This paper aims to overcome model uncertainty when using credit gap filters as an early warning indicator for future financial crises. Since each decomposition filter of the total credit series provides a stationary series that performs qualitatively differently from other filters as an EWI, we propose selecting the best gap candidates and performing model averaging to achieve model stability and improved out-of-sample prediction as proposed in [@raftery_bayesian_1995].

In subsection \@ref(modelselection), we will use the metrics discussed in subsection \@ref(logistic-regression) to select credit gap filters that perform well individually and in combination with other credit gaps. Then in subsection \@ref(model-average), we discuss the theory behind the Bayesian model average method, our model customization to fit our need, and the new metric (psAUC). 

Lastly, in subsection \@ref(weighted-gap-creation), for ease of policy implication, we propose the creation of a crisis-weighted credit gap that would inherit the information and features from the averaged model of 30 other credit gaps, and would perform as well as the averaged model prediction does.


<!--[Briefly discuss AUC section here]\
[Variable selection here]\
[Model Averaging here]\
[Weighted credit gap creation here]\-->

## Credit gap decompositions {#decomp}

\begin{align}
	100*\frac{Credit}{GDP} &= y_it = \tau_{itj} + c_{itj}
\end{align}


We started our variable selection process by creating 90 candidate one-sided credit gap measurements based on the literature.^[List of filters created is can be viewed in Appendix \@ref(filterslist)] The nonstationary Credit to GDP ratio series is decomposed into a nonstationary trend $\tau_{yit}$ and a stationary cycle credit gap $c_{itj}$ components. Once a country has more than 15 years of credit measurement available, we start storing its one-sided credit gap values onward. Our decomposition filter methods include one-sided Hodrick-Prescott, Hamilton (panel and non-panel setting), Moving Average, Structural Time-series model, Beveridge-Nelson, linear, quadratic, and polynomial decompositions. All are decomposed with full sample, rolling 15 years and 20 years rolling window feature when possible.

Apart from the filters that we already introduced in Chapter 3 - "Measuring credit gap" (Equations 3.1 - 3.5), the two additional filters we will use in this chapter are Moving Average, Structural Time-Series model filters that @beltran_optimizing_2021 introduced.^[Refer to their equation representations here in Appendix \@ref(ma-stm-eq)]

<!--Todo:
[List formula references for each decomposition method]\
[Full list of credit cycle created in appendix]\
[strength and weakness of each decomposition method if possible]\-->

## Early Warning Indicator - GLM Logistic regression {#logistic-regression}

We begin testing the fitness of the EWI model using credit gap measurements by implementing binary logistic regression. We identify our dependent variable as the periods of 5-12 quarters ahead of a systemic financial crisis. The underlying classification model assumes that the credit to GDP ratio gap will increase sharply as a response to an excessive credit increase due to expansionary monetary policy or a sharp decline in GDP, which is the ratio's denominator. When the credit gap is above a certain threshold for a prolonged period, it signals that the economy is at risk of a future financial crisis. The periods with excessive credit before financial crises will be labeled pre-crisis periods. 

It is also worth pointing out that there is no consensus on setting the periods to label as pre-crisis. The literature labeled pre-crisis periods with various ranges from 1-16 quarters before a crisis. We decided to use a labeling strategy with ideal policy implication properties. It is recommended that macroprudential policy takes more than four quarters to be effective because of policy implementation lag. As a result, a signal telling that the economy will experience a financial crisis in 1-4 quarters has little policy implication. Therefore, we start labeling the pre-crisis periods in the 5th quarter before a systemic crisis. We stop labeling in the 12th quarter before a crisis because implementing counter-cyclical policy too early will be ineffective in lowering the risk of a future crisis and would only exacerbate economic conditions by unnecessary credit tightening.

Equation \@ref(eq:logit) represents the binary logistic regression:

\begin{align} (\#eq:logit)
  pre.crisis_{it} \sim c_{itj} 
\end{align}

In which $i$ is the country indicator, and $j$ is the credit gap filter type. The binary dependent variable $pre.crisis_{it}$ takes values of 1 when the economy is between 5-12 quarters before a systemic financial crisis labeling the periods as "pre-crisis" positive. We discard measurements between 1-4 quarters before a crisis, during, and post-crisis management periods identified in Lo Duca et al. (2017) and Laeven and Valencia (2018). The measurements in these periods are discarded to avoid biased estimation as credit gaps behave erratically during a crisis. 

The indicator is set to 0 at other periods. Additionally, pre-crisis periods of imported crises identified in the dataset are set to 0 since the model aims to capture pre-crisis periods created by a country's excess credit growth, not from exogenous shocks. However, for labeling conformity, we still discard measurements of periods during and post-crisis of these imported crises, as countries experiencing imported crises could implement reactionary monetary policies.

<!--Todo:
[elaborate on why the strategy of identifying pre-crisis periods is used this way]\
[pros and cons]\
[alternatives]\ (not worth elaborating) (- individual quarters instead of 5-12)
[easy of use: choice]-->

## EWI performance metrics {#metrics}

### Likelihood values and BIC

The logistic regression model parameters are estimated by maximizing the cross-entropy log-likelihood values. The relationship between the BIC (Bayesian Information Criterion) and likelihood value is expressed in Equation \@ref(eq:BIC-lik). The model selection criterion here is to choose the filter method with a lower BIC value associated with a higher likelihood value and fitness of the general linearized model or a higher degree of freedom by using fewer explanatory variables.

### Area Under the Curve (AUC) of receiver operating characteristic (ROC) 

A receiver operating characteristic (ROC) curve in the EWI literature setting represents True Positive Rate (TPR) and False Positive Rate (FPR) Cartesian coordinates of different credit gap thresholds, which are used as indicators for identifying pre-crisis periods.^[Refer to Figure \@ref(fig:psAUCfig) for illustration] The credit gap thresholds are determined by the logistic regression model predicted response values which range from (0,1) and map increasingly with the credit gap magnitude values.

A logistic model is strictly preferred over another comparable model if all of the coordinates of its ROC curve are closer to the top-left region of the graph, which minimizes FPR and maximizes TPR. However, that is not always the case when we have such a clear-cut difference. Models can have overlapping ROC curves. To simplify the process of model selection in such cases, the area under the curve (AUC) of ROC metric is used.

\begin{align*}
AUC = \int_0^1 TPR d(FPR)
\end{align*}

Each logistic regression with a different gap measurement yields an Area Under Curve (AUC) of receiver operating characteristic value. There is an underlying assumption that the higher the AUC value is, the better the overall performance of a credit gap is as an EWI since, on average, its ROC curve has coordinates with higher TPR and lower FPR. 

True Positive Rate represents a model's predictive power (P) to identify pre-crisis periods correctly (positive case). $TPR = TP / (TP + FN)$. False Positive Rate represents the Type I error rate that a model misidentifies a calm, normal period (negative case) as a pre-crisis period (positive case). $FPR = FP / (FP + TN)$. Lastly, we discuss the False Negative Rate or the Type II error rate at which a model misidentifies a pre-crisis period (positive case) as a normal calm period (negative case). $FNR = 1 - TPR = FN / (TP + FN)$.^[Our notation of Type I and Type II error follows Beltran (2021) which deviated from previous literature.]

Central planners working with classification problems have dual objectives to minimize Type I and Type II errors. To simplify this problem, a policy loss function with the input of the two error types are used: 

\begin{align} (\#eq:policylossold)
L_{\theta,\rho}=\alpha TypeI(\theta)+(1-\alpha)TypeII(\theta)
\end{align}

With $\alpha = 0.5$ by default if policymakers are indifferent about the two types of errors. Here, the model selection criteria would be to select minimized policy loss function with the smallest combination of Type I and Type II error rates. 

A binary logistic regression model with a substantially higher AUC value will have smaller sets of Type I and Type II metrics values. Therefore, its optimized credit gap threshold value that minimizes the policy loss function would represent superior Type I and Type II error rates.

<!--[Talk about Policy Loss Function and TPR, FPR]-->
However, because the AUC value is an aggregate value representing information of the whole ROC curve, the area on its lower left corner, where the predictive power of the threshold (TPR) is low, and type II error rates are high, is not relevant for policy implications discussion. Before the Great Financial Crisis of 2008, central planners tended to weigh Type I errors more than Type II errors since the cost of misspecifying a financial crisis was not apparent, and a Type I error meant costing the economy unnecessary credit constraints by implementing reactionary policies. However, since 2009, there has been a shift in weighing Type II errors more as the cost of misspecifying a systemic financial crisis became significantly heavier than a Type I error. 

### Partial standardised AUC {#psAUC}
To overcome the issue of unnecessary information included in the full AUC. An approach to estimate only a partial relevant area under the ROC was proposed in @mcclish_analyzing_1989 and later implemented in the EWI setting by @detken_operationalising_2014. We will also discuss the standardization of the partial AUC metric (psAUC) in Equation \@ref(eq:psAUCeq).

Detken (2014) on partial standardized AUC:

>"Instead of considering only the full AUROC (e.g. Drehmann and Juselius, 2014), this paper also presents a partial standardized AUROC (psAUROC) that cuts off the area associated with a preference parameter of $\theta<0.5$."... 

>"While the psAUROC has been used extensively in the area of medical statistics to assess the performance of a classifier only in specific regions of the ROC curve (e.g., McClish, 1989 and Jiang et al., 1996), it is a new approach in the literature evaluating EWMs"...

>"The results reported in this paper show that the psAUROC can reveal useful additional information as long as the partial area does not become too restricted."

@detken_operationalising_2014 proposed cutting off the area representing the preference response parameter in a multivariate regression setting. However, this application does not directly translate to a univariate credit gap model. More relevantly, [@beltran_optimizing_2021] constrained the policy loss function to regions where TPR $\ge 2/3$ or Type II error rate $< 1/3$. They then estimated the policy loss function value at different points on the partial ROC curve by assigning different policy preference parameter values $\alpha$.

To merge these two ideas above and to solve the uncertainty issue of having to estimate policy loss function at different policy preference parameter values to determine model performance, we propose to restrict the consideration of the ROC curve to TPR $\ge 2/3$, then estimate the partial standardize psAUC of the restricted ROC curve region instead. Note in Equation \@ref(eq:pAUC). We estimated the partial area under to curve that represents TPR and TNR (instead of TPR and FNR) and took integral along the TPR axis. 

\begin{align} (\#eq:pAUC)
pAUC = \int_{\frac{2}{3}}^1 TNR \, d(TPR) = \int_{\frac{2}{3}}^1 specificity \, d(sensitivity)
\end{align}

Because we are limiting our analysis only to the portion of the ROC curve that satisfies TPR $\ge 2/3$, the policy loss function \@ref(eq:policylossold) used in previous literature tends to have a corner solution of optimized thresholds where TPR = 2/3. We propose using an alternative policy loss function that priorities points on the ROC closest to the top left regions where both Type I and II errors are the lowest:

\begin{align*}
L_{\theta,\rho}= TypeI(\theta)^2 + TypeII(\theta)^2 = (1 - sensitivity)^2 + (1 - specificity)^2
\end{align*}

The last step is to standardize the partial AUC value:

\begin{figure}

{\centering \includegraphics[width=0.7\linewidth]{../metadata/pAUC} 

}

\caption{Standardize partial AUC}(\#fig:psAUCfig)
\end{figure}

\begin{align} (\#eq:psAUCeq)
psAUC = \frac{1}{2}\left[ 1+ \frac{pAUC - min}{max - min}\right]
\end{align}

The standardization step helps with the comparison of EWI models' performance. Traditional AUC values range from 0 to 1, with 0.5 being the value for a null hypothesis model or an informationless guess. When only estimated partially, the partial AUC value will not retain the same range making it harder to interpret their meaning. Standardizing the partial AUC values restores the ranges of possible values to 0 and 1.

<!--(Discuss how standardization helps compare the performance of different EWI methods)-->

In section \@ref(empirical-results), we will discuss the relevance and performance of the psAUC as an EWI metric and the other metrics introduced in this subsection. 



## Variable Selection {#modelselection}

Our overall methodology goal is to implement model averaging of top candidate variables. In order to achieve that, we need to select top EWI candidates using the EWI performance criteria discussed in the previous section. We also search for models with combinations of variables that, when combined using positive weights, would have a better model fit than a univariate model would. We aim to select 29 credit gap measurements based on these two criteria.

Firstly, we compared performances of individual credit gaps using partial area under the curve (psAUC) values. Table \@ref(tab:varselect) ranked decomposition filters by psAUC. 




\begin{table}[H]

\caption{(\#tab:varselect)Top 30 credit gap measurements ranked by psAUC}
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{lrrr>{}rrrrr}
\toprule
Cycles & BIC & AIC & AUC & psAUC & c.Threshold & Type.I & Type.II & Policy.Loss.Function\\
\midrule
\cellcolor{gray!6}{null} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{0.5000} & \textbf{\cellcolor{gray!6}{0.5000}} & \cellcolor{gray!6}{} & \cellcolor{gray!6}{1.0000} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{1.0000}\\
c.bn6.r20 & -108.0679 & -114.4506 & 0.7048 & \textbf{0.6379} & 0.6581 & 0.3962 & 0.3019 & 0.2481\\
\cellcolor{gray!6}{c.hamilton28.panel} & \cellcolor{gray!6}{-149.8518} & \cellcolor{gray!6}{-156.2346} & \cellcolor{gray!6}{0.7107} & \textbf{\cellcolor{gray!6}{0.6359}} & \cellcolor{gray!6}{9.7674} & \cellcolor{gray!6}{0.3912} & \cellcolor{gray!6}{0.3066} & \cellcolor{gray!6}{0.2470}\\
c.hamilton13.panelr20 & -150.2442 & -156.6269 & 0.7036 & \textbf{0.6333} & 5.9895 & 0.4261 & 0.2547 & 0.2464\\
\cellcolor{gray!6}{c.hamilton24.panel} & \cellcolor{gray!6}{-134.4093} & \cellcolor{gray!6}{-140.7920} & \cellcolor{gray!6}{0.6991} & \textbf{\cellcolor{gray!6}{0.6322}} & \cellcolor{gray!6}{7.1794} & \cellcolor{gray!6}{0.4383} & \cellcolor{gray!6}{0.2689} & \cellcolor{gray!6}{0.2644}\\
\addlinespace
c.hamilton20.panelr20 & -151.5617 & -157.9445 & 0.7048 & \textbf{0.6313} & 7.9350 & 0.4321 & 0.3066 & 0.2807\\
\cellcolor{gray!6}{c.ma} & \cellcolor{gray!6}{-120.8108} & \cellcolor{gray!6}{-127.1936} & \cellcolor{gray!6}{0.6922} & \textbf{\cellcolor{gray!6}{0.6313}} & \cellcolor{gray!6}{5.7813} & \cellcolor{gray!6}{0.3989} & \cellcolor{gray!6}{0.3160} & \cellcolor{gray!6}{0.2590}\\
c.hamilton20.panelr15 & -135.3713 & -141.7540 & 0.6985 & \textbf{0.6312} & 7.5244 & 0.4616 & 0.2689 & 0.2854\\
\cellcolor{gray!6}{c.hamilton13.panelr15} & \cellcolor{gray!6}{-126.2968} & \cellcolor{gray!6}{-132.6796} & \cellcolor{gray!6}{0.6924} & \textbf{\cellcolor{gray!6}{0.6311}} & \cellcolor{gray!6}{6.5289} & \cellcolor{gray!6}{0.4297} & \cellcolor{gray!6}{0.2830} & \cellcolor{gray!6}{0.2647}\\
c.hamilton28.panelr20 & -164.6015 & -170.9842 & 0.7158 & \textbf{0.6302} & 10.8558 & 0.3948 & 0.2925 & 0.2414\\
\addlinespace
\cellcolor{gray!6}{c.hamilton24.panelr20} & \cellcolor{gray!6}{-155.8638} & \cellcolor{gray!6}{-162.2466} & \cellcolor{gray!6}{0.7096} & \textbf{\cellcolor{gray!6}{0.6301}} & \cellcolor{gray!6}{9.1672} & \cellcolor{gray!6}{0.4251} & \cellcolor{gray!6}{0.2830} & \cellcolor{gray!6}{0.2608}\\
c.hamilton24.panelr15 & -143.2235 & -149.6062 & 0.7033 & \textbf{0.6299} & 10.4963 & 0.3984 & 0.3160 & 0.2586\\
\cellcolor{gray!6}{c.hamilton20.panel} & \cellcolor{gray!6}{-126.8625} & \cellcolor{gray!6}{-133.2452} & \cellcolor{gray!6}{0.6907} & \textbf{\cellcolor{gray!6}{0.6288}} & \cellcolor{gray!6}{5.6212} & \cellcolor{gray!6}{0.4686} & \cellcolor{gray!6}{0.2830} & \cellcolor{gray!6}{0.2997}\\
c.hamilton28.panelr15 & -154.4533 & -160.8361 & 0.7091 & \textbf{0.6270} & 11.5510 & 0.3854 & 0.2972 & 0.2369\\
\cellcolor{gray!6}{c.hamilton13.panel} & \cellcolor{gray!6}{-133.9347} & \cellcolor{gray!6}{-140.3175} & \cellcolor{gray!6}{0.6922} & \textbf{\cellcolor{gray!6}{0.6250}} & \cellcolor{gray!6}{4.9769} & \cellcolor{gray!6}{0.4285} & \cellcolor{gray!6}{0.2877} & \cellcolor{gray!6}{0.2664}\\
\addlinespace
c.bn2.r20 & -109.3128 & -115.6955 & 0.6963 & \textbf{0.6218} & 0.2776 & 0.4080 & 0.3255 & 0.2724\\
\cellcolor{gray!6}{c.linear} & \cellcolor{gray!6}{-135.4069} & \cellcolor{gray!6}{-141.7896} & \cellcolor{gray!6}{0.6879} & \textbf{\cellcolor{gray!6}{0.6204}} & \cellcolor{gray!6}{3.9989} & \cellcolor{gray!6}{0.4616} & \cellcolor{gray!6}{0.2925} & \cellcolor{gray!6}{0.2986}\\
c.bn2 & -135.9914 & -142.3741 & 0.6842 & \textbf{0.6165} & 0.1864 & 0.4530 & 0.3113 & 0.3021\\
\cellcolor{gray!6}{c.bn6} & \cellcolor{gray!6}{-132.7915} & \cellcolor{gray!6}{-139.1742} & \cellcolor{gray!6}{0.6835} & \textbf{\cellcolor{gray!6}{0.6113}} & \cellcolor{gray!6}{0.4710} & \cellcolor{gray!6}{0.4371} & \cellcolor{gray!6}{0.2830} & \cellcolor{gray!6}{0.2712}\\
c.bn6.r15 & -54.9953 & -61.3781 & 0.6756 & \textbf{0.6070} & 0.5680 & 0.4179 & 0.3255 & 0.2806\\
\addlinespace
\cellcolor{gray!6}{c.bn2.r15} & \cellcolor{gray!6}{-83.9469} & \cellcolor{gray!6}{-90.3297} & \cellcolor{gray!6}{0.6749} & \textbf{\cellcolor{gray!6}{0.6047}} & \cellcolor{gray!6}{0.1349} & \cellcolor{gray!6}{0.4761} & \cellcolor{gray!6}{0.3302} & \cellcolor{gray!6}{0.3357}\\
c.poly4.r20 & 3.5738 & -2.8090 & 0.5772 & \textbf{0.6011} & 0.1651 & 0.4980 & 0.3302 & 0.3570\\
\cellcolor{gray!6}{BIS Basel gap} & \cellcolor{gray!6}{-121.5910} & \cellcolor{gray!6}{-127.9738} & \cellcolor{gray!6}{0.6733} & \textbf{\cellcolor{gray!6}{0.5960}} & \cellcolor{gray!6}{3.0578} & \cellcolor{gray!6}{0.4441} & \cellcolor{gray!6}{0.3255} & \cellcolor{gray!6}{0.3032}\\
c.bn4 & -169.1186 & -175.5014 & 0.6892 & \textbf{0.5943} & 1.2840 & 0.3837 & 0.3255 & 0.2532\\
\cellcolor{gray!6}{c.bn4.r15} & \cellcolor{gray!6}{-89.6147} & \cellcolor{gray!6}{-95.9975} & \cellcolor{gray!6}{0.6669} & \textbf{\cellcolor{gray!6}{0.5929}} & \cellcolor{gray!6}{0.4435} & \cellcolor{gray!6}{0.4792} & \cellcolor{gray!6}{0.2925} & \cellcolor{gray!6}{0.3152}\\
\addlinespace
c.bn5.r20 & -99.7674 & -106.1501 & 0.6744 & \textbf{0.5928} & 0.5016 & 0.4234 & 0.3302 & 0.2883\\
\cellcolor{gray!6}{c.stm.r15} & \cellcolor{gray!6}{-79.5531} & \cellcolor{gray!6}{-85.9358} & \cellcolor{gray!6}{0.6575} & \textbf{\cellcolor{gray!6}{0.5924}} & \cellcolor{gray!6}{2.0027} & \cellcolor{gray!6}{0.4778} & \cellcolor{gray!6}{0.3160} & \cellcolor{gray!6}{0.3281}\\
c.hp125k & -92.2897 & -98.6725 & 0.6562 & \textbf{0.5924} & 2.5216 & 0.4547 & 0.3302 & 0.3158\\
\cellcolor{gray!6}{c.hp221k} & \cellcolor{gray!6}{-106.8842} & \cellcolor{gray!6}{-113.2670} & \cellcolor{gray!6}{0.6656} & \textbf{\cellcolor{gray!6}{0.5921}} & \cellcolor{gray!6}{2.6641} & \cellcolor{gray!6}{0.4561} & \cellcolor{gray!6}{0.3160} & \cellcolor{gray!6}{0.3079}\\
c.linear.r15 & -66.3472 & -72.7300 & 0.6474 & \textbf{0.5916} & 2.6344 & 0.4626 & 0.3302 & 0.3230\\
\addlinespace
\cellcolor{gray!6}{c.hp400k.r15} & \cellcolor{gray!6}{-67.1228} & \cellcolor{gray!6}{-73.5055} & \cellcolor{gray!6}{0.6472} & \textbf{\cellcolor{gray!6}{0.5912}} & \cellcolor{gray!6}{2.6223} & \cellcolor{gray!6}{0.4592} & \cellcolor{gray!6}{0.3255} & \cellcolor{gray!6}{0.3168}\\
\bottomrule
\end{tabular}}
\end{table}

<!--[Discuss data shown on table]\
[- estimated and compute values BIC, AIC, AUC, psAUC]\
[- BIC, AIC : overall fitness of linearized binary logistic regression model]\
[- AUC: Area Under Curve of receiver operating characteristic (ROC) curve]\

[- we then detected the optimized threshold of credit gap that minimize the policy loss function]\
[- Policy loss function: details here]\
- [- Deviated from previous loss function in the literature (closest to top left)]\
- [- Loss function: if not corner solution at TPR = 2/3, discussion would be trivial]\-->


Secondly, we test for performances of multivariate models with combinations of different credit gaps.

\begin{align*}
Model_k :  pre.crisis_{ti} \sim \sum\nolimits_j \beta_j * credit.gap_{tij}
\end{align*}

We implement our gaps combination model selection using Markov Chain Monte Carlo Model Comparison ($MC^3$) method developed by @madigan_bayesian_1995. The method assigns a posterior probability for different credit gaps being selected in the most likely models/combinations with the lowest BIC values. With 90 variables, there are $2^{90} = 10^{26}$ possible subsets of combinations to choose from.  @babecky_banking_2014 used this $MC^3$ method to identify potential variables in multivariate EWI models. For more efficient search implementation, each variable is given increasing weights depending on their univariate EWI performance. We then estimated the posterior probability of each variable included in the most likely models using 4,000,000 MCMC iterations.


\tiny
\begin{table}[H]

\caption{(\#tab:varselectMC3)Top 25 credit gap measurements ranked by MC3 probability}
\centering
\begin{tabular}[t]{lllr}
\toprule
Variable & Pr(B!=0) & Variable & Pr(B!=0)\\
\midrule
\cellcolor{gray!6}{Intercept} & \cellcolor{gray!6}{1} & \cellcolor{gray!6}{c.bn2} & \cellcolor{gray!6}{0.3721}\\
c.hamilton28\_panel & 0.999968 & c.bn3\_r10 & 0.2478\\
\cellcolor{gray!6}{c.bn7\_r15} & \cellcolor{gray!6}{0.93097125} & \cellcolor{gray!6}{c.hp400k} & \cellcolor{gray!6}{0.2309}\\
c.poly3 & 0.915792 & c.hamilton24\_r20 & 0.2175\\
\cellcolor{gray!6}{c.hamilton13\_panel} & \cellcolor{gray!6}{0.733247} & \cellcolor{gray!6}{c.hamilton13\_r20} & \cellcolor{gray!6}{0.1958}\\
\addlinespace
c.hamilton13\_r10 & 0.70601225 & c.bn2\_r10 & 0.1916\\
\cellcolor{gray!6}{c.hamilton28} & \cellcolor{gray!6}{0.65141375} & \cellcolor{gray!6}{c.stm} & \cellcolor{gray!6}{0.1894}\\
c.hamilton13 & 0.6438865 & c.hamilton28\_r20 & 0.1799\\
\cellcolor{gray!6}{c.bn3\_r15} & \cellcolor{gray!6}{0.514728} & \cellcolor{gray!6}{c.hp\_r20} & \cellcolor{gray!6}{0.1794}\\
c.hp3k & 0.4888055 & c.hp & 0.1761\\
\addlinespace
\cellcolor{gray!6}{c.hp3k\_r20} & \cellcolor{gray!6}{0.4887615} & \cellcolor{gray!6}{c.bn8\_r20} & \cellcolor{gray!6}{0.1561}\\
c.poly6 & 0.39826475 & c.linear\_r20 & 0.1526\\
\cellcolor{gray!6}{} & \cellcolor{gray!6}{} & \cellcolor{gray!6}{c.hp221k} & \cellcolor{gray!6}{0.1440}\\
\bottomrule
\multicolumn{4}{l}{\rule{0pt}{1em}\textit{Note: }}\\
\multicolumn{4}{l}{\rule{0pt}{1em}Pr(B!=0) is the posterior probability of the variable being selected}\\
\end{tabular}
\end{table}
\normalsize

Using the two results table above, We selected our candidate gaps not only by their psAUC values but also by their other metrics and Type of decomposition methods and features to ensure the robustness of the model averaging method.

The 29 selected decomposition filters are reported in Figure \@ref(fig:weightgraph). 29 is also the number of recommended variables to use to start the Model Averaging method in the following subsection.


## Model averaging {#model-average}

The Bayesian Model Average method is formalized in @raftery_bayesian_1995 to account for model uncertainty and achieve better prediction results in out-of-sample forecasts.

Equation \@ref(eq:posteriorprobweight) represents a Model k's posterior probability or weight in the averaging process:
\begin{align} (\#eq:posteriorprobweight)
  P(M_k|D) = \frac{P(D|M_k)P(M_k)}{\sum\nolimits_{l=1}^K P(D|M_l)P(M_l)} 
  \approx \frac{exp(-\frac{1}{2}BIC_k)}{\sum\nolimits_{l=1}^K exp(-\frac{1}{2}BIC_l)}
\end{align}

Where $P(M_k)$ is model prior probability and can be ignored if all models are assumed to equal prior weights. $P(D|M_k)$ is marginal likelihood. And $P(D|M_k) \propto exp(-\frac{1}{2}BIC_k)$

In which: 
\begin{align} (\#eq:BIC-lik)
BIC_k = 2log (Bayesfactor_{sk}) = \chi^2_{sk} - df_klog(n)
\end{align}

The subscript s indicates the saturated model. $\chi^2_{sk}$ is the deviance of model K from the saturated model.  $\chi^2_{sk} = 2(ll(Ms) - ll(Mk))$ . And $ll(Mk)$ is the log-likelihood of model Mk given data D. A model with better fitness will have a higher log-likelihood value, hence smaller deviance and smaller BIC value. 

###  Alternate BIC measurement and three-pass filter.

We propose using psAUC in addition to the log-likelihood in the measurement of deviance. Hence, an alternative BIC value can be estimated at:

\begin{align} (\#eq:altBIC)
BIC_{alt,k} &= 2log (Bayesfactor_{alt,sk}) \\
&= 2(1000*(psAUC_s-psAUC_k)) - df_klog(n)
\end{align}

We scaled the psAUC value by 1000 since $0<psAUC<1$. Also, by design, the saturated model has $psAUC_s=1$.

### Final search steps for best models combinations

All of the following search steps described below are done in quasi-real time. As additional quarterly data are added, we will perform the search steps again to find the best possible combinations of models that fit the updated data.

From the set of 29 candidate filter gaps selected in the previous subsection, we add an intercept parameter to make a list of 30 possible variables from which to choose a subset of combinations. The number of possible subsets of combinations is still significantly high at $2^{30} = 10^6$ possible combinations subset, which will cost us computation time and resources. We still need to limit the number of possible subsets further to consider. @furnival_regressions_2000 proposed an algorithm for computing the residual sums of squares for all possible regressions with minimum computing power requirement. With a "leap and bound" technique, the paper found it possible to find the best subsets without examining all possible subsets. This feature reduced the number of operations required to find the best subsets by several orders of magnitude. 

Using the list of reduced subsets using "leap and bound" algorithm, we further filter the number of possible gaps combinations using a method called Occam's razor window described in @raftery_bayesian_1995. The Bayesian Model Average (BMA) R package has an inbuilt function to filter out less likely models using Occam's razor window method. The package also allowed for a multiple-pass filter through a custom function. 

In this variable selection step using Occam's Razor, we will first select the models with BIC values within an Occam's Razor window of the best-fitted model with the lowest BIC value. Secondly, we repeat the same step above but regarding the alternative BIC value derived from psAUC as in Equation \@ref(eq:altBIC).

Lastly, we filter out models with negative weight combinations for model averaging stability. In order to reach feasible results in these three-pass filter steps, we relax the Occam's razor (OC) value from the default value of 20 to 2000, corresponding to a change in the actual search window ( $2*ln(OC)$ ) that searches for models with six times less likelihood value to 15 times.


### Posterior distribution of coefficients of interest:

With all possible candidate models of credit gap combinations selected, we can start implementing the model averaging steps. First, we estimate each model k separately, then store their maximum likelihood estimated parameters $\beta_j(k)$ and their standard deviations$. We use the notation $\beta_j(k)$ as the coefficient of credit gap j ($c_j$) in a logistic regression model k against pre-crisis indicator.

We are interested in the averaged estimate of the parameter $\beta_j(K)$ across all models Ks, this is the estimate of the parameter of interest $\beta_j$ in an averaged model. When considering a particular $\beta_1$, the parameter has this probability distribution in a Bayesian averaged model setting.

\begin{align} (\#eq:postprob)
p(\beta_1|D, \beta_1\ne 0) = \sum\nolimits_{A_1} p(\beta_1|D,M_k)p'(M_k|D)
\end{align}

Where $p'(M_k|D)=p(M_k|D)/ pr[\beta_1 \ne 0|D]$. And $pr[\beta_1 \ne 0|D] = \sum\limits_{A_1} p(M_k|D)$. $p(M_k|D)$ is the posterior probability discussed in Equation \@ref(eq:posteriorprobweight).

While $pr[\beta_1 \ne 0|D]$ is the probability that $\beta_1$ is in the averaged model; and $A_1= \{M_k: k=1,...,K; \beta_1 \ne 0\}$ is the set of models that includes $\beta_1$.


### estimation of coefficients of interest:

From Equation \@ref(eq:postprob), an expected value of the parameter of interest $\beta_1$ could be estimated at:

\begin{align}
\hat{\beta}_1 &= E[\beta_1|D, \beta_1\ne 0] = \sum\limits_{A_1} \hat{\beta}_1(k)p'(M_k|D)
\\
SD^2[\beta_1|D, \beta_1\ne 0] &=[\sum\limits_{A_1}[se_1^2(k)+]+\hat{\beta_1}(k)]p'(M_k|D)
- E[\beta_1|D, \beta_1\ne 0]^2
\end{align}


Where $\hat{\beta}_1(k)$ and $se_1^2(k)$ are respectively the MLE and standard error of $\beta_1$ under the model $M_k$.

So far, we have established averaging estimated parameters using the Bayesian Model Average framework. The response values predicted by the generalized linear model regression can perform better than any individual model in out-of-sample prediction. However, this approach only solves half of the model uncertainty problem. Since we use a multivariate model, deducting an optimized credit gap threshold is still impossible through minimizing the policy loss function. We propose a solution to this issue in the following subsection.

## Weighted credit gap creation {#weighted-gap-creation}

Our motivation to create an averaged weighted gap is to find a solution to the issue of not being able to determine an optimized credit threshold discussed above. Since all credit gap variables measure one set of information: how much in absolute value the total credit series deviated from its long-run trend, we can strategically assign weights to them to create a weighted credit gap.

Our objective is to assign weights to the credit gaps to combine them and create a single credit gap that performs as well as the multivariate Bayesian averaged model in the previous subsection \@ref(model-average). After creating the weighted cycle, we can perform an optimized credit gap threshold analysis, assign a policy loss function value, and compare its EWI performance with other credit gap filters.

Multivariate GLM binary logistic predicted response values: 
\begin{align} (\#eq:glmpredicteq)
\widehat{pre.crisis}_{ti} = \widehat{probability}_{ti} = \frac {1}{1+exp(-(a+\sum\nolimits_j \hat{\beta}_j c_{tij}))}
\end{align}

From the previous subsection \@ref(model-average), in a Bayesian averaged model: $\hat{\beta}_j$ = $E[\beta_j|D, \beta_j\ne 0] = \sum\limits_{A_j} \hat{\beta}_j(k)p'(M_k|D)$. 

Using the information in Equation \@ref(eq:glmpredicteq), we propose creating a single weighted credit gap $\hat{c}_{ti}$ that satisfies:
\begin{align*}
\frac {1}{1+exp(-(a+\hat{\beta} \hat{c}_{ti}))}= \frac {1}{1+exp(-(a+\sum\nolimits_j \hat{\beta}_j c_{tij}))} \\
\end{align*}
Or
\begin{align}
\hat{\beta} \hat{c}_{ti} = \sum\limits_j \hat{\beta}_j c_{tij}
\end{align}

This condition allows us to create a weighted gap $\hat{c}_{ti}$ that will have similar predicted response values and averaged characteristics of the averaged decomposition filters selected. Additionally, to further simplify construction of the weighted gap, we then propose $\hat{\beta} = \sum\nolimits_j \hat{\beta}_j$.

Therefore, 

\begin{align}
\hat{c}_{ti} = \frac{\sum\nolimits_j (\hat{\beta}_j c_{tij})}{\hat{\beta}} = \frac{\sum\nolimits_j (\hat{\beta}_j c_{tij})}{\sum\nolimits_j\hat{\beta}_j} = \sum\nolimits_j w_j c_{tij}
\end{align}

The weight of each candidate credit gap j is $w_j = \frac{\hat{\beta}_j}{\sum\nolimits_j\hat{\beta}_j}$, which is the fraction of the estimate of coefficient $\beta_j$ in the averaged model over the sum of the parameters of all selected credit gaps.

### One-sided crisis-weighted averaged credit gap

We save the weights $w_j$ at every incremental period $t$ of available data to create a one-sided weight vector $w_{tj}$. In the next section, Figure \@ref(fig:weightgraph) illustrates time series of changes in the weights of credit gaps. We estimate the first 15 years of data available for stable model implementation as a full sample regression and assign the weights as constant during that period.

To create one-sided crisis weighted averaged credit gap for each country $i$ ($\hat{c}_{ti}$), we compute:

\begin{align}
\hat{c}_{ti,one-sided} = \sum\nolimits_{j} w_{tj} * c_{tij}
\end{align}

At this point, we have established a framework to create a one-sided crisis weighted averaged credit gap. In the next section, Empirical Results, we will compare the performance as an EWI of this one-sided crisis weighted credit gap (one-sided weighted gap) with other top candidate credit gaps.

