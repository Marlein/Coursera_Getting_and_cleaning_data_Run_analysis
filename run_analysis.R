## Loading the dplyr package
library(dplyr)

##Setting the working directory
setwd("C:/Users/")


## First I will read in all datasets seperately. The names of the data are 
## recognizable by their original names.
## At first I red in the 'features', because this file contains the names of the variables
## and they need some modification (the parenthesis removed and the data as factors)
## I add another variable, so the original variable stays as original
features <- read.table("features.txt", stringsAsFactors=FALSE)
features <- cbind(features, names=gsub("()","",features$V2, fixed=TRUE), stringsAsFactors=FALSE)
## And now the rest of the data:
traindata <- read.table("train/X_train.txt", col.names = features$names)
testdata <-  read.table("test/X_test.txt", col.names = features$names)
trainydata <- read.table("train/Y_train.txt", col.names = "activity")
testydata <-  read.table("test/Y_test.txt", col.names = "activity")
subjecttest <- read.table("test/subject_test.txt", col.names = "subject")
subjecttrain <- read.table("train/subject_train.txt", col.names = "subject")
activity_labels <- read.table("activity_labels.txt", col.names = c("V1", "activity.name"))

## Now I make two datasets - one for train and one for test - where the 
## activity-levels and subject are combined with the measurements
testdatacomplete <- cbind(testydata, subjecttest, testdata)
traindatacomplete <- cbind(trainydata, subjecttrain, traindata)

## To obtain one dataset with all the relevant data I combine them both
full_data <- rbind(traindatacomplete, testdatacomplete)

## Now I check if the dataset 'full_data' contains any NA's. If so I have
## to take further action, if not I can go on.
any(is.na(full_data))

## At this point I completed the first part of the assignment: Merges the 
## training and the test sets to create one data set.


## Next we go to the second part: Extracts only the measurements on the mean 
## and standard deviation for each measurement. 
## I extract only the variables (columns) with the name "mean" an "std"
## in it. Of course, the first two variables "activity_id", and "subject" must
## be extracted too.
full_data_mean_and_std <- select(full_data, activity, subject, contains("mean"), contains("std"))
## This completes step 2.


## Next is step 3: Uses descriptive activity names to name the activities in 
## the data set. 
## I merge the "full_data_mean_and_std" with the "activity_labels", where the 
## key in "full_data_mean_and_std"(by.x) is "activity" and the key in 
## "activity_labels" (by.y) is "V1".
full_data_merged <- merge(activity_labels, full_data_mean_and_std, by.y = "activity",
                          by.x = "V1", sort = FALSE)

## Because this dataset contains two variables that holds the same kind of data,
## i.e. "V1" and "activity.name", it does not meet the rules of a tidy data set.
## So I remove the column "V1".
full_data_merged <- select(full_data_merged,-V1)
## This completes step 3.

## Step 4. For the colnames to be tidy, I replaced all '-' for "_". Also there
## were some names with 'Bodybody' in it, so I changed it to 'Body'.
colnames(full_data_merged) <- gsub("[-]", "_", colnames(full_data_merged))
colnames(full_data_merged) <- gsub("Bodybody", "Body", colnames(full_data_merged))


## Step 5. From 'full_data_merged' I create 'group_data_mean'by grouping
## by activity.name and subject. Next I summerise all variables using the
## 'summirise_each' command. Then I write this to the file run_data_mean.txt.
group_data_mean <- full_data_merged %>% group_by(activity.name, subject) %>%
        summarise_each(funs(mean))
