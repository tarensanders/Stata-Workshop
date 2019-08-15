/*
Author: 	Taren Sanders
Contact:	taren.sanders@acu.edu.au
Available under CC-BY-SA-4.0
*/
version 15
set more off


// Let's use our wine dataset as a worked example
use wines, clear

// Before we do anything else, we should have a look at this dataset
describe
sum

// Let's  look at the two quantitative variables in a bit more detail.
inspect points price
sum points price, detail


/*		TTESTS		*/
/* 
Let's see who produces better wine on average - Australia or France?
*/

// I could do this lots of ways, but the easiest will just be to use an expression
ttest points if country=="Australia" | country=="France", by(country)

// Is it any cheaper?
ttest price if country=="Australia" | country=="France", by(country)

// What about our friends across the ditch?
ttest points if country=="Australia" | country=="New Zealand", by(country)

/*		TABULATIONS and CHI^2		*/
/*
We don't have any categorical variables to play with at the moment, but we 
can always recode some of our other variables.
*/

// Let's recode our points variable into 4 categories like so.
recode points (80/85=0) (86/90=1) (91/95=2) (96/100=3), gen(pointcats)
label define pointcatlabel 	0 "<85 Points" 1 "86-90 Points" ///
							2 "91-95 Points" 3 ">95 Points"
label values pointcat pointcatlabel
tab pointcat

/* 
Now let's do a tabulation and ask for a Pearson's Chi2. We'll do it across 
Australia and New Zealand
*/
tab pointcat country if country=="Australia" | country=="New Zealand", chi2

/* 
The observed differences are significant, but hard to tell with frequencies.
We can redo this test asking for row percentages instead.
I'm also going to specify the option 'all' to get the other tests that tab can
do.
*/
tab pointcat country if country=="Australia" | country=="New Zealand", row nofreq all

/*		CORRELATIONS		*/
/*
Let's ask an important scientific question: is there a correlation between
the price of wine and how good it is?
A correlation would be a simple way to check.
*/

// You can print a correlation matrix for all variables using 'pwcorr' or 'corr'
pwcorr

// Of course, we don't care about correlations with categories or the id variable
// Also, we want to know if these are significant. Let's do that instead.
pwcorr points price, star(0.05)

/*
Note that we ignored some important assumptions here. The most important of which
is that we did not check for outliers.
*/
scatter points price

/*
Let's check our correlation again, only without the very expensive wines.
*/
pwcorr points price if price<1000, star(0.05)
scatter points price if price<1000

/*		REGRESSION		*/
/*
Could we construct a regression equation so that we could predict what the cost
of a bottle of wine would be, given the points and country?
*/

regress price country points

// This fails because 'country' is a string variable, and Stata needs numbers

/*
We've been dealing with country as a string, but in this case it would be better
as a categorical variable
*/
encode country, gen(countrycat)
tab countrycat, sort

// Note that Stata was nice enough to put the labels on the data for us

// Let's try that regression. I'm going to exclude our very expensive wines again
regress price countrycat points if price<1000

/* 
Note that we've made a mistake here. Stata has treated countrycat as a 
continous variable. We can correct this by telling Stata that it is a categorical
variable by prefixing it with 'i.'
Also, so that I don't get a very long list of countries, i'm going to limit it 
to the countries with more wine than Australia.
*/
regress price i.countrycat points ///
		if price<1000 & ///
		inlist(country, "US", "France", "Italy", "Spain", "Portugal", ///
							"Chile", "Argentina", "Austria", "Australia")
							
// I'm going to do it one more time, this time for all countries
regress price i.countrycat points if price<1000

// I can now use this to predict prices for each of our wines
predict predprice
list country points price predprice in 1/10

/*		ANOVA		*/
/*
I'm not going to cover ANOVA in much depth, because it is basically just 
regression.
A simple, and somewhat terrible, example might be:
*/
anova points countrycat if price<1000 & inlist(country, "US", "France", "Italy")

