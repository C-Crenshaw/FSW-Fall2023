*********************************************************************************																	*		
/*	TITLE: 		Wk02_ContentSlideDeck.do								
*	PURPOSE:	Code written during class in Wk 02					
*	AUTHOR:		Allison Atteberry												
*	CREATED:	2022_0119													
*	UPDATED: 	YYYY_MMDD		
*	CALLS UPON:	"${rawdatapath}Wk02_MiniELSdataset.dta"
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
	
		*glob classpath		"C:/Users/alat8407/Box/UVA_Classes/LPPP_6001/"	// Comment out (i.e., put a * at the beginning of) this line when you've added yours below
		glob classpath	"/Users/carsoncrenshaw/Library/CloudStorage/OneDrive-UniversityofVirginia/LPPP_6001/"	
		glob rawdatapath	"${classpath}2 Raw Data/"
		glob syntaxpath		"${classpath}3 Syntax/"
		glob gendatapath	"${classpath}4 Generated Datasets/"
		glob logfilepath	"${classpath}5 Log Files/"
		glob tabsfigspath	"${classpath}6 Tables and Figures/"
		cd 	"${classpath}" 

	**Start the log file (something we'll learn about later in class)
	
		capture log close
		log using "${logfilepath}Wk02_ContentSlideDeck_log", replace 
	
*********
*
*	1: Open Data
*
*********

	use "${rawdatapath}Wk02_MiniELSdataset.dta", clear
	
*********
*
*	2: Do Some Things!
*
*********
	
	**RQ: What is the average math score among girls?

		codebook stusex
	
		summarize stutest_mth if stusex==2
	
		codebook stumotheduc
	
	**RQ: What is the average math score among children whose mother did not complete high school?
	
		su stutest_mth if stumotheduc==1	

	**RQ: How many students have mothers with a 4-year degree or an advanced degree?
	
		count if stumotheduc==6 | stumotheduc==7 | stumotheduc==8	

		count if stumotheduc>=6

		count if stumotheduc>=6 & stumotheduc < .
		* mdesc command shows the amount of missing values by variable

	**Command modifier in 
	* Browse in is very sensitive to previous sorts
	
		browse
		
		browse in 1/10
	
		browse in -5/16197
	
		browse in -5/l
		
		gsort -stutest_mth	// sorts the rows (aka observations or students) of the dataset in descending order
		
		browse stu_id stutest_mth in 1/10 
		
		list stu_id stutest_mth in 1/10 
		
		gsort -stutest_mth	// sorts the rows (aka observations or students) of the dataset in descending order

		browse stu_id stutest_mth in 1/10 

		list stu_id stutest_mth in 1/10 	 // list is a new command! What did it do?

	**Prefixing commands: bysort 
	
		bysort sturace: su stutest_mth

		bysort stusex : su stutest_mth
		
		bysort schurbanicity: tab stusex
		
		*bysort schurbanicity: tab sturace
		
		*gsort command sorts a variable by a certain criteria, not a prefix
	
	**Adding options (after a comma!) to your commands 
	
		su stutest_mth
		
		su stutest_mth, detail
		
		tab stusportspart stusex, col
		
		tab stusportspart stusex, row
		
		tab stusex
		
		tab stusex, nolabel

	**Getting help 
	
		help 
		
		help summarize 
		
	**Note: Must be very detailed about whether to acknowledge missing values or not. Look out for whether research questions ask for all observations with known data, or all observations given (i.e. asking for all women would include those who are missing values for other variables). 
	
	**Adopt default practice of tabulating data with the ,mi option so as to look for missing values. 

*********
*
*	3: Close log file (we'll learn about this later)
*
*********	
	
	log close
	
	translate "${logfilepath}Wk02_ContentSlideDeck_log.smcl" "${logfilepath}Wk02_ContentSlideDeck_log.pdf"



