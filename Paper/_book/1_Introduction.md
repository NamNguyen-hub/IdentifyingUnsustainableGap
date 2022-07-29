# Introduction


Credit-to-GDP gaps have been identified as the top candidate as an early warning indicator (EWI) for future financial crises. As the importance of the financial market to the real economy has increased, failing to predict a future systemic crisis and missing the correct timing to implement macroprudential instruments such as Countercyclical Capital Buffer (CCyB) can lead to significant economic losses. As a result, there is a need to improve the performance of our early warning indicator model, specifically when using the credit gap in univariate EWI models. 

In the EWI literature, The Bank of International Settlement (BIS) Basel credit gap using a real-time (one-sided) version of the Hodrick-Prescott filter (HP) has been established as a reference point for policymakers. The BIS Basel gap is easy to implement and communicate; traditionally, it has performed well as an early indicator. However, recent literature has found evidence that optimizing parameters of various decomposition filters can improve those filters' performance beyond the predictive power of the BIS Basel gap as an EWI. The details are discussed in @drehmann_which_2021 and @beltran_optimizing_2021.

The development of embedding optimization of decomposition filter into the process of building an EWI framework has significantly improved the performance of the credit gap filters. However, this also created another issue which is model uncertainty. Policymakers now face at least five decomposition methods, each with different feature parameters to consider optimizing for, such as smoothing parameters, robustness, and rolling window. Furthermore, changes in the sample window would change the performance of those filters with optimized parameters. Selecting a robust and best-performing decomposition filter and optimizing its feature parameters can be a paradox of choice for policymakers.

There is a need for a robust methodology to create a univariate EWI that adapts well to changes in dynamics of the underlying financial market but at the same time uses only the credit gap as an explanatory variable. This paper attempts to solve the model uncertainty issue by using Bayesian model selection and average methods. We first create a set of possible decomposition filters with rich features from the recent literature findings. Out of all possible initial credit gaps created, We then implement a series of model selection and discarding using an additional novel metric psAUC (partial standardized area under the curve of receiver operating characteristic), discussed in subsection \@ref(psAUC). Subsequently, from a finalized subset of variables that passed the performance filters, we perform model averaging of all possible combinations of the variables. @raftery_bayesian_1995 proposed the Bayesian model average method that averages its estimated parameters of interest across all possible combinations of variables. The model that uses the average estimate has proven to be more robust and performs better in out-of-sample forecasts than any other individual model in the selected subset of model combinations. 

Using data from 1970:Q4 to 2017:Q4 across 43 countries, we created 90 credit gaps with varying features found in the literature. We implemented the model selection and average methods described in the paragraph above. We then found evidence that the new EWI performance metric partially standarized AUC (psAUC), which constraints analysis to the region where Type II error < 1/3, to be a robust single value criterion. We also successfully incorporated the new metric into our model selection and averaging method. Lastly, to ease policy implications, we propose to create a single credit gap measurement from weighted-averaging other popularly studied credit gap measurements. The single weighted average credit gap is tested as more robust in resampling bootstrapping estimates. It performs better in out-of-sample forecasts k-fold cross-validation than any other individual model in the filtered subset of model combinations. 

The paper is structured as follows. In the next section, we discuss relevant branches of literature. In Section 3, we describe the data used in this paper. Section 4 outlines the methodology I use for model selection, model average, and a weighted combination of variables of interest, as well as a novel metric for testing the performance of the selected variable and averaged model. Section 5 describes the empirical results of the selected variables in the horse race. Section 6 analyzes time series graphs of individual countries. Section 7 summarizes the main conclusions.


<!--(Reference for opening: one of the 6 reference papers)

(Beltran:
Credit gaps are good predictors for financial crises, and banking regulators recommend using them to inform countercyclical capital buffers for banks. Researchers typically create credit gap measures using trend-cycle decomposition methods, which require many modelling choices, such as the method used, and the smoothness of the underlying trend. Other choices hinge on the tradeoffs implicit in how gaps are used as early warning indicators (EWIs) for predicting crises, such as the preference over false positives and false negatives. We evaluate how the performance of credit-gap-based EWIs for predicting crises is influenced by these modelling choices. For the most common trend-cycle decomposition methods used to recover credit gaps, we find that optimally smoothing the trend enhances out-of-sample prediction. We also show that out-ofsample performance improves further when we consider a preference for robustness of the credit gap estimates to the arrival of new information, which is important as any EWI should work in real-time. We offer several practical implications.)

(Drehmann:
The credit gap, defined as the deviation of the credit-to-GPD ratio from a Hodrick-Prescott (HP) filtered trend, is a powerful early warning indicator for predicting crises . Basel III therefore suggests that policymakers should use it as part of their countercyclical capital buffer frameworks. Hamilton (2017), however, argues that you should never use an HP filter as it results in spurious dynamics, has end-point problems and its typical implementation is at odds with its statistical foundations. Instead he proposes the use of linear projection


(Alessi: 
Unsustainable credit developments lead to the build-up of systemic risks to financial stability. While this is an accepted truth, how to assess whether risks are getting out of hand remains a challenge. To identify excessive credit growth and aggregate leverage we propose an early warning system, which aims at predicting banking crises. In particular, we use a modern classification tree ensemble technique, the “Random Forest”, and include (global) credit as well as real estate variables as predictors.

Drehmann Julius 2014: 
Ideally, early warning indicators (EWI) of banking crises should be evaluated on the basis of their performance relative to the macroprudential policy maker’s decision problem. We translate several practical aspects of this problem — such as difficulties in assessing the costs and benefits of various policy measures, as well as requirements for the timing and stability of EWIs — into statistical evaluation criteria. Applying the criteria to a set of potential EWIs, we find that the credit-to-GDP gap and a new indicator, the debt service ratio (DSR), consistently outperform other measures. The credit-to-GDP gap is the best indicator at longer horizons, whereas the DSR dominates at shorter horizons.


Begin writing:
(Unsustainable credit developments lead to the build-up of systemic risks to financial stability. While this is an accepted truth, how to assess whether risks are getting out of hand remains a challenge.)

(Motivation)-->

<!-- - Compare different credit gap measurements' performance as EWIs using a new robust metric - partial standarized AUC (psAUC) contraining Type II error < 1/3.
- Overcome model uncertainty by implementing model averaging. We incoporated psAUC values in the model selection and weighting process, instead of AUC or BIC values.
- For ease of policy implication, we propose a single credit gap measurement from weighted averaging other popularly studied credit gap measurements.

(summary structure) -->




<!--(Motivation and importance: 
- Increased importance of financial market on the real economy
- However, the BIS received some criticism: 
  - Length of cycle
  - Other countries have adapted counter cyclycal measurements, making the problem more complicated for using the gap as a predictor since it is already being used as a signal 

- Central planner do not like sharing the decision making tool details, since a low predictive power of the tool being public would make it lose confidence and further policies communication would be be effective in the future. 

- This tool helps central planner over come two problems. 
1 is selection of right credit gaps measurement for certain demographic (AE and EME in this case). 

- To overcome model uncertainty in using credit gap as an early warning indicator (EWI) of systemic financial crises, we propose using model averaging of different credit gap measurements. The method is based on Bayesian Model Average - Raftery (1995)

relevant literature in the model
- Area under the curve of operating characteristic (AUROC or AUC) has been widely used as a criterion to determine the performance of a EWI. But it has received some criticism regarding the lower left area of the curve representing low predictive ability of the indicator.
- Borio and Drehmann (2009) and Beltran et al (2021) proposed a policy loss function constraining the relevance of the curve measurement to just a portion where Type II error rate is less than 1/3 or at least 2/3 of the crises are predicted.    
- Detken (2014) proposed using partial standardized area under the curve (psAUC) as an alternative measurement of the performance of an EWI.

Our contribution: 
- Compare different credit gap measurements' performance as EWIs using a new criterion - partial standarized AUC (psAUC) contraining Type II error < 1/3.
- Overcome model uncertainty by implementing model averaging. We incoporated psAUC values in the model selection and weighting process, instead of AUC or BIC values.
- For ease of policy implication, we propose a single credit gap measurement from weighted averaging other popularly studied credit gap measurements.

<!--(Brief introduction of the methodologies, its roots)
(pAUC)
(model average)
(forecast combination - from previous chapter)
(robustness check: resampler bootstrapping and cross-validation)-->

<!--(Plan of the paper)-->

<!--Branches of literatures-->

# Literature Review

In this section, we discuss the branches of literature that our study is relevant and contributes to. 

@borio_assessing_2002 first documented credit gaps' property as a useful early warning indicator (EWI) for banking crises. Earlier literature on excessive credit leading to crises includes @minsky_financial_1977, @manias_panics_1978, and @kaminsky_twin_1999.


@borio_assessing_2009 assessed different smoothing parameters for the one-sided HP filter and later determined $\lambda=400,000$ to be the ideal value for measuring credit gap based on its long smooth trend property and performance as an early warning indicator. @basel_guidance_2010 later established this particular HP filter as the Basel credit gap (we call it BIS Basel gap in this paper), and it became the reference for all EWI models using credit gap filters. @drehmann_credit_2014 defended the Basel gap's performance as an EWI against criticism it received, such as its failure to perform well in emerging market economies.

@drehmann_evaluating_2014 set out a list of criteria for an EWI. It needs to have the "right timing" of being able to detect future financial crises from 20-6 quarters ahead of a future systemic crisis; a "stable signal" that does not decrease as the periods approach the actual crises date; "robustness" that fits well with different data set; and "interpretability" which is ideal for a univariate model such as the credit gap to determine an optimized threshold of classifying excessive credit. Lastly, EWI $S_i$ outperforms EWI $S_j$ for horizon h if $AUC(S_{i,h}) > AUC(S_{j,h})$. This last criterion, however, receives criticism regarding the lower left region of the ROC curve that represents low predictive power of a model, which the AUC metric also measures.^[the details are discussed in subsection \@ref(psAUC)]

@borio_financial_2014 established that credit cycles have a much lower frequency than business cycles. It also pointed out that credit cycle peaks are closely associated with the onset of financial crises. Because of that property, they can detect crises in real-time within macroprudential policies implementation window.

@hamilton_why_2018 argues against using HP filter for macroeconomics series as it introduces spurious dynamics. @drehmann_why_2018 defended the HP filter again but will later admit other filters with additional features, such as a Hamilton filter estimated in a panel setting, outperformed the Basel gap in @drehmann_which_2021. 

Additionally, features for the decomposition methods include rolling sample windows of 15 and 20 years as proposed by @galan_measuring_2019 to help improve the performance of the decomposition filter. @beltran_optimizing_2021 embedded the optimization of features parameters into the construction of an EWI model and constraint the search range for the loss function to the region where True Positive rates $\ge$ 2/3 or Type II error rates < 2/3 following suggestions in @borio_assessing_2009, the paper also introduced using Structural Time Series model (STM) gap, Moving average (MA) gap as possible candidates for the EWI model.

@galan_measuring_2019 also proposed adding other features to the Basel gap that individual countries implement that are out of the scope of this paper's implementation. Such adjustments include adjusting for GDP decrease, combining one and two-sided filters for robustness, adjusting by projection as in @gerdrup_key_2013, and adjusting for currency fluctuations. 

However, there is no consensus on which decomposition with which features would be the best performing and most robust EWI. In this paper, we aim to construct a methodology to find the best combination of decomposition and features to be used as an EWI and propose an average model that performs as well as the best combination, if not better. The methodology we use for the model selection, and average steps are discussed in the literature branch below.

@babecky_banking_2014 used a model selection method called Markov Chain Monte Carlo Model Comparison ($MC^3$) developed by @madigan_bayesian_1995. This method allows for a feasible search for best-fitted combinations out of a large set of variables with similar features, which would not be correctly estimated using other model selection methods such as RIDGE, LASSO, and Elastic Net. @furnival_regressions_2000 proposed a "leap and bound" algorithm to find the best-fitted subsets without examining all possible subsets of variables. 

The Bayesian model averaging method is formally described in @raftery_bayesian_1995. It aims to overcome model uncertainty by averaging the performance of a set of models. The averaged model performs better than the individual models on out-of-sample forecasts. Recently, @holopainen_toward_2017 implemented ensemble methods to combine various machine learning model predictions and found significant improvement in the model performance. 

The model average method could be applied to a multivariate setting, but that will cost us the ability to synthesize a combined weighted credit gap. Following the motivation from Chapter 3, we also attempt to create a combined weighted credit gap in this chapter that performs well in a horse race with other credit gap measurements.


Multivariate early warning system (EWS) is also a significant branch of early warning literature and is worth mentioning. The variables selected in @babecky_banking_2014 that perform well in EWS are then used in the following papers. @drehmann_evaluating_2014 established that with the credit gap, the Debt-to-Service ratio is another EWI that performs well within 1-4 quarters of the future systemic financial crisis. @aldasoro_early_2018 is an extension of @drehmann_evaluating_2014. Furthermore, @alessi_identifying_2018 used a Random Forest model to achieve a higher EWI performance metric than traditional generalized linear regression. Even though multivariate models can achieve higher model fit and prediction accuracy than univariate models, they also require richer data availability and limit the scope of the model implementation. Certain Emerging market economies with insufficient data would benefit more from a well-performing univariate model.


Lastly, we touch on the literature on partial estimating the Area Under the Curve of Receiver Operating Characteristic (psAUC). @detken_operationalising_2014 first introduced the use of partial standardized AUC in the EWI setting. The partial standardized AUC is popularly studied in the medical statistics literature, e.g., @mcclish_analyzing_1989, but is relatively new in the EWI literature. We will use this novel (psAUC) metric, inspired by both @detken_operationalising_2014 and the policy function restriction in @beltran_optimizing_2021, to improve our model selection and averaging process in terms of satisfying policy implication requirements (e.g. TPR $\ge$ 2/3). The method for partial estimation of the ROC curve is documented in @robin_proc_2011.




<!--( Literature history 
- Early 1990 papers

Minsky, 1982; Kindleberger, 2000

  - @kaminsky_twin_1999
  - @chang_model_2001

  Studies such as Lowe and Borio (2002b), Borio and Drehmann (2009), and Drehmann and Juselius (2014) show that credit growth and credit gaps –deviations of aggregate credit to GDP ratio from its long-run trend–are good predictors of systemic banking crises, often referred to as financial crises. They thus support the view that such financial crises are often “credit booms gone bust” (Minsky, 1977; Kindleberger, 1978; Schularick and Taylor, 2012).

- Borio and Lowe (2002a,b) argue that focusing on the behaviour of credit and asset prices is a promising line of enquiry to develop simple and transparent leading indicators of banking system distress.

The credit-to-GDP gap (“credit gap”) is defined as the difference between the credit-to-GDP ratio and its long-term trend. 
-->
<!-- 
( Model averaging and selection literature: 
- @raftery_bayesian_1995
- Bebecky @babecky_banking_2014
- ensemble techniques @holopainen_toward_2017
- @madigan_bayesian_1995
- @furnival_regressions_2000
- We contributed to this literature by further apply the averaging method to a set of different credit gap decomposition methods.
- The model average method could be applied to multivariate setting but that will cost us the ability to synthesize a combined weighted credit gap.
- For ease of policy implication and visualization, we also proposed a single credit gap measurement from weighted averaging other popularly studied credit gap measurements.
-->

<!--
- Borio and Drehmann (2009) @borio_assessing_2009
- Basel gap 2010 @basel_guidance_2010
  - Basel gap paper: became the reference for all EWI 
- @drehmann_credit--gdp_2014
- @drehmann_evaluating_2014
- Drehmann 2014 set out criteria for an EWI, has the "right timing" if 20-6, "stable" meaning the signal does not decrease as the periods approach the actual crises date, "robustness" and "interpretability". Lastly, EWI Si outperforms EWI Sj for horizon h if AUC(Si,h) > AUC(Sj,h). This last criteria however, receives criticism in @beltran_optimizing_2021, the details are discussed in section ...(insert ref here) . 

- @borio_financial_2014
Borio (2014) reports salient stylized features of credit cycles. First, these cycles are most parsimoniously characterized in terms of credit (loans and bonds) extended to the nonfinancial private sector (households and corporations). Second, credit cycles have a much lower frequency than business cycles (see Borio, 2014; Drehmann et al., 2012). Borio (2014) additionally points out that credit cycle peaks are closely associated with the onset of the financial crises, and that they help detect crises with a good lead in real time.


- @hamilton_why_2018 argues against using HP filter for macroeconomics series as it introduces suprious dynamics. @drehmann_why_2018 defended the HP filter. However, there has not been a consensus on which decomposition method has the superiority.
- Garlan 2019 @galan_measuring_2019
- Drehmann 2021 @drehmann_which_2021
- Beltran 2021 @beltran_optimizing_2021)


Galán (2019) proposed rolling sample of 15 and 20 years when creating one sided cycle.

Drehmann (2021) created Hamilton filter in a panel setting with fixed coefficients on independent variables across countries.

Mention other papers: norwegian, 
Other univariate methods in Garlan 2019
(Paper that Groups countries in different regions: brings better results too.)
Should multivariate early warning systems for banking crises pool across regions?
@davis_should_2011

-->

<!--
Multivariate EWI:
- @aldasoro_early_2018
- Alessi 2018 
- @alessi_identifying_2018
- @detken_operationalising_2014 

- Composite index
  - Deducted from PCA of other variables
- Machine learning, ensemble using multivariate models
-> Distinguish our contribution: we only use 1 variable to measure credit gap ( the credit series it self) using a combination of other popular credit gap measurements in the literature. 
 Pros: ease of implementation, richer data set, inclusion or extrapolating results to countries outside of the data set would also be easier. )
 Cons: lower model fitness than other multivariate models.
 
Composite index:
- Afanasyeva (2020) develops a Bayesian vector autoregression (BVAR) method to detect credit booms using monetary aggregates, asset prices, and measures of real economic activity, which provides a useful cross-check to the credit gaps derived from trend-cycle decomposition methods. 
- Sarlin and von Schweinitz (forthcoming) use 14 observable macroeconomic and asset price measures to predict the probability of a crisis, defined as periods when the Financial Stress Index of Lo Duca and Peltonen (2013) exceeds its 90th percentile.
-->



<!--
( partial standardized AUC literature: )
- Contribution: Detken 2014 together with Borio 2009 and Beltral 2021 criteria
- @robin_proc_2011


Beltran (2021) - measured and the performance of BIS Basel credit gap, Structural Time Series model (STM) gap, Moving average (MA) gap, Hamilton filter gap, and optimized the smoothing parameters $\rho$ in those filters to minimize policy loss function. 

\begin{align*}
L_{\theta,\rho}=\alpha TypeI(\theta)+(1-\alpha)TypeII(\theta)|TPR\ge2/3
\end{align*}

- $\theta$ is the optimized threshold that minizes loss function.

-->

