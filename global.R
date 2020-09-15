#---------------------------------------------------------------------------------------------------------
#packages
library("ows4R")
library("sp")
library("shiny")
library("dplyr")
library("plotly")
library("DT")
library("shinyWidgets")
library("shinycssloaders")
library("jsonlite")

#load module functions
source("https://raw.githubusercontent.com/eblondel/OpenFairViewer/master/src/resources/shinyModule/QueryInfo.R")
#source("D:/FAO-BLUECLOUD_04052020_11082020/02-R/04-Github/OpenFairViewer/src/resources/shinyModule/QueryInfo.R")
source("modules/FlagName.R")
source("modules/AnimeAnnualCapture.R")
source("modules/PieSp.R")
source("modules/DataTableWide.R")
source("ui.R")
source("server.R")

