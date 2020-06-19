RemoveFewTopAndBottomRowsWhichContainsNA <- function(DataFrame, 
                                         columnName){
  
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


# Functions to replace NA:
#
#   fill() - replace NA with previous or next value
#   replace_na() - 
#   DataFrame$ColName[is.na(DataFrame$ColName)] <- 0
#
#
#   na.omit() - remove row with NA based on all data or specific column
#   DataFrame %>% drop_na(ColumnName) - remove rows with NA in sepecific column
#
#
#   library(xts)
#
#   na.locf() - fill missing NA observations with a last or next known value
#   na.aprox() - fill with linear interpolation

#
#   cHECK duplicates in dates column
# 


