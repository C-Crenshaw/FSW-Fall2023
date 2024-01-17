*********************************************************************************		
/*	TITLE: 		Wk05_PracticeActivity.do								
*	PURPOSE:	Code written for the completion of the Wk05 practice activity			
*	AUTHOR:		Carson Crenshaw												
*	CREATED:	2023_0926													
*	CALLS UPON:	"${rawdatapath}Wk05_VA_Grades35_2008.dta"
*	PRODUCES: 	Figures:	NO
*				Tables: 	No
*				Datasets: 	NO.					
*	CONTENTS:	0. Set globals & start log file 
*				1: Open Data
*				2: Work
*				3: Close log file
*/
*********************************************************************************

	clear all
	set more off
	pause on

******
*
*	0. Set globals & start log file 
*
******

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
		log using "${logfilepath}Wk05_PracticeActivity_log", replace 
	
******
*
*	1: Open Data, Brief Analysis
*
******
	
	use "${rawdatapath}Wk05_VA_Grades35_2008.dta", clear
	
	describe, short	
	
	codebook, compact 
	
	mdesc	
	
*********
*
*	2: Practice Activity
*
*********

* Variable generation (example 1)
codebook R_PerProf_All R_PerAdv_All

cap drop Sum_ReadGood_All
generate Sum_ReadGood_All = R_PerProf_All + R_PerAdv_All, after(R_PerAdv_All)

gsort R_PerProf_All
browse R_PerProf_All R_PerAdv_All Sum_ReadGood_All

label variab Sum_ReadGood_All "Percentage of Students that are Adv & Proficient at Reading"

su Sum_ReadGood_All // Mean = 87.94255

list SchNm DivNm Grade if Sum_ReadGood_All <= 50

* Variable generation (example 2)
*Create a categorical variable title1_ayp with 4 categories. Make sure the variable and the values are labeled as follows: • School is Title 1, made AYP • School is Title 1, did not make AYP • School is not Title 1, made AYP • School is not Title 1, did not make AYP 

tab AYP TitleI, mi

cap drop title1_ayp 
generate title1_ayp = 1 if TitleI == 1 & AYP == 1
replace title1_ayp = 2 if TitleI == 1 & AYP == 0
replace title1_ayp = 3 if TitleI == 0 & AYP == 1
replace title1_ayp = 4 if TitleI == 0 & AYP == 0
replace title1_ayp=. if TitleI==. | AYP==.

label variab title1_ayp "Whether a school is Title I and made AYP"
cap lab drop title1_ayp_vallab
label define title1_ayp_vallab 1 "School is Title 1, made AYP" 2 "School is Title 1, did not make AYP" 3"School is not Title 1, made AYP" 4"School is not Title 1, did not make AYP"
label values title1_ayp  title1_ayp_vallab

tab title1_ayp, mi

*alternate method, this command combines all possible values of two categorical variables
egen title1_ayp_v2=group(TitleI AYP), label

* Odds and Ends
drop R_*

rename FLPer fl_pct

rename *,  upper

******
*
*	7: Close log file
*
******	
	
	log close
	
	translate "${logfilepath}Wk05_PracticeActivity_log.smcl" "${logfilepath}Wk05_PracticeActivityk_log.pdf", replace
