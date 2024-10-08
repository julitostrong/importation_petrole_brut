# Charger les packages nécessaires
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(leaflet)
library(DT)
library(maps)
# Charger les données et les nettoyer/formatage
print(getwd())
data_import <- read.csv("Données/data.csv")
data_import <- data_import |>
  mutate(#year = as.Date(year, format = "%Y"),
    year= as.numeric(data_import$year),
    #originName= as.factor(data_import$originName),
    originTypeName= as.factor(data_import$originTypeName),
    #destinationTypeName= as.factor(data_import$destinationTypeName),
    #gradeName= as.factor(data_import$gradeName),
    quantity= as.numeric(data_import$quantity),
    month = case_when(
      month == "1" ~ "January",
      month == "2" ~ "February",
      month == "3" ~ "March",
      month == "4" ~ "April",
      month == "5" ~ "May",
      month == "6" ~ "June",
      month == "7" ~ "July",
      month == "8" ~ "August",
      month == "9" ~ "September",
      month == "10" ~ "October",
      month == "11" ~ "November",
      month == "12" ~ "December",
      TRUE ~ as.character(month)  # Garder les valeurs non modifiées
    ))

# Définissons l'ordre personnalisé des mois, 
#on n'a pas pu utiliser la fonction dediée month.name à cause d'un problème sur la variable month
custom_month_order <- c("January", "February", "March", "April", "May", "June",
                        "July", "August", "September", "October", "November", "December")

# Application de l'ordre personnalisé aux mois dans notre DataFrame
data_import$month <- factor(data_import$month, levels = custom_month_order, ordered = TRUE)

# Ajouter des coordonnées géographiques pour les pays
country_coords <- data.frame(
  country = c("Belize", "Algeria", "Australia", "United Kingdom", "Vietnam", "Syria", "Chad", "Argentina", 
              "Ecuador", "Kuwait", "Saudi Arabia", "Angola", "Gabon", "Trinidad and Tobago", "China", 
              "Congo-Brazzaville", "Colombia", "Equatorial Guinea", "Peru", "Azerbaijan", "Canada", 
              "Guatemala", "Thailand", "Nigeria", "Iraq", "Libya", "Norway", "United Arab Emirates", 
              "Malaysia", "Russia", "Venezuela", "Brazil", "Mexico", "Mauritania", "Cameroon", "Indonesia", 
              "Qatar", "Oman", "Egypt", "Cote d'Ivoire", "Bolivia", "Kazakhstan", "Congo-Kinshasa", 
              "South Africa", "Netherlands", "Ghana", "Yemen", "Italy", "Brunei", "Albania", "Denmark", 
              "Papua New Guinea", "South Sudan", "Tunisia", "Barbados", "Spain", "Guyana", "Panama", 
              "The Bahamas"),
  lat = c(17.1899, 28.0339, -25.2744, 55.3781, 14.0583, 34.8021, 15.4542, -38.4161, -1.8312, 29.3117, 
          23.8859, -11.2027, -0.8037, 10.6918, 35.8617, -0.228, 4.5709, 1.6508, -9.19, 40.1431, 56.1304, 
          15.7835, 15.870, 9.082, 33.2232, 26.3351, 60.472, 23.4241, 4.2105, 61.524, 6.4238, -14.235, 
          23.6345, 21.0079, 12.3547, -0.7893, 25.3548, 21.5126, 26.8206, 7.5399, -16.2902, 48.0196, 
          -4.0383, -30.5595, 52.1326, 7.9465, 15.5527, 41.8719, 4.5353, 41.1533, 56.2639, -6.31499, 
          6.877, 33.8869, 13.1939, 40.4637, 4.8604, 8.537, 25.0343),
  lon = c(-88.4976, 1.6596, 133.7751, -3.436, 108.2772, 39.4667, 18.7322, -63.6167, -78.1834, 47.4818, 
          45.0792, 17.8739, 11.6094, -61.2225, 104.1954, 15.8277, -74.2973, 10.2679, -75.0152, 47.5769, 
          -106.3468, -90.2308, 100.9925, 8.6753, 43.6793, 17.2283, 8.4689, 53.8478, 101.9758, 105.3188, 
          -66.5897, -51.9253, -102.5528, -10.9408, 15.4542, 113.9213, 51.1839, 55.9233, 30.8025, 
          -5.5471, -63.5887, 66.9237, 21.7587, 22.9375, 5.2913, -1.0232, 48.5164, 12.5674, -2.1311, 
          20.1683, 134.5825, 30.0672, 10.165, -3.7492, -58.9302, -79.3871, -77.3963, -77.3963, NA)
)
#Base de donnée final
data_import <- data_import %>% 
  filter(originTypeName == "Country")
