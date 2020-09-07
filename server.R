server <- function(input, output, session) {
  
  data<-callModule(module = QueryInfo, id = "id_1")
  callModule(module = FlagName,id="name",reactive(data$data))
  callModule(module = AnimCapt,id="id_2",reactive(data$data))
  callModule(module = PieSp,id="id_3",reactive(data$data))
  callModule(module = DataTableWide,id="id_4",reactive(data$data),reactive(data$dsd))
  
}