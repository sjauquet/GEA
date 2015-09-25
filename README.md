# GEA (Gestionnaire d'Evénements Automatique)

Scénario permettant de contrôler si un périphérique est activé depuis trop longtemps ou lancer un push d'avertissement.
Ce scénario permet une annotation plus simple que le code LUA. Il nécessite néanmoins quelques connaissances.

This scene allow you to check every X second the status of a module and send actions if the module is activated since too long.
This scene allow you a more simple annotation than LUA. It requires some knowledge.

## Installation / Setup

- Depuis le panneau des variables, créer une variable (simple) appelée "GEA_Tasks" (son contenu n'a pas d'importance).
On the variable panel, create a simple variable called "GEA_Tasks" with a random content.

- Créer un scénario en mode LUA.
Create a scene in LUA mode.

- Insérer le script GEA.lua en le copiant-collant.
Insert GEA.lua script with copy-paste.

- Configurer GEA avec la fonction configure si besoin.
Configure GEA with configure function if necessary.

- Ajouter vos événements dans la fonction setEvents. Vous pouvez vous servir des exemples du fichier samples.lua et les copier dans cette fonction.
Add yours events in the setEvents function. You can grab samples in samples.lua file and copy them in this function.

## Usage / How to use

Ce script a pour but de contrôler, à intervalles réguliers, l'état de votre environnement pendant une durée déterminée afin de vous avertir d'éventuels soucis et si nécessaire d'effectuer automatiquement certaines actions.
This script is designed to control at regular intervals the state of your environment for a specified time to alert you to potential problems and if necessary to automatically perform certain actions.

```lua
-- Exemple de condition IF / IF Sample condition
local estChome             = {"Global", "JourChome", "OUI"}
local estTravail           = {"Global", "JourChome", "NON"}
local estSafe              = {"Global", "Intrusion", "NON"}
local estFerme             = {"Value", id["PORTE_ENTREE"], "0"}
local estVac               = {"Global", "Chauffage", "VACANCES"}
local enfantsVac           = {"Global", "VacScolaire", "0"}
local enfantsEcole         = {"Global!", "VacScolaire", "0"}
local co2Correct           = {"Global-", "CO2", "900"}
local garageAvertissement  = {"Global", "GEA_Garage", "ON"}
local lampeEscalierEteinte = {"Value", id["APLIQUE_ESCALIER"], 0}
local lampeEscalierAllumee = {"Value+", id["APLIQUE_ESCALIER"], 0}
local bsoAuto              = {"Global!", "BSO", "Manuel"}
local ifbso                = {"If", {bsoAuto, enfantsEcole}}

-- GEA.add({ {"Alarm", id["GEA_ALARMS"]}, enfantsEcole}, 0, "Poële mode auto à #value#")
-- GEA.add(id["CO2"], 5*60, "", {{"Global", "CO2", "#value#"}})

-- Timer toutes les heures
-- Chaque heure je rafraichis mon agenda / Every hours I refresh my calendar
GEA.add( true , 60*60, "", {
  {"VirtualDevice", id["AGENDA"], "12"}, {"Repeat"}
})

-- Timer tous les jours / all days timer
GEA.add( true , 30, "", {
  {"Time", "01:00", "01:05"}, 
  {"Global", "GEA_Garage", "ON"}
})

-- Deux fois par jour / twice a day timer
GEA.add( true , 30, "", {
  {"Time", "01:00", "01:00"}, {"Time", "12:00", "12:00"}, 
  {"VirtualDevice", id["METEOALERTE"], 5},
  {"VirtualDevice", id["VACANCES_SCOLAIRES"], 1},
  {"VirtualDevice", id["BRITA__FILTRE_"], 3},
  {"VirtualDevice", id["PLUIE"], 7},
  {"VirtualDevice", id["MY_BATTERIES"], 11},
  {"VirtualDevice", id["ANDROID_FILES"], 2}
})

-- === DIVERS === --
-- Variable global
--GEA.add({"Global", "Capsule", "100"}, -1, "Recommander du café") 
-- Avertir s'il fait froid dans le salon // Cold in the living room ?
GEA.add({"Value-", id["TEMP"], 18}, 30*60, "Il fait froid au salon #value# à #time#")
-- Vérification des piles  une fois par jour // Checking batteries once a day
--  GEA.add({"Batteries", 60}, 24*60*60, "", {{"Repeat"}})
```

## Historique / History

http://www.domotique-fibaro.fr/index.php/topic/1082-gea-gestionnaire-dévénements-automatique/?p=12428

## Credits

Auteur : Steven P. with modifications of Hansolo and Shyrka973
Version : 5.40

Special Thanks to :
jompa68, Fredric, Diuck, Domodial, moicphil, lolomail, byackee, JossAlf, Did, sebcbien, chris6783 and all other guy from Domotique-fibaro.fr