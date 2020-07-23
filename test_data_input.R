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
files <- list.files(TEST_PATH)[1:2]

# Apply the same methodology shiny import file functionality uses
f.df <- data.frame(name = files, 
                   size = 486,
                   type = "text/csv",
                   stringsAsFactors = F)

f.df <- f.df %>% mutate(datapath = paste0(TEST_PATH, f.df$name))

f.df <- preprocessFileDF(f.df) 

if(is.null(validateFileDF(f.df))) {
  print("All validation steps succesfully completed")
}

EQP_NO <<- f.df$eqp_no[1]

WDF <- preprocessData(f.df)

LDF <<- WDF %>% gather(variable, value, -date, -Channel) %>% 
  mutate(date = as.POSIXct(date))

# print(plotTrend(LDF))

print(plotSubTrend(LDF, mm = "None", size = 7))
print(plotSubTrend(LDF, mm = "Refrigerator [2, 8]", size = 7))

# Test 1
f.df <- rbind(f.df, f.df[3, ])
if(is.null(validateFileDF(f.df))) {
  print("All validation steps succesfully completed")
}
