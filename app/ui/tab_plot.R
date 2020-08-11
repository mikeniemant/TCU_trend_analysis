# TCU trend analysis - tab plot

tabPanel("Plot", value = "plot",
         
         conditionalPanel(condition = "output.file_uploaded", # & input.tabs == 'plot'
                          plotOutput("plot")),
         
)
