*********************************************************************************		
/*	TITLE: 		Wk06_PracticeActivity_AnswerKey.do								
*	PURPOSE:	Answer key for the W6 Practice Activity	
*				This practice question provides an opportunity to try out the material presented in this week's videos 
*				and to combine the newly presented skills with material already presented. The practice activities are not submitted or graded (they are just for practice!). 
*				However, it is very important that you do them. Each week the new material builds off of what we learned the prior week. It's important to stay on top of these. 
*				Feel free to work on them individually or with other students. Although an answer key is provided, I strongly encourage you to fully attempt the practice problems before reviewing the answer key.
*				Goal: This activity provides practice generating loops!			
*	AUTHOR:		Allison Atteberry												
*	CREATED:	2022_0119													
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
	
*		glob classpath		"C:/Users/aa2pn/Dropbox/Teaching/UVA Classes/LPPP 6001"	
		glob classpath		"C:/Users/alat8407/Dropbox/Teaching/UVA Classes/LPPP 6001"	// Comment out this line when you've added yours below
*		glob classpath		"" // <-- You'll put your own file path to the LPPP 6001 folder here, and uncomment it out (remove the asterisk at the start)	
		glob rawdatapath	"${classpath}/2 Raw Data/"
		glob syntaxpath		"${classpath}/3 Syntax/"
		glob gendatapath	"${classpath}/4 Generated Datasets/"
		glob logfilepath	"${classpath}/5 Log Files/"
		glob tabsfigspath	"${classpath}/6 Tables and Figures/"
		cd 	"${classpath}" 

********
*
*	1. Create a do.file, for this practice activity:
*		1.1. Include a header.
*		1.2. Include a command in your do.file to open the file "Wk06_ECLSK_Public_Abridged"
*		1.3. Write a command in your do.file to begin a log file
*
********
	
	**Start the log file (something we'll learn about later in class)
	
		capture log close
		log using "${logfilepath}Wk06_PracticeActivity_AnswerKey_log", replace 
	
	**Open Data

		use "${rawdatapath}Wk06_ECLSK_Public_Abridged.dta", clear


********
*
*	2. Learning to loop!
*
********

	**	2.1. The variable p1readbo has missing values codes as -9 and -8
	**	2.2. Recode the variable p1readbo so that -9 is coded as .a and -8 as .b. 
	**		 (Doing this makes them into missing values, but still allows you to distinguish between types of missing data, e.g. refused to answer, not applicable, etc.)
	
		recode 	 p1readbo (-9=.a) (-8=.b)

	**	2.3. Generate a new indicator variable called p1readbo_ed set to 1 if the parent reports they read every day, and 0 otherwise.
		
		cap drop p1readbo_ed
		generate p1readbo_ed=1 if p1readbo==4
		replace  p1readbo_ed=0 if p1readbo <4
	
	**	2.4. Now, use the foreach command to do this same basic task for a set of variables that are all coded the same. They are: p1tellst p1singso p1helpar p1chores p1games p1nature p1build p1sport (note they are all right next to each other so you can refer to them as p1tellst-p1sport).
	**	2.4.1. Recode the variables so that -9 is coded as .a; -8 as .b. and; -7 as .c
	**	2.4.2. For each of the variables generate a new indicator variable set to 1 if the parent does that activity every day, and 0 otherwise. The name of the variable should be the old name with "_ed" tacked on to the end (e.g. p1tellst_ed)
	
		foreach var of varlist p1tellst - p1sport {
			
			recode 	 `var' (-9=.a) (-8=.b) (-7=.c)
			
			cap drop `var'_ed 
			generate `var'_ed=1 if `var'==4
			replace  `var'_ed=0 if `var'< 4
		
		}	// close var of varlist loop	
	
********
*
*	3. Optional: Using a foreach command write a loop that recodes nearly all the variables in this dataset: 
*		dobmm-t1rscoyy such that (-9=.a) (-8=.b) (-7=.c) (-2=.d) (-1=.e).
*
********

	foreach var of varlist dobmm-t1rscoyy {
		recode `var' (-9=.a) (-8=.b) (-7=.c) (-2=.d) (-1=.e)
	}


*********
*
*	4. Close your log.file
*	5. Translate your log.file into a pdf.
*	6. Make sure your do.file runs all the way. Make sure you can find your log file
*
*********	
	
	log close
	
	translate "${logfilepath}Wk06_PracticeActivity_AnswerKey_log.smcl" "${logfilepath}Wk06_PracticeActivity_AnswerKey_log.pdf"
