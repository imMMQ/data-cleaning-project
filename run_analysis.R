library("data.table")
fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile1 <- "/Users/rwang10/Desktop/test3/getting and cleaning data/week4/dataset.zip"
download.file(fileUrl1, destfile1, method = "curl")
unzip(zipfile = "/Users/rwang10/Desktop/test3/getting and cleaning data/week4/dataset.zip", 
      exdir= "/Users/rwang10/Desktop/test3/getting and cleaning data/week4_project")

pathdata <- file.path("/Users/rwang10/Desktop/test3/getting and cleaning data/week4_project", "UCI HAR Dataset")
files <- list.files(pathdata, recursive=TRUE)
files
xtrain <- read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain <- read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
subject_train <- read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)
xtest <- read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest <- read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subject_test <- read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)
features <- read.table(file.path(pathdata, "features.txt"),header = FALSE)
activityLabels <- read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

colnames(xtrain) <- features[,2]
colnames(ytrain) <- c("activityId")
colnames(subject_train) <- c("subjectId")
colnames(xtest) <- features[,2]
colnames(ytest) <- c("activityId")
colnames(subject_test) <- c("subjectId")
colnames(activityLabels) <- c("activityId", "activityType")#4.Appropriately labels the data set with descriptive variable names

merge_train <- cbind(ytrain, subject_train, xtrain)
merge_test <- cbind(ytest, subject_test, xtest)
train_n_test <- rbind(merge_test, merge_train) #1.Merges the training and the test sets to create one data set.

colNames <- colnames(train_n_test)
mean_n_std <- (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
mean_n_std_of_train_n_test <- train_n_test[, mean_n_std == TRUE]#2.Extracts only the measurements on the mean and standard deviation for each measurement

discriptiveNames <- merge(mean_n_std_of_train_n_test, activityLabels, by = "activityId", all = TRUE)#3.Uses descriptive activity names to name the activities in the data set

Tidydata <- aggregate(. ~subjectId + activityId, mean_n_std_of_train_n_test, mean)
TidyMnSofTnT <- Tidydata[order(Tidydata$subjectId, Tidydata$activityId),]#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

write.table(TidyMnSofTnT, "/Users/rwang10/Desktop/test3/getting and cleaning data/week4_project/TidySet.txt", row.name=FALSE)


