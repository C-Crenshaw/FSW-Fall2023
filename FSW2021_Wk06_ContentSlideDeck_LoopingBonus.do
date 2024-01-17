*********************************************************************************		
/*	TITLE: 		Wk06_ContentSlideDeck_Looping_Bonus.do								
*	PURPOSE:	Code written during class in Wk 06 for bonus materials on Looping 					
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

	**Start the log file (something we'll learn about later in class)
	
		capture log close
		log using "${logfilepath}Wk06_ContentSlideDeck_Looping_Bonus_log", replace 
	
*********
*	1: Open Data
*********

	use "${rawdatapath}Wk06_ECLSK_Public_Abridged.dta", clear

	
************************************
* Repeating commands
************************************

	**  "We already know a few ways to do this... 
	
		su t1cmpsen
		su t1story
		su t1letter
		su t1rhyme 
		su t1prdct
		su t1reads
		su t1write
		su t1print
		su t1comptr
		su t1difliv 
		su t1difjob
		su t1obsrv
		su t1expln
		su t1clssfy
		su t1sorts
		su t1order 
		su t1relat
		su t1solve
		su t1graph
		su t1measu
		su t1strat
		describe t1cmpsen
		describe t1story
		describe t1letter
		describe t1rhyme 
		describe t1prdct
		describe t1reads
		describe t1write
		describe t1print
		describe t1comptr
		describe t1difliv 
		describe t1difjob
		describe t1obsrv
		describe t1expln
		describe t1clssfy
		describe t1sorts
		describe t1order 
		describe t1relat
		describe t1solve
		describe t1graph
		describe t1measu
		describe t1strat

	** "Better.."

		su t1cmpsen t1story t1letter t1rhyme t1prdct t1reads t1write t1print ///
		 t1comptr t1difliv t1difjob t1obsrv t1expln t1clssfy t1sorts t1order ///
		 t1relat t1solve t1graph t1measu t1strat

		describe t1cmpsen t1story t1letter t1rhyme t1prdct t1reads t1write t1print t1comptr ///
			t1difliv t1difjob t1obsrv t1expln t1clssfy t1sorts t1order t1relat t1solve ///
			t1graph t1measu t1strat

	** "Even Better.."
			
		# delimit 	
		su t1cmpsen t1story t1letter 
			t1rhyme t1prdct t1reads t1write t1print t1comptr 
			t1difliv t1difjob t1obsrv t1expln 
			t1clssfy t1sorts t1order 
			t1relat t1solve 
			t1graph t1measu t1strat ;

		describe t1cmpsen t1story t1letter t1rhyme t1prdct t1reads t1write t1print t1comptr 
			t1difliv t1difjob t1obsrv t1expln t1clssfy t1sorts t1order t1relat t1solve 
			t1graph t1measu t1strat ;


		# delimit cr
			
	** "EVEN better...!"

		summarize t1cmpsen-t1strat
		describe  t1cmpsen-t1strat
		
	**Using globals! 
	
		global listofvars "t1cmpsen t1story t1letter t1rhyme t1prdct t1reads t1write t1print t1comptr t1difliv t1difjob t1obsrv t1expln t1clssfy t1sorts t1order t1relat t1solve t1graph t1measu t1strat"
		summarize ${listofvars}
		describe  ${listofvars}
		
		
** Recode

	recode t1cmpsen - t1strat (-9 =.a)  (7 =.b)
	
** Using loops

	foreach var of varlist t1cmpsen - t1obsrv {
		recode `var' (-9=.a) (7=.b)
	}

** A longer loop:

	foreach var of varlist t1cmpsen - t1strat {
		recode   `var' (-9 =.a)  (7 =.b)
		generate `var'_prof= 1 if `var'==5
		replace  `var'_prof=0 if `var'!=5 & `var'!=.
	}

*********
*	3: Close log file (learn about this in Week 03)
*********	
	
	log close
	
	translate "${logfilepath}Wk06_ContentSlideDeck_Looping_Bonus_log.smcl" "${logfilepath}Wk06_ContentSlideDeck_Looping_Bonus_log.pdf"
