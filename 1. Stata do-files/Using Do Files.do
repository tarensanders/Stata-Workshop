/*
Author: 	Taren Sanders
Contact:	taren.sanders@acu.edu.au
Available under CC-BY-SA-4.0
*/
version 15
set more off

// Import system dataset
sysuse bplong, clear

// Summarize the dataset
summarize

// Tabulate by sex and age
tab sex agegrp

// Test if blood pressue differs by before/after
ttest bp, by(when)
