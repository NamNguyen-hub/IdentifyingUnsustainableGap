# References {-}
<div id="refs"></div>

# (APPENDIX) Appendix {-}
# Appendix



<!-- ## Model estimation - Initial values selection {-} -->
<!-- The priors for autoregressive parameters in matrix F are taken from VAR regression of the HP filter cycle decomposition of the series. -->

<!-- For $\beta_{0|0}$, I set $\tau_{0|0}$ as the value HP filtered trend component and omit the first observation from the regression. $c_{0|0}$ cycle components are also set to be equal to their HP filter counterpart. Variance $var(\tau_{0|0}) =100+50*random$; while other measures of the starting covariance are set to be their unconditional values. -->

<!-- Starting standard deviation and correlation values are randomized within reasonable range. -->
## List of complete decomposition filters used in the model selection process {#filterslist}

All filters are in (quasi-real time) one-sided fashion. We store the value of the decomposed cycles for the current period permanently as data becomes available and will not change it when new data comes in the next period.

**Hodrick Prescott (HP) filters with different smoothing parameters $\lambda$: \
**- c.hp, c.hp3k, c.hp25k,  c.hp125k, c.hp221k, c.hp400k  

**Hamilton filters with different smoothing parameters $\theta$ (distance of past lags): \
**- c.hamilton13,   c.hamilton20,   c.hamilton24,   c.hamilton28  

**Linear and polynomial filter models:\
**- c.linear, c.quad, c.poly3,  c.poly4,  c.poly5,  c.poly6 

**Beveridge-Nelson decomposition filters with different smoothing parameters (number of lags):\
**- c.bn2,  c.bn3,  c.bn4,  c.bn5,  c.bn6,  c.bn7,  c.bn8 

**Structural time series model:\
**- c.stm

**Rolling sample with 15 and 20 years window (of all previous filters in 1-5 ):\
**- c.hp_r15, c.hp3k_r15, c.hp25k_r15,  c.hp125k_r15, c.hp221k_r15, c.hp400k_r15, c.hamilton13_r15, c.hamilton20_r15, c.hamilton24_r15, c.hamilton28_r15, c.linear_r15, c.quad_r15, c.poly3_r15,  c.poly4_r15,  c.poly5_r15,  c.poly6_r15,  c.bn2_r15,  c.bn3_r15,  c.bn4_r15,  c.bn5_r15,  c.bn6_r15,  c.bn7_r15,  c.bn8_r15,  c.stm_r15 
- c.hp_r20, c.hp3k_r20, c.hp25k_r20,  c.hp125k_r20, c.hp221k_r20, c.hp400k_r20, c.hamilton13_r20, c.hamilton20_r20, c.hamilton24_r20, c.hamilton28_r20, c.linear_r20, c.quad_r20, c.poly3_r20,  c.poly4_r20,  c.poly5_r20,  c.poly6_r20,  c.bn2_r20,  c.bn3_r20,  c.bn4_r20,  c.bn5_r20,  c.bn6_r20,  c.bn7_r20,  c.bn8_r20,  c.stm_r20 

**Hamilton filters in panel setting (with rolling samples):\
**- c.hamilton13_panel, c.hamilton20_panel, c.hamilton24_panel, c.hamilton28_panel, c.hamilton13_panelr15,  c.hamilton20_panelr15,  c.hamilton24_panelr15,  c.hamilton28_panelr15,  c.hamilton13_panelr20,  c.hamilton20_panelr20,  c.hamilton24_panelr20,  c.hamilton28_panelr20

**Moving Average filter:\
**- c.ma  

All models are given equal prior weights.

## Statistical Methods for Trend-Cycle Decomposition {#ma-stm-eq}
<!--[Insert decomposition method equations here]-->

### Bayesian structural time series model (STM) {-}
\begin{align*}
y_t = u_t + v_t,  vt \sim N(0,V)\\
u_t = u_{t-1} + \beta_{t-1} + w_{1,t},  w_{1,t} \sim N(O,\sigma^2_{w1})\\
\beta_t = \beta_{t_1} + w_{2,t},  w_{2,t} \sim N(0,\sigma^2_{w2})
\end{align*}

The implementation of this filter is discussed in [@campagnoli_dynamic_2009]. One feature of this filter that allows for smoother trend component is its inclusion of a time-varying local growth rate $\beta_t$. @beltran_optimizing_2021 estimated the optimized the value of the smoothing parameter at $\sigma^2_{w1} = 1$ , $\sigma^2_{w2}=0.01$ and V = 1100.

### Moving Average {-}
\begin{align*}
MA_t = y_t - \frac{\sum\nolimits^t_{i=t-q+1}y_i}{q}
\end{align*}

With q being the smoothing parameter and the length of the moving average window. @beltran_optimizing_2021 estimated the optimized value for parameter q to be 16.

<!--( - How to deduct optimized threshold from model threshold results)
( - Only would work with univariate regression, since a multivariate model will have multiple
inputs solution for a predicted response value)

## Model average implimentation 
( - Steps of averaging
    - Do a search and bound ( paper reference here ) to find the best models with the fewest number of variables from a fully saturated model. 
    - Occam's razor: 20000, 2*log*2000
      - Filter them by Occam's razor based on BIC value: )
      - Filter only models with only positive weights
      - Filter them by Occam's razor based on psAUC value: )-->



## Out of sample forecast graphs

### Graphs of selected countries {#graphs-other}

\begin{figure}[H]

{\centering \includegraphics[width=0.85\linewidth]{../Data/Output/Graphs/All/Weighted_credit_gap_CA} 

}

\caption{Canada time series graph}(\#fig:CAseries)
\end{figure}

\begin{figure}[H]

{\centering \includegraphics[width=0.85\linewidth]{../Data/Output/Graphs/All/Weighted_credit_gap_FR} 

}

\caption{France time series graph}(\#fig:FRseries)
\end{figure}

\begin{figure}[H]

{\centering \includegraphics[width=0.85\linewidth]{../Data/Output/Graphs/All/Weighted_credit_gap_HK} 

}

\caption{Hong Kong time series graph}(\#fig:HKseries)
\end{figure}

\begin{figure}[H]

{\centering \includegraphics[width=0.85\linewidth]{../Data/Output/Graphs/All/Weighted_credit_gap_JP} 

}

\caption{Japan time series graph}(\#fig:JPseries)
\end{figure}

\begin{figure}[H]

{\centering \includegraphics[width=0.85\linewidth]{../Data/Output/Graphs/All/Weighted_credit_gap_KR} 

}

\caption{South Korea time series graph}(\#fig:KRseries)
\end{figure}

\begin{figure}[H]

{\centering \includegraphics[width=0.85\linewidth]{../Data/Output/Graphs/All/Weighted_credit_gap_SA} 

}

\caption{Saudi Arabia time series graph}(\#fig:SAseries)
\end{figure}

\begin{figure}[H]

{\centering \includegraphics[width=0.85\linewidth]{../Data/Output/Graphs/All/Weighted_credit_gap_SE} 

}

\caption{Sweden time series graph}(\#fig:SEseries)
\end{figure}

\begin{figure}[H]

{\centering \includegraphics[width=0.85\linewidth]{../Data/Output/Graphs/All/Weighted_credit_gap_CH} 

}

\caption{Switzerland time series graph}(\#fig:CHseries)
\end{figure}

\begin{figure}[H]

{\centering \includegraphics[width=0.85\linewidth]{../Data/Output/Graphs/All/Weighted_credit_gap_TH} 

}

\caption{Thailand time series graph}(\#fig:THseries)
\end{figure}


<!--[Will include periods of previous crises for those countries later]-->
