*********************************************************************************		
/*	TITLE: 		Wk07_PSET2_Crenshaw.do								
*	PURPOSE:	Code written for the completion of the second FSW Problem Set. 			
*	AUTHOR:		Carson Crenshaw												
*	CREATED:	2023_1012															
*	CALLS UPON:	"${rawdatapath}PSET1_NHES_Homework.dta"				
*	CONTENTS:	1: START A .DO FILE USING BEST PRACTICES
*				2: LAY OF THE LAND
*				3: DESCRIPTIVE STATISTICS
*				4: CONSTRUCTING NEW VARIABLES
*				5: FIRST-TIME KINDERGARTENERS
*				6: REFLECTIONS AND FINAL UPLOADS
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
	**Header (above) and Globals (below) for the classpath and other class folders
	
		glob classpath		"/Users/carsoncrenshaw/Library/CloudStorage/OneDrive-UniversityofVirginia/LPPP_6001/"
		glob rawdatapath	"${classpath}2 Raw Data/"
		glob syntaxpath		"${classpath}3 Syntax/"
		glob gendatapath	"${classpath}4 Generated Datasets/"
		glob logfilepath	"${classpath}5 Log Files/"
		glob tabsfigspath	"${classpath}6 Tables and Figures/"
		cd 	"${classpath}"  

	**Start the log file in the "5 Log Files" folder, closure of the log file and translation to a pdf can be found at the end of the document
	
		capture log close
		log using "${logfilepath}Wk07_PSET2_Crenshaw_log", replace 
	
	**Open data from "2 Raw Data" folder
	
		use "${rawdatapath}PSET2_FSW2022_ECLSK.dta", clear
	
* Part 1, Question 1: In your own words, how successful were you with PART 1? What parts did you struggle with the most, if any? How has your understanding of organizing files for analysis using Stata developed since you turned in PSET1? [Short answer]
di in red "I believe that I was very successful with Part 1 of the Problem Set. Now that I have had ample time to practice setting up my own do. files through the asynchronous lectures and the practice activities, setting up my file orientation from the template is very simple. I feel very comfortable with organizing files for analysis using Stata. I will say, however, that I have become much better at identifying errors in my code when they occur. I use to stumble over using the proper punctuation and ensuring that every filepath was updated and a perfect reflection of my file structure. This was an initial problem I had during PSET1 that I have now been able to work through thanks to my dedication to practicing this skill."

*********
*
*	2: LAY OF THE LAND
*
*********
*Quick look into the dataset 
*mdesc // lots of missing values
*describe, short
*codebook, compact

*PART2, Q1. How many observations are in this dataset?
describe, short
*browse // Check to make sure the number is correct
di in red "There are 5,390 observations in this dataset."

*PART2, Q2. How many variables are in this dataset?
describe, short
di in red "There are 147 variables in this dataset."

*PART2, Q3. How many different schools are included in this dataset?
distinct s1_id
*codebook s1_id // Confirm number
di in red "There are 327 schools in this dataset."

*PART2, Q4. Many variables in the dataset begin with the letters "p1". What does this mean? What does it mean when variables start with the letters "c1"? What about "t1"? [Short Answer]
*desc p1*
isvar p1*
	su `r(varlist)' // Summary table is broken into variable groups of 5, nine total groups with one variable leftover for a total of 46 variables. 
di in red "There are 46 variables in the dataset that begin with the letters 'p1'. The term 'p1' stands for the data/scores collected from fall-kindergarten parent interviews. Similarly, when variables begin with the letters 'c1', this means that these variables represent the data/scores collected from fall-kindergarten direct child assessments. 'T1' stands for data/scores collected from fall-kindergarten teacher questionnaire. The beginning values of a variable name stands for the origin of the data: Either a parent, child, or teacher."

*********
*
*	3: DESCRIPTIVE STATISTICS
*
*********

*PART3, Q1. There are 4 types of schools in this dataset (cs_type2). I'd like you to compare and contrast the chances that students of different ethnoracial categories (see race variable) attend public school by conducting the following analyses: What percentage of White students (labeled WHITE, NON-HISPANIC) attend public schools (labeled, PUBLIC/DOD/BIA)? What percentage of Black students (BLACK OR AFRICAN AMERICAN, NON-HISPANIC) attend public schools? What percentage of Hispanic students (both RACE SPECIFIED and RACE NOT SPECIFIED) attend public schools?" [Short Answer]
use "${rawdatapath}PSET2_FSW2022_ECLSK.dta", clear
codebook cs_type2 // No missing values in school type
codebook race // No missing values in race
count if race == -9
drop if race == -9
tab race cs_type2, row
di in red "Conducting an analysis on the relationship of ethnoracial categories and school type left me with the following results: 76.26% of white, non-hispanic students attend public schools, 93.19% of black students attend public schools, and 84.49% of hispanic students (race specified), 92.86% of hispanic students (race not specified) attend public school. From this analysis it is clear that non-white populations are more likely to go to public school than white populations of students."

// Correct Answer: I find that different percentages of each of the 3 ethnoracial groups attend public school. We see that ~76% of children attend public schools in K. That is lower than the percentage both for Hispanic students (~89%) and for Black students (93%). It appears that White students in this dataset are more likely to attend all other school types than the other two groups. **I needed to have taken the average between the Hispanic populations

*PART3, Q2. What percentage of children in this sample speak a primary home language other than English (wklangst)?
use "${rawdatapath}PSET2_FSW2022_ECLSK.dta", clear
codebook wklangst // Missing 223 values
tab wklangst, mi // '-9' values are also values that are deemed "Not Ascertained" aka Missing

drop if wklangst==. | wklangst==-9
tab wklangst
di in red "10.03% of children in this sample speak a primary home language other than English."

*PART3, Q3. What percentage of children in this sample have a mother who has attained a level of education beyond a bachelor's degree? (wkmomed)? 
use "${rawdatapath}PSET2_FSW2022_ECLSK.dta", clear
codebook wkmomed // 223 Missing values
tab wkmomed, mi // '-9' and '1' values are also values that are deemed "Not Ascertained" or "Not Applicable (legitimate skip)" aka Missing
count if wkmomed==. | wkmomed==-9 | wkmomed==-1 // Remove 314 values

drop if wkmomed==. | wkmomed==-9 | wkmomed==-1
tab wkmomed

di in red " 6.96% of children in this sample have a mother who has attained a level of education beyond a bachelor's degree."

*********
*
*	4: CONSTRUCTING NEW VARIABLES
*
*********

*PART4, Q1. Daily Reading: Generate a dummy variable called daily_read, based on p1readbo. Your new daily_read dummy should = 1 if the parent reported reading to their child EVERYDAY, and = 0 if parents reported reading to their children less than daily. Be sure to label your variable and its values. Now tab your new variable (exclude missing values) and paste the output from your Results Window into Canvas. [Short answer in Canvas, Courier New font]
use "${rawdatapath}PSET2_FSW2022_ECLSK.dta", clear 
*codebook p1readbo // Quick view of variable
*tab p1readbo, mi // Need to remove missing values, -9 and -8 values. 

cap drop daily_read
generate daily_read = 0 // baseline, all values 0
replace daily_read = 1 if p1readbo == 4 // parent reported reading to their child everyday
replace daily_read =. if p1readbo==. | p1readbo==-9 | p1readbo==-8 // code for missing values
label variab daily_read "dummy: 1 if parent read everyday, 0 less than daily, excluding missing values"
cap lab drop daily_read_vallab
label define daily_read_vallab 1 "(1) Read Daily" 0 "(0) Less than Daily"
label values daily_read daily_read_vallab
tab daily_read // Tab without missing values


*PART4, Q2. The ECLS-K provides standardized math scores (c1mtscor) and reading scores (c1rtscor) at Kindergarten entry. Using the generate command construct a new variable, called c1_avg_tscor that is equal to the average score on these two assessments (e.g., add the two variables and divide by two). Be sure to label your new variable. What is the minimum, maximum, and mean value of your newly-generated variable?
use "${rawdatapath}PSET2_FSW2022_ECLSK.dta", clear
*codebook c1mtscor // Missing values, need to remove negative values that indicate missing values
*codebook c1rtscor // Missing values, need to remove negative values that indicate missing values
drop if c1mtscor==. | c1mtscor==-9 | c1mtscor==-8 | c1mtscor==-7 | c1mtscor==-2 | c1mtscor==-1 // Removes all missing values in all forms
drop if c1rtscor==. | c1rtscor==-9 | c1rtscor==-8 | c1rtscor==-7 | c1rtscor==-2 | c1rtscor==-1 // Removes all missing values in all forms

cap drop c1_avg_tscor
	generate c1_avg_tscor= 0 
	replace  c1_avg_tscor= (c1mtscor + c1rtscor) / 2
	label variab c1_avg_tscor "Average math and reading scores at Kindergarten entry"

*browse c1mtscor c1rtscor c1_avg_tscor // Check that averages are correct
su c1_avg_tscor
di in red "The mean of the new variable is 50.24, the minimum is 24.72, and the maximum is 83.16."

*********
*
*	5: FIRST-TIME KINDERGARTENERS 
*
*********

*PART5 Q1. Start by generating a dummy variable, c1mtscor50plus, which is set equal to 1 if the child's math score when they enter Kindergarten (c1mtscor) is 50 or above, 0 if it is below 50, and missing if c1mtscor is missing (label variable and values, as always). Among children with non-missing data on this variable, what percent have a math score 50 or above?
use "${rawdatapath}PSET2_FSW2022_ECLSK.dta", clear
*su c1mtscor // need to drop negative values (missing values)
codebook c1mtscor // 745 missing values

cap drop c1mtscor50plus
generate c1mtscor50plus = 0 // baseline, all values 0
replace c1mtscor50plus = 1 if c1mtscor >= 50 // child math score is 50 or above
replace c1mtscor50plus =. if c1mtscor==. | c1mtscor==-9 | c1mtscor==-8 | c1mtscor==-7 | c1mtscor==-2 | c1mtscor==-1 // code for missing values
label variab c1mtscor50plus "dummy: 1 if math score at or above 50, 0 below 50, excluding missing values"
cap lab drop c1mtscor50plus_vallab
label define c1mtscor50plus_vallab 1 "(1) At or Above 50" 0 "(0) Less than 50"
label values c1mtscor50plus c1mtscor50plus_vallab
tab c1mtscor50plus // Tab without missing values

*Check
*count if c1mtscor >= 50 & c1mtscor != .
*count if c1mtscor==. | c1mtscor==-9 | c1mtscor==-8 | c1mtscor==-7 | c1mtscor==-2 | c1mtscor==-1

di in red "Among children with non-missing data on this variable, 50.75% of have a math score 50 or above."

*PART5 Q2. Among children with non-missing data, what percentage of children are considered "below the poverty threshold" (wkpovrty)? 
codebook wkpovrty // Missing 223 values
tab wkpovrty

di in red "Among children with non-missing data on this variable, 22.80% are in poverty."

*PART5 Q3. Construct a categorical variable called pov_math, based on wkpovrty and your new c1mtscor50plus dummy. Your new variable should have 4 values: 1= below poverty threshold, and has a math score < 50; 2= below poverty threshold, and has a math score >=50; 3= at/above poverty threshold, and has a math score < 50; 4= at/above poverty threshold, and has a math score >=50. Anyone with missing data for either of the two underlying variables should have a missing value for your new variable pov_math. As always, label your variable and its values. Now tab your new variable (exclude missing values) and paste the output from your Results Window into Canvas. [Short answer in Canvas, Courier New font]
cap drop pov_math
generate pov_math = 0 // baseline, all values 0
replace pov_math = 1 if wkpovrty == 1 & c1mtscor50plus == 0 //poor, math below 50
replace pov_math = 2 if wkpovrty == 1 & c1mtscor50plus == 1 //poor, math above or at 50
replace pov_math = 3 if wkpovrty == 2 & c1mtscor50plus == 0 //not poor, math below 50
replace pov_math = 4 if wkpovrty == 2 & c1mtscor50plus == 1 //not poor, math at or above 50
replace pov_math =. if wkpovrty==. | c1mtscor50plus==. // missing values (no negative values, all acounted for)
label variab pov_math "Poverty threshold and math performance of a given student"
cap lab drop pov_math_vallab
label define pov_math_vallab 1 "(1) poor, math below 50" 2 "(2) poor, math above or at 50" 3 "(3) not poor, math below 50" 4 "(4) not poor, math at or above 50"
label values pov_math pov_math_vallab

tab pov_math // exclude mising values (964)

*PART5 Q4. Write 1-2 sentences about what you have learned about poverty status and math scores at the start of K. 
di in red "At the start of kindergarten, I have learned that there seems to be a relationship between the poverty level of the child and their respective performance in math. For a child who is living under the poverty threshold, they are more likely to be at a math score of below 50 than above 50. However, a child living at or above the poverty threshold is more likely to be at a math score of at or above 50. One can assume that children at or above the poverty threshold have more resources to perform better in school, allowing them to preform better than other students in lower income brackets."

//**Correct answer needed to have percentages in it. Ex: At the start of K, I can see that children who are in poverty are less likely to have "high" math scores. Only 6.46% of all students (with non-missing data) are in both poverty and have a high score. But 44.55% of all students are not in poverty and have a high score. This suggests to me that systemic advantages and greater resources available to those who are not in poverty are already shaping children's outcomes even before school begins.

*********
*
*	6: REFLECTIONS AND FINAL UPLOADS 
*
*********

*PART6 Q1. How much time did it take you to complete this homework assignment? What was the most challenging part? Do you have any questions about the material presented so far?
di in red "It took me approximately 3 hours to complete this homework assignment. The most challenging part of this assignment was ensuring that my previous lines of code run earlier in the file did not effect the lines of code that I was currently writing. For instances where I used the drop command, for example, I found it a good practice to always reset the dataset I was working with to the original before I continued on the next question/coding problem. It took me a little while to realize that the reason I was getting different answers when I would individually run the code vs. when I would run the entire file was because I was not returning to the original dataset. Once I fixed this error, my file ran perfectly."

*PART6 Q2. Upload .do file

*PART6 Q3. Upload log. file

	log close
	
	translate "${logfilepath}Wk07_PSET2_Crenshaw_log.smcl" "${logfilepath}Wk07_PSET2_Crenshaw_log.pdf", replace
