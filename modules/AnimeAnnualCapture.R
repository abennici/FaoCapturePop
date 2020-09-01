###Module
# Function for module UI
AnimCaptUI <- function(id) {
  ns <- NS(id)
  # Options for Spinner
  options(spinner.color="#0275D8", spinner.color.background="#ffffff", spinner.size=1)
  #tabPanel("DataTable", DTOutput(ns('table')))
  tabPanel("Time", div(plotlyOutput(ns('plot'))%>%withSpinner(type = 2),  style = "font-size:80%"))
  
}

# Function for module server logic
AnimCapt <- function(input, output, session,data.sf,meta) {
  observe({
    accumulate_by <- function(dat, var) {
      var <- lazyeval::f_eval(var, dat)
      lvls <- plotly:::getLevels(var)
      dats <- lapply(seq_along(lvls), function(x) {
        cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
      })
      dplyr::bind_rows(dats)
    }
    df<-as.data.frame(data.sf())
    df <- df %>%group_by(year) %>% 
      summarise(capture = sum(capture))%>%
      accumulate_by(~year)
    fig <- df %>% plot_ly(
      x = ~year, 
      y = ~capture, 
      frame = ~frame,
      type = 'scatter', 
      mode = 'lines', 
      fill = 'tozeroy', 
      fillcolor='rgba(114, 186, 59, 0.5)',
      line = list(color = 'rgb(114, 186, 59)'),
      text = ~paste("Year: ", year, "<br>capture: ", capture), 
      hoverinfo = 'text'
    )
    fig <- fig %>% layout(
      title = "Annual capture for global fisheries",
      yaxis = list(
        title = "Total of capture in Tons", 
        #range = c(0,250), 
        zeroline = F
        #tickprefix = "$"
      ),
      xaxis = list(
        title = "Year", 
        #range = c(0,30), 
        zeroline = F, 
        showgrid = F
      )
    ) 
    fig <- fig %>% animation_opts(
      frame = 100, 
      transition = 0, 
      redraw = FALSE
    )
    fig <- fig %>% animation_slider(
      currentvalue = list(
        prefix = "Year "
      )
    )
    
    output$plot <- renderPlotly(fig)
    
  })
}
####