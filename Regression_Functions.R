  # If is not installed -> Install
    if (!require("dplyr"))     install.packages("dplyr", dep = TRUE)
    if (!require("ggplot2"))       install.packages("ggplot2", dep = TRUE)
  # Load Package if no loaded
    require(dplyr)
    require(ggplot2)


PlotFittedPredictedAndForecastData <- function(DataTrained,
                                               DataTested = NULL,
                                               DataForecast = NULL,
                                               MODEL,
                                               varaibleIndicator,
                                               yAxisLabel = NULL
                                               TitleName = NULL){
  
  varaibleIndicator = enquo(varaibleIndicator)
  
  DataToReturn <- DataTrained %>% 
    cbind(value = fitted(MODEL)) %>% 
    transmute(Date, !!varaibleIndicator, value, type = 'Fitted - Train Set')
  
  if(!is.null(DataTested)){
    DataToReturn <- DataToReturn %>% 
      rbind(DataTested %>% 
              cbind(value = predict(MODEL, DataTested)) %>% 
              transmute(Date, !!varaibleIndicator, value, type = 'Predicted - Test Set')
            )
  }
  
  if(!is.null(DataForecast)){
    DataToReturn <- DataToReturn %>% 
      bind_rows(DataForecast %>% 
                  cbind(value = predict(MODEL, DataForecast)) %>% 
                  transmute(Date, value, type = 'Forecast')
                )
  }
  
  PlotInside <- DataToReturn %>% 
    ggplot() +
    geom_line(aes(Date, !!varaibleIndicator, color = 'Messured Data')) +
    geom_line(aes(Date, value, color = type)) +
    theme_minimal() +
    ylab(yAxisLabel) +
    ggtitle(TitleName) +
    theme(plot.title = element_text(hjust = 0.5), text = element_text(size = 17)) +
    theme(legend.title = element_blank())
  
  if( is.null(DataTested) & is.null(DataForecast) ){
    PlotInside <- PlotInside +
      scale_color_manual(name = '', values = c('Fitted - Train Set'='blue',
                                               'Messured Data'='black'))
  } else if( !is.null(DataTested) & is.null(DataForecast) ){
    PlotInside <- PlotInside +
      scale_color_manual(name = '', values = c('Fitted - Train Set'='blue',
                                               'Predicted - Test Set'='green',
                                               'Messured Data'='black'))
  } else if( is.null(DataTested) & !is.null(DataForecast) ){
    PlotInside <- PlotInside +
      scale_color_manual(name = '', values = c('Fitted - Train Set'='blue',
                                               'Messured Data'='black',
                                               'Forecast'='red'))
  } else if( !is.null(DataTested) & !is.null(DataForecast) ){
    PlotInside <- PlotInside +
      scale_color_manual(name = '', values = c('Fitted - Train Set'='blue',
                                               'Predicted - Test Set'='green',
                                               'Messured Data'='black',
                                               'Forecast'='red'))
  }
  
  print(PlotInside)
  return(invisible(DataToReturn))
}

########################################################################

MakeTrainDataSetForLaggedAnalysis <- function(TrainData,
                                              NumberOfLags,
                                              varaibleIndicator){
  
  varaibleIndicator = enquo(varaibleIndicator)
  TrainDataWithLags <- TrainData
  
  for(i in 1:NumberOfLags){
    
    TrainDataWithLags[,paste0('Lag',i)] <- TrainData %>% 
      transmute(temporary = lag(!!varaibleIndicator,i))
    
  }
  
  TrainDataWithLags %>% 
    .[-(1:NumberOfLags),]
  
}

########################################################################

MakeTestDataSetForLaggedAnalysis <- function(TrainData,
                                             TestData,
                                             NumberOfLags,
                                             varaibleIndicator){
  
  varaibleIndicator = enquo(varaibleIndicator)
  TestDataWithLags <- TestData %>% mutate(predicted = NA)
  
  for(i in 1:NumberOfLags){
    
    TestDataWithLags[(1:i),paste0('Lag',i)] <- TrainData[ ( (nrow(TrainData)-i+1):
                                                              nrow(TrainData) ),] %>% 
      transmute(temporary = lag(!!varaibleIndicator,i))
  }
  
  return(TestDataWithLags)
  
}

########################################################################

PlotFittedAndPredictedDataWithLags <- function(DataTrained,
                                               DataTested,
                                               NumberOfLags = 1,
                                               MODEL,
                                               varaibleIndicator,
                                               TitleName = NULL){
  
  varaibleIndicator = enquo(varaibleIndicator)

  # !! DODAC if ze jak nrow(DataTested)
  
  for(i in 1:(nrow(DataTested)-NumberOfLags) ){
    
    DataTested[i,'predicted'] = predict(MODEL, DataTested[i,])
    
    for(j in (1:NumberOfLags)){
      DataTested[i+1,paste0('Lag',j)] <- predict(MODEL, DataTested[i,])
    }
  } 
  
  DataTrained %>% 
    cbind(value = fitted(MODEL)) %>% 
    transmute(Date, !!varaibleIndicator, value, type = 'Fitted - Train Set') %>% 
    rbind(DataTested %>% 
            transmute(Date, !!varaibleIndicator, 
                      value=predicted, type = 'Predicted - Test Set')
          ) %>% 
    ggplot()+
    geom_line(aes(Date,  !!varaibleIndicator, color = 'Messured Data')) +
    geom_line(aes(Date, value, color = 'type')) +
    scale_color_manual(name = '', values = c('Fitted - Train Set'='blue',
                                             'Predicted - Test Set'='red',
                                             'Messured Data'='black'))+
    theme_minimal() +
   # ylab(yAxisLabel) +
    ggtitle(TitleName) +
    theme(plot.title = element_text(hjust = 0.5), text = element_text(size = 17)) +
    theme(legend.title = element_blank())
  
}
