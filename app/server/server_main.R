# TCU trend analysis - server main 

observeEvent({
  
  c(input$tabs, input$radio_mm, input$input_files)
},
{
  # Define main text
  output$main_text <- renderUI({
    HTML(paste("Input file names should have the following format: 'YYYYMMMDD-RAW Data-EQP No.-FRM-084-###'",
               "",
               "Example: '2020JUL20-Raw Data REF-10-FRM-084-001.csv'",
               "",
               "The input files should meet to the following:",
               "- No duplicate names",
               "- No duplicate dates",
               "- No multiple equipment numbers",
               "- No duplicate iteration numbers",
               "",
               "The data should meet to the following:",
               "- Nine rows of data, each row representing a probe",
               "- Six columns:",
               " * 'Channel': probe name (character)",
               " * 'Minimum': value (numeric, point delimiter)",
               " * 'Maximum': value (numeric,  delimiter)",
               " * 'Average': value (numeric,  delimiter)",
               " * 'CORRECTIE_FACTOR': value (numeric, delimiter)",
               " - Use the correct value type (as shown in the previous step)",
               " - No empty cells",
               sep="<br/>"))
  })
}
)
