# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#
#install.packages('shiny', repos = 'http://cran.us.r-project.org')
library(shiny)
#install.packages('ggplot2', repos = 'http://cran.us.r-project.org')
library(ggplot2)
#install.packages('data.table', repos = 'http://cran.us.r-project.org')
library(data.table)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Model of flight delays"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("distance",
                  "Distance above:",
                  min = 0,
                  max = 5000,
                  value = 100),
      
      
      selectInput('name', 'Airline company', choices = c("All", as.character(unique(flights$name)))),
      selectInput('month', 'Month of 2013', choices = c("All", order(unique(flights$month)))),
      selectInput('day', 'Day', choices = c("All", order(unique(flights$day)))
                  #selectInput('col', 'Color', c('gear', 'am', 'cyl'))
      )),
    
    
    
    mainPanel(
      tabsetPanel(
        tabPanel("Linear Model", plotOutput("plot")),
        tabPanel("GG plot 1", plotOutput("ggplot")),
        tabPanel("GG plot 2", plotOutput("ggplot2")),
        tabPanel("GG plot 3", plotOutput("ggplot3")),
        tabPanel("GG plot 4", plotOutput("ggplot4")),
        tabPanel("Number of flights on destination", tableOutput("table"))
       
      )
    )
  )
))
