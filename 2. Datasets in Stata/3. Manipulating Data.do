/*
Author: 	Taren Sanders
Contact:	taren.sanders@acu.edu.au
Available under CC-BY-SA-4.0
*/
version 15
set more off


/*
Let's have a look at some other data manipulations.
Collapse and contract are mostly used for graphing data.
*/

/*		COLLAPSE		*/

// we'll use our basic wine dataset for this
use wines_base, clear

// We'll collapse the dataset for the only two numeric variablers
collapse points price
list

/* 
That was pretty useless. Also, it deleted our dataset, which is not very
helpful. Let's do it again across each country, this time keeping a copy of the
data in memory.
*/
use wines_base, clear
preserve
collapse points price, by(country)
list

// We can also do it for other statistics
preserve
collapse (mean) avgpoints=points avgprice=price ///
(p10) p10points=points p10price=price ///
(p90) p90points=points p90price=price ///
(count) countpoints=points countprice=price, by(country)
list

/*		CONTRACT		*/
/*
Pretty similar to collapse, only for frequencies 
*/
sysuse bplong, clear
preserve
contract sex agegrp when
list

/*		RESHAPE		*/
/*
Reshape lets you transform your data from wide to long format, or vice-versa.
Different data formats are usful for different types of analyses. It can also be
easier to calculate new variables in wide format, before transforming back to 
long.
*/
// We'll reshape our blood pressure dataset from long to wide
sysuse bplong, clear
reshape wide bp, i(patient) j(when)

// Notice that I ommited sex and agegrp. Why?

/*
Once you've reshaped once, you can return to the old format without giving Stata
all of the syntax again.
*/
reshape long
reshape wide

/*		GENERATE and EXTENDED GENERATE		*/
/*
Generate new variables using generage (gen for short), and do more complex
generation using extended generate (egen).
*/

// For an easy example, let's calculate a change score for our bp data
sysuse bplong, clear
reshape wide bp, i(patient) j(when)

gen bpchange = bp2 - bp1

/*
To demo egen, we'll create an average of the two timepoints using rowmean.
Have a look at the help for egen to see other things you can do with it. It is
one of the most powerful commands in Stata
*/
egen bpavg = rowmean(bp?)

// Note the use of '?'. What does this do? Why didn't I use *?

// Another common use of egen is to create categorical variables. 
// Before I do that, I need to know the range of the data I'm categorising
sum bp*
egen bpcat1 = cut(bp1), at(0,119,129,139,186)
egen bpcat2 = cut(bp2), at(0,119,129,139,186)
tab bpcat1 
tab bpcat2

/* 
(NOTE: we could also achieve this using recode, which is explained later. You 
can also use tab..., generate() for a more advanced optoin. This is left to you
to try, if you like).

Our new variables aren't super helpful. Almost everyone is in the high group.
Instead, I'll use egen to split into three equal groups based on their average.
*/
egen bpgrp = cut(bpavg), group(3)
tab bpgrp



/*		RENAME and LABEL */
/*
Rename does what it says on the tin - renames a variable. Let's change our 
change-score variable to be bpdiff
*/
rename bpchange bpdiff

/*
We just made a bunch of new variables, and it's bad practice to leave these 
unlabelled. There are three types of labels:
	Dataset labels
	Variable labels
	Value labels
We'll skip dataset labels and do variable labels for our five new variables.
*/

label variable bpdiff "Change in blood pressure"
label var bpavg "Average blood pressure"
label var bpcat1 "Blood pressure category before"
label var bpcat2 "Blood pressure category after"
label var bpgrp "Blood pressure tertile"

/*
Both of the bpcat variables, and the bpgrp variable, are categorical. So, we 
should apply value labels to these as well.

Start by defining the label for each value. Remember our values were the bottom 
level of the categories
*/
label define bpcatlabel 0 "Normal" 119 "Elevated" 129 "High" 139 "Very High"

// Then we apply the label to the variables
label values bpcat* bpcatlabel

// We can then repeat the steps for the group variable
label def groups 0 "Low" 1 "Medium" 2 "High"
label values bpgrp groups

tab bpcat*
tab bpgrp

/*		RECODE		*/
/*
Recode lets you recode categorical variables. For example, to collapse some 
categories together.

Our bpcat variable is not very helpful. Maybe instead we want to collapse this 
into "Not Very High" and "Very High"
I'd also like to chnage "Very High" to be 1, rather than the slightly random
139. 'recode' can handle multiple arguements at once, so we'll do it all in one
step. The brackets only help keep our syntax clear. Stata doesn't require these.
*/
recode bpcat* (0 119 129 = 0) (139=1)
label define bpcatlabel 0 "Not Very High" 1 "Very High", replace
label values bpcat* bpcatlabel
tab bpcat*


/*		KEEP and DROP		*/
/*
Use drop when you no longer want a variable (e.g., the ones Stata creates during
merges). Depending on how many variables you want to drop, it can be faster to 
just tell Stata which variables to keep
*/

// Drop the bpdiff variable
drop bpdiff

// Get rid of everything except the original variables
keep patient bp? sex agegrp
