# EMPIRICAL RESULTS


# Empirical Results
## Comparing performance of weighted gap - Full Sample

\begin{table}[H]
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{lrrr>{}rrrrr}
\toprule
Cycles & BIC & AIC & AUC & psAUC & c.Threshold & Type.I & Type.II & Policy.Loss.Function\\
\midrule
null & 0.0000 & 0.0000 & 0.5000 & \textbf{0.5000} & NA & 1.0000 & 0.0000 & 1.0000\\
\textbf{1.sided weighted.cycle} & \textbf{-127.5308} & \textbf{-133.9135} & \textbf{0.7182} & \textbf{\textbf{0.6454}} & \textbf{2.8892} & \textbf{0.3532} & \textbf{0.3255} & \textbf{0.2307}\\
c.bn6.r20 & -108.0679 & -114.4506 & 0.7048 & \textbf{0.6379} & 0.6581 & 0.3962 & 0.3019 & 0.2481\\
c.hamilton28.panel & -149.8518 & -156.2346 & 0.7107 & \textbf{0.6359} & 9.7674 & 0.3912 & 0.3066 & 0.2470\\
c.ma & -120.8108 & -127.1936 & 0.6922 & \textbf{0.6313} & 5.7813 & 0.3989 & 0.3160 & 0.2590\\
\addlinespace
c.hamilton13.panelr15 & -126.2968 & -132.6796 & 0.6924 & \textbf{0.6311} & 6.5289 & 0.4297 & 0.2830 & 0.2647\\
c.hamilton28.panelr20 & -164.6015 & -170.9842 & 0.7158 & \textbf{0.6302} & 10.8558 & 0.3948 & 0.2925 & 0.2414\\
c.hamilton28.panelr15 & -154.4533 & -160.8361 & 0.7091 & \textbf{0.6270} & 11.5510 & 0.3854 & 0.2972 & 0.2369\\
c.hamilton13.panel & -133.9347 & -140.3175 & 0.6922 & \textbf{0.6250} & 4.9769 & 0.4285 & 0.2877 & 0.2664\\
c.bn2.r20 & -109.3128 & -115.6955 & 0.6963 & \textbf{0.6218} & 0.2776 & 0.4080 & 0.3255 & 0.2724\\
\addlinespace
c.linear & -135.4069 & -141.7896 & 0.6879 & \textbf{0.6204} & 3.9989 & 0.4616 & 0.2925 & 0.2986\\
c.bn6 & -132.7915 & -139.1742 & 0.6835 & \textbf{0.6113} & 0.4710 & 0.4371 & 0.2830 & 0.2712\\
c.bn2.r15 & -83.9469 & -90.3297 & 0.6749 & \textbf{0.6047} & 0.1349 & 0.4761 & 0.3302 & 0.3357\\
c.poly4.r20 & 3.5738 & -2.8090 & 0.5772 & \textbf{0.6011} & 0.1651 & 0.4980 & 0.3302 & 0.3570\\
\textbf{BIS Basel gap} & \textbf{-121.5910} & \textbf{-127.9738} & \textbf{0.6733} & \textbf{\textbf{0.5960}} & \textbf{3.0578} & \textbf{0.4441} & \textbf{0.3255} & \textbf{0.3032}\\
\addlinespace
c.bn4 & -169.1186 & -175.5014 & 0.6892 & \textbf{0.5943} & 1.2840 & 0.3837 & 0.3255 & 0.2532\\
c.stm.r15 & -79.5531 & -85.9358 & 0.6575 & \textbf{0.5924} & 2.0027 & 0.4778 & 0.3160 & 0.3281\\
c.hp125k & -92.2897 & -98.6725 & 0.6562 & \textbf{0.5924} & 2.5216 & 0.4547 & 0.3302 & 0.3158\\
c.hp221k & -106.8842 & -113.2670 & 0.6656 & \textbf{0.5921} & 2.6641 & 0.4561 & 0.3160 & 0.3079\\
c.hp400k.r15 & -67.1228 & -73.5055 & 0.6472 & \textbf{0.5912} & 2.6223 & 0.4592 & 0.3255 & 0.3168\\
\addlinespace
c.stm & -89.2228 & -95.6055 & 0.6523 & \textbf{0.5903} & 2.2064 & 0.4684 & 0.3302 & 0.3284\\
c.bn3.r15 & -144.4817 & -150.8645 & 0.6687 & \textbf{0.5882} & 0.1862 & 0.4780 & 0.3302 & 0.3375\\
c.hp400k.r20 & -88.8450 & -95.2277 & 0.6545 & \textbf{0.5871} & 2.8130 & 0.4494 & 0.3302 & 0.3110\\
c.stm.r20 & -87.2179 & -93.6006 & 0.6482 & \textbf{0.5859} & 1.9362 & 0.4826 & 0.3302 & 0.3419\\
c.hp25k.r15 & -55.8805 & -62.2632 & 0.6275 & \textbf{0.5812} & 1.1403 & 0.5032 & 0.3066 & 0.3473\\
\addlinespace
c.hp25k & -56.0388 & -62.4215 & 0.6274 & \textbf{0.5782} & 1.2839 & 0.4970 & 0.3160 & 0.3469\\
c.hamilton13 & -23.7688 & -30.1516 & 0.6075 & \textbf{0.5782} & 1.6938 & 0.5006 & 0.3160 & 0.3505\\
c.quad & -85.1640 & -91.5468 & 0.6622 & \textbf{0.5774} & 0.2765 & 0.5162 & 0.3160 & 0.3664\\
c.poly3 & 5.5099 & -0.8728 & 0.5551 & \textbf{0.5597} & -0.5367 & 0.5860 & 0.2689 & 0.4156\\
c.hp3k & -24.5546 & -30.9374 & 0.5979 & \textbf{0.5572} & -0.0472 & 0.5706 & 0.3255 & 0.4315\\
\addlinespace
c.hp3k.r20 & -24.5252 & -30.9080 & 0.5978 & \textbf{0.5571} & -0.0420 & 0.5701 & 0.3255 & 0.4309\\
\bottomrule
\end{tabular}}
\end{table}


## Comparing performance of weighted gap as an EWI - AE

\begin{table}[H]
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{lrrr>{}rrrrr}
\toprule
Cycles & BIC & AIC & AUC & psAUC & c.Threshold & Type.I & Type.II & Policy.Loss.Function\\
\midrule
null & 0.0000 & 0.0000 & 0.5000 & \textbf{0.5000} & NA & 1.0000 & 0.0000 & 1.0000\\
\textbf{1.sided weighted.cycle} & \textbf{-128.8749} & \textbf{-134.9430} & \textbf{0.7545} & \textbf{\textbf{0.6889}} & \textbf{3.5486} & \textbf{0.3177} & \textbf{0.2841} & \textbf{0.1817}\\
c.hamilton13.panelr15 & -116.9260 & -122.9941 & 0.7282 & \textbf{0.6846} & 8.8000 & 0.3469 & 0.3011 & 0.2110\\
c.hamilton28.panelr15 & -141.5772 & -147.6453 & 0.7491 & \textbf{0.6825} & 11.5510 & 0.3834 & 0.2216 & 0.1961\\
c.hamilton28.panelr20 & -147.4322 & -153.5003 & 0.7514 & \textbf{0.6811} & 13.1072 & 0.3489 & 0.2898 & 0.2057\\
\addlinespace
c.bn6.r20 & -90.1022 & -96.1703 & 0.7338 & \textbf{0.6751} & 0.6581 & 0.4126 & 0.2273 & 0.2219\\
c.hamilton28.panel & -129.1730 & -135.2411 & 0.7382 & \textbf{0.6740} & 9.7674 & 0.3977 & 0.2386 & 0.2151\\
c.hamilton13.panel & -122.0054 & -128.0735 & 0.7208 & \textbf{0.6684} & 7.2247 & 0.3509 & 0.3239 & 0.2280\\
c.ma & -97.4868 & -103.5549 & 0.7133 & \textbf{0.6677} & 6.0375 & 0.4073 & 0.2727 & 0.2403\\
c.bn6 & -104.1404 & -110.2085 & 0.7042 & \textbf{0.6426} & 0.8256 & 0.4040 & 0.2955 & 0.2505\\
\addlinespace
c.hp125k & -92.8331 & -98.9012 & 0.6977 & \textbf{0.6397} & 3.6972 & 0.3788 & 0.3239 & 0.2484\\
\textbf{BIS Basel gap} & \textbf{-113.9826} & \textbf{-120.0507} & \textbf{0.7124} & \textbf{\textbf{0.6390}} & \textbf{3.9706} & \textbf{0.3847} & \textbf{0.3011} & \textbf{0.2387}\\
c.hp221k & -104.1190 & -110.1871 & 0.7070 & \textbf{0.6388} & 3.8869 & 0.3755 & 0.3011 & 0.2317\\
c.stm.r15 & -86.6063 & -92.6744 & 0.6989 & \textbf{0.6382} & 4.0784 & 0.3486 & 0.3295 & 0.2301\\
c.stm & -89.9073 & -95.9754 & 0.6929 & \textbf{0.6357} & 3.3071 & 0.3924 & 0.3295 & 0.2626\\
\addlinespace
c.hp400k.r15 & -73.5902 & -79.6582 & 0.6869 & \textbf{0.6357} & 4.2355 & 0.3496 & 0.3125 & 0.2199\\
c.linear & -111.9570 & -118.0251 & 0.7069 & \textbf{0.6356} & 3.9964 & 0.4620 & 0.2443 & 0.2732\\
c.hp400k.r20 & -93.8576 & -99.9257 & 0.6991 & \textbf{0.6340} & 4.3393 & 0.3622 & 0.3295 & 0.2398\\
c.bn2.r20 & -84.0800 & -90.1481 & 0.6955 & \textbf{0.6297} & 0.2773 & 0.4216 & 0.3182 & 0.2790\\
c.stm.r20 & -87.6992 & -93.7673 & 0.6879 & \textbf{0.6282} & 3.1055 & 0.4073 & 0.3239 & 0.2708\\
\addlinespace
c.bn4 & -119.0600 & -125.1280 & 0.7038 & \textbf{0.6272} & 1.8875 & 0.3575 & 0.3295 & 0.2364\\
c.hp25k.r15 & -54.6351 & -60.7032 & 0.6561 & \textbf{0.6138} & 1.6927 & 0.4547 & 0.2784 & 0.2843\\
c.hp25k & -55.5895 & -61.6576 & 0.6569 & \textbf{0.6117} & 1.7847 & 0.4458 & 0.2898 & 0.2827\\
c.poly4.r20 & 2.3864 & -3.6817 & 0.5901 & \textbf{0.6113} & 0.7143 & 0.4494 & 0.3239 & 0.3069\\
c.quad & -88.1553 & -94.2234 & 0.6998 & \textbf{0.6099} & 2.4569 & 0.4017 & 0.3295 & 0.2699\\
\addlinespace
c.bn2.r15 & -62.5255 & -68.5936 & 0.6683 & \textbf{0.6070} & 0.0956 & 0.5075 & 0.3011 & 0.3482\\
c.hamilton13 & -29.9493 & -36.0174 & 0.6334 & \textbf{0.6028} & 3.3153 & 0.4398 & 0.3239 & 0.2983\\
c.bn3.r15 & -93.9600 & -100.0281 & 0.6534 & \textbf{0.5836} & 0.1563 & 0.4896 & 0.3239 & 0.3445\\
c.hp3k & -20.4943 & -26.5624 & 0.6092 & \textbf{0.5725} & 0.1378 & 0.5446 & 0.3068 & 0.3907\\
c.hp3k.r20 & -20.4682 & -26.5363 & 0.6091 & \textbf{0.5724} & 0.1378 & 0.5446 & 0.3068 & 0.3907\\
\addlinespace
c.poly3 & -2.3248 & -8.3929 & 0.5905 & \textbf{0.5723} & 0.2767 & 0.5317 & 0.3295 & 0.3913\\
\bottomrule
\end{tabular}}
\end{table}

## Comparing performance of weighted gap as an EWI - EME

\begin{table}[H]
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{lrrr>{}rrrrr}
\toprule
Cycles & BIC & AIC & AUC & psAUC & c.Threshold & Type.I & Type.II & Policy.Loss.Function\\
\midrule
null & 0.0000 & 0.0000 & 0.5000 & \textbf{0.5000} & NA & 1.0000 & 0.0000 & 1.0000\\
c.bn3.r15 & -46.2774 & -51.3507 & 0.7365 & \textbf{0.6308} & 0.6244 & 0.3059 & 0.3333 & 0.2047\\
c.poly3 & 5.3862 & 0.3129 & 0.5737 & \textbf{0.6046} & 1.8089 & 0.5280 & 0.3056 & 0.3721\\
c.bn2.r15 & -13.2062 & -18.2795 & 0.6879 & \textbf{0.5879} & 0.2952 & 0.3566 & 0.3333 & 0.2383\\
c.poly4.r20 & 7.0732 & 1.9999 & 0.5040 & \textbf{0.5816} & -0.9609 & 0.5962 & 0.3333 & 0.4665\\
\addlinespace
\textbf{1.sided weighted.cycle} & \textbf{6.2094} & \textbf{1.1361} & \textbf{0.5325} & \textbf{\textbf{0.5811}} & \textbf{-1.0639} & \textbf{0.6827} & \textbf{0.1111} & \textbf{0.4784}\\
c.linear & -9.3676 & -14.4409 & 0.5787 & \textbf{0.5774} & -0.9783 & 0.6294 & 0.2222 & 0.4455\\
c.bn2.r20 & -16.6411 & -21.7144 & 0.6760 & \textbf{0.5751} & 0.1470 & 0.4510 & 0.3056 & 0.2968\\
c.hamilton13 & 6.5749 & 1.5016 & 0.5468 & \textbf{0.5710} & 3.6354 & 0.6206 & 0.3056 & 0.4785\\
c.ma & -11.6401 & -16.7133 & 0.5572 & \textbf{0.5457} & -0.2250 & 0.7220 & 0.1667 & 0.5491\\
\addlinespace
c.hamilton28.panel & -7.8687 & -12.9420 & 0.5392 & \textbf{0.5384} & -1.7750 & 0.6958 & 0.2778 & 0.5613\\
c.quad & 6.1997 & 1.1264 & 0.4654 & \textbf{0.5334} & -6.4882 & 0.7456 & 0.1944 & 0.5938\\
c.hamilton13.panelr15 & -1.6660 & -6.7393 & 0.5087 & \textbf{0.5274} & -1.1064 & 0.7002 & 0.3333 & 0.6014\\
c.hp25k.r15 & 3.6420 & -1.4313 & 0.5018 & \textbf{0.5265} & -3.5672 & 0.7850 & 0.1111 & 0.6285\\
c.hp25k & 3.9466 & -1.1267 & 0.4975 & \textbf{0.5247} & -3.7339 & 0.7893 & 0.1111 & 0.6354\\
\addlinespace
c.hp3k & 3.3678 & -1.7054 & 0.5276 & \textbf{0.5235} & -1.1119 & 0.7019 & 0.3333 & 0.6038\\
c.hp3k.r20 & 3.3703 & -1.7030 & 0.5276 & \textbf{0.5235} & -1.1125 & 0.7028 & 0.3333 & 0.6050\\
c.hamilton13.panel & -1.6294 & -6.7027 & 0.5166 & \textbf{0.5222} & -2.9398 & 0.7500 & 0.2778 & 0.6397\\
\textbf{BIS Basel gap} & \textbf{-0.7015} & \textbf{-5.7748} & \textbf{0.4928} & \textbf{\textbf{0.5217}} & \textbf{-5.3969} & \textbf{0.7920} & \textbf{0.1389} & \textbf{0.6465}\\
c.hamilton28.panelr20 & -4.9986 & -10.0719 & 0.5123 & \textbf{0.5213} & -1.5578 & 0.6932 & 0.3333 & 0.5916\\
\addlinespace
c.hamilton28.panelr15 & -3.3914 & -8.4647 & 0.4987 & \textbf{0.5162} & -1.8326 & 0.7220 & 0.3333 & 0.6324\\
c.hp400k.r15 & 5.0603 & -0.0129 & 0.4777 & \textbf{0.5147} & -5.7358 & 0.8121 & 0.1111 & 0.6718\\
c.stm.r15 & 4.7567 & -0.3166 & 0.4780 & \textbf{0.5129} & -5.6472 & 0.8191 & 0.0833 & 0.6778\\
c.hp221k & 1.5902 & -3.4831 & 0.4787 & \textbf{0.5123} & -5.6416 & 0.8121 & 0.1111 & 0.6718\\
c.stm.r20 & 3.1397 & -1.9336 & 0.4768 & \textbf{0.5095} & -5.3727 & 0.8226 & 0.0833 & 0.6835\\
\addlinespace
c.hp125k & 3.0774 & -1.9958 & 0.4740 & \textbf{0.5094} & -5.8918 & 0.8226 & 0.0833 & 0.6835\\
c.stm & 3.1932 & -1.8801 & 0.4757 & \textbf{0.5087} & -5.5221 & 0.8260 & 0.0833 & 0.6893\\
c.hp400k.r20 & 4.1478 & -0.9255 & 0.4596 & \textbf{0.5081} & -6.2903 & 0.8182 & 0.1389 & 0.6887\\
c.bn4 & -42.1713 & -47.2446 & 0.5479 & \textbf{0.4984} & -0.5515 & 0.7509 & 0.2778 & 0.6410\\
c.bn6.r20 & -9.5340 & -14.6072 & 0.5296 & \textbf{0.4965} & -0.5188 & 0.7002 & 0.2778 & 0.5674\\
\addlinespace
c.bn6 & -19.2453 & -24.3186 & 0.5352 & \textbf{0.4911} & -0.5146 & 0.7220 & 0.2778 & 0.5985\\
\bottomrule
\end{tabular}}
\end{table}

## Plot weighted gap against BIS gap


\begin{center}\includegraphics[width=1\linewidth]{../Data/Output/Graphs/Weighted_credit_gap_US} \end{center}

## Plot weighted gap against BIS gap


\begin{center}\includegraphics[width=1\linewidth]{../Data/Output/Graphs/Weighted_credit_gap_UK} \end{center}