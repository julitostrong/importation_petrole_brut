
# Définir l'interface utilisateur (UI)
ui <- fluidPage(
  # Titre de l'application
  titlePanel("Analyse des importations de pétrole brut aux États-Unis"),
  
  # Menu de navigation
  navbarPage("Navigation",
             tabPanel("Accueil",
                      tags$ul(tags$li(h3("Bienvenue sur cette Application consacrée à l'analyse des importations de pétrole brut aux États-Unis"))),
                      h3("(2009 à Jan. 2024)"),
                      p("Le pétrole brut est une substance pétrolière non raffinée, \n
                        composée de dépôts naturels d’hydrocarbures et d’autres matières organiques. \n
                        En tant que combustible fossile, il est raffiné pour créer des produits utilisables \n
                        tels que l’essence, le diesel et divers produits pétrochimiques. \n
                        Les États-Unis importent du pétrole brut de plusieurs pays pour compléter leur production domestique."),
                      plotOutput("carte_USA"),
                      p("Dans cette application il sera question de:"),
                      tags$ul(tags$li(p("Analyser l'évolution des importations de pétrole brut au fil du temps")),
                              tags$li(p("Explorer les pays d'origine des importations de pétrole brut des États-Unis")),
                              tags$li(p("Visualiser la répartition des importations par pays et analyser les tendances au fil du temps."))
             )),
             tabPanel("Analyse",
                      sidebarLayout(
                        sidebarPanel(
                          # Sélecteur d'année
                          selectInput("year", "Sélectionnez une année :", 
                                      choices = unique(data_import$year)),
                          # Sélecteur de pays
                          selectInput("country", "Sélectionnez un pays exportateur :", 
                                      choices = c("Tous", unique(data_import$originName))),
                          # Sélecteur de qualité du pétrole
                          selectInput("qualite", "Sélectionnez une qualité :", 
                                      choices = c("Tous", unique(data_import$gradeName)))
                        ),
                        mainPanel(
                          tabsetPanel(
                            tabPanel("Nuage de points",
                                     h3("Nuage de points des Importations de pétrole brut par mois"),
                                     plotlyOutput("nuage_points"),
                                     ),
                            tabPanel("Histogramme", 
                                     fluidRow(
                                       h3("Diagramme en barre des Importations par mois"),
                                       column(12, plotlyOutput("histogramme")),
                                       fluidRow(
                                         column(12, HTML("<br><br><br>"))
                                       ),
                                       h3("Importations de pétrole brut aux États-Unis par Année (De 2009 à Jan.2024)"),
                                       column(12,
                                              plotlyOutput("histogramme_2"),
                                              selectInput("country_2", "Choisir un pays exportateur en particulier:", 
                                                          choices = c("Tous",unique(data_import$originName)))
                                              )
                            ),
                            p(HTML("<b>Interpretation:</b>")),
                            p("Pendant la dernière décennie, les États-Unis enregistrent leur plus grande importation annuelle de \n 
                              pétrole brut en 2010 avec plus de 24.39548k Millions de barils importés, son principale fournisseur \n 
                              cette année-là est le Canada avec plus de 5,O14.975 Millions exportés vers les USA. Son deuxième pic \n 
                              d’importation est enregistré en 2017 avec plus de 20.37083k Millions de barils importés dont \n 
                              8,805.349 venus du Canada qui demeure son principal fournisseur. Le dernier et 3ème pic en date est \n 
                              en 2023 avec plus de 16.49191k Millions de barils importés, dont 9.83376k Millions venus du canada \n 
                              encore le principal fournisseur."),
                            p("Ce diagramme présente une tendance globalement décroissante, ce qui s’explique par une volonté,\n 
                              comme tout pays producteur, d’atteindre un niveau satisfaisant d’autosuffisance en pétrole brut. Les\n 
                              États-Unis, gros producteur mondial de pétrole brut, produisent de plus en plus une quantité \n 
                              suffisante pour leur consommation nationale, et la vente à l'internationale.")),
                            tabPanel("Série chronologique", 
                                     fluidRow(
                                       h3("série chronologique des importations de pétrole brut"),
                                       column(12, plotlyOutput("serie_chronologique")),
                                       fluidRow(
                                         column(12, HTML("<br><br><br>"))
                                         ),
                                       h3("Importations annuelles de pétrole brut aux États-Unis par Année (De 2009 à Jan. 2024)"),
                                       column(12,
                                              plotlyOutput("serie_chronologique_2"),
                                              selectInput("country_3", "Choisir un pays exportateur en particulier:", 
                                                          choices = c("Tous",unique(data_import$originName)))
                                       )
                                     ),
                                     p(HTML("<b>Interpretation:</b>")),
                                     p("Pendant la dernière décennie, les États-Unis enregistrent leur plus grande importation annuelle de \n 
                                       pétrole brut en 2010 avec plus de 24.39548k Millions de barils importés, son principal fournisseur \n 
                                       cette année-là est le Canada avec plus de 5,O14.975 Millions exportés vers les USA (voir l'onglet classement). Son deuxième pic \n 
                                       d’importation est enregistré en 2017 avec plus de 20.37083k Millions de barils importés dont \n 
                                       8,805.349 venus du Canada qui demeure son principal fournisseur. Le dernier et 3ème pic en date est \n 
                                       en 2023 avec plus de 16.49191k Millions de barils importés, dont 9.83376k venus du canada \n 
                                       encore le principal fournisseur. "),
                                     p("Cette courbe présente une tendance globalement décroissante, ce qui s’explique par une volonté,\n
                                       comme tout pays producteur, d’atteindre un niveau satisfaisant d’autosuffisance en pétrole brut. Les\n 
                                       États-Unis, gros producteur mondial de pétrole brut, produisent de plus en plus une quantité\n 
                                       suffisante pour leur consommation nationale, également pour la vente à l'extérieur.")),
                            tabPanel("Classement", 
                                     fluidRow(
                                       column(6, h3("Top 5 des pays exportateurs pour une année donnée"),
                                              p("sélectionnez uniquement l'année dans la barre latérale"),
                                              plotlyOutput("top_export_year")),
                                       column(6, h3("Classement des qualités de pétroles importés pour une année donnée"), 
                                              p("sélectionnez uniquement l'année dans la barre latérale"),
                                              plotlyOutput("top_qualite_year"))
                                     ),
                                     fluidRow(
                                       column(6, h3("Top 5 des pays exportateurs depuis 2009 (Années confondues)"), 
                                              plotlyOutput("top_export")),
                                       column(6, h3("Classement des qualités de pétroles importés depuis 2009 (Années confondues)"), 
                                              plotlyOutput("top_qualite"))
                                     ),
                                     p(HTML("<b>Interpretation:</b>")),
                                     p("Les principaux fournisseurs de pétrole brut des Etats-Unis pour chaque année et toutes les années \n
                                       confondues depuis 2009 restent en moyenne le canada, le Mexique et l’Arabie Saoudite.\n
                                       Cela s’explique par le fait que le Canada et le Mexique sont pays frontaliers des Etats-Unis, ce \n 
                                       qui est bénéfique du point de vue coût de transport. D’un autre côté, bien qu’éloigné, l’Arabie \n 
                                       Saoudite, faisant partie de l’OPEP (Organisation des Pays Exportateurs de Pétrole) est un gros \n 
                                       producteur de pétrole au monde. D’où l’importance d’y faire venir du pétrole pour des \n 
                                       raison non seulement économiques mais aussi géopolitiques. "),
                                     p("La Russie gros producteur et membre de l’OPEP+ a cessé de faire partie des fournisseurs de \n 
                                       pétrole des USA depuis 2021. En effet, La crise Russo-ukrainienne, avec l’invasion de \n 
                                       l’Ukraine par la Russie en Février 2022, a rompu les relations entre les deux états. \n
                                       L’Iraq pays de l’OPEP qu’on peut aussi citer d’exportateur important de pétrole vers les Etats-Unis \n 
                                       a enregistré sa plus grande exportation en 2018 avec plus de 1,5 milliard de barils."),
                                     p("Il faut noter que les USA restent l’un des plus gros consommateurs de pétrole brut dans le \n 
                                       monde, on peut donc en imaginer sa dépendance. Mais sa politique vis-à-vis de ses \n 
                                       importations peut être jugée bonne au regard de la diversité de ses fournisseurs. Rappelons également \n 
                                       que les USA font partie des pays qui ont une grosse part de production mondiale de pétrole. \n 
                                       Mais pour satisfaire son utilité marginale en pétrole il faut en importer."),
                                     p("Par ailleurs, On peut voir que les qualités de pétrole Fort Aigre (Heavy Sour) et moyenne \n 
                                       (medium) restent les plus importées depuis 2009 avec respectivement 149.6502k Millions et 93.05559k Millions de barils."))
                        )
                      )
             )),
             tabPanel("Visualisation carte",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("map_year", "Choisir une année:", choices = unique(data_import$year))
                        ),
                        mainPanel(
                          leafletOutput("map"),
                          h3("Répartition géospatiale des pays exportateurs de pétrole brut vers les U.S.A"),
                          p("Cliquez sur un pays pour voir le nom et la quantité exportée en fonction de l’année sélectionnée.")
                        )
                      )),
             tabPanel("DataBase",
                      h1("Base de données"),
                      DT::dataTableOutput("table"),
                      #Résumé statistique
                      h1("Résumé statistique"),
                      verbatimTextOutput("summary")
             ),
             tabPanel("À propos",
                      h2("À propos de cette application"),
                      p("Cette application a été conçue  pour analyser les importations de pétrole brut aux États-Unis de 2009 à Janvier 2024."),
                      p("Elle est utile dans le sens où elle aide à comprendre les différentes tendances de ces importations. \n 
                        Elle aide également à ouvrir d’autres perspectives à savoir faire des prédictions sur les tendances \n 
                        futures ou étudier l’impact du pétrole sur l’économie Américaine..."),
                      p("Pour plus d'informations, visitez:"),
                      tags$ul(
                        tags$li(a(href = "https://www.kaggle.com/datasets/alistairking/u-s-crude-oil-imports", 
                                  "Lien kaggle-Base de données"))
                      ),
                      h3("Auteurs de cette application "),
                      tags$ul(
                        tags$li(p("GOULIA JUNIAS  /", 
                                  a(href = "https://www.linkedin.com/feed/", "Lien linkedin-Goulia-Junias     /"),
                                  a(href = "https://github.com/julitostrong", "Lien Github-Goulia-Junias"))),
                        tags$li(p("TEBILI STEPHANIE"))
                      ),
                      HTML("<b><b><b><b><b><b>"),
                      p("Date d'édition: Mai 2024")
             )
  )
)

