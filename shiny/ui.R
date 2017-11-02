#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dygraphs)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Find CG"),

  sidebarLayout(
      sidebarPanel(
          fluidRow(
              column(width = 8,
                     textAreaInput('seq',
                                   width = '100%',
                                   height = '300px',
                                   resize = 'vertical',
                                   label = 'Paste your sequence here',
                                   placeholder = 'atcg...'),
                     sliderInput('wsize',
                                 label = 'Window size',
                                 min = 10,
                                 max = 100,
                                 value = 50,
                                 step = 5)),
              column(width = 4,
                     tags$div(class = "btn-group",
                              actionButton(inputId = 'clear', label = 'Clear',
                                           class = "btn btn-danger btn-sm"),
                              actionButton(inputId = 'example1',
                                           label = tags$span('Paste example'),
                                           class = "btn btn-primary btn-sm")),
                     hr(),
                     textOutput('seq_summary')
              )
          )
      ),

      mainPanel(dygraphOutput('cg_plot'))
  )
))
