## Download File

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

## Unzipping file

unzip(zipfile="./data/Dataset.zip",exdir="./data")

## Getting list of files

path_file <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_file, recursive=TRUE)
files

## Reading files

## Reading Y files

ActivityTest   <- read.table(file.path(path_file, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain  <- read.table(file.path(path_file, "train" , "Y_train.txt" ),header = FALSE)

## Reading Subject files

SubjectTrain <- read.table(file.path(path_file, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(path_file, "test" , "subject_test.txt"),header = FALSE)

## Reading X files

FeaturesTest   <- read.table(file.path(path_file, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain  <- read.table(file.path(path_file, "train" , "X_train.txt" ),header = FALSE)

## Merging Training and Test sets

## Concatenating data tables by rows

SubjectData  <- rbind(SubjectTrain, SubjectTest)
ActivityData <- rbind(ActivityTrain, ActivityTest)
FeaturesData <- rbind(FeaturesTrain, FeaturesTest)

## Naming variables

names(SubjectData)<-c("Subject")
names(ActivityData)<- c("Activity")
FeaturesDataNames <- read.table(file.path(path_file, "features.txt"),head=FALSE)
names(FeaturesData)<- FeaturesDataNames$V2

## Merging columns to get data frame from all data

CombineData <- cbind(SubjectData, ActivityData)
DataFrame <- cbind(FeaturesData, CombineData)

## Subset features names by measurements , Mean and standard deviation

subsetFeaturesNames<-FeaturesDataNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesDataNames$V2)]

## Subset 'DataFrame' object by selected names of features

SelectedFeaturesNames<-c(as.character(subsetFeaturesNames), "Subject", "Activity" )
Data<-subset(DataFrame,select=SelectedFeaturesNames)

## Assigning descriptive names 

LabelsActivity <- read.table(file.path(path_file, "activity_labels.txt"),header = FALSE)

## Factorize Variable Activity in 'Data' to assign descriptive names

Data$Activity<- factor(Data$Activity)
Data$Activity<- factor(Data$Activity,labels=as.character(LabelsActivity$V2))

## Labeling data sets with descriptive names

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

## Creating second and tidy data set 

library(plyr);
SecondDataSet<-aggregate(. ~Subject + Activity, Data, mean)
SecondDataSet<-SecondDataSet[order(SecondDataSet$Subject,SecondDataSet$Activity),]
write.table(SecondDataSet, file = "tidydata.txt",row.name=FALSE)


