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
count<-training$count

#preprocess casual data
training[,datetime:=NULL]
training[,casual:=NULL]
training[,registered:=NULL]

#Get model matrices, splitting factors
modelVars<-dummyVars(count~.,data=training)

training<-data.table(predict(modelVars,training,na.action=na.omit))

rmsle <- function (data, lev = NULL, model = NULL)                               
{     
  out<-sqrt(sum((log(data$pred+1)-log(data$obs+1))^2)/nrow(data))
  names(out)<-"RMSLE"
  out
}


fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number =10,verboseIter=T,
  ## no repeats
  repeats = 1,
  summaryFunction=rmsle
  )


rfGrid <-  expand.grid(mtry=(1:6)*5)

set.seed(825)

regRfFit1 <- train(x=training, y=regCount,
                 method = "rf",
                 trControl = fitControl,
                 tuneGrid=rfGrid,
                 metric="RMSLE",
                 maximize=FALSE)

set.seed(825)

casRfFit1 <- train(x=training, y=casCount,
                   method = "rf",
                   trControl = fitControl,
                   tuneGrid=rfGrid,
                   metric="RMSLE",
                   maximize=FALSE)

#Get predicted registered
crossVal<-data.table(predict(modelVars,cv,na.action=na.omit))
preRegCount<-predict(regRfFit1,newdata = crossVal)

#Get predicted casual
preCasCount<-predict(casRfFit1,newdata = crossVal)

#Add counts together
predictedCount<-preRegCount+preCasCount

#Get error score
sqrt(sum((log(predictedCount+1)-log(cv$count+1))^2)/nrow(cv))