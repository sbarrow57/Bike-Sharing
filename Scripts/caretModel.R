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

count<-training$count

dummies<-dummyVars(count~.,data=training)

training<-data.table(predict(dummies,training,na.action=na.omit))
#training[,count:=count]

fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number =10,verboseIter=T,
  ## no repeats
  repeats = 1)

rfGrid <-  expand.grid(mtry=(1:5)*4)

set.seed(825)

rfFit1 <- train(x=training, y=count,
                 method = "rf",
                 trControl = fitControl,
                 tuneGrid=rfGrid)

crossVal<-data.table(predict(dummies,cv,na.action=na.omit))
predictedCount<-predict(rfFit1,newdata = crossVal)
sqrt(sum((log(predictedCount+1)-log(cv$count+1))^2)/nrow(cv))