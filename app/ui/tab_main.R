# TCU trend analysis - sidebar

tabPanel("Imported files", value = "main",
         h3("Temperature controlled unit trend analysis (SOP EQP 037)"),
         
         conditionalPanel(condition = "!output.file_uploaded & input.tabs == 'main'",
                          htmlOutput("main_text")),
        
         DT::dataTableOutput("input_files_table"),
         
         conditionalPanel(condition = "!output.file_uploaded & input.tabs == 'main'",
                          textOutput("mes"))
)
