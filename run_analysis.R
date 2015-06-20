# Load the required packages

library(dplyr)

# Create a directory to host the data set
# If a directory with the same name exist, back it up

if(file.exists("./datamod3"))
{
        file.rename("./datamod3","./datamod3_old")
        dir.create("./datamod3")
}

# Download the dataset and unzip it
# remove the downloaded zip file to save space

file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file_url,"./datamod3/dataset.zip",method="libcurl")
unzip("./datamod3/dataset.zip",exdir="./datamod3")
file.remove("./datamod3/dataset.zip")

# Reading train data

train_data <- read.table("./datamod3/UCI HAR Dataset/train/X_train.txt")

# Reading test data

test_data <- read.table("./datamod3/UCI HAR Dataset/test/X_test.txt")

# Reading features data

features <- read.table("./datamod3/UCI HAR Dataset/features.txt") %>% tbl_df %>% select(V2)

# Extract the feature data as factor vector

feature_data <- features[["V2"]]

# Merge the train and test data

merge_data <- rbind(train_data,test_data)

# Apply column name to the merged data set based on features 

colnames(merge_data) <- feature_data

# filter out the column name that is related to mean() and std()

mean_std_cols <- grep(".*[Mm][Ee][Aa][Nn][(][)]|.*[Ss][Tt][[Dd][(][)]",names(merge_data))

# Derive a data set that only has the mean and std data

mean_std_data <- merge_data[,mean_std_cols]

# Merge the subject data and assign "subject" variable name to it

subject_train <- read.table("./datamod3/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./datamod3/UCI HAR Dataset/test/subject_test.txt")
subject_data <- rbind(subject_train,subject_test) 
colnames(subject_data) <- "subject"

# Merge the activity data and assign "activity" variable name to it

activity_train <- read.table("./datamod3/UCI HAR Dataset/train/y_train.txt")
colnames(activity_train) <- "activity"
activity_test <- read.table("./datamod3/UCI HAR Dataset/test/y_test.txt")
colnames(activity_test) <- "activity"
activity_data <- rbind(activity_train,activity_test)

# Reading activity label file and assign variable name to it

activity_label <- read.table("./datamod3/UCI HAR Dataset/activity_labels.txt")
colnames(activity_label) <- c("label","activity")

# Replace the activity value in activity data
# with proper text description based on the information
# in activity_labels.txt

activity_data$activity <- sapply(activity_data$activity, function(x){
        as.character(activity_label$activity[match(x, activity_label$label)])
})

# Add subject and activity column into mean_std_data data frame

untidy_data <-  cbind(subject_data,activity_data, mean_std_data)

# Generate tidy data set with the average of each variable for each activity and each subject

tidy_data <- untidy_data %>% group_by(subject,activity) %>% summarise_each(funs(mean))

# Modify the label name for variable to reflect that it has indeed been
# averaged, also remove the "()" and replace "-" with "_" to ease future processing

colnames(tidy_data)[3:68] <- gsub("\\(|\\)","", paste("avg_",names(tidy_data[3:68]),sep=""))

colnames(tidy_data)[3:68] <- gsub("-","_",colnames(tidy_data)[3:68])

# Write it out to a file for submission

write.table(tidy_data,"./datamod3/tidydata.txt",row.names=FALSE)