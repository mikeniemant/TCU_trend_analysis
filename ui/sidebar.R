# TCU trend analysis - sidebar

wellPanel(
  
  fileInput(inputId = "input_files", label = "", multiple = T,
            accept = c(".csv"), placeholder = "Select files"),
  
  conditionalPanel(condition = "output.file_uploaded & input.tabs == 'plot.tab'",
                   radioButtons(inputId = "radio_mm", 
                                label = "Outlier line",
                                choices = mm.df$name, 
                                selected = "No line")),
  
  conditionalPanel(condition = "output.file_uploaded & input.tabs == 'plot.tab'",
                   downloadButton("download_plot", "Download plot")),
  
  conditionalPanel(condition = "output.file_uploaded & input.tabs == 'plot.tab'",
                   imageOutput("probe_overview"))
  
  # shiny::verbatimTextOutput("file_uploaded")
)
