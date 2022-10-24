//Empirical Project Do File
//Kyle Chmielewski
//version: 12/9/2021

//import the data from excel
import excel "/Users/kchmielewski/Documents/Junior_Fall/Econometrics/Baseball_collapsed.xls", sheet("Sheet1") firstrow

//summary statistics
sum win_t era_t teamOPS, d 

//generate OPS as a integer for easier interpretation
generate OPS_points = teamOPS*1000

//Generate Dummy variable for World Series Champions
generate champions = 0

replace champions = 1 if wswin_t == "Y"

//Generate Dummy variable for AL or NL
generate AL = 0

replace AL = 1 if teamid == "BAL"

replace AL = 1 if teamid == "BOS"

replace AL = 1 if teamid == "CAL"

replace AL = 1 if teamid == "LAA"

replace AL = 1 if teamid == "CHA"

replace AL = 1 if teamid == "CLE"

replace AL = 1 if teamid == "DET"

replace AL = 1 if teamid == "HOU"

replace AL = 1 if teamid == "KCA"

replace AL = 1 if teamid == "MIN"

replace AL = 1 if teamid == "NYA"

replace AL = 1 if teamid == "OAK"

replace AL = 1 if teamid == "SEA"

replace AL = 1 if teamid == "TEX"

replace AL = 1 if teamid == "TOR"

replace AL = 1 if teamid == "TBA"

//Interaction terms one for ERA and OPS
generate OPS_Interaction = OPS_points*AL

generate ERA_Interaction = era_t*AL

//scatter plots
twoway (scatter win_t teamOPS), name(wins_vs_teamOPS)

twoway (scatter win_t era_t), name(wins_vs_era)

twoway (scatter win_t era_t) (scatter win_t teamOPS), name(both)

//run the simple regression(no controls) regression
reg win_t OPS_points era_t, r

outreg2 using myRegression.xls, replace ctitle(Simple Multivariate Regression)

//regression with control variables
reg win_t OPS_points era_t errors_t hit_t hr_t so_t bb_t, r

outreg2 using myRegression.xls, append ctitle(Multivariate Regression With Controls)

//Hypothesis Testing
test OPS_points==era_t==0

//Linear Probability Model
reg champions OPS_points era_t errors_t hit_t hr_t so_t bb_t, r

outreg2 using myRegression.xls, append ctitle(Linear Probability of Winning Championship)

//Interaction Term Model for OPS 
reg win_t AL OPS_points OPS_Interaction errors_t hit_t hr_t so_t bb_t, r 

outreg2 using myRegression.xls, append ctitle(Interaction Term for OPS)

//Interaction Term Model for ERA
reg win_t AL era_t ERA_Interaction errors_t hit_t hr_t so_t bb_t, r 

outreg2 using myRegression.xls, append ctitle(Interaction Term for ERA)
