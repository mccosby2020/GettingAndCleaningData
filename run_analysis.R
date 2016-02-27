#Download the file and store in local R working directory
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileUrl, destfile = 'smartphone.zip')
# Unzip to get the content folder UCI HAR Dataset
unzip(zipfile = 'smartphone.zip')
filefolder <- 'UCI HAR Dataset' 
# Get the name of files in the content folder
files <- list.files(filefolder,recursive = TRUE)
#read test activity from test/Y_test.txt in content folder
activityTest<- read.table(file.path(filefolder,"test","Y_test.txt"), header = FALSE)
#Read training activity from train/Y_train.txt in content folder
activityTrain<- read.table(file.path(filefolder,"train","Y_train.txt"), header = FALSE)
#read features for test in test/X_test.text in content folder
featureTest<- read.table(file.path(filefolder,"test","X_test.txt"), header = FALSE)
#read features for train in train/X_train.txt in content folder
featureTrain<- read.table(file.path(filefolder,"train","X_train.txt"), header = FALSE)
#read subject for test in test/subject_test.txt in content folder
subjectTest<- read.table(file.path(filefolder,"test","subject_test.txt"), header = FALSE)
# Read subject for train in train/subject_train.txt in content folder
subjectTrain<- read.table(file.path(filefolder,"train","subject_train.txt"), header = FALSE)
# combine test and test 
subject <- rbind(subjectTrain,subjectTest)
activity <- rbind(activityTrain,activityTest)
feature <- rbind(featureTrain,featureTest)
# Name the data
names(subject) <- c("subject")
names(activity) <- c("activity")
#Get the feature names from the features.text in content folder
featureNames <- read.table(file.path(filefolder,"features.txt"),header = FALSE)
# get the second colum ($v2) from featurenames and used it to name feature
names(feature) = featureNames$V2
#all data to form final data set
subjectActivity = cbind(subject,activity)
dataSet <- cbind(feature,subjectActivity)
# create set of names of features mean() and std()
subNames<-featureNames$V2[grep("mean\\(\\)|std\\(\\)", featureNames$V2)]
# create vector combining SubNames, activity and subject
selectedNames<-c(as.character(subNames), "subject", "activity" )
#Subset original dataSet to have only columns in selectedNames
dataSet <- subset(dataSet,select=selectedNames)
# Read descriptive activity names from activity_labels.txt in content folder
activityLabels <- read.table(file.path(filefolder, "activity_labels.txt"),header = FALSE)
# name the activity labels
colnames(activityLabels) <- c("activity","activityNames")
# merge the data set with activity label on activity
dataSet <- merge(x=dataSet,y=activityLabels, by = "activity")
#drop the activity column which has the ids
dataSet$activity <- NULL
#rename the column activityName to activity
names(dataSet)[names(dataSet) == "activityNames"] <- "activity"
#Descriptively label the data set with descriptive variables.
#prefix t is replaced by time
#Acc is replaced by Accelerometer
#Gyro is replaced by Gyroscope
#prefix f is replaced by frequency
#Mag is replaced by Magnitude
#BodyBody is replaced by Body
names(dataSet)<-gsub("^t", "time", names(dataSet))
names(dataSet)<-gsub("^f", "frequency", names(dataSet))
names(dataSet)<-gsub("Acc", "Accelerometer", names(dataSet))
names(dataSet)<-gsub("Gyro", "Gyroscope", names(dataSet))
names(dataSet)<-gsub("Mag", "Magnitude", names(dataSet))
names(dataSet)<-gsub("BodyBody", "Body", names(dataSet))

# Create second, indepent tidy data set with the average of each variable for each activity and each subject

dataSet2<-aggregate(. ~subject + activity, dataSet, mean)
dataSet2<-dataSet2[order(dataSet2$subject,dataSet2$activity),]
write.table(dataSet2, file = "tidydata.txt",row.name=FALSE)


