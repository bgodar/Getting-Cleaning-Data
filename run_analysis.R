## Load necessary libraries
library(dplyr)

## Load test and train data, setting xtest to Test set, ytest to Test labels,
## subtest to Test Subject labels xtrain to Training set, ytrain to Train
## labels, subtrain to Train Subject labels and features to the features label
## file

xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
subtest <- read.table("test/subject_test.txt")
xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
subtrain <- read.table("train/subject_train.txt")
features <- read.table("features.txt", 
                       stringsAsFactors = FALSE)

## Merge xtest, ytest and subtest, store as test.
## Merge xtrain, ytrain and subtrain, store as train.

test <- cbind(ytest, subtest, xtest)
train <- cbind(ytrain, subtrain, xtrain)

## Merge the train and the test sets to create one data set
full <- rbind(train, test)

## Add names to the full data set, labeling the first column
## "Activity", the second "Subject", and using the rest of the names 
## from the second column of features

colnames(full) <- c("Activity", "Subject", features$V2)

## Extract only the measurements on mean and standard deviation for
## each measurement. Start by search for "mean" or "std" in column
## names to obtain an integer vector of columns. Combine those vectors
## into one. Use that plus the Activity and Subject columns to select 
## columns from full data set and store in stdmean.

meanmsk <- grep("mean", names(full), ignore.case = TRUE)
stdmsk <- grep("std", names(full), ignore.case = TRUE)
msk <- c(meanmsk, stdmsk)
stdmean <- full[ , c(1, 2, msk)]

## Add descriptive activity names by reading in the activity labels
## file and storing as labels. Merge the two tables, rename the V1 
## column "ActivityNum" and the V2 descriptor "ActivityLabel"

labels <- read.table("~/Coursera/SamsungData/activity_labels.txt", 
                     stringsAsFactors = FALSE)
stdmean <- merge(labels, stdmean, by.x = "V1", 
                 by.y = "Activity", all.y = TRUE)
stdmean <- rename(stdmean, "ActivityNum" = V1,
                   "ActivityLabel" = V2)

## Create a second data set with the average of each variable for
## each activity and each subject.

avg <- group_by(stdmean, ActivityLabel, Subject)
avg <- summarize_each(avg, "mean")

## Write table to a file
write.table(avg, "~/Coursera/tidy_data_avgs.txt", row.names = FALSE)
