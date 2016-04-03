
#Download the file and put it in the project folder
if(!file.exists("./project")){dir.create("./project")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile = "./project/Dataset.zip", method = "curl")

#Unzip the file
unzip(zipfile = "./project/Dataset.zip", exdir = "./project")

#File path
path <- file.path("./project", "UCI HAR Dataset")

#Read data into the variables
dataactivitytest  <- read.table(file.path(path, "test", "Y_test.txt"), header = FALSE)
dataactivitytrain <- read.table(file.path(path, "train", "Y_train.txt"), header = FALSE)

datasubjecttest <- read.table(file.path(path, "test", "subject_test.txt"), header = FALSE)
datasubjecttrain <- read.table(file.path(path, "train", "subject_train.txt"), header = FALSE)

datafeaturestest  <- read.table(file.path(path, "test", "X_test.txt"), header = FALSE)
datafeaturestrain <- read.table(file.path(path, "train", "X_train.txt"), header = FALSE)

#Bind the data by rows
datasubject <- rbind(datasubjecttrain, datasubjecttest)
dataactivity <- rbind(dataactivitytrain, dataactivitytest)
datafeatures <- rbind(datafeaturestrain, datafeaturestest)

#Set the variable names
names(datasubject) <- c("Subject")
names(dataactivity) <- c("Activity")
datafeaturenames <- read.table(file.path(path, "features.txt"), head = FALSE)
names(datafeatures) <- datafeaturenames$V2

#Merge columns for all of the data
combinedata <- cbind(datasubject, dataactivity)
data <- cbind(datafeatures, combinedata)

#Subset by mean and standard deviation
subdatafeaturenames <- datafeaturenames$V2[grep("mean\\(\\)|std\\(\\)", datafeaturenames$V2)]
selectednames <- c(as.character(subdatafeaturenames), "Subject", "Activity")
data <- subset(data, sselect = selectednames)

#Pull the activity names from the text file
activitylabels <- read.table(file.path(path, "activity_labels.txt"), header = FALSE)

#Label the names
names(data) <- gsub("^t", "time", names(data))
names(data) <- gsub("^f", "frequency", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))

#Output file
datafinal <- aggregate(. ~Subject + Activity, data, mean)
datafinal <- datafinal[order(datafinal$Subject, datafinal$Activity),]
write.table(datafinal, file = "tidydata.txt", row.name = FALSE)

#Output codebook
knit2html("README.md");


  
