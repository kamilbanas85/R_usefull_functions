# Auxiliary Function:
InstallAndLoadRequirePackageAuxiliaryFun <- function(PackageRequire){
    
    # If is not installed -> Install
    if(!require(PackageRequire, character.only = TRUE)){
      install.packages(PackageRequire, dep = TRUE) ;
    }
    
    # Load Package
    require(PackageRequire, character.only = TRUE)
}

# Main Function:
InstallAndLoadRequirePackages <- function(PackageRequireList){
    
    invisible(lapply(PackageRequireList, InstallAndLoadRequirePackageAuxiliaryFun))
}

# Example:  
#   ListOfPackage <- listOfPackages <- c('dplyr','lubridate')
#   InstallAndLoadRequirePackages(ListOfPackage)



######### INSTALL ONLY PACKAGES IF THERE ARE NOT INSTALLED

InstallPackageAuxiliaryFun <- function(PackageToInstall){
  
  if(!PackageToInstall %in% installed.packages()){
          install.packages(PackageToInstall)
  } 
} 


InstallPackages <- function(PackageToInstallList){
  
  invisible(lapply(PackageToInstallList, InstallPackageAuxiliaryFun))
} 
