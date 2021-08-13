#------------------------- packages ---------------

#library(ggplot2)
library(plotly)
library(dplyr)
library(Hmisc) # %nin% 
library(lubridate)

# ------------------------ clean data --------------

data <- read.csv("owid-covid-data.csv")

data <- data %>% mutate(cases = ifelse(!(total_cases>=0), 0, total_cases),
                        deaths = ifelse(!(total_deaths>=0), 0, total_deaths),
                        vac1 = ifelse(!(people_vaccinated>=0 ), 0, people_vaccinated), 
                        vac2 = ifelse(!(people_fully_vaccinated>=0), 0, people_fully_vaccinated),
                        pop = population)


data <- data %>% select(continent,
                        location,
                        date,
                        cases,
                        deaths,
                        vac1,
                        vac2,
                        pop)


data <- data %>% filter(location %nin% c("World",
                                         "Asia",
                                         "Europe",
                                         "North America",
                                         "European Union",
                                         "South America",
                                         "Africa"))

# date => months

#data <- filter(date ...)


#------------------------- external data ------------------------------

#Estados Unidos: US$ 20,933 trilhões
#China: US$ 14,723 trilhões
#Japão: US$ 5,049 trilhões
#Alemanha: US$ 3,803 trilhões
#Reino Unido: US$ 2,711 trilhões
#Índia: US$ 2,709 trilhões
#França: US$ 2,599 trilhões
#Itália: US$ 1,885 trilhão
#Canadá: US$ 1,643 trilhão
#Coreia do Sul: US$ 1,631 trilhão
#Rússia: US$ 1,474 trilhão
#Brasil: US$ 1,434 trilhão
#Austrália: US$ 1,359 trilhão
#Espanha: US$ 1,278 trilhão
#México: US$ 1,076 trilhão

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
            '#022873', # América do norte (azul)
            '#F23D6D', # Oceania (rosa)
            'gray',    # Outros (cinza)
            '#03A62C') # América do sul (verde)

#------------------------- plotting -------------------------------------

fig <- data %>%
  plot_ly(
    x = ~cases/pop, 
    y = ~deaths/pop, 
    size = ~vac2/pop, 
    color = ~continent, 
    frame = ~date, 
    text = ~location, 
    hoverinfo = "text",
    type = 'scatter',
    mode = 'markers'
  )
fig <- fig %>% layout(
  xaxis = list(
    type = "log"
  )
)

fig

