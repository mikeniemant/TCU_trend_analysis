# TCU trend analysis - global 

# Define global variables
LDF <<- NULL
files.df <- NULL
mm.df <- data.frame(name = c("No line", 
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
  
  return(f.df)
}

validateFileDF <- function(f.df) {
  # From all csv files, extract information from file name
  sapply(f.df[, "name", T] , function(x) substr(x = x, start = nchar(x)-3, stop = nchar(x)), USE.NAMES = F)
  
  # Check if all names are length X
  if(all(nchar(f.df$name) != 41)) {
    print("error")
  }
  
  if(length(unique(f.df$date)) != nrow(f.df)) print("error")
  
  # Check if all eqp_no are the same
  if(length(unique(f.df$eqp_no)) != 1) {
    print("error")
  } else {
    EQP_NO <- f.df$eqp_no[1]
  }
  
  # Check if no iter versions are the same
  if(length(unique(f.df$iter)) != nrow(f.df)) print("error")
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
         y = "Value",
         colour = "Channel",
         shape = "Variable",
         title = paste0("Probe analysis of ", EQP_NO)) +
    theme_bw()
  return(p)
}

plotSubTrend <- function(LDF, mm, size = 15) {
  mini <- mm.df %>% filter(name == mm) %>% pull(min)
  maxi <- mm.df %>% filter(name == mm) %>% pull(max)
  
  p <- ggplot(LDF %>% mutate(variable = factor(variable, levels = c("Maximum", "Minimum", "Average"))), 
         aes(x = date, y = value, colour = variable)) +
    geom_point(size = 3) +
    geom_line() +
    geom_hline(yintercept = mini, linetype = "dashed", col = "blue") + 
    geom_hline(yintercept = maxi, linetype = "dashed", col = "red") + 
    labs(x = "Date",
         y = "Value",
         colour = "Statistic",
         title = EQP_NO) +
    facet_wrap(~Channel) +
    theme_bw() + 
    theme(text = element_text(size = size)) +
    scale_color_manual(values=c("red", "blue", "green"))
  
  return(p)
}
