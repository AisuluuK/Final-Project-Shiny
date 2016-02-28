# This is the server logic for a Shiny web application.
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
#install.packages('nycflights', repos = 'http://cran.us.r-project.org')
library(nycflights13)
flights <- data.table(nycflights13::flights)
dtairlines <- data.table(nycflights13::airlines)
setkey(flights, carrier)
setkey(dtairlines, carrier)
flights <- flights[dtairlines]
weather <- data.table(nycflights13::weather)
setorder(weather, year, month, day, hour)
daily_visib <- weather[, .(ave_visib = mean(visib)), by = .(year, month, day)]
setkey(daily_visib, year, month, day)
setkey(flights, year, month, day)
flights <- flights[daily_visib]
daily_temp <- weather[, .(ave_temp = mean(temp)), by = .(year, month, day)]
setkey(daily_temp, year, month, day)
setkey(flights, year, month, day)
flights <- flights[daily_temp]
flights <- data.frame(flights)

shinyServer(function(input, output) {
  
  output$plot <- renderPlot({
    
    flights <- flights[flights$distance >= input$distance,]
    
    #if (flights$distance > input$distance) {
    #  flights <- flights[flights$distance >= input$distance,]
    #}
    if (input$name != "All") {
      flights <- flights[flights$name == input$name,]
    }
    if (input$month != "All") {
      flights <- flights[flights$month == input$month,]
    }
    if (input$day != "All") {
      flights <- flights[flights$day == input$day,]
    }
    plot(flights$air_time, flights$arr_delay, col="blue", lwd = 1, xlab="Arrival Delay", ylab="Time in Air", main="Linear relationship between time in air & arrival delay")
    fit <- lm(arr_delay ~ air_time, data = flights)
    abline(fit, col='red')
    
  })
  
  output$ggplot <- renderPlot({
    
    flights <- flights[flights$distance >= input$distance,]
    
    if (input$name != "All") {
      flights <- flights[flights$name == input$name,]
    }
    if (input$month != "All") {
      flights <- flights[flights$month == input$month,]
    }
    if (input$day != "All") {
      flights <- flights[flights$day == input$day,]
    }
    
    ggplot(flights, aes_string(x = flights$ave_visib, y = flights$dep_delay)) + 
      geom_point(aes(col = factor(origin))) + 
      ggtitle("Correlation of daily visibility and departure delay")+ xlab("Average Daily Visibility") + ylab("Departure Delay") 
     
  })
  
  output$ggplot2 <- renderPlot({
    
    flights <- flights[flights$distance >= input$distance,]
    
    if (input$name != "All") {
      flights <- flights[flights$name == input$name,]
    }
    if (input$month != "All") {
      flights <- flights[flights$month == input$month,]
    }
    if (input$day != "All") {
      flights <- flights[flights$day == input$day,]
    }
    
    ggplot(flights, aes_string(x = flights$ave_visib, y = flights$arr_delay)) + 
      geom_point(aes(col = factor(origin))) + 
      ggtitle("Correlation of daily visibility and arrival delay")+ xlab("Average Daily Visibility") + ylab("Arrival Delay") 
    
  })
  
  output$ggplot3 <- renderPlot({
    
    flights <- flights[flights$distance >= input$distance,]
    
    if (input$name != "All") {
      flights <- flights[flights$name == input$name,]
    }
    if (input$month != "All") {
      flights <- flights[flights$month == input$month,]
    }
    if (input$day != "All") {
      flights <- flights[flights$day == input$day,]
    }
    
    ggplot(flights, aes_string(x = flights$ave_temp, y = flights$arr_delay)) + 
      geom_point(aes(col = factor(origin))) + 
      ggtitle("Correlation of daily temperature and arrival delay")+ xlab("Average Daily Temperature") + ylab("Arrival Delay") 
    
  })
  
  output$ggplot4 <- renderPlot({
    
    flights <- flights[flights$distance >= input$distance,]
    
    if (input$name != "All") {
      flights <- flights[flights$name == input$name,]
    }
    if (input$month != "All") {
      flights <- flights[flights$month == input$month,]
    }
    if (input$day != "All") {
      flights <- flights[flights$day == input$day,]
    }
    
    ggplot(flights, aes_string(x = flights$ave_temp, y = flights$dep_delay)) + 
      geom_point(aes(col = factor(origin))) + 
      ggtitle("Correlation of daily temperature and departure delay")+ xlab("Average Daily Temperature") + ylab("Departure Delay") 
    
  })
  
  output$table <- renderTable({
    
    flights <- flights[flights$distance >= input$distance,]
    
    if (input$name != "All") {
      flights <- flights[flights$name == input$name,]
    }
    if (input$month != "All") {
      flights <- flights[flights$month == input$month,]
    }
    if (input$day != "All") {
      flights <- flights[flights$day == input$day,]
    }
    
    table <- table(flights$dest, flights$origin)
    colnames(table) <- c("Newark Liberty International Airport", "John F. Kennedy International Airport", "LaGuardia Airport")
    
    table
    
  })
  
})


