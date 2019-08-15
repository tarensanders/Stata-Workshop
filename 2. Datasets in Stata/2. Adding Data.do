/*
ADD BOILER PLATE
*/

/*
A common data management task is merging or appending data.
Let's have a look at the process for doing this.
*/

// Open the wines_base dataset
use wines_base, clear

// Let's have a quick at what's in the dataset
describe
summarize

/*
We have some more data about these wines that we'd like to add. We can do this
without opening the new data, but for the sake of understanding let's take a 
look at the other dataset.
*/
use wines_merge, clear
describe
summarize

/*		MERGE		*/

/*
Let's go back to our original dataset and do the merge
*/
use wines_base, clear

/* As a quick aside - you can describe data that isn't in memory by specifying
'using [dataset]' like so:
*/
describe using wines_merge

/*
In the help documentation for merge, we see that we need to specify the type of 
merge, and the variable to merge on
*/
merge 1:1 id using wines_merge

/*
As an example, imagine we did not have the country variable, but we did have
the province. Could we use a list of countries and provinces to fill in the 
country for each wine? This is call a many to one merge.
*/

// We first have to get rid of the new _merge variable Stata created for us
drop _merge

/* Next, we can merge using m:1. In this case we're also going to tell Stata
to only keep instances that match, and get rid of anything that doesn't match
*/
merge m:1 province using wines_regions, keep(match)

/*		APPEND		*/

/* Let's try adding some new observations to the dataset*/

// First, check what the new data looks like
describe

/* Add the new data to the bottom */
append using wines_append
