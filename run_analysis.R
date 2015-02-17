# Read in the features file in order to create descriptive variable names
featureData <- read.table("features.txt")
featureNames <- as.character(factor(featureData$V2))

# Read in the activity names in order to create descriptive activity names
activityLabels <- read.table("activity_labels.txt")
activityNames <- as.character(factor(activityLabels$V2))

# Read in the training data, apply the descriptive variable names to
# the columns, and then only store off the columns that represent mean 
# or standard deviation measurements.
train_data <- read.table("train/X_train.txt")
colnames(train_data) <- featureNames
train_data <- train_data[,grep('-mean\\(\\)|-std\\(\\)',colnames(train_data))]

# Read the subject values that correspond to the training data and
# add this to the "training data" data frame.
train_subjects <- read.table("train/subject_train.txt")
train_data$subjects <- train_subjects[,1]

# Read the activity values that correspond to the training data and
# add this to the "training data" data frame.
train_activity <- read.table("train/y_train.txt")
train_data$activity <- as.character(factor(train_activity[,1],levels=activityLabels[,1],labels=activityLabels[,2]))

# Repeat the steps used for the training data with the test data. 
# NOTE: I chose to prepare the training and test data independantly prior 
# to the merge to save space in memory.
test_data <- read.table("test/X_test.txt")
colnames(test_data) <- featureNames
test_data <- test_data[,grep('-mean\\(\\)|-std\\(\\)',colnames(test_data))]

test_subjects <- read.table("test/subject_test.txt")
test_data$subjects <- test_subjects[,1]

test_activity <- read.table("test/y_test.txt")
test_data$activity <- as.character(factor(test_activity[,1],levels=activityLabels[,1],labels=activityLabels[,2]))

# Merge the training and test data
mergedData <- merge(test_data,train_data,all=TRUE)

library(dplyr)

# Group the merged data by subject and activity. The dplyr "group_by"
# function greatly simplifies this process. 

groupedData <- group_by(mergedData,subjects,activity)

# Once the data has been grouped, summarize the groups using the mean
# function
summarizedData <- summarise_each(groupedData,funs(mean))

# Write out the result. This data is in the "tidy wide form."
write.table(summarizedData,file="tidydata.txt",row.name=FALSE)
