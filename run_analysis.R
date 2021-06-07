### Download and unzip the dataset
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

### Unzip the dataset
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

### R script "run_analysis.R"
### This part of the code merges the training and the test datasets to create a single dataset.
### To read feature vector
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))

### To read activity labels
Activity_Labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

### To read testing tables
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

### To read training tables
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

### To merge all data in one set
X_merge <- rbind(x_train, x_test)
Y_merge <- rbind(y_train, y_test)
Subject_merge <- rbind(subject_train, subject_test)
Data_merge <- cbind(Subject_merge, Y_merge, X_merge)


### To extract only the measurements on the mean and standard deviation for each measurement
Tidy_dataset <- Data_merge %>% select(subject, code, contains("mean"), contains("std"))

### To name the activities in the data set, this part of the code assigns descriptive activity names
Tidy_dataset$code <- Activity_Labels[Tidy_dataset$code, 2]

### This part of the code label the data set with descriptive variable names
names(Tidy_dataset)[2] = "activity"
names(Tidy_dataset)<-gsub("Acc", "Accelerometer", names(Tidy_dataset))
names(Tidy_dataset)<-gsub("Gyro", "Gyroscope", names(Tidy_dataset))
names(Tidy_dataset)<-gsub("BodyBody", "Body", names(Tidy_dataset))
names(Tidy_dataset)<-gsub("Mag", "Magnitude", names(Tidy_dataset))
names(Tidy_dataset)<-gsub("^t", "Time", names(Tidy_dataset))
names(Tidy_dataset)<-gsub("^f", "Frequency", names(Tidy_dataset))
names(Tidy_dataset)<-gsub("tBody", "TimeBody", names(Tidy_dataset))
names(Tidy_dataset)<-gsub("-mean()", "Mean", names(Tidy_dataset), ignore.case = TRUE)
names(Tidy_dataset)<-gsub("-std()", "STD", names(Tidy_dataset), ignore.case = TRUE)
names(Tidy_dataset)<-gsub("-freq()", "Frequency", names(Tidy_dataset), ignore.case = TRUE)
names(Tidy_dataset)<-gsub("angle", "Angle", names(Tidy_dataset))
names(Tidy_dataset)<-gsub("gravity", "Gravity", names(Tidy_dataset))

### This part of the code creates a second, independent tidy dataset from the previous dataset with the average of each variable for each activity and each subject
OutputData <- Tidy_dataset %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(OutputData, "OutputTidyData.txt", row.name=FALSE)

### str(OutputData)





