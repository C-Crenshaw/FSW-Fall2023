*********************************************************************************											*		
/*	TITLE: 		Wk03_PracticeAssignment.do								
*	PURPOSE:	Code written for the completion of Week 3 practice. 			
*	AUTHOR:		Carson Crenshaw												
*	CREATED:	2023_0912														
*	CALLS UPON:	"${rawdatapath}Wk03_CaliSchools.dta"
*	PRODUCES: 	Figures:	NO
*				Tables: 	No
*				Datasets: 	NO.					
*	CONTENTS:	0: Set globals
* 				1: Open data 
*				2: Complete Practice
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
		
		glob classpath "/Users/carsoncrenshaw/Library/CloudStorage/OneDrive-UniversityofVirginia/LPPP_6001/"	
		glob rawdatapath	"${classpath}2 Raw Data/"
		glob syntaxpath		"${classpath}3 Syntax/"
		glob gendatapath	"${classpath}4 Generated Datasets/"
		glob logfilepath	"${classpath}5 Log Files/"
		glob tabsfigspath	"${classpath}6 Tables and Figures/"
		cd 	"${classpath}" 

	**Start the log file (something we'll learn about later in class)
	
		capture log close
		log using "${logfilepath}Wk03_PracticeAssignment_log", replace 
	
*********
*
*	1: Open Data
*
*********

	use "${rawdatapath}Wk03_CaliSchools.dta", clear
	
	summarize
	
	describe
	
*********
*
*	2: Practice Commands
*
*********

** Lay of the Land
	codebook, compact
	describe, short
	// 14 variables,  39522 observations
	
	tab year
	bysort year: count
	// In 2009, there are 9,669 schools. In 2010, there are 9,640 schools. In 2011, there are 9,891 schools. In 2012, there are 10,322 schools. 
	
** Enrollment
	summarize enrollment
	// Average enrollment is about 615 children.
	
	list year schoolname if enrollment > 5000
	// There are 2 schools in 3 years with enrollment > 5000: Paramount High in 2009, and River Springs Charter in both 2011 and 2012 
	
*********
*
*	3: Close log file (we'll learn about this later)
*
*********	
	
	log close
	
	translate "${logfilepath}Wk03_PracticeAssignment_log.smcl" "${logfilepath}Wk03_PracticeAssignment_log.pdf", replace
	