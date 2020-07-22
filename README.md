# TCU trend analysis

## Description
R Shiny app to plot temperature control unit (TCU) trend analysis.

## Installation

Install the latest R version, the necessary libraries and fork repo from GitHub.

Libraries

- shiny
- shinydashboard
- shinyFiles
- dplyr
- tidyr
- plotly

## Usage
Start terminal and set directory to forked directory. Launch the with the following command

`R -e "shiny::runApp('DIR_APP', port = 8888)"`

Go the your browser: http://127.0.0.1:8888

## Preprocess methodology

User selects specific directory (DIR) that only contains the necessary files for one test unit (freezer, fridge)

App imports all files in DIR and defines information from file names in data frame (FILES.DF). Performs the following validation steps

1. DIR is not empty
2. Length file name characters are of X length
3. No files with duplicate names
4. File name ends with ".csv""
5. File is not empty
6. File contains two columns
7. (File contains tab name "*results*")
8. Check columns
  - date column --> date
  - value column --> numeric
9. 

Visualize validation steps in the main tab

- date
- name
- iteration
- etc.

From each imported file, app preprocessed the data and adds to data frame (DATA.DF)

- What are these steps?

## Todo list:
- Add functionality to automatically install/updates packages
- Validate program with a jenkins server
- correctiefactor
- validation steps

## License
TCU trend analysis is under the APACHE-II license
