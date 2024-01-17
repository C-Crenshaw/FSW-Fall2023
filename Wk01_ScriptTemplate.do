*********************************************************************************		
/*	TITLE: 		Wk01_ScriptTemplate.do								
*	PURPOSE:	Code written during class in Wk 01					
*	AUTHOR:		Allison Atteberry												
*	CREATED:	2022_0119													
*	UPDATED: 	YYYY_MMDD		
*	CALLS UPON:	"${rawdatapath}YOURDATASETNAMEHERE.dta"
*	PRODUCES: 	Figures:	NO
*				Tables: 	No
*				Datasets: 	NO.					
*	CONTENTS:	0: Set globals
* 				1: Open Data 
*				2: Here you'll run a sequence of commands that complete your activity
*				3: Close log file (learn about this in Week 03)
*/
*********************************************************************************

	clear all
	set more off
	pause on

*********
*	0. Set globals & start log file 
*********

	**Set file paths using globals 
	
		glob classpath		"C:/Users/alat8407/Box/UVA_Classes/LPPP_6001/"	// Comment out (i.e., put a * at the beginning of) this line when you've added yours below
		* In order to copy path files on a Mac, use control + option + C 
*		glob classpath		"" // <-- You'll put your own file path to the LPPP_6001 folder here, and uncomment it out (remove the * at the start)	
		glob rawdatapath	"${classpath}2 Raw Data/"
		glob syntaxpath		"${classpath}3 Syntax/"
		glob gendatapath	"${classpath}4 Generated Datasets/"
		glob logfilepath	"${classpath}5 Log Files/"
		glob tabsfigspath	"${classpath}6 Tables and Figures/"
		cd 	"${classpath}" 

	**Start the log file (something we'll learn about later in class)
	
		capture log close
		log using "${logfilepath}Wk01_ScriptTemplate_log", replace 
	
*********
*	1: Open Data
*********

	use "${rawdatapath}Wk01_MiniELSdataset.dta", clear

*********
*	2: Here you'll run a sequence of commands that complete your activity
*********

	**Q1. How many students in this dataset attend an urban school?
	
		describe 	// To examine all variable labels to find the relevant var for this question 
				
		tab schurbanicity

	**Q2. What percentage of students  attend a school with less than 400 students? 

		codebook schenrollcat

		tab schenrollcat, missing
		
	**Q3. How many students do not have data available on maternal education?

		codebook stumotheduc
		
		tab stumotheduc, missing  // If you want to include the missing values 		

	**Q4. What is the highest score any student in this dataset got on the math test?

		codebook stutest_mth
				
		summarize stutest_mth
	
*********
*	3: Close log file (learn about this in Week 03)
*********	
	
	log close
	
	translate "${logfilepath}Wk01_ScriptTemplate_log.smcl" "${logfilepath}Wk01_ScriptTemplate_log.pdf"
