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
library(Biostrings)
library(ggplot2)
library(plotly)

example_seq = toupper(readLines('example/nef.txt')[1])
# mypattern = 'cg'

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    get_seq <- reactive({
        DNAString(input$seq)
    }) %>% debounce(1000)

    get_pat <- reactive({
        DNAString(input$pat)
    }) %>% debounce(1000)

    get_wsize <- reactive({
        input$wsize
    }) %>% debounce(1000)

    observeEvent(input$clear,
                 updateTextAreaInput(session, 'seq', value = ''))

    observeEvent(input$example1,
                 updateTextAreaInput(session, 'seq', value = example_seq))

    output$seq_summary <- renderUI({
        tags$dl(
            tags$dt('Sequence length'),
            tags$dd(length(get_seq())),
            tags$dt('Pattern'),
            tags$dd(get_pat())
        )
    })

    output$cg_plot <- renderDygraph({
        myseq = get_seq()
        mypattern = get_pat()
        if (length(myseq) == 0 || length(mypattern) == 0) {
            NULL
        } else {
            seq_search_res = matchPattern(mypattern, myseq, fixed = FALSE)
            if (length(seq_search_res) == 0) NULL
            else {
                # seq_cg = apply(seq_search_res, 1,
                #                function(x) {
                #                    seq(from = x['start'], to = x['end'])
                #                })
                # seq_cg = sort(unique(as.vector(seq_cg)))
                seq_cg = start(seq_search_res)
                seq_pat = rep(0, length(myseq))
                seq_pat[seq_cg] = 1
                seq_density = sapply(seq_along(seq_pat), function(n) {
                    window_start = max(1, n - get_wsize() / 2)
                    window_end = min(length(myseq), n + get_wsize() / 2)
                    sum(seq_pat[window_start:window_end])
                })
                seq_density <- data.frame(
                    pos = seq_along(seq_density),
                    freq = seq_density
                )
                dygraph(seq_density) %>%
                    dyRibbon(data = seq_pat, top = 0.05,
                             palette = c('white', 'red')) %>%
                    dyOptions(colors = 'lightgrey', drawGrid = FALSE) %>%
                    dyRangeSelector()
            }
        }
    })

    get_ggplot_obj <- reactive({
        myseq = get_seq()
        mypattern = get_pat()
        if (length(myseq) == 0 || length(mypattern) == 0) {
            NULL
        } else {
            seq_search_res = matchPattern(mypattern, myseq, fixed = FALSE)
            if (length(seq_search_res) == 0) NULL
            else {
                break_dist = ifelse(length(myseq) <= 2000, 100, ceiling(length(myseq) / 2000) * 100)
                ggplot(data = data.frame(x = start(seq_search_res)),
                       aes(label = x)) +
                    geom_segment(aes(x = x, xend = x),
                                 y = 0.45, yend = 0.55,
                                 color = 'red') +
                    scale_x_continuous(breaks = c(seq(from = 0, to = length(myseq), by = break_dist), length(myseq)), limits = c(0, length(myseq))) +
                    labs(x = '') +
                    theme_bw() +
                    theme(panel.grid = element_blank(),
                          axis.text.x = element_text(
                              angle = 45,
                              vjust = 1, hjust = 1,
                              size = 14
                          ),
                    )
            }
        }
    })

    output$cg_plot_static <- renderPlot({
        get_ggplot_obj()
    })

    output$cg_plot_dynamic <- renderPlotly({
        ggplotly(get_ggplot_obj() + theme(plot.margin = margin(b = 2, unit = "cm")), tooltip = 'label')
    })
})
