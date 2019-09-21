#Load the required libraries
library(dplyr)
library(tidyr)

#Now to load each portion with read.csv()

x_test = read.csv("test/X_test.txt", header = FALSE, sep ="")
x_train = read.csv("train/X_train.txt", header = FALSE, sep ="")

y_test = read.csv("test/y_test.txt", header = FALSE, sep ="")
y_train = read.csv("train/y_train.txt", header = FALSE, sep ="")

#Read features

features = read.csv("features.txt", header = FALSE, sep = "")

#We need only the second column of this dataframe, which contains the names themselves

features = features[2]
names(features) = "Features"

#Read activity codes

activities = read.csv("activity_labels.txt", header = FALSE, sep = "", stringsAsFactors = FALSE)
names(activities) = c("Number","Code")
#Read subjects for each folder

subject_test = read.csv("test/subject_test.txt", header = FALSE, sep ="")
subject_train = read.csv("train/subject_train.txt", header = FALSE, sep ="")

#Create new frames with the total of the test + train data

x_total = rbind(x_test, x_train)
y_total = rbind(y_test, y_train)
subject_total = rbind(subject_test, subject_train)

#Rename x_total columns to clear, understandable column names using features

names(x_total) = features$Features

#Rename y_total (Activity codes) and subject_total with clear names

names(y_total) = "Activity"
names(subject_total) = "Subject"

#Get rid of the non-mean, non-std columns in x_total

Names_Chosen = grepl("mean|std", names(x_total), ignore.case = TRUE)
x_total = x_total[Names_Chosen]

#Associate activity from "activities" to the number from "y_total"

y_total = merge(y_total, activities, by.x = "Activity", by.y = "Number")

#Get activity name from y_total

y_total = y_total[2]
names(y_total) = "Activity"
#Create a new frame containing all of the data

final_frame = cbind(subject_total, y_total, x_total)

#Using group_by for summarizing

final_frame = group_by(final_frame, Subject, Activity)

#Using summarize_all to summarize the means for each pair of Subject and Activity

summFrame = summarize_all(final_frame, funs(mean))

#Write summFrame to a file, in the next line I included (optional) the code to write to .txt instead to .csv
#write.table(summFrame, file = "Tidy.txt")
write.csv(summFrame, file = "Tidy.csv")