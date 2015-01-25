-----------------------------------------------------------------------------------------------------------------------------------
README.md
-----------------------------------------------------------------------------------------------------------------------------------

FILES SUBMITED:
	- (1) run_analysis.R - produces tidy dataset
	- (2) CODEBOOK.md - contains variable description
	- (3) README.md - provides basic instructions

	
SET UP INSTRUCTIONS:
	- 1. Download and extract data in working directory. 
	- 2. Rename the datasets folder to "datasets". 
	- 3. Place the file in the working directory.
	- 4. Execute the run_analysis.R code. 
	- 5. The result will produce "tidy_dataset.txt" file saved in the working directory where the run_analysis.R is located. 
	

 IMPORTANT NOTE! - I couldn't not figure out how to make this file readable in GITHUB in normal view. I always get some odd data layout. 
					The file can be read in raw view in github.com (when you click on the file you will see a button that says or raw). 
					Here is the direct link to the raw file:
					https://raw.githubusercontent.com/sinebe/gettingDataProject/master/CODEBOOK.md
					
	On my machine is this is the WD set-up:
		setwd("X:/WD/Documents/Projects/Education/DataScience/DataScience/3_Getting_and_Cleaning_Data/Assignment")


	The correctly execute the code the folder structure should look something like this: 
	
		Working_Directory
		|-datasets
		| | - UCI HAR Dataset
		| | | - test
		| | | - train
		| | | - activity_labels.txt
		| | | - features.txt
		| | | - features-info.txt
		| | | - README.txt
		| - run_analysis.R
		| - README.md (optional - not needed for the code)
		| - CODEBOOK.md (optional - not needed for the code)

-----------------------------------------------------------------------------------------------------------------------------------
CODEBOOK.md instructions:
-----------------------------------------------------------------------------------------------------------------------------------
 IMPORTANT NOTE! - I couldn't not figure out how to make this file readable in GITHUB in normal view. I always get some odd data layout. 
					The file can be read in raw view in github.com (when you click on the file you will see a button that says or raw). 
					Here is the direct link to the raw file:
					https://raw.githubusercontent.com/sinebe/gettingDataProject/master/CODEBOOK.md

					
	- This files contains data variable names, mapping to original variables, and short description of each variable used.
	- File structure is as follows:
			Variable number -> New Variable Name -> Original Variable Index -> Original Variable Name -> Short Description.
	- Using this format user can always track back to the original (features.txt) file in case more details is needed not provided in code book.  
	
	New Variable names are created by maintaining original naming methodology and then substituting illegal characters. The following
	code was used to achieve this:
	
		cleanedcols = gsub("(","", colNames, fixed = TRUE)
		cleanedcols = gsub(")","", cleanedcols, fixed = TRUE)
		cleanedcols = gsub("-","", cleanedcols, fixed = TRUE)
		cleanedcols = gsub(",",".", cleanedcols, fixed = TRUE)
		cleanedcols = gsub("mean","Mean", cleanedcols, fixed = TRUE)
		cleanedcols = gsub("std","Std", cleanedcols, fixed = TRUE)
		
		where colNames is the vector containing original variable names.
		Used camelCase for readability.
	
	
	
-----------------------------------------------------------------------------------------------------------------------------------
run_analysis.R instructions:
-----------------------------------------------------------------------------------------------------------------------------------	

	Package dependencies:
		plyr
		dplyr
		data.table
		
	Code is split in 5 section where each section answers assignment question in order:
	
	----------------------
	Section 1:
	----------------------
	
	Reads the file from three tables into separate variables and uses cbind() to merge columns. This step was performed. 
	for both, training subjects and test subjects.
	Another variable - dataSource - was added for validation. This variable is not used in tidy data set. 
	Variables are combined using rbind().

	----------------------
	Section 2:
	----------------------	

	-The assignment asks to include only fields that represent  standard deviation or mean measures.
	-This steps loads data from features.txt file into a vector and perform the search on its values. 
	-The code uses grep() function to find index of standard deviation and/mean. 
	-Return index (combined for mean and std) allow to pull in only columns that correspond to that index.
		subCombinedDataSet = combinedDataset[, c(1:3,meanStdIndexAdj)]
	-86 variables with std and mean were selected.

	----------------------
	Section 3:
	----------------------	

	-Section 3 loads the activity table and joins it with the main dataset to bring in the activity text values.
	-Code also reorders columns to have activity test at the 4th position.
	
	----------------------
	Section 4:
	----------------------	

	I used method such that the original names  were maintained and eliminate illegal characters: 
		-delete dashed
		-delete parenthesis
		-use camelCase to improve readability
		-see codebook for detailed description of variables.
		
	----------------------
	Section 5:
	----------------------		
	
	Complete the assignment by using dplyr summary_each() function. 