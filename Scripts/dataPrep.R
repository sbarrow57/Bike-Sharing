dataPrep<- function(rawData){
  #load as datatable
  rawData=data.table(rawData)
  
  #Set factors
  rawData[,season:=factor(season)]
  rawData[,workingday:=factor(workingday)]
  rawData[,weather:=factor(weather)]
  rawData[,holiday:=factor(holiday)]
  
  #Split out date time column
  rawData[,date:=factor(substr(datetime,1,10))]
  rawData[,time:=factor(substr(datetime,12,19))]
  
  #return processed data
  rawData
}