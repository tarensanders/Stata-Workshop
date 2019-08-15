/*
Author: 	Taren Sanders
Contact:	taren.sanders@acu.edu.au
Available under CC-BY-SA-4.0
*/
version 15
set more off

/*
You can import a built-in dataset using 'sysuse'
Use 'sysuse dir' to get a list of available datasets
*/

// List built-in datasets
sysuse dir

// Place a built-in dataset into memory 
//(using option 'clear' removes any existing data in memory)
sysuse bplong, clear

/*
You can open a dataset that's in the same location you opened the do-file 
by using the 'use' command.
Not that Stata assumes the file is '.dta'. You don't have to specify this.
*/

// Open the 'example_data.dta' file that is in the same folder
use example_data

/*
If the data isn't in the same location, provide the full path to the dataset in
double quotes.
NOTE: 	You can use the tilda (~) to represent the home directory.
		Mac and Windows use different file paths. But, Stata in Windows will 
		accept both forward (/) and backward (\) slashes. If you have data in
		the same location on two machines, it's usually best to use forward 
		slashes
*/
use "~/OneDrive/Documents/GitHub/Stata-Workshop/2. Datasets in Stata/example_data.dta"

/*
If you prefer, you can alwayss navigate your system using 'cd' and check 
your current directory using 'pwd'
*/
pwd
cd "~/OneDrive/Documents/GitHub/Stata-Workshop/2. Datasets in Stata"
pwd

/*
You can have a quick look at the contents of a dataset using the 'describe'
command. You could also use the data editor.
*/
describe

/*
The 'summarize' command gives basic descriptive statistics for a dataset
*/
summarize

/*
Finally, use 'list' to view some rows of data. Be careful - you can accidentally
print every row. Very large fields (e.g., text fields) can also display badly.
list in 1/5 is the equivelant of head() in many other languages.
*/
list in 1/5

/*
'codebook' is another way to get a sense of the data. In this case, let's just 
look at the sex variable.
*/
codebook sex

/*
Finally, 'inspect' gives a graphical view of some of the numerical variables. 
Let's just look at the blood pressure data.
*/
inspect bp

/*
Save your dataset using the 'save' command. If the data already exists, you must
specify the option 'replace'.
*/

// Save the dataset in the working directory, replacing the existing data
save example_data, replace

/*
You can also export data to excel, csv, databases, etc. Look at the options 
under the File -> Export for options and syntax.
*/
