## Load necessary libraries
library(dplyr)

## Load test data, setting xtest to Test set, ytest to Test labels,
## xtrain to Training set, ytrain to Train labels and features to the 
## features label file

xtest <- read.table("~/Coursera/SamsungData/test/X_test.txt")
ytest <- read.table("~/Coursera/SamsungData/test/y_test.txt")
xtrain <- read.table("~/Coursera/SamsungData/train/X_train.txt")
ytrain <- read.table("~/Coursera/SamsungData/train/y_train.txt")
features <- read.table("~/Coursera/SamsungData/features.txt", 
                       stringsAsFactors = FALSE)

## Merge xtest and ytest, store as test.
## Merge xtrain and ytrain, store as train.

test <- cbind(ytest, xtest)
train <- cbind(ytrain, xtrain)

## Merge the train and the test sets to create one data set
full <- rbind(train, test)

## Clean up column names in the second column of features, storing in
## cnames, then add names to the full data set, labeling the first column
## "TrainingLabels" and using the rest of the names from cnames

cnames <- gsub("[-()]", "", features$V2)
colnames(full) <- c("TrainingLabels", cnames)

## Extract only the measurements on mean and standard deviation for
## each measurement. Start by search for "mean" or "std" in column
## names to obtain an integer vector of columns. Combine those vectors
## into one. Use that plus the first TrainingLabels column to select 
## columns from full data set and store in stdmean.

meanmsk <- grep("mean", names(full), ignore.case = TRUE)
stdmsk <- grep("std", names(full), ignore.case = TRUE)
msk <- c(meanmsk, stdmsk)
stdmean <- full[ , c(1, msk)]

## Add descriptive activity names to the TrainingLabels column by
## reading in the activity labels file and storing as labels.
## Merge the two tables, rename the V1 column "ActivityNum"
## and the V2 descriptor "ActivityLabel"

labels <- read.table("~/Coursera/SamsungData/activity_labels.txt", 
                     stringsAsFactors = FALSE)
stdmean <- merge(labels, stdmean, by.x = "V1", 
                 by.y = "TrainingLabels", all.y = TRUE)
stdmean <- rename(stdmean, "ActivityNum" = V1,
                   "ActivityLabel" = V2)

## Create a second data set with the average of each variable for
## each activity and each subject.

avg <- group_by(stdmean, ActivityLabel)
avg <- summarize_each(avg, "mean")
