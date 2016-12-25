---
title: "ReadMe_run_analysis.R"
author: "Marlein"
date: "24 december 2016"
output: html_document
---

This ReadMe belongs to the peer graded assignment of week 4 of the Course Getting and Cleaning Data from Coursera. To understand the steps I took, I first repeat the assigment itself.

## The original assignemnt

Instructions
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

Review criteria

1. The submitted data set is tidy.
  
2. The Github repo contains the required scripts.
  
3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
  
4. The README that explains the analysis files is clear and understandable.
  
5. The work submitted for this project is the work of the student who submitted it.

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. 

You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 

1) Merges the training and the test sets to create one data set.

2) Extracts only the measurements on the mean and standard deviation for each measurement. 

3) Uses descriptive activity names to name the activities in the data set

4) Appropriately labels the data set with descriptive variable names. 

5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# The steps explained

First it is neccesary to load the dplyr package with ```library(dplyr)```

Next I set the working directory with 
```setwd("C:/Users/..... etc ")``` for privacy reasons I did not state my actual working directory.


Then I read in all datasets seperately. The names of the data are recognizable by their original names. At first I read in the 'features', because this file contains the names of the variables and they need some modification (the parenthesis removed and the data as factors) I added another variable, so the original variable stays as original. 

So reading in with ```features <- read.table("features.txt", stringsAsFactors=FALSE)``` and then adding the variable 
```features <- cbind(features, names=gsub("()","",features$V2, fixed=TRUE), stringsAsFactors=FALSE)```

Then I read in the rest of the data with ```traindata <- read.table("train/X_train.txt", col.names = features$names)``` and so I did for all of the datasets using the appropriate and logical names for the columns.


Next I made two datasets - one for train and one for test - where the activity-levels and subject are combined with the measurements
```testdatacomplete <- cbind(testydata, subjecttest, testdata)
traindatacomplete <- cbind(trainydata, subjecttrain, traindata)```

To obtain one dataset with all the relevant data I combine them both with ```full_data <- rbind(traindatacomplete, testdatacomplete)```

I checked if the dataset 'full_data' contains any NA's with ```any(is.na(full_data))```. There were no NA's, so no further action was needed.

At this point I completed the first part of the assignment: Merges the training and the test sets to create one data set.

Next we go to the second part: Extracts only the measurements on the mean and standard deviation for each measurement. I extract only the variables (columns) with the name "mean" an "std" in it. Of course, the first two variables "activity_id", and "subject" must be extracted too.
```full_data_mean_and_std <- select(full_data, activity, subject, contains("mean"), contains("std"))```
This completes step 2.


Next is step 3: Uses descriptive activity names to name the activities in the data set. 
I merged the "full_data_mean_and_std" with the "activity_labels", where the 
key in "full_data_mean_and_std"(by.x) is "activity" and the key in "activity_labels" (by.y) is "V1".
```full_data_merged <- merge(activity_labels, full_data_mean_and_std, by.y = "activity", by.x = "V1", sort = FALSE)```

Because this dataset contains two variables that holds the same kind of data, i.e. "V1" and "activity.name", it does not meet the rules of a tidy data set. So I removed the column "V1" with ```full_data_merged <- select(full_data_merged,-V1)``` and This completes step 3.

Step 4. For the colnames to be tidy, I replaced all '-' for "_". Also there were some names with 'Bodybody' in it, so I changed it to 'Body' with ```colnames(full_data_merged) <- gsub("[-]", "_", colnames(full_data_merged))
colnames(full_data_merged) <- gsub("Bodybody", "Body", colnames(full_data_merged))```


Step 5. From 'full_data_merged' I create 'group_data_mean'by grouping by activity.name (6 different names) and subject (30 subjects). Next I summerise all variables using the 'summirise_each' command. Then I write this to the file run_data_mean.txt.
```group_data_mean <- full_data_merged %>% group_by(activity.name, subject) %>% summarise_each(funs(mean))```

End of ReadMe