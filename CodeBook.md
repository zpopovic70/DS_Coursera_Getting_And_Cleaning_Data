# Code Book for the 'Getting and Cleaning Data' project

## Data source
The source of this data is the Human Activity Recognition Using Smartphones Data Set that can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones .
This data is compiled from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.


## Use the following libraries
library(data.table)
library(dplyr)

## 4. Appropriately labels the data set with descriptive variable names. 
### By examining the column names of the mergedData data set we could identify the following patterns that can be replaced:
  Acc'      -> 'Acceleration'
 'GyroJerk' -> 'AngularAcceleration'
 'Gyro'     -> 'AngulrSpeed'
 'Mag'      -> 'Magnitude'
 '^t'       -> 'Time'
 '^f'       -> 'Frequency'
 '^tBody'   -> 'TimeBody'
 '-mean()'  -> 'Mean'
 '-std()'   -> 'STD'
 '-freq()'  -> 'Frequency'
 'angle'    -> 'Angle'
 'gravity'  -> 'Gravity' 
