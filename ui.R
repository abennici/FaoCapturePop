ui <- fluidPage(
  tags$head(tags$link(rel="stylesheet", type="text/css", href="popup.css")),
  fluidRow(
    column(
      width = 4,
      tags$h4(FlagNameUI(id="name")),
      
      mainPanel(
        
        # Output: Tabset w/ plot, summary, and table ----
        tabsetPanel(type = "tabs",
                    AnimCaptUI(id="id_2"),
                    PieSpUI(id="id_3"),
                    DataTableWideUI(id="id_4")
                   # QueryInfoUI(id="id_1")
        )
      )
    )
  ) 
)
