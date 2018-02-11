library(dplyr)

subjectTrain<- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
subjectTest <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

trainX <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt")

testX <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
testY <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

#1- Merges the training and the test sets to create one data set.
subjects <- rbind(subjectTrain, subjectTest)
X <- rbind(trainX, testX)
Y <- rbind(trainY, testY)

featureName <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/features.txt", header = FALSE)

names(X) <- featureName$V2
names(subjects) <- "SubjectID"
names(Y) <- "activityID"

data <- cbind(subjects, X, Y)

columnNames <- names(data)
#meanStd <- grep("SubjectID|Activity|mean\\(\\)|std\\(\\)", columnName) %>% select(data)

#2- Extracts only the measurements on the mean and standard deviation for each measurement.
#from rpubs
meanStdName <- (grepl("activity" , columnNames) | 
                grepl("SubjectID" , columnNames) | 
                grepl("mean.." , columnNames) | 
                grepl("std.." , columnNames) )

meanStdOfData <- data[ , meanStdName == TRUE]

#4- Appropriately labels the data set with descriptive variable names.
activityLable <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", col.names = c("activityID", "activity"))
activitieData <- merge( activityLable,meanStdOfData, by = "activityID", all = TRUE)

#3- Uses descriptive activity names to name the activities in the data set
colnames(activitieData) <- gsub("Acc", "Accelerator" ,colnames(activitieData))
colnames(activitieData) <- gsub("Mag", "Magnitude" ,colnames(activitieData))
colnames(activitieData) <- gsub("Gyro","Gyroscope" ,colnames(activitieData))
colnames(activitieData) <- gsub("^t", "time" ,colnames(activitieData))
colnames(activitieData) <- gsub("^f", "frequency" ,colnames(activitieData))


#5- From the data set in step 4, creates a second, independent 
#tidy data set with the average of each variable for each activity and each subject.
DataWithMean <- activitieData %>% group_by(SubjectID, activityID) %>% 
  summarise_each( funs(mean))
#DataWithMean <- aggregate(. ~SubjectID + activityID, activitieData, mean)
tidyData <- DataWithMean[order(DataWithMean$SubjectID, DataWithMean$activityID),]
write.csv(tidyData, "second_tidy_data.csv")









