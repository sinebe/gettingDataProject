

library(plyr)
library(dplyr)
library(data.table)

setwd("X:/WD/Documents/Projects/Education/DataScience/DataScience/3_Getting_and_Cleaning_Data/Assignment")

## if need to download file uncomment and download. 

  ##fileName = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    ##download.file(fileName, destfile = "datasets.zip")

#################
##  SECTION 1  ##
#################


  ##  TRAINING DATA SET

trainingSet <- read.table("datasets/UCI HAR Dataset/train/X_train.txt")
trainingActivityCode <- read.table("datasets/UCI HAR Dataset/train/y_train.txt")
trainingSubject <- read.table("datasets/UCI HAR Dataset/train/subject_train.txt")
trainingSubject$Source = "training" 
trainingDataSet <- cbind(trainingSubject, trainingActivityCode, trainingSet)


  ##  TEST DATA SET

testSet <- read.table("datasets/UCI HAR Dataset/test/X_test.txt")
testActivityCode <- read.table("datasets/UCI HAR Dataset/test/y_test.txt")
testSubject <- read.table("datasets/UCI HAR Dataset/test/subject_test.txt")
testSubject$Source = "test"
testDataSet <- cbind(testSubject, testActivityCode, testSet)


  ## COMBINING DATA

combinedDataset = rbind(trainingDataSet, testDataSet)

  ##test whether rbind worked as expected. Uncomment the code if needed. 

  #nrow(combinedDataset)
  #nrow(trainingDataSet) + nrow(testDataSet) #should be the same as previous
  #sort(unique(combinedDataset$V1)) #expected 30


#################
##  SECTION 2  ##
#################


variables <- read.table("datasets/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
variables <- variables[,2]


  #RETURNS INDEX OF COLUMNS THAT ARE STD OR MEAN
meanColumnIndex <- grep("mean", variables, ignore.case = TRUE)
stdColumnIndex <- grep("std", variables, ignore.case = TRUE)
meanStdIndex <- sort(c(meanColumnIndex,stdColumnIndex))
meanStdIndexAdj <- meanStdIndex + 3 #add three columns to the index 

  #EXTRACT MEAN STANDARD DEVIATION COLUMNS FROM THE DATASET
subCombinedDataSet = combinedDataset[, c(1:3,meanStdIndexAdj)]

  #CHECK
#data.frame (names(subCombinedDataSet)) # list (using data frame) of all mean and standard deviation variables



#################
##  SECTION 3  ##
#################


activityDesc <- read.table("datasets/UCI HAR Dataset/activity_labels.txt")
colnames(activityDesc) = c("V1.1", "activityDesc") # set joining column to V1.1 

subCombinedDataSetActivity <-join(x = subCombinedDataSet, y = activityDesc, by =  "V1.1")
subCombinedDataSetActivity <- subCombinedDataSetActivity [,c(1:3,90,4:89)] #variable re-ordering


 #CHECK
#View(data.frame (names(subCombinedDataSetActivity)))


#################
##  SECTION 4  ##
#################



variablesRaw <- read.table("datasets/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
variables <- variablesRaw[,2]

meanColumnIndexNaming <- grep("mean", variables, ignore.case = TRUE)
stdColumnIndexNaming <- grep("std", variables, ignore.case = TRUE)
meanStdIndexNaming = sort(c(meanColumnIndexNaming,  stdColumnIndexNaming))
meanStdColsNaming = variables[meanStdIndexNaming]

colNames = append(c('subjectID',  "dataSource", 'activityID', 'activityDescription'),meanStdColsNaming)

cleanedcols = gsub("(","", colNames, fixed = TRUE)
cleanedcols = gsub(")","", cleanedcols, fixed = TRUE)
cleanedcols = gsub("-","", cleanedcols, fixed = TRUE)
cleanedcols = gsub(",",".", cleanedcols, fixed = TRUE)
cleanedcols = gsub("mean","Mean", cleanedcols, fixed = TRUE)
cleanedcols = gsub("std","Std", cleanedcols, fixed = TRUE)


colnames(subCombinedDataSetActivity) = cleanedcols


#################
##  SECTION 5  ##
#################

  ##CURRENTLY TOO MANY COLUMNS. DROP ACTIVITY ID AND DUMMY VARIABLE DATASOURCE
subCombinedDataSetActivityTidy  = subCombinedDataSetActivity[order(subCombinedDataSetActivity$subjectID,subCombinedDataSetActivity$activityDescription),c(1,4:90)]

  ##CAST TO DATA TABLE TO WORK WITH DPLYR
shortNameTidy =  data.table(subCombinedDataSetActivityTidy)

shortNameTidyFinal = shortNameTidy %>% group_by(subjectID, activityDescription) %>% summarise_each(funs(mean))


write.table(shortNameTidyFinal, file='tidy_dataset_full.txt', row.name=FALSE)


View(shortNameTidyFinal)







