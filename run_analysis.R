library(tidyverse)

# GET TEST DATA
x_test   <- read.table("~/coursera_r/uci_har_dataset/test/X_test.txt", quote="\"", comment.char="")
y_test   <- read.table("~/coursera_r/uci_har_dataset/test/y_test.txt", quote="\"", comment.char="")
sub_test <- read.table("~/coursera_r/uci_har_dataset/test/subject_test.txt", quote="\"", comment.char="")

# GET TRAIN DATA
x_train   <- read.table("~/coursera_r/uci_har_dataset/train/X_train.txt", quote="\"", comment.char="")
y_train   <- read.table("~/coursera_r/uci_har_dataset/train/y_train.txt", quote="\"", comment.char="")
sub_train <- read.table("~/coursera_r/uci_har_dataset/train/subject_train.txt", quote="\"", comment.char="")

# GET FEATURES
features <- read.table("~/coursera_r/uci_har_dataset/features.txt", quote="\"", comment.char="")

# GET ACTIVITY LABELS
activity_labels <- read.table("~/coursera_r/uci_har_dataset/activity_labels.txt", quote="\"", comment.char="")

# MERGE DATA
df_x      <- rbind(x_test, x_train)
df_y      <- rbind(y_test, y_train)
sub_total <- rbind(sub_test, sub_train)

# SELECT MEAN & STANDARD DEV ONLY
select_features <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
df_x            <- df_x[,select_features[,1]]

# NAME ACTIVITIES
colnames(df_y)     <- "activity"
df_y$activitylabel <- factor(df_y$activity, labels = as.character(activity_labels[,2]))
activitylabel      <- df_y[,-1]

# LABEL DATASET
colnames(df_x) <- features[select_features[,1],2]

# CREATE TIDY DATASET
colnames(sub_total) <- "subject"
total               <- cbind(df_x, activitylabel, sub_total)
total_mean          <- total %>% group_by(activitylabel, subject) %>% summarize_each(list(~mean))
total_mean          <- as_tibble(total_mean)
