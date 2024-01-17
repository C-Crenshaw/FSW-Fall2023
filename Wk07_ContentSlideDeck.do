*********************************************************************************		
/*	TITLE: 		Wk07_ContentSlideDeck.do								
*	PURPOSE:	Code written during class in Wk 07, to learn to APPEND					
*	AUTHOR:		Carson Crenshaw											
*	CREATED:	2022_0119													
*	UPDATED: 	YYYY_MMDD		
*	CALLS UPON:	"${rawdatapath}Wk07_socialskills_teacher01.dta"
*				"${rawdatapath}Wk07_socialskills_teacher02.dta"
*				"${rawdatapath}Wk07_socialskills_teacher02_v1.dta"
*				"${rawdatapath}Wk07_socialskills_teacher02_v2.dta"
*				"${rawdatapath}Wk07_socialskills_teacher02_v3.dta"
*	PRODUCES: 	Figures:	NO
*				Tables: 	No
*				Datasets: 	YES					
*	CONTENTS:	0. Set globals & start log file 
*				1. APPPEND: INTRODUCTION
*				2. APPPEND: POTENTIAL PROBLEMS 
*				3.  Close log file
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
		log using "${logfilepath}Wk07_ContentSlideDeck_log", replace 
	
*******
*
*	1. APPPEND: INTRODUCTION
*
*******

	*help append 
		/*
		Syntax: append using "filename.dta" [, options]
		Description: append appends Stata-format datasets stored on disk to the end
			of the dataset in memory.  If any filename is specified without
			an extension, .dta is assumed.
		options          Description
		----------------------------------------------------------------
		generate(newvar) newvar marks source of resulting observations
		keep(varlist)    keep specified variables from appending dataset(s)
		nolabel          do not copy value-label definitions from dataset(s) on disk
		nonotes          do not copy notes from dataset(s) on disk
		force            append string to numeric or numeric to string without error
		----------------------------------------------------------------
		*/
	
	
	**It's always a good idea to examine the 2 datasets before you try to append them. 

		use "${rawdatapath}Wk07_socialskills_teacher01.dta", clear
			codebook, compact 
			browse
			count 
			
		use "${rawdatapath}Wk07_socialskills_teacher02.dta", clear
			codebook, compact 
			browse
			count 

	***
	*	Append syntax 
	***

		use "${rawdatapath}Wk07_socialskills_teacher01.dta", clear //master data

		append using "${rawdatapath}Wk07_socialskills_teacher02.dta" //used data

		count // Now there are 10 observations

	***
	*	Appending multiple datasets at once
	***
	
		clear 
		append using ///
			"${rawdatapath}Wk07_socialskills_teacher01.dta" ///
			"${rawdatapath}Wk07_socialskills_teacher02.dta" ///
			"${rawdatapath}Wk07_socialskills_teacher03.dta" /// 
			, gen(source) 
			// creates another column named "source" that documents source of data
			
			// three slashes represents a delimiter, all one command
		
*******
*
*	2. APPPEND: POTENTIAL PROBLEMS 
*
*******

	***
	*  Append Common Problem #1: 
	***
	
	// No error message
	
		**It's always a good idea to examine the 2 datasets before you try to append them. 
		**Can you spot what the problem is going to be? 
	
			use "${rawdatapath}Wk07_socialskills_teacher01.dta", clear
				codebook, compact 
				browse
			use "${rawdatapath}Wk07_socialskills_teacher02_v1.dta", clear
				codebook, compact 
				browse

		**Try to append: 
	
			use 		 "${rawdatapath}Wk07_socialskills_teacher01.dta", clear
			append using "${rawdatapath}Wk07_socialskills_teacher02_v1.dta"
			browse 		// "Is this what we wanted?"
		
		**How to fix
		**The two datasets have the same content in their variables, but the variables themselves have different names! 
		**Stata has no way to infer that gender and female are the same variable
		**How to fix: Once you realize you have a problem, add pre-cleaning to one of the datasets in advance

			use 		 "${rawdatapath}Wk07_socialskills_teacher01.dta", clear
			rename gender female
			append using "${rawdatapath}Wk07_socialskills_teacher02_v1.dta"
			browse

	***			
	*  Append Common Problem #2: 
	***

	// No error message
	
		**It's always a good idea to examine the 2 datasets before you try to append them. 
		**Can you spot what the problem is going to be? 
		
			use "${rawdatapath}Wk07_socialskills_teacher01.dta", clear			
				codebook, compact 
				browse
			use "${rawdatapath}Wk07_socialskills_teacher02_v2.dta", clear
				codebook, compact 
				browse
	
		**Try to append: 
	
			clear 
			use          "${rawdatapath}Wk07_socialskills_teacher01.dta", clear
			append using "${rawdatapath}Wk07_socialskills_teacher02_v2.dta"
			browse
			tab gender, mi // Oops I notice this isn't what I wanted

		**How to fix
		**	Your variables are coded differently in different datasets 
		**	Stata has no way to infer that your gender variable was coded differently 
		
			use          "${rawdatapath}Wk07_socialskills_teacher01.dta", clear
			recode  gender (0=1) (1=2)	// newly added line of code
			lab var gender "Gender dummy where 2 = female, 1 = male"	// update var label too
			
			cap lab drop gender_vallab 
			label define gender_vallab 2 "2=female" 1 "1 = male" 
			label values gender gender_vallab
			
			append using "${rawdatapath}Wk07_socialskills_teacher02_v2.dta"
			browse
			tab gender, mi // 		
			
	***	
	*	Append Common Problem #3: 
	***

		**It's always a good idea to examine the 2 datasets before you try to append them. 
		**Can you spot what the problem is going to be? 
		
			use "${rawdatapath}Wk07_socialskills_teacher01.dta", clear
			desc
			browse
			use "${rawdatapath}Wk07_socialskills_teacher02_v3.dta", clear //numbers stored as string variables
			desc 
			browse
		
		**Try to append: 
	
			use "${rawdatapath}Wk07_socialskills_teacher01.dta", clear
			capture noisily ///
			append using "${rawdatapath}Wk07_socialskills_teacher02_v3.dta"
			/*	I got this error message! 		
				variable socialskills is byte in master but str2 in using data
				You could specify append's force option to ignore this numeric/string mismatch.  The using variable would then be
				treated as if it contained numeric missing value.
			*/		

		**How to fix
		**	Your variables are coded differently in different datasets 
		**	Stata has no way to infer that your gender variable was coded differently 
		
			use  		 "${rawdatapath}Wk07_socialskills_teacher01.dta", clear 
			
			tostring socialskills, replace 	// Added pre-cleaning, creating string variables
			
			append using "${rawdatapath}Wk07_socialskills_teacher02_v3.dta"	// Notice I am now appending the cleaned version in the "4 Generated Datasets" folder! 
			
			browse
			tab socialskills, mi // 
			
			destring socialskills, replace


*******
*
*	3.  Close log file
*
*******	
	
	log close
	
	translate "${logfilepath}Wk07_ContentSlideDeck_log.smcl" "${logfilepath}Wk07_ContentSlideDeck_log.pdf"
