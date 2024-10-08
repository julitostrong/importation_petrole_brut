
# Définir le serveur

server <- function(input, output, session) {
  
  output$carte_USA <- renderPlot({
    ggplot(map_data("state"))+aes(x=long,y=lat,group=group)+
      geom_polygon(fill="white",color="black")+coord_quickmap()
  })
  # Filtrer les données en fonction de l'année sélectionnée et du pays
  donnees_filtrees <- reactive({
    filtered_data <- data_import %>%
      filter(year == input$year)
    if (input$country != "Tous") {
      filtered_data <- filtered_data %>%
        filter(originName == input$country)
    }
    
    if (input$qualite != "Tous") {
      filtered_data <- filtered_data %>%
        filter(gradeName == input$qualite)
    }
    
    filtered_data %>%
      group_by(year, month) %>%
      summarise(quantite_totale = sum(quantity)/1000, .groups = 'drop')
  })
  
  #Filtrer les données en fonction de l'année uniquement
  donnees_filtrees_2 <- reactive({
    filtered_data_2 <- data_import
    if (input$country_2 != "Tous") {
      filtered_data_2 <- filtered_data_2 %>%
        filter(originName == input$country_2)
    }
    filtered_data_2 %>%
      group_by(year)  %>%
      summarise(quantite_totale = sum(quantity)/1000, .groups = 'drop')
  })
  
  donnees_filtrees_3 <- reactive({
    filtered_data_3 <- data_import
    if (input$country_3 != "Tous") {
      filtered_data_3 <- filtered_data_3 %>%
        filter(originName == input$country_3)
    }
    filtered_data_3 %>%
      group_by(year)  %>%
      summarise(quantite_totale = sum(quantity)/1000, .groups = 'drop')
  })
 
  # Créer l'histogramme des importations de pétrole brut par mois
  output$histogramme <- renderPlotly({
    p <- plot_ly(data = donnees_filtrees(), x = ~month, y = ~quantite_totale, type = 'bar') %>%
      layout(#title = "Importations de pétrole brut aux États-Unis par mois",
             xaxis = list(title = "Mois"),
             yaxis = list(title = "Quantité importée (millions de barils)"))
    
    # Ajouter une interaction au graphique pour afficher les valeurs au survol
    p <- p %>% event_register('plotly_hover') # Activation de l'événement hover
    p # Retourner le graphique
  })
  
  # Créer l'histogramme des importations de pétrole brut par année uniquement
  output$histogramme_2 <- renderPlotly({
    p <- plot_ly(data = donnees_filtrees_2(), x = ~year, y = ~quantite_totale, type = 'bar') %>%
      layout(#title = "Importations de pétrole brut aux États-Unis par Année (De 2009 à Jan.2024)",
             xaxis = list(title = "Années"),
             yaxis = list(title = "Quantité importée (millions de barils)"))
    
    # Ajouter une interaction au graphique pour afficher les valeurs au survol
    p <- p %>% event_register('plotly_hover') # Activer l'événement hover
    p # Retourner le graphique
  })
  
  # Créer le nuage de points par mois pour une année donnée
  output$nuage_points <- renderPlotly({
    plot_ly(data = donnees_filtrees(), x = ~month, y = ~quantite_totale, type = "scatter", mode = "markers", marker = list(color = 'red')) %>%
      layout(#title = "Nuage de points des importations de pétrole brut",
             xaxis = list(title = "Mois"),
             yaxis = list(title = "Quantité importée (millions de barils)"))
  })
  
  output$serie_chronologique <- renderPlotly({
    plot_ly(data = donnees_filtrees(), x = ~month, y = ~quantite_totale, type = "scatter", mode = "lines") %>%
      layout(#title = "série chronologique des importations de pétrole brut",
             xaxis = list(title = "Mois"),
             yaxis = list(title = "Quantité importée (millions de barils)"))
  })
  
  output$serie_chronologique_2 <- renderPlotly({
    plot_ly(data = donnees_filtrees_3(), x = ~year, y = ~quantite_totale, type = "scatter", mode = "lines") %>%
      layout(#title = "série chronologique des importations de pétrole brut",
        xaxis = list(title = "Année"),
        yaxis = list(title = "Quantité importée (millions de barils)"))
  })
  
  # Fonction pour obtenir les couleurs selon la position
  get_color <- function(rank) {
    colors <- c("#FFD700", "#C0C0C0", "#CD7F32", "#FF5733", "#33FF57")
    return(colors[rank])
  }
  
  #LES TOP 5 PAR ANNEE
  
  # Calculer et afficher le top 5 des pays exportateurs par année
  top_export_data_year <- reactive({
    data_import %>%
      filter(year == input$year) %>%
      group_by(originName) %>%
      summarise(total_quantity = sum(quantity)/1000) %>%
      arrange(desc(total_quantity)) %>%
      head(5)%>%
      mutate(color = sapply(1:n(), get_color))
  })
  
  # Graphique des top 5 des pays exportateurs
  output$top_export_year <- renderPlotly({
    plot_ly(data = top_export_data_year(), x = ~reorder(originName, -total_quantity), y = ~total_quantity, type = 'bar', marker = list(color = ~color)) %>%
      layout(
        xaxis = list(title = "Pays (originName)"),
        yaxis = list(title = "Quantité importée (millions de barils)"))
  })
  
  # Calculer et afficher le classement des gradeName
  top_qualite_data_year <- reactive({
    data_import %>%
      filter(year == input$year) %>%
      group_by(gradeName) %>%
      summarise(total_quantity = sum(quantity)/1000) %>%
      arrange(desc(total_quantity))%>%
      mutate(color = sapply(1:n(), get_color))
  })
  
  # Graphique du classement des gradeName
  output$top_qualite_year <- renderPlotly({
    plot_ly(data = top_qualite_data_year(), x = ~reorder(gradeName, -total_quantity), y = ~total_quantity, type = 'bar',  marker = list(color = ~color)) %>%
      layout(
        xaxis = list(title = "Qualité (gradeName)"),
        yaxis = list(title = "Quantité importée (millions de barils)"))
  })
  
  
  #LES TOP 5 DE 2009 A JANVIER 2024
  
  # Calculer et afficher le top 5 des pays exportateurs
  top_export_data <- reactive({
    data_import %>%
      group_by(originName) %>%
      summarise(total_quantity = sum(quantity)/1000) %>%
      arrange(desc(total_quantity)) %>%
      head(5)%>%
      mutate(color = sapply(1:n(), get_color))
  })
  
  # Graphique des top 5 des pays exportateurs
  output$top_export <- renderPlotly({
    plot_ly(data = top_export_data(), x = ~reorder(originName, -total_quantity), y = ~total_quantity, type = 'bar', marker = list(color = ~color)) %>%
      layout(
             xaxis = list(title = "Pays"),
             yaxis = list(title = "Quantité importée (millions de barils)"))
  })
  
  # Calculer et afficher le classement des gradeName
  top_qualite_data <- reactive({
    data_import %>%
      group_by(gradeName) %>%
      summarise(total_quantity = sum(quantity)/1000) %>%
      arrange(desc(total_quantity))%>%
      mutate(color = sapply(1:n(), get_color))
  })
  
  # Graphique du classement des gradeName
  output$top_qualite <- renderPlotly({
    plot_ly(data = top_qualite_data(), x = ~reorder(gradeName, -total_quantity), y = ~total_quantity, type = 'bar',  marker = list(color = ~color)) %>%
      layout(
             xaxis = list(title = "Qualité (gradeName)"),
             yaxis = list(title = "Quantité importée (millions de barils)"))
  })
  
  # Affichons la carte des pays exportateurs
  output$map <- renderLeaflet({
    year_data <- data_import %>%
      filter(year == input$map_year) %>%
      group_by(originName) %>%
      summarise(total_quantity = sum(quantity), .groups = 'drop')
    
    fusion_data <- merge(country_coords, year_data, by.x = "country", by.y = "originName", all.x = TRUE)
    fusion_data$total_quantity[is.na(fusion_data$total_quantity)] <- 0
    
    leaflet() %>%
      addTiles() %>%
      addMarkers(
        data = fusion_data,
        lng = ~lon, lat = ~lat,
        popup = ~paste(country, "<br>Quantity:", total_quantity)
      )
  })
  
  # Affichage de la table de données dans l'onglet DataBase
  output$table <- renderDataTable({
    datatable(data_import)
  })
  
  # Affichage du résumé statistique dans l'onglet DataBase
  output$summary <- renderPrint({
    summary(data_import)
  })
}

# Lancer l'application Shiny
#shinyApp(ui = ui, server = server)

