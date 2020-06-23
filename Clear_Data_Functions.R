# Install Require Packages
  if (!require("dplyr")) install.packages("dplyr")

  InstallPackagesGIT <- 'https://raw.githubusercontent.com/kamilbanas85/R_usefull_functions/master/Install_And_Load_Packages.R'
  devtools::source_url(InstallPackagesGIT)

  PackagesList <- c('dplyr')
  InstallAndLoadRequirePackages(PackagesList)
# install.packages('TSstudio')
  rm(PackagesList, InstallPackagesGIT)




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
