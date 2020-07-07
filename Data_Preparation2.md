# Install Require Packages And Functions:

<ul>
```r
if(!"devtools" %in% installed.packages()) install.packages("devtools")

InstallPackagesGIT <-
'https://raw.githubusercontent.com/kamilbanas85/R_usefull_functions/master/Install_And_Load_Packages.R'
ClearDataGIT <-   
'https://raw.githubusercontent.com/kamilbanas85/R_usefull_functions/master/Clear_Data_Functions.R'
DataTranformationGIT <-
'https://raw.githubusercontent.com/kamilbanas85/R_usefull_functions/master/Data_Transformation.R'

devtools::source_url(InstallPackagesGIT)
devtools::source_url(ClearDataGIT)
devtools::source_url(DataTranformationGIT)

listOfPackages <- c('dplyr', 'ggplot2', 'tidyr','xts')
InstallAndLoadRequirePackages(listOfPackages)

rm(InstallPackagesGIT, ClearDataGIT, DataTranformationGIT, listOfPackages)
```

</ul>


```{r, include=FALSE}
listOfPackages2 <- c('EIAdata')
InstallAndLoadRequirePackages(listOfPackages2)
rm(listOfPackages2)
```

```{r, include=FALSE}
# Download Data

MyEIAapiKey <- 'afff06a7487250d16b281fc6a6e50b94'
series_id='NUC_STATUS.OUT.US.D'
#https://www.eia.gov/opendata/qb.php?category=2889994&sdid=NUC_STATUS.OUT.US.D

US_Nuclear_Outages_XTS_imported <- getEIA(series_id, MyEIAapiKey)
plot(US_Nuclear_Outages_XTS_imported)

US_Nuclear_Outages_DF <- US_Nuclear_Outages_XTS_imported %>% 
data.frame(Date =index(.)) %>% 
  tibble::remove_rownames() %>% 
  select('Date', everything()) 

names(US_Nuclear_Outages_DF) <- c('Date', 'ColumnName')

DataFrameEx <- US_Nuclear_Outages_DF
```

<font size="5">**Check data in general:**</font>
  <ul>
   ```{r,  error=FALSE, warning=FALSE, message=FALSE}
    DataFrameEx %>% glimpse()
    ```
  
**Plot data:**

   ```{r, error=FALSE, warning=FALSE, message=FALSE}
    DataFrameEx %>% ggplot() + geom_line(aes(Date, ColumnName))
  
    ```
</ul>


<font size="5">**Repair 'Date' column:**</font>
<ul>
- remove NA from the top and bottom data
- complite missing dates
- remove dupicated dates


 **Check top and bottom values:**
 <ul>
  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}

  DataFrameEx %>% head()
  DataFrameEx %>% tail()
  ```
  If missing some top and bottom Dates -> remove it (function from  'Clear_Data_Functions.R' on GitGub):
  
  <ul>
  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  DataFrameEx <- DataFrameEx %>% 
      RemoveTopAndBottomRowsWithNA(columnName = Date)
  ```
  </ul>

 </ul>
  
 
 **Check dupicates on 'Date' column:**
 <ul>

  Extract duplicated elements:
  <ul>

  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  DataFrameEx %>% .[duplicated(.), 'Date']
  ```
  </ul>
       

  Remove duplicates based on 'Date' column:
  <ul>
      
  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  DataFrameEx <- DataFrameEx %>% 
                      .[!duplicated(.$Date), ]
  ```
  
  or using a function from 'dplyr':
  
  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  DataFrameEx %>% distinct(Date, .keep_all = TRUE)
  ```
  </ul>
 </ul>
    
    
 **Complate 'Date' column - replace 'NA', 'None' etc.:**
 <ul>
 Check missing data in 'Date' column to knwolage:
  <ul>
  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  is.na(DataFrameEx$Date) %>% table()  
  ```
  </ul>
 Fill 'Date' column with sequence of dates:
  <ul>
  ```{r, results='hide', error=FALSE, warning=FALSE, message=FALSE}
  DataFrameEx <- DataFrameEx %>% 
                    tidyr::complete(Date = seq.Date(min(Date, na.rm = TRUE),
                                      max(Date, na.rm = TRUE), by = 'day'))
  ``` 
  </ul>
  
 </ul>
 
</ul>


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


