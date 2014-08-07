setwd("~/R/Kaggle/Bike Sharing/")
bsData<-read.csv("Data/Raw Data/train.csv")
source("Scripts/dataPrep.R")
bsData<-dataPrep(bsData)

smp_size <- floor(0.75 * nrow(bsData))

set.seed(123)
inTraining <- sample(seq_len(nrow(bsData)), size = smp_size)

training <- bsData[inTraining, ]
cv <- bsData[!inTraining, ]

#preprocess
training[,datetime:=NULL]
training[,casual:=NULL]
training[,registered:=NULL]
training[,date:=NULL]
training[,weather:=NULL,]

#count<-training$count

#dummies<-dummyVars(count~.,data=training)

#training<-data.table(predict(dummies,training,na.action=na.omit))
#training[,count:=count]

fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 2,verboseIter=T,
  ## repeated ten times
  repeats = 1)

set.seed(825)

gbmFit1 <- train(count ~ ., data = training,
                 method = "gbm",
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 distribution="poisson")