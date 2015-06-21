## Open libraries
library(reshape2)

## define root dir
rootDir = "c:/DataScience Course/Lecture/Getting and Cleaning Data/UCI HAR Dataset/"


runanalysis <- function(){

  ## Read the activity labels file and make a table of activity id  and activity description

  activityTable = read.table(paste0(rootDir,"activity_labels.txt"), sep=" ", col.names=c("activity_id", "activity"),fill=TRUE) 

  ## Read all feature and make a table of feature id and feature name

  featureTable = read.table(paste0(rootDir,"features.txt"), sep=" ", col.names=c("feature_id", "feature_name"),fill=FALSE) 

  ##make a list of feature names so that we can assign these feature names to the columns of X data file

  featurecolNames <- featureTable[,2]

  ## Function to read Features File from test and train directory

  readFeatures.File <- function(axis,name) {
     paste0(axis,"_", name, ".txt", sep = "")
  }

  ## Read Test Data 

  name <- "test"
  test.data <- read.table(paste0(rootDir,name,"/",readFeatures.File("X",name)))
  test.activity <- read.table(paste0(rootDir,name,"/",readFeatures.File("y",name)))
  test.subject <- read.table(paste0(rootDir,name,"/",readFeatures.File("subject",name)))

  ## Update Column Names for Test 

  colnames(test.data) <- featurecolNames
  colnames(test.activity) <- "activity_id"
  colnames(test.subject) <- "subject_id"

  ## Read Train  Data 

  name <- "train"
  train.data <- read.table(paste0(rootDir,name,"/",readFeatures.File("X",name)))
  train.activity <- read.table(paste0(rootDir,name,"/",readFeatures.File("y",name)))
  train.subject <- read.table(paste0(rootDir,name,"/",readFeatures.File("subject",name)))

  ## Update Column Names for Train

  colnames(train.data) <- featurecolNames
  colnames(train.activity) <- "activity_id"
  colnames(train.subject) <- "subject_id"


  ## Filter columns refering to mean() or std() values

   ## For Mean() value
   meancolID <- grep("mean()", names(test.data),  fixed=TRUE)
   meanColNames <- names(test.data)[meancolID]
   
   ## for STD() value
   stdcolID <- grep("std()", names(test.data),  fixed=TRUE)
   stdColNames <- names(test.data)[stdcolID]

   ## Select only mean() and std() data, there should be 66 columns for test and train data and bind the subject, activity to the data

   mean_std.testdata <-  test.data[,c(meanColNames,stdColNames)]
   mean_std.testdata <-  cbind(test.subject, test.activity, mean_std.testdata) 

   mean_std.traindata <- train.data[,c(meanColNames,stdColNames)]
   mean_std.traindata <- cbind(train.subject, train.activity, mean_std.traindata) 
 

   ## Combine both TEST and TRAIN data into single data Frame

   all_data <- rbind(mean_std.traindata, mean_std.testdata)

   ## Merge the activities data with the mean/std values data with descriptive activity and remove activity id

   all_data <- merge(all_data, activityTable,by.x="activity_id",by.y="activity_id",all=TRUE)
   all_data <- all_data[,c("subject_id", "activity", meanColNames, stdColNames)]

 
   ##Melt the dataset with measures avergaing of variables over activity and subject to do a group by
   melt.data <- melt(all_data,id=c("subject_id","activity"))

   ##Cast the dataset according to  the average of each variable for each activity and each subject
   mean.data <- dcast(melt.data,subject_id + activity ~ variable,fun.aggregate = mean, na.rm = TRUE)

   ## Create a file with the new tidy dataset
   write.table(mean.data,"./tidy_movement_data.txt",row.names = FALSE, quote = FALSE, col.names=FALSE, na="NA")
}
