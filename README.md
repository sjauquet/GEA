# GEA (Gestionnaire d'Evénements Automatiques)

Scénario permettant de contrôler si un périphérique est activé depuis trop longtemps ou lancer un push d'avertissement.
Ce scénario permet une annotation plus simple que le code LUA. Il nécessite néanmoins quelques connaissances.

This scene allow you to check every X second the status of a module and send actions if the module is activated since too long.
This scene allow you a more simple annotation than LUA. It requires some knowledge.

## Installation

- Depuis le panneau des variables, créer une variable (simple) appelée "GEA_Tasks" (son contenu n'a pas d'importance).
- Créer un scénario en mode LUA.
- Insérer le script GEA.lua en le copiant-collant.
- Adapter les premières lignes à vos besoins (au dessus de la ligne "A VOUS DE JOUER")

## Usage

Ce script a pour but de contrôler, à intervalles réguliers, l'état de votre environnement pendant une durée déterminée afin de vous avertir d'éventuels soucis et si nécessaire d'effectuer automatiquement certaines actions.

```lua
-- ----------------------------------------------------------------
  -- [FR] A partir d'ici vous trouverez ma propre configuration
  -- [FR] vous permettant ainsi d'avoir une série d'exemples
  -- [EN] From here are ma own configuration
  -- [EN] just to allow you to see some examples
  -- ----------------------------------------------------------------
  
  -- GEA.add(id["LAMPE_ESCALIER"], -1, "", {{"Global", "Test", "#value#"}})
  
  -- Exemple de condition IF // IF Sample condition
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
  
  -- Timer toutes les 5 mn
  GEA.add( true , 5*60, "", {
    {"Scenario", 294}, {"Repeat"}
  })

  -- Timer toutes les heures
  -- Chaque heure je rafraichis mon agenda // Every hours I refresh my calendar
  GEA.add( true , 60*60, "", {
    {"VirtualDevice", id["AGENDA"], "12"}, {"Repeat"}
  })
  
  -- Timer tous les jours
  GEA.add( true , 30, "", {
    {"Time", "01:00", "01:05"}, 
    {"Global", "GEA_Garage", "ON"}
  })

  -- Deux fois par jour
  GEA.add( true , 30, "", {
    {"Time", "01:00", "01:00"}, {"Time", "12:00", "12:00"}, 
    {"VirtualDevice", id["METEOALERTE"], 5},
    {"VirtualDevice", id["VACANCES_SCOLAIRES"], 1},
    {"VirtualDevice", id["BRITA__FILTRE_"], 3},
    {"VirtualDevice", id["PLUIE"], 7},
    {"VirtualDevice", id["MY_BATTERIES"], 11},
    {"VirtualDevice", id["ANDROID_FILES"], 2}
  })
  
  GEA.add({"Global", "NotificationStatus", "HOUR"}, 60*60, "", {{"Global", "NotificationStatus", "ON"}})

  
  -- === Lave-Linge == --
  GEA.add({{"Sensor+", id["LAVE_LINGE"], 1.5}, {"Sensor-", id["LAVE_LINGE"], 2.5}, {"Global", "Lave_Linge", "WAITING"}}, 30*60, "Le lave_linge est arrêté depuis #duration#", {{"Global", "Notification", "Le lave-linge est arrêté depuis #durationfull#"},{"VirtualDevice", id["NOTIFICATION_CENTER"], TypeNotification.Karotz},{"Repeat"}})
  GEA.add({"Sensor-", id["LAVE_LINGE"], 1.5}, 2*60, "OFF LL #value#", {{"turnOff", id["LAVE_LINGE"]}, {"Global", "Lave_Linge", "OFF"}}) 
  GEA.add({"Sensor+", id["LAVE_LINGE"], 3}, 2*60, "", {{"Global", "Lave_Linge", "RUNNING"}}) 
  GEA.add({{"Sensor+", id["LAVE_LINGE"], 1.0},{"Sensor-", id["LAVE_LINGE"], 2.5}, {"Global", "Lave_Linge", "RUNNING"}}, 10*60, "Runng to waiting LL #value#", {{"Global", "Lave_Linge", "WAITING"}})
  GEA.add( id["LAVE_LINGE"],-1, "OFF to Prepatation LL #value#", {{"Global", "Lave_Linge", "PREPARATION"}})

  -- Pellets en kilo ---
  GEA.add({{"Global+", "Poele", 20},{"Sensor+", 176, 5.0}}, 30*60, "Vérifier les pellets #value#", {{"Global", "Notification", "Veuillez vérifier les pellets"},{"VirtualDevice", id["NOTIFICATION_CENTER"], TypeNotification.Karotz},{"Repeat"}})  
  GEA.add({{"Global+", "Poele", 23},{"Sensor-", 176, 5.0}}, 60*60, "Vérifier les pellets #value#", {{"Global", "Notification", "Veuillez vérifier les pellets"},{"VirtualDevice", id["NOTIFICATION_CENTER"], TypeNotification.Karotz},{"Repeat"}})  
  
  -- === GARAGE == --
  -- Le scénario enverra un push toutes les 10mn tant que la porte sera ouverte // Send a push every 10 minutes when the door is open
  GEA.add( {id["DETECTEUR_PORTE"], garageAvertissement}, 10*60, "La porte du garage est ouverte depuis plus de #duration#", {{"Global", "Notification", "La porte du garage est ouverte depuis #durationfull#"},{"VirtualDevice", id["NOTIFICATION_CENTER"], TypeNotification.Karotz},{"Repeat"}})
  -- Usage immédiat. La porte du garage s'ouvre, mon Karotz m'averti et ses oreilles basculent en direction du garage
  -- Immediat scene. The door opens, my Korotz tel it to me and move its ear direct to the garage
  GEA.add({ id["DETECTEUR_PORTE"], garageAvertissement}, -1, "", {{"Global", "Notification", "La porte du garage est ouverte"},{"VirtualDevice", id["NOTIFICATION_CENTER"], TypeNotification.Karotz},{"Slider", id["OPENKAROTZ"], "4", "65"},{"Slider", id["OPENKAROTZ"], "5", "65"}})
  GEA.add( id["DETECTEUR_PORTE"], -1, "", {{"CurrentIcon", id["PORTE_GARAGE"], "238"},{"VirtualDevice", id["IMPERIHOME"],"7"}})
  -- Reset des oreilles à la fermeture du garage // Ears are moving back when the door closes
  GEA.add( id["DETECTEUR_PORTE"], -1, "", {{"Inverse"}, {"VirtualDevice", id["OPENKAROTZ"], "7"},{"VirtualDevice", id["IMPERIHOME"],"6"}, {"CurrentIcon", id["PORTE_GARAGE"], "239"}})
  -- Avertissement push si la porte du garage s'ouvre à des heures non inappropriée // Push when door opens at unexptected moment
  GEA.add ( id["DETECTEUR_PORTE"], -1, "Ouverture de la porte du garage à #time#", {{"Time", "09:00", "16:00"}, {"Days", "Monday, Tuesday, Thursday, Friday"}, {"Picture", id["CAMERA"], 2}})

  -- Surpresseur
  GEA.add({"Sensor+", id["SURPRESSEUR"], 400}, 5*60, "Supresseur éteint, vérifiez le niveau du puit", {{"turnOff", id["SURPRESSEUR"]},{"Global", "Notification", "Vérifier l eau du puit. Surpresseur éteint"},{"VirtualDevice", id["NOTIFICATION_CENTER"], TypeNotification.Karotz}}) 

  -- === LOCAL TECHNIQUE == --
  -- Eteindre automatiquement le local technique après 10 mn // Automatically turn off the light after 10 minutes
  GEA.add( id["PLAFONNIER"], 10*60, "", {{"turnOff"}}) 
  -- Allumage automatique à l'ouverture de la porte // Automatic turn on the light when the door opens
  GEA.add( id["PORTE_LOCAL"], -1, "", {{"turnOn", id["PLAFONNIER"]}})
  -- Extinction automatique à la fermeture de la porte // Automatic turn off the light when the door closes
  GEA.add( id["PORTE_LOCAL"], -1, "", {{"Inverse"},{"turnOff", id["PLAFONNIER"]}})
    
  -- Gestion de la VMC --
  -- Avertissement en cas de surconsommation // Warning if the ventilation is consumming to much
  GEA.add({"Sensor+", id["VMC_DOUBLE_FLUX"], 100}, 1*60, "Consommation excessive de la VMC #value#") 
  -- Si la température du salon est inférieur à 23° on arrète la VMC pour éviter un refroidissement excessif --
  -- sauf si la quantité de CO2 est excessive
  -- If temperature is bellow 23° we stop the ventilation except if the CO2 is to much.
  GEA.add({ {"Value-", id["TEMP"], 21}, co2Correct }, 10*60, "", {{"turnOff", id["VMC_DOUBLE_FLUX"]},{"Time","23:00","06:00"}})
  -- On rallume la VMC si elle est éteinte. // Turn on the ventilation
  GEA.add(id["VMC_DOUBLE_FLUX"], 1*60, "", {{"Inverse"},{"turnOn"},{"Time","06:00", "06:05"}})
    
    -- Réfrigérateur ---
  GEA.add({"Sensor+", id["FRIGO"], 150}, 1*60, "Consommation excessive du réfrigérateur #value# (#date# #time#)") 
  
  
  -- === CHAMBRES ENFANTS === --
  -- Dans la nuit, si une lampe est allumée plus de 10mn, on diminue son intensité de 20% 
  -- Si après 20mn la lampe est toujours allumée, on l'éteint
  -- Si la lumière des escaliers est allumée, on n'éteint pas l'éclairage des chambres
  -- During night, if children light up their room, we will dim the light to 20% after 10 min and switch off after 20 minutes
  -- this only if the stairs' light is turn off
  GEA.add( id["PLAFONNIER_NOLAN"], 10*60, "Chambre Nolan allumée 20%", {{"Time", "22:00", "06:00"}, {"Value", 20}})
  GEA.add({ id["PLAFONNIER_NOLAN"],lampeEscalierEteinte}, 20*60, "Chambre Nolan extinction", {{"Time", "22:00", "06:00"}, {"turnOff"}})
  GEA.add( id["PLAFONNIER_KENDRA"], 10*60, "Chambre Kendra allumée 20%", {{"Time", "22:00", "06:00"}, {"Value", 20}})
  GEA.add({ id["PLAFONNIER_KENDRA"],lampeEscalierEteinte}, 20*60, "Chambre Kendra extinction", {{"Time", "22:00", "06:00"}, {"turnOff"}})
  GEA.add( id["PLAFONNIER_NORA"], 10*60, "Chambre Nora allumée 20%", {{"Time", "22:00", "06:00"}, {"Value", 20}})
  GEA.add({ id["PLAFONNIER_NORA"],lampeEscalierEteinte}, 20*60, "Chambre Nora extinction", {{"Time", "22:00", "06:00"}, {"turnOff"}})

  GEA.add( id["APLIQUE_ESCALIER"], -1, "", {{"turnOn", id["LEDS_ESCALIER"]}})
  GEA.add( id["APLIQUE_ESCALIER"], -1, "", {{"Inverse"},{"turnOff", id["LEDS_ESCALIER"]}})
  GEA.add( {id["TV"],lampeEscalierAllumee}, 30, "", {{"Program", id["LEDS_ESCALIER"], 4}, {"Repeat"}})
  
  -- === ENTREE === --
  GEA.add({id["DETECTEUR_ENTREE"],{"Global", "Sortie", "0"}}, -1, "", {{"Global", "Sortie", "1"}})
  GEA.add({"Global", "Sortie", "1"}, 5*60, "", {{"Global", "Sortie", "0"}})
  GEA.add( { id["PORTE_ENTREE"],{"Global", "Sortie", "0"}}, -1, "", {{"Time", "Sunset", "Sunrise"}, {"turnOn", id["PLAFONNIER_ENTREE"]}, {"VirtualDevice", id["LUMIERE_SALON"], "2"}, {"Global", "Sortie", "2"}})
  GEA.add({"Global", "Sortie", "2"}, 5*60, "", {{"turnOff", 65}, {"Global", "Sortie", "0"}})
  GEA.add( id["PORTE_ENTREE"], -1, "Porte entrée ouverte à #time#", {{"Days","Monday,Thursday"}, {"Time","16:00","19:30"}, {"Picture", id["CAMERA_ENTREE"], 2}})
  GEA.add({id["PLAFONNIER_ENTREE"],{"Value-",id["DETECTEUR_ENTREE"],1}}, 10*60, "", {{"turnOff",65}})

  -- == Brise-Soleil // Shutters managed by a virtual device ==--
  GEA.add( {id["DETECTEUR"], estTravail, estSafe}, -1, "Intrusion détectée à #time# - #date#", {{"VirtualDevice", id["BRISE_SOLEIL"], "5"}, {"Global", "Intrusion", "OUI"}, {"Time", "09:00", "16:30"}})
  local terrassetimer = GEA.add( {"Global", "Intrusion", "OUI"}, 5*60, "", { {"Global", "Intrusion", "NON"}, {"turnOff", id["TERRASSE"]}, {"Time", "Sunset", "Sunrise"}})
  GEA.add( id["DETECTEUR"], -1, "", {{"Global", "Intrusion", "OUI"}, {"turnOn", id["TERRASSE"]}, {"Time", "Sunset+30", "Sunrise"}, {"RestartTask", terrassetimer}})
  GEA.add( {{"Global", "Intrusion", "OUI"}, {"Value-", id["TEMPERATURE"], 23}}, 30*60, "", { {"Global", "Intrusion", "NON"}, {"VirtualDevice", id["BRISE_SOLEIL"], "4"},{"Time", "09:00", "17:00"}})

  GEA.add( {id["PORTE_ENTREE"],{"Global", "Sortie", "0"}}, -1, "", {{"VirtualDevice", id["BRISE_SOLEIL"], "4"},{"Days","Weekday"}, {"Time","16:00","19:30"}})
  
  -- == Tondeuse == --
  -- GEA.add(id["TONDEUSE"], 30, "", {{"Time", "20:00", "07:00"}, {"turnOff"}, {"MaxTime", 1}})
  -- GEA.add(id["TONDEUSE"], 30, "", {{"Inverse"}, {"Time", "07:05", "19:55"}, {"turnOn"}})
  
  -- == Roomba == --
  GEA.add(id["ROMBA"], 30, "", {{"Time", "23:30", "23:32"}, {"turnOff"}})
  GEA.add(id["ROMBA"], 30, "", {{"Inverse"}, {"Time", "06:05", "06:07"}, {"turnOn"}})

  GEA.add({"Sensor-", id["HIFI"], 2}, 10*60, "", {{"turnOff"}}) 
  GEA.add({"Sensor-", id["WI"], 2}, 10*60, "", {{"turnOff"}}) 
  
  -- === KAROTZ === --
  GEA.add(true , 30, "", {{"VirtualDevice", id["OPENKAROTZ"], "21"},{"Time", "07:00", "07:01"}})
  GEA.add(id["TV"], 5*60, "", {{"Slider", id["OPENKAROTZ"], "9", "0"},{"Slider", id["OPENKAROTZ"], "10", "0"},{"Slider", id["OPENKAROTZ"], "11", "0"}, {"Repeat"}})
  GEA.add(id["TV"], 60, "", {{"Inverse"}, {"VirtualDevice", id["OPENKAROTZ"], "14"}})
  GEA.add(true, 30, "", {{"VirtualDevice", id["OPENKAROTZ"], "20"},{"Time", "23:30", "23:31"}})
  GEA.add(id["TV"], 30, "", {{"Scenario", 4},{"Time", "07:55", "08:00"},{"Days","Monday,Tuesday,Thursday,Friday"}})
  GEA.add(id["TV"], 30, "", {{"Scenario", 4},{"Time", "08:40", "08:45"},{"Days","Wednesday"}})

  GEA.add(id["TV"], -1, "", {{"VirtualDevice", id["FREEBOX"], "1"}})
  GEA.add(id["TV"], -1, "", {{"turnOn", id["WI"]}})
  GEA.add(id["TV"], -1, "", {{"Inverse"}, {"turnOff", id["WI"]}})
  
  -- ===  Sèche-serviettes === --
  -- Allumage à 7h les jours de semaines // Switch on the radiator at 7 am on working day
  GEA.add({id["SECHE_SERVIETTE"],estTravail,{"Value-", id["TEMP"], 23}}, 30, "", {{"Inverse"},{"Time", "07:00", "07:02"}, {"turnOn"}})
  -- Allumage à 8h30 les jours de weekend // Switch on the radiator at 8:30am am on sleeping day :)
  GEA.add({id["SECHE_SERVIETTE"], estChome,{"Value-", id["TEMP"], 23}}, 30, "", {{"Inverse"},{"Time", "08:30", "08:32"}, {"turnOn"}})
  -- Eteindre après 2 heures / Switch it off after 2 hours
  GEA.add(id["SECHE_SERVIETTE"], 2*60*60, "", {{"turnOff"}})

  -- ===  Arrosage === --
  -- On rafraichi les prévisions de pluie toutes les heures // Checking wheater every hours
  --  GEA.add(true, 60*60, "", {{"VirtualDevice", id["VD_PLUIE"], "7"}})
  -- On calcul le besoin d'arrosage // Calculation to check if irrogator is needed
  --  GEA.add(true, 30, "", {{"VirtualDevice", id["VD_PLUIE"], "9"},{"Days", "Tuesday, Friday"}, {"Time", "04:55", "04:56"}})
  -- Allumage de l'arrosage automatique // Switch on irrigator
  --  GEA.add({"Global", "Arrosage", "OUI"}, 30, "", {{"turnOn", id["ARROSAGE"]}, {"Days", "Tuesday"}, {"Time","05:00","08:00"}})
  --  GEA.add({"Global", "Arrosage", "PREPARATION"}, 30, "", {{"turnOn", id["ARROSAGE"]}, {"Days", "Tuesday, Friday"}, {"Time","07:30","08:00"}})
  -- On éteint // Switch off irrigator
  --  local longarrosage = {"If", {{"Global", "Arrosage", "OUI"}}}
  --  local courtarrosage = {"If", {{"Global", "Arrosage", "PREPARATION"}}}
  --  GEA.add(id["ARROSAGE"], 2*60*60, "", {{"turnOff"}, longarrosage, {"Global", "Arrosage", "NON"}})
  --  GEA.add(id["ARROSAGE"], 30*60, "", {{"turnOff"}, courtarrosage, {"Global", "Arrosage", "NON"}})

  -- === DIVERS === --
  -- Variable global
  --GEA.add({"Global", "Capsule", "100"}, -1, "Recommander du café") 
  -- Avertir s'il fait froid dans le salon // Cold in the living room ?
  GEA.add({"Value-", id["TEMP"], 18}, 30*60, "Il fait froid au salon #value# à #time#")
  -- Vérification des piles  une fois par jour // Checking batteries once a day
  --  GEA.add({"Batteries", 60}, 24*60*60, "", {{"Repeat"}})

  -- Vérification des modules parfois "dead" // Checking sometimes dead modules
  GEA.add({"Dead", id["POELE"]}, 5*60, "", {{"WakeUp", id["POELE"]}})
  GEA.add({"Dead", id["LEDS_ESCALIER"]}, 5*60, "", {{"WakeUp", id["LEDS_ESCALIER"]}}) -- extérieur
```

## Historique

http://www.domotique-fibaro.fr/index.php/topic/1082-gea-gestionnaire-dévénements-automatique/?p=12428

## Credits

Auteur : Steven P. with modifications of Hansolo and Shyrka973
Version : 5.40

Special Thanks to :
jompa68, Fredric, Diuck, Domodial, moicphil, lolomail, byackee, JossAlf, Did, sebcbien, chris6783 and all other guy from Domotique-fibaro.fr