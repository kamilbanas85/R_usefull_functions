InstallAndLoadRequirePackage <- function(PackageRequire){
    
    if(!require(PackageRequire, character.only = TRUE)){
    
      install.packages(PackageRequire, dep = TRUE) ;
    }
    
    require(PackageRequire, character.only = TRUE)
}


InstallAndLoadRequirePackages <- function(PackageListRequire){
  
  invisible(lapply(PackageListRequire, LoadAndInstallRequirePackage))
}
