*********************************************************************************		
/*	TITLE: 		Wk08_PracticeActivity_AnswerKey.do								
*	PURPOSE:	Code written during Wk 07 Practice Activity, to learn to APPEND					
*	AUTHOR:		Allison Atteberry												
*	CREATED:	2022_0119													
*	UPDATED: 	YYYY_MMDD		
*	CALLS UPON:	"${rawdatapath}
*	PRODUCES: 	Figures:	NO
*				Tables: 	No
*				Datasets: 	YES					
*	CONTENTS:	0. Set globals & start log file 
* 				Q1. Append 3 Datasets Together
* 				Q2. Verify the Append Was Successful
*				Q3. Answer an RQ You Couldn't Have Answered Without the Append. 
* 				Q4.	[BONUS. Practice Looping]
*				Q5. Take steps to end your Stata session
*/
*********************************************************************************

	clear all
	set more off
	pause on
	ssc install mdesc

*******
*
*	0. Set globals & start log file 
*
*******

	**Set file paths using globals 
	
*		glob classpath		"C:/Users/aa2pn/Dropbox/Teaching/UVA Classes/LPPP 6001"	
		glob classpath		"/Users/ameliawagner/Desktop/LPPP_6001/"	// Comment out this line when you've added yours below
*		glob classpath		"" // <-- You'll put your own file path to the LPPP 6001 folder here, and uncomment it out (remove the asterisk at the start)	
		glob rawdatapath	"${classpath}/2 Raw Data/"
		glob syntaxpath		"${classpath}/3 Syntax/"
		glob gendatapath	"${classpath}/4 Generated Datasets/"
		glob logfilepath	"${classpath}/5 Log Files/"
		glob tabsfigspath	"${classpath}/6 Tables and Figures/"
		cd 	"${classpath}" 

	**Start the log file (something we'll learn about later in class)
	
		capture log close
		log using "${logfilepath}Wk08_PracticeActivity_AnswerKey_log", replace 

****
*
*	1. Conceptual Difference: Appending vs. Merging? 
*	Conceptually, how is merging these datasets different than appending them?  How will the end results be different? 
*
****

	/*
	ANSWER: 
	
	Appending the datasets meant stacking the datasets (adding observations, making dataset longer). 
	The resulting dataset will be long by schid and year (and wide by grade)
	
	Merging the datasets means adding variables, making the datasets wider.  
	The resulting dataset will be long by schid (only!) and wide by both grade AND syear 
	
	They have the same information organized in a different way.

	*/

****
* 
*	2. Consider Same-Named Variables: SYEAR
*
****

	** Before we merge the datasets, we will need to drop the syear variable from  each dataset. 
	** Why do we need to do this?  
	
		/* 	Answer: We need to drop the syear variable before merging because,
			in our merged dataset, each row will represent a particular school across all three years (2010, 2011, 2012) not in a single year.

			More mechanically, if we leave the syear variable, Stata will not make changes to the first one (2010) since the master data is inviolate
		*/

	** Write code to drop the  syear variable from  each dataset  (2010, 2011, 2012) 
	
		use "${rawdatapath}Wk07_SchAchGr1to3_2010.dta", clear
		drop syear 
		
		use "${rawdatapath}Wk07_SchAchGr1to3_2011.dta", clear
		drop syear 
	
		use "${rawdatapath}Wk07_SchAchGr1to3_2012.dta", clear
		drop syear 
		
	** But to do this, we're going to need to open raw data, make some pre-cleaning changes, and then save REVISED versions of those datasets in the "4 Generated Datasets" path. Build this into your code, as well. Save the new datasets as:
	** ${gendatapath}Wk08_StudAchGr1to3_2010_cleaned.dta
	** ${gendatapath}Wk08_StudAchGr1to3_2011_cleaned.dta
	** ${gendatapath}Wk08_StudAchGr1to3_2012_cleaned.dta 
	
		use  "${rawdatapath}Wk07_SchAchGr1to3_2010.dta", clear
		drop syear *Avg
		save "${gendatapath}Wk08_SchAchGr1to3_2010_cleaned.dta", replace // Notice I'm saving cleaned version in "5 Generated Datasets", updating name to Wk08, and adding "_cleaned" to the name 	
		
		
		use  "${rawdatapath}Wk07_SchAchGr1to3_2011.dta", clear
		drop syear *Avg 
		save "${gendatapath}Wk08_SchAchGr1to3_2011_cleaned.dta", replace // Notice I'm saving cleaned version in "5 Generated Datasets", updating name to Wk08, and adding "_cleaned" to the name 	
	
		
		use  "${rawdatapath}Wk07_SchAchGr1to3_2012.dta", clear
		drop syear *Avg 
		save "${gendatapath}Wk08_SchAchGr1to3_2012_cleaned.dta", replace // Notice I'm saving cleaned version in "5 Generated Datasets", updating name to Wk08, and adding "_cleaned" to the name 	
		
/*	** [Bonus: You could do Q2 with a loop! Not necessary, but shown in Answer Key]

		foreach syear in 2010 2011 2012 {
			
			use  "${rawdatapath}Wk07_SchAchGr1to3_`syear'.dta", clear
			drop syear *Avg 
			save "${gendatapath}Wk08_SchAchGr1to3_`syear'_cleaned.dta", replace // Notice I'm saving cleaned version in "5 Generated Datasets", updating name to Wk08, and adding "_cleaned" to the name 	
						
		}	// (close syear loop)
*/


****
* 
*	3. Before Merge: Examine the Newly-Cleaned Datasets
*
****

	**	3a. Pre-examine datasets
	**	It is always good practice to start by examining any datasets you're going to combine. 
	**	Write code to open each CLEANED dataset (you should have stored these in your "4 Generated Datasets" folder), and examine it. 
	**	In particular, you might want to examine the number of observations, number of variables, and examine the names of the variables. Why? Because we know, from the Screencasts, that many of the challenges that arise in merging are related to variable names. 

		use "${gendatapath}Wk08_SchAchGr1to3_2010_cleaned.dta", clear	// Notice I'm starting with the Datasets we cleaned in Q2 
			desc, short			// 200 observations (schools), 7 variables 
			codebook, compact 	// seems to be school's math and reading scores -- an average and then a score from each grade 1 through 3 
			codebook schid 		// never hurts to look closely at the id variable. No missingness, and it's unique 
			mdesc				// check for missing data. none here.
			*browse 	
		use "${gendatapath}Wk08_SchAchGr1to3_2011_cleaned.dta", clear
			desc, short			// 200 observations (schools), 7 variables 
			codebook, compact 	// seems to be be school's math and reading scores -- an average and then a score from each grade 1 through 3 
			codebook schid 		// never hurts to look closely at the id variable. No missingness, and it's unique  
			mdesc				// check for missing data. none here.
			*browse				// Any apparent differences in the variables? 	
		use "${gendatapath}Wk08_SchAchGr1to3_2012_cleaned.dta", clear
			desc, short			// 200 observations (schools), 7 variables 
			codebook, compact 	// seems to be be school's math and reading scores -- an average and then a score from each grade 1 through 3 
			codebook schid 		// never hurts to look closely at the id variable. No missingness, and it's unique  
			mdesc				// check for missing data. none here.
			*browse				// Any apparent differences in the variables? This can be hard to spot 
			
		** 	Question: How many variables and observations should you expect to have if the append is successful? 
		
		**	Answer: I expect the appended dataset to have 200 observations (one row per school)
		**			I expect the dataset to have 19 variables: 
		**			The schid variable (linking var), 6 math and reading vars from 2010, 6 math and reading vars from 2011, & 6 math and reading vars from 2012
		
		
	**3b. Try simply merging all three of your cleaned datasets 
	**		Write the code to merge the 3 cleaned datasets together. 
	**		Make 2010 the "master", then merge 2011 data to it. Then merge 2012 data to the other two.  
	
		use "${gendatapath}Wk08_SchAchGr1to3_2010_cleaned.dta", clear
		
		merge 1:1 schid using ///
			"${gendatapath}Wk08_SchAchGr1to3_2011_cleaned.dta"
			
			tab _merge 	// Perfect merge! 
			drop _merge // Drop this variable once I've checked in
			
		merge 1:1 schid using ///
			"${gendatapath}Wk08_SchAchGr1to3_2012_cleaned.dta"
			
			tab _merge 	// Perfect merge! 
			drop _merge // Drop this variable once I've checked in			
			
	**3c. Did you get the expected number of observations and rows? 
	**	  In 3a, we expected  the appended dataset to have 200 observations (one row per school); 
	**	  and we expected to have 19 variables (the schid variable [linking var], 6 math and reading vars from 2010, 6 math and reading vars from 2011, & 6 math and reading vars from 2012)
	**	  Is that what happened? Write in your code the command "desc, short" to check. 
			
			desc, short		// Didn't work! We got the right number of observations (200), but we only have 7 variables, when we should have 19.
		
		
****
* 
*	4.  Add pre-cleaning to fix the merge.
*
****
		
	**4a. Modify the code you wrote for Q2. This time, we also need to make sure that 
	**	  in each dataset (2010, 2011, 2012) each score variable now includes the syear in the name. 
	**	  To do this in the 2010, add the following code to your cleaning: 
		
		use  "${rawdatapath}Wk07_SchAchGr1to3_2010.dta", clear
		drop syear *Avg	// cleaning from Q2 
		rename MathGr* MathGr*_2010 	// newly-added pre-cleaning to fix the merge! 
		rename ReadGr* ReadGr*_2010 	// newly-added pre-cleaning to fix the merge!  		
		save "${gendatapath}Wk08_SchAchGr1to3_2010_cleaned.dta", replace // Notice I'm saving cleaned version in "5 Generated Datasets", updating name to Wk08, and adding "_cleaned" to the name 	
		
		
		use  "${rawdatapath}Wk07_SchAchGr1to3_2011.dta", clear
		drop syear *Avg	// cleaning from Q2 
		rename MathGr* MathGr*_2011 	// newly-added pre-cleaning to fix the merge! 
		rename ReadGr* ReadGr*_2011 	// newly-added pre-cleaning to fix the merge!  		 
		save "${gendatapath}Wk08_SchAchGr1to3_2011_cleaned.dta", replace // Notice I'm saving cleaned version in "5 Generated Datasets", updating name to Wk08, and adding "_cleaned" to the name 	
	
		
		use  "${rawdatapath}Wk07_SchAchGr1to3_2012.dta", clear
		drop syear *Avg	// cleaning from Q2 
		rename MathGr* MathGr*_2012 	// newly-added pre-cleaning to fix the merge! 
		rename ReadGr* ReadGr*_2012 	// newly-added pre-cleaning to fix the merge!  		 
		save "${gendatapath}Wk08_SchAchGr1to3_2012_cleaned.dta", replace // Notice I'm saving cleaned version in "5 Generated Datasets", updating name to Wk08, and adding "_cleaned" to the name 	
		
		** What did that code do? Why was this step necessary? 

		
	**4b. Try simply merging all three of your cleaned datasets 
	**		Write the code to merge the 3 cleaned datasets together. 
	**		Make 2010 the "master", then merge 2011 data to it. Then merge 2012 data to the other two.  
	
		use "${gendatapath}Wk08_SchAchGr1to3_2010_cleaned.dta", clear
		
		merge 1:1 schid using "${gendatapath}Wk08_SchAchGr1to3_2011_cleaned.dta"			
			tab _merge 	// Perfect merge! 
			drop _merge // Drop this variable once I've checked in
			
		merge 1:1 schid using "${gendatapath}Wk08_SchAchGr1to3_2012_cleaned.dta"
			tab _merge 	// Perfect merge! 
			drop _merge // Drop this variable once I've checked in					
		
		desc, short		// Yay! We got the right number of observations (200), and 19 variables!
	
	
****
* 
*	[5. Bonus: Can you write a loop to do steps 3-5?]
*
****
/*
	**Pre-cleaning, in a loop:
	
		foreach syear in 2010 2011 2012 {
			use  "${rawdatapath}Wk07_SchAchGr1to3_`syear'.dta", clear
			drop syear *Avg	
			rename *Gr* *Gr*_`syear'
			save "${gendatapath}Wk08_SchAchGr1to3`syear'_cleaned.dta", replace // Notice I'm saving cleaned version in "5 Generated Datasets", updating name to Wk08, and adding "_cleaned" to the name 				
		}	// close syear loop
	

	**Merging in a (silly) loop
	
		use "${gendatapath}Wk08_SchAchGr1to3_2010_cleaned.dta", clear
		
		foreach syear in  2011 2012 {
			merge 1:1 schid using "${gendatapath}Wk08_SchAchGr1to3_`syear'_cleaned.dta"
				tab _merge 	// Perfect merge! 
				drop _merge // Drop this variable once I've checked in
		}	// close syear loop
*/				

*******
*
*	6. Take steps to end your Stata session
*		Close your log.file 
*		Translate your log.file into a pdf.  
*		Make sure your do.file runs all the way. Make sure you can  find your log file 
*
*******	
	
	log close
	
	translate	"${logfilepath}Wk08_PracticeActivity_AnswerKey_log.smcl" ///
				"${logfilepath}Wk08_PracticeActivity_AnswerKey_log.pdf"


