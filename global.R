# TCU trend analysis - global 

# Define global variables
mes <<- " "
LDF <<- NULL
files.df <- NULL
limit.df <- data.frame(name = c("No limit", 
                                "Refrigerator [2, 8]", 
                                "Fridge [-20, -15]", 
                                "ULT-fridge [-90, -70]"),
                       min = c(NA, 2,-20, -90),
                       max = c(NA, 8, -15, -70), 
                       stringsAsFactors = F)

preprocessFileDF <- function(f.df) {
  # Extract date
  f.df <- f.df %>% mutate(date = lubridate::parse_date_time(substr(x = name, start = 1, stop = 9), "Ymd"))
  f.df$date <- format(f.df$date,'%Y-%m-%d')
  
  # Extract eqp_no
  f.df <- f.df %>% mutate(eqp_no = substr(x = name, start = 20, stop = 25))
  
  # Extract test iteration
  f.df <- f.df %>% mutate(iter = substr(x = name, start = 35, stop = 37))
  
  # Arrange
  f.df <- f.df %>% arrange(as.integer(iter))
  
  return(f.df)
}

validateFileDF <- function(f.df) {
  # 1. Check if names are duplicate
  if(length(unique(f.df$name)) != nrow(f.df)) return("duplicate file names")

  # 2. Check if all names are length X
  if(all(nchar(f.df$name) != 41)) return("file names length are not equal to 41")
  
  # 3. Check if all dates are unique
  if(length(unique(f.df$date)) != nrow(f.df)) return("duplicate date")
  
  # 4. Multiple equipment numbers
  if(length(unique(f.df$eqp_no)) != 1) return("multiple EQP numbers")
  
  # 5. Check if no iter versions are the same
  if(length(unique(f.df$iter)) != nrow(f.df)) return("duplicate iter numbers")
  return()
}

# Validate
validateData <- function(f.df) {
  for(i in 1:nrow(f.df)) {
    df <- read.csv2(f.df$datapath[i], stringsAsFactors = F, dec = ".")
    
    # 1. Count number of rows
    f.df[i, "nrow"] <- nrow(df) == 9
    
    # 2. Check if columns are available
    f.df[i, "column_names"] <- all(colnames(df) == c("Channel", "Minimum", "Maximum", "Average", "Standard.deviation", "Alarms", "MKT"))
    
    # 3. Check columns class
    f.df[i, "column_types"] <- all(unname(sapply(df, class)) == c("character", "numeric", "numeric", "numeric", "numeric", "integer", "numeric"))
    
    # 4. Check for empty cells
    f.df[i, "complete"] <- !(any(df == "", na.rm = T) | any(is.na(df)))
  }
  
  return(f.df)
}

preprocessData <- function(f.df) {
  WDF <- do.call(rbind, mapply(function(i) {
    # Load file, add date as column and filter irrelevant columns
    df <- read.csv2(f.df$datapath[i], stringsAsFactors = F, dec = ".")
    df <- df %>% 
      mutate(date = f.df$date[i]) %>% 
      select(date, Channel, Minimum, Maximum, Average)
    
    return(df)
  }, 1:nrow(f.df), SIMPLIFY = F))
  
  return(WDF)
}

plotTrend <- function(LDF) {
  p <- ggplot(LDF, aes(x = date, y = value, shape = variable, colour = Channel)) +
    geom_point() +
    geom_line() +
    labs(x = "Date",
         y = "Temperature (°C)",
         colour = "Channel",
         shape = "Variable",
         title = paste0("Probe analysis of ", EQP_NO)) +
    theme_bw()
  return(p)
}

plotSubTrend <- function(LDF, limit, size = 14) {
  mini <-limit.df %>% filter(name == limit) %>% pull(min)
  maxi <-limit.df %>% filter(name == limit) %>% pull(max)
  
  p <- ggplot(LDF %>% mutate(variable = factor(variable, levels = c("Maximum", "Average", "Minimum"))), 
              aes(x = date, y = value, colour = variable)) +
    geom_point(size = 3) +
    geom_line() +
    labs(x = "Date",
         y = "Temperature (°C)",
         colour = "Statistic",
         title = EQP_NO) +
    facet_wrap(~Channel) +
    scale_x_datetime(limits = c(as.POSIXct(lubridate::floor_date(min(LDF$date), "year")),
                                as.POSIXct(lubridate::ceiling_date(max(LDF$date), "year"))),
                     expand = c(0.1, 0.1)) +
    scale_y_continuous(expand = c(0.07, 0.07)) +
    theme_bw() + 
    theme(text = element_text(size = size)) +
    scale_color_manual(values=c("red", "green", "blue"))
  
  if(limit != "No limit") {
    p <- p + geom_hline(yintercept = mini, linetype = "dashed", col = "blue") + 
      geom_hline(yintercept = maxi, linetype = "dashed", col = "red")
  }
  
  return(p)
}
