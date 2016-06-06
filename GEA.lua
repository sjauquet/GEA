--[[
%% autostart
%% properties
%% globals
--]]


-- v 5.42
-- ==================================================
-- GEA : Gestionnaire d'Evénements Automatique
-- ==================================================
-- [FR] Scénario permettant de contrôler si un périphérique est
-- activé depuis trop longtemps ou lancer un push d'avertissement.
-- Ce scénario permet une annotation plus simple que le code LUA
-- il nécessite néanmoins quelques connaissances.
--
-- [EN] This scene allow you to check every X second the status
-- of a module and send actions if the module is activated since too long.
-- This scene allow you a more simple annotation than LUA
-- it requires some knowledge
--
-- Auteur : Steven P. with modifications of Hansolo and Shyrka973
-- Version : 5.42
-- Special Thanks to :
-- jompa68, Fredric, Diuck, Domodial, moicphil, lolomail, byackee,
-- JossAlf, Did,  sebcbien, chris6783, tibahut and all other guy from Domotique-fibaro.fr
-- ------------------------------------------------------------
-- Historique / History
-- ------------------------------------------------------------
-- L'historique complet est diponible ici / the full history is available here :
-- http://www.domotique-fibaro.fr/index.php/topic/1082-gea-gestionnaire-dévénements-automatique/?p=12428



-- Paramétrage de GEA / GEA configuration
function config()
  GEA.isVersionFour           = true -- On est en version 4.017 Beta ou supérieure /
  GEA.language                = "FR" -- Votre langue : FR (default) / Your language : EN
  GEA.checkEvery              = 30 -- On vérifie toutes les X secondes  (default : 30) / Check every X seconds
  GEA.portables               = {179} -- Liste des portables devant recevoir une notification {70, 71} / Smartphones you want to be notified
  GEA.debug                   = false -- Affichage des traces dans la console (default : false) / Show trace in the debug window
  -- GEA.getGlobalForActivation = {"SuspendreGEA", "non"} -- active ou désactive l'exécution de GEA via une variable globale / active or deactive GEA execution with a global variable
  -- GEA.catchError             = false
  GEA.optimize                = GEA.typeOptimize["IMMEDIATE_ONLY"]
  -- option : GEA.typeOptimize["NONE"], GEA.typeOptimize["IMMEDIATE_ONLY"], GEA.typeOptimize["ALL"]
  -- permet d'optimiser les soucis liés au getName et getRoom de fibaro mais n'affiche plus le nom des modules concernés.
end



-- Ajouter ici les événements à exécuter / Add here events to schedule
-- Une liste d'exemples est disponible dans un fichier annexe samples.lua / A samples list is available in another file called samples.lua
function setEvents()



end



-- ==================================================
--
--  NE PLUS RIEN TOUCHER / DON'T TOUCH UNDER THIS POINT
--
-- ==================================================
--
-- SCRIPT GEA PRINCIPAL / GEA MAIN SCRIPT
--
-- ==================================================
if (not GEA) then
  GEA = {}
  GEA.version                = "5.42"
  GEA.language               = "FR";
  GEA.checkEvery             = 30
  GEA.index                  = 0
  GEA.isVersionFour          = true
  GEA.globalTasks            = "GEA_Tasks"
  GEA.regexFullAllow         = false
  GEA.portables              = {}
  GEA.todo                   = {}
  GEA.power                  = "valueSensor"
  GEA.suspended              = ""
  GEA.keys                   = {ID = 1, SECONDES = 2, MESSAGE = 3, ISREPEAT = 4, PARAMS = 5, NAME = 6, NBRUN = 7, DONE = 8, VALUE = 9, GROUPS = 10, OK = 11, TOTALRUNS = 12, INDEX = 13, MAXTIME = 14, ROOM = 15}
  GEA.debug                  = false -- mode de débuggage par défaut
  GEA.catchError             = true -- capture des erreurs par défaut
  GEA.pos                    = 1 -- compteur du nombre d'éléments principaux
  GEA.useTasksGlobal         = true -- utilise ou non une variable globale pour stocker les Restart/Stop Task
  GEA.tasks                  = "" -- variable pour remplacer la variable global si GEA.useTasksGlobal = false
  GEA.typeOptimize           = {NONE = 0, IMMEDIATE_ONLY = 1, ALL = 2}
  GEA.optimize               = GEA.typeOptimize["NONE"]
  GEA.getGlobalForActivation = {}
  GEA.source                 = fibaro:getSourceTrigger()

  GEA.translate = {true, true}
  GEA.translate["FR"] = {
    ACTIONS          = "traitement des actions",
    ACTIVATED        = "activé",
    ACTIVATED_SINCE  = "activé depuis ",
    ADDED_DIRECT     = "ajout de la tâche pour lancement instantané",
    ADDED_FOR        = "ajout de la tâche pour",
    ALWAYS           = "Toujours",
    BATTERIE         = "Pile faible",
    CHECKING         = "vérification",
    CHECKING_DATE    = "vérification des dates",
    CHECKING_TIME    = "vérification plage horaire",
    CHECK_IF         = "vérification de l'exception",
    CHECK_IF_FAILED  = "désactivé par exception",
    CHECK_MAIN       = "vérification de l'activation",
    CHECK_STARTED    = "démarrage vérification",
    CURRENT_TIME     = "L'heure actuelle",
    DATE_NOT_ALLOWED = "n'est pas dans la plage de dates spécifiées",
    DESACTIVATED     = "désactivé",
    DEVICE_NOT_FOUND = "ID non trouvé",
    DONE             = "tâche effectuée et suspendue",
    ERROR            = "!!! ERREUR !!!",
    ERROR_IF         = "IF malformé",
    GEA_SUSPENDED    = "Scénario suspendu par la variable globale ",
    HOUR             = "heure",
    HOURS            = "heures",
    MINUTE           = "minute",
    MINUTES          = "minutes",
    NOTHING_TODO     = "aucun traitement à effectuer",
    NOTHING_TODOID   = "aucun traitement à effectuer pour l'ID :",
    NOT_INCLUDED     = "n'est pas inclus dans",
    REQUIRED         = "attendu",
    RESTART          = "Redémarrage",
    RUN              = "En cours",
    RUNNING          = "en exécution",
    RUN_FOR          = "Durée des traitements : ",
    RUN_NEW          = "nouveau délai : ",
    RUN_SINCE        = "tourne depuis",
    SECOND           = "seconde",
    SECONDS          = "secondes",
    SLEEPING         = "Endormi pendant",
    SUPSENDED        = "Arrêtée",
    SUSPEND_ERROR    = "ERROR GEA.Suspend demande un tableau en paramètre 2",
    TIME_IN          = "vérification contrôlée car dans la plage horaire spécifiée ",
    TIME_NOT_ALLOWED = "n'est pas autorisée",
    TIME_OUT         = "vérification ignorée car en dehors de la plage horaire : ",
    TODAY            = "Aujourd'hui ",
    TODAY_NOT_DST    = "Aujourd'hui n'est pas en mode DST",
    VALUE            = "valeur",
    WILL_SUSPEND     = "entrainera la suspension de"
  }

  GEA.translate["EN"] = {
    ACTIONS          = "doing actions",
    ACTIVATED        = "activated",
    ACTIVATED_SINCE  = "activated since ",
    ADDED_DIRECT     = "task added for instant run",
    ADDED_FOR        = "task added for",
    ALWAYS           = "Always",
    BATTERIE         = "Low batterie",
    CHECKING         = "checking",
    CHECKING_DATE    = "checking dates",
    CHECKING_TIME    = "checking time range",
    CHECK_IF         = "'if' checking",
    CHECK_IF_FAILED  = "'if' stop the check",
    CHECK_MAIN       = "activation checking",
    CHECK_STARTED    = "starting checking",
    CURRENT_TIME     = "Current hour",
    DATE_NOT_ALLOWED = "is not in the specified dates range",
    DESACTIVATED     = "desactivated",
    DEVICE_NOT_FOUND = "Device ID not found",
    DONE             = "task done and suspended",
    ERROR            = "!!! ERROR !!!",
    ERROR_IF         = "IF malformed",
    GEA_SUSPENDED    = "Scene suspended by the global variable ",
    HOUR             = "hour",
    HOURS            = "hours",
    MINUTE           = "minute",
    MINUTES          = "minutes",
    NOTHING_TODO     = "nothing to do",
    NOTHING_TODOID   = "nothing to do for ID:",
    NOT_INCLUDED     = "is not included in",
    REQUIRED         = "excepted",
    RESTART          = "Restart",
    RUN              = "Run",
    RUNNING          = "Running",
    RUN_FOR          = "Duration : ",
    RUN_NEW          = "new delay : ",
    RUN_SINCE        = "running since",
    SECOND           = "second",
    SECONDS          = "seconds",
    SLEEPING         = "Sleeping for",
    SUPSENDED        = "Stopped",
    SUSPEND_ERROR    = "ERROR GEA.Suspend require a table as second parameter",
    TIME_IN          = "checking done time range is ok ",
    TIME_NOT_ALLOWED = "is not allowed",
    TIME_OUT         = "checking abort because out of time range: ",
    TODAY            = "Today ",
    TODAY_NOT_DST    = "Today is not in DST mode",
    VALUE            = "value",
    WILL_SUSPEND     = "will suspend "
  }

  -- ---------------------------------------------------------------------------
  -- Ajoute un périphérique dans la liste des éléments à traiter
  -- ---------------------------------------------------------------------------
  GEA.add = function(id, secondes, message, arg)
    local repeating  = false
    local notStarted = false
    local maxtime    = -1
    local groups     = {}
    local params     = {}
    local name       = {}
    local room       = {}

    if (arg and #arg > 0) then
      for i = 1, #arg do
        lowCapsArg = string.lower(arg[i][1])
        if (lowCapsArg == "repeat") then
          repeating = true
        elseif (lowCapsArg == "maxtime") then
          maxtime = tonumber(arg[i][2])
        elseif (lowCapsArg == "group") then
          groups[tonumber(arg[i][2])] = true
        elseif (lowCapsArg == "notstarted") then
          notStarted = true
        end
      end

      params = arg
    end

    if (maxtime > -1) then repeating = true end

    GEA.index = GEA.index + 1

    if (type(id) == "table") then
      if (type(id[1]) == "number" or type(id[1]) == "table") then
        local conditions = {}
        for i = 2, #id do
          table.insert(conditions, id[i])
          name[i], room[i] = GEA.getName(id[i])
        end

        id = id[1]

        if (type(id) == "table" and type(id[1]) == "string" and string.lower(id[1]) == "alarm") then
          repeating = false
          secondes  = 1
        end

        table.insert(params, {"If", conditions})
      elseif (type(id[1]) == "string") then
        if (string.lower(id[1]) == "global" and #id > 2 and id[2] == "" and id[3] == "") then
          id = true
        elseif (string.lower(id[1]) == "alarm") then
          repeating = false
          secondes  = 1
        end
      end
    end

    name[1], room[1] = GEA.getName(id)

    local entry = {id, secondes, message, repeating, params, name, 0, false, {}, groups, false, 0, GEA.index, maxtime, room}

    if (GEA.source["type"] == "autostart" and tonumber(entry[GEA.keys["SECONDES"]]) >= 0) then
      GEA.insert(entry)
      GEA.log("Add Autostart", entry, GEA.translate[GEA.language]["ADDED_FOR"] .. " " .. secondes .. " " .. GEA.translate[GEA.language]["SECONDS"], true, "grey")

      if (notStarted) then
        local cIndex = GEA.getCode("S", entry[GEA.keys["INDEX"]])

        if (GEA.suspended ~= nil) then
          GEA.suspended = string.gsub(GEA.suspended, cIndex, "")
        end

        GEA.suspended = GEA.suspended .. cIndex
      end
    elseif (GEA.source["type"] == "global" and tonumber(entry[GEA.keys["SECONDES"]]) < 0) then
      if (type(entry[GEA.keys["ID"]]) == "table" and GEA.match(string.lower(entry[GEA.keys["ID"]][1]), "global|global.") and entry[GEA.keys["ID"]][2] == GEA.source["name"]) then
        GEA.insert(entry)
        GEA.log("Add Global", entry, GEA.translate[GEA.language]["ADDED_DIRECT"], true, "grey")
      end
    -- dirty fix fox beta 4.081 GEA.source["type"] == "event"
    elseif ((GEA.source["type"] == "property" or GEA.source["type"] == "event") and tonumber(entry[GEA.keys["SECONDES"]]) < 0) then
      local id = 0

      if (type(entry[GEA.keys["ID"]]) == "number") then
        id = entry[GEA.keys["ID"]]
      elseif (type(entry[GEA.keys["ID"]]) == "table") then
        id = entry[GEA.keys["ID"]][2]

        if (string.lower(entry[GEA.keys["ID"]][1]) == "sceneactivation" and #entry[GEA.keys["ID"]] > 2) then
          if (tonumber(fibaro:getValue(id, "sceneActivation")) ~= tonumber(entry[GEA.keys["ID"]][3])) then
            id = -1
          end
        end
      end
      -- dirty fox for beta 4.081 GEA.source["type"] == "event"
      if ((GEA.source["type"] == "property" and tonumber(id) == tonumber(GEA.source["deviceID"])) or (GEA.source["type"] == "event" and tonumber(id) == tonumber(GEA.source.event.data.id))) then
        GEA.insert(entry)
        GEA.log("Add Property", entry, GEA.translate[GEA.language]["ADDED_DIRECT"], true, "grey")
      end
    end

    return entry[GEA.keys["INDEX"]]
  end

  -- ---------------------------------------------------------------------------
  -- Ajoute une opération dans la liste
  -- ---------------------------------------------------------------------------
  GEA.insert = function(entry)
    GEA.todo[GEA.pos] = entry;
    -- table.insert(GEA.todo, entry)
    -- entry[GEA.keys["INDEX"]] = #GEA.todo
    GEA.pos = GEA.pos + 1

    return entry[GEA.keys["INDEX"]]
  end

  -- ---------------------------------------------------------------------------
  -- Ajoute ou supprime un code dans la variable global GEA_Tasks
  -- ---------------------------------------------------------------------------
  GEA.addOrRemoveTask = function(code, index, add)
    local glob   = nil
    local cIndex = GEA.getCode(code, index)

    if (GEA.useTasksGlobal) then
      glob = fibaro:getGlobalValue(GEA.globalTasks)
    else
      glob = GEA.tasks
    end

    if (glob ~= nil) then
      glob = string.gsub(glob, cIndex, "")
    end

    if (add) then
      if (GEA.useTasksGlobal) then
        fibaro:setGlobal(GEA.globalTasks, glob .. cIndex)
      else
        GEA.tasks = glob .. cIndex
      end
    else
      if (GEA.useTasksGlobal) then
        fibaro:setGlobal(GEA.globalTasks, glob)
      else
        GEA.tasks = glob
      end
    end
  end

  -- ---------------------------------------------------------------------------
  -- Vérifie l'existence d'un code dans la variable global GEA_Tasks
  -- ---------------------------------------------------------------------------
  GEA.isTask = function(code, index)
    local glob   = nil
    local cIndex = GEA.getCode(code, index)

    if (GEA.useTasksGlobal) then
      glob = fibaro:getGlobalValue(GEA.globalTasks)
    else
      glob = GEA.tasks
    end

    if (glob ~= nil) then
      return string.match(glob, cIndex)
    end

    return nil
  end

  -- ---------------------------------------------------------------------------
  -- Concatène un code et un index
  -- ---------------------------------------------------------------------------
  GEA.getCode = function(code, index)
    return "|" .. code .. "_" .. index .. "|"
  end

  -- ---------------------------------------------------------------------------
  -- Obtention d'un nom pour le système
  -- ---------------------------------------------------------------------------
  GEA.getName = function(id)
    if (GEA.optimize == GEA.typeOptimize["ALL"] or (GEA.source["type"] ~= "autostart" and GEA.optimize == GEA.typeOptimize["IMMEDIATE_ONLY"])) then
      return "n/a", "n/a"
    end

    local room = ""

    if (type(id) == "nil" or type(id) == "boolean") then
      return GEA.translate[GEA.language]["ALWAYS"], ""
    elseif (type(id) == "number") then
      return fibaro:getName(tonumber(id)), GEA.getRoom(tonumber(id))
    elseif (type(id) == "table" and GEA.match(string.lower(id[1]), "global|global.")) then
      return id[2], ""
    elseif (type(id) == "table") then
      lowerCaps = string.lower(id[1])

      if (id[2]) then
        idNumeric = tonumber(id[2])
      end

      if (lowerCaps == "batteries") then
        return "Batteries <= " .. id[1], ""
      elseif (lowerCaps == "sceneactivation") then
        return "Scene [" .. id[2] .. "|" .. fibaro:getName(idNumeric) .. "] = " .. id[3], GEA.getRoom(idNumeric)
      elseif (lowerCaps == "sensor") then
        return "Sensor [" .. id[2] .. "|" .. fibaro:getName(idNumeric) .. "] = " .. id[3], GEA.getRoom(idNumeric)
      elseif (lowerCaps == "sensor+") then
        return "Sensor [" .. id[2] .. "|" .. fibaro:getName(idNumeric) .. "] > " .. id[3], GEA.getRoom(idNumeric)
      elseif (lowerCaps == "sensor-") then
        return "Sensor [" .. id[2] .. "|" .. fibaro:getName(idNumeric) .. "] < " .. id[3], GEA.getRoom(idNumeric)
      elseif (lowerCaps == "sensor!") then
        return "Sensor [" .. id[2] .. "|" .. fibaro:getName(idNumeric) .. "] ~= " .. id[3], GEA.getRoom(idNumeric)
      elseif (lowerCaps == "battery") then
        return "[" .. id[2] .. "|" .. fibaro:getName(idNumeric) .. "] <= " .. id[3]  , GEA.getRoom(idNumeric)
      elseif (lowerCaps == "value") then
        return "Value [" .. id[2] .. "|" .. fibaro:getName(idNumeric) .. "] = " .. id[3], GEA.getRoom(idNumeric)
      elseif (lowerCaps == "value+") then
        return "Value [" .. id[2] .. "|" .. fibaro:getName(idNumeric) .. "] > " .. id[3], GEA.getRoom(idNumeric)
      elseif (lowerCaps == "value-") then
        return "Value [" .. id[2] .. "|" .. fibaro:getName(idNumeric) .. "] < " .. id[3], GEA.getRoom(idNumeric)
      elseif (lowerCaps == "value!") then
        return "Value [" .. id[2] .. "|" .. fibaro:getName(idNumeric) .. "] ~= " .. id[3], GEA.getRoom(idNumeric)
      elseif (lowerCaps == "dead") then
        return "Dead [" .. id[2] .. "|" .. fibaro:getName(idNumeric) .. "]", GEA.getRoom(idNumeric)
      elseif (lowerCaps == "slider") then
        return "Slider [" .. id[2] .. "|" .. id[3].. "] = " .. id[4] , GEA.getRoom(idNumeric)
      elseif (lowerCaps == "slider+") then
        return "Slider [" .. id[2] .. "|" .. id[3] .. "] > " .. id[4] , GEA.getRoom(idNumeric)
      elseif (lowerCaps == "slider-") then
        return "Slider [" .. id[2] .. "|" .. id[3] .. "] < " .. id[4] , GEA.getRoom(idNumeric)
      elseif (lowerCaps == "slider!") then
        return "Slider [" .. id[2] .. "|" .. id[3] .. "] ~= " .. id[4], GEA.getRoom(idNumeric)
      elseif (lowerCaps == "label") then
        return "Label [" .. id[2] .. "|" .. id[3] .. "] = " .. id[4], GEA.getRoom(idNumeric)
      elseif (lowerCaps == "label!") then
        return "Label [" .. id[2] .. "|" .. id[3] .. "] ~= " .. id[4], GEA.getRoom(idNumeric)
      elseif (lowerCaps == "function") then
        return "Function", ""
      elseif (lowerCaps == "weather") then
        return "Weather", ""
      elseif (lowerCaps == "alarm") then
        return "Alarm " .. fibaro:getValue(idNumeric, "ui.lblAlarme.value"), ""
      elseif (lowerCaps == "property") then
        return "Property [" .. id[2] .. "|" .. id[3] .. "] = " .. id[4], GEA.getRoom(idNumeric)
      elseif (lowerCaps == "property!") then
        return "Property [" .. id[2] .. "|".. id[3] .. "] ~= " .. id[4], GEA.getRoom(idNumeric)
      elseif (lowerCaps == "group") then
        return "Group [" .. id[2] .. "]", ""
      else
      -- autres à venir
      end
    end
  end

  -- ---------------------------------------------------------------------------
  -- Retourne la pièce contenant le module
  -- ---------------------------------------------------------------------------
  GEA.getRoom = function(id)
    local roomId = fibaro:getRoomID(id)

    if (type(roomId) == "number") then
      local roomName = fibaro:getRoomName(roomId)

      if (type(roomName) == "string") then
        return roomName
      end
    end

    return ""
  end

  -- ---------------------------------------------------------------------------
  -- Vérifie si le jour en cours est dans la liste
  -- ---------------------------------------------------------------------------
  GEA.checkDay = function(days)
    local dayFound = false

    jours = days
    jours = string.gsub(jours, "All", "Weekday,Weekend")
    jours = string.gsub(jours, "Weekday", "Monday,Tuesday,Wednesday,Thursday,Friday")
    jours = string.gsub(jours, "Weekend", "Saturday,Sunday")

    if (string.find(string.lower(jours), string.lower(os.date("%A")))) then
      dayFound = true
    end

    return dayFound
  end

  -- ---------------------------------------------------------------------------
  -- Vérification des plages de date
  -- ---------------------------------------------------------------------------
  GEA.checkTimes = function(entry)
    GEA.log("Check", entry, GEA.translate[GEA.language]["CHECKING_DATE"], false)

    if (not entry[GEA.keys["PARAMS"]]) then
      return true
    end

    local notFound  = true
    local dayFound  = true
    local dateFound = true
    local dst       = true
    local jours     = ""

    if (type(entry[GEA.keys["PARAMS"]]) == "table") then
      for i = 1, #entry[GEA.keys["PARAMS"]] do
        local iterator = entry[GEA.keys["PARAMS"]][i]

        if (type(iterator) == "table") then
          if (string.lower(iterator[1]) == "days") then
            dayFound = GEA.checkDay(iterator[2])
          elseif (string.lower(iterator[1]) == "dst") then
            dst = os.date("*t", os.time()).isdst
          elseif (string.lower(iterator[1]) == "notdst") then
            dst = not os.date("*t", os.time()).isdst
          elseif (string.lower(iterator[1]) == "dates") then
            dateFound = false
            local now = os.date("%Y%m%d")
            -- todo check
            local from = iterator[2]

            if (string.len(from) == 5) then
              from = from .. "/" .. os.date("%Y")
            end

            from     = string.format ("%04d", GEA.split(from, "/")[3]) .. string.format("%02d", GEA.split(from, "/")[2]) .. string.format("%02d", GEA.split(from, "/")[1])
            local to = iterator[3]

            if (string.len(to) == 5) then
              to = to .. "/" .. os.date("%Y")
            end

            to        = string.format ("%04d", GEA.split(to, "/")[3]) .. string.format("%02d", GEA.split(to, "/")[2]) .. string.format("%02d", GEA.split(to, "/")[1])
            dateFound = tonumber(now) >= tonumber(from) and tonumber(now) <= tonumber(to)
          end
        end
      end
    end

    if (dayFound and dst) then
      local found = false

      for i = 1, #entry[GEA.keys["PARAMS"]] do
        local iterator = entry[GEA.keys["PARAMS"]][i]

        if (type(iterator) == "table" and string.lower(iterator[1]) == "dates") then
          if (not found) then
            dateFound = false
          end

          local now = os.date("%Y%m%d")
          -- todo check
          local from = iterator[2]

          if (string.len(from) == 5) then
            from = from .. "/" .. os.date("%Y")
          end

          from = string.format("%04d", GEA.split(from, "/")[3]) .. string.format("%02d", GEA.split(from, "/")[2]) .. string.format("%02d", GEA.split(from, "/")[1])
          local to = iterator[3]

          if (string.len(to) == 5) then
            to = to .. "/".. os.date("%Y")
          end

          to = string.format("%04d", GEA.split(to, "/")[3]) .. string.format("%02d", GEA.split(to, "/")[2]) .. string.format("%02d", GEA.split(to, "/")[1])

          if (tonumber(from) > tonumber(to) and tonumber(from) > tonumber(now)) then
            from = tonumber(from) - 10000
          end

          if (tonumber(now) >= tonumber(from) and tonumber(now) <= tonumber(to)) then
            dateFound = true
            found     = true
          end
        end
      end
    end

    if (dayFound and dst and dateFound) then
      for i = 1, #entry[GEA.keys["PARAMS"]] do
        local iterator = entry[GEA.keys["PARAMS"]][i]

        if (type(iterator) == "table" and string.lower(iterator[1]) == "time") then
          notFound = false

          if (GEA.checkTime(entry, GEA.flatTime(iterator[2]) .. "-" .. GEA.flatTime(iterator[3]))) then
            return true
          end
        end
      end
    else
      if (not dayFound) then
        GEA.log("!CANCEL! CheckTimes", entry, GEA.translate[GEA.language]["TODAY"] .. " " .. os.date("%A") .. " " .. GEA.translate[GEA.language]["NOT_INCLUDED"] .. " " .. jours, false, "yellow")
      elseif (not dst) then
        GEA.log("!CANCEL! CheckTimes", entry, GEA.translate[GEA.language]["TODAY_NOT_DST"], false, "yellow")
      elseif (not dateFound) then
        GEA.log("!CANCEL! CheckTimes", entry, GEA.translate[GEA.language]["TODAY"] .. " " .. os.date("%x") .. " " .. GEA.translate[GEA.language]["DATE_NOT_ALLOWED"], false, "yellow")
      end
    end

    if (not notFound) then
      GEA.log("!CANCEL! CheckTimes", entry, GEA.translate[GEA.language]["CURRENT_TIME"] .. " " .. os.date("%H:%M") .. " " .. GEA.translate[GEA.language]["TIME_NOT_ALLOWED"], false, "yellow")
    end

    return notFound and dateFound and dayFound and dst
  end

  -- ---------------------------------------------------------------------------
  -- Contrôle des heures
  -- ---------------------------------------------------------------------------
  GEA.flatTime = function(time)
    local t = string.lower(time)

    t = string.gsub(t, " ", "")
    t = string.gsub(t, "h", ":")
    t = string.gsub(t, "sunset", fibaro:getValue(1, "sunsetHour"))
    t = string.gsub(t, "sunrise", fibaro:getValue(1, "sunriseHour"))

    if (string.find(t, "<")) then
      t = GEA.flatTime(GEA.split(t, "<")[1]) .. "<" .. GEA.flatTime(GEA.split(t, "<")[2])
    end

    if (string.find(t, ">")) then
      t = GEA.flatTime(GEA.split(t, ">")[1]) .. ">" .. GEA.flatTime(GEA.split(t, ">")[2])
    end

    if (string.find(t, "+")) then
      local time    = GEA.split(t, "+")[1]
      local add     = GEA.split(t, "+")[2]
      local td      = os.date("*t")
      local minutes = GEA.split(time, ":")[2]
      local sun     = os.time{year = td.year, month = td.month, day = td.day, hour = tonumber(GEA.split(time, ":")[1]), min = tonumber(GEA.split(time, ":")[2]), sec = 0}

      sun = sun + (add *60)
      t   = os.date("*t", sun)
      t   = string.format("%02d", t.hour) .. ":" .. string.format("%02d", t.min)

    elseif (string.find(t, "-")) then
      local time = GEA.split(t, "-")[1]
      local add  = GEA.split(t, "-")[2]
      local td   = os.date("*t")
      local sun  = os.time{year = td.year, month = td.month, day = td.day, hour = tonumber(GEA.split(time, ":")[1]), min = tonumber(GEA.split(time, ":")[2]), sec = 0}

      sun = sun - (add *60)
      t   = os.date("*t", sun)
      t   = string.format("%02d", t.hour) .. ":" .. string.format("%02d", t.min)

    elseif (string.find(t, "<")) then
      local s1 = GEA.split(t, "<")[1]
      local s2 = GEA.split(t, "<")[2]

      s1 = string.format("%02d", GEA.split(s1, ":")[1]) .. ":" .. string.format("%02d", GEA.split(s1, ":")[2])
      s2 = string.format("%02d", GEA.split(s2, ":")[1]) .. ":" .. string.format("%02d", GEA.split(s2, ":")[2])

      if (s1 < s2) then
        t = s1
      else
        t = s2
      end

    elseif (string.find(t, ">")) then
      local s1 = GEA.split(t, ">")[1]
      local s2 = GEA.split(t, ">")[2]

      s1 = string.format("%02d", GEA.split(s1, ":")[1]) .. ":" .. string.format("%02d", GEA.split(s1, ":")[2])
      s2 = string.format("%02d", GEA.split(s2, ":")[1]) .. ":" .. string.format("%02d",GEA. split(s2, ":")[2])

      if (s1 > s2) then
        t = s1
      else
        t = s2
      end

    else
      t = string.format("%02d", GEA.split(t, ":")[1]) .. ":" .. string.format("%02d", GEA.split(t, ":")[2])
    end

    return t
  end

  -- ---------------------------------------------------------------------------
  -- Vérification d'une plage de date
  -- ---------------------------------------------------------------------------
  GEA.checkTime = function(entry, times)
    GEA.log("CheckTime", entry, GEA.translate[GEA.language]["CHECKING_TIME"] .. " " .. times, false)

    if (not times or times == "") then
      return true
    end

    local from    = string.sub(times, 1, 5)
    local to      = string.sub(times, 7, 11)
    local now     = os.date("%H:%M")
    local inplage = false

    if (to < from) then
      inplage = (now >= from) or (now <= to)
    else
      inplage = (now >= from) and (now <= to)
    end

    if (not inplage) then
      GEA.log("CheckTime", entry, GEA.translate[GEA.language]["TIME_OUT"] .. times, false, "yellow")
    else
      GEA.log("CheckTime", entry, GEA.translate[GEA.language]["TIME_IN"] .. times, false)
    end

    return inplage
  end

  -- ---------------------------------------------------------------------------
  -- Split une chaîne selon un délimiteur
  -- ---------------------------------------------------------------------------
  GEA.split = function(text, sep)
    local sep, fields = sep or ":", {}
    local pattern     = string.format("([^%s]+)", sep)

    text:gsub(pattern, function(c) fields[#fields+1] = c end)

    return fields
  end

  -- ---------------------------------------------------------------------------
  -- Supprime les espaces avant et après
  -- ---------------------------------------------------------------------------
  GEA.trim = function(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
  end

  -- ---------------------------------------------------------------------------
  -- Utilisation des regex
  -- ---------------------------------------------------------------------------
  GEA.match = function(s, p)
    if (type(s) == "nil") then
       return type(p) == "nil"
    end

    s = tostring(s)
    p = tostring(p):gsub("%%", "%%%%"):gsub("-", "%%-")

    local words = GEA.split(p, "|")

    for i = 1, #words do
      if (not GEA.regexFullAllow) then
        words[i] = "^"..words[i].."$"
      end

      if (string.match(s, GEA.trim(words[i]))) then
        return true
      end
    end

    return false
  end

  -- ---------------------------------------------------------------------------
  -- On vérifie pour un pérphérique
  -- ---------------------------------------------------------------------------
  GEA.check = function(entry, index)
    GEA.log("Check", entry, GEA.translate[GEA.language]["CHECK_STARTED"], false)

    if (GEA.isTask("R", entry[GEA.keys["INDEX"]]) ~= nil) then
      GEA.log("Check", entry, GEA.translate[GEA.language]["RESTART"], true)
      entry[GEA.keys["NBRUN"]]     = 0
      entry[GEA.keys["TOTALRUNS"]] = 0
      entry[GEA.keys["DONE"]]      = false
      entry[GEA.keys["OK"]]        = false
      GEA.addOrRemoveTask("R", entry[GEA.keys["INDEX"]], false)
      GEA.addOrRemoveTask("S", entry[GEA.keys["INDEX"]], false)
    end

    if (GEA.isTask("S", entry[GEA.keys["INDEX"]]) ~= nil) then
      GEA.log("Check", entry, GEA.translate[GEA.language]["SUPSENDED"], true)
      return
    end

    if (not entry[GEA.keys["DONE"]]) then
      entry[GEA.keys["OK"]] = false
    end

    if (GEA.checkTimes(entry)) then
      if (GEA.isActivated(entry, 1, entry)) then
        -- le périphérique est actif, on incrémente le compteur
        if (entry[GEA.keys["SECONDES"]] < 0) then
          local maxglob =  GEA.isTask("M", entry[GEA.keys["INDEX"]] .. "{(%d+)}")

          if (maxglob ~= nil) then
            entry[GEA.keys["TOTALRUNS"]] = tonumber(maxglob)
            GEA.addOrRemoveTask("M", entry[GEA.keys["INDEX"]] .. "{(%d+)}", false)
          end
        end

        if (entry[GEA.keys["NBRUN"]]) then
          entry[GEA.keys["NBRUN"]]     = entry[GEA.keys["NBRUN"]] + 1
          entry[GEA.keys["TOTALRUNS"]] = entry[GEA.keys["TOTALRUNS"]] + 1
        else
          entry[GEA.keys["NBRUN"]]     = 0
          entry[GEA.keys["TOTALRUNS"]] = 0
        end

        if (not entry[GEA.keys["DONE"]]) then
          GEA.log("Check", entry, GEA.translate[GEA.language]["ACTIVATED_SINCE"] .. (entry[GEA.keys["TOTALRUNS"]] * GEA.checkEvery)  .. "/" .. entry[GEA.keys["SECONDES"]], false)
        end

        if (entry[GEA.keys["SECONDES"]] < 0 and (entry[GEA.keys["MAXTIME"]] == -1 or (entry[GEA.keys["TOTALRUNS"]]-1) < entry[GEA.keys["MAXTIME"]])) then
          GEA.sendActions(entry)
        end

        if (entry[GEA.keys["SECONDES"]] < 0 and entry[GEA.keys["MAXTIME"]] > -1) then
          GEA.addOrRemoveTask("M", entry[GEA.keys["INDEX"]] .. "{(%d+)}", false)

          if (entry[GEA.keys["TOTALRUNS"]] >= entry[GEA.keys["MAXTIME"]] ) then
            GEA.addOrRemoveTask("S", entry[GEA.keys["INDEX"]], true)
          else
            GEA.addOrRemoveTask("M", entry[GEA.keys["INDEX"]] .. "{" .. entry[GEA.keys["TOTALRUNS"]] .. "}", true)
          end
        end
      else
        -- le périphérique est inactif on remet le compteur à 0
        entry[GEA.keys["NBRUN"]]     = 0
        entry[GEA.keys["TOTALRUNS"]] = 0
        entry[GEA.keys["DONE"]]      = false
        entry[GEA.keys["OK"]]        = false
      end

      if (GEA.source["type"] == "autostart" and ((entry[GEA.keys["NBRUN"]] * GEA.checkEvery) >= entry[GEA.keys["SECONDES"]]) and not entry[GEA.keys["DONE"]] and (entry[GEA.keys["MAXTIME"]] == -1 or (entry[GEA.keys["TOTALRUNS"]]-1) < entry[GEA.keys["MAXTIME"]])) then
        -- Envoi du messsage au destinataires
        GEA.sendActions(entry)
        entry[GEA.keys["OK"]] = true

        if (entry[GEA.keys["ISREPEAT"]] and entry[GEA.keys["MAXTIME"]] == -1) then
           --- nothing
        elseif (entry[GEA.keys["MAXTIME"]] == -1 or (entry[GEA.keys["TOTALRUNS"]] >= entry[GEA.keys["MAXTIME"]])) then
          GEA.log("Done", entry, GEA.translate[GEA.language]["DONE"], true, "DarkSlateBlue")
          entry[GEA.keys["DONE"]] = true
        end

        entry[GEA.keys["NBRUN"]] = 0
      end
    else
      entry[GEA.keys["NBRUN"]]     = 0
      entry[GEA.keys["TOTALRUNS"]] = 0
      entry[GEA.keys["DONE"]]      = false
      entry[GEA.keys["OK"]]        = false
    end
  end

  -- ---------------------------------------------------------------------------
  -- Vérification spécifique pour savoir si un périphérique est activé
  -- ou non
  -- ---------------------------------------------------------------------------
  GEA.isActivated = function(entry, nb, master)
    if (nb == 1) then
      GEA.log("isActivated", entry, GEA.translate[GEA.language]["CHECK_MAIN"], false)
    else
      GEA.log("isActivated", entry, GEA.translate[GEA.language]["CHECK_IF"], false)
    end

    local mainid = -1
    local id     = entry[GEA.keys["ID"]]
    local result = true
    local typeID = type(id)

    if (typeID == "nil") then
      result                        = true
      master[GEA.keys["VALUE"]][nb] = "true"

    elseif (typeID == "boolean") then
      result = id

      if (result) then
        master[GEA.keys["VALUE"]][nb] = "true"
      else
        master[GEA.keys["VALUE"]][nb] = "false"
      end

    elseif (typeID == "number") then
      local type = fibaro:getType(tonumber(id))
      GEA.log("isActivated", entry, "type : " .. type, false)

      if (GEA.match(type, "door_sensor|water_sensor|motion_sensor|com.fibaro.FGMS001|com.fibaro.doorSensor|com.fibaro.waterSensor|com.fibaro.motionSensor")) then
        result = tonumber(fibaro:getValue(tonumber(id), "value")) >= 1

        if not result and (GEA.source["type"] == "autostart") and (fibaro:getValue(tonumber(id), "lastBreached")) ~= "" then
          result = ((os.time() - tonumber(fibaro:getValue(tonumber(id), "lastBreached"))) < GEA.checkEvery)
        elseif not result and (GEA.source["type"] == "autostart") and (fibaro:getModificationTime(tonumber(id), "value")) then
          result  = ((os.time() - tonumber(fibaro:getModificationTime(tonumber(id), "value"))) < GEA.checkEvery)
        end

      elseif (GEA.match(type, "dimmable_light|binary_light|rgb_driver|com.fibaro.FGRGBW441M|com.fibaro.multilevelSwitch|com.fibaro.binarySwitch")) then
        if (GEA.match(type, "rgb_driver")) then
          -- verison 3.x
          result = (tonumber(fibaro:getValue(tonumber(id), "value")) > 0 ) or tonumber(fibaro:getValue(tonumber(id), "currentProgramID")) > 0
        elseif (GEA.match(type, "com.fibaro.FGRGBW441M")) then
          -- verison 4.x
          result = (tonumber(fibaro:getValue(tonumber(id), "value")) > 0 and not fibaro:getValue(tonumber(id), "color") == "0,0,0,0") or tonumber(fibaro:getValue(tonumber(id), "currentProgramID")) > 0
        else
          result = tonumber(fibaro:getValue(tonumber(id), "value")) > 0
        end

        if not result and (GEA.source["type"] == "autostart") and (fibaro:getModificationTime(tonumber(id), "value") ) then
          result  = ((os.time() - tonumber(fibaro:getModificationTime(tonumber(id), "value"))) < GEA.checkEvery)
        end

      elseif (type == "blind") then
        result = tonumber(fibaro:getValue(tonumber(id), "value")) > 0
      else
        result = tonumber(fibaro:getValue(tonumber(id), "value")) == 1
      end

      mainid                        = tonumber(id)
      master[GEA.keys["VALUE"]][nb] = fibaro:getValue(tonumber(id), "value")

    elseif (typeID == "table") then
      local lowerValue = string.lower(id[1])

      if(lowerValue == "global" and #id > 2) then
        GEA.log("isActivated", entry, "type : global variable", false)
        result = GEA.match(fibaro:getGlobalValue(id[2]), id[3])
        master[GEA.keys["VALUE"]][nb] = fibaro:getGlobalValue(id[2])

      elseif (lowerValue == "global+" and #id > 2) then
        GEA.log("isActivated", entry, "type : Global+", false)
        result = tonumber(fibaro:getGlobalValue(id[2])) > tonumber(id[3])
        --mainid = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getGlobalValue(id[2])

      elseif (lowerValue == "global-" and #id > 2) then
        GEA.log("isActivated", entry, "type : Global-", false)
        result = tonumber(fibaro:getGlobalValue(id[2])) < tonumber(id[3])
        --mainid = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getGlobalValue(id[2])

      elseif (lowerValue == "global!" and #id > 2) then
        GEA.log("isActivated", entry, "type : Global!", false)
        result = not GEA.match(fibaro:getGlobalValue(id[2]), id[3])
        --mainid = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getGlobalValue(id[2])

      elseif (lowerValue == "slider" and #id > 3) then
        GEA.log("isActivated", entry, "type : Slider", false)
        result = tonumber(fibaro:getValue(id[2], "ui." .. id[3] .. ".value")) == tonumber(id[4])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(id[2], "ui." .. id[3] .. ".value")

      elseif (lowerValue == "slider-" and #id > 3) then
        GEA.log("isActivated", entry, "type : Slider-", false)
        result = tonumber(fibaro:getValue(id[2], "ui." .. id[3] .. ".value")) < tonumber(id[4])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(id[2], "ui." .. id[3] .. ".value")

      elseif (lowerValue == "slider!" and #id > 3) then
        GEA.log("isActivated", entry, "type : Slider!", false)
        result = tonumber(fibaro:getValue(id[2], "ui." .. id[3] .. ".value")) ~= tonumber(id[4])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(id[2], "ui." .. id[3] .. ".value")

      elseif (lowerValue == "slider+" and #id > 3) then
        GEA.log("isActivated", entry, "type : Slider+", false)
        result = tonumber(fibaro:getValue(id[2], "ui." .. id[3] .. ".value")) > tonumber(id[4])
        --mainid = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(id[2], "ui." .. id[3] .. ".value")

      elseif (lowerValue == "label" and #id > 3) then
        GEA.log("isActivated", entry, "type : Label", false)
        result = GEA.match(fibaro:getValue(id[2], "ui." .. id[3] .. ".value"), id[4])
        --mainid = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(id[2], "ui." .. id[3] .. ".value")

      elseif (lowerValue == "label!" and #id > 3) then
        GEA.log("isActivated", entry, "type : Label!", false)
        result = not GEA.match(fibaro:getValue(id[2], "ui." .. id[3] .. ".value"), id[4])
        --mainid = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(id[2], "ui." .. id[3] .. ".value")

      elseif (lowerValue == "property" and #id > 3) then
        GEA.log("isActivated", entry, "type : Property", false)
        result = GEA.match(fibaro:getValue(id[2], id[3]), id[4])
        --mainid = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(id[2], id[3])

      elseif (lowerValue == "property!" and #id > 3) then
        GEA.log("isActivated", entry, "type : Property", false)
        result = not GEA.match(fibaro:getValue(id[2], id[3]), id[4])
        --mainid = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(id[2], id[3])

      elseif (lowerValue == "batteries" and #id > 1) then
        GEA.log("isActivated", entry, "type : batteries", false)
        local msg = ""

        for i = 1, 1000 do
          local batt = fibaro:getValue(i, 'batteryLevel')

          if (type(batt) ~= nil and (tonumber(batt) ~= nil) and (tonumber(batt) <= tonumber(id[2])) or (tonumber(batt) == 255)) then
            GEA.log("isActivated", entry, "checking : batteries " .. fibaro:getName(i), false)

            if (not string.find(fibaro:getName(i), "Zwave_")) then
              msg    = msg .. GEA.translate[GEA.language]["BATTERIE"] .. " [" .. fibaro:getName(i) .. "] " .. batt .. "%\n"
              result = true
            end
          end
        end

        master[GEA.keys["VALUE"]][nb] = id[2]
        entry[GEA.keys["MESSAGE"]]    = msg

      elseif ((lowerValue == "sensor" or lowerValue == "power") and #id > 2) then
        GEA.log("isActivated", entry, "type : Sensor", false)
        result                        = tonumber(fibaro:getValue(tonumber(id[2]), GEA.power)) == tonumber(id[3])
        mainid                        = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(tonumber(id[2]), GEA.power)

      elseif ((lowerValue == "sensor+" or lowerValue == "power+") and #id > 2) then
        GEA.log("isActivated", entry, "type : Sensor+", false)
        result                        = tonumber(fibaro:getValue(tonumber(id[2]), GEA.power)) > tonumber(id[3])
        mainid                        = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(tonumber(id[2]), GEA.power)

      elseif ((lowerValue == "sensor-" or lowerValue == "power-") and #id > 2) then
        GEA.log("isActivated", entry, "type : Sensor-", false)
        result                        = tonumber(fibaro:getValue(tonumber(id[2]), GEA.power)) < tonumber(id[3])
        mainid                        = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(tonumber(id[2]), GEA.power)

      elseif ((lowerValue == "sensor!" or lowerValue == "power!") and #id > 2) then
        GEA.log("isActivated", entry, "type : Sensor!", false)
        result                        = tonumber(fibaro:getValue(tonumber(id[2]), GEA.power)) ~= tonumber(id[3])
        mainid                        = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(tonumber(id[2]), GEA.power)

      elseif (lowerValue == "battery" and #id > 2) then
        GEA.log("isActivated", entry, "type : Battery", false)
        result     = false
        local batt = fibaro:getValue(tonumber(id[2]), 'batteryLevel')

        if (type(batt) ~= nil and tonumber(batt) <= tonumber(id[3]) or tonumber(batt) == 255) then
          result = true
          master[GEA.keys["VALUE"]][nb] = batt
        end

        mainid = tonumber(id[2])

      elseif (lowerValue == "value" and #id > 2) then
        GEA.log("isActivated", entry, "type : Value", false)
        result                        = tonumber(fibaro:getValue(tonumber(id[2]), "value")) == tonumber(id[3])
        mainid                        = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(tonumber(id[2]), "value")

      elseif (lowerValue == "value+" and #id > 2) then
        GEA.log("isActivated", entry, "type : Value+", false)
        result                        = tonumber(fibaro:getValue(tonumber(id[2]), "value")) > tonumber(id[3])
        mainid                        = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(tonumber(id[2]), "value")

      elseif (lowerValue == "value-" and #id > 2) then
        GEA.log("isActivated", entry, "type : Value-", false)
        result                        = tonumber(fibaro:getValue(tonumber(id[2]), "value")) < tonumber(id[3])
        mainid                        = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(tonumber(id[2]), "value")

      elseif (lowerValue == "value!" and #id > 2) then
        GEA.log("isActivated", entry, "type : Value!", false)
        result                        = tonumber(fibaro:getValue(tonumber(id[2]), "value")) ~= tonumber(id[3])
        mainid                        = tonumber(id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(tonumber(id[2]), "value")

      elseif (lowerValue == "dead" and #id > 1) then
        GEA.log("isActivated", entry, "type : isDead", false)
        result                        = tonumber(fibaro:getValue(tonumber(id[2]), "dead")) >= 1
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(tonumber(id[2]), "dead")

      elseif (lowerValue == "weather" and #id > 1) then
        GEA.log("isActivated", entry, "type : weather", false)
        result = GEA.match(fibaro:getValue(3, "WeatherConditionConverted"), id[2])
        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(3, "WeatherConditionConverted")

      elseif (lowerValue == "function" and #id > 1) then
        GEA.log("isActivated", entry, "type : Function", false)
        local status, err, value = pcall(id[2])

        if (status) then
          result = err

          if (value) then
            master[GEA.keys["VALUE"]][nb] = value
          end
        else
          result = false
        end

      elseif (lowerValue == "group" and #id > 1) then
        GEA.log("isActivated", entry, "type : Group", false)

        for i = 1, #GEA.todo do
          if (GEA.todo[i][GEA.keys["GROUPS"]][tonumber(id[2])]) then
            if (not GEA.todo[i][GEA.keys["OK"]]) then
              result = false
            end
          end
        end

        master[GEA.keys["VALUE"]][nb] = fibaro:getValue(tonumber(id[2]), "")

      elseif (lowerValue == "alarm") then
        GEA.log("isActivated", entry, "type : alarm", false)
        local time = fibaro:getValue(tonumber(id[2]), "ui.lblAlarme.value")

        if (not (type(time) == "nil" or time == "" or time == "--:--")) then
          result = GEA.checkTime(entry, GEA.flatTime(time) .. "-" .. GEA.flatTime(time))

          if (result) then
            local jours = fibaro:getValue(tonumber(id[2]), "ui.lblJours.value")
            local days  = ""

            if (string.find(jours, "Lu") or string.find(jours, "Mo")) then days = days .. "Monday" end
            if (string.find(jours, "Ma") or string.find(jours, "Tu")) then days = days .. "Tuesday" end
            if (string.find(jours, "Me") or string.find(jours, "We")) then days = days .. "Wednesday" end
            if (string.find(jours, "Je") or string.find(jours, "Th")) then days = days .. "Thursday" end
            if (string.find(jours, "Ve") or string.find(jours, "Fr")) then days = days .. "Friday" end
            if (string.find(jours, "Sa") or string.find(jours, "Sa")) then days = days .. "Saturday" end
            if (string.find(jours, "Di") or string.find(jours, "Su")) then days = days .. "Sunday" end
            result = GEA.checkDay(days)
          end

          master[GEA.keys["VALUE"]][nb] = time
        else
          result = false
        end
      end
    else
      -- autre à venir
    end

    if (nb == 1) then
      for i = 1, #entry[GEA.keys["PARAMS"]] do
        if (string.lower(entry[GEA.keys["PARAMS"]][i][1]) == "inverse") then
          result = not result
        end
      end

      if (mainid > -1 and type(entry[GEA.keys["PARAMS"]]) == "table") then
        for i = 1, #entry[GEA.keys["PARAMS"]] do
          local iterator = entry[GEA.keys["PARAMS"]][i]

          if (string.lower(iterator[1]) == "armed") then
            result = result and tonumber(fibaro:getValue(mainid, "armed")) > 0

            if (#iterator > 1) then
              result = result and tonumber(fibaro:getValue(iterator[2], "armed")) > 0
            end

          elseif (string.lower(iterator[1]) == "disarmed") then
            result = result and tonumber(fibaro:getValue(mainid, "armed")) == 0

            if (#iterator > 1) then
              result = result and tonumber(fibaro:getValue(iterator[2], "armed")) == 0
            end
          end
        end
      end

      if (result) then
        for i = 1, #entry[GEA.keys["PARAMS"]] do
          local iterator = entry[GEA.keys["PARAMS"]][i]

          if (type(iterator) == "table" and string.lower(iterator[1]) == "if") then
            local ok = true

            for j = 1, #iterator[2] do
              if (type(iterator[2]) == "table") then
                if ( not GEA.isActivated({iterator[2][j]}, j+1, entry) ) then
                  ok = false
                  GEA.log("!CANCEL! isActivated", entry, GEA.translate[GEA.language]["CHECK_IF_FAILED"], false, "yellow")
                end
              else
                GEA.log(GEA.translate[GEA.language]["ERROR"], entry, GEA.translate[GEA.language]["ERROR_IF"], true, "red")
              end
            end

            result = ok
          end
        end
      end
    end

    if (result) then
      GEA.log("isActivated", entry, GEA.translate[GEA.language]["ACTIVATED"], false)
    else
      GEA.log("!CANCEL! isActivated", entry, GEA.translate[GEA.language]["DESACTIVATED"], false, "yellow")
    end
    return result
  end

  -- ---------------------------------------------------------------------------
  -- Permet de définir / spécifier un message précis qui sera envoyé
  -- par la méthode sendWarning
  -- ---------------------------------------------------------------------------
  GEA.getMessage = function(entry, message)
    local msg = ""

    if (entry[GEA.keys["MESSAGE"]]) then
      msg = entry[GEA.keys["MESSAGE"]]
    end

    if (message and message ~= "") then
      msg = message
    end

    if (entry[GEA.keys["VALUE"]][1]) then
      msg = string.gsub(msg, "#value#", entry[GEA.keys["VALUE"]][1])
      msg = string.gsub(msg, "#value%[1%]#", entry[GEA.keys["VALUE"]][1])
    end

    if (entry[GEA.keys["VALUE"]][2]) then msg = string.gsub(msg, "#value%[2%]#", entry[GEA.keys["VALUE"]][2]) end
    if (entry[GEA.keys["VALUE"]][3]) then msg = string.gsub(msg, "#value%[3%]#", entry[GEA.keys["VALUE"]][3]) end
    if (entry[GEA.keys["VALUE"]][4]) then msg = string.gsub(msg, "#value%[4%]#", entry[GEA.keys["VALUE"]][4]) end
    if (entry[GEA.keys["VALUE"]][5]) then msg = string.gsub(msg, "#value%[5%]#", entry[GEA.keys["VALUE"]][5]) end
    if (entry[GEA.keys["VALUE"]][6]) then msg = string.gsub(msg, "#value%[6%]#", entry[GEA.keys["VALUE"]][6]) end
    if (entry[GEA.keys["VALUE"]][7]) then msg = string.gsub(msg, "#value%[7%]#", entry[GEA.keys["VALUE"]][7]) end
    if (entry[GEA.keys["VALUE"]][8]) then msg = string.gsub(msg, "#value%[8%]#", entry[GEA.keys["VALUE"]][8]) end
    if (entry[GEA.keys["VALUE"]][9]) then msg = string.gsub(msg, "#value%[9%]#", entry[GEA.keys["VALUE"]][9]) end

    msg = string.gsub(msg, "#time#", os.date("%X"))
    msg = string.gsub(msg, "#date#", os.date("%x"))

    if (entry[GEA.keys["NAME"]][1]) then
      msg = string.gsub(msg, "#name#", entry[GEA.keys["NAME"]][1])
      msg = string.gsub(msg, "#name%[1%]#", entry[GEA.keys["NAME"]][1])
    end

    if (entry[GEA.keys["NAME"]][2]) then msg = string.gsub(msg, "#name%[2%]#", entry[GEA.keys["NAME"]][2]) end
    if (entry[GEA.keys["NAME"]][3]) then msg = string.gsub(msg, "#name%[3%]#", entry[GEA.keys["NAME"]][3]) end
    if (entry[GEA.keys["NAME"]][4]) then msg = string.gsub(msg, "#name%[4%]#", entry[GEA.keys["NAME"]][4]) end
    if (entry[GEA.keys["NAME"]][5]) then msg = string.gsub(msg, "#name%[5%]#", entry[GEA.keys["NAME"]][5]) end
    if (entry[GEA.keys["NAME"]][6]) then msg = string.gsub(msg, "#name%[6%]#", entry[GEA.keys["NAME"]][6]) end
    if (entry[GEA.keys["NAME"]][7]) then msg = string.gsub(msg, "#name%[7%]#", entry[GEA.keys["NAME"]][7]) end
    if (entry[GEA.keys["NAME"]][8]) then msg = string.gsub(msg, "#name%[8%]#", entry[GEA.keys["NAME"]][8]) end
    if (entry[GEA.keys["NAME"]][9]) then msg = string.gsub(msg, "#name%[9%]#", entry[GEA.keys["NAME"]][9]) end

    if (entry[GEA.keys["ROOM"]][1]) then
      msg = string.gsub(msg, "#room#", entry[GEA.keys["ROOM"]][1])
      msg = string.gsub(msg, "#room%[1%]#", entry[GEA.keys["ROOM"]][1])
    end

    if (entry[GEA.keys["ROOM"]][2]) then msg = string.gsub(msg, "#room%[2%]#", entry[GEA.keys["ROOM"]][2]) end
    if (entry[GEA.keys["ROOM"]][3]) then msg = string.gsub(msg, "#room%[3%]#", entry[GEA.keys["ROOM"]][3]) end
    if (entry[GEA.keys["ROOM"]][4]) then msg = string.gsub(msg, "#room%[4%]#", entry[GEA.keys["ROOM"]][4]) end
    if (entry[GEA.keys["ROOM"]][5]) then msg = string.gsub(msg, "#room%[5%]#", entry[GEA.keys["ROOM"]][5]) end
    if (entry[GEA.keys["ROOM"]][6]) then msg = string.gsub(msg, "#room%[6%]#", entry[GEA.keys["ROOM"]][6]) end
    if (entry[GEA.keys["ROOM"]][7]) then msg = string.gsub(msg, "#room%[7%]#", entry[GEA.keys["ROOM"]][7]) end
    if (entry[GEA.keys["ROOM"]][8]) then msg = string.gsub(msg, "#room%[8%]#", entry[GEA.keys["ROOM"]][8]) end
    if (entry[GEA.keys["ROOM"]][9]) then msg = string.gsub(msg, "#room%[9%]#", entry[GEA.keys["ROOM"]][9]) end

    msg = string.gsub(msg, "#seconds#", entry[GEA.keys["SECONDES"]])

    local durees = GEA.getDureeInString( entry[GEA.keys["TOTALRUNS"]] * GEA.checkEvery)

    msg = string.gsub(msg, "#duration#", durees[1])
    msg = string.gsub(msg, "#durationfull#", durees[2])
    msg = string.gsub(msg, "#runs#", entry[GEA.keys["TOTALRUNS"]])

    return msg
  end

  -- ---------------------------------------------------------------------------
  -- Converti une durée en chaîne de caratères
  -- ---------------------------------------------------------------------------
  GEA.getDureeInString = function(duree)
    local duree     = duree
    local dureefull = ""

    nHours = math.floor(duree/3600)
    nMins  = math.floor(duree/60 - (nHours*60))
    nSecs  = math.floor(duree - nHours*3600 - nMins *60)
    duree  = ""

    if (nHours > 0) then
      duree     = duree .. nHours .. "h "
      dureefull = dureefull .. nHours

      if (nHours > 1) then
        dureefull = dureefull .. " " .. GEA.translate[GEA.language]["HOURS"]
      else
        dureefull = dureefull .. " " .. GEA.translate[GEA.language]["HOUR"]
      end
    end

    if (nMins > 0) then
      duree = duree .. nMins .. "m "

      if (nHours > 0) then
        dureefull = dureefull .. " "
      end

      if (nSecs == 0 and nHours > 0) then
        dureefull = dureefull .. "et "
      end

      dureefull = dureefull .. nMins
      if (nMins > 1) then
        dureefull = dureefull .. " " .. GEA.translate[GEA.language]["MINUTES"]
      else
        dureefull = dureefull .. " " .. GEA.translate[GEA.language]["MINUTE"]
      end
    end

    if (nSecs > 0) then
      duree = duree .. nSecs .. "s"

      if (nMins > 0) then
        dureefull = dureefull .. " et "
      end

      dureefull = dureefull .. nSecs
      if (nSecs > 1) then
        dureefull = dureefull .. " " .. GEA.translate[GEA.language]["SECONDS"]
      else
        dureefull = dureefull .. " " .. GEA.translate[GEA.language]["SECOND"]
      end
    end

    return {duree, dureefull}
  end

  -- ---------------------------------------------------------------------------
  -- Envoi le message en push
  -- ---------------------------------------------------------------------------
  GEA.sendActions = function(entry)

    GEA.log("sendActions", entry, GEA.translate[GEA.language]["ACTIONS"] , true)

    local pushed = false

    if (type(entry[GEA.keys["PARAMS"]]) == "table") then

      for i = 1, #entry[GEA.keys["PARAMS"]] do
        local paramsIterator = entry[GEA.keys["PARAMS"]][i]

        if (type(paramsIterator) == "table") then
          local lowerValue = string.lower(paramsIterator[1])

          if ((lowerValue == "turnoff" or lowerValue == "turnon" or lowerValue == "switch")) then
            local id = GEA.getId(entry, paramsIterator)

            if (id > 0) then
              local etat = fibaro:getValue(tonumber(id), "value")
              local typef = fibaro:getType(tonumber(id))

              if (GEA.match(typef, "rgb_driver") and ((tonumber(fibaro:getValue(tonumber(id), "value")) > 0 ) or tonumber(fibaro:getValue(tonumber(id), "currentProgramID")) > 0)) then
                -- verison 3.x
                etat = 1
              elseif (GEA.match(typef, "com.fibaro.FGRGBW441M")) then
                if (fibaro:getValue(tonumber(id), "color") ~= "0,0,0,0" or tonumber(fibaro:getValue(tonumber(id), "currentProgramID")) > 0) then
                -- verison 4.x
                  etat = 1
                end
              end

              if (tonumber(etat) >= 1 and lowerValue == "turnoff") or (tonumber(etat) == 0 and lowerValue == "turnon") then
                fibaro:call(tonumber(id), paramsIterator[1])
              elseif (lowerValue == "switch") then
                local mode = "turnOff"

                if (tonumber(etat) == 0) then
                  mode = "turnOn"
                end

                fibaro:call(tonumber(id), mode)
              end

              GEA.log("sendActions", entry, "!ACTION! : " .. paramsIterator[1] , true)
            end
          end

          if (lowerValue == "global" and #paramsIterator > 2) then
            local value = string.match(paramsIterator[3], "(%d+)")

            if (GEA.match(paramsIterator[3], "inc%+")) then
              local number = tonumber(fibaro:getGlobalValue(paramsIterator[2]))

              if (type(value) ~= "nil") then
                fibaro:setGlobal(paramsIterator[2], number + value)
              else
                fibaro:setGlobal(paramsIterator[2], number + 1)
              end
            elseif (GEA.match(paramsIterator[3], "dec%-")) then
              local number = tonumber(fibaro:getGlobalValue(paramsIterator[2]))

              if (type(value) ~= "nil") then
                fibaro:setGlobal(paramsIterator[2], number - value)
              else
                fibaro:setGlobal(paramsIterator[2], number - 1)
              end
            else
              fibaro:setGlobal(paramsIterator[2], GEA.getMessage(entry,paramsIterator[3]))
            end

            GEA.log("sendActions", entry, "!ACTION! : setGlobal " .. paramsIterator[2] .. "," .. GEA.getMessage(entry, paramsIterator[3]) , true)

          elseif (lowerValue == "portable" and #paramsIterator > 1) then
            fibaro:call(tonumber(paramsIterator[2]), "sendPush", GEA.getMessage(entry, nil))
            GEA.log("sendActions", entry, "!ACTION! : pushed to " .. paramsIterator[2], true)
            pushed = true

          elseif (lowerValue == "email" and #paramsIterator > 1) then
            local sujet = "GEA Notification"

            if (#paramsIterator > 2) then
              sujet = paramsIterator[3]
            end

            fibaro:call(tonumber(paramsIterator[2]), "sendEmail", GEA.getMessage(entry, sujet), GEA.getMessage(entry, nil))
            GEA.log("sendActions", entry, "!ACTION! : email to " .. paramsIterator[2], true)

          elseif (lowerValue == "picture" and #paramsIterator > 2) then
            local destinataire = tonumber(paramsIterator[3])
            local camera       = tonumber(paramsIterator[2])

            fibaro:call(camera, "sendPhotoToUser", destinataire)
            GEA.log("sendActions", entry, "!ACTION! : email picture from camera " .. camera .. " to " .. destinataire, true)

          elseif (lowerValue == "scenario" and #paramsIterator > 1) then
            fibaro:startScene(paramsIterator[2])
            GEA.log("sendActions", entry, "!ACTION! : Scene " .. paramsIterator[2], true)

          elseif (lowerValue == "stopscenario" and #paramsIterator > 1) then
            if (fibaro:countScenes(paramsIterator[2])) then
                fibaro:killScene(paramsIterator[2])
                GEA.log("sendActions", entry, "!ACTION! : Stop Scene " .. paramsIterator[2], true)
            else
                GEA.log("sendActions", entry, "!ACTION! : No Stop Scene " .. paramsIterator[2], true)
            end

          elseif (lowerValue == "enablescenario" and #paramsIterator > 1) then
            fibaro:setSceneEnabled(paramsIterator[2], true)
            GEA.log("sendActions", entry, "!ACTION! : Scene enabled " .. paramsIterator[2], true)

          elseif (lowerValue == "disablescenario" and #paramsIterator > 1) then
            fibaro:setSceneEnabled(paramsIterator[2], false)
            GEA.log("sendActions", entry, "!ACTION! : Scene disabled " .. paramsIterator[2], true)

          elseif (lowerValue == "function") then
            local status, err = pcall(paramsIterator[2])

            if (status) then
              GEA.log("sendActions", entry, "!ACTION! : Function OK",  true)
            else
              GEA.log("sendActions", entry, "!ACTION! : Function " .. tostring(err or "Inconnu."), true)
            end

          elseif (lowerValue == "setarmed" and #paramsIterator > 1) then
            fibaro:call(paramsIterator[2], "setArmed", 1)
            GEA.log("sendActions", entry, "!ACTION! : setArmed " .. paramsIterator[2], true)

          elseif (lowerValue == "setdisarmed" and #paramsIterator > 1) then
            fibaro:call(paramsIterator[2], "setArmed", 0)
            GEA.log("sendActions", entry, "!ACTION! : setDisarmed " .. paramsIterator[2], true)

          elseif (lowerValue == "currenticon" and #paramsIterator > 2) then
            fibaro:call(paramsIterator[2], "setProperty", "currentIcon", tostring(paramsIterator[3]))
            GEA.log("sendActions", entry, "!ACTION! : CurrentIcon " .. paramsIterator[2], true)

          elseif (lowerValue == "copyglobal" and #paramsIterator > 2) then
            fibaro:setGlobal(paramsIterator[3], fibaro:getGlobalValue(paramsIterator[2]))
            GEA.log("sendActions", entry, "!ACTION! : CopyGlobal " .. paramsIterator[2], true)

          elseif (lowerValue == "restarttask" and #paramsIterator > 1) then
            GEA.addOrRemoveTask("R", paramsIterator[2], true)
            GEA.log("sendActions", entry, "!ACTION! : Restart " .. paramsIterator[2], true)

          elseif (lowerValue == "stoptask" and #paramsIterator > 1) then
            GEA.addOrRemoveTask("S", paramsIterator[2], true)
            GEA.log("sendActions", entry, "!ACTION! : StopTask " .. paramsIterator[2], true)

          elseif (lowerValue == "wakeup" and #paramsIterator > 1) then
            fibaro:call(1, 'wakeUpAllDevices', (paramsIterator[2]))
            GEA.log("sendActions", entry, "!ACTION! : WakeUp " .. paramsIterator[2], true)

          elseif (lowerValue == "virtualdevice" and #paramsIterator > 2) then
            fibaro:call(paramsIterator[2], "pressButton", tostring(paramsIterator[3]))
            GEA.log("sendActions", entry, "!ACTION! : VirtualDevice " .. paramsIterator[2] .. "," .. paramsIterator[3], true)

          elseif (lowerValue == "slider" and #paramsIterator > 3) then
            fibaro:call(paramsIterator[2], "setSlider", paramsIterator[3], paramsIterator[4])
            GEA.log("sendActions", entry, "!ACTION! : Slider " .. paramsIterator[2] .. "," .. paramsIterator[3] .. "=" .. paramsIterator[4], true)

          elseif (lowerValue == "label" and #paramsIterator > 3) then
            fibaro:call(paramsIterator[2], "setProperty", "ui."..paramsIterator[3] .. ".value", GEA.getMessage(entry, paramsIterator[4]))
            GEA.log("sendActions", entry, "!ACTION! : Label " .. paramsIterator[2] .. "," .. paramsIterator[3]  .. " = " ..  GEA.getMessage(entry, paramsIterator[4]), true)

          elseif (lowerValue == "rgb" and #paramsIterator > 5) then
            -- added by Shyrka973
            if (paramsIterator[3] == -1 or paramsIterator[4] == -1 or paramsIterator[5] == -1 or paramsIterator[6] == -1) then
              if (paramsIterator[3] ~= -1) then
                fibaro:call(paramsIterator[2], "setR", paramsIterator[3])
              end

              if (paramsIterator[4] ~= -1) then
                fibaro:call(paramsIterator[2], "setG", paramsIterator[4])
              end

              if (paramsIterator[5] ~= -1) then
                fibaro:call(paramsIterator[2], "setB", paramsIterator[5])
              end

              if (paramsIterator[6] ~= -1) then
                fibaro:call(paramsIterator[2], "setW", paramsIterator[6])
              end
            else
              fibaro:call(paramsIterator[2], "setColor", paramsIterator[3], paramsIterator[4], paramsIterator[5], paramsIterator[6])
            end

            GEA.log("sendActions", entry, "!ACTION! : RGB " .. paramsIterator[2] .. ", Color = " .. paramsIterator[3]  .. "," .. paramsIterator[4] .. "," .. paramsIterator[5] .. "," .. paramsIterator[6])

          elseif (lowerValue == "program" and #paramsIterator > 2) then
            if (tonumber(fibaro:getValue(tonumber(paramsIterator[2]), "currentProgramID")) ~= tonumber(paramsIterator[3])) then
              fibaro:call(paramsIterator[2], "startProgram", paramsIterator[3])
            end

            GEA.log("sendActions", entry, "!ACTION! : startProgram " .. paramsIterator[2] .. ", program = " .. paramsIterator[3])

          elseif (lowerValue == "value") then
            local id = GEA.getId(entry, paramsIterator)

            if (id > 0) then
              if (#paramsIterator > 2) then
                fibaro:call(id, "setValue", paramsIterator[3])
                GEA.log("sendActions", entry, "!ACTION! : setValue " .. paramsIterator[3], true)
              else
                fibaro:call(id, "setValue", paramsIterator[2])
                GEA.log("sendActions", entry, "!ACTION! : setValue " .. paramsIterator[2], true)
              end
            end

          elseif (lowerValue == "open" or lowerValue == "close") then
            local id = GEA.getId(entry, paramsIterator)

            if (id > 0) then
              local pourc = 100

              if (#paramsIterator > 2) then
                if (lowerValue == "close") then
                  pourc = pourc - paramsIterator[3]
                else
                  pourc = paramsIterator[3]
                end

                fibaro:call(id, "setValue", pourc)
                GEA.log("sendActions", entry, "!ACTION! : setValue " .. pourc, true)

              elseif (#paramsIterator > 1) then
                if (lowerValue == "close") then
                  pourc = pourc - paramsIterator[2]
                else
                  pourc = paramsIterator[2]
                end

                fibaro:call(id, "setValue", pourc)
                GEA.log("sendActions", entry, "!ACTION! : setValue " .. pourc, true)

              else
                fibaro:call(id, paramsIterator[1])
                GEA.log("sendActions", entry, "!ACTION! :  " .. paramsIterator[1], true)

              end
            end
          end
        end
      end
    end

    if (entry[GEA.keys["MESSAGE"]] ~= "" and not pushed) then
      if (entry[GEA.keys["MESSAGE"]] == "debug") then
        fibaro:debug("==============" .. os.time() .. "=====================")
      else
        for i = 1, #GEA.portables do
          fibaro:call(tonumber(GEA.portables[i]), "sendPush",GEA.getMessage(entry, nil))
          GEA.log("sendActions", entry, "!ACTION! : sendPush " .. GEA.getMessage(entry, nil), true)
        end
      end
    end
  end

  -- ---------------------------------------------------------------------------
  -- Chercher l'id du périphérique
  -- ---------------------------------------------------------------------------
  GEA.getId = function(entry, param)
    local id = 0

    if (param and type(param) == "table" and #param > 1 and (string.lower(param[1]) == "turnoff" or string.lower(param[1]) == "turnon" or string.lower(param[1]) == "switch")) then
      id = tonumber(param[2])
    elseif (param and type(param) == "table" and #param > 2 and (string.lower(param[1]) == "value" or string.lower(param[1]) == "open" or string.lower(param[1]) == "close")) then
      id = tonumber(param[2])
    elseif (type(entry[GEA.keys["ID"]]) == "number") then
      id = entry[GEA.keys["ID"]]
    elseif (type(entry[GEA.keys["ID"]]) == "table" and string.lower(entry[GEA.keys["ID"]][1]) == "sensor+" or string.lower(entry[GEA.keys["ID"]][1]) == "sensor-" or string.lower(entry[GEA.keys["ID"]][1]) == "value-" or string.lower(entry[GEA.keys["ID"]][1]) == "value+" or string.lower(entry[GEA.keys["ID"]][1]) == "dead") then
      id = tonumber(entry[GEA.keys["ID"]][2])
    end

    if (id == 0) then
      fibaro:debug(GEA.translate[GEA.language]["DEVICE_NOT_FOUND"])
    end

    return id
  end

  -- ---------------------------------------------------------------------------
  -- Le système est-il en pause
  -- ---------------------------------------------------------------------------
  GEA.pause = function()
    local continue = true

    if (#GEA.getGlobalForActivation > 0) then
      continue = false

      if (fibaro:getGlobalValue(GEA.getGlobalForActivation[1]) == GEA.getGlobalForActivation[2]) then
        continue = true
      else
        GEA.log("Run", nil, GEA.translate[GEA.language]["GEA_SUSPENDED"] .. " " .. GEA.getGlobalForActivation[1] .. " " .. GEA.translate[GEA.language]["VALUE"] .. " " .. fibaro:getGlobalValue(GEA.getGlobalForActivation[1]) .. " " .. GEA.translate[GEA.language]["REQUIRED"] .. " " .. GEA.getGlobalForActivation[2], true)
      end
    end

    return not continue
  end

  -- ---------------------------------------------------------------------------
  -- Contrôle tous les périphériques déclarés toutes les X secondes
  -- ---------------------------------------------------------------------------
  GEA.run = function()
    if (config) then
      config()
    end

    if (setEvents) then
      setEvents()
    end

    if (GEA.isVersionFour) then
      GEA.power = "power"
    end

    GEA.log("GEA Version " .. GEA.version, nil, " " .. GEA.translate[GEA.language]["RUNNING"] .. "...", true, "green")

    if (#GEA.todo == 0) then
      if (GEA.source["type"] ~= "property") then
        GEA.log(GEA.translate[GEA.language]["RUN"], nil, GEA.translate[GEA.language]["NOTHING_TODO"], true)
      else
        GEA.log(GEA.translate[GEA.language]["RUN"], nil, GEA.translate[GEA.language]["NOTHING_TODOID"] .. GEA.source["deviceID"], true)
      end

      return false
    end

    local nbElement = #GEA.todo

    if (GEA.source["type"] == "autostart") then
      if (GEA.useTasksGlobal) then
        fibaro:setGlobal(GEA.globalTasks, GEA.suspended)
      else
        GEA.tasks = GEA.suspended
      end

      local delai      = GEA.checkEvery
      local count      = 1
      local firstOfAll = true
      local allStart   = os.time()

      while true do
        GEA.log(GEA.translate[GEA.language]["RUN"], nil, GEA.translate[GEA.language]["SLEEPING"] .. " " .. GEA.checkEvery .. " " .. GEA.translate[GEA.language]["SECONDS"], false)
        fibaro:sleep(delai * 1000)

        local start = os.time()

        local stop = GEA.checkAllToDo(nbElement)
        local diff = (stop - start) -- / 1000

        if (firstOfAll) then
          diff       = diff * 2
          firstOfAll = false
        end

        delai = GEA.checkEvery - diff
        -- Log toutes les 20 checks que GEA tourne
        if (count >= 20) then
          local msg = GEA.translate[GEA.language]["RUN_FOR"] .. diff .. "s " .. GEA.translate[GEA.language]["RUN_NEW"] .. delai .. "s / ".. GEA.translate[GEA.language]["RUN_SINCE"] .. " " .. GEA.getDureeInString(os.time() - allStart)[1]
          fibaro:debug("<span style=\"color:CadetBlue; padding-left:125px; display:inline-block; width:80%; margin-top:-18px; padding-top:-18px; text-align:left;\">" .. msg .. "</span>")
          count = 0
        end

        count = count + 1
      end
    else
      GEA.checkAllToDo(nbElement)
    end
  end

  -- ---------------------------------------------------------------------------
  --  Check les tâches à effectuer sinon, log si une erreur survient
  -- ---------------------------------------------------------------------------
  GEA.checkAllToDo = function(nbElement)
    if (not GEA.pause()) then
      for i = 1, nbElement do
        GEA.log(GEA.translate[GEA.language]["RUN"], GEA.todo[i], GEA.translate[GEA.language]["CHECKING"], false)

        if (GEA.catchError) then
          if (not pcall(function() GEA.check(GEA.todo[i], i) end)) then
            GEA.log(GEA.translate[GEA.language]["ERROR"], GEA.todo[i], GEA.translate[GEA.language]["CHECKING"], true, red)
          end
        else
          GEA.check(GEA.todo[i], i)
        end
      end
    end

    return os.time()
  end

  -- ---------------------------------------------------------------------------
  -- Contrôle tous les périphériques déclarés toutes les X secondes
  -- ---------------------------------------------------------------------------
  GEA.log = function(method, entry, message, force, color)
    if (force or GEA.debug) then
      local msg  = ""
      local name = "If"

      if (not entry and not force) then
        return

      elseif (entry) then
        local typeEntry = type(entry[GEA.keys["ID"]])

        if (entry[GEA.keys["NAME"]]) then
          name =  entry[GEA.keys["NAME"]]

          if (type(name) == "table") then
            name = name[1]
          end

          name = name .. " ] "

          if (typeEntry == "nil" or typeEntry == "boolean") then
            msg = msg .. "[ " .. name
          elseif (typeEntry == "number") then
            msg = msg .. "[ " .. entry[GEA.keys["ID"]] .. " | " .. name
          elseif (typeEntry == "table") then
            lowerId = string.lower(entry[GEA.keys["ID"]][1])

            if (GEA.match(lowerId, "global|global.")) then
              msg = msg .. "[ " .. entry[GEA.keys["ID"]][2] .. "=" .. entry[GEA.keys["ID"]][3] .. " ] "
            elseif (lowerId == "batteries") then
              msg = msg .. "[ " .. entry[GEA.keys["ID"]][2] .. " ] "
            elseif (lowerId == "group") then
              msg = msg .. "[ " .. name
            elseif (GEA.match(lowerId, "sensor|sensor.|value|value.|dead|sceneactivation|battery")) then
              msg = msg .. "[ " .. name
            elseif (GEA.match(lowerId, "slider|slider.|label|label.|property|property.")) then
              msg = msg .. "[ " .. name
            elseif (lowerId == "weather") then
              msg = msg .. "[ Weather ] "
            elseif (lowerId == "function") then
              msg = msg .. "[ Function ] "
            elseif (lowerId == "alarm") then
              msg = msg .. "Alarm " .. fibaro:getValue(tonumber(entry[GEA.keys["ID"]][2]), "ui.lblAlarme.value")
            else
              -- autre à venir
            end
          end
        end
      end

      if (method and method ~= "") then
        msg = msg .. string.format("%-20s", method) .. ": "
      end

      if (message and message ~= "") then
        msg = msg .. string.format("%-20s", message)
      end

      if (entry) then
        if (entry[GEA.keys["INDEX"]]) then
          msg = msg .. " (ID: " .. entry[GEA.keys["INDEX"]] .. ")"
        end

        if (entry[GEA.keys["PARAMS"]] and type(entry[GEA.keys["PARAMS"]]) == "table" and #entry[GEA.keys["PARAMS"]] > 0) then
          for i = 1, #entry[GEA.keys["PARAMS"]] do
            msg            = msg .. " ["
            local paramToIterate = entry[GEA.keys["PARAMS"]][i]

            if (type(paramToIterate) == "table") then
              for j = 1, #paramToIterate do
                if (string.lower(paramToIterate[1]) == "if") then
                  if (j == 1) then
                    msg = msg .. "If..."
                  end
                elseif (string.lower(paramToIterate[1]) == "function") then
                  if (j == 1) then
                    msg = msg .. "Function..."
                  end
                else
                  msg = msg .. paramToIterate[j] .. ","
                end
              end
            end

            msg = msg:sub(1, msg:len()-1) .. "]"
          end
        end
      end

      fibaro:debug("<span style=\"color:" .. (color or "white") .. "; padding-left: 125px; display:inline-block; width:80%; margin-top:-18px; padding-top:-18px; text-align:left;\">" .. msg .. "</span>")
    end
  end


end
-- Démarrage de GEA
GEA.run()
