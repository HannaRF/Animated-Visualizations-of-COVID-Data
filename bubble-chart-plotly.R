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

# ------------------------ clean data --------------

data <- read.csv("Animated-Visualizations-of-COVID-Data/owid-covid-data.csv")

data <- data %>% mutate(cases = replace_na(ifelse(!(total_cases_per_million>=0),
                                                  0, total_cases_per_million), 0),
                        deaths = replace_na(ifelse(!(total_deaths_per_million>=0),
                                                   0, total_deaths_per_million), 0),
                        vac1 = replace_na(ifelse(!(people_vaccinated_per_hundred>=0 ),
                                                 0, people_vaccinated_per_hundred), 0), 
                        vac2 = replace_na(ifelse(!(people_fully_vaccinated_per_hundred>=0),
                                                 0, people_fully_vaccinated_per_hundred), 0))


data <- data %>% select(continent,
                        location,
                        date,
                        cases,
                        deaths,
                        vac1,
                        vac2)


data <- data %>% filter(location %nin% c("World",
                                         "Asia",
                                         "Europe",
                                         "North America",
                                         "European Union",
                                         "South America",
                                         "Africa"))

data <- data %>% mutate(continent = ifelse(location %in% names,
                                           continent,
                                           "others"))

data <- data[day(ymd(data$date)) %in% c(01,15), ]


#------------------------- plotting -------------------------------------

fig <- data %>%
  plot_ly(
    x = ~cases, 
    y = ~deaths, 
    #size = '~vac2/pop', #`line.width` does not currently support multiple values.
    #color = ~continent,
    #colors = colors, 
    frame = ~date, 
    
    # Hover text:
    text = ~paste("Continent: ", continent, '$<br>Country:', location),
    
    type = 'scatter',
    mode = 'markers'
  )

fig
