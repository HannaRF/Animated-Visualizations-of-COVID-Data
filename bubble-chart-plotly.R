#------------------------- packages ---------------

library(ggplot2)
library(plotly)
library(dplyr)
library(Hmisc) # %nin% 
library(lubridate)
library(tidyr)

#------------------------- external data ------------------------------

#Estados Unidos: US$ 20,933 trilh?es
#China: US$ 14,723 trilh?es
#Jap?o: US$ 5,049 trilh?es
#Alemanha: US$ 3,803 trilh?es
#Reino Unido: US$ 2,711 trilh?es
#?ndia: US$ 2,709 trilh?es
#Fran?a: US$ 2,599 trilh?es
#It?lia: US$ 1,885 trilh?o
#Canad?: US$ 1,643 trilh?o
#Coreia do Sul: US$ 1,631 trilh?o
#R?ssia: US$ 1,474 trilh?o
#Brasil: US$ 1,434 trilh?o
#Austr?lia: US$ 1,359 trilh?o
#Espanha: US$ 1,278 trilh?o
#M?xico: US$ 1,076 trilh?o

names <- c('Brazil',
           'United States',
           'Canada',
           'Mexico',
           'Germany',
           'United Kingdom',
           'French',
           'Italy',
           'Spain',
           'Russia',
           'India',
           'South Korea',
           'China',
           'Japan',
           'Australia')


colors <- c('#F28B30', # Asia (laranja)
            '#BF0A3A', # Europa (vermelho)
            '#022873', # Am?rica do norte (azul)
            '#F23D6D', # Oceania (rosa)
            'gray',    # Outros (cinza)
            '#03A62C') # Am?rica do sul (verde)

#------------------------- plotting -------------------------------------
fig <- data %>%
  plot_ly(
    x = ~cases, 
    y = ~deaths, 
    marker = list(size = ~vac2,opacity = 0.5),
    #color = ~continent,
    #colors = colors, 
    frame = ~date, 
    text = ~paste("Continent: ", continent, '<br>Country:', location),
    type = 'scatter',
    mode = 'markers'
  )
fig