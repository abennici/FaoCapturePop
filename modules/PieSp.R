###Module
# Function for module UI
PieSpUI <- function(id) {
  ns <- NS(id)
  # Options for Spinner
  options(spinner.color="#0275D8", spinner.color.background="#ffffff", spinner.size=1)
  #tabPanel("DataTable", DTOutput(ns('table')))
  tabPanel("Species", div(plotlyOutput(ns('pie'))%>%withSpinner(type = 2),  style = "font-size:80%"))
  
}

# Function for module server logic
PieSp <- function(input, output, session,data) {
  observe({

  req = readr::read_csv("https://raw.githubusercontent.com/openfigis/RefData/gh-pages/species/CL_FI_SPECIES_ITEM.csv", col_names = FALSE)
  names(req) <- req[1,]
  sp_register <- data.frame(
    species = req$Alpha3_Code,
    label = paste0(req$Name_En," [",req$Alpha3_Code,"]"),
    stringsAsFactors = FALSE
  )
  
  df<-as.data.frame(data())
  df <- df %>%group_by(species) %>% 
    summarise(capture = sum(capture)) %>%
    left_join(sp_register)
  
#fig <- plot_ly(df, labels = ~as.factor(label), values = ~capture, type = 'pie',textinfo = 'none')
fig <- plot_ly(df, labels = ~as.factor(label), values = ~capture,textinfo = 'none')
fig <- fig %>% add_pie(hole = 0.6)
fig <- fig %>% layout(title = '',
                      xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                      yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                      showlegend = FALSE)
                     #legend = list(font = list(family = "sans-serif", size = 5)))
                     #margin = list(l = 5, r = 5, t = 20, b = 20))

output$pie <- renderPlotly(fig)

  })
}