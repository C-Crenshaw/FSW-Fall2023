*********************************************************************************		
/*	TITLE: 		Wk05_ContentSlideDeck.do								
*	PURPOSE:	Code written during Wk05 Screencasts as part of Wk05_Content.pptx slide deck			
*	AUTHOR:		Allison Atteberry												
*	CREATED:	2022_0119													
*	UPDATED: 	YYYY_MMDD		
*	CALLS UPON:	sysuse auto.dta
*				"${rawdatapath}Wk05_VA_Grades35_2008.dta"
*	PRODUCES: 	Figures:	NO
*				Tables: 	No
*				Datasets: 	NO.					
*	CONTENTS:	0. Set globals & start log file 
*				1: Open Data: A dataset that was included with the Stata system: auto.dta
*				2: Generating an indicator for low repairs
*				3: Recoding and clonevar: foreign
*				4: Recoding and clonevar: Make rep78_v3
*				5: From 1 categorical variable --> a set of 0/1 dummies
*				6: A few more odds and ends - using 
*				7: Close log file
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
		log using "${logfilepath}Wk05_ContentSlideDeck_log", replace 
	
******
*
*	1: Open Data: A dataset that was included with the Stata system: auto.dta
*
******
	
	*help sysuse 	// sysuse filename 	<-- loads the specified Stata-format dataset that was shipped with Stata
					// sysuse dir		<-- lists the names of the datasets shipped with Stata plus any other datasets stored along the ado-path.

	sysuse auto.dta, clear
	
	describe, short	// 74 observations, 12 variables 
	
	codebook, compact // vars seem to capture features of cars 
	
	ssc install mdesc // This line of code will ensure that you have the "mdesc" command installed on your Stata (if you dont' already)
	mdesc	// very little missing data to worry about here 
	
	codebook make // always good to examine the ID variable	

	browse 	// I often just keep the dataset open in the background, and I always just look at it to make sense of what I'll be working with 
	

*********
*
*	2: Generating an indicator for low repairs
*
*********

	codebook rep78	// var is repair record in 1978, 5 unique values 1 thru 5, 5 missing values 
	
	**Step 1: Create 
	
		cap drop repair_low
		generate repair_low = 1 if rep78<=3
		replace  repair_low = 0 if repair_low==.

	**Step 2: Document 

		label variab repair_low "dummy: 1 if 3 repairs or fewer, 0 otherwise"
		
		cap lab drop repair_low_vallab
		label define repair_low_vallab 1 "1: <=3 reps" 0 "0: >3 reps"
		label values repair_low repair_low_vallab
		
		tab repair_low, missing
	
	**Step 3: Verify 
	
		tab rep78 repair_low, missing	// My verification step revealed a problem!
	
	**How to fix it: Strategy #1 
	
		replace  repair_low = . if rep78==.
	
		**Now Re-Verify 
		
		tab rep78 repair_low, missing	// Fixed!
	
	**How to fix it: Strategy #2: 
	**Add a cap drop and make the variable in more steps 
	
		cap drop repair_low 
		generate repair_low=9999
		replace  repair_low=1 if rep78<=3
		replace  repair_low=0 if rep78> 3
		replace  repair_low=. if rep78==.

		label variab repair_low "dummy: 1 if 3 repairs or fewer, 0 otherwise"

		label values repair_low repair_low_vallab
		
		**Now Re-Verify 
		
			tab rep78 repair_low, missing	// Fixed!

	**How to fix it: Strategy #3: 		
	
		cap drop repair_low 
		generate repair_low=(rep78<=3)
		replace  repair_low=. if rep78==.

		label variab repair_low "dummy: 1 if 3 repairs or fewer, 0 otherwise"

		label values repair_low repair_low_vallab
		
		**Now Re-Verify 
		
			tab rep78 repair_low, missing	// Fixed!		
						
*********
*
*	3: Recoding and clonevar: foreign
*
*********

	codebook foreign
			
	**Let's begin by making a new variable that is exactly the same as foreign but has a new name:

		generate foreign_v2 = foreign, after(foreign) // new option!
		
		lab var  foreign_v2 "Oddly coded version of foreign Domestic=10, Foreign=20"

	**Sidenote: clonevar 
		
		help clonevar	// Syntax:  clonevar newvar = varname [if] [in]
		clonevar foreign_v3 = foreign 
		
		su foreign* // summarize all variables that begin with the word variable
		*browse foreign*

	**How to make foreign_v2 = to 10 and 20 
	
		**Option 1: Using replace 
		
			replace  foreign_v2 = 10 if foreign == 0
			replace  foreign_v2 = 20 if foreign == 1
			tab foreign_v2, mi

		**Option 2: Using recode 
		
			*help recode 
			recode  foreign_v3 0=10 1=20

			**But would then need to add a new value label set
			
			cap lab drop foreign_v3_vallab
			label define foreign_v3_vallab 10 "10= Domestic" 20 "20= Foreign"
			label values foreign_v3  foreign_v3_vallab
			
			tab foreign_v3, mi
			
*********
*
*	4: Recoding and clonevar: Make rep78_v3
*
*********
	
	tab rep78, mi 	// Start by examining the variable I'll use to make rep78_v3
	
	**Step 1: Create 
	
		cap drop rep78_v3 	// This is a helpful this to do right before making any new variable
		clonevar rep78_v3 = rep78

		recode   rep78_v3  1/2=1  3/4=2  5=3	// You may want to review the syntax in the help file 
				
	**Step 2: Document 
		
		label variab rep78_v3 "Repair Record in 1978 (3 categories)"
		
		cap lab drop rep78_v3_vallab
		label define rep78_v3_vallab 1 "1:1or2 reps" 2 "2:3or4 reps" 3 "3: 5 reps"
		label values rep78_v3  rep78_v3_vallab

		tab rep78_v3, mi 	// Make sure the variable and value labels were applied
		
	**Step 3: Verify 
	
		tab rep78 rep78_v3, mi 
		
		
*********
*
*	5: From 1 categorical variable --> a set of 0/1 dummies
*
*********		
		
		*help tab // Type this to learn about the options on a oneway tab command
		
		*tab varname, generate(stubname) <-- Note to self

		cap drop repair_* // Useful before making new vars 
		
		tab rep78, gen(repair_)

		codebook repair_*, compact // Examine newly-made vars

		*browse make rep78 repair_* // maybe also browse the variables

		
*********
*
*	6: A few more odds and ends - using 
*	use "${rawdatapath}Wk05_ContentSlideDeck_log.dta", clear
*
*********		

	* Open a different dataset from Collab
	* Wk05_VA_Grades35_2008.dta

		use "${rawdatapath}Wk05_VA_Grades35_2008.dta", clear

	**Here are some commands I often use to get to know a new dataset: 
		
		describe, short		// 3,357 observations (rows) and 58 variables (columns) in this dataset
		
		codebook, compact	// Get to know what kind of variables are in this dataset
		
		mdesc 			// a nice command for checking out %missing's
		
		distinct SchID	// there are 1160 unique values of the SchID, but there are 3357 observations 
		
		tab SchYr, mi	// All these observations come from a singly School Year (2008)
		
		tab Grade, mi	// Ok, so now I see that each school has 3 observations: one for grade 3, one for grade 4, and one for gra
	
		browse 		// I often just keep the dataset open in the background, and I always just look at it to make sense of what I'll be working with 

	**
	*  	In which grade is the average reading score the highest?  What about the average math score? 
	*	Relevant variables: R_AvgScr_All and M_AvgScr_All
	**
	
		bysort Grade: su R_AvgScr_All

		bysort Grade: su M_AvgScr_All

	**
	* Renaming variables:
	**
	
		use "${rawdatapath}Wk05_VA_Grades35_2008.dta", clear

		*help rename
		*Note to self: the syntax for this command is: rename oldvar newvar

		**Let's try it:
		describe NoStu Bl_Grade 	 // These variable names aren't super clear. Could we do better?
		rename 	 NoStu  SchEnr
		rename   Bl_Grade  GradeEnr_Bl

		* The rename command is *quite* flexible
		
		rename M_*  math*	// Change the prefix on all the math variables from M to math

		rename *_All  *_total	// Change any vars that end in "_All" to end in "_total" instead

		rename *Avg*  *Lemur*	// Change any vars that have "Avg" anywhere to say "Lemur"

		rename *Lemur*  *Mean*	// Ok…maybe not the best name! Let's change to "Mean" instead

		rename *,  lower		// cool! renames all variables to be lowercase 

		desc *math* // anything that has math somewhere in the middle
		desc *_total // anything that has total at the end

	***
	* Ordering variables
	***

		use "${rawdatapath}Wk05_VA_Grades35_2008.dta", clear

		*help order // Note to self on syntax for this command: order varlist, [options]	

		order _all, alpha	// Order all variables alphabetically

		order SchID SchNm DivNo DivNm Grade 	// Order variables so that all the ID variables are first (e.g., school, division, grade)

		order FL FLPer RL RLPer, after(Grade) //  Now put free/reduced price lunch variables next (after ID variables)

	***
	* Drop/Keep
	**

		* Dropping / keeping variables:

			use "${rawdatapath}Wk05_VA_Grades35_2008.dta", clear

			drop TitleI RLPer FLPer

			keep SchID - RL

		* Dropping/keeping observations

			use "${rawdatapath}Wk05_VA_Grades35_2008.dta", clear
		
			drop if NoStu< 300
		
			keep if FLPer<.50
	
	***
	* Check-In
	**
	
	*1. Generate a new variable called headroom3 with three values.  Set the new variable equal to 1 if  the variable headroom is less than 3, 2 if headroom is between 3 and 4 (inclusive), and 3 if headroom is greater than 4. Be sure to label the variable. Also add a set of value labels to the values 1, 2, and 3 of 1:low, 2:medium, and 3:high, respectively.
	sysuse auto.dta, clear
	
	cap drop headroom3
	clonevar headroom3 = headroom 
	replace  headroom3 = 1 if headroom3 < 3
	replace  headroom3 = 2 if 3 <= headroom3 & headroom3 <= 4
	replace  headroom3 = 3 if headroom3 > 4
	
	label variab headroom3 "Headroom (in) (3 categories)"
		
	cap lab drop headroom3_vallab
	label define headroom3_vallab 1 "1:low" 2 "2:medium" 3 "3:high"
	label values headroom3  headroom3_vallab
	
	*Alternatively, this code also works 
	cap drop headroom3
	clonevar headroom3 = headroom 
	recode   headroom3  1/2.5=1  3/4=2  4.5/5=3
	
	label variab headroom3 "Headroom (in) (3 categories)"
	
	cap lab drop headroom3_vallab
	label define headroom3_vallab 1 "1:low" 2 "2:medium" 3 "3:high"
	label values headroom3  headroom3_vallab

	*2 Write the code to drop all domestic cars from the dataset (see the variable foreign).
	
	drop if foreign == 0
	
	

******
*
*	7: Close log file
*
******	
	
	log close
	
	translate "${logfilepath}Wk05_ContentSlideDeck_log.smcl" "${logfilepath}Wk05_ContentSlideDeck_log.pdf"
	