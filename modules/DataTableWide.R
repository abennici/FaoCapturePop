###Module
# Function for module UI
DataTableWideUI <- function(id) {
  ns <- NS(id)
  # Options for Spinner
  options(spinner.color="#0275D8", spinner.color.background="#ffffff", spinner.size=1)
  #tabPanel("DataTable", DTOutput(ns('table')))
  tabPanel("Data", div(DTOutput(ns('table'))%>%withSpinner(type = 2),  style = "font-size:80%"))
  
}

# Function for module server logic
DataTableWide <- function(input, output, session,data,dsd) {
  observe({
    ###Reformat
    tab<-as.data.frame(data())
    tab<-subset(tab,select=-c(geometry))
    name<-data.frame(MemberCode=names(tab))
    name<-name%>%left_join(dsd(),by="MemberCode")
    label<-paste0(name$MemberName," [",name$MemberCode,"]")
    tab$capture<-paste0(tab$capture," t")
    names(tab)<-label
    
    output$table <- renderDT(tab,rownames='',options =list(pageLength=5,lengthChange=FALSE))
    
    # ##First version
    # tab<-as.data.frame(data.sf())
    # name<-data.frame(MemberCode=tab$names)
    # name<-merge(test,subset(meta(),select=c(MemberCode,MemberName,Definition,MeasureUnitSymbol)))
    # label<-paste0(test2$MemberName," [",test2$MemberCode,"]")
    # names(tab)<-label
    # 
    # test<-as.data.frame(data.sf())
    # test<-t(test)
    # test<-as.data.frame(test)
    # print(meta())
    # test$MemberCode<-rownames(test)
    # test2<-merge(test,subset(meta(),select=c(MemberCode,MemberName,Definition,MeasureUnitSymbol)))
    # rownames(test2)<-paste0(test2$MemberName," [",test2$MemberCode,"]")
    # 
    # for(i in grep("V",names(test2),value=T)){
    #   test2[,i]<-paste(test2[,i],test2$MeasureUnitSymbol,sep=" ")    
    # }
    # 
    # test2<-subset(test2,select=-c(MemberCode,MemberName,MeasureUnitSymbol))
    # test2<-t(test2)
    # 
    # output$table <- renderDT(test2,rownames='',options =list(pageLength=5,lengthChange=FALSE))

                                 
})
}
####