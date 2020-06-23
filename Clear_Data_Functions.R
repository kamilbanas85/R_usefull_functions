  # If is not installed -> Install
    if (!require("dplyr"))     install.packages("dplyr", dep = TRUE)
  # Load Package if no loaded
    require(dplyr)




RemoveTopAndBottomRowsWithNA <- function(DataFrame, columnName){
  
  columnName <- deparse(substitute(columnName))

  for (i in 1:nrow(DataFrame)) {
    if( is.na(DataFrame[1,columnName]) ){
      DataFrame <- DataFrame %>% .[-1,]
    } else{break}
  }
  
  for (i in 1:nrow(DataFrame)) {
    if( is.na(DataFrame[nrow(DataFrame),columnName]) ){
      DataFrame <- DataFrame %>% .[-nrow(.),]
    } else{break}
  }  
  
  return(DataFrame)  
}

####################################################################

RemoveTopRows <- function(DataFrame, numberOfRows){
  
  DataFrame <- DataFrame %>% .[-(1:numberOfRows), ]
  
  return(DataFrame)
}

####################################################################

RemoveBottomRows <- function(DataFrame, numberOfRows){
  
  DataFrame <- DataFrame %>% 
    .[-( (nrow(.)-numberOfRows+1):nrow(.) ), ]
  
  return(DataFrame)
}
