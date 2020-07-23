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
  titlePanel(title = "TCU trend analysis | V 0.0.2"),
  
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
  # File uploaded global boolean ----
  output$file_uploaded <- reactive({
    # Extract imputed files
    f.df <<- input$input_files
    
    # If f.df is not NULL (global setting), "if files are selected.."
    if(!is.null(f.df)) {
      # Preprocess files df
      f.df <<- preprocessFileDF(f.df)
      mes <- validateFileDF(f.df)
      
      # Render files df
      output$input_files_table <- DT::renderDataTable(f.df %>% select(-datapath, -size, -type), 
                                                      options = list(dom = 't'))
      
      if(!is.null(mes)) {
        print(mes)
        output$mes <- renderText(paste0("Incorrect file input: ",
                                        mes))
        
        return(F)
      } else{
        EQP_NO <<- f.df$eqp_no[1]
        
        # Preprocess data
        WDF <- preprocessData(f.df)
        
        # Gather data frame and change date column to posix
        LDF <<- WDF %>% gather(variable, value, -date, -Channel) %>% 
          mutate(date = as.POSIXct(date))
        return(T)
      }  
    }
  })
  
  outputOptions(output, 'file_uploaded', suspendWhenHidden=FALSE)
  
  # Sidebar ----
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
  
  # Main ----
  source(file.path("server", "server_main.R"),  local = TRUE)$value
  
  # Plot ----
  source(file.path("server", "server_plot.R"),  local = TRUE)$value
})

# Run application 
shinyApp(ui = ui, server = server)
