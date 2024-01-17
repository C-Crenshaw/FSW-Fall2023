*********************************************************************************		
/*	TITLE: 		PSET3_Crenshaw.do								
*	PURPOSE:	Code written for the completion of the third and final FSW Problem Set. 			
*	AUTHOR:		Carson Crenshaw												
*	CREATED:	2023_1027															
*	CALLS UPON:	"${rawdatapath}FSW_Arts2013.dta"
*				"${rawdatapath}FSW_Arts2015.dta"				
*	CONTENTS:	1: START A .DO FILE USING BEST PRACTICES
*				2: APPEND
*				3: IMPROVE THE CODING OF YOUR VARIABLES FOR ANALYSIS
*				4: CROSS-YEAR ANALYSES
*				5: BONUS
*				6: MERGING
*				7: REFLECTIONS AND FINAL UPLOADS
*/
*********************************************************************************

	clear all
	set more off
	pause on

******
*
*	1. START A .DO FILE USING BEST PRACTICES 
*
******

	**Header (above) and Globals (below) for the classpath and other class folders
	
		glob classpath		"/Users/carsoncrenshaw/Library/CloudStorage/OneDrive-UniversityofVirginia/LPPP_6001/"
		glob rawdatapath	"${classpath}2 Raw Data/"
		glob syntaxpath		"${classpath}3 Syntax/"
		glob gendatapath	"${classpath}4 Generated Datasets/"
		glob logfilepath	"${classpath}5 Log Files/"
		glob tabsfigspath	"${classpath}6 Tables and Figures/"
		cd 	"${classpath}"  

	**Start the log file in the "5 Log Files" folder, closure of the log file and translation to a pdf can be found at the end of the document
	
		capture log close
		log using "${logfilepath}PSET3_Crenshaw_log", replace 
	
	**Open 2013 data from "2 Raw Data" folder
	
		use "${rawdatapath}FSW_Arts2013.dta", clear
		
	**A few lines of code to "get to know" the content and structure of this dataset
		
		// browse // most variables seem to be coded as either a 1 or a 2 (no value labels)
		codebook, compact
		describe, short // 9,340 observations, 13 variables
		mdesc // need to be careful of missing observations in the dataset, all variables have missing data except "caseid" and "perform_r"
		
	**Open 2015 data from "2 Raw Data" folder
	
		use "${rawdatapath}FSW_Arts2015.dta", clear
		
	**A few lines of code to "get to know" the content and structure of this dataset
		
		// browse // In addition to being coded as 1 or 2, the observation values have labels (Yes/No)
		codebook, compact
		describe, short // 9,110 observations, 13 variables -- Seems to have the same variables as the 2013 dataset (names are the same)
		mdesc // need to be careful of missing observations in the dataset, all variables have missing data except "caseid" and "perform_r"
		codebook artapp_r // demonstrates that this dataset includes value labels (1 means Yes, 2 means No)
		
** PART1, Q1. 
*In your own words, how successful were you with PART 1? What parts did you struggle with the most, if any? How has your understanding of organizing files for analysis using Stata developed since you turned in PSET1? (1pt). [Short answer in canvas]
di in red "At the conclusion of Part 1 of this problem set, I am confident that I have mastered the development and utilization of a proper do. file document that follows the proper organization structure. To this point, the most complex aspect of establishing my document is simply ensuring that my paths are updated and that I am using the correct naming conventions. Small details are easily overlooked at any point --regardless of personal understanding and proficiency-- and I consistently work to ensure that I am setting up myself for success by carefully working through each line of code. I will say, however, that my capacity to successfully create do. files and my understanding of this process has exponentially improved since PSET1. I am confident that I will be able to carry these skills forward, and with the repetitions of practice I will not soon forget what I have learned in FSW."


******
*
*	2. APPEND
*
******		

**PART2, Q1.
*Imagine you are appending these two datasets together (do not do so yet). Based on what you learned from PART 1, state how many rows (observations) and how many columns (variables) the successfully-appended dataset should have. 
di in red "I expect that the appended dataset will have 13 variables and 18,450 observations."

**PART2, Q2.
	// 2013 data
	use "${rawdatapath}FSW_Arts2013.dta", clear
	cap drop year
	generate year = 2013
	label variab year "YEAR IN WHICH DATA WAS COLLECTED"
	save "${gendatapath}FSW_Arts2013_revised.dta", replace
	
	// 2015 data
	use "${rawdatapath}FSW_Arts2015.dta", clear
	cap drop year
	generate year = 2015
	label variab year "YEAR IN WHICH DATA WAS COLLECTED"
	save "${gendatapath}FSW_Arts2015_revised.dta", replace
	
	// Append revised data
	use "${gendatapath}FSW_Arts2013_revised.dta", clear //master data, 2013
	append using "${gendatapath}FSW_Arts2015_revised.dta" //used data, 2015
	save "${gendatapath}FSW_ArtsAppended.dta", replace 
	describe, short // 18,450 observations, 15 variables
di in red "This FSW_ArtsAppended.dta dataset has 15 variables and 18,450 observations. "
	
**PART2, Q3. 
	// 2013 data
	use "${rawdatapath}FSW_Arts2013.dta", clear
	cap drop year
	generate year = 2013
	label variab year "YEAR IN WHICH DATA WAS COLLECTED"
	save "${gendatapath}FSW_Arts2013_revised.dta", replace
	
	// 2015 data
	use "${rawdatapath}FSW_Arts2015.dta", clear
	cap drop year
	generate year = 2015
	label variab year "YEAR IN WHICH DATA WAS COLLECTED"
	rename musuem_r museum_r // problem with the original dataset was that museum was originally spelled wrong
	save "${gendatapath}FSW_Arts2015_revised.dta", replace
	
	// Append revised data
	use "${gendatapath}FSW_Arts2013_revised.dta", clear //master data, 2013
	append using "${gendatapath}FSW_Arts2015_revised.dta" //used data, 2015
	save "${gendatapath}FSW_ArtsAppended.dta", replace 
	describe, short // 18,450 observations, 14 variables.
**Did you need to make changes to your code to make the append work? If yes, please explain how you discover the problem and how you solved it. [Yes/No and Rationale in Canvas]
di in red "Yes. There is a problem with the original append: We would expect there to be 14 variables (after the addition of the year variable/original dataset indicator), but there are 15. When investigating the problem through the browse function, it becomes clear that the two datasets use different naming conventions for the 'museum_r' variable. Within the 2015 dataset, the variable name is accidentally misspelled. In order to solve this problem, one must rename the variable in the 2015 dataset to match the 2013 dataset."

**PART2, Q4
*Explain why it was important to create a new variable called year prior to appending the datasets. [Short answer in Canvas]
di in red "It is important to create a new variable called 'year' prior to appending the datasets in order to easily identify where the data originates from. By including the additional (incorrect, repeated) variable, it was easier to solve the appending problem because it was easily understood that the additional variable came from the 2015 data. Therefore, a user can quickly return to the used data in order to match this information to the master dataset. If the creation of the variable had not occurred, this important information would be missing from the dataset and errors would take more time to correct."

**PART2, Q5
*Write code to order the variables so that year comes after caseid. Copy/paste that line of code here. [Short answer in Canvas]
	// if the appended dataset is already being used, no need to define the dataset again
	order caseid year
	
	// just in case, however, one can re-open the appended dataset and run the code
	// use "${gendatapath}FSW_ArtsAppended.dta", clear
	// order caseid year


******
*
*	3. IMPROVE THE CODING OF YOUR VARIABLES FOR ANALYSIS
*
******			
	
**PART3, Q1. 
*Copy/paste the output from your summarize command from the Results Window into Canvas (be sure to put it in Courier New font). [Short answer in Canvas]
	recode *_r (1=1) (2=0)	// change "no" observations to 0 instead of 2
	cap lab drop r_vallab 
	label define r_vallab 1 "1= yes" 0 "0= no" 
	label values *_r r_vallab
	summarize *_r
	
**PART3, Q2. 
*According to the tab, what percentage of respondents visited any buildings/ neighborhoods/ parks/ monuments in the last 12 months? Compare that percentage (from tab) to the mean of that variable (from summarize). What do you notice about the mean of a binary variable coded 0/1? [Short answer in Canvas]
	tab historic_r
di in red "Without the missing values being included in the tab function, 27.15% of respondents visited any buildings/neighborhoods/parks/monuments in the last 12 months. The mean of his variable, according to the summarize code from part 1, is approximately 27.15 percent. From these numbers, I notice that the mean of a binary variable coded 0/1 is equal to the proportion of observations in the 1 group (not accounting for missing variables). Testing other variables, this conclusion is consistent across all the binary variables."


******
*
*	4. CROSS-YEAR ANALYSES
*
******	

**PART4, Q1. 
*What percentage of the respondents (reminder: exclude missing values) indicated they went to an art exhibit in the past 12 months? [museum_r] 
	tab museum_r
di in red "I find that 20.17% of the respondents went to an art exhibit in the past 12 months (round to two decimals)."

**PART4, Q2.
*What percentage of people who indicated they attended an art exhibit in the past year [museum_r] indicate they have read (a novel, short stories, poetry or plays) in the past year [reading_r]? What percentage of people who indicate they did not attend an art exhibit in the past year [museum_r] indicate they have read a novel, short stories, poetry or plays in the past year [reading_r] ? 
	tab museum_r reading_r, row
di in red "Of those who DID attend an art exhibit in the past year, 81.57% indicated they'd read in the past year. But of those who did NOT attend an art exhibit in the past year, only 37.15% indicated they'd read in the past year (round to 2 decimals)."

**PART4, Q3. 
*What are the top 3 most common forms of arts participation in this dataset? [Short answer in Canvas]	
	summarize *_r
di in red "The three most common forms of arts participation in this dataset are attending a live music/theatre/dance performance (31.70%)('perform_r'), going out to see a movie/film (56.59%)('movies_r'), and reading any novels/short stories/plays/poetry (46.13%)('reading_r'). Taken from the summary statistics of all arts participation activities, these have the highest means. The highest means are also an indication of their proportion of observations who did attend (1) the activity, excluding missing values."
	

******
*
*	5. BONUS
*
******	

**Skipped. 	
	
	
******
*
*	6. MERGING
*
******	

**PART6, Q1. 
*Question: If you were able to conduct a successful merge of these two datasets, how many variables would you expect the newly-merged dataset to have? Explain your answer. [Short answer in Canvas]
di in red "If a successful merge were conducted between the two datasets, I would expect the newly-merged dataset to have at least different variables for each set of performing arts variables. There should be 1 caseid variable between the two datasets, a combination of 24 performing arts variables (12 for each of the two datasets), the year variable may still be included (if not dropped because it is largely unnecessary now), and the newly created _merge variable detailing where the information originated. In total, there should be about 27 variables if done correctly. However, because the datasets do not contain uniquely defined variables to differentiate between 2013 and 2015, there may only be 15 variables. Because the two sets of data have identical variable names, the only new variables to be merged together will be the _merge variable that appears in order to indicate where the data is being pulled from."

**PART6, Q2. 
	use "${gendatapath}FSW_Arts2013_revised.dta", clear
	merge 1:1 caseid using ///
		"${gendatapath}FSW_Arts2015_revised.dta"
	tab _merge 
*How many caseids (aka observations) are in the new dataset? How many and what percentage of the total observations were in both datasets? 
di in red "There are 17,947 observations in the newly-merged dataset. Of those, only 503 caseid's were found in both datasets. That is 2.80% of the observations in the newly-merged dataset were matched (round to 2 decimals)."

**PART6, Q3. 
*How many variables are in the newly-merged dataset? Explain how that compares to the number of variables you'd anticipated a successfully-merged dataset to have in PART6, Q1 above. [Short answer in Canvas]
	describe, short
di in red "There are 15 variables in the newly-merged dataset. This is smaller than the number of variables predicted in question 1 above (27) and smaller than what one would expect if the merge was correctly conducted. As aforementioned in question 1, there are only 15 variables because the two sets of data have identical variable names. As a result, no new variables are merged into the original dataset: the only new variables to be merged together were the  _merge variable that appears in order to indicate where the data is being pulled from. In other words, this data holds a potential problem: the dataset did not get wider as there is no differentiation between the 2013 and 2015 variables."

**PART6, Q4. [BONUS, up to 2 extra points]
*This merge did not seem very successful in a few different ways, but for this question, just focus on the fact that very few cases were matched (see Part6, Q2). In your own words, explain why it made more sense in this case to append the two files together rather than merge them. [Short answer in Canvas]
di in red "Very few cases from both datasets were matched together because of the nature of the data collection. The Annual Arts Basic Survey is a repeated, cross-sectional survey sponsored by the National Endowment for the Arts in order to track public participation in the arts. Annually a different nationally-representative sample of adults is asked about their participation in the arts, therefore it is very rare that the same respondent would be included in two different years of the data collection. Understanding the nature of the data and the initial results from the merge, it is understandable to conclude that append would be better than a merge because there are so few cases that were interviewed in both 2013 and 2015. Merge involves the comparison of data for individuals over different variables/over time, while append simply adds more observations to the data. Given these constraints, append makes more sense in this context."


*********
*
*	7: REFLECTIONS AND FINAL UPLOADS 
*
*********
	
**PART7, Q3. [BONUS, 3 extra points]
*Bonus: What was the most memorable arts experience you've had in the past 12 months (e.g. movie, live music, theater, art exhibit, book reading, etc.) and why? [Short answer]
di in red "The most memorable arts experience I have had in the last 12 months was going to see Luke Combs in concert this past July. I am not the biggest country fan, and it is far from my favorite genre, but the concert experience was something I will never forget. Because the concert was in my hometown (Charlotte, NC), I was fortunate enough to be able to see him perform with my little brother. Not only was the concert fantastic, but I will always remember being able to sing along with him in the rain. I don't think I have ever had that much fun at a concert before in my life, and I am glad I got to share that with him since I don't see him a lot anymore."
	
**PART7, Q1. Upload .do file

**PART7, Q2. Upload log. file

	log close
	
	translate "${logfilepath}PSET3_Crenshaw_log.smcl" "${logfilepath}PSET3_Crenshaw_log.pdf", replace

	
	
	
	
	
	
	
		
		
		
		
		
	