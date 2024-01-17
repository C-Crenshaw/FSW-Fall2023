*********************************************************************************		
/*	TITLE: 		Wk06_ContentSlideDeck.do								
*	PURPOSE:	Do file to go along with the 6th lecture of FSW				
*	AUTHOR:		Carson Crenshaw												
*	CREATED:	2023_1003													
*	UPDATED: 	YYYY_MMDD		
*	CALLS UPON:	"${rawdatapath}Wk06_ECLSK_Public_Abridged.dta"
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
	
		glob classpath		"/Users/carsoncrenshaw/Library/CloudStorage/OneDrive-UniversityofVirginia/LPPP_6001/"
		glob rawdatapath	"${classpath}2 Raw Data/"
		glob syntaxpath		"${classpath}3 Syntax/"
		glob gendatapath	"${classpath}4 Generated Datasets/"
		glob logfilepath	"${classpath}5 Log Files/"
		glob tabsfigspath	"${classpath}6 Tables and Figures/"
		cd 	"${classpath}" 

	**Start the log file (something we'll learn about later in class)
	
		capture log close
		log using "${logfilepath}Wk06_ContentSlideDeck_log", replace 
	
*********
*
*	1: Open Data
*
*********

	use "${rawdatapath}Wk06_ECLSK_Public_Abridged.dta", clear

	
*********
*
*	1: Stata's display command 
*
*********

	*help display
	/*	From Help File: 
		display displays strings and values of scalar expressions.  
		display produces output from the programs that you write.

		Interactively, display can be used as a substitute for a hand calculator; 
		see [R] display.  You can type things such as display 2+2.
	*/
	
	
	
	display 3 + 4 + 8 // think of display like print
	
	tab gender 
	/*	
		 GENDER |      Freq.     Percent        Cum.
	------------+-----------------------------------
		   MALE |      3,688       51.99       51.99
		 FEMALE |      3,406       48.01      100.00
	------------+-----------------------------------
		  Total |      7,094      100.00
	*/
	
	display 3406 / 7094 * 100 
	
	display   "Hello! My name is Allison A!"
	
	display	  "The number of fingers I have is: " 5 + 5
	
	** display in red is a special color -- will be shown whether you "run" or "do" your syntax file

	di in red "The number of fingers I have is: " 5 + 5	

*********
*
*	Macros
*
*********


	***
	*	locals -- string example
	***

		local myfullname "Allison Claire Mebane Atteberry"	// <-- Syntax to define a string local: local localname "string here"
		
		display 	" `myfullname' "	// <-- Syntax to call upon a local. Stata recognizes locals with what people call `funny quotes'
		
		di in red   "Hello! My name is `myfullname' "
		
		
	***
	*	locals -- numeric
	***
	
		count
		
		local numobs = 7094
		
		display `numobs' 
		
		di "There are `numobs' observations in this dataset"
		
	***
	*	globals -- string example
	***
	 
		global myfullname "Allison Claire Mebane Atteberry"	// <-- Syntax to define a string global: global globalname "string here"
		
		display 	" ${myfullname} "	// <-- Syntax to call upon a global. Stata recognizes globals with ${}
		
		di in red   "Hello! My name is ${myfullname} "
		
	***
	*	globals -- numeric
	***
		
		count
		
		global numobs = 7094
		
		display ${numobs}
		
		di "There are ${numobs} observations in this dataset"
	
	***
	*	locals -- another numeric example 
	***
	
		local numfingers = 5 + 5
		
		display `numfingers' + 1 
	
		*The above command is equivalent to:
	
		display 5 + 5 + 1 
	
	
	***
	*	locals -- another string
	***
	
		local prof_vars "c1rprof1 c1rprof2 c1rprof3 c1rprof4 c1rprof5"
		
		display "The proficiency vars are: `prof_vars' "
		
		summarize `prof_vars'
		
		*The above command is equivalent to:

		summarize c1rprof1 c1rprof2 c1rprof3 c1rprof4 c1rprof5
		
		codebook `prof_vars', compact
		
		desc `prof_vars'
		
		
	***
	*	globals -- another string
	***
	
		global myproficiency_vars "c1rprof1 c1rprof2 c1rprof3 c1rprof4 c1rprof5"
		
		display "The proficiency vars are: ${myproficiency_vars} "
		
		summarize ${myproficiency_vars}
		
		*The above command is equivalent to:

		summarize c1rprof1 c1rprof2 c1rprof3 c1rprof4 c1rprof5
		
		codebook ${myproficiency_vars}, compact
		
		desc ${myproficiency_vars}	
		
		
	
*********
*
*	Built-in macros – stored results
*
*********	
			
	count 
		
		return list
		
		display `r(N)'
		
		display "The number of obs in this dataset is --> " `r(N)'		
		
		*help count
		
			
	count if gender == 2
		
		return list
		
		display `r(N)'
		
		display "The number of obs in this dataset is that are females is " `r(N)'		
	
	*help summarize
	/*	Stored results
    summarize stores the following in r():
      r(N)           number of observations
      r(mean)        mean
      r(min)         minimum
      r(max)         maximum
      r(sum_w)       sum of the weights
      r(Var)         variance
      r(sum)         sum of variable
      r(sd)          standard deviation
	*/	
	summarize c1mscale
	
		return list
		
	di "The math scores have a mean of `r(mean)' and an SD of `r(sd)'"
	di "The math scores have a min of `r(min)' and a max of `r(max)'"

	**Get to know the math score variable 
	
		codebook c1mscale
		su 		 c1mscale
		gsort 	 c1mscale
		browse   c1mscale
	
	**Make standardized version (standard deviation subtracted by the mean) (new mean of 0, std of 1)
	
		**Step 1: Create 
		
		cap drop c1mscale_std
		generate c1mscale_std= 99999
		su 		 c1mscale	// to get the mean and sd of c1mscale as a stored result 
		replace  c1mscale_std= (c1mscale - `r(mean)') / `r(sd)'
		
		**Step 2: Document 
		
		label var c1mscale_std "standardized version of c1mscale"
		
		**Step 3: Verify -- Does new var have mean of 0, sd of 1? 
		
		su c1mscale_std
		
		di in red "Our new var has a mean of `r(mean)'"
		di in red "Our new var has an sd  of `r(sd)'"
		
		

*********
*	3: Close log file (learn about this in Week 03)
*********	
	
	log close
	
	translate "${logfilepath}Wk06_ContentSlideDeck_log.smcl" "${logfilepath}Wk06_ContentSlideDeck_log.pdf"
