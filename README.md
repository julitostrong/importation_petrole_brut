# importation_petrole_brut

Rapport sur l’Application Shiny d’Analyse des Importations de Pétrole Brut aux États-Unis
Author
Goulia Junias - Tébili Stéphanie

Published
May 21, 2024

lien de l’Application:
https://gouliajunias.shinyapps.io/import_petrole/

Contexte
Le pétrole brut est une ressource essentielle pour l’économie mondiale, et les États-Unis, en tant que l’un des plus grands consommateurs de pétrole, importent une quantité significative de cette ressource depuis divers pays. Cette application Shiny a été développée pour analyser et visualiser les données d’importation de pétrole brut aux États-Unis de 2009 à janvier 2024.

Problématique
La gestion et l’analyse des données d’importation de pétrole brut sont cruciales pour comprendre les tendances du marché, les dépendances énergétiques et les dynamiques internationales. La problématique de ce projet est de déterminer comment visualiser et analyser efficacement les données d’importation de pétrole brut aux États-Unis pour identifier les tendances temporelles, les variations par pays d’origine et les différences de qualité du pétrole importé. Plus précisément, nous cherchons à répondre aux questions suivantes :

- Quelles sont les tendances des importations de pétrole brut aux États-Unis au fil du temps ?

- Quels sont les principaux pays exportateurs de pétrole brut vers les États-Unis ?

- Comment la qualité du pétrole importé varie-t-elle selon le pays et l’année ?

Intérêt et Objectifs
L’Intérêt de cette application est de fournir un outil interactif pour analyser les tendances des importations de pétrole brut aux États-Unis. Les utilisateurs peuvent explorer les données par année, par pays d’origine, et par qualité du pétrole. Aussi acceder à la cartographie et au classement des pays exportateurs de pétrole brut vers les U.S.A.

Les principaux objectifs incluent :

- Analyser l’évolution des importations de pétrole brut au fil du temps.

- Explorer les pays d’origine des importations de pétrole brut des États-Unis.

- Visualiser la répartition des importations par pays et analyser les tendances au fil du temps.

Méthodologie
Source des Données
Les données utilisées dans cette application proviennent d’un fichier CSV nommé data.csv téléchargeable sur le site de kaggle (https://www.kaggle.com/datasets/alistairking/u-s-crude-oil-imports). Ce fichier contient des informations détaillées sur les importations de pétrole brut aux États-Unis, y compris les variables année (year), mois (month), le pays d’origine (originName), la qualité du pétrole (gradeName) et la quantité importée (quantity) auxquelles nous nous sommes intéressez dans cette étude. Les quantités importées enregistrées dans la base de données sont en millier de barils.

Préparation des Données
Les données ont été importées, nettoyées et formatées pour être utilisées dans l’application Shiny. Les étapes suivantes ont été effectuées :

- Conversion des colonnes year, month, originTypeName et quantity (en millier de barils) en types de données appropriés.

- Conversion de la variable month, où les mois étaient representés par les numeros de mois, nous les avons ramener en noms de mois. pour des raisons particulières, Plutôt que d’utiliser une fonction dédiée, nous avons été obligés de definir un ordre habitraire pour R mais selon l’ordre des mois d’une année.

- Filtrage des données pour inclure uniquement les importations provenant de pays spécifiques (en excluant les types de lieux non pertinents).

- Nous avons été cherchés des données géographiques des pays (longitude et latitude) pour le compte de la visualisation sur carte.

- Au vu des totaux élevés, plus loin nous avons diviser toutes les sommes totales par 1000 pour lisibilité fluide sur les graphiques, Ainsi sur les graphes les observations en ordonnée sont en millions de barils vu qu’elles étaient deja en milliers de barils.
