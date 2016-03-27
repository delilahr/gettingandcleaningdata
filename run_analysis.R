##R Script for the final project of Getting and Cleaning Data 

##Read the data sets from text files
train.set = read.table("./ProjectInstructions/train/X_train.txt")
test.set = read.table("./ProjectInstructions/test/X_test.txt")
subject.train = read.table("./ProjectInstructions/train/subject_train.txt")
subject.test = read.table("./ProjectInstructions/test/subject_test.txt")
activities.train = read.table("./ProjectInstructions/train/y_train.txt")
activities.test = read.table("./ProjectInstructions/test/y_test.txt")
activity.labels = read.table("./ProjectInstructions/activity_labels.txt")
features = read.table("./ProjectInstructions/features.txt")

##Rename columns in the train and test data sets to match the features being measured
names(train.set) <- features$V2
names(test.set) <- features$V2

##Append the Subject variable as a new column in the train and test data sets
train.set$subject <- subject.train$V1
test.set$subject <- subject.test$V1

##Append the Activity variable as a new column in the train and test data sets
train.set$activity <- activities.train$V1
test.set$activity <- activities.test$V1

##Merge the train and test data sets
dataset <- rbind(train.set, test.set)

##Retain only measurements related to mean and standard deviation
mean.vector <- grep("[Mm]ean",names(dataset))
std.vector <- grep("[Ss]td",names(dataset))
subject.vector <- grep("subject",names(dataset))
activity.vector <- grep("activity",names(dataset))
mean.std.column.names <- c(mean.vector,std.vector,subject.vector,activity.vector)
reduced.dataset <- dataset[mean.std.column.names]

##Rename the values in the activity column with descriptive names
reduced.dataset$activity <- gsub("1","walking",reduced.dataset$activity,)
reduced.dataset$activity <- gsub("2","walkingupstairs",reduced.dataset$activity,)
reduced.dataset$activity <- gsub("3","walkingdownstairs",reduced.dataset$activity,)
reduced.dataset$activity <- gsub("4","sitting",reduced.dataset$activity,)
reduced.dataset$activity <- gsub("5","standing",reduced.dataset$activity,)
reduced.dataset$activity <- gsub("6","laying",reduced.dataset$activity,)

##Appropriately label the data set with descriptive variable names.

names(reduced.dataset) <- gsub("tBodyAcc","BodyLinearAccelerationByTime",names(reduced.dataset),)
names(reduced.dataset) <- gsub("tGravityAcc","GravityAccelerationByTime",names(reduced.dataset),)
names(reduced.dataset) <- gsub("tBodyAccJerk","JerkSignalForBodyLinearAccelerationByTime",names(reduced.dataset),)
names(reduced.dataset) <- gsub("tBodyGyro","BodyAngularVelocityByTime",names(reduced.dataset),)
names(reduced.dataset) <- gsub("tBodyGyroJerk","JerkSignalForBodyAngularVelocityByTime",names(reduced.dataset),)
names(reduced.dataset) <- gsub("tBodyAccMag","EuclideanBodyLinearAccelerationByTime",names(reduced.dataset),)
names(reduced.dataset) <- gsub("tGravityAccMag","EuclideanGravityAccelerationByTime",names(reduced.dataset),)
names(reduced.dataset) <- gsub("tBodyAccJerkMag","JerkSignalForEuclideanBodyLinearAccelerationByTime",names(reduced.dataset),)
names(reduced.dataset) <- gsub("tBodyGyroMag","EuclideanBodyAngularVelocityByTime",names(reduced.dataset),)
names(reduced.dataset) <- gsub("tBodyGyroJerkMag","JerkSignalForEuclideanBodyAngularVelocityByTime",names(reduced.dataset),)
names(reduced.dataset) <- gsub("fBodyAcc","BodyLinearAccelerationByFrequency",names(reduced.dataset),)
names(reduced.dataset) <- gsub("fBodyAccJerk","JerkSignalForBodyLinearAccelerationByFrequency",names(reduced.dataset),)
names(reduced.dataset) <- gsub("fBodyGyro","BodyAngularVelocityByFrequency",names(reduced.dataset),)
names(reduced.dataset) <- gsub("fBodyAccMag","EuclideanBodyLinearAccelerationByFrequency",names(reduced.dataset),)
names(reduced.dataset) <- gsub("fBodyAccJerkMag","JerkSignalForEuclideanBodyLinearAccelerationByFrequency",names(reduced.dataset),)
names(reduced.dataset) <- gsub("fBodyGyroMag","EuclideanBodyAngularVelocityByFrequency",names(reduced.dataset),)
names(reduced.dataset) <- gsub("fBodyGyroJerkMag","JerkSignalForEuclideanBodyAngularVelocityByFrequency",names(reduced.dataset),)
names(reduced.dataset) <- gsub("std()","StandardDeviation",names(reduced.dataset),)
names(reduced.dataset) <- gsub("meanFreq()","MeanFrequency",names(reduced.dataset),)

##create an independent tidy data set with the average of each variable for each activity and each subject.
final.dataset <- reduced.dataset
final.dataset <- melt(final.dataset, id = c("subject","activity"))
final.dataset <- dcast(final.dataset,subject + activity ~ variable, fun.aggregate = mean)
filename <- "finaldataset.txt"
write.table(final.dataset,filename,col.names = TRUE)

##end
