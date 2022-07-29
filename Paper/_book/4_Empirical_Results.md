
\begin{figure}

{\centering \includegraphics[width=1\linewidth]{../Data/Output/Graphs/Weights_combined} 

}

\caption{One sided weights graph}(\#fig:weightgraph)
\end{figure}

# Empirical Results {#empirical-results}

## One sided weights stacked time series graph {#weight-graphs}




In Figure \@ref(fig:weightgraph), we see that for the first 15-18 years of the data sample, the parsimony (c.poly3) filter's weight dominated all the other filters. However, after about 20 years, the (c.poly3) filter lost all of its weight. This could be explained by the lack of initial data, leading to poorer performance of other credit gap measurements.

However, as more data were updated, the dynamics of the weights changed significantly. During the early 1990s, Hodrick-Prescott filters' weights overshadowed others, then Beveridge-Nelson, and the Structural Time-Series model did. As the Great Financial Crisis happened, the Hamilton filter in a panel setting gained weight. And lastly, at the end of the crisis data period 2017:Q4, we have 3 Beveridge-Nelson filters (c.bn2_r20, c.bn2_r15 and c.bn3_r15) and 1 Hamilton filter (c.hamiolton28_panelr20) sharing nearly equal weights. To apply our findings in our limited sample, we fixed the weights for 2017:Q4 at constant and extrapolated the weights to 2021:Q3, the end of this paper's credit data availability.


<!--[Talk about weight changes over the years below]
[How we extrapolated from 2018:Q1 to 2021:Q3]-->


## Model Fitness Results {#model-fit}


<!--[Discuss bootstrapping method details, and other methodological details here.]-->

The standard deviation for each estimate is deducted from a 95% confidence interval of the bootstrapping results using 2000 stratified bootstrap replicates.^[We estimate partial ROC and confidence interval using the R package "pROC" by @robin_proc_2011 whose methodology is based on @carpenter_bootstrap_2000]

\begin{table}[H]

\caption{(\#tab:varcompAE)Credit gaps performance as EWIs - Advanced Economies}
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{llll>{}lllll}
\toprule
Cycle & BIC & AIC & AUC & psAUC & c.Threshold & Type I & Type II & Policy Loss Function\\
\midrule
\cellcolor{gray!6}{null} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{0.5000} & \textbf{\cellcolor{gray!6}{0.5000}} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{1.0000} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{1.0000}\\
 &  &  &  & \textbf{} &  &  &  & \\
\addlinespace
\textbf{\cellcolor{gray!6}{1.sided weighted.cycle}} & \textbf{\cellcolor{gray!6}{-128.8749}} & \textbf{\cellcolor{gray!6}{-134.9430}} & \textbf{\cellcolor{gray!6}{0.7545}} & \textbf{\textbf{\cellcolor{gray!6}{0.6889}}} & \textbf{\cellcolor{gray!6}{3.5486}} & \textbf{\cellcolor{gray!6}{0.3177}} & \textbf{\cellcolor{gray!6}{0.2841}} & \textbf{\cellcolor{gray!6}{0.1817}}\\
\textbf{} & \textbf{} & \textbf{} & \textbf{(0.0177)} & \textbf{\textbf{(0.0195)}} & \textbf{} & \textbf{(0.0088)} & \textbf{(0.0348)} & \textbf{(0.0254)}\\
\addlinespace
\cellcolor{gray!6}{c.hamilton13.panelr15} & \cellcolor{gray!6}{-116.9260} & \cellcolor{gray!6}{-122.9941} & \cellcolor{gray!6}{0.7282} & \textbf{\cellcolor{gray!6}{0.6846}} & \cellcolor{gray!6}{8.8000} & \cellcolor{gray!6}{0.3469} & \cellcolor{gray!6}{0.3011} & \cellcolor{gray!6}{0.2110}\\
 &  &  & (0.0174) & \textbf{(0.0178)} &  & (0.0087) & (0.0348) & (0.0270)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panelr15} & \cellcolor{gray!6}{-141.5772} & \cellcolor{gray!6}{-147.6453} & \cellcolor{gray!6}{0.7491} & \textbf{\cellcolor{gray!6}{0.6825}} & \cellcolor{gray!6}{11.5510} & \cellcolor{gray!6}{0.3834} & \cellcolor{gray!6}{0.2216} & \cellcolor{gray!6}{0.1961}\\
 &  &  & (0.0184) & \textbf{(0.0198)} &  & (0.0088) & (0.0319) & (0.0212)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panelr20} & \cellcolor{gray!6}{-147.4322} & \cellcolor{gray!6}{-153.5003} & \cellcolor{gray!6}{0.7514} & \textbf{\cellcolor{gray!6}{0.6811}} & \cellcolor{gray!6}{13.1072} & \cellcolor{gray!6}{0.3489} & \cellcolor{gray!6}{0.2898} & \cellcolor{gray!6}{0.2057}\\
 &  &  & (0.0185) & \textbf{(0.0195)} &  & (0.0086) & (0.0348) & (0.0262)\\
\addlinespace
\cellcolor{gray!6}{c.bn6.r20} & \cellcolor{gray!6}{-90.1022} & \cellcolor{gray!6}{-96.1703} & \cellcolor{gray!6}{0.7338} & \textbf{\cellcolor{gray!6}{0.6751}} & \cellcolor{gray!6}{0.6581} & \cellcolor{gray!6}{0.4126} & \cellcolor{gray!6}{0.2273} & \cellcolor{gray!6}{0.2219}\\
 &  &  & (0.0183) & \textbf{(0.0171)} &  & (0.0094) & (0.0319) & (0.0222)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panel} & \cellcolor{gray!6}{-129.1730} & \cellcolor{gray!6}{-135.2411} & \cellcolor{gray!6}{0.7382} & \textbf{\cellcolor{gray!6}{0.6740}} & \cellcolor{gray!6}{9.7674} & \cellcolor{gray!6}{0.3977} & \cellcolor{gray!6}{0.2386} & \cellcolor{gray!6}{0.2151}\\
 &  &  & (0.0187) & \textbf{(0.0189)} &  & (0.0090) & (0.0319) & (0.0224)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton13.panel} & \cellcolor{gray!6}{-122.0054} & \cellcolor{gray!6}{-128.0735} & \cellcolor{gray!6}{0.7208} & \textbf{\cellcolor{gray!6}{0.6684}} & \cellcolor{gray!6}{7.2247} & \cellcolor{gray!6}{0.3509} & \cellcolor{gray!6}{0.3239} & \cellcolor{gray!6}{0.2280}\\
 &  &  & (0.0182) & \textbf{(0.0174)} &  & (0.0090) & (0.0362) & (0.0296)\\
\addlinespace
\cellcolor{gray!6}{c.ma} & \cellcolor{gray!6}{-97.4868} & \cellcolor{gray!6}{-103.5549} & \cellcolor{gray!6}{0.7133} & \textbf{\cellcolor{gray!6}{0.6677}} & \cellcolor{gray!6}{6.0375} & \cellcolor{gray!6}{0.4073} & \cellcolor{gray!6}{0.2727} & \cellcolor{gray!6}{0.2403}\\
 &  &  & (0.0181) & \textbf{(0.0174)} &  & (0.0087) & (0.0333) & (0.0255)\\
\addlinespace
\cellcolor{gray!6}{c.bn6} & \cellcolor{gray!6}{-104.1404} & \cellcolor{gray!6}{-110.2085} & \cellcolor{gray!6}{0.7042} & \textbf{\cellcolor{gray!6}{0.6426}} & \cellcolor{gray!6}{0.8256} & \cellcolor{gray!6}{0.4040} & \cellcolor{gray!6}{0.2955} & \cellcolor{gray!6}{0.2505}\\
 &  &  & (0.0198) & \textbf{(0.0184)} &  & (0.0089) & (0.0348) & (0.0277)\\
\addlinespace
\cellcolor{gray!6}{c.hp125k} & \cellcolor{gray!6}{-92.8331} & \cellcolor{gray!6}{-98.9012} & \cellcolor{gray!6}{0.6977} & \textbf{\cellcolor{gray!6}{0.6397}} & \cellcolor{gray!6}{3.6972} & \cellcolor{gray!6}{0.3788} & \cellcolor{gray!6}{0.3239} & \cellcolor{gray!6}{0.2484}\\
 &  &  & (0.0195) & \textbf{(0.0185)} &  & (0.0089) & (0.0348) & (0.0293)\\
\addlinespace
\textbf{\cellcolor{gray!6}{BIS Basel gap}} & \textbf{\cellcolor{gray!6}{-113.9826}} & \textbf{\cellcolor{gray!6}{-120.0507}} & \textbf{\cellcolor{gray!6}{0.7124}} & \textbf{\textbf{\cellcolor{gray!6}{0.6390}}} & \textbf{\cellcolor{gray!6}{3.9706}} & \textbf{\cellcolor{gray!6}{0.3847}} & \textbf{\cellcolor{gray!6}{0.3011}} & \textbf{\cellcolor{gray!6}{0.2387}}\\
\textbf{} & \textbf{} & \textbf{} & \textbf{(0.0200)} & \textbf{\textbf{(0.0197)}} & \textbf{} & \textbf{(0.0085)} & \textbf{(0.0348)} & \textbf{(0.0275)}\\
\addlinespace
\cellcolor{gray!6}{c.hp221k} & \cellcolor{gray!6}{-104.1190} & \cellcolor{gray!6}{-110.1871} & \cellcolor{gray!6}{0.7070} & \textbf{\cellcolor{gray!6}{0.6388}} & \cellcolor{gray!6}{3.8869} & \cellcolor{gray!6}{0.3755} & \cellcolor{gray!6}{0.3011} & \cellcolor{gray!6}{0.2317}\\
 &  &  & (0.0198) & \textbf{(0.0197)} &  & (0.0086) & (0.0362) & (0.0285)\\
\addlinespace
\cellcolor{gray!6}{c.stm.r15} & \cellcolor{gray!6}{-86.6063} & \cellcolor{gray!6}{-92.6744} & \cellcolor{gray!6}{0.6989} & \textbf{\cellcolor{gray!6}{0.6382}} & \cellcolor{gray!6}{4.0784} & \cellcolor{gray!6}{0.3486} & \cellcolor{gray!6}{0.3295} & \cellcolor{gray!6}{0.2301}\\
 &  &  & (0.0195) & \textbf{(0.0204)} &  & (0.0090) & (0.0348) & (0.0292)\\
\addlinespace
\cellcolor{gray!6}{c.stm} & \cellcolor{gray!6}{-89.9073} & \cellcolor{gray!6}{-95.9754} & \cellcolor{gray!6}{0.6929} & \textbf{\cellcolor{gray!6}{0.6357}} & \cellcolor{gray!6}{3.3071} & \cellcolor{gray!6}{0.3924} & \cellcolor{gray!6}{0.3295} & \cellcolor{gray!6}{0.2626}\\
 &  &  & (0.0197) & \textbf{(0.0193)} &  & (0.0091) & (0.0348) & (0.0300)\\
\addlinespace
\cellcolor{gray!6}{c.hp400k.r15} & \cellcolor{gray!6}{-73.5902} & \cellcolor{gray!6}{-79.6582} & \cellcolor{gray!6}{0.6869} & \textbf{\cellcolor{gray!6}{0.6357}} & \cellcolor{gray!6}{4.2355} & \cellcolor{gray!6}{0.3496} & \cellcolor{gray!6}{0.3125} & \cellcolor{gray!6}{0.2199}\\
 &  &  & (0.0194) & \textbf{(0.0201)} &  & (0.0085) & (0.0348) & (0.0277)\\
\addlinespace
\cellcolor{gray!6}{c.linear} & \cellcolor{gray!6}{-111.9570} & \cellcolor{gray!6}{-118.0251} & \cellcolor{gray!6}{0.7069} & \textbf{\cellcolor{gray!6}{0.6356}} & \cellcolor{gray!6}{3.9964} & \cellcolor{gray!6}{0.4620} & \cellcolor{gray!6}{0.2443} & \cellcolor{gray!6}{0.2732}\\
 &  &  & (0.0206) & \textbf{(0.0177)} &  & (0.0092) & (0.0319) & (0.0241)\\
\addlinespace
\cellcolor{gray!6}{c.hp400k.r20} & \cellcolor{gray!6}{-93.8576} & \cellcolor{gray!6}{-99.9257} & \cellcolor{gray!6}{0.6991} & \textbf{\cellcolor{gray!6}{0.6340}} & \cellcolor{gray!6}{4.3393} & \cellcolor{gray!6}{0.3622} & \cellcolor{gray!6}{0.3295} & \cellcolor{gray!6}{0.2398}\\
 &  &  & (0.0197) & \textbf{(0.0197)} &  & (0.0090) & (0.0362) & (0.0306)\\
\addlinespace
\cellcolor{gray!6}{c.bn2.r20} & \cellcolor{gray!6}{-84.0800} & \cellcolor{gray!6}{-90.1481} & \cellcolor{gray!6}{0.6955} & \textbf{\cellcolor{gray!6}{0.6297}} & \cellcolor{gray!6}{0.2773} & \cellcolor{gray!6}{0.4216} & \cellcolor{gray!6}{0.3182} & \cellcolor{gray!6}{0.2790}\\
 &  &  & (0.0201) & \textbf{(0.0168)} &  & (0.0090) & (0.0348) & (0.0301)\\
\addlinespace
\cellcolor{gray!6}{c.stm.r20} & \cellcolor{gray!6}{-87.6992} & \cellcolor{gray!6}{-93.7673} & \cellcolor{gray!6}{0.6879} & \textbf{\cellcolor{gray!6}{0.6282}} & \cellcolor{gray!6}{3.1055} & \cellcolor{gray!6}{0.4073} & \cellcolor{gray!6}{0.3239} & \cellcolor{gray!6}{0.2708}\\
 &  &  & (0.0200) & \textbf{(0.0178)} &  & (0.0089) & (0.0348) & (0.0298)\\
\bottomrule
\multicolumn{9}{l}{\textsuperscript{} The standard deviation for each estimates are deducted from 95\% confidence interval of the bootstrapping results}\\
\multicolumn{9}{l}{using 2000 stratified bootstrap replicates.}\\
\end{tabular}}
\end{table}

\begin{table}[H]

\caption{(\#tab:varcompEME)Credit gaps performance as EWIs - Emerging Market Economies}
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{llll>{}lllll}
\toprule
Cycle & BIC & AIC & AUC & psAUC & c.Threshold & Type I & Type II & Policy Loss Function\\
\midrule
\cellcolor{gray!6}{null} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{0.5000} & \textbf{\cellcolor{gray!6}{0.5000}} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{1.0000} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{1.0000}\\
 &  &  &  & \textbf{} &  &  &  & \\
\addlinespace
\cellcolor{gray!6}{c.bn3.r15} & \cellcolor{gray!6}{-46.2774} & \cellcolor{gray!6}{-51.3507} & \cellcolor{gray!6}{0.7365} & \textbf{\cellcolor{gray!6}{0.6308}} & \cellcolor{gray!6}{0.6244} & \cellcolor{gray!6}{0.3059} & \cellcolor{gray!6}{0.3333} & \cellcolor{gray!6}{0.2047}\\
 &  &  & (0.0471) & \textbf{(0.0451)} &  & (0.0134) & (0.0779) & (0.0623)\\
\addlinespace
\cellcolor{gray!6}{c.poly3} & \cellcolor{gray!6}{5.3862} & \cellcolor{gray!6}{0.3129} & \cellcolor{gray!6}{0.5737} & \textbf{\cellcolor{gray!6}{0.6046}} & \cellcolor{gray!6}{1.8089} & \cellcolor{gray!6}{0.5280} & \cellcolor{gray!6}{0.3056} & \cellcolor{gray!6}{0.3721}\\
 &  &  & (0.0358) & \textbf{(0.0264)} &  & (0.0152) & (0.0709) & (0.0593)\\
\addlinespace
\cellcolor{gray!6}{c.bn2.r15} & \cellcolor{gray!6}{-13.2062} & \cellcolor{gray!6}{-18.2795} & \cellcolor{gray!6}{0.6879} & \textbf{\cellcolor{gray!6}{0.5879}} & \cellcolor{gray!6}{0.2952} & \cellcolor{gray!6}{0.3566} & \cellcolor{gray!6}{0.3333} & \cellcolor{gray!6}{0.2383}\\
 &  &  & (0.0505) & \textbf{(0.0508)} &  & (0.0140) & (0.0779) & (0.0642)\\
\addlinespace
\cellcolor{gray!6}{c.poly4.r20} & \cellcolor{gray!6}{7.0732} & \cellcolor{gray!6}{1.9999} & \cellcolor{gray!6}{0.5040} & \textbf{\cellcolor{gray!6}{0.5816}} & \cellcolor{gray!6}{-0.9609} & \cellcolor{gray!6}{0.5962} & \cellcolor{gray!6}{0.3333} & \cellcolor{gray!6}{0.4665}\\
 &  &  & (0.0339) & \textbf{(0.0160)} &  & (0.0147) & (0.0779) & (0.0717)\\
\addlinespace
\textbf{\cellcolor{gray!6}{1.sided weighted.cycle}} & \textbf{\cellcolor{gray!6}{6.2094}} & \textbf{\cellcolor{gray!6}{1.1361}} & \textbf{\cellcolor{gray!6}{0.5325}} & \textbf{\textbf{\cellcolor{gray!6}{0.5811}}} & \textbf{\cellcolor{gray!6}{-1.0639}} & \textbf{\cellcolor{gray!6}{0.6827}} & \textbf{\cellcolor{gray!6}{0.1111}} & \textbf{\cellcolor{gray!6}{0.4784}}\\
\textbf{} & \textbf{} & \textbf{} & \textbf{(0.0402)} & \textbf{\textbf{(0.0183)}} & \textbf{} & \textbf{(0.0136)} & \textbf{(0.0496)} & \textbf{(0.0310)}\\
\addlinespace
\cellcolor{gray!6}{c.linear} & \cellcolor{gray!6}{-9.3676} & \cellcolor{gray!6}{-14.4409} & \cellcolor{gray!6}{0.5787} & \textbf{\cellcolor{gray!6}{0.5774}} & \cellcolor{gray!6}{-0.9783} & \cellcolor{gray!6}{0.6294} & \cellcolor{gray!6}{0.2222} & \cellcolor{gray!6}{0.4455}\\
 &  &  & (0.0471) & \textbf{(0.0208)} &  & (0.0143) & (0.0709) & (0.0495)\\
\addlinespace
\cellcolor{gray!6}{c.bn2.r20} & \cellcolor{gray!6}{-16.6411} & \cellcolor{gray!6}{-21.7144} & \cellcolor{gray!6}{0.6760} & \textbf{\cellcolor{gray!6}{0.5751}} & \cellcolor{gray!6}{0.1470} & \cellcolor{gray!6}{0.4510} & \cellcolor{gray!6}{0.3056} & \cellcolor{gray!6}{0.2968}\\
 &  &  & (0.0519) & \textbf{(0.0462)} &  & (0.0154) & (0.0709) & (0.0572)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton13} & \cellcolor{gray!6}{6.5749} & \cellcolor{gray!6}{1.5016} & \cellcolor{gray!6}{0.5468} & \textbf{\cellcolor{gray!6}{0.5710}} & \cellcolor{gray!6}{3.6354} & \cellcolor{gray!6}{0.6206} & \cellcolor{gray!6}{0.3056} & \cellcolor{gray!6}{0.4785}\\
 &  &  & (0.0386) & \textbf{(0.0229)} &  & (0.0143) & (0.0709) & (0.0610)\\
\addlinespace
\cellcolor{gray!6}{c.ma} & \cellcolor{gray!6}{-11.6401} & \cellcolor{gray!6}{-16.7133} & \cellcolor{gray!6}{0.5572} & \textbf{\cellcolor{gray!6}{0.5457}} & \cellcolor{gray!6}{-0.2250} & \cellcolor{gray!6}{0.7220} & \cellcolor{gray!6}{0.1667} & \cellcolor{gray!6}{0.5491}\\
 &  &  & (0.0546) & \textbf{(0.0164)} &  & (0.0134) & (0.0567) & (0.0382)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panel} & \cellcolor{gray!6}{-7.8687} & \cellcolor{gray!6}{-12.9420} & \cellcolor{gray!6}{0.5392} & \textbf{\cellcolor{gray!6}{0.5384}} & \cellcolor{gray!6}{-1.7750} & \cellcolor{gray!6}{0.6958} & \cellcolor{gray!6}{0.2778} & \cellcolor{gray!6}{0.5613}\\
 &  &  & (0.0522) & \textbf{(0.0170)} &  & (0.0132) & (0.0709) & (0.0577)\\
\addlinespace
\cellcolor{gray!6}{c.quad} & \cellcolor{gray!6}{6.1997} & \cellcolor{gray!6}{1.1264} & \cellcolor{gray!6}{0.4654} & \textbf{\cellcolor{gray!6}{0.5334}} & \cellcolor{gray!6}{-6.4882} & \cellcolor{gray!6}{0.7456} & \cellcolor{gray!6}{0.1944} & \cellcolor{gray!6}{0.5938}\\
 &  &  & (0.0474) & \textbf{(0.0140)} &  & (0.0127) & (0.0638) & (0.0455)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton13.panelr15} & \cellcolor{gray!6}{-1.6660} & \cellcolor{gray!6}{-6.7393} & \cellcolor{gray!6}{0.5087} & \textbf{\cellcolor{gray!6}{0.5274}} & \cellcolor{gray!6}{-1.1064} & \cellcolor{gray!6}{0.7002} & \cellcolor{gray!6}{0.3333} & \cellcolor{gray!6}{0.6014}\\
 &  &  & (0.0550) & \textbf{(0.0130)} &  & (0.0136) & (0.0779) & (0.0732)\\
\addlinespace
\cellcolor{gray!6}{c.hp25k.r15} & \cellcolor{gray!6}{3.6420} & \cellcolor{gray!6}{-1.4313} & \cellcolor{gray!6}{0.5018} & \textbf{\cellcolor{gray!6}{0.5265}} & \cellcolor{gray!6}{-3.5672} & \cellcolor{gray!6}{0.7850} & \cellcolor{gray!6}{0.1111} & \cellcolor{gray!6}{0.6285}\\
 &  &  & (0.0558) & \textbf{(0.0101)} &  & (0.0125) & (0.0496) & (0.0320)\\
\addlinespace
\cellcolor{gray!6}{c.hp25k} & \cellcolor{gray!6}{3.9466} & \cellcolor{gray!6}{-1.1267} & \cellcolor{gray!6}{0.4975} & \textbf{\cellcolor{gray!6}{0.5247}} & \cellcolor{gray!6}{-3.7339} & \cellcolor{gray!6}{0.7893} & \cellcolor{gray!6}{0.1111} & \cellcolor{gray!6}{0.6354}\\
 &  &  & (0.0560) & \textbf{(0.0099)} &  & (0.0118) & (0.0496) & (0.0310)\\
\addlinespace
\cellcolor{gray!6}{c.hp3k} & \cellcolor{gray!6}{3.3678} & \cellcolor{gray!6}{-1.7054} & \cellcolor{gray!6}{0.5276} & \textbf{\cellcolor{gray!6}{0.5235}} & \cellcolor{gray!6}{-1.1119} & \cellcolor{gray!6}{0.7019} & \cellcolor{gray!6}{0.3333} & \cellcolor{gray!6}{0.6038}\\
 &  &  & (0.0556) & \textbf{(0.0146)} &  & (0.0136) & (0.0850) & (0.0758)\\
\addlinespace
\cellcolor{gray!6}{c.hp3k.r20} & \cellcolor{gray!6}{3.3703} & \cellcolor{gray!6}{-1.7030} & \cellcolor{gray!6}{0.5276} & \textbf{\cellcolor{gray!6}{0.5235}} & \cellcolor{gray!6}{-1.1125} & \cellcolor{gray!6}{0.7028} & \cellcolor{gray!6}{0.3333} & \cellcolor{gray!6}{0.6050}\\
 &  &  & (0.0556) & \textbf{(0.0149)} &  & (0.0132) & (0.0779) & (0.0726)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton13.panel} & \cellcolor{gray!6}{-1.6294} & \cellcolor{gray!6}{-6.7027} & \cellcolor{gray!6}{0.5166} & \textbf{\cellcolor{gray!6}{0.5222}} & \cellcolor{gray!6}{-2.9398} & \cellcolor{gray!6}{0.7500} & \cellcolor{gray!6}{0.2778} & \cellcolor{gray!6}{0.6397}\\
 &  &  & (0.0554) & \textbf{(0.0134)} &  & (0.0132) & (0.0709) & (0.0591)\\
\addlinespace
\textbf{\cellcolor{gray!6}{BIS Basel gap}} & \textbf{\cellcolor{gray!6}{-0.7015}} & \textbf{\cellcolor{gray!6}{-5.7748}} & \textbf{\cellcolor{gray!6}{0.4928}} & \textbf{\textbf{\cellcolor{gray!6}{0.5217}}} & \textbf{\cellcolor{gray!6}{-5.3969}} & \textbf{\cellcolor{gray!6}{0.7920}} & \textbf{\cellcolor{gray!6}{0.1389}} & \textbf{\cellcolor{gray!6}{0.6465}}\\
\textbf{} & \textbf{} & \textbf{} & \textbf{(0.0544)} & \textbf{\textbf{(0.0100)}} & \textbf{} & \textbf{(0.0118)} & \textbf{(0.0638)} & \textbf{(0.0382)}\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panelr20} & \cellcolor{gray!6}{-4.9986} & \cellcolor{gray!6}{-10.0719} & \cellcolor{gray!6}{0.5123} & \textbf{\cellcolor{gray!6}{0.5213}} & \cellcolor{gray!6}{-1.5578} & \cellcolor{gray!6}{0.6932} & \cellcolor{gray!6}{0.3333} & \cellcolor{gray!6}{0.5916}\\
 &  &  & (0.0544) & \textbf{(0.0147)} &  & (0.0136) & (0.0710) & (0.0663)\\
\bottomrule
\multicolumn{9}{l}{\textsuperscript{} The standard deviation for each estimates are deducted from 95\% confidence interval of the bootstrapping}\\
\multicolumn{9}{l}{results using 2000 stratified bootstrap replicates.}\\
\end{tabular}}
\end{table}

\begin{table}[H]

\caption{(\#tab:varcompfull)Credit gaps performance as EWIs comparison - Full sample}
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{llll>{}lllll}
\toprule
Cycle & BIC & AIC & AUC & psAUC & c.Threshold & Type I & Type II & Policy Loss Function\\
\midrule
\cellcolor{gray!6}{null} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{0.5000} & \textbf{\cellcolor{gray!6}{0.5000}} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{1.0000} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{1.0000}\\
 &  &  &  & \textbf{} &  &  &  & \\
\addlinespace
\textbf{\cellcolor{gray!6}{1.sided weighted.cycle}} & \textbf{\cellcolor{gray!6}{-127.5308}} & \textbf{\cellcolor{gray!6}{-133.9135}} & \textbf{\cellcolor{gray!6}{0.7182}} & \textbf{\textbf{\cellcolor{gray!6}{0.6454}}} & \textbf{\cellcolor{gray!6}{2.8892}} & \textbf{\cellcolor{gray!6}{0.3532}} & \textbf{\cellcolor{gray!6}{0.3255}} & \textbf{\cellcolor{gray!6}{0.2307}}\\
\textbf{} & \textbf{} & \textbf{} & \textbf{(0.0174)} & \textbf{\textbf{(0.0165)}} & \textbf{} & \textbf{(0.0076)} & \textbf{(0.0313)} & \textbf{(0.0257)}\\
\addlinespace
\cellcolor{gray!6}{c.bn6.r20} & \cellcolor{gray!6}{-108.0679} & \cellcolor{gray!6}{-114.4506} & \cellcolor{gray!6}{0.7048} & \textbf{\cellcolor{gray!6}{0.6379}} & \cellcolor{gray!6}{0.6581} & \cellcolor{gray!6}{0.3962} & \cellcolor{gray!6}{0.3019} & \cellcolor{gray!6}{0.2481}\\
 &  &  & (0.0184) & \textbf{(0.0176)} &  & (0.0077) & (0.0313) & (0.0250)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panel} & \cellcolor{gray!6}{-149.8518} & \cellcolor{gray!6}{-156.2346} & \cellcolor{gray!6}{0.7107} & \textbf{\cellcolor{gray!6}{0.6359}} & \cellcolor{gray!6}{9.7674} & \cellcolor{gray!6}{0.3912} & \cellcolor{gray!6}{0.3066} & \cellcolor{gray!6}{0.2470}\\
 &  &  & (0.0185) & \textbf{(0.0169)} &  & (0.0075) & (0.0313) & (0.0251)\\
\addlinespace
\cellcolor{gray!6}{c.ma} & \cellcolor{gray!6}{-120.8108} & \cellcolor{gray!6}{-127.1936} & \cellcolor{gray!6}{0.6922} & \textbf{\cellcolor{gray!6}{0.6313}} & \cellcolor{gray!6}{5.7813} & \cellcolor{gray!6}{0.3989} & \cellcolor{gray!6}{0.3160} & \cellcolor{gray!6}{0.2590}\\
 &  &  & (0.0181) & \textbf{(0.0170)} &  & (0.0077) & (0.0313) & (0.0259)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton13.panelr15} & \cellcolor{gray!6}{-126.2968} & \cellcolor{gray!6}{-132.6796} & \cellcolor{gray!6}{0.6924} & \textbf{\cellcolor{gray!6}{0.6311}} & \cellcolor{gray!6}{6.5289} & \cellcolor{gray!6}{0.4297} & \cellcolor{gray!6}{0.2830} & \cellcolor{gray!6}{0.2647}\\
 &  &  & (0.0180) & \textbf{(0.0175)} &  & (0.0079) & (0.0313) & (0.0245)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panelr20} & \cellcolor{gray!6}{-164.6015} & \cellcolor{gray!6}{-170.9842} & \cellcolor{gray!6}{0.7158} & \textbf{\cellcolor{gray!6}{0.6302}} & \cellcolor{gray!6}{10.8558} & \cellcolor{gray!6}{0.3948} & \cellcolor{gray!6}{0.2925} & \cellcolor{gray!6}{0.2414}\\
 &  &  & (0.0189) & \textbf{(0.0181)} &  & (0.0074) & (0.0313) & (0.0241)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panelr15} & \cellcolor{gray!6}{-154.4533} & \cellcolor{gray!6}{-160.8361} & \cellcolor{gray!6}{0.7091} & \textbf{\cellcolor{gray!6}{0.6270}} & \cellcolor{gray!6}{11.5510} & \cellcolor{gray!6}{0.3854} & \cellcolor{gray!6}{0.2972} & \cellcolor{gray!6}{0.2369}\\
 &  &  & (0.0190) & \textbf{(0.0184)} &  & (0.0077) & (0.0325) & (0.0254)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton13.panel} & \cellcolor{gray!6}{-133.9347} & \cellcolor{gray!6}{-140.3175} & \cellcolor{gray!6}{0.6922} & \textbf{\cellcolor{gray!6}{0.6250}} & \cellcolor{gray!6}{4.9769} & \cellcolor{gray!6}{0.4285} & \cellcolor{gray!6}{0.2877} & \cellcolor{gray!6}{0.2664}\\
 &  &  & (0.0184) & \textbf{(0.0169)} &  & (0.0075) & (0.0301) & (0.0239)\\
\addlinespace
\cellcolor{gray!6}{c.bn2.r20} & \cellcolor{gray!6}{-109.3128} & \cellcolor{gray!6}{-115.6955} & \cellcolor{gray!6}{0.6963} & \textbf{\cellcolor{gray!6}{0.6218}} & \cellcolor{gray!6}{0.2776} & \cellcolor{gray!6}{0.4080} & \cellcolor{gray!6}{0.3255} & \cellcolor{gray!6}{0.2724}\\
 &  &  & (0.0188) & \textbf{(0.0170)} &  & (0.0079) & (0.0313) & (0.0268)\\
\addlinespace
\cellcolor{gray!6}{c.linear} & \cellcolor{gray!6}{-135.4069} & \cellcolor{gray!6}{-141.7896} & \cellcolor{gray!6}{0.6879} & \textbf{\cellcolor{gray!6}{0.6204}} & \cellcolor{gray!6}{3.9989} & \cellcolor{gray!6}{0.4616} & \cellcolor{gray!6}{0.2925} & \cellcolor{gray!6}{0.2986}\\
 &  &  & (0.0191) & \textbf{(0.0145)} &  & (0.0079) & (0.0325) & (0.0264)\\
\addlinespace
\cellcolor{gray!6}{c.bn6} & \cellcolor{gray!6}{-132.7915} & \cellcolor{gray!6}{-139.1742} & \cellcolor{gray!6}{0.6835} & \textbf{\cellcolor{gray!6}{0.6113}} & \cellcolor{gray!6}{0.4710} & \cellcolor{gray!6}{0.4371} & \cellcolor{gray!6}{0.2830} & \cellcolor{gray!6}{0.2712}\\
 &  &  & (0.0194) & \textbf{(0.0188)} &  & (0.0075) & (0.0313) & (0.0242)\\
\addlinespace
\cellcolor{gray!6}{c.bn2.r15} & \cellcolor{gray!6}{-83.9469} & \cellcolor{gray!6}{-90.3297} & \cellcolor{gray!6}{0.6749} & \textbf{\cellcolor{gray!6}{0.6047}} & \cellcolor{gray!6}{0.1349} & \cellcolor{gray!6}{0.4761} & \cellcolor{gray!6}{0.3302} & \cellcolor{gray!6}{0.3357}\\
 &  &  & (0.0192) & \textbf{(0.0149)} &  & (0.0074) & (0.0313) & (0.0277)\\
\addlinespace
\cellcolor{gray!6}{c.poly4.r20} & \cellcolor{gray!6}{3.5738} & \cellcolor{gray!6}{-2.8090} & \cellcolor{gray!6}{0.5772} & \textbf{\cellcolor{gray!6}{0.6011}} & \cellcolor{gray!6}{0.1651} & \cellcolor{gray!6}{0.4980} & \cellcolor{gray!6}{0.3302} & \cellcolor{gray!6}{0.3570}\\
 &  &  & (0.0154) & \textbf{(0.0144)} &  & (0.0077) & (0.0313) & (0.0284)\\
\addlinespace
\textbf{\cellcolor{gray!6}{BIS Basel gap}} & \textbf{\cellcolor{gray!6}{-121.5910}} & \textbf{\cellcolor{gray!6}{-127.9738}} & \textbf{\cellcolor{gray!6}{0.6733}} & \textbf{\textbf{\cellcolor{gray!6}{0.5960}}} & \textbf{\cellcolor{gray!6}{3.0578}} & \textbf{\cellcolor{gray!6}{0.4441}} & \textbf{\cellcolor{gray!6}{0.3255}} & \textbf{\cellcolor{gray!6}{0.3032}}\\
\textbf{} & \textbf{} & \textbf{} & \textbf{(0.0197)} & \textbf{\textbf{(0.0164)}} & \textbf{} & \textbf{(0.0077)} & \textbf{(0.0325)} & \textbf{(0.0281)}\\
\addlinespace
\cellcolor{gray!6}{c.bn4} & \cellcolor{gray!6}{-169.1186} & \cellcolor{gray!6}{-175.5014} & \cellcolor{gray!6}{0.6892} & \textbf{\cellcolor{gray!6}{0.5943}} & \cellcolor{gray!6}{1.2840} & \cellcolor{gray!6}{0.3837} & \cellcolor{gray!6}{0.3255} & \cellcolor{gray!6}{0.2532}\\
 &  &  & (0.0204) & \textbf{(0.0206)} &  & (0.0075) & (0.0325) & (0.0268)\\
\addlinespace
\cellcolor{gray!6}{c.stm.r15} & \cellcolor{gray!6}{-79.5531} & \cellcolor{gray!6}{-85.9358} & \cellcolor{gray!6}{0.6575} & \textbf{\cellcolor{gray!6}{0.5924}} & \cellcolor{gray!6}{2.0027} & \cellcolor{gray!6}{0.4778} & \cellcolor{gray!6}{0.3160} & \cellcolor{gray!6}{0.3281}\\
 &  &  & (0.0193) & \textbf{(0.0167)} &  & (0.0075) & (0.0325) & (0.0279)\\
\addlinespace
\cellcolor{gray!6}{c.hp125k} & \cellcolor{gray!6}{-92.2897} & \cellcolor{gray!6}{-98.6725} & \cellcolor{gray!6}{0.6562} & \textbf{\cellcolor{gray!6}{0.5924}} & \cellcolor{gray!6}{2.5216} & \cellcolor{gray!6}{0.4547} & \cellcolor{gray!6}{0.3302} & \cellcolor{gray!6}{0.3158}\\
 &  &  & (0.0194) & \textbf{(0.0164)} &  & (0.0077) & (0.0337) & (0.0293)\\
\addlinespace
\cellcolor{gray!6}{c.hp221k} & \cellcolor{gray!6}{-106.8842} & \cellcolor{gray!6}{-113.2670} & \cellcolor{gray!6}{0.6656} & \textbf{\cellcolor{gray!6}{0.5921}} & \cellcolor{gray!6}{2.6641} & \cellcolor{gray!6}{0.4561} & \cellcolor{gray!6}{0.3160} & \cellcolor{gray!6}{0.3079}\\
 &  &  & (0.0196) & \textbf{(0.0163)} &  & (0.0077) & (0.0325) & (0.0274)\\
\addlinespace
\cellcolor{gray!6}{c.hp400k.r15} & \cellcolor{gray!6}{-67.1228} & \cellcolor{gray!6}{-73.5055} & \cellcolor{gray!6}{0.6472} & \textbf{\cellcolor{gray!6}{0.5912}} & \cellcolor{gray!6}{2.6223} & \cellcolor{gray!6}{0.4592} & \cellcolor{gray!6}{0.3255} & \cellcolor{gray!6}{0.3168}\\
 &  &  & (0.0190) & \textbf{(0.0164)} &  & (0.0075) & (0.0313) & (0.0272)\\
\bottomrule
\multicolumn{9}{l}{\textsuperscript{} The standard deviation for each estimates are deducted from 95\% confidence interval of the bootstrapping results}\\
\multicolumn{9}{l}{using 2000 stratified bootstrap replicates.}\\
\end{tabular}}
\end{table}

### Performance Metrics
Along with the results from Table \@ref(tab:varcompAE) - \@ref(tab:varcompfull), we will discuss psAUC as a performance measurement criteria of a credit gap series as an EWI. 

Firstly, the psAUC metric overall gives a consistent signal about the quality of the credit gap decomposition filters. A filter with a higher psAUC value, in general, will have a higher quality set of possible policy loss function values to optimize. The standard deviation values of the weighted cycle metrics are also comparable to the other gap measurements.

In some scenarios, psAUC can be a deciding factor if policymakers are indifferent about the AUC value of a filter. In Table \@ref(tab:varcompfull), the Moving Average (c.ma) and Hamilton 13th lag using panel setting (c.hamilton13.panel) filters have the same AUC values. While the BIC and AIC values, the overall linearized binary logistic regression fitness criteria, would favor (c.hamilton13.panel) filter. The psAUC indicates otherwise. If we only focus on the region where FPR or the optimized threshold's predictive power is at least 2/3, the minimized policy loss function would favor c.ma. 

However, there are also instances where psAUC failed to be a single criterion for determining the performance of a filter. In Table \@ref(tab:varcompfull), the 4th-degree polynomial filter with a rolling sample of 20 years (c.poly4.r20) have a higher psAUC value than the BIS Basel gap. However, all of (c.poly4.r20) filter's other metrics have less preferred values than the BIS Basel gap. As a result, we will deem (c.poly4.r20) less preferred than the BIS Basel gap. 

In conclusion, even though psAUC is an overall good measurement for a specific case of binary regression model, where Type II errors are costlier than Type I errors, we focus our optimized threshold on the region where Type II errors are less than 1/3. We still have to use it in conjunction with other criteria such as BIC, AUC, and loss function to determine the performance of a filter. Using it alone will not give biased results of the model performance.


### Weighted gap and other gaps performance comparison

In this part, we will discuss the performance of the weighted credit gap series as an EWI and compare it with other selected series.

From Table \@ref(tab:varcompAE) and Table \@ref(tab:varcompfull) regarding Advanced Economies and full sample results, the weighted credit cycle outperformed other cycles in AUC, psAUC, and Policy Loss function values. Specifically, while maintaining approximately the same optimized threshold as the BIS Basel gap, the weighted credit cycle can achieve lower Type I and II error rates than the BIS Basel gap in all samples.

The findings in Advanced Economies and full sample results also align with the literature findings. Hamilton, moving average filters with optimized parameters perform well, which agrees with the findings in @beltran_optimizing_2021. @drehmann_which_2021 proposed using Hamilton filter in a panel setting with fixed sloping coefficients across countries, and @galan_measuring_2019 found rolling sample with 15 and 20 years window helps with improvement of the early indicator performance.

Across the three tables, optimizing and changing parameters on the one-sided HP filter does not improve its performance over the BIS Basel gap. Contrary to the finding in @beltran_optimizing_2021 and @galan_measuring_2019. The author did not use a full sample analysis but by individual countries. The structural time series filter proposed in @beltran_optimizing_2021 also did not perform better than the BIS Basel gap. 

Unsurprisingly, parsimony filters such as linear and polynomial does not perform well in AE and full sample. However, they can outperform other well-studied gaps in EMEs. This confirmed our finding in the previous section \@ref(weight-graphs) that when data are limited, and the market economies are not well established, parsimony filters outperformed other complex filters.

We want to reiterate the importance of avoiding the pitfall of using a single criterion for selecting models, even for the psAUC metric. In Table \@ref(tab:varcompEME). The (c.poly3) filter has a higher psAUC value than its next filter on the table (c.bn2.r15). However, because (c.poly3)'s other metrics have lower quality than its counterpart, the policy loss function, Type I and II errors rates are higher for (c.poly3).

Last but not least, the emerging market economies (EMEs) have proven challenging to predict crises using the credit gap as EWI because of their more limited sample sizes and less established financial systems. Both @beltran_optimizing_2021 and @drehmann_which_2021 found that credit gap-based EWIs do not perform well in emerging market economies. In this paper, we found evidence that adding Beveridge-Nelson decomposition filters to the model selection process improved our model performance for the EMEs, specifically the (c.bn3.r15) Beveridge-Nelson with smoothing parameter 3 and 15 years rolling sample filter. Later graphical analysis in this paper on EMEs will include (c.bn3.r15) filter as another reference. Another Beveridge-Nelson filter with specific features such as (c.bn6.r20) also performs well in both AE and full samples.

<!--
(Reconfirm findings in other papers)
  (Compare results of certain papers and also compare the results of the three regions)
  (Compare results of hybrid (rolling and panel) and how that creates an even better indicator)
  (However, changing parameter for the one sided hp filter does not seem to prove helpful)
(Discuss outliers and pitfall of using a single criterion for selecting models)
(Establish superiority of the weighted gap)
(Establish superiority of the new EWI criteria)
(BN gap works better than other gaps for EME)
-->


## Out of sample forecast {#cross-validation}

<!--(Discuss cross validation methods)-->
We followed @alessi_identifying_2018 in implementing k-fold leave-one-out cross-validation to perform an out-of-sample forecast analysis. To assess the out-of-sample predictive power of the credit gaps, we perform a 3-fold cross-validation, in which the data is randomly split into three partitions. For each partition, the model is estimated using the other two groups. The resulting estimated parameter is then used to predict the dependent variable in the unused group. We then compute psAUCs and other metrics values and obtain the average metrics and their standard deviations from 10 repeats.

\begin{table}[H]

\caption{(\#tab:cvvarcompAE)Credit gaps performance as EWIs - Out of sample prediction - AE}
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{lll>{}lllll}
\toprule
Cycle & BIC & AUC & psAUC & c.Threshold & Type I & Type II & Policy Loss Function\\
\midrule
\cellcolor{gray!6}{c.null} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{0.4729} & \textbf{\cellcolor{gray!6}{0.4906}} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{1.0000} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{1.0000}\\
 & (1.4201) & (0.0099) & \textbf{(0.0032)} &  &  &  & \\
\addlinespace
\cellcolor{gray!6}{c.hamilton13.panelr15} & \cellcolor{gray!6}{-92.1757} & \cellcolor{gray!6}{0.7247} & \textbf{\cellcolor{gray!6}{0.6801}} & \cellcolor{gray!6}{8.0229} & \cellcolor{gray!6}{0.3694} & \cellcolor{gray!6}{0.2909} & \cellcolor{gray!6}{0.2220}\\
 & (3.1133) & (0.0050) & \textbf{(0.0053)} & (1.3409) & (0.0218) & (0.0245) & (0.0085)\\
\addlinespace
\textbf{\cellcolor{gray!6}{1.sided weighted.cycle}} & \textbf{\cellcolor{gray!6}{-83.3823}} & \textbf{\cellcolor{gray!6}{0.7469}} & \textbf{\textbf{\cellcolor{gray!6}{0.6776}}} & \textbf{\cellcolor{gray!6}{3.7972}} & \textbf{\cellcolor{gray!6}{0.3261}} & \textbf{\cellcolor{gray!6}{0.2915}} & \textbf{\cellcolor{gray!6}{0.1923}}\\
\textbf{} & \textbf{(5.0485)} & \textbf{(0.0084)} & \textbf{\textbf{(0.0127)}} & \textbf{(0.8036)} & \textbf{(0.0200)} & \textbf{(0.0253)} & \textbf{(0.0158)}\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panelr15} & \cellcolor{gray!6}{-102.2043} & \cellcolor{gray!6}{0.7442} & \textbf{\cellcolor{gray!6}{0.6755}} & \cellcolor{gray!6}{12.1456} & \cellcolor{gray!6}{0.3595} & \cellcolor{gray!6}{0.2744} & \cellcolor{gray!6}{0.2058}\\
 & (3.1634) & (0.0036) & \textbf{(0.0059)} & (1.7511) & (0.0202) & (0.0300) & (0.0070)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panelr20} & \cellcolor{gray!6}{-106.5651} & \cellcolor{gray!6}{0.7469} & \textbf{\cellcolor{gray!6}{0.6748}} & \cellcolor{gray!6}{12.2954} & \cellcolor{gray!6}{0.3625} & \cellcolor{gray!6}{0.2722} & \cellcolor{gray!6}{0.2061}\\
 & (3.8537) & (0.0040) & \textbf{(0.0061)} & (1.8840) & (0.0151) & (0.0213) & (0.0037)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panel} & \cellcolor{gray!6}{-89.7510} & \cellcolor{gray!6}{0.7354} & \textbf{\cellcolor{gray!6}{0.6705}} & \cellcolor{gray!6}{10.0439} & \cellcolor{gray!6}{0.3930} & \cellcolor{gray!6}{0.2585} & \cellcolor{gray!6}{0.2220}\\
 & (2.9903) & (0.0024) & \textbf{(0.0036)} & (1.9885) & (0.0157) & (0.0226) & (0.0041)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton13.panel} & \cellcolor{gray!6}{-101.4619} & \cellcolor{gray!6}{0.7184} & \textbf{\cellcolor{gray!6}{0.6665}} & \cellcolor{gray!6}{6.7644} & \cellcolor{gray!6}{0.3714} & \cellcolor{gray!6}{0.2983} & \cellcolor{gray!6}{0.2287}\\
 & (1.6108) & (0.0022) & \textbf{(0.0022)} & (1.0174) & (0.0260) & (0.0355) & (0.0039)\\
\addlinespace
\cellcolor{gray!6}{c.ma} & \cellcolor{gray!6}{-69.1570} & \cellcolor{gray!6}{0.7091} & \textbf{\cellcolor{gray!6}{0.6630}} & \cellcolor{gray!6}{6.0750} & \cellcolor{gray!6}{0.3994} & \cellcolor{gray!6}{0.2818} & \cellcolor{gray!6}{0.2410}\\
 & (3.2513) & (0.0036) & \textbf{(0.0051)} & (0.7204) & (0.0244) & (0.0405) & (0.0065)\\
\addlinespace
\cellcolor{gray!6}{c.bn6.r20} & \cellcolor{gray!6}{-72.3756} & \cellcolor{gray!6}{0.7062} & \textbf{\cellcolor{gray!6}{0.6353}} & \cellcolor{gray!6}{0.6105} & \cellcolor{gray!6}{0.4187} & \cellcolor{gray!6}{0.3028} & \cellcolor{gray!6}{0.2691}\\
 & (2.7401) & (0.0122) & \textbf{(0.0158)} & (1.4701) & (0.0333) & (0.0349) & (0.0324)\\
\addlinespace
\cellcolor{gray!6}{c.hp125k} & \cellcolor{gray!6}{-71.8112} & \cellcolor{gray!6}{0.6930} & \textbf{\cellcolor{gray!6}{0.6351}} & \cellcolor{gray!6}{3.5090} & \cellcolor{gray!6}{0.4030} & \cellcolor{gray!6}{0.3057} & \cellcolor{gray!6}{0.2568}\\
 & (5.1241) & (0.0039) & \textbf{(0.0030)} & (1.0440) & (0.0250) & (0.0217) & (0.0098)\\
\addlinespace
\textbf{\cellcolor{gray!6}{BIS Basel gap}} & \textbf{\cellcolor{gray!6}{-87.6905}} & \textbf{\cellcolor{gray!6}{0.7089}} & \textbf{\textbf{\cellcolor{gray!6}{0.6350}}} & \textbf{\cellcolor{gray!6}{4.4951}} & \textbf{\cellcolor{gray!6}{0.3818}} & \textbf{\cellcolor{gray!6}{0.3131}} & \textbf{\cellcolor{gray!6}{0.2451}}\\
\textbf{} & \textbf{(2.4274)} & \textbf{(0.0029)} & \textbf{\textbf{(0.0049)}} & \textbf{(0.9743)} & \textbf{(0.0255)} & \textbf{(0.0283)} & \textbf{(0.0059)}\\
\addlinespace
\cellcolor{gray!6}{c.stm.r15} & \cellcolor{gray!6}{-65.4667} & \cellcolor{gray!6}{0.6950} & \textbf{\cellcolor{gray!6}{0.6349}} & \cellcolor{gray!6}{3.7851} & \cellcolor{gray!6}{0.3723} & \cellcolor{gray!6}{0.3216} & \cellcolor{gray!6}{0.2424}\\
 & (2.8230) & (0.0018) & \textbf{(0.0017)} & (0.7083) & (0.0170) & (0.0108) & (0.0102)\\
\addlinespace
\cellcolor{gray!6}{c.hp400k.r15} & \cellcolor{gray!6}{-58.7622} & \cellcolor{gray!6}{0.6830} & \textbf{\cellcolor{gray!6}{0.6330}} & \cellcolor{gray!6}{4.2265} & \cellcolor{gray!6}{0.3756} & \cellcolor{gray!6}{0.3051} & \cellcolor{gray!6}{0.2352}\\
 & (3.6325) & (0.0028) & \textbf{(0.0037)} & (0.9549) & (0.0276) & (0.0191) & (0.0108)\\
\addlinespace
\cellcolor{gray!6}{c.linear} & \cellcolor{gray!6}{-87.1078} & \cellcolor{gray!6}{0.7045} & \textbf{\cellcolor{gray!6}{0.6328}} & \cellcolor{gray!6}{4.8208} & \cellcolor{gray!6}{0.4265} & \cellcolor{gray!6}{0.3040} & \cellcolor{gray!6}{0.2747}\\
 & (2.9343) & (0.0024) & \textbf{(0.0035)} & (0.8031) & (0.0104) & (0.0184) & (0.0091)\\
\addlinespace
\cellcolor{gray!6}{c.hp221k} & \cellcolor{gray!6}{-79.5029} & \cellcolor{gray!6}{0.7001} & \textbf{\cellcolor{gray!6}{0.6311}} & \cellcolor{gray!6}{3.6423} & \cellcolor{gray!6}{0.3779} & \cellcolor{gray!6}{0.3165} & \cellcolor{gray!6}{0.2434}\\
 & (4.4132) & (0.0051) & \textbf{(0.0070)} & (1.1691) & (0.0149) & (0.0154) & (0.0116)\\
\addlinespace
\cellcolor{gray!6}{c.stm} & \cellcolor{gray!6}{-71.3061} & \cellcolor{gray!6}{0.6881} & \textbf{\cellcolor{gray!6}{0.6298}} & \cellcolor{gray!6}{2.9453} & \cellcolor{gray!6}{0.4040} & \cellcolor{gray!6}{0.3153} & \cellcolor{gray!6}{0.2631}\\
 & (2.9283) & (0.0028) & \textbf{(0.0044)} & (0.8258) & (0.0143) & (0.0140) & (0.0071)\\
\addlinespace
\cellcolor{gray!6}{c.hp400k.r20} & \cellcolor{gray!6}{-74.2327} & \cellcolor{gray!6}{0.6940} & \textbf{\cellcolor{gray!6}{0.6286}} & \cellcolor{gray!6}{3.7081} & \cellcolor{gray!6}{0.3932} & \cellcolor{gray!6}{0.3165} & \cellcolor{gray!6}{0.2554}\\
 & (2.0353) & (0.0050) & \textbf{(0.0067)} & (1.2202) & (0.0258) & (0.0085) & (0.0208)\\
\addlinespace
\cellcolor{gray!6}{c.bn6} & \cellcolor{gray!6}{-76.6398} & \cellcolor{gray!6}{0.6914} & \textbf{\cellcolor{gray!6}{0.6243}} & \cellcolor{gray!6}{1.1094} & \cellcolor{gray!6}{0.4392} & \cellcolor{gray!6}{0.2960} & \cellcolor{gray!6}{0.2830}\\
 & (2.4656) & (0.0100) & \textbf{(0.0141)} & (0.6884) & (0.0417) & (0.0324) & (0.0268)\\
\addlinespace
\cellcolor{gray!6}{c.stm.r20} & \cellcolor{gray!6}{-70.6443} & \cellcolor{gray!6}{0.6818} & \textbf{\cellcolor{gray!6}{0.6219}} & \cellcolor{gray!6}{2.9958} & \cellcolor{gray!6}{0.4207} & \cellcolor{gray!6}{0.3227} & \cellcolor{gray!6}{0.2813}\\
 & (2.8287) & (0.0049) & \textbf{(0.0051)} & (1.0397) & (0.0069) & (0.0128) & (0.0047)\\
\addlinespace
\cellcolor{gray!6}{c.bn4} & \cellcolor{gray!6}{-94.6995} & \cellcolor{gray!6}{0.6964} & \textbf{\cellcolor{gray!6}{0.6174}} & \cellcolor{gray!6}{1.8741} & \cellcolor{gray!6}{0.3953} & \cellcolor{gray!6}{0.3125} & \cellcolor{gray!6}{0.2549}\\
 & (1.7677) & (0.0072) & \textbf{(0.0103)} & (0.8777) & (0.0306) & (0.0149) & (0.0286)\\
\bottomrule
\multicolumn{8}{l}{\rule{0pt}{1em}\textit{Note: }}\\
\multicolumn{8}{l}{\rule{0pt}{1em}3-fold cross-validation results. Standard errors are reported in parentheses.}\\
\end{tabular}}
\end{table}


\begin{table}[H]

\caption{(\#tab:cvvarcompEME)Credit gaps performance as EWIs - Out of sample prediction - EME}
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{lll>{}lllll}
\toprule
Cycle & BIC & AUC & psAUC & c.Threshold & Type I & Type II & Policy Loss Function\\
\midrule
\cellcolor{gray!6}{c.null} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{0.4445} & \textbf{\cellcolor{gray!6}{0.4828}} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{1.0000} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{1.0000}\\
 & (2.1053) & (0.0294) & \textbf{(0.0081)} &  &  &  & \\
\addlinespace
\cellcolor{gray!6}{c.bn3.r15} & \cellcolor{gray!6}{-42.6016} & \cellcolor{gray!6}{0.7211} & \textbf{\cellcolor{gray!6}{0.6224}} & \cellcolor{gray!6}{0.3484} & \cellcolor{gray!6}{0.3928} & \cellcolor{gray!6}{0.3111} & \cellcolor{gray!6}{0.2569}\\
 & (2.2377) & (0.0293) & \textbf{(0.0301)} & (0.4116) & (0.0764) & (0.0255) & (0.0709)\\
\addlinespace
\cellcolor{gray!6}{c.linear} & \cellcolor{gray!6}{-18.9590} & \cellcolor{gray!6}{0.5665} & \textbf{\cellcolor{gray!6}{0.5675}} & \cellcolor{gray!6}{0.7792} & \cellcolor{gray!6}{0.6094} & \cellcolor{gray!6}{0.2889} & \cellcolor{gray!6}{0.4599}\\
 & (4.6826) & (0.0110) & \textbf{(0.0123)} & (2.2166) & (0.0510) & (0.0559) & (0.0407)\\
\addlinespace
\cellcolor{gray!6}{c.bn2.r20} & \cellcolor{gray!6}{-7.2882} & \cellcolor{gray!6}{0.6564} & \textbf{\cellcolor{gray!6}{0.5579}} & \cellcolor{gray!6}{0.1180} & \cellcolor{gray!6}{0.4755} & \cellcolor{gray!6}{0.3167} & \cellcolor{gray!6}{0.3300}\\
 & (2.2840) & (0.0162) & \textbf{(0.0164)} & (0.3002) & (0.0576) & (0.0268) & (0.0459)\\
\addlinespace
\cellcolor{gray!6}{c.bn2.r15} & \cellcolor{gray!6}{-3.5368} & \cellcolor{gray!6}{0.6418} & \textbf{\cellcolor{gray!6}{0.5570}} & \cellcolor{gray!6}{0.0252} & \cellcolor{gray!6}{0.4911} & \cellcolor{gray!6}{0.3306} & \cellcolor{gray!6}{0.3557}\\
 & (1.8649) & (0.0392) & \textbf{(0.0247)} & (0.4690) & (0.0757) & (0.0088) & (0.0745)\\
\addlinespace
\cellcolor{gray!6}{c.poly3} & \cellcolor{gray!6}{1.7710} & \cellcolor{gray!6}{0.5143} & \textbf{\cellcolor{gray!6}{0.5499}} & \cellcolor{gray!6}{3.0514} & \cellcolor{gray!6}{0.6313} & \cellcolor{gray!6}{0.2917} & \cellcolor{gray!6}{0.4900}\\
 & (0.9026) & (0.0404) & \textbf{(0.0367)} & (7.6000) & (0.0705) & (0.0458) & (0.1062)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panel} & \cellcolor{gray!6}{-23.8796} & \cellcolor{gray!6}{0.5309} & \textbf{\cellcolor{gray!6}{0.5267}} & \cellcolor{gray!6}{-0.8265} & \cellcolor{gray!6}{0.6839} & \cellcolor{gray!6}{0.3028} & \cellcolor{gray!6}{0.5615}\\
 & (4.1713) & (0.0074) & \textbf{(0.0097)} & (4.2248) & (0.0330) & (0.0357) & (0.0352)\\
\addlinespace
\cellcolor{gray!6}{c.ma} & \cellcolor{gray!6}{-26.0114} & \cellcolor{gray!6}{0.5466} & \textbf{\cellcolor{gray!6}{0.5244}} & \cellcolor{gray!6}{1.2194} & \cellcolor{gray!6}{0.6885} & \cellcolor{gray!6}{0.3000} & \cellcolor{gray!6}{0.5666}\\
 & (7.1586) & (0.0068) & \textbf{(0.0168)} & (1.5300) & (0.0302) & (0.0450) & (0.0401)\\
\addlinespace
\textbf{\cellcolor{gray!6}{1.sided weighted.cycle}} & \textbf{\cellcolor{gray!6}{1.6191}} & \textbf{\cellcolor{gray!6}{0.4787}} & \textbf{\textbf{\cellcolor{gray!6}{0.5219}}} & \textbf{\cellcolor{gray!6}{1.5348}} & \textbf{\cellcolor{gray!6}{0.6621}} & \textbf{\cellcolor{gray!6}{0.3056}} & \textbf{\cellcolor{gray!6}{0.5400}}\\
\textbf{} & \textbf{(0.8146)} & \textbf{(0.0301)} & \textbf{\textbf{(0.0306)}} & \textbf{(4.9140)} & \textbf{(0.0877)} & \textbf{(0.0393)} & \textbf{(0.1028)}\\
\addlinespace
\cellcolor{gray!6}{c.hamilton13} & \cellcolor{gray!6}{1.6095} & \cellcolor{gray!6}{0.4816} & \textbf{\cellcolor{gray!6}{0.5197}} & \cellcolor{gray!6}{1.7494} & \cellcolor{gray!6}{0.6581} & \cellcolor{gray!6}{0.3111} & \cellcolor{gray!6}{0.5391}\\
 & (0.8780) & (0.0404) & \textbf{(0.0347)} & (3.5850) & (0.0923) & (0.0410) & (0.1137)\\
\addlinespace
\cellcolor{gray!6}{c.quad} & \cellcolor{gray!6}{1.6542} & \cellcolor{gray!6}{0.4498} & \textbf{\cellcolor{gray!6}{0.5040}} & \cellcolor{gray!6}{-8.3825} & \cellcolor{gray!6}{0.7454} & \cellcolor{gray!6}{0.2806} & \cellcolor{gray!6}{0.6389}\\
 & (0.9705) & (0.0291) & \textbf{(0.0267)} & (9.5714) & (0.0623) & (0.0357) & (0.0948)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton13.panel} & \cellcolor{gray!6}{-7.5078} & \cellcolor{gray!6}{0.4985} & \textbf{\cellcolor{gray!6}{0.5037}} & \cellcolor{gray!6}{-0.4802} & \cellcolor{gray!6}{0.7158} & \cellcolor{gray!6}{0.3139} & \cellcolor{gray!6}{0.6119}\\
 & (7.0689) & (0.0153) & \textbf{(0.0107)} & (2.9623) & (0.0277) & (0.0187) & (0.0342)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panelr20} & \cellcolor{gray!6}{-18.0060} & \cellcolor{gray!6}{0.5006} & \textbf{\cellcolor{gray!6}{0.5034}} & \cellcolor{gray!6}{-5.4259} & \cellcolor{gray!6}{0.7463} & \cellcolor{gray!6}{0.2833} & \cellcolor{gray!6}{0.6407}\\
 & (5.4148) & (0.0075) & \textbf{(0.0176)} & (2.7504) & (0.0456) & (0.0410) & (0.0542)\\
\addlinespace
\textbf{\cellcolor{gray!6}{BIS Basel gap}} & \textbf{\cellcolor{gray!6}{-6.5423}} & \textbf{\cellcolor{gray!6}{0.4791}} & \textbf{\textbf{\cellcolor{gray!6}{0.5023}}} & \textbf{\cellcolor{gray!6}{-4.3181}} & \textbf{\cellcolor{gray!6}{0.7816}} & \textbf{\cellcolor{gray!6}{0.2417}} & \textbf{\cellcolor{gray!6}{0.6759}}\\
\textbf{} & \textbf{(5.8202)} & \textbf{(0.0128)} & \textbf{\textbf{(0.0138)}} & \textbf{(2.1378)} & \textbf{(0.0374)} & \textbf{(0.0764)} & \textbf{(0.0408)}\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panelr15} & \cellcolor{gray!6}{-16.2657} & \cellcolor{gray!6}{0.4841} & \textbf{\cellcolor{gray!6}{0.5022}} & \cellcolor{gray!6}{-2.1619} & \cellcolor{gray!6}{0.7701} & \cellcolor{gray!6}{0.2583} & \cellcolor{gray!6}{0.6641}\\
 & (6.9303) & (0.0190) & \textbf{(0.0214)} & (3.4804) & (0.0471) & (0.0508) & (0.0625)\\
\addlinespace
\cellcolor{gray!6}{c.hp3k} & \cellcolor{gray!6}{1.0131} & \cellcolor{gray!6}{0.5102} & \textbf{\cellcolor{gray!6}{0.5017}} & \cellcolor{gray!6}{-0.2747} & \cellcolor{gray!6}{0.7488} & \cellcolor{gray!6}{0.2861} & \cellcolor{gray!6}{0.6440}\\
 & (0.9964) & (0.0157) & \textbf{(0.0232)} & (1.0254) & (0.0234) & (0.0322) & (0.0445)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton13.panelr15} & \cellcolor{gray!6}{-11.6105} & \cellcolor{gray!6}{0.4688} & \textbf{\cellcolor{gray!6}{0.4976}} & \cellcolor{gray!6}{1.2963} & \cellcolor{gray!6}{0.7628} & \cellcolor{gray!6}{0.2861} & \cellcolor{gray!6}{0.6682}\\
 & (6.0026) & (0.0612) & \textbf{(0.0259)} & (6.5172) & (0.0461) & (0.0541) & (0.0660)\\
\addlinespace
\cellcolor{gray!6}{c.hp25k.r15} & \cellcolor{gray!6}{1.0960} & \cellcolor{gray!6}{0.4604} & \textbf{\cellcolor{gray!6}{0.4957}} & \cellcolor{gray!6}{-1.7970} & \cellcolor{gray!6}{0.7691} & \cellcolor{gray!6}{0.2917} & \cellcolor{gray!6}{0.6797}\\
 & (1.5266) & (0.0283) & \textbf{(0.0135)} & (2.1943) & (0.0419) & (0.0419) & (0.0437)\\
\addlinespace
\cellcolor{gray!6}{c.hp221k} & \cellcolor{gray!6}{-3.6880} & \cellcolor{gray!6}{0.4692} & \textbf{\cellcolor{gray!6}{0.4955}} & \cellcolor{gray!6}{-3.9673} & \cellcolor{gray!6}{0.7913} & \cellcolor{gray!6}{0.2306} & \cellcolor{gray!6}{0.6874}\\
 & (3.7753) & (0.0089) & \textbf{(0.0139)} & (1.9937) & (0.0415) & (0.0859) & (0.0354)\\
\addlinespace
\cellcolor{gray!6}{c.bn6.r20} & \cellcolor{gray!6}{-6.2230} & \cellcolor{gray!6}{0.5007} & \textbf{\cellcolor{gray!6}{0.4948}} & \cellcolor{gray!6}{-0.1197} & \cellcolor{gray!6}{0.6855} & \cellcolor{gray!6}{0.3028} & \cellcolor{gray!6}{0.5650}\\
 & (4.0505) & (0.0238) & \textbf{(0.0125)} & (0.6508) & (0.0541) & (0.0306) & (0.0699)\\
\bottomrule
\multicolumn{8}{l}{\rule{0pt}{1em}\textit{Note: }}\\
\multicolumn{8}{l}{\rule{0pt}{1em}3-fold cross-validation results. Standard errors are reported in parentheses.}\\
\end{tabular}}
\end{table}


\begin{table}[H]

\caption{(\#tab:cvvarcompfull)Credit gaps performance as EWIs - Out of sample prediction - Full sample}
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{lll>{}lllll}
\toprule
Cycle & BIC & AUC & psAUC & c.Threshold & Type I & Type II & Policy Loss Function\\
\midrule
\cellcolor{gray!6}{c.null} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{0.4767} & \textbf{\cellcolor{gray!6}{0.4907}} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{1.0000} & \cellcolor{gray!6}{0.0000} & \cellcolor{gray!6}{1.0000}\\
 & (1.8172) & (0.0128) & \textbf{(0.0049)} &  &  &  & \\
\addlinespace
\textbf{\cellcolor{gray!6}{1.sided weighted.cycle}} & \textbf{\cellcolor{gray!6}{-80.9638}} & \textbf{\cellcolor{gray!6}{0.7134}} & \textbf{\textbf{\cellcolor{gray!6}{0.6404}}} & \textbf{\cellcolor{gray!6}{2.9939}} & \textbf{\cellcolor{gray!6}{0.3707}} & \textbf{\cellcolor{gray!6}{0.3208}} & \textbf{\cellcolor{gray!6}{0.2411}}\\
\textbf{} & \textbf{(5.0654)} & \textbf{(0.0033)} & \textbf{\textbf{(0.0037)}} & \textbf{(0.6513)} & \textbf{(0.0282)} & \textbf{(0.0092)} & \textbf{(0.0164)}\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panel} & \cellcolor{gray!6}{-121.3928} & \cellcolor{gray!6}{0.7078} & \textbf{\cellcolor{gray!6}{0.6318}} & \cellcolor{gray!6}{9.6472} & \cellcolor{gray!6}{0.4043} & \cellcolor{gray!6}{0.3071} & \cellcolor{gray!6}{0.2583}\\
 & (1.7471) & (0.0025) & \textbf{(0.0032)} & (0.3081) & (0.0195) & (0.0155) & (0.0113)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton13.panelr15} & \cellcolor{gray!6}{-120.5975} & \cellcolor{gray!6}{0.6903} & \textbf{\cellcolor{gray!6}{0.6291}} & \cellcolor{gray!6}{6.6028} & \cellcolor{gray!6}{0.4120} & \cellcolor{gray!6}{0.3071} & \cellcolor{gray!6}{0.2646}\\
 & (2.5998) & (0.0016) & \textbf{(0.0019)} & (0.5314) & (0.0158) & (0.0187) & (0.0056)\\
\addlinespace
\cellcolor{gray!6}{c.ma} & \cellcolor{gray!6}{-98.5015} & \cellcolor{gray!6}{0.6892} & \textbf{\cellcolor{gray!6}{0.6276}} & \cellcolor{gray!6}{5.5675} & \cellcolor{gray!6}{0.4045} & \cellcolor{gray!6}{0.3113} & \cellcolor{gray!6}{0.2611}\\
 & (7.0341) & (0.0018) & \textbf{(0.0030)} & (0.6929) & (0.0146) & (0.0201) & (0.0059)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panelr20} & \cellcolor{gray!6}{-139.0052} & \cellcolor{gray!6}{0.7134} & \textbf{\cellcolor{gray!6}{0.6272}} & \cellcolor{gray!6}{10.5537} & \cellcolor{gray!6}{0.3910} & \cellcolor{gray!6}{0.3042} & \cellcolor{gray!6}{0.2458}\\
 & (3.0642) & (0.0018) & \textbf{(0.0027)} & (1.1148) & (0.0119) & (0.0165) & (0.0070)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton13.panel} & \cellcolor{gray!6}{-123.8627} & \cellcolor{gray!6}{0.6894} & \textbf{\cellcolor{gray!6}{0.6220}} & \cellcolor{gray!6}{5.1997} & \cellcolor{gray!6}{0.4206} & \cellcolor{gray!6}{0.3132} & \cellcolor{gray!6}{0.2757}\\
 & (4.9205) & (0.0021) & \textbf{(0.0034)} & (0.6877) & (0.0194) & (0.0199) & (0.0092)\\
\addlinespace
\cellcolor{gray!6}{c.hamilton28.panelr15} & \cellcolor{gray!6}{-132.7462} & \cellcolor{gray!6}{0.7052} & \textbf{\cellcolor{gray!6}{0.6217}} & \cellcolor{gray!6}{11.6613} & \cellcolor{gray!6}{0.3874} & \cellcolor{gray!6}{0.3127} & \cellcolor{gray!6}{0.2486}\\
 & (5.5529) & (0.0041) & \textbf{(0.0053)} & (0.5448) & (0.0245) & (0.0135) & (0.0141)\\
\addlinespace
\cellcolor{gray!6}{c.linear} & \cellcolor{gray!6}{-106.5647} & \cellcolor{gray!6}{0.6846} & \textbf{\cellcolor{gray!6}{0.6158}} & \cellcolor{gray!6}{4.0160} & \cellcolor{gray!6}{0.4621} & \cellcolor{gray!6}{0.3113} & \cellcolor{gray!6}{0.3108}\\
 & (4.8347) & (0.0017) & \textbf{(0.0028)} & (1.5341) & (0.0110) & (0.0156) & (0.0080)\\
\addlinespace
\cellcolor{gray!6}{c.bn2.r20} & \cellcolor{gray!6}{-76.7863} & \cellcolor{gray!6}{0.6908} & \textbf{\cellcolor{gray!6}{0.6137}} & \cellcolor{gray!6}{0.2458} & \cellcolor{gray!6}{0.4327} & \cellcolor{gray!6}{0.3208} & \cellcolor{gray!6}{0.2907}\\
 & (2.1205) & (0.0043) & \textbf{(0.0066)} & (0.2248) & (0.0239) & (0.0116) & (0.0149)\\
\addlinespace
\cellcolor{gray!6}{c.bn6.r20} & \cellcolor{gray!6}{-86.4636} & \cellcolor{gray!6}{0.6757} & \textbf{\cellcolor{gray!6}{0.5987}} & \cellcolor{gray!6}{0.2144} & \cellcolor{gray!6}{0.4713} & \cellcolor{gray!6}{0.3231} & \cellcolor{gray!6}{0.3286}\\
 & (2.8925) & (0.0160) & \textbf{(0.0205)} & (1.1466) & (0.0471) & (0.0114) & (0.0445)\\
\addlinespace
\cellcolor{gray!6}{c.bn6} & \cellcolor{gray!6}{-101.2737} & \cellcolor{gray!6}{0.6693} & \textbf{\cellcolor{gray!6}{0.5935}} & \cellcolor{gray!6}{0.3956} & \cellcolor{gray!6}{0.4611} & \cellcolor{gray!6}{0.3250} & \cellcolor{gray!6}{0.3203}\\
 & (4.0553) & (0.0130) & \textbf{(0.0176)} & (0.6125) & (0.0472) & (0.0061) & (0.0459)\\
\addlinespace
\textbf{\cellcolor{gray!6}{BIS Basel gap}} & \textbf{\cellcolor{gray!6}{-110.9026}} & \textbf{\cellcolor{gray!6}{0.6707}} & \textbf{\textbf{\cellcolor{gray!6}{0.5932}}} & \textbf{\cellcolor{gray!6}{3.3012}} & \textbf{\cellcolor{gray!6}{0.4490}} & \textbf{\cellcolor{gray!6}{0.3250}} & \textbf{\cellcolor{gray!6}{0.3073}}\\
\textbf{} & \textbf{(4.6247)} & \textbf{(0.0018)} & \textbf{\textbf{(0.0025)}} & \textbf{(0.7148)} & \textbf{(0.0080)} & \textbf{(0.0052)} & \textbf{(0.0059)}\\
\addlinespace
\cellcolor{gray!6}{c.hp221k} & \cellcolor{gray!6}{-100.8887} & \cellcolor{gray!6}{0.6632} & \textbf{\cellcolor{gray!6}{0.5908}} & \cellcolor{gray!6}{3.4199} & \cellcolor{gray!6}{0.4530} & \cellcolor{gray!6}{0.3292} & \cellcolor{gray!6}{0.3137}\\
 & (2.0973) & (0.0020) & \textbf{(0.0015)} & (0.5762) & (0.0103) & (0.0020) & (0.0098)\\
\addlinespace
\cellcolor{gray!6}{c.hp125k} & \cellcolor{gray!6}{-88.2934} & \cellcolor{gray!6}{0.6540} & \textbf{\cellcolor{gray!6}{0.5905}} & \cellcolor{gray!6}{2.4639} & \cellcolor{gray!6}{0.4691} & \cellcolor{gray!6}{0.3236} & \cellcolor{gray!6}{0.3248}\\
 & (2.9343) & (0.0012) & \textbf{(0.0019)} & (0.7551) & (0.0079) & (0.0067) & (0.0089)\\
\addlinespace
\cellcolor{gray!6}{c.bn2.r15} & \cellcolor{gray!6}{-47.5774} & \cellcolor{gray!6}{0.6637} & \textbf{\cellcolor{gray!6}{0.5901}} & \cellcolor{gray!6}{0.1127} & \cellcolor{gray!6}{0.5010} & \cellcolor{gray!6}{0.3212} & \cellcolor{gray!6}{0.3550}\\
 & (2.8755) & (0.0110) & \textbf{(0.0152)} & (0.2168) & (0.0270) & (0.0090) & (0.0294)\\
\addlinespace
\cellcolor{gray!6}{c.bn4} & \cellcolor{gray!6}{-143.6399} & \cellcolor{gray!6}{0.6835} & \textbf{\cellcolor{gray!6}{0.5889}} & \cellcolor{gray!6}{0.9797} & \cellcolor{gray!6}{0.4146} & \cellcolor{gray!6}{0.3236} & \cellcolor{gray!6}{0.2772}\\
 & (1.8203) & (0.0043) & \textbf{(0.0061)} & (0.7268) & (0.0233) & (0.0116) & (0.0186)\\
\addlinespace
\cellcolor{gray!6}{c.stm.r15} & \cellcolor{gray!6}{-66.3874} & \cellcolor{gray!6}{0.6530} & \textbf{\cellcolor{gray!6}{0.5879}} & \cellcolor{gray!6}{2.4833} & \cellcolor{gray!6}{0.4742} & \cellcolor{gray!6}{0.3179} & \cellcolor{gray!6}{0.3272}\\
 & (2.6907) & (0.0024) & \textbf{(0.0025)} & (0.8012) & (0.0311) & (0.0190) & (0.0208)\\
\addlinespace
\cellcolor{gray!6}{c.stm} & \cellcolor{gray!6}{-84.2480} & \cellcolor{gray!6}{0.6500} & \textbf{\cellcolor{gray!6}{0.5879}} & \cellcolor{gray!6}{2.3616} & \cellcolor{gray!6}{0.4767} & \cellcolor{gray!6}{0.3250} & \cellcolor{gray!6}{0.3330}\\
 & (3.8697) & (0.0021) & \textbf{(0.0026)} & (0.5334) & (0.0063) & (0.0068) & (0.0056)\\
\addlinespace
\cellcolor{gray!6}{c.hp400k.r15} & \cellcolor{gray!6}{-61.6848} & \cellcolor{gray!6}{0.6439} & \textbf{\cellcolor{gray!6}{0.5876}} & \cellcolor{gray!6}{2.6897} & \cellcolor{gray!6}{0.4627} & \cellcolor{gray!6}{0.3226} & \cellcolor{gray!6}{0.3184}\\
 & (2.2021) & (0.0014) & \textbf{(0.0034)} & (0.8146) & (0.0125) & (0.0102) & (0.0075)\\
\bottomrule
\multicolumn{8}{l}{\rule{0pt}{1em}\textit{Note: }}\\
\multicolumn{8}{l}{\rule{0pt}{1em}3-fold cross-validation results. Standard errors are reported in parentheses.}\\
\end{tabular}}
\end{table}

The overall results of the out-of-sample prediction exercise show similar findings as in the previous subsection \@ref(model-fit) that used bootstrapping method. The ranking of the filters does not change significantly. These results overall affirm the robustness of using credit gaps as EWI models. 

On Table \@ref(tab:cvvarcompAE) regarding the AEs, the weighted cycle has a lower value than the (c.hamilton.panelr15) filter. However, the weighted cycle has a lower loss function value and lower overall Type I and Type II error rates.

Expectedly, for EMEs, on Table \@ref(tab:cvvarcompEME) the parsimony (c.poly3) 3th power polynomial filter dropped its psAUC in out-of-sample prediction context compared to its bootstrapped value on Table \@ref(tab:varcompEME). This could be predicted by its poor metrics such as BIC and Loss Function on the model fitness results in the previous subsection.

Through the two subsections \@ref(model-fit) and \@ref(cross-validation), the model proved to perform well in identifying at-risk periods before a crisis and normal periods of countries in the sample, especially regarding criteria for selecting robust EWI early warning indicators or weighted-averaging between the top candidates for improved model certainty and out-of-sample forecast. With this evidence, We will move our discussion to specific individual countries' analysis in the next section.

<!--
(Discuss results in the three regions, variance difference too)
(Reconfirm findings in previous section with the bootstrapping method)
(Reconfirm findings in other papers)

- (Compare results of certain papers and also compare the results of the three regions)

- (Compare results of hybrid (rolling and panel) and how that creates an even better indicator)

(Establish superiority of the weighted gap)

(Establish superiority of the new EWI criteria)

(BN gap works better than other gaps for EME)-->
