server <- function(input, output, session) {
  
  data<-callModule(module = QueryInfo, id = "id_1")
  callModule(module = AnimCapt,id="id_2",reactive(data$data.sf),reactive(data$meta))
  callModule(module = DataTable,id="id_3",reactive(data$data.sf),reactive(data$meta))
  
}