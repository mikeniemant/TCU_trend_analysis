# TCU trend analysis - sidebar

wellPanel(
  
  conditionalPanel(condition = "input.tabs == 'main'", 
                   fileInput(inputId = "input_files", label = "", multiple = T,
                             accept = c(".csv"), placeholder = "Select files")),
  
  conditionalPanel(condition = "output.file_uploaded & input.tabs == 'plot'",
                   radioButtons(inputId = "radio_limit",
                                label = "Temperature limits",
                                choices = limit.df$name, 
                                selected = "No limit")),
  
  conditionalPanel(condition = "output.file_uploaded & input.tabs == 'plot'",
                   downloadButton("download_plot", "Download plot")),
  
  conditionalPanel(condition = "output.file_uploaded & input.tabs == 'plot'",
                   imageOutput("probe_overview"))
  
  # shiny::verbatimTextOutput("file_uploaded")
)
