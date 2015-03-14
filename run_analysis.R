## Objective 1 - Merges the training and the test sets to create one data set

#Reading Test Data
TestData_X <- read.table("UCI HAR Dataset/test/X_test.txt")
TestData_Y <- read.table("UCI HAR Dataset/test/y_test.txt")
TestData_S <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Reading Training Data
TrainData_X <- read.table("UCI HAR Dataset/train/X_train.txt")
TrainData_Y <- read.table("UCI HAR Dataset/train/y_train.txt")
TrainData_S <- read.table("UCI HAR Dataset/train/subject_train.txt")


#Merging Both Test & Traing Data
MergedData <- rbind(TestData_X, TrainData_X)

#Merging Test Subject and Activities
TestAS <- cbind(TestData_Y, TestData_S)

#Merging Train Subject and Activities
TrainAS <- cbind(TrainData_Y, TrainData_S)

#Merging both Test and Train Subjects and Activities

MergedAS <- rbind(TestAS, TrainAS)

colnames(MergedAS) <- c("Activity", "Subject")

## Objective 2 - Extracts only the measurements on the mean and standard deviation for each measurement.

#Reading Features
Features <- read.table("UCI HAR Dataset/features.txt")

#Seperating Std & Mean Features
FilterdFeatures <- grep("std|mean", Features$V2)

#Filtering Merged Data Based On Filtered Colums
FilteredData <- MergedData[,FilterdFeatures]

#Adding Collumn Name To Filtered Data
colnames(FilteredData) <- Features$V2[FilterdFeatures]

#Merging Data, Activity and Subject
FinalData <- cbind(MergedAS, FilteredData)

## Objective 3 - Uses descriptive activity names to name the activities in the data set

#Reading Activities Table
Activities <- read.table("UCI HAR Dataset/activity_labels.txt")

#Adding Activity Description
FinalData <- mutate(FinalData, Activity_Desc = Activities$V2[as.numeric(Activity)])

## Objective 4 - Appropriately labels the data set with descriptive variable names.

#Implemented as part of Objective 2 While Mergind Data Sets

#Objective 5 -  creates a second, independent tidy data set with the average of each variable for each activity and each subject.

TidyData <- aggregate(FinalData[,3:81], by = list(FinalData$Subject, FinalData$Activity), FUN = mean)
colnames(TidyData)[1:2] <- c("Subject", "Activity")
write.table(TidyData, file="TidyData.txt", row.names = FALSE)
