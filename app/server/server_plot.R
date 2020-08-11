# TCU trend analysis - server plot

observeEvent({
  
  c(input$tabs, input$radio_limit, input$input_files)
},
{
  if(is.null(LDF)) {
    return(NULL)
  }
  
  p <- plotSubTrend(LDF, input$radio_limit[1])
  
  output$plot <- renderPlot({
    plot(p)
  },height = 600, width = 900)
}
)
