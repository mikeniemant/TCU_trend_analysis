# TCU trend analysis - sidebar
library(shiny)
library(shinydashboard)
library(shinyFiles)
library(dplyr)
library(tidyr)
library(ggplot2)

# import global variables and functions
source("./global.R")

# UI ----
ui <- fluidPage(
  # App title
  titlePanel(title = "TCU trend analysis | V 0.0.1"),
  
  fluidRow(
    column(3,
           source(file.path("ui", "sidebar.R"), local = TRUE)$value),
    
    column(8,
           tabsetPanel(id = "tabs",
                       source(file.path("ui", "tab_main.R"),  local = TRUE)$value,
                       source(file.path("ui", "tab_plot.R"),  local = TRUE)$value
           )
    )
  )
)

# All functionality in the back-end
# Server ----
server <- shinyServer(function(input, output, session) {
  # Main tab ----
  # Define main text
  output$main_text <- renderUI({
    HTML(paste("Input file names should have the following format: 'YYYYMMMDD-RAW Data-EQP No.-FRM-084-###'",
               "Example: '2020JUL20-Raw Data REF-10-FRM-084-001.csv'", sep="<br/>"))
  })
  
  output$probe_overview <- renderImage({
    outfile <- tempfile(fileext = '.png')
    
    # Generate the PNG
    png(outfile)
    return(list(
      src = "documents/TCU_overview.png",
      contentType = "image/png",
      alt = "overview",
      width = 300, 
      height = 300))
  }, deleteFile = FALSE)
  
  # Side-bar ----
  observeEvent({
    
    input$input_files
  }, {
    # Extract imputed files
    f.df <- input$input_files
    
    # Preprocess files df
    f.df <- preprocessFileDF(f.df) 
    
    # Validate files df
    validateFileDF(f.df)
    
    EQP_NO <<- f.df$eqp_no[1]
    
    # Render files df
    output$input_files_table <- DT::renderDataTable(f.df %>% select(-datapath, -size, -type), 
                                                    options = list(dom = 't'))
    
    # Preprocess data
    WDF <- preprocessData(f.df)
    
    # Gather data frame and change date column to posix
    LDF <<- WDF %>% gather(variable, value, -date, -Channel) %>% 
      mutate(date = as.POSIXct(date))
    
    # output$wdf_output <- DT::renderDataTable(WDF)
    # output$ldf_output <- DT::renderDataTable(LDF)
  })
  
  # # Import files
  # output$file_uploaded <- reactive({
  #   output$import_message <- renderText("Please import probe files")
  #   # Get imported files
  #   f.df <<- input$input_files # data frame with columns: name, size, type, datapath
  # 
  #   # # Perform validation steps
  #   # # 1. Check if f.df not empty
  #   # if(is.null(f.df)) return(F)
  #   # 
  #   # # 2. Check for duplicate file names
  #   # n.files <- sum(unlist(lapply(f.df$name, function(x) {
  #   #   length(which(f.df$name %in% x))}
  #   # )))
  #   # 
  #   # if(n.files != nrow(f.df)) {
  #   #   output$import_message <- renderText("Double file names")
  #   #   output$input_files_table <- DT::renderDataTable(NULL)
  #   #   return(F)
  #   # }
  #   print(f.df)
  # 
    # WDF <- do.call(rbind, mapply(function(x) {
    #   # Load file, add date as column and filter irrelevant columns
    #   df <- read.csv2(paste0(TEST_PATH, f.df$file[i]), stringsAsFactors = F, dec = ".")
    #   df <- df %>%
    #     mutate(date = f.df$date[i]) %>%
    #     select(date, Channel, Minimum, Maximum, Average)
  #     
  #     return(df)
  #   }, 1:nrow(f.df), SIMPLIFY = F))
  # 
  #   # Assess validation steps
  #   # 6. Check if all Excel files have a results tab
  #   missing.results.rows <- which(if.df$`Results sheet?` == "No")
  # 
  #   if(length(missing.results.rows) > 0) {
  #     output$import_message <- renderText(paste0(ifelse(length(missing.results.rows), "File ", "Files "), missing.results.rows, " missing `Results` sheet"))
  #     output$input_files_table <- DT::renderDataTable(if.df)
  #     return(F)
  #   }
  # 
  #   # Check for empty files
  #   empty.files <<- which(if.df$`File empty?` == "Yes")
  #   if(length(empty.files) > 0) {
  #     output$import_message <- renderText(paste0(ifelse(length(empty.files) == 1, "File ", "Files "), empty.files, " no data"))
  #     output$input_files_table <- DT::renderDataTable(if.df)
  #     return(F)
  #   }
  # 
  #   # Check if all other values are valid
  #   incomplete.rows <- which(unname(apply(if.df %>% select(-`File empty?`), 2, function(x) sum(x == F)>0)))
  # 
  #   if(length(incomplete.rows) > 0) {
  #     output$import_message <- renderText(paste0(ifelse(length(incomplete.rows) == 1, "File ", "Files "), incomplete.rows, " incomplete"))
  # 
  #     output$input_files_table <- DT::renderDataTable(if.df)
  #     return(F)
  #   } else {
  #     output$import_message <- renderText(paste0("Successfully imported and pre-processed ", nrow(if.df), ifelse(nrow(if.df) == 0, " file", " files")))
  #     output$input_files_table <- DT::renderDataTable(if.df %>% select(-`Results sheet?`))
  # 
  #     # Preprocess data
  #     data.df <<- preProcessFiles(f.df)
  # 
  #     return(T)
  #   }
  # })
  
  # outputOptions(output, 'file_uploaded', suspendWhenHidden=FALSE)
  
  
  # Extract mm selected by mm radar
  mm <- reactive({
    return(input$radio_mm)
  })
  
  observeEvent({
    
    input$input_files
  }, {
    output$download_plot = downloadHandler(
      filename = function() {paste0(Sys.Date(), "_", EQP_NO, ".png")},
      content = function(file) {
        ggsave(file, width = 10, height = 6, units = "in", plot = plotSubTrend(LDF, input$radio_mm[1], size = 10), device = "png")
      }
    )
  })
  
  # Plot ----
  source(file.path("server", "server_plot.R"),  local = TRUE)$value
})

# Run application 
shinyApp(ui = ui, server = server)
