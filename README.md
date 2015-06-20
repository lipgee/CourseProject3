## README for CourseProject3

This readme document describes the process to transform "Human Activity Recognition Using Smartphones Dataset" 
into a tidy data set. The tidy data set consist of average metrics for 66 variables grouped by subject and activity. 

The retrieval and cleansing of data is to be performed by running run_analysis.R script in this repository.

The logic of run_analysis.R scripts can be categorized as the following sub-processes:

1) Environment Setup 
2) Data Retrieval Process
3) Data Consolidation Process
4) Data Cleansing/Tidy Data Generation Process 


Listed below are the steps performed by run_analysis.R script:

Step 1: Environment Setup (line 1 to line 12)
----------------------------------------------
- In this step, the script loads the required packages that is needed for execution.
- It also check if a directory name datamod3 exist (ie: data for module 3)
- If datamod3 directory exist, it is to be renamed to datamod3_old. This is to make sure the script won't overwrite any
  pre-existing data in user's platform
- Once the directory existance and rename operation is done, a directory named datamod3 is to be created 
  in the current R environment working directory to host the Samsung phone raw data set

Step 2: Data Retrieval Process (line 14 to line 20)
----------------------------------------------------  
- The script connects to URL "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  to download the raw data set file
- Once the download is complete, the downloaded file gets unzipped into datamod3 directory created in Step 1
- To save user's machine capacity, the downloaded zip files is removed once the unzip operation is done.

Step 3: Data Consolidation Process (line 22 to line 84)
--------------------------------------------------------
- Line 22 to 44 in run_analysis.R script reads the following files and derives a base data frame for subsequent 
  processing: 

 a) UCI HAR Dataset/train/X_train.txt
 b) UCI HAR Dataset/test/X_test.txt
 c) UCI HAR Dataset/features.txt
 
- A data frame named "merge_data" is created by combining train set and test set data, the header for the data frame
  is derived from features.txt.
- At this point of time, the dimension of the merge_data data frame is 10299 rows * 561 columns
- Line 46 - 52 in the script further filter out the data that is of interest to the scope of this project. Only 
  the measurements on the mean and standard deviation for each measurement is extracted. This resulted in a new data
  frame named mean_std_data
- mean_std_data data frame consist of 10299 rows * 66 columns
- As the ultimate goal of the project is to group up the data by subject and activity. Line 54 to line 67 prepares the
  data for subject and activity columns.
- As the raw form of activity data is numeric value, Line 69 to Line 80 performs the matching of activity numeric value
  with UCI HAR Dataset/activity_labels.txt. Text description of the activity is then replaced in the activity data.
- On Line 84, the base data frame named mean_std_data combines with the subject & activity data as a staging data frame
  named untidy_data. untidy_data consists of 10299 rows * 68 columns
- As of this stage, requirement 1 to 3 in course project questions has been fulfilled. However, there's still some 
  clean up needed to fulfill requirement 4 & 5.
  
Step 4: Data Cleansing/Tidy Data Generation Process (line 86 to line 99)
-------------------------------------------------------------------------
- As per requirement 5 in course project question, we need to group the data set by activity and subject. All the 
  measurement data needs to be averaged up by this grouping. Line 88 performs the mentioned operation and this yield
  a new data frame named "tidy_data"
- Line 93 and Line 95 further tidy up the "tidy_data" data set by changing the column name to a more descriptive name
  to reflect that those measurement are the averaged result of the original raw data
- tidy_data data frame consist of 180 rows * 68 columns  
- Line 99 takes the complete tidy_data data frame and write it out to a file named: tidydata.txt

Unit Test
---------
Listed below are the steps to unit test the script:

  - Load the script named run_analysis.R into R Studio
  - Run the script
  - Execute View(tidy_data) to validate the result
  
