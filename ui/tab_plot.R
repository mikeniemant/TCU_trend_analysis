# TCU trend analysis - tab plot

tabPanel("Plot", value = "plot.tab",
         
         conditionalPanel(condition = "output.file_uploaded & input.tabs == 'plot.tab'",
                          plotOutput("plot")),
         
)
