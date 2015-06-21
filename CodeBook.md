# Code Book for the 'Getting and Cleaning Data' project

## Data 
The source of this data is the Human Activity Recognition Using Smartphones Data Set that can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones .

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

For each record it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.


### Script is using the following libraries:
- *data.table* (to write output into .txt tabular format)
- *dplyr* (to aggregate data)


### 1. Merge the training and the test set to create one data set
```
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

# Name the columns and merge the data into single mergeData set
colnames(features) <- t(featureNames[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
mergedData <- cbind(features,activity,subject)
```

### 2. Extracts only the measurements on the mean and standard deviation for each measurement
```
# Using grep extract the column names that contains 'mean' and 'std' (case insensitive)
columnsWithMeanAndSTD <- grep(".*mean.*|.*std.*", names(mergedData), ignore.case=TRUE)

# Form a vector of column names (together with Activity and Subject) and use it to create a subset data set
filteredMergedData <- mergedData[,c(columnsWithMeanAndSTD, 562, 563)]
```

### 3. Uses descriptive activity names to name the activities in the data set
```
# Replace the Activity field values (ids) with activity name factors
filteredMergedData$Activity <- activityLabels[filteredMergedData[,87] ,2]
```

### 4. Appropriately labels the data set with descriptive variable names. 

By examining the column names of the mergedData data set we could identify the following patterns that can be replaced:
*  Acc'      -> 'Acceleration'
* 'GyroJerk' -> 'AngularAcceleration'
* 'Gyro'     -> 'AngulrSpeed'
* 'Mag'      -> 'Magnitude'
* '^t'       -> 'Time'
* '^f'       -> 'Frequency'
* '^tBody'   -> 'TimeBody'
* '-mean()'  -> 'Mean'
* '-std()'   -> 'STD'
* '-freq()'  -> 'Frequency'
* 'angle'    -> 'Angle'
* 'gravity'  -> 'Gravity'

```
# Use gsub to replace the character patterns in the column names
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
``` 

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
```
# Turn the Subject column values into factors and convert to table
filteredMergedData$Subject <- as.factor(filteredMergedData$Subject)
filteredMergedData <- data.table(filteredMergedData)

# Find the mean for each Subject and Activity
tidyData <- aggregate(. ~Subject + Activity, filteredMergedData, mean)

# Order by the Subject and Activity
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]

# Write the Tidy data set to TidyData.txt file
write.table(tidyData, file = "TidyData.txt", row.name=FALSE)
```
