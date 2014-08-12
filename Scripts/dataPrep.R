dataPrep<- function(rawData){
  #load as datatable
  rawData=data.table(rawData)
  
  #Set factors
  rawData[,season:=factor(season)]
  rawData[,workingday:=factor(workingday)]
  rawData[,weather:=factor(weather)]
  rawData[,holiday:=factor(holiday)]
  
  #Split out date time column
  datetime = ymd_hms(rawData$datetime)
  hour = hour(datetime)
  wday = wday(datetime)
  month = month(datetime)
  year = year(datetime)
  rawData[,hour:=factor(hour)]
  rawData[,wday:=factor(wday)]
  rawData[,month:=factor(month)]
  rawData[,year:=factor(year)]
  
  #return processed data
  rawData
}