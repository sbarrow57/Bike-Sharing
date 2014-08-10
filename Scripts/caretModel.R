setwd("~/R/Kaggle/Bike Sharing/")
bsData<-read.csv("Data/Raw Data/train.csv")
source("Scripts/dataPrep.R")
bsData<-dataPrep(bsData)

smp_size <- floor(0.75 * nrow(bsData))

set.seed(123)
inTraining <- sample(seq_len(nrow(bsData)), size = smp_size)

training <- bsData[inTraining, ]
cv <- bsData[!inTraining, ]

regCount<-training$registered
casCount<-training$casual

#preprocess casual data
training[,datetime:=NULL]
training[,casual:=NULL]
training[,registered:=NULL]
training[,date:=NULL]

#Get model matrices, splitting factors
modelVars<-dummyVars(count~.,data=training)

training<-data.table(predict(modelVars,training,na.action=na.omit))

fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number =10,verboseIter=T,
  ## no repeats
  repeats = 1)

rfGrid <-  expand.grid(mtry=(1:5)*4)

set.seed(825)

regRfFit1 <- train(x=training, y=regCount,
                 method = "rf",
                 trControl = fitControl,
                 tuneGrid=rfGrid)

casRfFit1 <- train(x=training, y=casCount,
                   method = "rf",
                   trControl = fitControl,
                   tuneGrid=rfGrid)

#Get predicted registered
crossVal<-data.table(predict(modelVars,cv,na.action=na.omit))
preRegCount<-predict(regRfFit1,newdata = crossVal)

#Get predicted casual
preCasCount<-predict(casRfFit1,newdata = crossVal)

#Add counts together
predictedCount<-preRegCount+preCasCount

#Get error score
sqrt(sum((log(predictedCount+1)-log(cv$count+1))^2)/nrow(cv))