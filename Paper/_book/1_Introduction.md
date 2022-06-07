# INTRODUCTION
- To overcome model uncertainty in using credit gap as an early warning indicator (EWI) of systemic financial crises, we propose using model averaging of different credit gap measurements. The method is based on Bayesian Model Average - Raftery (1995)

- Area under the curve of operating characteristic (AUROC or AUC) has been widely used as a criterion to determine the performance of a EWI. But it has received some criticism regarding the lower left area of the curve representing low predictive ability of the indicator.
- Borio and Drehmann (2009) and Beltran et al (2021) proposed a policy loss function constraining the relevance of the curve measurement to just a portion where Type II error rate is less than 1/3 or at least 2/3 of the crises are predicted.    
- Detken (2014) proposed using partial standardized area under the curve (psAUC) as an alternative measurement of the performance of an EWI.

Our contribution: 
- Compare different credit gap measurements' performance as EWIs using a new criterion - partial standarized AUC (psAUC) contraining Type II error < 1/3.
- Overcome model uncertainty by implementing model averaging. We incoporated psAUC values in the model selection and weighting process, instead of AUC or BIC values.
- For ease of policy implication, we propose a single credit gap measurement from weighted averaging other popularly studied credit gap measurements.

# LITERATURE REVIEW

Beltran (2021) - measured and the performance of BIS Basel credit gap, Structural Time Series model (STM) gap, Moving average (MA) gap, Hamilton filter gap, and optimized the smoothing parameters $\rho$ in those filters to minimize policy loss function. 

\begin{align*}
L_{\theta,\rho}=\alpha TypeI(\theta)+(1-\alpha)TypeII(\theta)|TPR\ge2/3
\end{align*}

- $\theta$ is the optimized threshold that minizes loss function.

Galán (2019) proposed rolling sample of 15 and 20 years when creating one sided cycle.

Drehmann (2021) created Hamilton filter in a panel setting with fixed coefficients on independent variables across countries.
