# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:latest

# system libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libsqlite3-dev \
    libmariadbd-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libcurl4-openssl-dev \
    libssl-dev 

## Install Linux dependencies for geospatial R packages
RUN apt-get update && apt-get install -y curl git libboost-all-dev \
    libgdal-dev libgit2-dev libproj-dev libssl-dev  \
    libudunits2-0 libudunits2-dev libmysqlclient-dev
    
	
## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean
    

RUN R -e "install.packages(pkgs=c('shiny','dplyr', 'jsonlite', 'httr', 'lubridate', 'plotly', 'sf', 'stringr'), repos='https://cran.rstudio.com/')" 

COPY app/ /root/app

EXPOSE 3838

# RUN dos2unix /usr/bin/shiny-server.sh && apt-get --purge remove -y dos2unix && rm -rf /var/lib/apt/lists/*
CMD ["R", "-e", "shiny::runApp('/root/app', host='0.0.0.0', port=3838)"]