*********************************************************************************		
/*	TITLE: 		Wk09b_ContentSlideDeck.do								
*	PURPOSE:	Learn about graph twoway (mostly scatterplots) 		
*	AUTHOR:		Allison Atteberry												
*	CREATED:	2022_0119													
*	UPDATED: 	YYYY_MMDD		
*	CALLS UPON:	sysuse uslifeexp2.dta, clear
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
		log using "${logfilepath}Wk09b_ContentSlideDeck_log", replace 
	
*********
*	1: Open Data
*********

	sysuse uslifeexp2.dta, clear
	
	notes _dta

*********
*
*	Scatterplots - a common type of twoway graph
*
*********

	*help graph twoway
	*twoway is a family of plots, all of which fit on numeric y and x scales.
	
	graph twoway (scatter le year)

//  "twoway graphs: Scatterplots"

	graph twoway (scatter le year)
	
	graph twoway ///
		(scatter le year) ///
		, ///
		title("Life Expectancy at Birth, Over Time (U.S.)") ///
		xsize(10) ysize(5) ///			
		xtitle("Year of Birth") ///
		ytitle("Life Expectancy") ///
		xlabel(1900(2)1940, angle(30)) ///				
		ylabel(35(5)75, angle(0)) 
		
	**Example from the scatter help file (not in slide deck)
/*	
		graph twoway ///
			(scatter le year) ///
			, ///
			title("Scatterplot") ///
			subtitle("Life expectancy at birth, U.S.") ///
			note("1") ///
			caption("Source: National Vital Statistics Report, Vol. 50 No. 6") ///
			xsize(10) ysize(5) ///			
			xlabel(1900(5)1940) ///				
			ylabel(35(5)75, angle(0)) ///
			scheme(economist)
*/
			
	**Quick Sidenote on Graph-Making in Stata:
	**Add a name to your figure window
	
		graph twoway ///
			(scatter le year) ///
			, ///
			name(scatter1, replace)

	
	**"It's possible to overlay several twoway relationships in the same graph."

		**Simplest syntax 
				
			graph twoway ///
				(scatter le year) ///
				(lfit    le year) ///
				, ///
				name(lfit1, replace)

		**And now with ALL the formatting 
		
			graph twoway ///
				(scatter le year) ///
				(lfit    le year) ///		// < -- Only added this line of code 
				, ///
				title("Life Expectancy at Birth, Over Time (U.S.)") ///
				xsize(10) ysize(5) ///			
				xtitle("Year of Birth") ///
				ytitle("Life Expectancy") ///
				xlabel(1900(2)1940, angle(30)) ///				
				ylabel(35(5)75, angle(0))  ///
				name(lfit2, replace)

	**Let's ALSO add a quadratic "best fit" line.

		**Simplest syntax 
	
			graph twoway ///
				(scatter le year) ///
				(lfit    le year) ///
				(qfit    le year) ///
				, ///
				name(qfit1, replace)  

		**And now with ALL the formatting 
		
			graph twoway ///
				(scatter le year) ///
				(lfit    le year) ///		
				(qfit    le year) ///		// < -- Only added this line of code 
				, ///
				title("Life Expectancy at Birth, Over Time (U.S.)") ///
				xsize(10) ysize(5) ///			
				xtitle("Year of Birth") ///
				ytitle("Life Expectancy") ///
				xlabel(1900(2)1940, angle(30)) ///				
				ylabel(35(5)75, angle(0)) ///  
				name(qfit2, replace) 		
	
	**graph twoway
	**Add options to plottype (colors of lfit and qfit)
	
		graph twoway ///
		   (scatter le year) ///
		   (lfit    le year, lcolor(pink)) ///
		   (qfit    le year) ///  
		   , ///
		   name(qfit_pink, replace)  
			   
		graph twoway ///
			(scatter le year) ///
			(lfit    le year, lcolor(orange)) ///
			(qfit    le year, lcolor(green)) ///  
		   , ///
		   name(qfit_lcolors, replace)  

	
	**Final Version of Our Graph Twoway

	graph twoway ///
		(scatter le year, mcolor(navy) msymbol(X) msize(*2)) ///
		(lfit    le year, lcolor(green)			 ) ///		
		(qfit    le year, lcolor(orange)		 ) ///
		, ///
		title("Life Expectancy at Birth, Over Time (U.S.)") ///
		xsize(10) ysize(5) 			///			
		xtitle("Year of Birth") 	///
		ytitle("Life Expectancy") 	///
		xlabel(1900(5)1940) 		///				
		ylabel(35(5)75, angle(0)) 	///
		legend(ring(0) position(4) col(1) order(1 "L.E. in Yr" 2 "Linear Fit" 3 "Quadratic Fit")) ///
		name(final, replace)

	
	**Types of graphs: (vertical) Bar graphs
	**Hidden Slide (just for fun)
	
	sysuse citytemp, clear

	graph bar (mean) tempjuly tempjan, over(region) ///
		bargap(-30) ///
		legend( label(1 "July") label(2 "January") ) ///
		ytitle("Degrees Fahrenheit") ///
		title("Average July and January temperatures") ///
		subtitle("by regions of the United States") ///
		note("Source: U.S. Census Bureau, U.S. Dept. of Commerce") ///
		name(extrabar, replace)

*********
*	3: Close log file (learn about this in Week 03)
*********	
	
	log close
	
	translate "${logfilepath}Wk09b_ContentSlideDeck_log.smcl" "${logfilepath}Wk09b_ContentSlideDeck_log.pdf"
