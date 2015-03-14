library(RMySQL)
library(shiny)


shinyServer(function(input, output, session) {
  
  output$gtagPlot <- renderPlot({
    GTags=reactive({
    input$gtag
    start_date = as.numeric(input$dateRange[1])
    end_date = as.numeric(input$dateRange[2])
    ids = sDates>=start_date & sDates <=end_date
    qids = single$Quality.Run == "Yes"
    qr = table(sdata[,c("Tag")][ids][qids])
#    dr = table(sdata[,c("Tag")][ids])
#    qrd = qr[ids]
    qr[order(-qr),drop=TRUE]
    })
    if (sum(GTags()) > 0)
    {
  
    barplot(t(
      as.matrix(GTags())), 
      beside=TRUE, 
       main=paste("Genia Tags with Quality Runs: ", sum(GTags())," (from ",input$dateRange[1] ," to ", input$dateRange[2], ")"),
       ylab="Num Quality Runs",xlab="",las=2)

  }
  })
  
  # Generate a summary of the data
  output$summary <- renderPrint({
    GTags=reactive({
      input$gtag
      start_date = as.numeric(input$dateRange[1])
      end_date = as.numeric(input$dateRange[2])
      ids = sDates>=start_date & sDates <=end_date
      qids = single$Quality.Run == "Yes"
      qr = table(sdata[,c("Tag")][qids][ids])
      #     qrd = qr[ids]
      qr[order(-qr),drop=TRUE]
    })
    data.frame(GTags())
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
  },
#  option = list(drawCallback = I("function( settings ) {document.getElementById('ex1').style.width = '200px';}"))
  options = list(lengthMenu = c(10, 20, 50), pageLength = 10,autoWidth = FALSE)
#                ,columnDefs = list(width = "20px", width = "20px",width = "20px",width = "20px", 
#                                    width = "20px", width = "20px",width = "10px"))
)


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
