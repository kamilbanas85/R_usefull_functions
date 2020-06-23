# Auxiliary Function:
InstallAndLoadRequirePackage <- function(PackageRequire){
    
    if(!require(PackageRequire, character.only = TRUE)){
      install.packages(PackageRequire, dep = TRUE) ;
    }
    
    require(PackageRequire, character.only = TRUE)
}

# Main Function:
InstallAndLoadRequirePackages <- function(PackageListRequire){
    
    invisible(lapply(PackageListRequire, LoadAndInstallRequirePackage))
}


######### INSTALL ONLY PACKAGES IF THERE ARE NOT INSTALLED
