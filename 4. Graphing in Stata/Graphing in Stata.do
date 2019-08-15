/*
Author: 	Taren Sanders
Contact:	taren.sanders@acu.edu.au
Available under CC-BY-SA-4.0
*/
version 15
set more off

// Using our wines dataset again
use "~/GitHub/Stata-Workshop/3. Basic Statistics/wines.dta", clear


/*
Quickly going to edit our data to match the one we used for basic stats
*/
recode points (80/85=0) (86/90=1) (91/95=2) (96/100=3), gen(pointcats)
label define pointcatlabel 	0 "<85 Points" 1 "86-90 Points" ///
							2 "91-95 Points" 3 ">95 Points"
label values pointcat pointcatlabel
encode country, gen(countrycat)


/*		SCATTER		*/
scatter points price, by(countrycat)

// Just for bottles less than 200
scatter points price if price<200, by(countrycat)

/*
There's too many countries to plot all at once, but we could combine two graphs
to compare two countries like so.
*/
graph twoway (scatter points price if country=="Australia" & price<200) ///
			 (scatter points price if country=="New Zealand" & price<200), ///
			 legend(label(1 Australia) label(2 New Zealand))
			 
			 
/*		HISTOGRAMS		*/
/*
Good way to check distributions
*/
hist price

// Not great. What if we decrease the number of bins
hist price, bin(5)

// Yep, pretty clearly not well distributed. Let's try points with a normal curve
hist points, norm 

// Why does the normal curve look so strange?
hist points, norm  bin(21)

/*
Also have a look at the manual for diagnostic plots. These are more modern 
approaches to checking data
*/


/*		BAR		*/

/*
Since graphing basically all works the same, i'm just going to show you the
graphs from the Stata documentation
*/

sysuse citytemp, clear
graph bar (mean) tempjuly tempjan, over(region) ///
bargap(-30) ///
legend( label(1 "July") label(2 "January") ) ///
ytitle("Degrees Fahrenheit") ///
title("Average July and January temperatures") ///
subtitle("by regions of the United States") ////
note("Source: U.S. Census Bureau, U.S. Dept. of Commerce") 

/*		Lines	*/
/*
Technically line is just a scatterplot, and has all the same options
*/
sysuse auto, clear
quietly regress mpg weight
predict hat
predict stdf, stdf // This is the standard error
generate lo = hat - 1.96*stdf
generate hi = hat + 1.96*stdf
scatter mpg weight || line hat lo hi weight, pstyle(p2 p3 p3) sort
