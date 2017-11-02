#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dygraphs)
library(stringr)
library(tibble)

example_seq = readLines('example/nef.txt')[1]
mypattern = 'cg'

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    get_seq <- reactive({
        input$seq
    }) %>% debounce(1000)

    get_wsize <- reactive({
        input$wsize
    }) %>% debounce(1000)

    observeEvent(input$clear,
                 updateTextAreaInput(session, 'seq', value = ''))

    observeEvent(input$example1,
                 updateTextAreaInput(session, 'seq', value = example_seq))

    output$seq_summary <- renderText({
        paste('Length:', str_length(get_seq()))
    })

    output$cg_plot <- renderDygraph({
        myseq = str_to_lower(get_seq())
        if (str_length(myseq) < 1) {
            NULL
        } else {
            seq_cg = sort(as.vector(apply(str_locate_all(myseq,
                                                         fixed(mypattern))[[1]], 1,
                                          function(x) {
                                              seq(from = x['start'], to = x['end'])
                                          })))
            seq_pat = rep(0, str_length(myseq))
            seq_pat[seq_cg] = 1
            seq_density = sapply(seq_along(seq_pat), function(n) {
                sum(seq_pat[max(1,n-get_wsize()/2):min(str_length(myseq),n+get_wsize()/2)])
            })
            seq_density <- data.frame(
                pos = seq_along(seq_density),
                freq = seq_density
            )
            dygraph(seq_density) %>%
                dyRibbon(data = seq_pat, top = 0.05, palette = c('white', 'red')) %>%
                dyRangeSelector()
        }
    })

})