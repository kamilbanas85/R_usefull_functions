library(dplyr)
library(xts)
library(lubridate)
# install.packages('TSstudio')

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



XTStoTSremoveLeapYear <- function(XTSobject){
  
  # add instal packages
  # Remove 29-02 - leap day
  XTSobject_withoutLeapDays <-
    XTSobject[!(lubridate::month(index(XTSobject)) == 2 & 
                  lubridate::day(index(XTSobject))==29)]
  
  TSobject <- TSstudio::xts_to_ts(XTSobject_withoutLeapDays)
}



CreateDateSequence <- function(TSobject){
  
  StartDate <- paste0(start(TSobject)[1],start(TSobject)[2]) %>% 
    as.Date(format('%Y %j'))
  
  EndDate <- paste0(end(TSobject)[1],end(TSobject)[2]) %>% 
    as.Date(format('%Y %j'))

  if (lubridate::leap_year(StartDate) & lubridate::month(EndDate) >= 3 ){
    StartDate = StartDate + 1
  }
    
  if(lubridate::leap_year(EndDate) & lubridate::month(EndDate) >= 3 ){
    EndDate = EndDate + 1
  }  
    
  DateSeqence <- seq.Date(StartDate, EndDate, by = 'day')
}



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




