dataPrep<- function(rawData){
  #load as datatable
  rawData=data.table(rawData)
  
  #Set factors
  rawData[,season:=factor(season)]
  rawData[,workingday:=factor(workingday)]
  rawData[,weather:=factor(weather)]
  rawData[,holiday:=factor(holiday)]
  
  #Split out date time column
  dt<-str_split(rawData$datetime, " ")
  date = character()
  time = character()
  for(i in 1:length(dt)){
    date=c(date,dt[[i]][[1]])
    time=c(time,dt[[i]][[2]])
  }
  rawData[,date:=factor(date)]
  rawData[,time:=factor(time)]
  
  #return processed data
  rawData
}