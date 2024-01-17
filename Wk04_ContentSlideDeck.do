*********************************************************************************											
/*	TITLE: 		Wk04_ContentSlideDeck.do								
*	PURPOSE:	Code written during Screencasts for Week 4					
*	AUTHOR:		Carson Crenshaw												
*	CREATED:	2023_0919															
*	CALLS UPON:	"${rawdatapath}Wk04_nlsw88.dta"
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
		glob classpath		"/Users/carsoncrenshaw/Library/CloudStorage/OneDrive-UniversityofVirginia/LPPP_6001/"	
		glob rawdatapath	"${classpath}2 Raw Data/"
		glob syntaxpath		"${classpath}3 Syntax/"
		glob gendatapath	"${classpath}4 Generated Datasets/"
		glob logfilepath	"${classpath}5 Log Files/"
		glob tabsfigspath	"${classpath}6 Tables and Figures/"
		cd 	"${classpath}" 

	**Start the log file 
	
		capture log close
		log using "${logfilepath}Wk04_ContentSlideDeck_log", replace
	
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
	
	*** Generate a weekly wages variable ***
	
		generate weekly_wages = wage * hours // ONLY ONE EQUAL SIGN

		* Verify that the new variable operates as expected:

		su wage hours weekly_wages
		hist weekly_wages, frequency	// new command to make a histogram
	
		label variable weekly_wages "Estimated weekly wages, wage*hours"

	* Let's make a "dummy" or "indicator" variable

		*Begin by generating a var, I've chosen to name it age40plus, which will be set to 1 if age is bigger than 40, 0 if <40, and missing if age is missing

			codebook age						// First, examine the variable(s) I'll be using to create the new variable. Any missings in that var?
			generate age40plus = 0 
			replace  age40plus = 1 if age>= 40
			replace  age40plus = . if age==.
		
		*Write code that will help you verify that you were successful. 

		**One option: 
			tab age age40plus, miss
		
		** Another option:
			bysort age40plus : su age
		
		** Another option: 

			gsort +age
			browse age age40plus

	** Label the variable
	
		label var age40plus "indicator where 1= age40 or above, 0 = <40"
		label var age40plus "dummy: 1= woman is age 40+, 0 = not"
		codebook  age40plus
		codebook age40plus, compact

	** Label the values (what's the difference between variable labels and value labels)

		* Two step process:

		* First:  Define the value label 

			cap lab drop yesno_vallab // safety measure to ensure that you haven't already created this label
			label define yesno_vallab 0 "0=no" 1 "1=yes"

		* Second:  Assign label to variable
	
			lab values age40plus yesno_vallab
		
			codebook age40plus
			tab age40plus, mi
			browse id  age age40plus

	**Now quickly apply the yesno_vallab value label set to other variables 
	
		codebook     never_married south c_city
		label values never_married south c_city yesno_vallab
		codebook     never_married south c_city
		browse 		 never_married south c_city

	**If you forget your value label set names, you can always look them up! 
	
		label dir
		label list 
	 
*********
*
*	4: Screencast Practice: Generate a new variable called high_wage if hourly wages are 17 dollars an hour or higher.
*
*********

	codebook wage	// No missing data to worry about 
	generate high_wage=1 if wage>=17
	replace  high_wage=0 if wage <17
	*OR
	generate high_wagev2= wage>=17

	bysort high_wage : su wage
	
	label var high_wage "Hourly wages >=17"
	label val high_wage yesno_vallab
	tab high_wage

*********
*
*	5: Save a revised version of the dataset?
*
*********

	save "${gendatapath}Wk04_nlsw88_revised", replace


*********
*
*	6: Close log file 
*
*********	
	
	log close
	
	translate "${logfilepath}Wk04_ContentSlideDeck_log.smcl" "${logfilepath}Wk04_ContentSlideDeck_log.pdf", replace



