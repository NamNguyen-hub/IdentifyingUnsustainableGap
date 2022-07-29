
# Analyzing time series graphs of individual countries

This section will discuss the BIS Basel gap and weighted gap as EWIs for the US and UK. Based on the estimated optimized gap threshold values for the weighted gap and BIS Basel gap reported in Table \@ref(tab:varcompfull) and \@ref(tab:cvvarcompfull) for full sample results, we will use an optimized credit gap threshold of 3.00 for ease of comparison. The black shaded area on Figures \@ref(fig:wUS) and \@ref(fig:wUK) ranges from 2018:Q1 to 2021:Q3, representing periods where we do not have sufficient crisis data, but credit data are available.

<!--(Insert statistics about TPR and TNR / Confusion matrix here)-->


\begin{figure}

{\centering \includegraphics[width=1\linewidth]{../Data/Output/Graphs/Weighted_credit_gap_US} 

}

\caption{US time series graph}(\#fig:wUS)
\end{figure}

\begin{figure}

{\centering \includegraphics[width=1\linewidth]{../Data/Output/Graphs/Weighted_credit_gap_UK} 

}

\caption{UK time series graph}(\#fig:wUK)
\end{figure}

For the US, the weighted gap and BIS Basel gap performed similarly. They were able to predict the late 80s - early 90s financial crisis. They raised above the threshold starting early 2000s, which would result in misclassification of pre-crisis periods (Type I error) since our model wants to only identify periods of 5-12 months before a systemic financial crisis that would not happen until 2008. Nevertheless, the two gap series showed a build-up of an unsustainable credit gap for a prolonged period before the Great Financial Crisis (GFC) in the US. It is also worth pointing out that the weighted gap dipped below the threshold again before climbing again to identify the pre-crisis period of the GFC correctly. 

The graph for the UK tells quite a similar story to the US. Both the credit gaps were able to detect the pre-crisis periods in the early 1990s and the GFC on 2008 for the UK. However, regarding the 90s crisis, the BIS Basel gap went above its threshold too early, for about five years. This could trigger unnecessary counter-cyclical buffer measurements from the central bank and cause the economy to slow its growth rate because of credit constraints. The weighted gap performed much better than the BIS Basel gap as it only sent out the signal during the pre-crisis period of the early 1990s for the UK.   

From the graphical features of the weighted gap, we can compare the magnitude and length of the weighted gaps to that of the BIS Basel gap, which has long, smooth trends. Additionally, the weighted gap also retains the more volatile features and short spikes of sudden credit growth that the Beveridge-Nelson and other shorter-term cycle decomposition methods have. These averaged features help explain the averaged method's improved performance as an EWI over other traditional decomposition filters.

From here, to continue our analysis beyond 2017:Q4, we extrapolated our weights on one-sided credit gaps as constants to create a weighted credit gap outside of the crisis data range. This allows us to extrapolate our prediction until 2021:Q3. In response to COVID-19, most countries increased their total credit through multiple monetary policies, or their GDP growth slowed down, both of which created a significant upswing in the magnitude of the credit gap measurement above its optimized pre-crisis detection threshold. Per @drehmann_which_2021, a good EWI signal would have the ideal characteristic of a stable signal meaning the credit gap need to be above the threshold and remain stable above the threshold during the pre-crisis period. We assume from our model finding that an economy with a credit gap above its optimized threshold for 8 consecutive quarters has a 2/3rd chance of having a financial crisis after the next 4 quarters.

As for the US, even though its credit gap was above the threshold for a few quarters, the gap eventually dropped below the threshold. This does not give us enough evidence to suggest that the country is at risk of a systemic financial crisis in the short future. However, there was an increase in the risk of crisis as the credit gap went beyond the threshold substantially during COVID-19 period. For the UK, the credit gaps did not exceed its threshold. Therefore, there is no evidence to show that the UK is at risk of a future financial crisis.

We performed a graphical analysis of all the countries in the sample and identified countries with significant credit gaps above the optimized 3.00 credit gap threshold beyond the 2017:Q4 crisis data limit window. We selected nine countries with signs of being at pre-crisi riskand should have performed pre-emptive macroprudential measures. They are Canada, France, Hong Kong (SAR), Japan, South Korea, Saudi Arabia, Switzerland, Sweden, and Thailand.^[graphs of those countries are included in Appendix \@ref(graphs-other)]

There are three outliers in those nine countries: Canada, Switzerland, and Hong Kong (SAR). Since the end of the GFC, the credit gaps in these three countries have been substantially above their optimized threshold. Additionally, those three countries never experienced systemic financial crises. Therefore, the EWI model performance for those three countries is not robust, and the evidence only comes from abroad. The other six countries: France, Switzerland, Japan, South Korea, Saudi Arabia, and Thailand, have evidence to show that pre-emptive macroprudential measures are to be performed to reduce the risk of having a systemic crisis.

<!--(Discuss how different gap capture the pre-crisis periods differently)

(How the weighted gap performs better than the BIS gap based on the evidence of the graph)

(From the discussion on the out-of-sample forecast analysis, 
extrapolate the prediction on the end of crisis data period (2018:Q1 - 2021:Q3)

(Mention the countries that have substantial credit gap above it's long run trend)

(- Include graphs of those countries (with crises periods) on Appendix and link reference here)

(- Discuss certain countries, criteria for identifying (unsustainable gap above threshold), we can say with certain degree of certainty that the risk of systemic crisis given our model is ... % percent, from fpr and fnr values out of sample forecast )

( - Discuss outliers : HK and CH, how they have been having a long periods of positive credit gaps above their long-run trends even before the end of crisis data )-->
