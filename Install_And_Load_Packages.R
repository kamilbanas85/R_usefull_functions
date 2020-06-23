# Auxiliary Function:
InstallAndLoadRequirePackage <- function(PackageRequire){
    
    # If is not installed -> Install
    if(!require(PackageRequire, character.only = TRUE)){
      install.packages(PackageRequire, dep = TRUE) ;
    }
    
    # Load Package
    require(PackageRequire, character.only = TRUE)
}

# Main Function:
InstallAndLoadRequirePackages <- function(PackageListRequire){
    
    invisible(lapply(PackageListRequire, InstallAndLoadRequirePackage))
}

# Example:  
#   ListOfPackage <- listOfPackages <- c('dplyr','lubridate')
#   InstallAndLoadRequirePackages(ListOfPackage)



######### INSTALL ONLY PACKAGES IF THERE ARE NOT INSTALLED
