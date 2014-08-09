#Load Packages
library("data.table")
library("plyr")
library("dplyr")
library("ggplot2")
library("lubridate")
library("stringr")
library("caret")
library("randomForest")

#Set WD
setwd("~/R/Kaggle/Bike Sharing/")

#include source scripts
source("Scripts/dataPrep.R")
source("Scripts/model.R")

#Read in training and test data
train=read.csv("Data/Raw Data/train.csv")
test = read.csv("Data/Raw Data/test.csv")

#get training output
count=train$count

#get test datetime
dt=test$datetime

#Complete data preparation
train=dataPrep(train)
test=dataPrep(test) 

train[,datetime:=NULL]
train[,casual:=NULL]
train[,registered:=NULL]
train[,date:=NULL]

test[,datetime:=NULL]
test[,date:=NULL]

dummies<-dummyVars(count~.,data=train)
dummyTest<-dummyVars(~.,data=test)

train<-data.table(predict(dummies,train,na.action=na.omit))
test<-data.table(predict(dummyTest,test,na.action=na.omit))

#Create model and predict values
predictedCount<-predictCount(train,count,test)

#Create output
output = data.frame(datetime=dt,count=predictedCount)
write.csv(output,"Data/ProcessedData/output.csv",row.names=F)
