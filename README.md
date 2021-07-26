# TCU trend analysis

RShiny: [![Binder](http://mybinder.org/badge_logo.svg)](http://mybinder.org/v2/gh/mikeniemant/TCU_trend_analysis/master?urlpath=shiny/app/)

## Description
R Shiny app to plot temperature control unit (TCU) trend analysis.

## Installation

Install the latest R version, the necessary libraries and fork repo from GitHub.

Packages: DT, shiny, shinydashboard, shinyFiles and tidyverse

## Usage
Start terminal and set directory to forked directory. Launch the app with the following command:

`R -e "shiny::runApp('DIR_APP', port = 8888)"`

Go the your browser: http://127.0.0.1:8888

## Preprocess methodology

In the app, user can browse directories to selects files from a particular directory for one test unit (freezer, fridge)

App imports all selected files  and extracts information from file names into data frame (f.df). Performs the following validation steps:

1. Check if names are duplicated
2. Check if all names are length 41
3. Check if all dates are unique
4. Multiple equipment numbers
5. Check if no iter versions are the same

If all file validation checks pass, preprocess the data and perform the following checks:

1. Count number of rows
2. Check if file contains the following columns:
  - 'Channel': probe name (character)
  - 'Minimum': value (numeric, point delimiter)
  - 'Maximum': value (numeric, point delimiter)
  - 'Average': value (numeric, point delimiter)
  - 'CORRECTIE_FACTOR': value (numeric, point delimiter)
3. Check columns class (as shown in the previous step)
4. Check for empty cells

If all data validation checks pass, preprocess the data and plot output.

## Todo list:
- add/deduce correction factor?
- change graph order
- Read main/SkylineDx/Specifications/SWP
- Sop IT 048
- SWP 001 / SWP 002
- Paragraphs
  - Introduction
  - Software description
  - Related documents
  - Document history
- URS: user requirements specification
- SRD (software requirements document) --> software development plan (SDP)

## License
TCU trend analysis is under the APACHE-II license
