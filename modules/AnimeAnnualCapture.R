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
AnimCapt <- function(input, output, session,data) {
  observe({
    accumulate_by <- function(dat, var) {
      var <- lazyeval::f_eval(var, dat)
      lvls <- plotly:::getLevels(var)
      dats <- lapply(seq_along(lvls), function(x) {
        cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
      })
      dplyr::bind_rows(dats)
    }
    df<-as.data.frame(data())
    
    df <- df %>%group_by(year,f_area_type) %>% 
      summarise(capture = sum(capture))%>%
      accumulate_by(~year)
    
    df$f_area_type<-as.factor(df$f_area_type)
    df$f_area_type<-factor(df$f_area_type,levels=c("marine","inland"))
    
    fig <- df %>% plot_ly(
      x = ~year, 
      y = ~capture,
      stackgroup = 'one',
      split=~f_area_type,
      height = 300,
      frame = ~frame,
      type = 'scatter', 
      mode = 'lines',
      #line = list(simplyfy = F),
      fill = 'tozeroy', 
      # marker = list(
      #   color = factor(df$f_area_type,labels=c("blue","orange"))  
      # ),
      fillcolor=list(
        fill = factor(df$f_area_type,labels=c("blue","orange"))
      ),
      line = list(
        color = factor(df$f_area_type,labels=c("blue","orange"))
        ),
      #line = list(color = c('orange','blue')),
      text = ~paste("Year: ", year, "<br>capture: ", capture), 
      hoverinfo = 'text'
    )
    fig <- fig %>% layout(
     # sliders = list(
    #    list(
     #     active = 2018)),
      title = "",
      barmode = "stack",#ignored 
      yaxis = list(
        title = "Capture (Tons)", 
        range = c(0,max(df$capture)+25*max(df$capture)/100), 
        zeroline = F
        #tickprefix = "t"
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
      
        y = 0.2,
       anchor="middle",
        currentvalue = list(
        active=2018,#ignored
        tickcolor='#ffffff',#ignored
        ticklength=0,#ignored
        prefix = "",
        font = list(size=10)
        )
    )
    
    output$plot <- renderPlotly(fig)
    
  })
}
####