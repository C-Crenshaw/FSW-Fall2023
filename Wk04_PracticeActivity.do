*********************************************************************************											
/*	TITLE: 		Wk04_PracticeActivity.do								
*	PURPOSE:	Week 4 practice activity. 					
*	AUTHOR:		Carson Crenshaw												
*	CREATED:	2023_0919															
*	CALLS UPON:	"${rawdatapath}Wk04_nlsw88.dta"
*	PRODUCES: 	Figures:	NO
*				Tables: 	No
*				Datasets: 	NO.					
*	CONTENTS:	0: Set globals
* 				1: Open data 
*				2: Activity
*/
*********************************************************************************

	clear all
	set more off
	pause on

*********
*
*	0. Set globals & start log file 
*
*********

	**Set file paths using globals 	
		glob classpath		"/Users/carsoncrenshaw/Library/CloudStorage/OneDrive-UniversityofVirginia/LPPP_6001/"	
		glob rawdatapath	"${classpath}2 Raw Data/"
		glob syntaxpath		"${classpath}3 Syntax/"
		glob gendatapath	"${classpath}4 Generated Datasets/"
		glob logfilepath	"${classpath}5 Log Files/"
		glob tabsfigspath	"${classpath}6 Tables and Figures/"
		cd 	"${classpath}" 

	**Start the log file 
	
		capture log close
		log using "${logfilepath}Wk04_PracticeActivity_log", replace
	
*********
*
*	1: Open Data
*
*********

	use "${rawdatapath}Wk04_nlsw88", clear // Opens up a dataset, can be used to rerun the data without variables (start again from a clean, original dataset)
	
*********
*
*	2: Commands we ran during Screencast
*
*********

*Generate a new variable called married_south set to 1 if the woman is married and lives in the south. The variable should be 0 if the woman is unmarried and/or does not live in the south.
generate married_south = 0
replace  married_south=1 if married ==1 & south == 1
label var married_south "married and lives in the south"
cap lab drop marriedsouth_vallab
label define marriedsouth_vallab 0 "unmarried and/or does not live in the south" 1 "married and lives in the south"
label values married_south marriedsouth_vallab

codebook married_south
tab age40plus, mi

*Generate a new variable called education set to 1 if grade is less than 12, 2 if grade is 12 to 16, and 3 if grade is greater than 16.  
generate education = 1
replace  education=2 if grade >=12 & grade <= 16
replace  education=3 if grade >16
replace education=. if grade==.
label var education "categorical measure of education"
cap lab drop education_vallab
label define education_vallab 1 "less than 12" 2 "between 12 and 16" 3 "greater than 16"
label values education education_vallab

codebook education
tab grade education, mi

*Generate a new variable called one_job set to 1 if the total number of years the woman has worked at her current job is the same as her total years of experience. Set the variable to 0 otherwise.
codebook tenure
codebook ttl_exp // no missing values

generate one_job = 0
replace  one_job= 1 if ttl_exp == tenure
replace one_job=. if tenure==. 
label var one_job "only worked one job"
cap lab drop onejob_vallab
label define onejob_vallab 0 "not equal" 1 "equal" 
label values one_job onejob_vallab

codebook one_job
tab one_job, mi
su ttl_exp tenure if one_job==1

*OR
codebook tenure
codebook ttl_exp // no missing values

generate one_job = 1 if ttl_exp == tenure
replace  one_job= 0 if ttl_exp != tenure
replace one_job=. if tenure==. 
label var one_job "only worked one job"
cap lab drop onejob_vallab
label define onejob_vallab 0 "not equal" 1 "equal" 
label values one_job onejob_vallab

codebook one_job
tab one_job, mi
su ttl_exp tenure if one_job==1

*Make a new indicator variable called public_admin and define it as 1 if the person is in the public administration industry (really explore the categorical "industry" variable by using codebook and tab), and 0 if they are in any other industry.  If the person has missing value for the "industry" variable, they should be coded as missing in your new variable too.
codebook industry
tab industry
label list

generate public_admin = 0
replace  public_admin= 1 if industry == 12 // 12 is Val Labeled as Public Administration
replace public_admin=. if industry==. 
label var public_admin "works in public administration"
cap lab drop pa_vallab
label define pa_vallab 0 "does not work publicly" 1 "works publicly" 
label values public_admin pa_vallab

codebook public_admin
tab public_admin, mi

*Quiz Question 3
lab var occupation "categorical variable representing the respondent's occupation"

*Quiz Question 4
lab var age40plus "dummy: 1=age 40+, 0=not"

*********
*
*	3: Save a revised version of the dataset?
*
*********

	save "${gendatapath}Wk04_nlsw88_practiceactivity", replace


*********
*
*	4: Close log file 
*
*********	
	
	log close
	
	translate "${logfilepath}Wk04_PracticeActivity_log.smcl" "${logfilepath}Wk04_PracticeActivity_log.pdf", replace
