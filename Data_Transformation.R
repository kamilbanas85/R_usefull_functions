  # If is not installed -> Install
    if (!require("dplyr"))     install.packages("dplyr", dep = TRUE)
    if (!require("xts"))       install.packages("xts", dep = TRUE)
    if (!require("lubridate")) install.packages("lubridate", dep = TRUE)
    if (!require("TSstudio"))  install.packages("TSstudio", dep = TRUE) 
  # Load Package if no loaded
    require(dplyr)
    require(xts)
    require(lubridate)

############################################################
## check what happen when data start or end on 29-02

DataFrameToXTS <- function(DataFrame){
  
  if('tbl' %in% class(DataFrame) | 'tbl_df' %in% class(DataFrame)){
    DataFrame <- as.data.frame(DataFrame)
  }
  
  DateTimeClasses <- c('Date','POSIXlt','POSIXct')
  
  for (i in 1:length(DataFrame)) {
    if(class(DataFrame[,i]) %in% DateTimeClasses){
      DateColumnNumber = i
    }
  }
  
  DataFrameConverted <- xts(DataFrame[,-DateColumnNumber], 
                            order.by=DataFrame[,DateColumnNumber])
}

############################################################

XTStoTSremoveLeapYear <- function(XTSobject){
  
  # add instal packages
  # Remove 29-02 - leap day
  XTSobject_withoutLeapDays <-
    XTSobject[!(lubridate::month(index(XTSobject)) == 2 & 
                  lubridate::day(index(XTSobject))==29)]
  
  TSobject <- TSstudio::xts_to_ts(XTSobject_withoutLeapDays)
}

############################################################

XTStoTSremoveLeapYear1d <- function(XTSobject, SetFrequncy = 365){
  
  # Only for daily data
  # Remove 29-02 - leap day
  XTSobject_withoutLeapDays <-
    XTSobject[!(lubridate::month(index(XTSobject)) == 2 & 
                  lubridate::day(index(XTSobject))==29)]
  
  TemporalDF = data.frame(Colname = coredata(XTSobject_withoutLeapDays))
  begin = c(year(index(XTSobject_withoutLeapDays)[1]) ,
            yday(index(XTSobject_withoutLeapDays)[1]) )

  TSobject  <- ts(TemporalDF$Colname, 
                  start = begin,
                  frequency = SetFrequncy)
}

############################################################

CreateDateSequence <- function(TSobject){
  
  StartDate <- paste0(start(TSobject)[1],start(TSobject)[2]) %>% 
    as.Date(format('%Y %j'))
  
  EndDate <- paste0(end(TSobject)[1],end(TSobject)[2]) %>% 
    as.Date(format('%Y %j'))

  if (lubridate::leap_year(StartDate) & lubridate::month(StartDate) >= 3 ){
    StartDate = StartDate + 1
  }
    
  if(lubridate::leap_year(EndDate) & lubridate::month(EndDate) >= 3 ){
    EndDate = EndDate + 1
  }  
    
  DateSeqence <- seq.Date(StartDate, EndDate, by = 'day')
}

############################################################

TStoDataFrame <- function(TSobject){
  
  DateSequence <- CreateDateSequence(TSobject)
  
  DateSequenceWithoutLeapDays <- 
    DateSequence[!(lubridate::month(DateSequence) == 2 &
                   lubridate::day(DateSequence)==29)]
  
  DateFrameObject <- cbind(Date = DateSequenceWithoutLeapDays, 
              as.data.frame(TSobject ))
  return(DateFrameObject)
}

############################################################

ForecastToDataFrame <- function(FORECASTobject){
  
  DateBeseSeries <- FORECASTobject$x %>% CreateDateSequence()
  DateFittedSeries <- FORECASTobject$fitted %>% CreateDateSequence() 
  DatePredictedSeries <- FORECASTobject$mean %>% CreateDateSequence()
  
  DateBeseSeriesWithoutLeapDays <- 
    DateBeseSeries[!(lubridate::month(DateBeseSeries) == 2 & 
                       lubridate::day(DateBeseSeries)==29)]
  
  DateFittedSeriesWithoutLeapDays <- 
    DateFittedSeries[!(lubridate::month(DateFittedSeries) == 2 & 
                         lubridate::day(DateFittedSeries)==29)] 
  
  DatePredictedSeriesWithoutLeapDays <- 
    DatePredictedSeries[!(lubridate::month(DatePredictedSeries) == 2 & 
                            lubridate::day(DatePredictedSeries)==29)]
    
  BaseSeries <- cbind(Date = DateBeseSeriesWithoutLeapDays, 
                      as.data.frame(FORECASTobject$x))
  Fitted <- cbind(Date = DateFittedSeriesWithoutLeapDays, 
                  as.data.frame(FORECASTobject$fitted))  
  Predicted <- cbind(Date = DatePredictedSeriesWithoutLeapDays, 
                     as.data.frame(FORECASTobject$mean))  
  
  StartDateMain <- BaseSeries[1,'Date']
  EndDateMain <- Predicted[nrow(Predicted),'Date']
  
  Date <- seq.Date(StartDateMain, EndDateMain, by = 'day')
  
  FORECASTobjectTransformedToDataFrame <-
    as.data.frame(Date) %>% 
    left_join(BaseSeries, by = 'Date') %>% 
    left_join(Fitted, by = 'Date') %>% 
    left_join(Predicted, by = 'Date')
  
  names(FORECASTobjectTransformedToDataFrame) <- c('Date','BaseSeries',
                                                   'Fitted','Predicted')
  return(FORECASTobjectTransformedToDataFrame)
}




