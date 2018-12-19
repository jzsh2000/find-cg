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
  titlePanel("Find DNA Pattern"),

  sidebarLayout(
      sidebarPanel(width = 5,
          fluidRow(
              column(width = 8,
                     textAreaInput('seq',
                                   width = '100%',
                                   height = '300px',
                                   resize = 'vertical',
                                   label = 'Paste your sequence here',
                                   placeholder = 'ATCG...'),
                     textInput('pat',
                               label = 'Pattern',
                               value = 'GNCG',
                               placeholder = 'ATCGN...'),
                     sliderInput('wsize',
                                 label = 'Window size',
                                 min = 10,
                                 max = 200,
                                 value = 100,
                                 step = 5)
              ),
              column(width = 4,
                     tags$div(class = "btn-group",
                              actionButton(inputId = 'clear', label = 'Clear',
                                           class = "btn btn-danger btn-sm"),
                              actionButton(inputId = 'example1',
                                           label = tags$span('Example'),
                                           class = "btn btn-primary btn-sm")),
                     hr(),
                     uiOutput('seq_summary'),
                     hr(),
                     tags$a('IUPAC codes', href = 'http://genome.ucsc.edu/goldenPath/help/iupac.html', target = '_blank')
              )
          )
      ),

      mainPanel(
          width = 7,
          tabsetPanel(
              tabPanel('ggplot2', plotOutput('cg_plot_static')),
              tabPanel('ggplot2-plotly', plotlyOutput('cg_plot_dynamic')),
              tabPanel('dygraphs', dygraphOutput('cg_plot'))
          )
      )
  )
))
