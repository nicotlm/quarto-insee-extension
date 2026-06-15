
library(plotly)

month <- c('January', 'February', 'March', 'April', 'May', 'June', 'July',
           'August', 'September', 'October', 'November', 'December')
high_2000 <- c(32.5, 37.6, 49.9, 53.0, 69.1, 75.4, 76.5, 76.6, 70.7, 60.6, 45.1, 29.3)
low_2000 <- c(13.8, 22.3, 32.5, 37.2, 49.9, 56.1, 57.7, 58.3, 51.2, 42.8, 31.6, 15.9)
high_2007 <- c(36.5, 26.6, 43.6, 52.3, 71.5, 81.4, 80.5, 82.2, 76.0, 67.3, 46.1, 35.0)
low_2007 <- c(23.6, 14.0, 27.0, 36.8, 47.6, 57.7, 58.9, 61.2, 53.3, 48.5, 31.0, 23.6)
high_2014 <- c(28.8, 28.5, 37.0, 56.8, 69.7, 79.7, 78.5, 77.8, 74.1, 62.6, 45.3, 39.9)
low_2014 <- c(12.7, 14.3, 18.6, 35.5, 49.9, 58.0, 60.0, 58.6, 51.7, 45.2, 32.2, 29.1)

data <- data.frame(month, high_2000, low_2000, high_2007, low_2007, high_2014, low_2014)

#The default order will be alphabetized unless specified as below:
data$month <- factor(data$month, levels = data[["month"]])

fig <- plot_ly(data, x = ~month, y = ~high_2014, name = 'High 2014', type = 'scatter', mode = 'lines',
               line = list(color = 'rgb(205, 12, 24)', width = 4)) 
fig <- fig %>% add_trace(y = ~low_2014, name = 'Low 2014', line = list(color = 'rgb(22, 96, 167)', width = 4)) 
fig <- fig %>% add_trace(y = ~high_2007, name = 'High 2007', line = list(color = 'rgb(205, 12, 24)', width = 4, dash = 'dash')) 
fig <- fig %>% add_trace(y = ~low_2007, name = 'Low 2007', line = list(color = 'rgb(22, 96, 167)', width = 4, dash = 'dash')) 
fig <- fig %>% add_trace(y = ~high_2000, name = 'High 2000', line = list(color = 'rgb(205, 12, 24)', width = 4, dash = 'dot')) 
fig <- fig %>% add_trace(y = ~low_2000, name = 'Low 2000', line = list(color = 'rgb(22, 96, 167)', width = 4, dash = 'dot'))

fig <- fig %>% layout(width = 850, height = 700,
                      title = "Average High and Low Temperatures in New York",
                      xaxis = list(title = "Months",
                                   autorange = TRUE),
                      yaxis = list(title = "Temperature (degrees F)",
                                    autorange = TRUE))


