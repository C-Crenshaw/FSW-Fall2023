*********************************************************************************		
/*	TITLE: 		Wk07_PracticeActivity.do								
*	PURPOSE:	Code written for the completion of practice activity. 				
*	AUTHOR:		Carson Crenshaw											
*	CREATED:	2022_0119														
*	CALLS UPON:	"${rawdatapath}Wk07_SchAchGr1to3_2010.dta"
				"${rawdatapath}Wk07_SchAchGr1to3_2011.dta"
				"${rawdatapath}Wk07_SchAchGr1to3_2012.dta"
*	PRODUCES: 	Figures:	NO
*				Tables: 	No
*				Datasets: 	YES					
*	CONTENTS:	0. Set globals & start log file 
*				1. Practice Activity
*				2.  Close log file
*/
*********************************************************************************

	clear all
	set more off
	pause on

*******
*
*	0. Set globals & start log file 
*
*******

	**Set file paths using globals 
	
		glob classpath		"/Users/carsoncrenshaw/Library/CloudStorage/OneDrive-UniversityofVirginia/LPPP_6001/"
		glob rawdatapath	"${classpath}2 Raw Data/"
		glob syntaxpath		"${classpath}3 Syntax/"
		glob gendatapath	"${classpath}4 Generated Datasets/"
		glob logfilepath	"${classpath}5 Log Files/"
		glob tabsfigspath	"${classpath}6 Tables and Figures/"
		cd 	"${classpath}" 

	**Start the log file (something we'll learn about later in class)
	
		capture log close
		log using "${logfilepath}Wk07_PracticeActivity_log", replace 
	
*******
*
*	1. APPPEND: INTRODUCTION
*
*******

**Q1
	use "${rawdatapath}Wk07_SchAchGr1to3_2010.dta", clear
			codebook, compact 
			browse
			count 
			
	use "${rawdatapath}Wk07_SchAchGr1to3_2011.dta", clear
			codebook, compact 
			browse
			count 
			
	use "${rawdatapath}Wk07_SchAchGr1to3_2012.dta", clear
			codebook, compact 
			browse
			count 
			
	clear 
	append using ///
		"${rawdatapath}Wk07_SchAchGr1to3_2010.dta" ///
		"${rawdatapath}Wk07_SchAchGr1to3_2011.dta" ///
		"${rawdatapath}Wk07_SchAchGr1to3_2012.dta" /// 

**Q2
order schid syear *Avg

desc

use "${rawdatapath}Wk07_SchAchGr1to3_2010.dta", clear
	rename Math_Avg MathAvg
	rename Read_Avg ReadAvg
	append using "${rawdatapath}Wk07_SchAchGr1to3_2011.dta"
	append using "${rawdatapath}Wk07_SchAchGr1to3_2012.dta"
	browse
	
gsort schid syear
browse

**Q3: In what year was the average 3rd grade math score the highest?
tab syear, sum(MathGr3)

bysort syear: su MathGr3 // highest in 2010

table syear, stat(mean MathGr3) // Advanced alternative to bysort

*******
*
*	2.  Close log file
*
*******	
	
	log close
	
	translate "${logfilepath}Wk07_PracticeActivity_log.smcl" "${logfilepath}Wk07_PracticeActivity_log.pdf"
