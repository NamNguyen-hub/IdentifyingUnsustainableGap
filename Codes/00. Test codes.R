## Stata installation

#install.packages('RStata')

library('RStata')

options("RStata.StataPath" = "\"C:\\Program Files\\Stata16\\StataMP-64\"")
options("RStata.StataVersion" = 16)

stata("help regress")

chooseStataBin()
options("RStata.StataPath")

stata_path = "\"C:\\Program Files\\Stata16\\StataMP-64\""

stata(stata.path=stata_path,
      c("set obs 200", "gen a = 1"))

stata_src = "
version 10
sysuse auto
reg mpg weight
"
stata(stata.path=stata_path,
      stata_src)


## Data input stata
x <- data.frame(a = rnorm(3), b = letters[1:3])
stata("sum a", data.in = x)

library('RStata')


ssc install estout

#probit crisis gap_h1, vce(cluster id)
probit crisis credit_gap, vce(cluster id)

estout e(out) using matrix.txt, replace
predict crisis_hat
lroc
r(area)
twoway scatter crisis_hat crisis credit_gap, connect(l i) msymbol(i O) sort ylabel(0 1)
graph export mygraph2.pdf, replace


#Import do file

stata_src = "
xtset id date
rocreg crisis credit_gap, cluster(id)
estat nproc, auc
return list
matrix list r(ci_bc)
matrix list r(ci_percentile)
matrix list r(ci_normal)
matrix list r(V)
matrix list r(b)

matrix A = r(b)'
matrix B = r(V)'
matrix C = r(ci_normal)'
putexcel set myresults, replace
putexcel A1 = matrix(A)
putexcel B1 = matrix(B)
putexcel C1 = matrix(C)
rocregplot, plot1opts(msymbol(i))
graph export mygraph1.pdf, replace
"

stata(stata_src, data.in=dfh2)
library(readxl)
x <- read_xlsx("myresults.xlsx", col_names=FALSE)
x <- as.(x)

tabresults = matrix(NA, 4, 12)
tabresults[,1]=t(x)
## Data output stata 
auto <- stata("sysuse auto", data.out = TRUE)

# Test 1 with crisis data
stata("sum crisis", data.in=df)


