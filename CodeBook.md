# Code Book for the 'Getting and Cleaning Data' project

## Data source
The source of this data is the Human Activity Recognition Using Smartphones Data Set that can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones .
This data is compiled from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.


### Script is using the following libraries:
- *data.table* (to write output into .txt tabular format)
- *dplyr* (to aggregate data)


### 1. Merge the training and the test set to create one data set
##### Read the meta data
featureNames <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

#### Read the training data
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

#### Read the test data
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

#### Merge the training and the test set for subject, activity and features'
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

#### Name the columns and merge the data into single mergeData set
colnames(features) <- t(featureNames[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
mergedData <- cbind(features,activity,subject)


### 2. Extracts only the measurements on the mean and standard deviation for each measurement

### 3. Uses descriptive activity names to name the activities in the data set

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
