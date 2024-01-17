*********************************************************************************		
/*	TITLE: 		Wk05_PSET1_Crenshaw.do								
*	PURPOSE:	Code written for the completion of the first FSW Problem Set. 			
*	AUTHOR:		Carson Crenshaw												
*	CREATED:	2023_0928															
*	CALLS UPON:	"${rawdatapath}PSET1_NHES_Homework.dta"				
*	CONTENTS:	1: START A .DO FILE USING BEST PRACTICES
*				2: EXPLORE A DATASET
*				3: ENJOYING SCHOOL 
*				4: CHILD'S HOMEWORK
*				5: REFLECTIONS AND FINAL UPLOADS
*/
*********************************************************************************

	clear all
	set more off
	pause on

******
*
*	1. START A .DO FILE USING BEST PRACTICES 
*
******
	**Proper header can be found above
	
	**Set file paths using globals 
	
		glob classpath		"/Users/carsoncrenshaw/Library/CloudStorage/OneDrive-UniversityofVirginia/LPPP_6001/"
		glob rawdatapath	"${classpath}2 Raw Data/"
		glob syntaxpath		"${classpath}3 Syntax/"
		glob gendatapath	"${classpath}4 Generated Datasets/"
		glob logfilepath	"${classpath}5 Log Files/"
		glob tabsfigspath	"${classpath}6 Tables and Figures/"
		cd 	"${classpath}"  

	**Start the log file in the "5 Log Files" folder, closure of the log file and translation to a pdf can be found at the end of the document
	
		capture log close
		log using "${logfilepath}Wk05_PSET1_Crenshaw_log", replace 
	
	**Open data from "2 Raw Data" folder
	
	use "${rawdatapath}PSET1_NHES_Homework.dta", clear
	
* Question 1: In your own words, how successful were you with PART 1? What parts did you struggle with the most, if any? [Short answer]
* I feel very confident in my completion of part 1 and I believe that I was successful at its implementation. The most difficult portion of these tasks was the assignment of file paths using globals because I find the exactness of the globals tricky. It takes me a little more time to ensure that the file paths are correct, that the naming conventions follow the LPPP_6001 folder structure, and that I have properly linked my individual structure to the file with no error.  
	

*********
*
*	2: EXPLORE A DATASET
*
*********
*a: How many observations are in this dataset?  (1pt) 
describe, short
*There are 5092 observations in the dataset


*b: On average, how old are the children in this dataset, and what is the range of ages included?  (1pt) 
summarize age
*On average, children in this dataset are  7.95 years old (round to 2 decimals). And the ages range from 5 to 11 years old (whole numbers).


*c: What percentage of the children are male?  (1pt)
tab csex, mi
*In this dataset, 51.77% of the children are male (round to two decimals).


*d: What grades are the children in?  (1pt)
tab grade
codebook grade
*E. Grades K through 6


*e: What percent of the children in this dataset have a parent with a college degree or above?  (1pt)
tab pargradex, mi

codebook pargradex
tab pargradex if pargradex == 4 | pargradex == 5 // add totals and divide by total number of children
* 54.42% of the children in this dataset have a parent with a college degree or above.


*f: How many children were absent for more than 10 days?  (1pt)
codebook seabsnt
count if seabsnt>10

tab seabsnt if seabsnt>10, mi
*In this dataset, 223 children were absent for more than 10 days. 


*g: Do any of the variables have missing data? If so, which ones, and how many observations are missing?  (1pt) [Short answer]
* Yes, three of the variables have missing data. Using the mdesc command, one can see that the observations for hours spent doing homework assigned ("fhwkhrs"), adult's feelings about the amount of homework assigned ("fhamount"), and child's feelings about the amount of homework ("fhcamt") are all missing. The number of observations that are missing from each of these variables is the same: 222. 


******
*
*	3: ENJOYING SCHOOL
*
******	
*a: What percentage of parents strongly agree that their child likes school?  (1pt)
tab seenjoy, mi
*50.00% of parents strongly agree that their child likes school (round to two decimals). 


*b: What percentage of kindergarten parents strongly agree that their children like school?  What percentage of sixth grade parents strongly agree that their children like school? (1pt)
tab seenjoy grade
tab seenjoy if grade == 2

tab seenjoy if grade == 8
*63.06% of the kindergarten children's parents strongly agree that their children like school (round to two decimal places). And  43.24% of the sixth grade children's parents strongly agree that their children like school (round to two decimals).


*c: How are the reported levels of school enjoyment different between male and female students? Summarize your findings from your analysis written in your Stata code, in 1-2 sentences.  (1pt)  [Short answer]
tab seenjoy csex
tab seenjoy if csex ==1 //male
tab seenjoy if csex ==2 // female
* Both sexes have greater numbers of parents who either strongly agree or agree that their child enjoys school, but that number is higher for females and is even higher when examining the differences between strongly agree and just agree (of the 92.19% reported to enjoy school in some capacity, strongly agree only makes up 42.34% of male enjoyment; of the 96.50%, strongly agree makes up 58.22% of female enjoyment). To summarize, while the differences in reported levels of school enjoyment between male and female students are relatively small, female students are reported by their parents to enjoy school more (agree/strongly agree) overall than their male counterparts and males are reported by their parents to not enjoy school more (disagree/strongly disagree) than females. 


******
*
*	4: CHILD'S HOMEWORK 
*
******	
*a: In your .do file, write one line of code to report the average number of hours spent on homework per week, for each grade level included in this dataset. Write 1-3 sentences about what you learn about hours spent on homework by grade level. (1pt)  [Short answer]
tab grade, sum(fhwkhrs) mi
*As one would expect, after running the proper STATA code to tabulate grade values by their summary statistics of the homework hours variable one can observe that there is a positive trend between the average number of hours spent on homework per week and grade level. As the student's grade level rises, the average amount of time spent per week on homework increases. One can assume that this is illustrating that the course material might get harder (needing more time to complete homework) as a student achieves higher grade levels. 

*b: Who is more likely to feel the child has too much homework? A greater percentage of parents or children? (1pt)
tab fhamount, mi
tab fhcamt, mi
*A. Children are more likely to feel there is too much homework. 	

*c: In how many cases do parents and children align in their feelings about the amount of homework received? (e.g. both think it's about right, both think it's too much, etc). Only consider cases with non-missing data. (1pt)
count if fhamount == fhcamt & fhamount !=. & fhcamt !=.
*In 3534 (#) of the 4870 (#) cases without missing data, parents and children align in their feelings about the amount of homework received. In terms of percentage, that equates to 72.57% (round to 2 decimals) of cases without missing data have parents and children aligned in their feelings about the amount of homework received.


*d: Make a dummy variable that indicates cases where the parent reports the child does homework for three hours a week or less, and also reports that it is too much homework. Use that variable to determine the following: In what percentage of cases does this happen (again, only consider cases with non-missing data)? In what grade is this most likely to happen (again, only consider cases with non-missing data)? (1pt)  [Short answer]
cap drop dummy_var
generate dummy_var = 0
replace dummy_var = 1 if fhwkhrs <= 3 & fhamount == 2 // child does homework for three or less hours, reports too much hw
replace dummy_var =. if fhwkhrs==. | fhamount==.
label variab dummy_var "dummy: 1 if hw hours <= 3 and parent reports too much hw, 0 otherwise, excludes missing values"
cap lab drop dummy_var_vallab
label define dummy_var_vallab 1 "1: <=3 hours & fhamount = too much" 0 "all else"
label values dummy_var dummy_var_vallab
tab dummy_var

tab grade dummy_var

tab grade dummy_var, row
*Only considering cases with non-missing data, the percentage of cases where the parent reports the child does homework for three hours a week or less and also reports that it is too much homework is 3.39% (165 out of 4870 cases). This instance of the parent reporting both circumstances is most likely to happen in the 2nd grade. 


******
*
*	5: REFLECTIONS AND FINAL UPLOADS
*
******	
*How much time did it take you to complete this homework assignment? What was the most challenging part? Do you have any questions about the material presented so far? (1pt)  [Short answer]
*It took me approximately an hour to complete this homework assignment. The most challenging part was accounting for the missing variables and ensuring that I was receiving the correct answers after removing/discounting the missing observations. I have no further questions about the material presented thus far. 


	**Upload .do file 
	
	**Upload log file
	
	log close
	
	translate "${logfilepath}Wk05_PSET1_Crenshaw_log.smcl" "${logfilepath}Wk05_PSET1_Crenshaw_log.pdf", replace
	