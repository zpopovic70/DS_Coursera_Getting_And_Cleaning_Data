# Use the following libraries
library(data.table)
library(dplyr)

print("Analysis script started")
#
# 1. Merge the training and the test set to create one data set
#
print("... Step 1")
# Read the meta data
featureNames <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

# Read the training data
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

# Read the test data
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

# Merge the training and the test set for subject, activity and features
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

#    Name the columns and merge the data into single mergeData set
colnames(features) <- t(featureNames[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
mergedData <- cbind(features,activity,subject)

#
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#
print("... Step 2")
#    Using grep extract the column names that contains 'mean' and 'std' (case insensitive)
columnsWithMeanAndSTD <- grep(".*mean.*|.*std.*", names(mergedData), ignore.case=TRUE)
#    Form a vector of column names (together with Activity and Subject) and use it to create a subset data set
filteredMergedData <- mergedData[,c(columnsWithMeanAndSTD, 562, 563)]

#
# 3. Uses descriptive activity names to name the activities in the data set
#
#
print("... Step 3")
# Replace the Activity field values (ids) with activity name factors
filteredMergedData$Activity <- activityLabels[filteredMergedData[,87] ,2]

#
# 4. Appropriately labels the data set with descriptive variable names. 
#
print("... Step 4")
# Using gsub to replace the following strings in the column names:
# 'Acc'      -> 'Acceleration'
# 'GyroJerk' -> 'AngularAcceleration'
# 'Gyro'     -> 'AngulrSpeed'
# 'Mag'      -> 'Magnitude'
# '^t'       -> 'Time'
# '^f'       -> 'Frequency'
# '^tBody'   -> 'TimeBody'
# '-mean()'  -> 'Mean'
# '-std()'   -> 'STD'
# '-freq()'  -> 'Frequency'
# 'angle'    -> 'Angle'
# 'gravity'  -> 'Gravity' 
names(filteredMergedData) <- gsub('Acc',"Acceleration",names(filteredMergedData))
names(filteredMergedData) <- gsub('GyroJerk',"AngularAcceleration",names(filteredMergedData))
names(filteredMergedData) <- gsub('Gyro',"AngularSpeed",names(filteredMergedData))
names(filteredMergedData) <- gsub('Mag',"Magnitude",names(filteredMergedData))
names(filteredMergedData) <- gsub("^t", "Time", names(filteredMergedData))
names(filteredMergedData) <- gsub("^f", "Frequency", names(filteredMergedData))
names(filteredMergedData) <- gsub("tBody", "TimeBody", names(filteredMergedData))
names(filteredMergedData) <- gsub("-mean()", "Mean", names(filteredMergedData), ignore.case = TRUE)
names(filteredMergedData) <- gsub("-std()", "STD", names(filteredMergedData), ignore.case = TRUE)
names(filteredMergedData) <- gsub("-freq()", "Frequency", names(filteredMergedData), ignore.case = TRUE)
names(filteredMergedData) <- gsub("angle", "Angle", names(filteredMergedData))
names(filteredMergedData) <- gsub("gravity", "Gravity", names(filteredMergedData))

#
# 5. From the data set in step 4, creates a second, independent tidy data set with
#    the average of each variable for each activity and each subject.
#
print("... Step 5")
filteredMergedData$Subject <- as.factor(filteredMergedData$Subject)
filteredMergedData <- data.table(filteredMergedData)
tidyData <- aggregate(. ~Subject + Activity, filteredMergedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "TidyData.txt", row.name=FALSE)

print("Analysis script completed.")
