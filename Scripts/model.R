predictCount<-function(train,test){
  
  #Poisson model for casual and registered user seperately
  regFit<-glm(registered ~ season+holiday+workingday+weather+temp+atemp+humidity+windspeed+time,family="poisson",data=train)
  casFit<-glm(casual ~ season+holiday+workingday+weather+temp+atemp+humidity+windspeed+time,family="poisson",data=train)
  
  
  #Make predictions using models
  predict(regFit,newdata = test,type='response')+predict(casFit,newdata = test,type='response')
  
}