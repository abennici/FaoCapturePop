FROM r-base:3.6.3

MAINTAINER Alexandre Bennici "bennicialexandre@gmail.com"


# system libraries of general use
  # mainly for installing sf (which requires units/rgeos/rgdal)


RUN apt-get update && apt-get install -y \
    sudo \
    libudunits2-dev \
    libproj-dev \
    libgeos-dev \
    libgdal-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2 \
    libxml2-dev \
    git 
   
  RUN apt-get update && apt-get upgrade -y

#Install XML package from archive
#Issue is that XML package from 2020-07 is referenced as depending on R >= 4.0
#To temporarily solve that we use the previous XML package version from archive
RUN wget https://cran.r-project.org/src/contrib/Archive/XML/XML_3.99-0.3.tar.gz

RUN R -e "install.packages('XML_3.99-0.3.tar.gz', repos = NULL, type = 'source')"
# install dependencies of the Fao Capture popup app

RUN R -e "install.packages(c('R6', 'httr','plotly','dplyr','sp','sf','rgdal','geometa','shiny','DT','shinyWidgets','jsonlite','remotes'), repos='http://cran.r-project.org')"

RUN R -e "remotes::install_github('eblondel/ows4R')"
RUN R -e "remotes::install_github('daattali/shinycssloaders')"

RUN git -C /root/ clone https://github.com/abennici/FaoCapturePop.git && echo "OK!"
RUN mkdir -p /srv/shiny/
RUN ln -s /root/FaoCapturePop /srv/shiny/FaoCapturePop
 
EXPOSE 3838

RUN apt-get install -y curl
CMD ["R", "-e shiny::runApp('/srv/shiny/FaoCapturePop',port=3838,host='0.0.0.0')"]
#CMD ["R", "-e shiny::runApp('/srv/shiny/FaoCapturePop')"]
