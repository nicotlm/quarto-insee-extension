# Chargement des données pour illustrer le parametrage en externalisation dans le fichier params.yml

# INITIALISATION PACKAGE --------------------

library(dplyr)

## RECUPERATION PARAMS.YML --------------------

# params <- yaml::read_yaml("params.yml")

## INITIALISATION FONCTIONS --------------------

filtrerParAnnee <- function(df){
  
  res <- df %>% dplyr::filter(ANNEE == params$annee)
  
  return(res)
  
}

filtrerParDepartement <- function(df){
  
  res <- df %>% dplyr::filter(DEP == params$codeDepartement)
  
  return(res)
  
}

filtrerParTypequ <- function(df){
  
  res <- df %>% dplyr::filter(TYPEQU == params$typeEquipement)
  
  return(res)
  
}

## IMPORTATION DES DONNEES  --------------------

jeuDonnees <- read.csv2(file = "data/jeuDeDonnees_test_param.csv",
                        sep = ";",
                        encoding = "UTF-8",
                        colClasses = "character")


## FILTRAGE DES DONNEES  --------------------


donneesSelonAnneeEnParam <- filtrerParAnnee(jeuDonnees)
donneesSelonDepartementEnParam <- filtrerParDepartement(jeuDonnees)
donneesSelonTypequEnParam <- filtrerParTypequ(jeuDonnees)

