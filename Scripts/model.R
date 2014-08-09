predictCount<-function(train,count,test){
  
  #Random forest model based on 12 variable selection
  rfFit<-randomForest(x=train, y=count,mtry=12)
  
  
  #Make predictions using models
  predict(rfFit,newdata = test)
  
}