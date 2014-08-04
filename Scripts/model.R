predictCount<-function(train,test){
  
  #Poisson model
  glmFit<-glm(count ~ season+holiday+workingday+weather+temp+atemp+humidity+windspeed+time,family="poisson",data=train)
  
  #Make predictions using model
  predict(glmFit,newdata = test,type='response')
  
}