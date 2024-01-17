*********************************************************************************		
/*	TITLE: 		Wk06_PracticeActivity.do								
*	PURPOSE:	Do file to go along with the 6th practice activity. 				
*	AUTHOR:		Carson Crenshaw												
*	CREATED:	2023_1003															
*	CALLS UPON:	"${rawdatapath}Wk06_ECLSK_Public_Abridged.dta"				
*	CONTENTS:	0: Set globals
* 				1: Open Data 
*				2: Activity Code
*				3: Close log file
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
		log using "${logfilepath}Wk06_PracticeActivity_log", replace 
	
*********
*
*	1: Open Data
*
*********

	use "${rawdatapath}Wk06_ECLSK_Public_Abridged.dta", clear
	

*********
*
*	2: Stata's display command 
*
*********
*2*
tab kurban
* LOCATION TYPE IN SAMPLE |
*                      FRAME |      Freq.     Percent        Cum.
*----------------------------+-----------------------------------
*               CENTRAL CITY |      2,878       40.57       40.57
*URBAN FRINGE AND LARGE TOWN |      2,801       39.48       80.05
*       SMALL TOWN AND RURAL |      1,415       19.95      100.00
*----------------------------+-----------------------------------
*                      Total |      7,094      100.00

display 40.57 + 19.95

display sqrt(132480)

*3*
global myfeelings "great about"

display in red "Currently I feel ${myfeelings} Stata!"

*4*
local acv "c1rtscor"
display in red "c1rtscor stands for C1 READING T-SCORE"
su `acv'
	return list
	display `r(mean) '
	display `r(sd) '
	display `r(min) '
	display `r(max) '
	di "The reading scores have a mean of `r(mean)', an SD of `r(sd)', a minimum value of `r(min)', and a maximum score of `r(max)'"

local acv "c1mtscor"
display in red "c1mtscor stands for C1 MATH T-SCORE"
su `acv'
	return list
	di "The reading scores have a mean of `r(mean)', an SD of `r(sd)', a minimum value of `r(min)', and a maximum score of `r(max)'"

*Weekly Quiz*
*ssc install isvar
*help isvar
isvar c1*
	return list
	di "The variables that begin with 'cl' are: " "`r(varlist)'"



*********
*	3: Close log file (learn about this in Week 03)
*********	
	
	log close
	
	translate "${logfilepath}Wk06_PracticeActivity_log.smcl" "${logfilepath}Wk06_PracticeActivity_log.pdf"
