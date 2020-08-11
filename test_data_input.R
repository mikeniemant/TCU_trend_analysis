# TCU trend analysis - test data input

# Prepare work environment ----
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

# Preprocess data ----
# Extract all data
files <- list.files(TEST_PATH)[c(2, 4)]

# Apply the same methodology shiny import file functionality uses
f.df <- data.frame(name = files, 
                   size = 486,
                   type = "text/csv",
                   stringsAsFactors = F)

f.df <- f.df %>% mutate(datapath = paste0(TEST_PATH, f.df$name))

f.df <- preprocessFileDF(f.df) 

# Validate output ----
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

# Plot trending ----
print(plotSubTrend(LDF, limit = "None", size = 7))
print(plotSubTrend(LDF, limit = "Refrigerator [2, 8]", size = 7))

# Include the correction factor ----
# Import all cf sheets
CF_PATH <- paste0(PATH, "documents/Cross-table correction factors meetset.xlsx")
tabs <- readxl::excel_sheets(CF_PATH)

cf.df <- do.call(rbind, mapply(function(t) {
  df <- readxl::read_xlsx(path = CF_PATH, sheet = t, skip = 1, col_types = "numeric", progress = F)
  names(df)[1] <- "label"
  df <- df %>% 
    mutate(cf_date = t) %>% 
    select(cf_date, everything()) %>% 
    gather(probe, factor, -cf_date, -label)
  return(df)
}, t = tabs, SIMPLIFY = F))

# Extract radar button value
x = "Refrigerator [2, 8]"
y = limit.df %>% filter(name == x) %>% pull(cf_label)
cf.df %>% filter(label == y)

LDF <- LDF %>% 
  mutate(probe = substr(Channel, 0, 2),
         cf_date = substr(date, 1,7)) %>% 
  select(date, probe, everything())

# Add correction factor as column
LDF <- LDF %>% 
  left_join(cf.df %>% filter(label == y), by = c("probe")) %>% 
  mutate(new_value = value + factor)

# 
# Above works, but the date from 2020 is used for all time points

# Evaluate the date ----
# Rebuild df
LDF <<- WDF %>% gather(variable, value, -date, -Channel) %>% 
  mutate(date = as.POSIXct(date))
LDF <- LDF %>% 
  mutate(probe = substr(Channel, 0, 2)) %>% 
  select(date, probe, everything())

# Extract radar selection and the corresponidng cf_label from limit.df
x = "Refrigerator [2, 8]"
y = limit.df %>% filter(name == x) %>% pull(cf_label)

# Identify unique dates and create dummy
u.cf.dates <- unique(cf.df$cf_date)
u.cf.dates <- as.POSIXct(paste0(u.cf.dates, "-01"), format = "%Y-%m-%d")
u.cf.dates <- c(u.cf.dates, as.POSIXct("9999-01-01")) 

# TODO: make sure that the u.cf.date and the y are processed
LDF <- applyCorrectionFactor(LDF)

print(plotSubTrend(LDF, limit = "Refrigerator [2, 8]", size = 7))

# Tests ----
# Test 1
f.df <- rbind(f.df, f.df[2, ])
if(!is.null(validateFileDF(f.df))) {
  print(validateFileDF(f.df))
}

