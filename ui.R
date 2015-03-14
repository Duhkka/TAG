library(shiny)
shinyUI(fluidPage(
  titlePanel("Genia TAG Experiments"),
    verticalLayout(
      wellPanel(
        fluidRow(       
          column(3,selectInput("tag", "Tags:", choices=tags)), 
          column(2,selectInput("station", "Stations:", choices=machines)), 
          column(3,selectInput("status", "Status:", choices=status)), 
          column(4,dateRangeInput('dateRange',label = 'Select range of dates:',start = earliest, end = latest))
        )
      )
    ),

                
                mainPanel(
                  tabsetPanel(type = "tabs", 
                              tabPanel("Plot", plotOutput("tagPlot")), 
                              tabPanel("Summary", verbatimTextOutput("summary")), 
                              tabPanel("Single Level ", dataTableOutput("sltable")),
                              tabPanel("Dye", dataTableOutput("dtable")),
                              tabPanel("Competition", dataTableOutput("ctable")),
                              tabPanel("Background", dataTableOutput("btable"))
                  )
                )

))

