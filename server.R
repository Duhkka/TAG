library(RMySQL)
library(shiny)


shinyServer(function(input, output, session) {
  
  output$chipPlot <- renderPlot({
    Tags=reactive({
    input$tag
    start_date = as.numeric(input$dateRange[1])
    end_date = as.numeric(input$dateRange[2])
    ids = sDates>=start_date & sDates <=end_date
#     gsum = table(adata[,c(input$tag)][ids])
#     gsum=gsum[gsum>0]
#     gsum[order(-gsum),drop = TRUE]
    })
    if (sum(Tags()) > 0)
    {
#     par(mfrow=c(2,1))
    
    barplot(t(
      as.matrix(Tags())), 
      beside=TRUE, 
      main=paste("Chip Usage from ",input$dateRange[1] ," to ", input$dateRange[2], " : ", sum(Tags())),
      ylab="Number of chips",xlab="",ylim=c(0,max(Tags())*1.5),las=2,cex.names=1.0,cex.lab=1.5)

  }
  })
  
  # Generate a summary of the data
  output$summary <- renderPrint({
    Tags=reactive({
      input$tag
      start_date = as.numeric(input$dateRange[1])
      end_date = as.numeric(input$dateRange[2])
      ids = sDates>=start_date & sDates <= end_date
    })
    data.frame(Tags())
  })
  
  # Generate an HTML table view of the data
  output$sltable <- renderDataTable({
    osdata=reactive({
      start_date = as.numeric(input$dateRange[1])
      end_date = as.numeric(input$dateRange[2])
      ids = sDates>=start_date & sDates <=end_date
      subset(sdata, ids)
    })
    data.frame(osdata())  
  },   options = list(lengthMenu = c(10, 20, 50), pageLength = 10))

  output$dtable <- renderDataTable({
    ocdata=reactive({
      start_date = as.numeric(input$dateRange[1])
      end_date = as.numeric(input$dateRange[2])
      ids = cDates>=start_date & cDates <=end_date
      subset(cdata, ids)
    })
    data.frame(ocdata())  
  },options = list(lengthMenu = c(10, 20, 50), pageLength = 20)) 

  output$ctable <- renderDataTable({
    oddata=reactive({
      start_date = as.numeric(input$dateRange[1])
      end_date = as.numeric(input$dateRange[2])
      ids = dDates>=start_date & dDates <=end_date
      subset(ddata, ids)
    })
    data.frame(oddata())  
  },options = list(lengthMenu = c(10, 20, 50), pageLength = 20)) 

})  
