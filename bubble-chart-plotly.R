#------------------------- packages ---------------

#library(ggplot2)
library(plotly)
library(dplyr)
library(Hmisc) # %nin% 

# ------------------------ clean data --------------

data <- read.csv("owid-covid-data.csv")

data <- data %>% 
  group_by(location) %>%
  summarise(continent = max(continent),
            pop = max(population,na.rm = TRUE),
            cases = max(total_cases,na.rm = TRUE),
            deaths = max(total_deaths,na.rm = TRUE),
            vac1 = max(people_vaccinated - people_fully_vaccinated,
                       na.rm = TRUE), 
            vac2 = max(people_fully_vaccinated,na.rm = TRUE))

data <- data %>% mutate(cases = ifelse(!(cases>=0), 0, cases),
                        deaths = ifelse(!(deaths>=0), 0, deaths),
                        vac1 = ifelse(!(vac1>=0 ), 0, vac1), 
                        vac2 = ifelse(!(vac2>=0), 0, vac2))


data <- data %>% filter(location %nin% c("World",
                                         "Asia",
                                         "Europe",
                                         "North America",
                                         "European Union",
                                         "South America",
                                         "Africa"))

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

fig <- plot_ly(data, x = ~ (cases/pop) * 100,
               y = ~ (deaths/pop) * 100,
               text = ~location,
               type = 'scatter',
               mode = 'markers',
               marker = list(size = ~ (vac2/pop) * 100,
                             opacity = 0.5, 
                             color = 'blue'))

fig <- fig %>% layout(title = "COVID-19 vaccinations of top 15 GPD countries",
                      xaxis = list(showgrid = FALSE,rangemode: 'tozero'),
                      yaxis = list(showgrid = FALSE,rangemode: 'tozero'))

fig

