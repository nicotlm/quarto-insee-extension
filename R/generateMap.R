load(file = "data/donnees_carte.Rdata")


library(leaflet)
library(RColorBrewer)
library(htmltools)
library(sf)

# Palettes
color_com_rurale <- colorFactor(c("#a6cee3","#fb9a99","#e31a1c","#1f78b4","#b2df8a","#33a02c"), com_sf$LIB_TYPO_DENSITE) # brewer.pal(length(unique(com_sf$LIB_TYPO_DENSITE)
color_college_proximite <- colorFactor(brewer.pal(length(unique(com_sf$com_college_lib)), "Paired"), com_sf$com_college_lib)
color_lycee_gen_proximite <- colorFactor(brewer.pal(length(unique(com_sf$com_lycee_gen_lib)), "Paired"), com_sf$com_lycee_gen_lib)
color_college_temps <- colorBin("Blues", com_sf$TEMPS_MOYEN, 5, pretty = TRUE,reverse = FALSE)
color_lycee_gen_temps <- colorBin("Blues", com_sf$TEMPS_MOYEN_lycee_gen, 5, pretty = TRUE,reverse = FALSE)

# Carte interactive
output_map <- leaflet(options = leafletOptions(zoomControl = TRUE,
                                 minZoom = 1, maxZoom = 15)) %>%
  
  addProviderTiles(providers$CartoDB.Positron, group = "Positron") %>%
  addTiles(group = "OSM") %>%
  addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
  
  # EPCI
  addPolygons(data = epci %>% 
                st_transform(4326),
              opacity = 3,
              group = "Intercommunalités",
              color =  "#85929e", stroke = TRUE, weight = 2,
              fill = FALSE, fillOpacity = 1,
              label = ~paste(libelle),
              highlightOptions = highlightOptions(
                color = "#e52165", opacity = 1, weight = 3, fillOpacity = 0,
                bringToFront = TRUE, sendToBack = FALSE)
  ) %>%
  
  # Grille de densité
  addPolygons(data = com_sf %>% st_transform(4326),
              group = "Grille de densité",
              stroke = FALSE,opacity = 2,
              color = ~presence_college_bordure,weight = 1,
              fill = TRUE,
              fillColor = ~color_com_rurale(LIB_TYPO_DENSITE),
              fillOpacity = 0.9,
              label = ~popuptext_college
  ) %>%
  addLegend(pal = color_com_rurale,
            values = com_sf$LIB_TYPO_DENSITE,
            group = "Grille de densité",
            position = 'bottomleft') %>%
  
  # Proximité college
  addPolygons(data = com_sf %>% 
                st_transform(4326),
              group = "Proximite college",
              stroke = TRUE,opacity = 2,
              color = ~presence_college_bordure,
              weight = 1,
              fill = TRUE,
              fillColor = ~color_college_proximite(com_college_lib),
              fillOpacity = 0.9,
              label = ~popuptext_college
  ) %>%
  addLegend(pal = color_college_proximite,
            values = com_sf$com_college_lib,
            group = "Proximite college",
            position = 'bottomleft') %>%
  
  # Temps college
  addPolygons(data = com_sf %>%
                st_transform(4326),
              group = "Temps college",
              stroke = TRUE,opacity = 2,
              color = ~presence_college_bordure,
              weight = 1,
              fill = TRUE,
              fillColor = ~color_college_temps(TEMPS_MOYEN),
              fillOpacity = 0.9,
              label = ~popuptext_college
  ) %>%
  addLegend(pal = color_college_temps,
            values = com_sf$TEMPS_MOYEN,
            group = "Temps college",
            position = 'bottomleft') %>%
  
  # Proximité Lycee generam
  addPolygons(data = com_sf %>%
                st_transform(4326),
              group = "Proximite lycee general",
              stroke = TRUE,opacity = 2,
              color = ~presence_lycee_gen_bordure,
              weight = 1,
              fill = TRUE,
              fillColor = ~color_lycee_gen_proximite(com_lycee_gen_lib),
              fillOpacity = 0.9,
              label = ~popuptext_lycee_gen
  ) %>%
  addLegend(pal = color_lycee_gen_proximite,
            values = com_sf$com_lycee_gen_lib,
            group = "Proximite lycee general",
            position = 'bottomleft') %>%
  
  # Temps lycee_gen
  addPolygons(data = com_sf %>%
                st_transform(4326),
              group = "Temps lycee general",
              stroke = TRUE,opacity = 2,
              color = ~presence_lycee_gen_bordure,
              weight = 1,
              fill = TRUE,
              fillColor = ~color_lycee_gen_temps(TEMPS_MOYEN_lycee_gen),
              fillOpacity = 0.9,
              label = ~popuptext_lycee_gen
  ) %>%
  addLegend(pal = color_lycee_gen_temps,
            values = com_sf$TEMPS_MOYEN_lycee_gen,
            group = "Temps lycee general",
            position = 'bottomleft') %>%
  
  
  addLayersControl(
    baseGroups = c("Positron","OSM", "Satellite"),
    overlayGroups = c("Intercommunalités","Grille de densité","Proximite college","Temps college","Proximite lycee general","Temps lycee general"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  hideGroup(c("Grille de densité","Proximite college","Intercommunalités","Proximite lycee general","Temps lycee general"))