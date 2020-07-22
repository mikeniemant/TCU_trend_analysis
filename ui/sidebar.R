# TCU trend analysis - sidebar

wellPanel(
  # conditionalPanel(condition = "!output.file_uploaded & input.tabs == 'main'",
  #                  textOutput("import_message")),
  # conditionalPanel(condition = "input.tabs == 'main'",
  fileInput(inputId = "input_files", label = "", multiple = T,
            accept = c(".csv"), placeholder = "Select files"),
  
  radioButtons(inputId = "radio_mm", 
               label = "Outlier line",
               choices = mm.df$name, 
               selected = "No line"),
  downloadButton("download_plot"),
  imageOutput("probe_overview")
)
