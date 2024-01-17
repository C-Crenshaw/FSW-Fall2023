*********************************************************************************		
/*	TITLE: 		Wk09_ContentSlideDeck.do								
*	PURPOSE:	 		
*	AUTHOR:		Allison Atteberry												
*	CREATED:	2022_0119													
*	UPDATED: 	YYYY_MMDD		
*	CALLS UPON:	"${rawdatapath}Wk09_MiniELSdataset.dta"
*	PRODUCES: 	Figures:	NO
*				Tables: 	No
*				Datasets: 	NO.					
*	CONTENTS:	0: Set globals
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
		log using "${logfilepath}Wk09a_ContentSlideDeck_log", replace 
	
*********
*	1: Open Data
*********

	use "${rawdatapath}Wk09_MiniELSdataset.dta", clear

***********
*
* GRAPH PIE
*
***********

// "Types of graphs: Pie charts"

	help graph pie

	// graph pie draws pie charts. graph pie has three modes of operation. 
	// [The first… The second… 
	// The third mode of operation corresponds to the specification of over() with no variables. Pie slices are drawn for each value of variable region; the slices correspond to the number of observations in each group.


	graph pie , over(sturace)
	
	graph pie , over(sturace) ///
		title("Share of Students in Dataset of Each Ethnoracial Category")
		
	**Bonus Formatting:  
	
	graph pie , over(sturace) ///
		title("Share of Students in Dataset of Each Ethnoracial Category" , size(6.5)) ///
		legend( ring(0) position(3) col(1) ) ///	// <-- Move the Legend
		xsize(10) ///	// <-- change the width of the figure, in inches
		ysize(5)		// <-- change the height of the figure, in inches
	
	
***********
*
* HISTOGRAM
*
***********

	// Which of the variables in our dataset are continuous?
	browse
	codebook, compact


	help histogram
	/*histogram draws histograms of varname, which is assumed to be 
	the name of a continuous variable unless the discrete option is specified.
	*/

	** "Types of graphs: Histogram
	
	histogram testpctcorrect_mth , frequency


	hist testpctcorrect_mth , ///
		frequency /// 		
		title("Distribution of Math Test Scores") ///
		xsize(10) ysize(5) 	// <-- change the height of the figure, in inches

		
	hist testpctcorrect_mth , ///
		frequency /// 		
		title("Distribution of Math Test Scores") ///
		xsize(10) ysize(5) 	///
		start(20) width(5)
		

	hist testpctcorrect_mth , ///
		frequency /// 		
		title("Distribution of Math Test Scores") ///
		xsize(10) ysize(5) ///			// <-- change the height of the figure, in inches
		start(20) /// 					// <-- Controls value where first bar starts
		width(5)  ///					// <-- Controls width of each bar
		addlabel ///					// <-- Adds frequency labels to tops of bars
		xlabel( 20(  5) 100 ) ///		// <-- Labels the x-axis starting at 20, in increments of 5, up to 100	
		ylabel(  0(250)2000 , angle(0)) ///		// <-- Labels the y-axis starting at 0, in increments of 250, up to 2000
		xtitle("The Percentage of Math Questions Answered Correctly") ///
		ytitle("Number of Students with Given Math Scores") 



*********
*	3: Close log file (learn about this in Week 03)
*********	
	
	log close
	
	translate "${logfilepath}Wk09a_ContentSlideDeck_log.smcl" "${logfilepath}Wk09a_ContentSlideDeck_log.pdf"
