# TCU trend analysis - server plot

observeEvent({
  
  c(input$tabs, input$radio_mm, input$input_files)
},
{
  if(is.null(LDF)) {
    return(NULL)
  }
  
  p <- plotSubTrend(LDF, input$radio_mm[1])
  
  output$plot <- renderPlot({
    plot(p)
  },height = 600, width = 900)
}
)
