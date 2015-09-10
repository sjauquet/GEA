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

## Paramètres existants / available parameters

Les paramètres disponibles sont 
-- {"turnOff"} -- Eteint le périphérique concenné  / Switch off the module
-- {"turnOn"} -- Allume le périphérique concerné  / Switch on the module
-- {"Inverse"} -- On vérifie si le périphérique est DESACTIVE au lieu d'activé / Check if the module is NOT activate instead of activated
-- {"Repeat"} -- On répete les avertissements tant que le périphérique n'a pas changé d'état. / Repeating the actions as long as the condition is ok
-- {"Portable", <id>} -- {"Portable", 70} -- Le message associé à ce périphérique sera envoyé à ce portable au lieu de ceux par défaut / Push message will be send to this(these) smartphone instead of default one
-- {"Scenario", <id>} -- {"Scenario", 2} -- Lance le scénario avec l'identifiant 2 / Start the scene XXX
-- {"StopScenario", <id>} -- {"StopScenario", 2} -- Arrête le scénario avec l'identifiant 2 / Stop the scene XXX
-- {"EnableScenario", <id>} -- {"EnableScenario", 2} -- Active le scénario avec l'identifiant 2 / Enable the scene XXX
-- {"DisableScenario", <id>} -- {"DisableScenario", 2} -- Désactive le scénario avec l'identifiant 2 / Disable the scene XXX
-- {"Value", <value>} -- {"Value", 20} -- Met la valeur 20 dans le périphérique - dimmer une lampe. / Change the value of the dimmer
-- {"Value", <id>, <value>} -- {"Value", 30, 20} -- Met la valeur 20 dans le périphérique 30 - dimmer une lampe. / Change the value of the dimmer ID 30
-- {"Open"} -- Ouvre le volet. / Open the shutter
-- {"Open", <value>} -- {"Open", 20} -- Ouvre le volet de 20%. / Open the shutter for 20%
-- {"Open", <id>, <value>} -- {"Open", 30, 20} -- Ouvre le volet 30 de 20%. / Open the shutter (id 30) for 20%
-- {"Close"} -- Ferme le volet. / Close the shutter
-- {"Close", <value>} -- {"Close", 20} -- Ferme le volet de 20%. / Close the shutter for 20%
-- {"Close", <id>, <value>} -- {"Close", 30, 20} -- Ferme le volet 30 de 20%. / Close the shutter (id 30) for 20 %
-- {"Global", <variable>, <valeur>} -- {"Global", "Maison", "Oui"} -- Met la valeur "Oui" dans la variable globale "Maison" / Update the global variable, put "Oui" in the variable called "Maison"
-- *{"Time", <from>, <to>} -- {"Time", "22:00", "06:00"} -- Ne vérifie le périphérique QUE si nous sommes dans la/les tranches horaires / Check only if the time is in range
-- {"Armed"} -- Uniquement si le module est armé / Check only it the module is armed
-- {"Disarmed"} -- Uniquement si le module est désarmé / Check only if the module is disarmed
-- {"setArmed", <id_module>} -- Arme le module / Armed the module
-- {"setDisarmed", <id_module>} -- Désarme le module / Disarmed the module
-- {"DST"} -- En mode "saving time" uniquement - en mode heure d'été / Only if we are un summer time
-- {"NOTDST"} -- En mode "spending time" - en mode heure d'hiver / Only if we are un winter time
-- {"VirtualDevice", <id,_module>, <id_bouton>} -- {"VirtualDevice", 2, 1} -- Press le bouton (id 1) du module virtuel (id 2) / Press the button 1 from the virtual device Id 2
-- {"Label", <id_module>, <name>, <message>} -- {"Label", 21, "Label1", "activé"} -- Affiche "activé" dans le label ""ui.Label1.value" du module virtuel 21 / Update the value of a label
-- {"WakeUp", <id,_module>} -- {"WakeUp", 54} -- Essai de réveillé le module 54 / Try to wake up a module
-- {"Email", <id_user>,} -- {"Email", 2} -- Envoi le message par email à l'utilisateur 2 / Send an email to a specific usermodule
-- {"picture", <id_camera>, <id_user>,} -- {"picture", 2, 3} -- Envoi une capture de la caméra 2 à l'utilisateur 3 / Send a capture of camera 2 to user 3
-- {"Group", <numero>} -- {"Group", 2} -- Attribut cet événement au groupe 2 / Group attribution
-- {"Slider", <id_module>, <id_slider>, <valeur>} -- {"Slider", 19, "1", 21} -- Met 21 dans le slider 1 du module 19 / Update de slider, put 21 into the slider 1 from the virtual device id 19
-- {"Program", <id_module>, <no>} -- {"Program", 19, 5} -- Exécute le programme 5 du module RGB 19 / Start the program 5 from the RBG module id 19
-- {"RGB", <id_module>, <col1>, <col2>, <col3>, <col4>} -- {"RGB", 19, 100, 100, 0, 100} -- Modifie la couleur RGB du module 19 / Change the color of a RGBW module id 19
-- {"Days", "Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, All, Weekday, Weekend"} -- {"Days", "Weekday"} -- uniquement les jours de semaines / add days condition 
-- {"Dates", "01/01[/2014]", "31/06[/2014]"} -- Seulement si la date est comprise entre le 1er janvier et le 31 juin inclus / Add date range !! French date format
-- {"StopTask", <id_task>} -- Stop  la tâche / stop the task
-- {"RestartTask", <id_task>} -- Redémarre la tâche / Restart the task
-- {"MaxTime", <number>} -- Stop après X execution / Stop after X run
-- {"CurrentIcon", <id_module>, <id_icone>} -- modifie l'icone d'un module virtuel
-- {"If", {<condition>[,<condition>[,...]}} -- Uniquement si toutes les conditions sont respectée / Add more condition 

## Historique / History

http://www.domotique-fibaro.fr/index.php/topic/1082-gea-gestionnaire-dévénements-automatique/?p=12428

## Credits

Auteur : Steven P. with modifications of Hansolo and Shyrka973
Version : 5.40

Special Thanks to :
jompa68, Fredric, Diuck, Domodial, moicphil, lolomail, byackee, JossAlf, Did, sebcbien, chris6783 and all other guy from Domotique-fibaro.fr