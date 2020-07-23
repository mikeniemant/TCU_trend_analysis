# TCU trend analysis

## Description
R Shiny app to plot temperature control unit (TCU) trend analysis.

## Installation

Install the latest R version, the necessary libraries and fork repo from GitHub.

Libraries:

- shiny
- shinydashboard
- shinyFiles
- dplyr
- tidyr
- ggplot2

## Usage
Start terminal and set directory to forked directory. Launch the with the following command

`R -e "shiny::runApp('DIR_APP', port = 8888)"`

Go the your browser: http://127.0.0.1:8888

## Preprocess methodology

User selects specific directory (DIR) that only contains the necessary files for one test unit (freezer, fridge)

App imports all selecte dfiles  and defines information from file names in data frame (f.df). Performs the following validation steps

1. Check if names are duplicate
2. Check if all names are length 41
3. Check if all dates are unique
4. Multiple equipment numbers
5. Check if no iter versions are the same

If all checks pass, preprocess the data and perform the following checks:

1. File it not empty
2. File contains the columns 
  - 'Channel': probe name (character)
  - 'Minimum': value (numeric, point delimiter)
  - 'Maximum': value (numeric,  delimiter)
  - 'Average': value (numeric,  delimiter)
  - 'CORRECTIE_FACTOR': value (numeric, delimiter)
3. Each row has values for each column

## Todo list:
- Add functionality to automatically install/updates packages in the install CMD file
  - install nbs
  - nbs::importPackages("shiny", "shinydashboard", "shinyFiles", "dplyr", "tidyr", "ggplot2")
  - install app
- correctiefactor
- include the data preprocess validation steps

## License
TCU trend analysis is under the APACHE-II license
