*********************************************************************************											*		
/*	TITLE: 		Wk01_ScriptTemplate.do								
*	PURPOSE:	Code written during class in Wk 01					
*	AUTHOR:		Allison Atteberry												
*	CREATED:	2022_0119													
*	UPDATED: 	YYYY_MMDD		
*	CALLS UPON:	"${rawdatapath}Wk01_MiniELSdataset.dta"
*	PRODUCES: 	Figures:	NO
*				Tables: 	No
*				Datasets: 	NO.					
*	CONTENTS:	0: Set globals
* 				1: Open data 
*				2: Do Some Things!
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
	
		*glob classpath "C:/Users/alat8407/Box/UVA_Classes/LPPP_6001/"	// Comment out (i.e., put a * at the beginning of) this line when you've added yours below
		glob classpath "/Users/carsoncrenshaw/Library/CloudStorage/OneDrive-UniversityofVirginia/LPPP_6001/"	
		glob rawdatapath	"${classpath}2 Raw Data/"
		glob syntaxpath		"${classpath}3 Syntax/"
		glob gendatapath	"${classpath}4 Generated Datasets/"
		glob logfilepath	"${classpath}5 Log Files/"
		glob tabsfigspath	"${classpath}6 Tables and Figures/"
		cd 	"${classpath}" 

	**Start the log file (something we'll learn about later in class)
	
		capture log close
		log using "${logfilepath}Wk01_inclass_log", replace 
	
*********
*
*	1: Open Data
*
*********

	use "${rawdatapath}Wk01_MiniELSdataset.dta", clear
	
*********
*
*	2: Commands we ran during class
*
*********
	
	summarize stutest_mth 

	browse 
	
	describe
	
	codebook sturace
	
	codebook stusex
	
	summarize stutest_combined
	
	su  stutest_rdg	// The same as "summarize stutest_rdg"
	
	su
	
	tabulate sturace
	
	tabulate stulanghome

	tab stusportspart stusex 
	
	codebook stusportspart

*********
*
*	3: Answering Qs at the end of the Week 01 slide deck:
*
*********

	**Q1. How many students in this dataset attend an urban school?
	
		describe 	// To examine all variable labels to find the relevant var for this question 
		
		codebook schurbanicity
		
		tab schurbanicity

	**Q2. What percentage of students  attend a school with less than 400 students? 

		codebook schenrollcat

		tab schenrollcat, missing
		
	**Q3. How many students do not have data available on maternal education?

		codebook stumotheduc
		
		tab stumotheduc, missing  // If you want to include the missing values 		

	**Q4. What is the highest score any student in this dataset got on the math test?

		codebook stutest_mth
		
		browse stutest_mth
		
		summarize stutest_mth

	**Q5. How many female students in the dataset attend a school with 2,500 or more students


		tab schenrollcat stusex // 1st var will be rows, 2nd var will be columns

		tab stusex schenrollcat  // 1st var will be rows, 2nd var will be columns. Less pretty, but you can still find the answer.
	
*********
*
*	3: Close log file (we'll learn about this later)
*
*********	
	
	log close
	
	translate "${logfilepath}Wk01_inclass_log.smcl" "${logfilepath}Wk01_inclass_log.pdf"



