# TCU trend analysis - sidebar

tabPanel("Imported files", value = "main",
         h3("Temperature controlled unit trend analysis (SOP EQV 037)"),
         htmlOutput("main_text"),
         DT::dataTableOutput("input_files_table")
)
