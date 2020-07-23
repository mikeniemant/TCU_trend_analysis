# TCU trend analysis - test data input
library(dplyr)
library(tidyr)
library(ggplot2)

# Define paths
PATH <- "/Users/michaelniemantsverdriet/Library/Mobile Documents/com~apple~CloudDocs/workspace/R/skyline_projects/TCU_trend_analysis/"
ID <- "freezer_1"
# Source functions
source(file = paste0(PATH, "global.R"))
TEST_PATH <- paste0(PATH, "test_data/", ID, "/")
dir.exists(TEST_PATH)

# Extract all data
files <- list.files(TEST_PATH)[c(1, 2)]

# Apply the same methodology shiny import file functionality uses
f.df <- data.frame(name = files, 
                   size = 486,
                   type = "text/csv",
                   stringsAsFactors = F)

f.df <- f.df %>% mutate(datapath = paste0(TEST_PATH, f.df$name))

f.df <- preprocessFileDF(f.df) 

mes <- validateFileDF(f.df)
if(is.null(mes)) {
  print("All input file alidation steps succesfully completed")
} else {
  mes
}

EQP_NO <<- f.df$eqp_no[1]

# Validate input data
f.df <- validateData(f.df)

# 
if(any(!f.df[, "nrow"])) mes <- "File does not contain output from 9 probes"
if(any(!f.df[, "column_names"])) mes <- "File does not contain all column names"
if(any(!f.df[, "column_types"])) mes <- "Column types not as expected"
if(any(!f.df[, "complete"])) mes <- "File contains empty cells"

if(is.null(mes)) {
  print("All data validation steps succesfully completed")
} else {
  mes
}

WDF <- preprocessData(f.df)

LDF <<- WDF %>% gather(variable, value, -date, -Channel) %>% 
  mutate(date = as.POSIXct(date))

# print(plotTrend(LDF))

print(plotSubTrend(LDF, limit = "None", size = 7))
print(plotSubTrend(LDF, limit = "Refrigerator [2, 8]", size = 7))

# Test 1
f.df <- rbind(f.df, f.df[2, ])
if(!is.null(validateFileDF(f.df))) {
  print(validateFileDF(f.df))
}
