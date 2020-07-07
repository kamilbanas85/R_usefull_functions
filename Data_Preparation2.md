# Install Require Packages And Functions:

  ```r
    if(!"devtools" %in% installed.packages()) install.packages("devtools")

    InstallPackagesGIT <- 'https://raw.githubusercontent.com/kamilbanas85/R_usefull_functions/master/Install_And_Load_Packages.R'
    ClearDataGIT <- 'https://raw.githubusercontent.com/kamilbanas85/R_usefull_functions/master/Clear_Data_Functions.R'
    DataTranformationGIT <- 'https://raw.githubusercontent.com/kamilbanas85/R_usefull_functions/master/Data_Transformation.R'

    devtools::source_url(InstallPackagesGIT)
    devtools::source_url(ClearDataGIT)
    devtools::source_url(DataTranformationGIT)

    listOfPackages <- c('dplyr', 'ggplot2', 'tidyr','xts')
    InstallAndLoadRequirePackages(listOfPackages)

    rm(InstallPackagesGIT, ClearDataGIT, DataTranformationGIT, listOfPackages)
  ```

# Check data in general:
 * Display data:
   ```r
   DataFrameEx %>% glimpse()
   ```
 * Plot data:
   ```r 
    DataFrameEx %>% ggplot() + geom_line(aes(Date, ColumnName))
   ```

# Repair 'Date' column:
 * ## Remove NA from the top and bottom data:
     Check top and bottom values:
     ```r
     DataFrameEx %>% head()
     DataFrameEx %>% tail()
     ```
     If missing some top and bottom Dates -> remove it (function from  'Clear_Data_Functions.R' on GitGub):
     ```r
     DataFrameEx <- DataFrameEx %>% 
                    RemoveTopAndBottomRowsWithNA(columnName = Date)
     ```
 * ## Complite missing dates:
      ### Check dupicates on 'Date' column:
      * Extract duplicated elements:
      ```r
      DataFrameEx %>% .[duplicated(.), 'Date']
      ```
 * ## Remove dupicated dates:
      * Remove duplicates based on 'Date' column:
      ```r
      DataFrameEx <- DataFrameEx %>% 
                      .[!duplicated(.$Date), ]
      ```
      * or using a function from 'dplyr':
      ```r
      DataFrameEx %>% distinct(Date, .keep_all = TRUE)
      ```
    
 **Complate 'Date' column - replace 'NA', 'None' etc.:**
 Check missing data in 'Date' column to knwolage:
  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  is.na(DataFrameEx$Date) %>% table()  
  ```
 Fill 'Date' column with sequence of dates:
  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  DataFrameEx <- DataFrameEx %>% 
                    tidyr::complete(Date = seq.Date(min(Date, na.rm = TRUE),
                                      max(Date, na.rm = TRUE), by = 'day'))
  ``` 



<font size="5">**Repair rest of a data**</font>
<ul>
- remove NA from the top and bottom data
- fill missing datas

 **Functions to replace NA:**
 <ul>
  
  **fill()** - replace NA with previous or next value. Example:
  
  <ul>
  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  DataFrameEx <- DataFrameEx %>% 
                      fill(ColumnName)
  ```
  </ul>
  
  **replace_na()** - replace NA with specified value. Example, replace with '0'
  
  <ul>
  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  DataFrameEx <- DataFrameEx %>% 
                      mutate(ColumnName = replace_na(ColumnName, 0))
  ```
  </ul>
  
  **Direct replacemnt**
  
  <ul>
  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  DataFrameEx$ColumnName[is.na(DataFrameEx$ColumnName)] <- 0
  ```
  </ul>
  
  **xts::na.locf()** - fill NA with a last or next known value. Example, ( DataFrameToXTS from 'Data_Transformation' functions):
  <ul>

  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  DataFrameEx %>% 
        DataFrameToXTS() %>% 
        na.locf()
  ```
  </ul>
**xts::na.approx()** - fill NA with linear interpolation. Example, ( DataFrameToXTS from 'Data_Transformation' functions):
  <ul>

  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  DataFrameEx %>% 
        DataFrameToXTS() %>% 
        na.approx()
  ```
  </ul>  
  
 </ul>


 **Functions to remove NA:**
 <ul>
  
  **na.omit()** - remove row with NA based on all data or specific column. Example:
  
  <ul>
  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  DataFrameEx <- DataFrameEx %>% 
                      na.omit()
  ```
  </ul>
  
  **drop_na()** - remove rows with NA in sepecific column. Example:
  
  <ul>
  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  
  DataFrameEx <- DataFrameEx %>% 
                      drop_na(ColumnName)
  ```
  </ul>
  
 </ul>


</ul>


