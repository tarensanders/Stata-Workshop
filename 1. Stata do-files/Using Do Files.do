/*
ADD BOILER PLATE
*/

// Import system dataset
sysuse bplong, clear

// Summarize the dataset
summarize

// Tabulate by sex and age
tab sex agegrp

// Test if blood pressue differs by before/after
ttest bp, by(when)
