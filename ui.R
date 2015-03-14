library(shiny)
#library(shinyBS)

shinyUI(fluidPage(
#shinyUI(bootstrapPage(  
  titlePanel("Genia TAG Experiments"),
    verticalLayout(
      wellPanel(width = "60%",
        fluidRow(
          theme = "bootstrap.css",   # make sure bootstrap is in www  
          column(3,selectInput("gtag", "Tags:", choices=gtags)),
          column(2,selectInput("station", "Stations:", choices=machines)), 
#           bsTooltip(id = "station", title = "This is an input", 
#                     placement = "left", trigger = "hover"),
          column(3,selectInput("status", "Status:", choices=status)), 
          column(4,dateRangeInput('dateRange',label = 'Select range of dates:',start = earliest, end = latest))
        )
      )
    ),

                
                mainPanel(width = "100%",
                  tabsetPanel(type = "tabs", 
                              tabPanel("Plot", plotOutput("gtagPlot")), 
                              tabPanel("Summary", verbatimTextOutput("summary")), 
                              tabPanel("Single Level ", dataTableOutput("sltable")),
                              tabPanel("Dye", dataTableOutput("dtable")),
                              tabPanel("Competition", dataTableOutput("ctable")),
                              tabPanel("Background", dataTableOutput("btable"))
                  )
                )

))

