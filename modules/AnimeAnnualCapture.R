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
    
    df <- df %>%
      #group_by(year,f_area_type) %>% 
      group_by(year) %>% 
      summarise(capture = sum(capture))%>%
      accumulate_by(~year)%>%
      #arrange(desc(f_area_type))%>%
      ungroup()
    #mutate(f_area_type,as.factor(f_area_type))
    # df$f_area_type<-as.factor(df$f_area_type)
    # df$f_area_type<-factor(df$f_area_type,levels=c("marine","inland"))
    
    #df$f_area_type2<-ifelse(df$f_area_type=="inland","inland","marine")
    print("df_area loaded")
    
    #AREA PLOT
    #color_map <- c(marine="blue", inland="orange")
    #df$color <- ifelse(df$f_area_type=="marine", "blue", "orange") 
    
  #  pal <- c("orange", "blue")
  #  pal <- setNames(pal, c("inland", "marine"))
    
    fig <- df %>% 
      plot_ly(
        x = ~year, 
        y = ~capture,
        #stackgroup = 'one',
        height = 300,
      #  split=~f_area_type,
        frame = ~frame,
      #  color = ~as.character(f_area_type),
        #colors="Set1",
      #  colors=pal,
        #color=color_map[df$f_area_type]
        #colors = c( "blue", "orange"),
        type = 'scatter', 
        mode = 'lines',
        fill = 'tozeroy',
        line = list(simplyfy = F),
        text = ~paste("Year: ", year, "<br>capture: ", capture), 
        hoverinfo = 'text'
      )
    
    fig <- fig %>% layout(title = "",
                                   # yaxis = list(title = "Capture (Tons) by Type of Area", range = c(0,max(df$capture)+25*max(df$capture)/100), zeroline = F),
                          yaxis = list(title = "Capture (Tons)", range = c(0,max(df$capture)+25*max(df$capture)/100), zeroline = F),
                                    xaxis = list( title = "Year", zeroline = F)
    ) 
    fig<- fig %>% animation_opts(frame = 100,transition = 0,redraw = FALSE )
    
    fig <- fig %>% animation_slider(y = 0.2,anchor="middle",currentvalue = list(
      active=2018,tickcolor='#ffffff',ticklength=0,prefix = "",font = list(size=10))
    )
    
    ###FIRST VERSION
    # 
    # df <- df %>%group_by(year,f_area_type) %>% 
    #   summarise(capture = sum(capture))%>%
    #   accumulate_by(~year)%>%
    #   ungroup()
    # 
    # df$f_area_type<-as.factor(df$f_area_type)
    # df$f_area_type<-factor(df$f_area_type,levels=c("marine","inland"))
    # 
    # fig <- df %>% plot_ly(height = 300)
    # fig<-fig%>% add_trace(
    #   x = ~year, 
    #   y = ~capture,
    # # name= c("marine","inland"),
    #  # stackgroup = 'one',
    #   split=~f_area_type,
    #   height = 300,
    #   frame = ~frame,
    #   type = 'scatter', 
    #   mode = 'lines',
    #   line = list(simplyfy = F),
    #   fill = 'tozeroy', 
    #   color = ~f_area_type, 
    #   colors = c( "blue", "orange"), 
    #   text = ~paste("Year: ", year, "<br>capture: ", capture), 
    #   hoverinfo = 'text'
    # )
    # 
    # 
    # fig <- fig %>% layout(
    #  # sliders = list(
    # #    list(
    #  #     active = 2018)),
    #   title = "",
    #   barmode = "stack",#ignored 
    #   yaxis = list(
    #     title = "Capture (Tons)", 
    #     #range = c(0,max(df$capture)+25*max(df$capture)/100), 
    #     autorange=TRUE,
    #     zeroline = F
    #     #tickprefix = "t"
    #   ),
    #   xaxis = list(
    #     title = "Year", 
    #     #range = c(0,30), 
    #     zeroline = F, 
    #     showgrid = F
    #   )
    # ) 
    # fig <- fig %>% animation_opts(
    #   frame = 100, 
    #   transition = 0, 
    #   redraw = FALSE
    # )
    # fig <- fig %>% animation_slider(
    #   
    #     y = 0.2,
    #    anchor="middle",
    #     currentvalue = list(
    #     active=2018,#ignored
    #     tickcolor='#ffffff',#ignored
    #     ticklength=0,#ignored
    #     prefix = "",
    #     font = list(size=10)
    #     )
    # )
    
    ##END FIRST VERSION
    #####Test 2 alternative with ggplotly
    
  #   df <- df %>%group_by(year,f_area_type) %>% 
  #     summarise(capture = sum(capture))
  #   
  #   df$f_area_type<-as.factor(df$f_area_type)
  #   df$f_area_type<-factor(df$f_area_type,levels=c("marine","inland"))
  #   
  #   p <- ggplot(df,aes(x = year, y = capture,frame=year))+
  #     geom_area(aes(fill=f_area_type,frame=f_area_type),alpha=0.5)+
  #     labs(x='Capture (Tons)',y='Year')+
  #     theme(legend.title = element_blank(),
  #           axis.text.x = element_text(angle = 90)))+
  #   scale_fill_manual(name = c("marine","inland"),values = c("lightblue","coral"))
  # p  
  # fig<-ggplotly(p)
    
    ###End test 2
    output$plot <- renderPlotly(fig)
    
  })
}
####