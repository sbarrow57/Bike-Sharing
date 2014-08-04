#Load Packages
library("data.table")
library("dplyr")
library("ggplot2")
library("lubridate")
library("caret")
library("stringr")

#Set WD
setwd("~/R/Kaggle/Bike Sharing/")

#include source scripts
source("Scripts/dataPrep.R")
source("Scripts/model.R")

#Read in training and test data
train=read.csv("Data/Raw Data/train.csv")
test = read.csv("Data/Raw Data/test.csv")

#Complete data preparation
train=dataPrep(train)
test=dataPrep(test) 

#Create model and predict values
predictedCount<-predictCount(train,test)

#Create output
output = data.frame(datetime=test$datetime,count=predictedCount)
write.csv(output,"Data/Processed Data/output.csv",row.names=F)
