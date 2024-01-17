*********************************************************************************		
/*	TITLE: 		Wk08_ContentSlideDeck.do								
*	PURPOSE:	Code written during class in Wk 08, to learn to MERGE 					
*	AUTHOR:		Carson Crenshaw												
*	CREATED:	2022_0119													
*	UPDATED: 	YYYY_MMDD		
*	CALLS UPON:	"${rawdatapath}Wk08_socialskills_fall.dta"
*				"${rawdatapath}Wk08_socialskills_fall_v1.dta"
*				"${rawdatapath}Wk08_socialskills_spring.dta"
*				"${rawdatapath}Wk08_socialskills_spring_7kids.dta"
*				"${rawdatapath}Wk08_socialskills_spring_v1.dta"
*	PRODUCES: 	Figures:	NO
*				Tables: 	No
*				Datasets: 	NO.					
*	CONTENTS:	0. Set globals & start log file 
*				1. MERGE: INTRODUCTION
*				2. MERGE: COMPLICATIONS 
*				3. MERGE MISTAKE: Potential Problem w/ No Error Message 
*				4.  Close log file
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
	
		glob classpath		"/Users/carsoncrenshaw/Library/CloudStorage/OneDrive-UniversityofVirginia/LPPP_6001"
		glob rawdatapath	"${classpath}/2 Raw Data/"
		glob syntaxpath		"${classpath}/3 Syntax/"
		glob gendatapath	"${classpath}/4 Generated Datasets/"
		glob logfilepath	"${classpath}/5 Log Files/"
		glob tabsfigspath	"${classpath}/6 Tables and Figures/"
		cd 	"${classpath}" 

	**Start the log file (something we'll learn about later in class)
	
		capture log close
		log using "${logfilepath}Wk08_ContentSlideDeck_log", replace 
	

*******
*
*	1. MERGE: INTRODUCTION
*
*******

	help merge 
		/*
		Syntax: merge 1:1 varlist using "filename.dta" [, options]
		Description:  merge joins corresponding observations from the dataset currently in memory
			(called the master dataset) with those from filename.dta (called the using
			dataset), matching on one or more key variables...
			merge is for adding new variables from a second dataset to existing
			observations.  You use merge, for instance, when combining hospital patient
			and discharge datasets. If you wish to add new observations to existing
			variables, then see [D] append.  You use append, for instance, when adding
			current discharges to past discharges...
			By default, merge creates a new variable, _merge, containing numeric codes
			concerning the source and the contents of each observation in the merged
			dataset. These codes are explained below in the match results table.

			options          Description
			----------------------------------------------------------------
			generate(newvar) newvar marks source of resulting observations
			keep(varlist)    keep specified variables from appending dataset(s)
			nolabel          do not copy value-label definitions from dataset(s) on disk
			nonotes          do not copy notes from dataset(s) on disk
			force            append string to numeric or numeric to string without error
			----------------------------------------------------------------
		*/
	
	**It's always a good idea to examine the 2 datasets before you try to merge them. 

		use "${rawdatapath}Wk08_socialskills_fall.dta", clear
		codebook, compact	// 3 vars, 10 children (observations) for tchid 4
		browse				// 3 vars are: childid, tchid, socski_fall
		
		use "${rawdatapath}Wk08_socialskills_spring.dta", clear
		codebook, compact	// 3 vars, 10 children (observations) for tchid 4
		browse				// 3 vars are: childid, tchid, socski_spr


	***
	*	Merge syntax 
	***

		use "${rawdatapath}Wk08_socialskills_fall.dta", clear // master dataset
		
		merge 1:1 childid using ///
			"${rawdatapath}Wk08_socialskills_spring.dta" // using dataset
			
* RESULTS/OUTPUT: 

* .  merge 1:1 childid using ///
*>           "${rawdatapath}Wk08_socialskills_spring.dta" 
* 
*    Result                      Number of obs
*    -----------------------------------------
*    Not matched                             0
*    Matched                                10  (_merge==3)
*    -----------------------------------------
* All observations were matched, no errors because data was so clean
		

*******
*
*	2. MERGE: COMPLICATIONS 
*
*******
	
	***
	*	What if the set of unique IDs not the same?
	***

		**It's always a good idea to examine the 2 datasets before you try to merge them. 
		**Can you spot what the complication is going to be? 
		
			use "${rawdatapath}Wk08_socialskills_fall.dta", clear
			codebook, compact	// 3 vars, 10 children (observations) for tchid 4
			browse				// 3 vars are: childid, tchid, socski_fall
			
			use "${rawdatapath}Wk08_socialskills_spring_7kids.dta", clear
			codebook, compact	// 3 vars, 7 children (observations) for tchid 4
			browse				// 3 vars are: childid, tchid, socski_spr
		
		**Conduct the merge 
		
			use "${rawdatapath}Wk08_socialskills_fall.dta", clear
		
			merge 1:1 childid using ///
				"${rawdatapath}Wk08_socialskills_spring_7kids.dta"
			
			tab _merge 
			
			codebook, compact	// It is "wider" (more columns)... now 4 vars, and a total of 10 children (observations)
			
			browse
			
		**Other way around
			use "${rawdatapath}Wk08_socialskills_spring_7kids.dta", clear
		
			merge 1:1 childid using ///
				"${rawdatapath}Wk08_socialskills_fall.dta"
			
			tab _merge 
			
			codebook, compact	// It is "wider" (more columns)... now 4 vars, and a total of 10 children (observations)
			
			browse


*******
*
*	3. MERGE MISTAKE: Potential Problem w/ No Error Message 
*
*******			
	
	**It's always a good idea to examine the 2 datasets before you try to merge them. 
	**Can you spot what the complication is going to be? 
	
		use "${rawdatapath}Wk08_socialskills_fall_v1.dta", clear
		codebook, compact	// 3 vars, 10 children (observations) for tchid 4
		browse				// 3 vars are: childid, tchid, socski
		
		use "${rawdatapath}Wk08_socialskills_spring_v1.dta", clear
		codebook, compact	// 3 vars, 10 children (observations) for tchid 4
		browse				// 3 vars are: childid, tchid, socski
		
	**Conduct the merge 
		
		use "${rawdatapath}Wk08_socialskills_fall_v1.dta", clear
		
		merge 1:1 childid using ///
			"${rawdatapath}Wk08_socialskills_spring_v1.dta"
				
		tab _merge 
		
		codebook, compact	// Hmmm.... it DIDNT get any wider (except for the _merge variable)
		
		browse // problem: the dataset did not get wider; no differentiation between the fall and spring social skills variable.
		
	**How to fix this problem
		
		**Pre-cleaning 
		
			use  "${rawdatapath}Wk08_socialskills_fall_v1.dta", clear
			rename socski socski_fall 
			save "${gendatapath}Wk08_socialskills_fall_v1_cleaned.dta", replace
			
			use  "${rawdatapath}Wk08_socialskills_spring_v1.dta", clear
			rename socski socski_spr
			save "${gendatapath}Wk08_socialskills_spring_v1_cleaned.dta", replace
		
		**Conduct the merge with the CLEANED DATASETS
		
		use "${gendatapath}Wk08_socialskills_fall_v1_cleaned.dta", clear
		
		merge 1:1 childid using ///
			"${gendatapath}Wk08_socialskills_spring_v1_cleaned.dta"
				
		tab _merge 
		
		codebook, compact
		
		browse			

*******
*
*	4. Close log file
*
*******	
	
	log close
	
	translate "${logfilepath}Wk08_ContentSlideDeck_log.smcl" "${logfilepath}Wk08_ContentSlideDeck_log.pdf"
