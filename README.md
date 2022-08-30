# Scotland COVID map app
A Shiny app showing the recent COVID-19 cases reported on a map of Scotland.

This was created using a docker image. The image uses the latest build of the shiny image from the rocker repository (https://github.com/rocker-org/rocker-versioned2)

There are also additional dependencies that are required for installing the 'sf' R package.

(I had an initial problem getting the app to work because the 'sf' package would not install so I found the additional dependencies)

To build the image run the following on the command line:

docker build -t covid-map-app . 

(be warned: it took me about ~ 1 hour to build the image)

Alternatively, pull the image from my Docker Hub repository using the following on the command line:

docker pull lbargie/covid-map-app

To run the app enter the following on the command line:

docker run --rm -p 3838:3838 covid-map-app

Navigate to http://localhost:3838 in your web browser to view the app.
