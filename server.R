server <- function(input, output, session) {
  
  data<-callModule(module = QueryInfo, id = "id_1")
  data2<-callModule(module = QueryData, id = "id_5",reactive(data$data),reactive(data$query$wfs_server),reactive(data$query$wfs_version),reactive(data$query$layer),reactive(data$query$feature_geom),reactive(data$query$par))
  callModule(module = FlagName,id="name",reactive(data2$data))
  callModule(module = AnimCapt,id="id_2",reactive(data2$data))
  callModule(module = PieSp,id="id_3",reactive(data2$data))
  callModule(module = DataTableWide,id="id_4",reactive(data2$data),reactive(data$dsd))
  
}