subjectTrain<- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
subjectTest <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

trainX <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt")

testX <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
testY <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

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


#from rpubs
meanStdName <- (grepl("activity" , columnNames) | 
                grepl("SubjectID" , columnNames) | 
                grepl("mean.." , columnNames) | 
                grepl("std.." , columnNames) )

meanStdOfData <- data[ , meanStdName == TRUE]

activityLable <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", col.names = c("activityID", "activity"))
activitieData <- merge( activityLable,meanStdOfData, by = "activityID", all = TRUE)

colnames(activitieData) <- gsub("Acc", "Accelerator" ,colnames(activitieData))
colnames(activitieData) <- gsub("Mag", "Magnitude" ,colnames(activitieData))
colnames(activitieData) <- gsub("Gyro","Gyroscope" ,colnames(activitieData))
colnames(activitieData) <- gsub("^t", "time" ,colnames(activitieData))
colnames(activitieData) <- gsub("^f", "frequency" ,colnames(activitieData))


secTidySet <- aggregate(. ~SubjectID + activityID, activities, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]









