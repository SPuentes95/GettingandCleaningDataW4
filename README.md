# Getting and Cleaning Data: Course Project

This is an R script that can be used to read the files contained in the project:
* activity_labels.txt
* features.txt
* test folder, which contains:
 * subject_test.txt
 * X_test
 * y_test
* train folder, which contains:
 * subject_train.txt
 * X_train
 * y_train
 
Firstly, we'd like to load the libraries taught in this course: 
```{r}
library(dplyr)
library(tidyr)
```

## Reading files into R

Now we start by adding the files into our workspace, we use the _sep_ argument to immediately split the blanks for each row contained in the .txt files:

```{r, echo=FALSE}
x_test = read.csv("test/X_test.txt", header = FALSE, sep ="")
x_train = read.csv("train/X_train.txt", header = FALSE, sep ="")

y_test = read.csv("test/y_test.txt", header = FALSE, sep ="")
y_train = read.csv("train/y_train.txt", header = FALSE, sep ="")

features = read.csv("features.txt", header = FALSE, sep = "")
```
### Data Cleaning
We then proceed to rename the "features" data frame to make calculations easier:

```{r, echo=FALSE}
features = features[2]
names(features) = "Features"
```

Same with activities:

```{r, echo=FALSE}
activities = read.csv("activity_labels.txt", header = FALSE, sep = "", stringsAsFactors = FALSE)
names(activities) = c("Number","Code")
```

We then proceed to read subject data for each folder:

```{r, echo=FALSE}
subject_test = read.csv("test/subject_test.txt", header = FALSE, sep ="")
subject_train = read.csv
```

Then we combine the datasets from test and train folders, and obtain the names of the x_total variables as indicated by the features .txt file:

```{r, echo=FALSE}
x_total = rbind(x_test, x_train)
y_total = rbind(y_test, y_train)
subject_total = rbind(subject_test, subject_train)

names(x_total) = features$Features
```

We also rename the remaining data frames:

```{r, echo=FALSE}
names(y_total) = "Activity"
names(subject_total) = "Subject"
```

The following line gets rid of the variables we are not interested in, namely, those who do not contain either "std" or "mean":

```{r, echo=FALSE}
Names_Chosen = grepl("mean|std", names(x_total), ignore.case = TRUE)
x_total = x_total[Names_Chosen]
```

Now we use _merge_ to associate the activity numbers (on y_total) to their respective names (from activities):

```{r, echo=FALSE}
y_total = merge(y_total, activities, by.x = "Activity", by.y = "Number")
y_total = y_total[2]
names(y_total) = "Activity"
```

### Final Steps
Afterwards, we want to create one final frame (conveniently named) to summarize the mean values of the desired variables (one per column as indicated by the tidy data philosophy):

```{r, echo=FALSE}
final_frame = cbind(subject_total, y_total, x_total)
final_frame = group_by(final_frame, Subject, Activity)
```

At this point we summarize the entire data frame.  
Using the [funs](https://www.rdocumentation.org/packages/dplyr/versions/0.7.8/topics/funs) function coupled with  [summarize_all](https://rdrr.io/cran/dplyr/man/summarise_all.html), we can do this:

```{r, echo=FALSE}
summFrame = summarize_all(final_frame, funs(mean))
```

And finally, we write our resulting summary into a .csv file (in the code is included a line if exporting to .txt is preferred):

```{r, echo=FALSE}
write.csv(summFrame, file = "Tidy.csv")
```
