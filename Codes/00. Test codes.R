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

#probit crisis gap_h1, vce(cluster id)

stata_src = "
probit crisis credit_gap, vce(cluster id)
predict crisis_hat
lroc
graph export mygraph1.pdf, replace
twoway scatter crisis_hat crisis credit_gap, connect(l i) msymbol(i O) sort ylabel(0 1)
graph export mygraph2.pdf, replace
"

stata(stata_src, data.in=dfh2)


## Data output stata 
auto <- stata("sysuse auto", data.out = TRUE)

# Test 1 with crisis data
stata("sum crisis", data.in=df)


