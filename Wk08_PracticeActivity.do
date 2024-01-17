*********************************************************************************		
/*	TITLE: 		Wk08_PracticeActivity.do								
*	PURPOSE:	Code written for the completion of practice activity. 				
*	AUTHOR:		Carson Crenshaw											
*	CREATED:	2023_1017														
*	CALLS UPON:	"${rawdatapath}Wk07_SchAchGr1to3_2010.dta"
				"${rawdatapath}Wk07_SchAchGr1to3_2011.dta"
				"${rawdatapath}Wk07_SchAchGr1to3_2012.dta"				
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
		log using "${logfilepath}Wk08_PracticeActivity_log", replace 
		
*******
*
*	1. Practice Activity
*
*******

**Pre-cleaning 
		
	use  "${rawdatapath}Wk07_SchAchGr1to3_2010.dta", clear
	drop syear *Avg
	save "${gendatapath}Wk08_StudAchGr1to3_2010_cleaned.dta", replace
			
	use  "${rawdatapath}Wk07_SchAchGr1to3_2011.dta", clear
	drop syear *Avg
	save "${gendatapath}Wk08_StudAchGr1to3_2011_cleaned.dta", replace
	
	use  "${rawdatapath}Wk07_SchAchGr1to3_2012.dta", clear
	drop syear *Avg
	save "${gendatapath}Wk08_StudAchGr1to3_2012_cleaned.dta", replace
	
**Merge
	use "${gendatapath}Wk08_StudAchGr1to3_2010_cleaned.dta", clear
		
	merge 1:1 schid using ///
		"${gendatapath}Wk08_StudAchGr1to3_2011_cleaned.dta"
		tab _merge 
		codebook, compact
		
		drop _merge
		
	merge 1:1 schid using ///
		"${gendatapath}Wk08_StudAchGr1to3_2012_cleaned.dta"
		tab _merge
		browse
		
		drop _merge
		
* Perfect merge BUT not the expected number of variables we want. This is a problem because the variables are named the same. 

**Clean Dataset
	use  "${gendatapath}Wk08_StudAchGr1to3_2010_cleaned.dta", clear
	rename MathGr* MathGr*_2010
	rename ReadGr* ReadGr*_2010
	save "${gendatapath}Wk08_StudAchGr1to3_2010_cleaned.dta", replace
			
	use  "${gendatapath}Wk08_StudAchGr1to3_2011_cleaned.dta", clear
	rename MathGr* MathGr*_2011
	rename ReadGr* ReadGr*_2011
	save "${gendatapath}Wk08_StudAchGr1to3_2011_cleaned.dta", replace
	
	use  "${gendatapath}Wk08_StudAchGr1to3_2012_cleaned.dta", clear
	rename MathGr* MathGr*_2012
	rename ReadGr* ReadGr*_2012
	save "${gendatapath}Wk08_StudAchGr1to3_2012_cleaned.dta", replace
	
* You can also start from the beginning and redo the entire cleaning process:
*	use  "${rawdatapath}Wk07_SchAchGr1to3_2010.dta", clear
*	drop syear *Avg
*	rename MathGr* MathGr*_2010
*	rename ReadGr* ReadGr*_2010
*	save "${gendatapath}Wk08_StudAchGr1to3_2010_cleaned.dta", replace
	
**Merge
use "${gendatapath}Wk08_StudAchGr1to3_2010_cleaned.dta", clear
		
	merge 1:1 schid using ///
		"${gendatapath}Wk08_StudAchGr1to3_2011_cleaned.dta"
		tab _merge 
		drop _merge
		codebook, compact
		
	merge 1:1 schid using ///
		"${gendatapath}Wk08_StudAchGr1to3_2012_cleaned.dta"
		tab _merge
		drop _merge // REMEMBER TO DROP THE MERGE VARIABLE
		browse
		
		desc, short

*******
*
*	2.  Close log file
*
*******	
	
	log close
	
	translate "${logfilepath}Wk08_PracticeActivity_log.smcl" "${logfilepath}Wk08_PracticeActivity_log.pdf"
