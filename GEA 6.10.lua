--[[
%% autostart
%% properties
%% globals
--]]

-- ==========================================================
-- GEA : Gestionnaire d'Evénements Automatique
-- v 6.10
-- Créé par Steven en collaboration avec Pepite et Thibaut
-- Remerciement à :
-- tous les utilisateurs/testers/apporteurs d'idées du 
-- forum Domotique-fibaro.fr
-- ==========================================================
-- ajout de LedBrightness
-- ajout de DeviceState
-- ajout de NeighborList
-- ajout de LastWorkingRoute
-- ajout de CheckVG
-- correction du "Name" pour Or et Xor
-- contrôle des variables globales (API not found)
-- contrôle des labels (API not found)
-- usage du cache pour les noms de modules et pièces

function config() 
  -- ===================================================
  -- CONFIGURATON GENERALE
  -- ===================================================
  GEA.checkEvery = 30
  GEA.portables = {256} 
  GEA.globalvariables = "GEA_Tasks6"
  GEA.language = "fr"
  
  -- ===================================================
  -- FIN CONFIGURATION GENERALE
  -- =================================================== 
end

function setEvents() 
  -- ==========================================================
  -- LE CODE UTILISATEUR DOIT ALLER ICI
  -- ==========================================================
  
  -- ==========================================================
  -- FIN DU CODE UTILISATEUR
  -- =========================================================== 
end


-- ==========================================================
-- [FR] NE PLUS RIEN TOUCHER
-- [EN] DON'T TOUCH UNDER THIS POINT
-- ==========================================================
-- ==========================================================
-- Tous ce que GEA sait faire est ici
-- ===========================================================
if (not GEA) then
  
  if not tools then tools={version="2.00",addstyle="",isdebug=false,log=function(a,b,c)a=tools.tostring(a)for d,e in string.gmatch(a,"(#spaces(%d+)#)")do local f=""for g=1,e do f=f.."."end;a=string.gsub(a,d,"<span style=\"color:black;"..tools.addstyle.."\">"..f.."</span>")end;if tools.isdebug or c then fibaro:debug("<span style=\"color:"..(b or"white")..";"..tools.addstyle.."\">"..a.."</span>")end end,error=function(a,b)tools.log(a,b or"red",true)end,warning=function(a,b)tools.log(a,b or"orange",true)end,info=function(a,b)tools.log(a,b or"white",true)end,debug=function(a,b)tools.log(a,b or"gray",false)end,tostring=function(h)if type(h)=="boolean"then if h then return"true"else return"false"end elseif type(h)=="table"then if json then return json.encode(h)else return"table found"end else return tostring(h)end end,split=function(i,j)local j,k=j or":",{}local l=string.format("([^%s]+)",j)i:gsub(l,function(m)k[#k+1]=m end)return k end,trim=function(n)return n:gsub("^%s*(.-)%s*$","%1")end,deep_print=function(o)for g,p in pairs(o)do if type(p)=="table"then deep_print(p)else print(g,p)end end end,iif=function(q,r,s)if q then return r else return s end end,cut=function(t,u)u=u or 10;if u<t:len()then return t:sub(1,u-3).."..."end;return t end,isNumber=function(v)if type(v)=="number"then return true end;if type(v)=="string"then return type(tonumber(v))=="number"end;return false end,getStringTime=function(w)if w then return os.date("%H:%M:%S")end;return os.date("%H:%M")end,toTime=function(x)local y,z=string.match(x,"(%d+):(%d+)")local A=os.date("*t")local B=os.time{year=A.year,month=A.month,day=A.day,hour=y,min=z,sec=0}if B<os.time()then B=os.time{year=A.year,month=A.month,day=A.day+1,hour=y,min=z,sec=0}end;return B end,getStringDate=function()return os.date("%d/%m/%Y")end,isNil=function(C)return type(C)=="nil"end,isNotNil=function(C)return not tools.isNil(C)end}end
  tools.addstyle = "padding-left: 125px; display:inline-block; width:80%; margin-top:-18px; padding-top:-18px;"
  
  GEA = {}
  
  GEA.globalvariables   = "GEA_Tasks"
  GEA.pluginsvariables  = "GEA_Plugins"
  GEA.control           = true
  GEA.power             = tools.iif(api, "power", "valueSensor")
  GEA.version           = "6.10"
  GEA.checkEvery        = 30       -- durée en secondes
  GEA.debug             = false          -- mode d'affiche debug on/off
  GEA.secureAction      = GEA.catchError or true   -- utilise pcall() ou pas
  GEA.source            = fibaro:getSourceTrigger()
  GEA.auto              = GEA.source.type == "autostart"
  GEA.language          = nil
  GEA.running           = fibaro:isSceneEnabled(__fibaroSceneId)
  GEA.globalvalue       = nil
  GEA.globalhisto       = nil
  GEA.runAt             = nil
  
  GEA.portables = {} 
  GEA.moduleNames = {}
  GEA.moduleRooms = {}
  GEA.variables = {} 
  GEA.plugins = {}
  GEA.output = nil
  GEA.stoppedTasks = {}
  GEA.history = {}
  GEA.historyvariable = "GEA_History"
  GEA.historymax = 5
  GEA.pluginsreturn = {}
  GEA.pluginretry = 500
  GEA.pluginmax = 5
  GEA.garbagevalues = {}
  GEA.usedoptions = {}
  GEA.event = nil
  GEA.declared = {}
  GEA.forceRefreshValues = false
  GEA.showRoomNames = true
  GEA.batteriesWithRoom = GEA.showRoomNames
  
  GEA.traduction = {
    en = {        
        id_missing          = "ID : %s doesn't exists",
        global_missing      = "Global : %s doesn't exists",
        label_missing       = "Label : [%d] %s doesn't exists",
        not_number          = "%s must be a number",
        from_missing        = "&lt;from&gt; is mandatory",
        varCacheInstant     = "VariableCache doesn't work with event instance",
        central_instant     = "CentralSceneEvent works only with event instance",
        central_missing     = "id, key et attribute are mandatory",
        property_missing    = "Property : %s can't be found",
        option_missing      = "Option : %s is missing",
        not_an_action       = "Option : %s can't be used as an action",
        not_math_op         = "Option : %s doesn't allow + or - operations",
        hour                = "hour",
        hours               = "hours",
        andet               = "and",
        minute              = "minute",
        minutes             = "minutes",
        second              = "second",
        seconds             = "seconds",
        err_cond_missing    = "Error : condition(s) required",
        err_dur_missing     = "Error : duration required", 
        err_msg_missing     = "message required, empty string is allowed",
        not_an_condition    = "Option : %s can't be used as a condition",
        no_action           = "< no action >",
        repeated            = "repeat",
        stopped             = "stopped",
        maxtime             = "MaxTime",
        add_event           = "Add immediately :",
        add_auto            = "Add auto :",
        gea_failed          = "GEA ... STOPPED",
        validate            = "Validation",
        action              = "action",
        err_check           = "Error, check : ",
        date_format         = "%d.%m.%y",
        hour_format         = "%X",
        input_date_format   = "dd/mm/yyyy",
        quit                = "Quit",
        gea_run_since       = "GEA run since %s",
        gea_check_nbr       = "... check running #%d @%ds...",
        gea_start           = "Started automatically of GEA %s (mode %s)",
        gea_start_event     = "Started by event of GEA %s (mode %s [%s])",
        gea_minifier        = "Use minifiertools v. %s",
        gea_check_every     = "Check automatic every %s seconds",
        gea_global_create   = "Creation of %s global variable",
        gea_load_usercode   = "Loading user code setEvents() ...",
        gea_nothing         = "No entry to check",
        gea_start_time      = "GEA started on %s at %s ...",
        gea_stopped_auto    = "GEA has stopped running in automatic mode",
        week_short          = {"mo", "tu", "we", "th", "fr", "sa", "su"},
        week                = {"monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"},
        months              = {"january", "febuary", "march", "april", "may", "juin", "july", "august", "september", "october", "november", "december"},
        weekend             = "Weekend",
        weekdays            = "Weekdays",
        weather             = {"clear", "cloudy", "rain", "snow", "storm", "fog"},
        search_plugins      = "Searching plugins, ...",
        plugins_none        = "Found any",
        plugin_not_found    = "Plugin not found",
        popupinfo           = "Information",
        popupsuccess        = "Success",
        popupwarning        = "Warning", 
        popupcritical       = "Critical",
        memoryused          = "Memory used: ",
        optimization        = "Optimization...",
        removeuseless       = "Removing useless option: ",
        removeuselesstrad   = "Removing useless traduction: ",
        start_entry         = "Started",
        no_entry_for_event  = "No entry for this event %s, please remove it from header",
        locale              = "en-US",
        execute             = "Démarrer",
        name_is_missing     = "Name isn't specified",
        room_is_missing     = "Room isn't specified",
    }, 
    fr = {
        id_missing          = "ID : %s n'existe(nt) pas",
        global_missing      = "Global : %s n'existe(nt) pas",
        label_missing       = "Label : [%d] %s n'existe pas",
        not_number          = "%s doit être un numéro",
        from_missing        = "&lt;from&gt; est obligatoire",
        varCacheInstant     = "VariableCache ne fonctionne pas avec les déclenchements instantanés",
        central_instant     = "CentralSceneEvent ne fonctionne qu'avec des déclenchements instantanés",
        central_missing     = "id, key et attribute sont obligatoires",
        property_missing    = "Propriété: %s introuvable",
        option_missing      = "Option : %s n'existe pas",
        not_an_action       = "Option : %s ne peut pas être utilisé comme action",
        not_math_op         = "Option : %s n'autorise pas les + ou -",
        hour                = "heure",
        hours               = "heures",
        andet               = "et",
        minute              = "minute",
        minutes             = "minutes",
        second              = "seconde",
        seconds             = "secondes",
        err_cond_missing    = "Erreur : condition(s) requise(s)",
        err_dur_missing     = "Erreur : durée requise", 
        err_msg_missing     = "message requis, chaine vide autorisée",
        not_an_condition    = "Option : %s ne peut pas être utilisé comme une condition",
        no_action           = "< pas d'action >",
        repeated            = "répété",
        stopped             = "stoppé",
        maxtime             = "MaxTime",
        add_event           = "Ajout immédiat :",
        add_auto            = "Ajout auto :",
        gea_failed          = "GEA ... ARRETE",
        validate            = "Validation",
        action              = "action",
        err_check           = "Erreur, vérifier : ",
        date_format         = "%d.%m.%y",
        hour_format         = "%X",
        input_date_format   = "dd/mm/yyyy",
        quit                = "Quitter",
        gea_run_since       = "GEA fonctionne depuis %s",
        gea_check_nbr       = "... vérification en cours #%d @%ds...",
        gea_start           = "Démarrage automatique de GEA %s (mode %s)",
        gea_start_event     = "Démarrage par évenement de GEA %s (mode %s [%s])",
        gea_minifier        = "Utilisation de minifiertools v. %s",
        gea_check_every     = "Vérification automatique toutes les %s secondes",
        gea_global_create   = "Création de la variable globale : %s",
        gea_load_usercode   = "Chargement du code utilisateur setEvents() ...",
        gea_nothing         = "Aucun traitement à effectuer",
        gea_start_time      = "GEA a démarré le %s à %s ...",
        gea_stopped_auto    = "GEA est arrêté en mode automatique",
        week_short          = {"lu", "ma", "me", "je", "ve", "sa", "di"},
        week                = {"lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche"},
        months              = {"janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre"},
        weekend             = "Weekend",
        weekdays            = "Semaine",
        weather             = {"dégagé", "nuageux", "pluvieux", "neigeux", "orageux", "brouillard"},
        search_plugins      = "Recherche de plugins, ...",
        plugins_none        = "Aucun plugins trouvé",
        plugin_not_found    = "Plugin inexistant",
        popupinfo           = "Information",
        popupsuccess        = "Succès",
        popupwarning        = "Attention appelée", 
        popupcritical       = "Erreur Critique",
        memoryused          = "Mémoire utilisée : ",
        optimization        = "Optimisation en cours ...",
        removeuseless       = "Suppression d'option inutile : ",
        removeuselesstrad   = "Suppression de traduction inutile : ",
        start_entry         = "Démarrage",
        no_entry_for_event  = "Aucune entrée pour l'évennement %s, supprimer le de l'entête",
        locale              = "fr-FR",
        execute             = "Execute",
        name_is_missing     = "Nom inconnue",
        room_is_missing     = "Pièce inconnue",
    }
  }  
 
  -- ----------------------------------------------------------
  -- Déclaration de toutes les fonctions de GEA
  --   f    = {name="Nouvelle fonction", 
  --                  math=true, -- autorise les + et -
  --                  keepValues = true, ne traduit pas les sous-table {"TurnOn", 73} reste ainsi et non pas true ou false
  --                  control=function(name,value) if (...) then return true else return false, "Message d'erreur" end end,
  --                  getValue=function(name) return <la valeur> end, 
  --                  action=function(name,value) <effectuer l'action> end
  --              },
  -- ----------------------------------------------------------
  GEA.options = {
    number    = {name="ID",
                    control=function(id) if (type(id) ~= "table") then id = {id} end local res, msg = true, "" for i=1, #id do if (not GEA.getName(id[i], GEA.showRoomNames)) then res = false msg = msg .. id[i] .. " " end end return res, string.format(GEA.trad.id_missing, msg) end,
                    getValue=function(id) return tonumber(fibaro:getValue(id, "value")) end, 
                },
    boolean   = {name="Boolean",
                    getValue=function(bool) return bool end, 
                },
    global    = {name="Global", 
                    optimize = true,
                    math=true, -- autorise les Global+ et Global-
                    control=function(name) if (type(name) ~= "table") then name = {name} end local res, msg = true, "" for i=1, #name do if (not GEA.getGlobalValue(name[i])) then res = false msg = msg .. name[i] .. " " end end return res, string.format(GEA.trad.global_missing, msg) end,
                    getValue=function(name) return GEA.getGlobalValue(name) end, 
                    action=function(name,value) 
                      if (type(name) ~= "table") then name = {name} end
                      for i=1, #name do fibaro:setGlobal(name[i], GEA.getMessage(GEA.incdec(value, GEA.options.global.getValue(name[i])))) end
                    end
                },
    value     = {name="Value", 
                    optimize = true,
                    math=true, -- autorise les Value+ et Value-
                    control=function(id) return GEA.options.number.control(id) end, 
                    getValue=function(id) if (not id) then id = GEA.currentMainId end return fibaro:getValue(id, "value") end, 
                    action=function(id, value) if (not value) then value = id id = GEA.currentMainId end if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i],"setValue",GEA.incdec(value, GEA.options.value.getValue(id[i]))) end end
                },
    value2    = {name="Value2",
                    optimize = true,
                    math=true, -- autorise les Value+ et Value-
                    control=function(id) return GEA.options.value.control(id) end, 
                    getValue=function(id) if (not id) then id = GEA.currentMainId end return fibaro:getValue(id, "value2") end, 
                    action=function(id, value) if (not value) then value = id id = GEA.currentMainId end if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i],"setValue2",GEA.incdec(value, GEA.options.value2.getValue(id[i]))) end end
                },
    property  = {name="Property", 
                    optimize = true,
                    math=true,
                    control=function(id) return GEA.options.number.control(id) end, 
                    getValue=function(id, property) return fibaro:getValue(id, property) end,
                    action=function(id, property, value) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i], "setProperty", property, GEA.getMessage(GEA.incdec(value, GEA.options.property.getValue(id, property)))) end end
                },
    turnon    = {name="TurnOn", 
                    optimize = true,
                    control=function(id) if (not id) then id = GEA.currentMainId end return GEA.options.number.control(id) end, 
                    getValue=function(id) if (not id) then id = GEA.currentMainId end  return tonumber(fibaro:getValue(id, "value"))>0 end, 
                    action=function(id, duree) if (not id) then id = GEA.currentMainId end if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i],"turnOn") end if (duree) then setTimeout(function() for i=1, #id do fibaro:call(id[i],"turnOff") end end, tonumber(duree) * 1000) end end
                },
    turnoff   = {name="TurnOff", 
                    optimize = true,
                    control=function(id) if (not id) then id = GEA.currentMainId end return GEA.options.number.control(id) end, 
                    getValue=function(id) if (not id) then id = GEA.currentMainId end return tonumber(fibaro:getValue(id, "value"))==0 end, 
                    action=function(id, duree) if (not id) then id = GEA.currentMainId end if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i],"turnOff") end if (duree) then setTimeout(function() for i=1, #id do fibaro:call(id[i],"turnOn") end end, tonumber(duree) * 1000) end end
                },
    switch    = {name="Switch",
                    optimize = true,
                    control=function(id) if (not id) then id = GEA.currentMainId end return GEA.options.number.control(id) end, 
                    action=function(id) if (not id) then id = GEA.currentMainId end if (type(id) ~= "table") then id = {id} end for i=1, #id do if (tonumber(fibaro:getValue(id[i], "value"))>0) then fibaro:call(id[i],"turnOff") else fibaro:call(id[i],"turnOn") end end end
                },
    armed     = {name="Armed", 
                    optimize = true,
                    control=function(id) if (not id) then id = GEA.currentMainId end return GEA.options.number.control(id) end,
                    getValue=function(id) if (not id) then id = GEA.currentMainId end return tonumber(fibaro:getValue(id, "armed"))==1 end, 
                },
    disarmed  = {name="Disarmed", 
                    optimize = true,
                    control=function(id) if (not id) then id = GEA.currentMainId end return GEA.options.number.control(id) end,
                    getValue=function(id) if (not id) then id = GEA.currentMainId end return tonumber(fibaro:getValue(id, "armed"))==0 end, 
                },
    setarmed     = {name="Armed", 
                    optimize = true,
                    control=function(id) if (not id) then id = GEA.currentMainId end return GEA.options.number.control(id) end,
                    getValue=function(id) if (not id) then id = GEA.currentMainId end return tonumber(fibaro:getValue(id, "armed"))==1 end, 
                    action=function(id) if (not id) then id = GEA.currentMainId end if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i],"setArmed", 1) end end
                },
    setdisarmed  = {name="Disarmed",
                    optimize = true,
                    control=function(id) if (not id) then id = GEA.currentMainId end return GEA.options.number.control(id) end,
                    getValue=function(id) if (not id) then id = GEA.currentMainId end return tonumber(fibaro:getValue(id, "armed"))==0 end, 
                    action=function(id) if (not id) then id = GEA.currentMainId end if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i],"setArmed", 0) end end
                },
    sensor    = {name="Sensor",
                    optimize = true,
                    math=true,
                    control=function(id) if (not id) then id = GEA.currentMainId end return GEA.options.number.control(id) end,
                    getValue=function(id) if (not id) then id = GEA.currentMainId end return fibaro:getValue(id, GEA.power) end
                },
    virtualdevice = {name="VirtualDevice", 
                    optimize = true,
                    control=function(id, button) local check, message = GEA.options.number.control(id) if (check) then return tools.isNumber(button), string.format(GEA.trad.not_number, button) else return check, message end end,
                    action=function(id, button) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i], "pressButton", tostring(button)) end end
                },
    label     = {name="Label",
                    optimize = true,
                    math=true,
                    control=function(id, property) if (not GEA.options.checklabel.getValue(id, property)) then return false, string.format(GEA.trad.label_missing, id, property) else return true end end,
                    getValue=function(id, property) return fibaro:getValue(id, "ui."..property:gsub("ui.", ""):gsub(".value", "")..".value") end, 
                    action=function(id, property, value) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i], "setProperty", "ui."..property..".value", GEA.getMessage(GEA.incdec(value, GEA.options.label.getValue(id[i], property)))) end end
                },
    time      = {name="Time", 
                    control=function(from) if (from and from:len()>0 ) then return true else return false, GEA.trad.from_missing end end,
                    getValue=function(from, to) if (not to) then to = from end if (not to) then return os.date(GEA.trad.hour_format, GEA.runAt) end return GEA.checkTime(from, to) end
                },
    days      = {name="Days", 
                    optimize = true,
                    getValue=function(days) return GEA.checkDays(days) end
                },
    dates     = {name="Dates", 
                    optimize = true,
                    control=function(from) if (from and from:len()>0 ) then return true else return false, GEA.trad.from_missing end end,
                    getValue=function(from, to) return GEA.checkDates(from, to) end
                },
    dst       = {name="DST", 
                    optimize = true,
                    getValue=function() return os.date("*t", GEA.runAt).isdst end
                },
    nodst     = {name="NODST", 
                    optimize = true,
                    getValue=function() return not os.date("*t", GEA.runAt).isdst end
                },
    weather   = {name="Weather",
                    optimize = true,
                    math=true, 
                    getValue=function(property) if (not property or property=="") then property = "WeatherCondition" end return fibaro:getValue(3, property) end
                },
    weatherlocal   = {name="WeatherLocal",
                    optimize = true,
                    math=true, 
                    depends = {"weather"},
                    getValue=function(property) return GEA.translatetrad("weather", GEA.getOption({"Weather", property}).getValue()) end
                },
    battery   = {name="Battery", 
                    optimize = true,
                    math=true,
                    control=function(id) return GEA.options.number.control(id) end,
                    getValue=function(id) return fibaro:getValue(id, 'batteryLevel') end
                },
    batteries = {name="Batteries", 
                    optimize = true,
                    getValue=function(value) return GEA.batteries(value) end,
                    getName=function(value) local _, names, _ = GEA.batteries(value, GEA.batteriesWithRoom) return names end,
                    getRoom=function(value) local _, _, rooms = GEA.batteries(value, GEA.batteriesWithRoom) return rooms end
                },
    dead      = {name="Dead", 
                    optimize = true,
                    control=function(id) return GEA.options.number.control(id) end,
                    getValue=function(id) return tonumber(fibaro:getValue(id, "dead"))>0 end, 
                    action=function(id) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(1, "wakeUpAllDevices", id[i]) end end
                },
    deads     = {name="Deads", 
                    optimize = true,
                    getValue=function() local devices = api.get("/devices?property=[dead,true]&enabled=true") return #devices>0, #devices end, 
                    action=function() 
                      local devices = api.get("/devices?property=[dead,true]&enabled=true")
                      for _, v in pairs(devices) do fibaro:call(1, "wakeUpAllDevices", v.id) end                      
                    end,
                    getName=function() return "" end,
                    getRoom=function() return "" end                    
                },                
    sceneactivation = {name="SceneActivation", 
                    optimize = true,
                    getValue=function(id, value) return tonumber(fibaro:getValue(id, "sceneActivation")) == tonumber(value) end
                },
    fonction  = {name="Function", 
                    optimize = true,
                    getValue=function(func) return func() end, 
                    action=function(func) GEA.forceRefreshValues = true func() end
                },
    copyglobal= {name="CopyGlobal", 
                    optimize = true,
                    control=function(source, destination) return GEA.options.global.control({source, destination}) end,
                    action=function(source,destination) fibaro:setGlobal(destination, GEA.getGlobalValue(source)) end
                },
    portable  = {name="Portable", 
                    action=function(id, message) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i], "sendPush", GEA.getMessage(message)) end end
                },
    email     = {name="Email", 
                    optimize = true,
                    action=function(id, message, sujet) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i], "sendEmail", sujet or ("GEA " .. GEA.version), GEA.getMessage(message)) end end
                },
    currenticon= {name="CurrentIcon", 
                    optimize = true,
                    control=function(id) return GEA.options.number.control(id) end,
                    getValue=function(id) return fibaro:getValue(id, "currentIcon") end, 
                    action=function(id, value) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i], "setProperty", "currentIcon", value) end end
                },
    scenario  = {name="Scenario", 
                    keepValues = true,
                    control=function(id) return type(fibaro:isSceneEnabled(id)) ~= nil end,
                    action=function(id, args) if (type(id) ~= "table") then id = {id} end 
                      for i=1, #id do fibaro:startScene(id[i], json.decode(GEA.getMessage(json.encode(args)))) end 
                    end
                },
    killscenario  = {name="Kill", 
                    optimize = true,
                    control=function(id) return GEA.options.scenario.control(id) end,
                    action=function(id) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:killScenes(id[i]) end end
                },
    picture   = {name="Picture", 
                    optimize = true,
                    keepValues = true,
                    action=function(id, destinataire) if (type(id) ~= "table") then id = {id} end if (type(destinataire) ~= "table") then destinataire = {destinataire} end for i=1, #id do for j =1, #destinataire do fibaro:call(id[i], "sendPhotoToUser", destinataire[j]) end end end
                },
    picturetoemail   = {name="PictureToEmail", 
                    optimize = true,
                    keepValues = true,
                    action=function(id, destinataire) if (type(id) ~= "table") then id = {id} end if (type(destinataire) ~= "table") then destinataire = {destinataire} end for i=1, #id do for j =1, #destinataire do fibaro:call(id[i], "sendPhotoToEmail", destinataire[j]) end end end
                },
    open      = {name="Open", 
                    optimize = true,
                    math=true,
                    depends = {"value"},
                    control=function(id) return GEA.options.number.control(id) end,
                    getValue=function(id) return math.abs(-100+tonumber(GEA.options.value.getValue(id))) end,
                    action=function(id, value) if (not id) then id = GEA.currentMainId end if (type(id) ~= "table") then id = {id} end  if (not value) then value = 100 end for i=1, #id do GEA.options.value.action(id, value) end  end
                },
    close     = {name="Close",
                    optimize = true,
                    math=true,
                    depends = {"value"},
                    control=function(id) return GEA.options.number.control(id) end,
                    getValue=function(id) return GEA.options.value.getValue(id) end,
                    action=function(id, value) if (not id) then id = GEA.currentMainId end if (type(id) ~= "table") then id = {id} end  if (not value) then value = 100 end for i=1, #id do GEA.options.value.action(id, math.abs(-100+value)) end end
                },
    stop      = {name="Stop", 
                    optimize = true,
                    control=function(id) return GEA.options.number.control(id) end,
                    action=function(id) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i], "stop") end end
                },
    apipost    = {name="ApiPost", 
                    optimize = true,
                    getValue=function(url, data) __assert_type(data, "table") return api.post(url, data) end,
                    action=function(url, data) __assert_type(data, "table") api.post(url, data) end
                },
    apiput    = {name="ApiPost", 
                    optimize = true,
                    getValue=function(url, data) __assert_type(data, "table") return api.put(url, data) end,
                    action=function(url, data) __assert_type(data, "table") api.put(url, data) end
                },
    apiget    = {name="ApiGet", 
                    optimize = true,
                    math=true,
                    getValue=function(url) return api.get(url) end,
                    action=function(url) api.get(url) end
                },
    program   = {name="Program", 
                    optimize = true,
                    math=true,
                    getValue=function(id) return fibaro:getValue(id, "currentProgram") end, 
                    action=function(id, prog) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i], "startProgram", prog) end end
                },
    thermostatlevel   = {name="ThermostatLevel", 
                    optimize = true,
                    control=function(id) return GEA.options.number.control(id) end,
                    getValue=function(id) return fibaro:getValue(id, "value") end, --targetLevel
                    action=function(id, value) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i], "setTargetLevel", tostring(GEA.incdec(value, GEA.options.thermostatlevel.getValue(id[i])))) end end
                },
    thermostattime   = {name="ThermostatTime", 
                    optimize = true,
                    control=function(id) return GEA.options.thermostatlevel.control(id) end,
                    getValue=function(id) return fibaro:getValue(id, "timestamp") end,
                    action=function(id, value) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i], "setTime", tonumber(os.time()) + value) end end
                },                
    ask       = {name="Ask",
                    optimize = true,
                    action=function(id, message, scene) 
                      if (type(id) ~= "table") then id = {id} end
                      if (not scene) then scene = message message = GEA.getMessage() end
                      api.post('/mobile/push', {["mobileDevices"]=id,["message"]=GEA.getMessage(message),["title"]='HC2 Fibaro',["category"]='YES_NO',["data"]={["sceneId"]=scene}}) 
                    end
                },
    repe_t    = {name="Repeat", 
                    getValue=function() return true end,
                },
    notstart  = {name="NotStart", 
                    optimize = true,
                    getValue=function() return true end,
                },                
    inverse   = {name="Inverse", 
                    optimize = true,
                    getValue=function() return true end,
                },                
    maxtime   = {name="Maxtime", 
                    getValue=function(taskid) return GEA.globalvalue:match("|M_" .. taskid .. "{(%d+)}|") end,
                    action=function(taskid, number) if (number == 0) then GEA.options.stoptask.action(taskid) else GEA.globalvalue = GEA.globalvalue:gsub("|M_" .. taskid .. "{(%d+)}|", "") .. "|M_" .. taskid .. "{"..number.."}|" end end
                },
    restarttask = {name="RestartTask", 
                    getValue=function(taskid) return GEA.globalvalue:find("|R_" .. taskid.."|") end,
                    action=function(taskid) if (type(taskid) ~= "table") then taskid = {taskid} end for i=1, #taskid do if (taskid[i]=="self") then taskid[i]=GEA.currentEntry.id end GEA.globalvalue = GEA.globalvalue:gsub("|R_" .. taskid[i].."|", ""):gsub("|M_" .. taskid[i] .. "{(%d+)}|", ""):gsub("|S_" .. taskid[i].."|", "") .. "|R_" .. taskid[i].."|" end end
                },
    stoptask  = {name="StopTask", 
                    getValue=function(taskid) return GEA.globalvalue:find("|S_" .. taskid) end,
                    action=function(taskid) if (type(taskid) ~= "table") then taskid = {taskid} end for i=1, #taskid do if (taskid[i]=="self") then taskid[i]=GEA.currentEntry.id end GEA.globalvalue = GEA.globalvalue:gsub("|S_" .. taskid[i].."|", ""):gsub("|M_" .. taskid[i] .. "{(%d+)}|", ""):gsub("|R_" .. taskid[i].."|", "") .. "|S_" .. taskid[i].."|" end end
                },
    depend    = {name="Depend", 
                    optimize = true,
                    control=function(entryId) return type(GEA.findEntry(entryId)) ~= "nil" end,
                    getValue=function(entryId) return not GEA.currentEntry.isWaiting[entryId] end,
                },
    test      = {name="Test", 
                    optimize = true,
                    getValue=function(name1, name2, name3) print("test getValue() ") return name1 .. name2 .. name3, name1 end,
                    action=function(name) print("test action() " .. GEA.getMessage(name))end
                },
    sleep      = {name="Sleep", 
                    control=function(duree, option) return type(duree)=="number" and type(GEA.getOption(option, true)~="nil") end,
                    keepValues = true,
                    action=function(duree, option) local o = GEA.getOption(option) if (duree and o) then setTimeout(function() GEA.currentAction.name = o.name o.action(true) end, duree*1000) end end
                },
    variablecache = {name="VariableCache",
                    optimize = true,
                    math=true,
                    control=function() return GEA.currentEntry.duration >= 0, GEA.trad.varCacheInstant end,
                    getValue=function(var) return GEA.variables[var] end,
                    action=function(var, value) GEA.variables[var] = GEA.getMessage(GEA.incdec(value, GEA.variables[var])) end,
                },
    enablescenario = {name="EnableScenario",
                    optimize = true,
                    control=function(id) return GEA.options.scenario.control(id) end,
                    getValue=function(id) return fibaro:isSceneEnabled(id) end, 
                    action=function(id) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:setSceneEnabled(id[i], true) end end
                },
    disablescenario = {name="DisableScenario",
                    optimize = true,
                    control=function(id) return GEA.options.scenario.control(id) end,
                    getValue=function(id) return not fibaro:isSceneEnabled(id) end, 
                    action=function(id) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:setSceneEnabled(id[i], false) end end
                },      
    setrunconfigscenario = {name="SetrunConfigScenario", 
                    optimize = true,
                    control=function(id) return GEA.options.scenario.control(id) end,
                    getValue=function(id) return fibaro:getSceneRunConfig(id) end,
                    action=function(id, runconfig) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:setSceneRunConfig(id[i], runconfig) end end
                },          
    countscenes = {name="CountScenes",
                    optimize = true,
                    control=function(id) return GEA.options.scenario.control(id) end,
                    getValue=function(id) return fibaro:countScenes(id) end
                },                    
    popup       = {name="Popup",
                    optimize = true,
                    action=function(typepopup, titlepopup, msgpopup, sceneID) 
                      local content = tools.tostring(GEA.trad.popupinfo)
                      local scene = sceneID or 0 
                      if typepopup=="Success" then content = tools.tostring(GEA.trad.popupsuccess) elseif typepopup=="Warning" then content = tools.tostring(GEA.trad.popupwarning) elseif typepopup=="Critical" then content = tools.tostring(GEA.trad.popupcritical) end 
                      local boutons = {{caption=GEA.trad.quit,sceneId=0}}
                      if (scene ~= 0) then
                        table.insert(boutons, 1, {caption=GEA.trad.execute, sceneId=scene})
                      end
                      HomeCenter.PopupService.publish({title="GEA - "..titlepopup,subtitle = os.date(GEA.trad.date_format .. " - " .. GEA.trad.hour_format),contentTitle = tools.tostring(content),contentBody=GEA.getMessage(msgpopup),img="..img/topDashboard/info.png",type=tools.tostring(typepopup),buttons=boutons})
                    end
                },                
    debugmessage = {name="DebugMessage",
                    optimize = true,
                    control=function(id) return GEA.options.number.control(id) end,
                    action=function(id, elementid, msgdebug, typedebug) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i], "addDebugMessage", elementid, GEA.getMessage(msgdebug), typedebug or debug) end end
                },
    -- {"Filters", "Lights|Blinds", "turnOff|Close|Open"}
    filters     = {name="Filters",
                    optimize = true,
                    --control=function(id) return GEA.options.number.control(id) end,
                    action=function(typefilter,choicefilter) if typefilter:lower() == "lights" then for _,v in ipairs(fibaro:getDevicesId({properties = {isLight = true}})) do fibaro:call(v, choicefilter) end elseif typefilter:lower() =="blinds" then for _,v in ipairs(fibaro:getDevicesId({type = tools.tostring("com.fibaro.FGRM222")})) do fibaro:call(v, choicefilter) end end end
                },
    rgb         = {name="RGB",
                    optimize = true,
                    control=function(id) return GEA.options.number.control(id) end,
                    action=function(id, r, g, b, w) if (type(id) ~= "table") then id = {id} end for i=1, #id do fibaro:call(id[i], "setColor", r or 0, g or 0, b or 0, w or 0) end end
                },
    centralsceneevent = {name="CentralSceneEvent",
                    optimize = true,
                    control=function(id, key, attribute) 
                      if (GEA.currentEntry.duration > -1) then return false, GEA.trad.central_instant end
                      return GEA.options.number.control(id) and type(key)~="nil" and type(attribute)~="nil", GEA.trad.central_missing 
                    end,
                    getValue=function(id, key, attribute) return (GEA.source.event.data.deviceId==tonumber(id) and tostring(GEA.source.event.data.keyId)==tostring(key) and tostring(GEA.source.event.data.keyAttribute)==tostring(attribute)) end
                },
    frequency = {name="Frequency",
                    optimize = true,
                    getValue=function(freqday, freqnumber) return GEA.getFrequency(freqday,freqnumber) end
                },
    reboothc2 = {name="RebootHC2",
                    optimize = true,
                    action=function() HomeCenter.SystemService.reboot() end
                },
    shutdownhc2 = {name="ShutdownHC2",
                    optimize = true,
                    action=function() HomeCenter.SystemService.shutdown() end
                },                
    alarm     = {name = "Alarm", 
                    optimize = true,
                    control=function(id) return GEA.options.number.control(id) end,
                    getValue=function(id)                       
                      if (os.date("%H:%M", GEA.runAt) == fibaro:getValue(id, "ui.lblAlarme.value")) then
                        local days = fibaro:getValue(id, "ui.lblJours.value")
                        days = days:lower()
                        selected = tools.split(days, " ")
                        for i = 1, #selected do
                          for j = 1, #GEA.trad.week_short do
                            if (GEA.trad.week_short[j] == selected[i]) then 
                              if (GEA.traduction.en.week[j]:lower() == os.date("%A"):lower()) then
                                return true
                              end
                            end
                          end
                        end
                      end
                      return false
                    end,
                },
    info      = {name = "Info", 
                  optimize = true,
                  math = true,
                  control=function(property) if (type(api.get("/settings/info")[property])=="nil") then return false, string.format(GEA.trad.property_missing, property) else return true end end,
                  getValue=function(property) return api.get("/settings/info")[property] end
                },
    pluginscenario = {name="PluginScenario",
                  control=function() if ((GEA.currentAction and GEA.plugins[GEA.currentAction.name]) or (GEA.currentCondition and GEA.plugins[GEA.currentCondition.name])) then return true else return false, GEA.trad.plugin_not_found end end,
                  getValue=function(...) 
                    local line = GEA.currentEntry.id.."@"..GEA.currentCondition.option_id
                    local args = {...}
                    local params = {{geaid = __fibaroSceneId}, {gealine = line}, {geamode = "value"}}
                    for i, v in ipairs(args) do table.insert(params, {["param"..i] = GEA.getMessage(v)}) end
                    local id = GEA.plugins[GEA.currentCondition.name]
                    fibaro:startScene(id, params)
                    return GEA.waitWithTimeout(function() 
                        local vgplugins = GEA.getGlobalValue(GEA.pluginsvariables)
                        if (vgplugins and vgplugins ~= "") then GEA.plugins = json.decode(vgplugins) end
                        if (GEA.plugins.retour and GEA.plugins.retour[line]) then return true, GEA.plugins.retour[line] end 
                    end, GEA.pluginretry, GEA.pluginmax)
                  end,
                  action=function(...)
                    local args = {...}
                    local params = {{geaid = __fibaroSceneId}, {gealine = GEA.currentEntry.id.."@"..GEA.currentAction.option_id}, {geamode = "action"}}
                    for i, v in ipairs(args) do table.insert(params, {["param"..i] = GEA.getMessage(v)}) end
                    local id = GEA.plugins[GEA.currentAction.name]
                    fibaro:startScene(id, params)
                  end
    			},
    doorlock     = {name="DoorLock", 
                    optimize = true,
                    depends = {"value"},
                    control=function(id) return GEA.options.number.control(id) end, 
                    getValue=function(id) GEA.options.value.getValue(id) end, 
                    action=function(id, value) if (not id) then id = GEA.currentMainId end if (type(id) ~= "table") then id = {id} end for i=1, #id do if value == tools.tostring("secure") then fibaro:call(id[i],"secure") else fibaro:call(id[i],"unsecure") end end end
                },  
    o_r     = {name="Or", 
                    optimize = true,
                    keepValues = true,
                    control=function(...) local args = {...} for i = 1, #args do if (type(GEA.getOption(args[i]))=="nil") then return false end end return true end,
                    getValue=function(...) local args = {...} for i = 1, #args do if (GEA.getOption(args[i]).check()) then return true end end return false end, 
                    getName=function(...) 
                      local args = {...} 
                      local name = ""
                      for i = 1, #args do if (GEA.getOption(args[i]).check()) then name = name .. " " .. GEA.getOption(args[i]).getModuleName() end end 
                      return tools.trim(name)
                    end, 
                }, 
    xor     = {name="XOr", 
                    optimize = true,
                    keepValues = true,
                    control=function(...) local args = {...} for i = 1, #args do if (type(GEA.getOption(args[i]))=="nil") then return false end end return true end,
                    getValue=function(...) local args = {...} local nb = 0 for i = 1, #args do if (GEA.getOption(args[i]).check()) then nb = nb+1 end end return nb == 1 end, 
                    getName=function(...) 
                      local args = {...} 
                      local name = ""
                      for i = 1, #args do if (GEA.getOption(args[i]).check()) then name = name .. " " .. GEA.getOption(args[i]).getModuleName() end end 
                      return tools.trim(name)
                    end, 
                },
    hue     = {name="Hue", 
                    optimize = true,
                    math = true,
                    control=function(id) return GEA.options.number.control(id) end, 
                    getValue=function(id, property) if (not id) then id = GEA.currentMainId end return fibaro:getValue(id, property) end, 
                    getHubParam=function(id)
                      local device = api.get("/devices/"..id)
                      local lightid = device.properties.lightId
                      if (device.parentId > 0) then device = api.get("/devices/"..device.parentId) end
                      return lightid, device.properties.ip, device.properties.userName
                    end,
                    action=function(id, property, value) if (type(id) ~= "table") then id = {id} end for i=1, #id do 
                      local lightid, ip, username = GEA.options.hue.getHubParam(id[i])
                      local datas = "{\""..property.."\":"..tools.iif(type(value)=="boolean", tostring(value), value).."}"
                      local http = net.HTTPClient() 
                      http:request("http://"..ip.."/api/"..username.."/lights/"..lightid.."/state",  { options =  { method =  "PUT", data = datas }, success = function(response) end, error  = function(err) tools.error(err) end })
                    end end
                },                
      transpose = {name = "Transpose", 
                  getValue=function(table1, table2, value) return GEA.translate(value, table1, table2) end,
                  action  =function(table1, table2, value) return GEA.translate(value, table1, table2) end
                },
      roomlights = {name="RoomLights",
                    optimize = true,
                      action = function(roomName, action)
                        local rooms = api.get("/rooms")
                        for _, room in pairs(rooms) do
                          if (room.name:lower() == roomName:lower()) then
                            for _, device in pairs(api.get("/devices?type=com.fibaro.philipsHueLight&roomID="..room.id)) do fibaro:call(device.id, action) end              
                            for _, device in pairs(api.get("/devices?property=[isLight,true]&roomID="..room.id)) do fibaro:call(device.id, action) end
                          end
                        end
                      end
                },
      sectionlights = {name="SectionLights",
                      optimize = true,
                      depends = {"roomlights"},
                      action = function(sectionName, action)
                          local sections = api.get("/sections")
                          for _, section in pairs(sections) do
                            if (section.name:lower() == sectionName:lower()) then
                              for _, room in pairs(api.get("/rooms")) do
                                if (room.sectionID == section.id) then GEA.options.roomlights.action(room.name, action) end
                              end
                            end
                          end        
                      end                        
                },
        onoff = { name = "On Off",
                  optimize = true,
                  depends = {"transpose"},
                  getValue = function(id) return GEA.getOption({"Transpose", {true, false}, {"ON", "OFF"}, {"TurnOn", id}}).getValue() end,
                  action = function(id) GEA.getOption({"Switch", id}).action() end,
                },
        result  = { name = "Result", math = true, getValue=function(position) if (not position) then position = 1 end return GEA.currentEntry.conditions[position].lastvalue end },
        name    = { name = "Name", getValue=function(position) if (not position) then position = 1 end return GEA.currentEntry.conditions[position].getModuleName() end },
        room    = { name = "Room", getValue=function(position) if (not position) then position = 1 end return GEA.currentEntry.conditions[position].getModuleRoom() end },
        runs    = { name = "Runs", math = true, getValue=function() return GEA.nbRun end },
        seconds = { name = "Seconds", math = true, getValue=function() return GEA.checkEvery end },
        duration= { name = "Duration", math = true, getValue=function() local d, _ = GEA.getDureeInString(os.difftime(GEA.runAt, GEA.currentEntry.firstvalid)) return d end },
        durationfull= { name = "DurationFull", getValue=function() local _, d = GEA.getDureeInString(os.difftime(GEA.runAt, GEA.currentEntry.firstvalid)) return d end },
        sunrise = { name = "Sunrise", getValue=function() return fibaro:getValue(1, "sunriseHour"):gsub(":", " " .. GEA.trad.hour .. " ") end },
        sunset  = { name = "Sunset", getValue=function() return fibaro:getValue(1, "sunsetHour"):gsub(":", " " .. GEA.trad.hour .. " ") end },
        date    = { name = "Date", getValue=function() return os.date(GEA.trad.date_format, GEA.runAt) end },
        trigger = { name = "Trigger", 
                    getValue=function() 
                      if (GEA.source.type == "autostart") then
                        return "autostart" 
                      elseif (GEA.source.type == "global") then 
                        return "Global["..GEA.source.name.."]"
                      elseif (GEA.source.type == "property") then 
                        return "Property[" ..GEA.source.deviceID .."]"
                      elseif (GEA.source.type == "event") then
                        return "Event["..GEA.source.event.data.deviceId.."]"
                      end
                      return "other"
                    end 
                  },
        datefull= { name = "DateFull", 
                    getValue=function() 
                      local jour = tonumber(os.date("%w", GEA.runAt))
                      if (jour == 0) then jour = 6 else jour = jour-1 end  
                      return GEA.trad.week[jour+1] .. " " .. os.date("%d", GEA.runAt).. " " .. GEA.trad.months[tonumber(os.date("%m", GEA.runAt))].. " " .. os.date("%Y", GEA.runAt) 
                    end 
                  },
        translate= { name = "Translate",
                    getValue=function(key, word) 
                      word = GEA.getMessage(word)
                      return GEA.translatetrad(tools.trim(key), tools.trim(word))
                    end 
                  },
        sonosmp3 = {name = "Sonos MP3",
                    action = function(vd_id, button_id, filepath, volume)
                      if (not volume) then volume = 30 end
                      local _f = fibaro
                      local _x ={root="x_sonos_object",load=function(b)local c=_f:getGlobalValue(b.root)if string.len(c)>0 then local d=json.decode(c)if d and type(d)=="table"then return d else _f:debug("Unable to process data, check variable")end else _f:debug("No data found!")end end,set=function(b,e,d)local f=b:load()if f[e]then for g,h in pairs(d)do f[e][g]=h end else f[e]=d end;_f:setGlobal(b.root,json.encode(f))end,get=function(b,e)local f=b:load()if f and type(f)=="table"then for g,h in pairs(f)do if tostring(g)==tostring(e or"")then return h end end end;return nil end}
                      _x:set(tostring(vd_id), { stream = {stream=filepath, source="local", duration="auto", volume=volume} })
                      _f:call(vd_id, "pressButton", button_id)
                    end,
                  },
        sonostts = {name = "Sonos TTS",
                    action = function(vd_id, button_id, message, volume)
                      local message = GEA.getMessage(message)
                      if (not volume) then volume = 30 end
                      local _f = fibaro
                      local _x ={root="x_sonos_object",load=function(b)local c=_f:getGlobalValue(b.root)if string.len(c)>0 then local d=json.decode(c)if d and type(d)=="table"then return d else _f:debug("Unable to process data, check variable")end else _f:debug("No data found!")end end,set=function(b,e,d)local f=b:load()if f[e]then for g,h in pairs(d)do f[e][g]=h end else f[e]=d end;_f:setGlobal(b.root,json.encode(f))end,get=function(b,e)local f=b:load()if f and type(f)=="table"then for g,h in pairs(f)do if tostring(g)==tostring(e or"")then return h end end end;return nil end}
                      _x:set(tostring(vd_id), { tts = {message=message, duration='auto', language=GEA.trad.locale, volume=volume} })
                      _f:call(vd_id, "pressButton", button_id)
                    end,
                  },
        jsondecodefromglobal  = {name ="JSON Decode from Global", optimize = true, math = true, getValue=function(vg, property) return GEA.decode(GEA.getGlobalValue(vg), property) end },
        jsondecodefromlabel  = {name ="JSON Decode from Label", optimize = true, math = true, getValue=function(id, label, property) return GEA.decode(fibaro:getValue(id, "ui."..label..".value"), property) end },
        tempext   = {name="Temp. Ext.", math=true, getValue=function() return fibaro:getValue(3, "Temperature") end},
        tempexttts= {name="Temp. Ext. TTS", getValue=function() 
                      local value = fibaro:getValue(3, "Temperature") 
                      if (value:find("%.")) then return value:gsub("%.", " degrés ") end
                      return value .. " degrés"
                    end
                  },
        monthly   = {name = "monthly",
                    getValue = function(day)
                        day = day or ""
                        day = tostring(day):lower()
                        if (day == "" or day == "begin" or day == "first") then
                          day = 1;
                        elseif (day == "end" or day == "last" or day == "31") then
                          local now = os.date("*t", GEA.runAt)
                          local tomorrow = os.time{year=now.year, month=now.month, day=now.day+1}
                          return now.month ~= os.date("*t", tomorrow).month
                        end
                        if (tools.isNumber(day)) then
                          return tonumber(os.date("%d", GEA.runAt)) == tonumber(day)
                        end
                        day = GEA.translate(day, GEA.trad.week, GEA.traduction.en.week)
                        local n,d = os.date("%d %A", GEA.runAt):match("(%d+).?(%w+)")
                        return ( tonumber(n) < 8 and d:lower() == day )
                      end
                  }, 
        slider    = {name="Slider",
                    math=true,
                    optimize=true,
                    depends = {"label"},
                    control=function(id) return GEA.options.number.control(id) end,
                    getValue=function(id, property) return GEA.options.label.getValue(id, property) end, 
                    action=function(id, property, value) 
                      if (type(id) ~= "table") then id = {id} end 
                      for i=1, #id do 
                        if (not tools.isNumber(property)) then 
                            property = GEA.findNoById(id[i], property)
                        end
                        fibaro:call(id[i], "setSlider", property, GEA.incdec(GEA.getMessage(value), GEA.options.label.getValue(id[i], property))) 
                      end 
                    end
                  },
        polling   = {name = "Polling", 
                    optimize = true, 
                    control = function(id) return GEA.options.number.control(id) end, 
                    action = function(id) if (type(id) ~= "table") then id = {id} end for i=1, #id do api.post("/devices/"..id[i].."/action/poll") end end,
                  },
		ledbrightness={name="LedBrightness", 
            		optimize = true,
            		getValue=function()  return fibaro:getLedBrightness() end,
            		action=function(level) fibaro:setLedBrightness(tonumber(level)) end
				  },
    	devicestate={name="DeviceState", 
            		optimize = true,
            		getValue=function(id) 
                  local device = api.get("/devices/"..id)
                  if (device.parentId > 1) then device = api.get("/devices/"..device.parentId) end
                  return device.properties.deviceState 
                end,

            	  },
		neighborlist={name="NeighborList",
        		    optimize=true,
            		control=function(id) return GEA.options.number.control(id) end, 
                ids="",
            		getValue=function(id) 
                  local device = api.get("/devices/"..id)
                  if (device.parentId > 1) then device = api.get("/devices/"..device.parentId) end
                  GEA.options.neighborlist.ids = device.properties.neighborList
                  return json.encode(device.properties.neighborList)
                end,
                getName=function() return GEA.getName(GEA.options.neighborlist.ids, GEA.showRoomNames) end
				  },
		lastworkingroute={name="LastWorkingRoute", 
            		optimize=true,
            		control=function(id) return GEA.options.number.control(id) end,
                ids="",
            		getValue=function(id) 
                  local device = api.get("/devices/"..id)
                  if (device.parentId > 1) then device = api.get("/devices/"..device.parentId) end
                  GEA.options.lastworkingroute.ids = device.properties.lastWorkingRoute
                  return json.encode(device.properties.lastWorkingRoute)
                end,
                getName=function() return GEA.getName(GEA.options.lastworkingroute.ids, GEA.showRoomNames) end
              },    
    checkvg   = {name="CheckVG",
                getValue=function(name)
                  if (not GEA.vglist) then 
                    GEA.vglist = {}
                    for _, vg in pairs(api.get("/globalVariables")) do
                      GEA.vglist[vg.name] = true
                    end
                  end
                  local result = GEA.vglist[name] or false
                  return result
                end,
              },
    checklabel   = {name="CheckLabel",
                getValue=function(id, name)
                  if (not GEA.vdlist) then 
                    GEA.vdlist = {}
                    local vds = api.get("/devices?type=virtual_device&enabled=true")
                    for _, vd in pairs(vds) do
                      GEA.vdlist[vd.id] = {}
                      for _, row in pairs(vd.properties.rows) do
                          if (row.type == "label") then
                            for _, element in pairs(row.elements) do
                              GEA.vdlist[vd.id][element.name] = true
                            end
                          end
                      end
                    end
                  end
                  local result = GEA.vdlist[id][name:gsub("ui.", ""):gsub(".value", "")] or false
                  return result
                end,
              },
  }
  
  GEA.copyOption = function(optionName, newName) 
    local copy = {} 
    option = GEA.options[optionName]
    copy.name = newName or option.name 
    if (option.math) then copy.math = option.math end 
    if (option.optimize) then copy.optimize = option.optimize end  
    if (option.keepValues) then copy.keepValues = option.keepValues end  
    if (option.control) then copy.control = option.control end 
    if (option.getValue) then copy.getValue = option.getValue end 
    if (option.action) then copy.action = option.action end
    if (option.depends) then copy.depends = option.depends else copy.depends = {} end
    table.insert(copy.depends, optionName)
    return copy
  end
  
  -- Alias - GEA.copyOption(option, <nouveau nom>)
  GEA.options.vd = GEA.copyOption("virtualdevice", "VD")
  GEA.options.scene = GEA.copyOption("scenario")
  GEA.options.start = GEA.copyOption("scenario")
  GEA.options.startscene = GEA.copyOption("scenario")
  GEA.options.killscene = GEA.copyOption("killscenario")
  GEA.options.enablescene = GEA.copyOption("enablescenario")
  GEA.options.disablescene = GEA.copyOption("disablescenario")
  GEA.options.wakeup = GEA.copyOption("dead")
  GEA.options.notdst = GEA.copyOption("nodst", "Not DST")
  GEA.options.photo = GEA.copyOption("picture", "Photo")
  GEA.options.phototomail = GEA.copyOption("picturetoemail", "PhotoToMail")
  GEA.options.thermostat = GEA.copyOption("thermostatlevel")
  GEA.options.startprogram = GEA.copyOption("program", "startProgram")
  GEA.options.push = GEA.copyOption("portable", "Push")
  GEA.options.power = GEA.copyOption("sensor", "Power")
  GEA.options.pressbutton = GEA.copyOption("virtualdevice", "PressButton")
  GEA.options.slide = GEA.copyOption("value2", "Slide")
  GEA.options.orientation = GEA.copyOption("value2", "Orientation")
  GEA.options.issceneenabled = GEA.copyOption("enablescenario", "isSceneEnabled")
  GEA.options.isscenedisabled = GEA.copyOption("disablescenario", "isSceneDisabled")
  GEA.options.runconfigscene = GEA.copyOption("setrunconfigscenario", "RunConfigScene")
  GEA.options.dayevenodd = GEA.copyOption("frequency", "DayEvenOdd")

  -- ----------------------------------------------------------
  -- Proposition pepite GEA.getFrequency pour Frequency 
  -- (code qui vient de toi deja)
  -- ----------------------------------------------------------
  GEA.getFrequency = function(day, number) --day : 1-31 wday :1-7 (1 :sunday)
		local t = os.date("*t", GEA.runAt)
		local semainepaire = os.date("%W", GEA.runAt) %2 == 0
		if (os.date("%A", GEA.runAt):lower() == day:lower()) then
			return (number == 2 and semainepaire) or t["day"] < 8
		end
  end
  -- ----------------------------------------------------------
  -- fin proposition pepite
  -- ----------------------------------------------------------
  
  GEA.getGlobalValue = function(name)
    if (GEA.options.checkvg.getValue(name)) then
      return fibaro:getGlobalValue(name)
    end
    return nil
  end
  
  -- ----------------------------------------------------------
  -- Met et retourne le nom d'un module en cache
  -- ----------------------------------------------------------
  GEA.getNameInCache = function(id)
    if (type(id) == "number") then 
      id = tonumber(id) 
      if (not GEA.moduleNames[id]) then 
        GEA.moduleNames[id] = fibaro:getName(id)
      end 
      return GEA.moduleNames[id] or GEA.trad.name_is_missing
    else 
      return "" 
    end
  end
  
  -- ----------------------------------------------------------
  -- Met et retourne le nom d'une pièce d'un module en cache
  -- ----------------------------------------------------------
  GEA.getRoomInCache = function(id)
    if (type(id) == "number") then 
      id = tonumber(id) 
      if (not GEA.moduleRooms[id]) then 
        local idRoom = api.get("/devices/"..id).roomID
        if (idRoom and idRoom > 0) then 
          GEA.moduleRooms[id] = fibaro:getRoomName(idRoom)
        end
      end
      return GEA.moduleRooms[id] or GEA.trad.room_is_missing
    else 
      return "" 
    end
  end
  
  -- ----------------------------------------------------------
  -- Retourne le nom d'un module (pièce optionelle)
  -- ----------------------------------------------------------
  GEA.getName = function(id, withRoom)
    if (type(id) ~= "table") then id = {id} end
    local names = ""
    for i=1, #id do 
      if (names ~= "") then names = names .. ", " end
      if (withRoom) then
        names = names .. GEA.getNameInCache(id[i]) .. " (" .. GEA.getRoomInCache(id[i]) .. ")"
      else 
        names = names .. GEA.getNameInCache(id[i])
      end
    end
    return names
  end
  
  -- ----------------------------------------------------------
  -- Vérification des batteries
  -- ----------------------------------------------------------
  GEA.batteries = function(value, concatroom) 
    local res = false 
    local names, rooms = "", ""
    for _, v in ipairs(fibaro:getDevicesId({interface="battery", visible=true})) do 
      local bat = fibaro:getValue(v, 'batteryLevel')
      local low = (tonumber(bat) < tonumber(value))
      if (low) then
        if (names ~= "") then names = names .. ", " end
        names = names .. "["..v.."] " .. GEA.getName(v, concatroom)
        if (rooms ~= "") then rooms = rooms .. ", " end
        rooms = rooms .. GEA.getRoomInCache(v) 
      end
      res = res or low
    end
    return res, names, rooms
  end
 
  -- ----------------------------------------------------------
  -- Recherche et retourne une option (condition ou action) 
  -- encapsulée
  -- ----------------------------------------------------------
  GEA.options_id = 0
  GEA.getOption = function(object, silent)
    local sname = ""
    local tname = type(object)
    local originalName = object
    if (tname == "table") then 
      sname = string.lower(object[1]):gsub("!", ""):gsub("+", ""):gsub("-", ""):gsub("%(", ""):gsub("%)", "") 
      originalName = object[1]
    else
      sname = string.lower(tostring(object)):gsub("!", ""):gsub("+", ""):gsub("-", ""):gsub("%(", ""):gsub("%)", "") 
    end
    if (sname~="function") then
      local jo = json.encode(object)
      if (GEA.declared[jo]) then return GEA.declared[jo] end
    end
    local option = nil
    if (tonumber(sname)) then tname = "number" object = tonumber(sname) end
    if (tname=="number" or tname=="boolean") then 
        option = GEA.options[tname] 
        option.name = object
        originalName = tostring(originalName)
        object = {object}
        sname = tname
    else
        if (sname == "function") then sname = "fonction" end
        if (sname == "repeat") then sname = "repe_t" end
        if (sname == "or") then sname = "o_r" end
        option = GEA.options[sname]
    end
    if (option) then
      GEA.options_id = GEA.options_id + 1
      if (GEA.nbRun < 1) then table.insert(GEA.usedoptions, sname) end
      local o = GEA.encapsule(option, object, originalName:find("!"), originalName:find("+"), originalName:find("-"), GEA.options_id, originalName:find("%(") and originalName:find("%)"))
      if (jo) then GEA.declared[jo] = o end
      return o
    end
    if (not silent) then
      tools.error(string.format(GEA.trad.option_missing, __convertToString(originalName)) )
      fibaro:abort()
    end
  end

  -- ----------------------------------------------------------
  -- Encapsulation d'une option (condition ou action)
  -- ----------------------------------------------------------
  GEA.encapsule = function(option, args, inverse, plus, moins, option_id, not_immediat)
    local copy = {}
    copy.lastRunAt = 0
    copy.option_id = option_id
    copy.name = option.name
    copy.args = {table.unpack(args)}
    copy.inverse = inverse
    copy.not_immediat = not_immediat
    if (copy.args and #copy.args>0) then
       table.remove(copy.args, 1)
    end
    copy.getLog = function() 
          local params = "]"
          if (#copy.args>0) then 
            if (copy.name:lower() == "function") then
                params = ", {...}" .. params
            else
              params = ", " .. __convertToString(copy.args) .. params
            end
          end
          return "["..tostring(copy.name) .. tools.iif(copy.inverse, "!", "") .. tools.iif(plus, "+", "") .. tools.iif(moins, "-", "") .. params
      end
    copy.lastvalue = ""
    copy.hasValue = type(option.getValue)=="function" or false
    copy.hasAction = type(option.action)=="function" or false
    copy.hasControl = type(option.control)=="function" or false
    copy.getModuleName = function() if (option.getName) then return option.getName(copy.searchValues()) end local id = copy.getId() return GEA.getNameInCache(id) end
    copy.getModuleRoom = function() if (option.getRoom) then return option.getRoom(copy.searchValues()) end local id = copy.getId() return GEA.getRoomInCache(id) end
    copy.getId = function()  
                    if (copy.not_immediat) then return "" end
                    if (type(copy.name)=="boolean") then 
                      return copy.name
                    elseif (type(copy.name)=="number") then 
                      return copy.name
                    elseif (type(copy.name)=="function") then 
                      return nil
                    elseif (GEA.plugins[copy.name]) then 
                      return GEA.currentEntry.id .. "@" .. copy.option_id
                    else 
                      if (copy.name == "Or" or copy.name == "XOr") then
                        local ids = {}
                        for i=1, #copy.args do table.insert(ids, GEA.getOption(copy.args[i]).getId()) end
                        return ids
                      end
                      return copy.args[1]
                    end
      end
    copy.searchValues = function() 
                        if (type(copy.name)=="boolean") then 
                          return copy.name
                        elseif (type(copy.name)=="number") then 
                          return copy.name
                        else 
                          local results = {}
                          for i = 1, #args do
                            if (type(args[i]) == "table" and not option.keepValues and i > 2) then 
                              local o = GEA.getOption(args[i], true)
                              if (o) then table.insert(results, o.getValue()) else table.insert(results, args[i]) end
                            else
                              table.insert(results, args[i])
                            end
                          end
                          if (results and #results>0) then table.remove(results, 1) end
                          return table.unpack(results)
                        end
                      end
    copy.control = function() if (GEA.control and copy.hasControl) then return option.control(copy.searchValues()) else return true end end
    copy.action = function() if (copy.hasAction) then copy.lastRunAt=0; return option.action(copy.searchValues()) else tools.warning(string.format(GEA.trad.not_an_action, copy.name)) return nil end end
    copy.getValue = function() 
                        if (not copy.hasValue) then return end
                        if (copy.lastRunAt == GEA.runAt and copy.lastvalue and (not GEA.forceRefreshValues)) then 
                          return copy.lastvalue
                        end
                        if (type(args[2])=="function") then 
                          copy.lastvalue = args[2]() 
                        elseif (type(copy.name)=="boolean") then 
                          copy.lastvalue = GEA.options.boolean.getValue(copy.name)
                        elseif (type(copy.name)=="number") then 
                          copy.lastvalue = GEA.options.number.getValue(copy.name) 
                        else 
                          copy.lastvalue = option.getValue(copy.searchValues()) 
                        end 
                        copy.lastRunAt = GEA.runAt
                        return copy.lastvalue
                    end
    copy.check = function()
                        local id, property, value, value2, value3, value4 = copy.searchValues()
                        if (not copy.hasValue) then return true end
                        if (not property) then property = id end
                        if (not value) then value = property end
                        if (not value2) then value2 = value end
                        if (not value3) then value3 = value2 end
                        if (not value4) then value4 = value3 end
                        local result = copy.getValue()
                        if (type(copy.name)=="number") then 
                          result = (result > 0)
                        end
                        local forceInverse = false
                        if (GEA.currentEntry and GEA.currentEntry.inverse[GEA.currentEntry.id.."-"..copy.option_id]) then forceInverse = true end
                        if (copy.inverse or forceInverse) then
                          if (type(value4)=="function") then local r, v = value4() return not r, v end
                          if (type(result)=="boolean") then return not result, result end
                          return not GEA.compareString(result, value4), result
                        else
                          if (type(result)=="boolean") then return result, result end
                          if (tools.isNil(option.math) and (plus or moins)) then
                            tools.error(string.format(GEA.trad.not_math_op, copy.name))
                            fibaro:abort()
                          end
                          if (plus or moins) then
                            local num1 = tonumber(string.match(value4, "[0-9.]+"))
                            local num2 = tonumber(string.match(result, "[0-9.]+"))
                            if (plus) then
                              return num2 > num1, result
                            else
                              return num2 < num1, result
                            end
                          end
                          if (type(value4)=="function") then return value4() end
                          return GEA.compareString(result, value4), result
                        end
                      end
    return copy
  end
  
  -- ----------------------------------------------------------
  -- Compare 2 chaînes de caractères (autorise les regex)
  -- ----------------------------------------------------------
  GEA.compareString = function(s1, s2)
    s1 = GEA.replaceChar(tostring(s1):lower())
    s2 = GEA.replaceChar(tostring(s2):lower())
    if (s2:find("#r#")) then
      s2 = s2:gsub("#r#", "")
      local res = false
      for _, v in pairs(tools.split(s2, "|")) do
        res = res or tostring(s1):match(tools.trim(v))
      end
      return res
    end
    return (tostring(s1) == tostring(s2))
  end
  
  -- ----------------------------------------------------------
  -- Remplacement des caractères spéciaux
  -- ----------------------------------------------------------
  GEA.replaceChar=function(s)
    return s:gsub("Ã ", "à"):gsub("Ã©", "é"):gsub("Ã¨", "è"):gsub("Ã®", "î"):gsub("Ã´", "ô"):gsub("Ã»", "û"):gsub("Ã¹", "ù"):gsub("Ãª", "ê"):gsub("Ã¢","â"):gsub(" ' ", "'")
  end 
  
  -- ----------------------------------------------------------
  -- Retourne l'id de l'élément selon son label
  -- ---------------------------------------------------------- 
  GEA.findNoById = function(deviceId, name)
    local device = api.get("/devices/" .. deviceId)
    for _, v in ipairs(device.properties.rows) do
      for _, w in ipairs(v.elements) do 
        if (w.name) then
          if (GEA.compareString(w.name, name)) then
            return w.id
          end
        end
      end
    end
    return 0
  end
  
  -- ----------------------------------------------------------
  -- Trie un tableau selon sa propriété
  -- ----------------------------------------------------------  
  GEA.table_sort = function(t, property)
    local new1, new2 = {}, {}
    for k,v in pairs(t) do table.insert(new1, { key=k, val=v } ) end
    table.sort(new1, function (a,b) return (a.val[property] < b.val[property]) end)  
    for _,v in pairs(new1) do table.insert(new2, v.val) end
    return new2    
  end
  
  -- ----------------------------------------------------------
  -- Retourne year, month, days selon un format spécifique
  -- ----------------------------------------------------------    
  GEA.getDateParts = function(date_str, date_format)
    local d,m,y = date_format:find("dd"), date_format:find("mm"), date_format:find("yy")    
    local arr = { { pos=y, b="yy" }, { pos=m, b="mm" } , { pos=d, b="dd" }  }
    arr = GEA.table_sort(arr, "pos")
    date_format = date_format:gsub("yyyy","(%%d+)"):gsub("yy","(%%d+)"):gsub("mm","(%%d+)"):gsub("dd","(%%d+)"):gsub(" ","%%s")
    if (date_str and date_str~="") then     
        _, _, arr[1].c, arr[2].c, arr[3].c = string.find(string.lower(date_str), date_format)
    else
        return nil, nil, nil
    end
    arr = GEA.table_sort(arr, "b")
    return tonumber(arr[3].c), tonumber(arr[2].c), tonumber(arr[1].c)
  end
  
  -- ----------------------------------------------------------
  -- Gestion des inc+ et dec-
  -- ----------------------------------------------------------
  GEA.incdec = function(value, oldvalue)
    if (type(value) ~= "string") then return value end
    if (value:find("inc%+") or value:find("dec%-")) then
      local num = value:match("%d+") or 1
      local current = tonumber(oldvalue) or 0
      if (value:find("inc%+")) then value = current + num else value = current - num end
    end
    return value
  end
  
  -- ----------------------------------------------------------
  -- Converti un nombre de secondes en un format expressif 
  -- ----------------------------------------------------------
  GEA.getDureeInString = function(nbSecondes) 
    local dureefull = ""
    local duree = ""
    nHours = math.floor(nbSecondes/3600)
    nMins = math.floor(nbSecondes/60 - (nHours*60))
    nSecs = math.floor(nbSecondes - nHours*3600 - nMins *60)
    if (nHours > 0) then 
      duree = duree .. nHours .. "h " 
      dureefull = dureefull .. nHours
      if (nHours > 1) then dureefull = dureefull .. " " .. GEA.trad.hours else dureefull = dureefull .. " " .. GEA.trad.hour end
    end
    if (nMins > 0) then 
      duree = duree .. nMins .. "m " 
      if (nHours > 0) then dureefull = dureefull .. " " end
      if (nSecs == 0 and nHours > 0) then dureefull = dureefull .. "et " end
      dureefull = dureefull .. nMins
      if (nMins > 1) then dureefull = dureefull .. " " .. GEA.trad.minutes else dureefull = dureefull .. " " .. GEA.trad.minute end
    end
    if (nSecs > 0) then 
      duree = duree.. nSecs .. "s" 
      if (nMins > 0) then dureefull = dureefull .. " " .. GEA.trad.andet .. " " end
      dureefull = dureefull .. nSecs
      if (nSecs > 1) then dureefull = dureefull .. " " .. GEA.trad.seconds else dureefull = dureefull .. " "  .. GEA.trad.second end
    end
    return duree, dureefull
  end
  
  -- ----------------------------------------------------------
  -- Retourne les heures au bon format si besoin
  -- ----------------------------------------------------------
  GEA.flatTimes = function(from, to)
    return GEA.flatTime(from, false), GEA.flatTime(to, to==from)
  end
  
  -- ----------------------------------------------------------
  -- Retourne une heure au bon format si besoin
  -- ----------------------------------------------------------
  GEA.flatTime = function(time, force)

    local t = time:lower()
    t = t:gsub(" ", ""):gsub("h", ":"):gsub("sunset", fibaro:getValue(1, "sunsetHour")):gsub("sunrise", fibaro:getValue(1, "sunriseHour"))

    if (string.find(t, "<")) then
      t = GEA.flatTime(tools.split(t, "<")[1]).."<"..GEA.flatTime(tools.split(t, "<")[2])
    end
    if (string.find(t, ">")) then
      t = GEA.flatTime(tools.split(t, ">")[1])..">"..GEA.flatTime(tools.split(t, ">")[2])
    end

    local td = os.date("*t", GEA.runAt)
    if(string.find(t, "+")) then
      local time = tools.split(t, "+")[1]
      local add = tools.split(t, "+")[2]
      local sun = os.time{year=td.year, month=td.month, day=td.day, hour=tonumber(tools.split(time, ":")[1]), min=tonumber(tools.split(time, ":")[2]), sec=td.sec}
      sun = sun + (add *60)
      t = os.date("*t", sun)
      t =  string.format("%02d", t.hour).. ":" ..string.format("%02d", t.min)
    elseif(string.find(t, "-")) then
      local time = tools.split(t, "-")[1]
      local add = tools.split(t, "-")[2]
      local sun = os.time{year=td.year, month=td.month, day=td.day, hour=tonumber(tools.split(time, ":")[1]), min=tonumber(tools.split(time, ":")[2]), sec=td.sec}
      sun = sun - (add *60)
      t = os.date("*t", sun)
      t =  string.format("%02d", t.hour)..":" ..string.format("%02d", t.min)			
    elseif (string.find(t, "<")) then
      local s1 = tools.split(t, "<")[1]
      local s2 = tools.split(t, "<")[2]
      s1 =  string.format("%02d", tools.split(s1, ":")[1]) .. ":" .. string.format("%02d", tools.split(s1, ":")[2])
      s2 =  string.format("%02d", tools.split(s2, ":")[1]) .. ":" .. string.format("%02d", tools.split(s2, ":")[2])
      if (s1 < s2) then t = s1 else t = s2 end
    elseif (string.find(t, ">")) then
      local s1 = tools.split(t, ">")[1]
      local s2 = tools.split(t, ">")[2]
      s1 =  string.format("%02d", tools.split(s1, ":")[1]) .. ":" .. string.format("%02d", tools.split(s1, ":")[2])
      s2 =  string.format("%02d", tools.split(s2, ":")[1]) .. ":" .. string.format("%02d", tools.split(s2, ":")[2])
      if (s1 > s2) then t = s1 else t = s2 end
    else
      t =  string.format("%02d", tools.split(t, ":")[1]) .. ":" .. string.format("%02d", tools.split(t, ":")[2])  
    end

    if (force) then
      if (GEA.currentEntry.firstvalid) then
        local td = os.date("*t", GEA.currentEntry.firstvalid)
        local sun = os.time{year=td.year, month=td.month, day=td.day, hour=td.hour, min=td.min, sec=td.sec}
        sun = sun + GEA.currentEntry.duration
        t = os.date("*t", sun)	
        return string.format("%02d", t.hour).. ":" ..string.format("%02d", t.min)..":" ..string.format("%02d", t.sec)
      end
    end
    return t .. ":" ..string.format("%02d", td.sec)

    
  end
  
  -- ----------------------------------------------------------
  -- Contrôle des heures
  -- ----------------------------------------------------------
  GEA.checkTime = function(from, to)
		local now = os.date("%H%M%S", GEA.runAt)
    from, to = GEA.flatTimes(from, to)
    from = from:gsub(":", "")
    to = to:gsub(":", "")
		if (to < from) then
			return (now >= from) or (now <= to)
		else
			return (now >= from) and (now <= to)
		end
	end
  
  -- ----------------------------------------------------------
  -- Contrôle des dates
  -- ----------------------------------------------------------
  GEA.checkDates = function(from, to)
    local now = os.date("%Y%m%d", GEA.runAt)
    to = to or from
    local d,m,y = to:match("(%d+).(%d+).(%d+)")
    if (not y) then to = to .. GEA.trad.input_date_format:match("[/,.]") .. os.date("%Y", GEA.runAt) end
    local toy, tom, tod = GEA.getDateParts(to, GEA.trad.input_date_format)
    d,m,y = from:match("(%d+).(%d+).(%d+)")
    if (not y) then from = from .. GEA.trad.input_date_format:match("[/,.]") .. os.date("%Y", GEA.runAt) end
    local fromy, fromm, fromd = GEA.getDateParts(from, GEA.trad.input_date_format)
    from = string.format ("%04d", fromy) ..string.format ("%02d", fromm)..string.format ("%02d", fromd)
		to = string.format ("%04d", toy) ..string.format ("%02d", tom)..string.format ("%02d", tod)
		return tonumber(now) >= tonumber(from) and tonumber(now) <= tonumber(to)    
  end
  
  -- ----------------------------------------------------------
  -- Contrôle des jours
  -- ----------------------------------------------------------
 	GEA.checkDays = function(days)
    if (not days or days=="") then days = "All" end
    days = days:lower()
		local jours = days:gsub("all", "weekday,weekend")
    jours = jours:gsub(GEA.trad.weekdays, GEA.traduction.en.weekdays):gsub(GEA.trad.weekend, GEA.traduction.en.weekend)
    jours = jours:gsub(GEA.trad.week[1], GEA.traduction.en.week[1]):gsub(GEA.trad.week[2], GEA.traduction.en.week[2]):gsub(GEA.trad.week[3], GEA.traduction.en.week[3]):gsub(GEA.trad.week[4], GEA.traduction.en.week[4]):gsub(GEA.trad.week[5], GEA.traduction.en.week[5]):gsub(GEA.trad.week[6], GEA.traduction.en.week[6]):gsub(GEA.trad.week[7], GEA.traduction.en.week[7])
		jours = jours:gsub("weekday", "monday,tuesday,wednesday,thursday,friday"):gsub("weekdays", "monday,tuesday,wednesday,thursday,friday"):gsub("weekend", "saturday,sunday")
		return tools.isNotNil(string.find(jours:lower(), os.date("%A", GEA.runAt):lower()))
	end
  
  -- ----------------------------------------------------------
  -- Traite les entrées spéciales avant de l'ajouter dans le tableau
  -- ----------------------------------------------------------
  GEA.insert = function(t, v, entry)
    --if ((GEA.auto and entry.duration<0) or (not GEA.auto and entry.duration>=0)) then return false end
    local action = tostring(v.name):lower()
    if (action == "repeat") then entry.repeating = true  return end
    if (action == "notstart") then entry.stopped = true return end
    if (action == "portables") then entry.portables = v.args[1] return end
    if (action == "portable" or action == "push") then entry.portables = {} end
    if (action == "inverse") then local num = v.args[1] or 1 entry.inverse[entry.id.."-"..entry.conditions[num].option_id] = true return end
    if (action == "time") then if (not entry.ortime) then entry.ortime = {"Or", {"Time", v.args[1], v.args[2]}} else table.insert(entry.ortime, {"Time", v.args[1], v.args[2]}) end return end
    if (action == "dates") then if (not entry.ordates) then entry.ordates = {"Or", {"Dates", v.args[1], v.args[2]}} else table.insert(entry.ordates, {"Dates", v.args[1], v.args[2]}) end return end
    if (action == "maxtime") then 
      local time = GEA.options.maxtime.getValue(entry.id)
      if (time and tonumber(time) < 1) then
        entry.stopped = true
      else
        entry.maxtime = v.args[1] 
        entry.repeating = true 
      end
      return 
    end
    if (action == "alarm") then entry.duration = 30 entry.repeating = true end
    if (action == "depend") then table.insert(GEA.findEntry(v.args[1]).listeners, entry.id) entry.isWaiting[v.args[1]]=true end
    table.insert(t, v)
    return true
  end
  
  -- ----------------------------------------------------------
  -- Ajoute dans l'historique
  -- ----------------------------------------------------------  
  GEA.addHistory = function(message)
    if (not GEA.auto) then return end
    if (not GEA.history) then GEA.history = {} end
    if (#GEA.history >= GEA.historymax) then
      for i = 1, (#GEA.history-1) do
        GEA.history[i] = GEA.history[i+1]
      end
      GEA.history[#GEA.history] = nil
    end
    GEA.history[(#GEA.history+1)] = os.date(GEA.trad.hour_format, GEA.runAt) .. " : " .. message:gsub("<", ""):gsub(">", "")
  end
  
  GEA.id_entry = 0
  GEA.entries = {}
  -- ----------------------------------------------------------
  -- Retrouve une entry selon son ID
  -- ----------------------------------------------------------
  GEA.findEntry = function(entryId) 
      for i = 1, #GEA.entries do
        if (GEA.entries[i].id == tonumber(entryId)) then return GEA.entries[i] end
      end
  end
  
  -- ----------------------------------------------------------
  -- Permet l'ajout des entrées à traiter
  -- c : conditions
  -- d : duree
  -- m : message
  -- a : actions
  -- l : log
  -- ----------------------------------------------------------
  GEA.add = function(c, d, m, a, l)
      
    if (not c) then tools.error(GEA.trad.err_cond_missing) return end
    if (not d) then tools.error(GEA.trad.err_dur_missing) return end
    if (not m) then tools.error(GEA.trad.err_msg_missing) return end
    
    GEA.id_entry =   GEA.id_entry + 1
    
    if (type(a) == "string" and type(l) == "nil") then l = a a = nil end
        
    local entry = {id=GEA.id_entry, conditions={}, duration=d, message=m, actions={}, repeating=false, maxtime=-1, count=0, stopped=false, listeners={}, isWaiting={}, firstvalid=nil, lastvalid=nil, runned=false, log="#" .. GEA.id_entry .. " " ..tools.iif(l, tools.tostring(l), ""), portables=GEA.portables, inverse={}}
    
    -- entrée inutile, on retourne juste l'id pour référence
    if (not GEA.auto and d>=0) then return entry.id end
    if (GEA.auto and d<0) then return entry.id end
    if (GEA.source["type"] == "other") then return entry.id end

    GEA.currentEntry = entry
    
    entry.mainid = -1
    local done = false
    -- traitement des conditions
    if (type(c) == "table" and ( type(c[1]) == "table" or type(c[1]) == "number" or c[1]:find("%d+!") or type(c[1]) == "boolean")) then
      for i = 1, #c do 
          local res = GEA.insert(entry.conditions, GEA.getOption(c[i]), entry) 
          done = done or res
      end
    else
      done = GEA.insert(entry.conditions, GEA.getOption(c), entry)
    end
    if (done) then 
      if (type(entry.conditions[1].getId()) == "table") then
        entry.mainid = entry.conditions[1].getId()[1]
      else
        entry.mainid = entry.conditions[1].getId() 
      end
    end    
    
        -- analyse des messages pour empécher la suppression des otpions utilisées
    if (GEA.auto) then GEA.getMessage(m, true) end
    
    -- analyse du déclencheur
    if (GEA.event) then
      -- si le déclencheur est touvé en recherche un id correspondant
      local found = false
      for i = 1, #entry.conditions do
        local ids = entry.conditions[i].getId()
        if (type(ids) == "table") then
          for j = 1, #ids do
            if (tostring(ids[j]) == tostring(GEA.event)) then found = true end
          end
        else
          if (tostring(ids) == tostring(GEA.event)) then found = true end
        end
      end
      if (not found) then return entry.id end
    end

    if (a) then
      -- traitement des actions
      if (type(a) == "table" and type(a[1]) == "table") then
          for i = 1, #a do 
            if (type(a[i]) == "table" and a[i][1]:lower()=="if") then 
              GEA.insert(entry.conditions, GEA.getOption(a[i][2]), entry) 
            elseif (type(a[i]) == "table" and GEA.compareString(a[i][1]:lower(), "#r#^time|dates|days|dst|nodst|^armed|^disarmed")) then 
              GEA.insert(entry.conditions, GEA.getOption(a[i]), entry) 
            else 
              GEA.insert(entry.actions, GEA.getOption(a[i]), entry) 
            end
          end
      else
          if (type(a) == "table" and a[1]:lower()=="if") then 
            GEA.insert(entry.conditions, GEA.getOption(a[2]), entry) 
          elseif (type(a) == "table" and GEA.compareString(a[1]:lower(), "#r#^time|dates|days|dst|nodst|^armed|^disarmed")) then 
            GEA.insert(entry.conditions, GEA.getOption(a), entry) 
          else 
            GEA.insert(entry.actions, GEA.getOption(a), entry) 
          end
      end
    end
    -- gestion des heures et dates multiples
    if (entry.ortime) then if (#entry.ortime > 2) then GEA.insert(entry.conditions, GEA.getOption(entry.ortime), entry) else table.insert(entry.conditions, GEA.getOption(entry.ortime[2])) end end
    if (entry.ordates) then if (#entry.ordates > 2) then GEA.insert(entry.conditions, GEA.getOption(entry.ordates), entry) else table.insert(entry.conditions, GEA.getOption(entry.ordates[2])) end end
        
    local correct = true
    local erreur = ""
    for i = 1,  #entry.conditions do
      entry.log = tools.iif(l, entry.log, entry.log .. entry.conditions[i].getLog())
      if (GEA.auto) then
      -- Controle des conditions
        GEA.currentMainId = entry.mainid
        GEA.currentCondition = entry.conditions[i]
        check, msg = entry.conditions[i].control()
        if (not check) then erreur = msg end
        if (not entry.conditions[i].hasValue) then 
          check = false
          erreur = string.format(GEA.trad.not_an_condition, entry.conditions[i].getLog())
        end
        correct = correct and check
      end
    end
        
    for i = 1,  #entry.actions do
      entry.log = tools.iif(l, entry.log, entry.log .. entry.actions[i].getLog())
      if (GEA.auto) then
        -- Controle des actions  
        GEA.currentAction = entry.actions[i]
        check, msg = entry.actions[i].control()
        if (not check) then erreur = msg end
        if (not entry.actions[i].hasAction) then 
          check = false
          erreur = string.format(GEA.trad.not_an_action, entry.actions[i].getLog())
        end      
        correct = correct and check
      end
    end
    entry.simplelog = entry.log
    entry.log = entry.log .."<span style=\"color:gray;\">" .. tools.iif(entry.repeating, " *"..GEA.trad.repeated.."*", "") .. tools.iif(entry.stopped, " *"..GEA.trad.stopped.."*", "") .. tools.iif(entry.maxtime > 0, " *"..GEA.trad.maxtime.."="..entry.maxtime.."*", "") .. "</span>"
        
    if (correct) then 
      if (GEA.auto) then tools.info(GEA.trad.add_auto .." ".. entry.log) end
    else 
      tools.error(tools.iif(entry.duration < 0, GEA.trad.add_event .." ", GEA.trad.add_auto .." ") .. entry.log) 
      tools.error(erreur) 
      tools.error(GEA.trad.gea_failed) 
      fibaro:abort()
    end
    table.insert(GEA.entries, entry)
    
    return entry.id
  end
  
  -- ----------------------------------------------------------
  -- Execute une function et attends un retour
  -- ----------------------------------------------------------  
  GEA.waitWithTimeout = function(func, sleep, max)
    local ok, result = func()
    while (not ok and max > 0) do
      fibaro:sleep(sleep)
      max = max - sleep
      ok, result = func()
    end
    return result
  end
  
  -- ----------------------------------------------------------
  -- Vérifie une entrée pour s'assurer que toutes les conditions 
  -- soient remplies
  -- ----------------------------------------------------------
  GEA.check = function(entry) 
    
    if (GEA.options.restarttask.getValue(entry.id)) then 
      GEA.reset(entry) 
      GEA.stoppedTasks[entry.id] = nil
      GEA.globalvalue = GEA.globalvalue:gsub("|R_" .. entry.id.."|", ""):gsub("|S_" .. entry.id.."|", ""):gsub("|M_" .. entry.id .. "{(%d+)}|", "")
    end
    if (GEA.options.stoptask.getValue(entry.id)) then entry.stopped = true end

    if (entry.stopped) then 
      if (not GEA.stoppedTasks[entry.id]) then tools.debug("&nbsp;&nbsp;&nbsp;["..GEA.trad.stopped.."] " .. entry.log) end
      GEA.stoppedTasks[entry.id] = true
    end
    
    -- test des conditions
    local ready = true
    for i = 1, #entry.conditions do 
      GEA.currentCondition = entry.conditions[i]
      local result, _ = entry.conditions[i].check() 
      ready = ready and result
    end    
      
    if (not entry.stopped) then tools.debug("@" ..(GEA.nbRun*GEA.checkEvery) .. "s ["..GEA.trad.validate..tools.iif(ready, "*] ", "] ") .. entry.log) end
   
    if (ready) then
      if (entry.stopped) then return end
      if (tools.isNil(entry.lastvalid)) then entry.lastvalid = GEA.runAt end
      if (tools.isNil(entry.firstvalid)) then entry.firstvalid = GEA.runAt end
      if (os.difftime(GEA.runAt, entry.lastvalid) >= entry.duration) then
        entry.count = entry.count + 1
        entry.lastvalid = GEA.runAt
        tools.info("&nbsp;&nbsp;&nbsp;["..GEA.trad.start_entry.."] " .. entry.log)
        -- gestion des actions
        for i = 1, #entry.actions do
          GEA.currentAction = entry.actions[i]
          tools.debug("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;["..GEA.trad.action.."] " .. GEA.getMessage(entry.actions[i].getLog()))
          if (GEA.secureAction) then
            if (not pcall( function() entry.actions[i].action() end ) ) then 
              tools.error(GEA.trad.err_check .. entry.actions[i].getLog()) 
              GEA.addHistory(GEA.trad.err_check .. entry.simplelog)
            end
          else
            entry.actions[i].action()
          end
        end
        -- envoi message push
        if (entry.message ~= "") then if (type(GEA.output)~="function") then for i = 1, #entry.portables do GEA.getOption({"Portable", entry.portables[i], GEA.getMessage()}).action() end else GEA.output(GEA.getMessage()) end end
        entry.runned = true
        -- mise à jour des écoutes --
        for i=1, #entry.listeners do GEA.findEntry(entry.listeners[i]).isWaiting[entry.id] = false end
        -- remise à zéro des attente --
        for i=1, #entry.isWaiting do entry.isWaiting[i] = true end
        -- Vérification du MaxTime
        if (entry.maxtime > 0) then
          local timeleft = GEA.options.maxtime.getValue(entry.id)
          if (not timeleft) then 
            GEA.options.maxtime.action(entry.id, entry.maxtime-1)
          else
            timeleft = tonumber(timeleft)
            GEA.options.maxtime.action(entry.id, timeleft-1)
          end
        end
        GEA.addHistory(entry.simplelog)
        if (not entry.repeating) then entry.stopped = true end
      end
    else
      GEA.reset(entry)
    end
    return ready
  end
  
  -- ----------------------------------------------------------
  -- Cherche un mot dans le tableau source et retourne sa valeur
  -- dans du tableau destination
  -- ----------------------------------------------------------
  GEA.translate = function(word, tableSource, tableDest)
    for k, v in pairs(tableSource) do if (tostring(v):lower() == tostring(word):lower()) then return tableDest[k] end end 
  end
  
  -- ----------------------------------------------------------
  -- Cherche un mot anglais et trouve son équivalence dans 
  -- la langue locale
  -- ----------------------------------------------------------
  GEA.translatetrad = function(key, word)
    if (type(GEA.traduction.en[key])=="table") then 
      local res = GEA.translate(word, GEA.traduction.en[key], GEA.trad[key])
      if (res) then return res end
    elseif (GEA.trad[key]) then
      return GEA.trad[key]
    end
    return word
  end
  
  -- ----------------------------------------------------------
  -- Remplace les éléments du message
  -- ----------------------------------------------------------
    GEA.getMessage = function(message, forAnalyse)
    if (not forAnalyse) then
      if (not message) then message = GEA.currentEntry.message end
      message = tostring(message)
      message:gsub("(#.-#)", function(c) 
          local position = tonumber(c:match("%[(%d+)%]") or 1)
          c = c:gsub("%[","%%%1"):gsub("%]","%%%1")
          if (c:find("value")) then message = message:gsub(c, tostring(GEA.options.result.getValue(position))) end
          if (c:find("name")) then message = message:gsub(c, GEA.options.name.getValue(position)) end
          if (c:find("room")) then message = message:gsub(c, GEA.options.room.getValue(position)) end
      end)
    end
    message:gsub("({.-})", function(c) 
        local d = tools.split(c:gsub("{", ""):gsub("}", ""), ",")
        for i = 1, #d do 
          d[i] = tools.trim(d[i])
          if (tools.isNumber(d[i])) then d[i] = tonumber(d[i])
          elseif (d[i]:lower()=="true") then d[i] = true 
          elseif (d[i]:lower()=="false") then d[i] = false
          end
        end
        local res = GEA.getOption(d).getValue()
        if (type(res) == "nil") then res = "n/a" end
        message = message:gsub(c, tostring(res))
    end)     
    if (not forAnalyse) then
      message = message:gsub("#runs#", GEA.options.runs.getValue())
      message = message:gsub("#seconds#", GEA.options.seconds.getValue())
      message = message:gsub("#duration#", GEA.options.duration.getValue())
      message = message:gsub("#durationfull#", GEA.options.durationfull.getValue())
      message = message:gsub("#time#", GEA.options.time.getValue())
      message = message:gsub("#date#", GEA.options.date.getValue())
      message = message:gsub("#datefull#", GEA.options.datefull.getValue())
      message = message:gsub("#trigger#", GEA.options.trigger.getValue())
      message:gsub("#translate%(.-%)", function(c)
          local key, word = c:match("%((.-),(.-)%)")
          c = c:gsub("%[","%%%1"):gsub("%]","%%%1"):gsub("%(","%%%1"):gsub("%)","%%%1")
          message = message:gsub(c.."#", GEA.options.translate.getValue(key, word))
      end)
    end
    if (type(GEA.getMessageDecorator) == "function") then message = GEA.getMessageDecorator(message) end
    return message
  end

  -- ----------------------------------------------------------
  -- Recherche et activation des plugins scénarios
  -- ----------------------------------------------------------
  GEA.searchPlugins = function()
    if (not GEA.auto) then
      local vgplugins = GEA.getGlobalValue(GEA.pluginsvariables)
      if (vgplugins and vgplugins ~= "") then
        GEA.plugins = json.decode(vgplugins)
        for k, _ in pairs(GEA.plugins) do if (k ~= "retour") then GEA.options[k] = GEA.copyOption("pluginscenario", k) end end
      end
      return
    end
    local message = GEA.trad.search_plugins.." :"
    local scenes = api.get("/scenes")
    local found = false
    for i = 1, #scenes do
      if (scenes[i].isLua) then
        local scene = api.get("/scenes/"..scenes[i].id)
        if (string.match(scene.lua, "GEAPlugin%.version.?=.?(%d+)")) then
          local name = scene.name:lower():gsub("%p", ""):gsub("%s", "")
          message = message .. " " .. name
          GEA.plugins[name] = scene.id
          GEA.options[name] = GEA.copyOption("pluginscenario", name)
          found = true
          if (tools.isNil(GEA.getGlobalValue(GEA.pluginsvariables))) then 
            tools.info(string.format(GEA.trad.gea_global_create, GEA.pluginsvariables), "yellow")
            api.post("/globalVariables", {name=GEA.pluginsvariables, isEnum=0}) 
          end
          fibaro:setGlobal(GEA.pluginsvariables, json.encode(GEA.plugins))
        end
      end
    end
    if (not found) then message = message .. GEA.trad.plugins_none end
    tools.info(message, "yellow")
  end
  
  -- ----------------------------------------------------------
  -- RAZ d'une entrée
  -- ----------------------------------------------------------
  GEA.reset = function(entry)
      entry.count = 0
      entry.lastvalid = nil
      entry.firstvalid = nil
      entry.stopped = false
      entry.runned = false
      for i=1, #entry.isWaiting do entry.isWaiting[i] = true end
  end
  
  -- ----------------------------------------------------------
  -- Decode un JSON et va chercher la propriété demandé
  -- ----------------------------------------------------------
  GEA.decode = function(flux, property)
    local d = json.decode(flux)
    if (d) then
        local lastvalue = d
        for k, v in pairs(tools.split(property, ".")) do
          if (v:match("%[(%d+)%]") and type(lastvalue[v:gsub("%[(%d+)%]", "")]) == "table") then 
            local number = tonumber(v:match("%[(%d+)%]") or 1)
            if (number) then 
              v = v:gsub("%[(%d+)%]", "")
              lastvalue = lastvalue[v][number]
            end
          elseif (v:match("%[(%d+)%]")) then 
            local number = tonumber(v:match("%[(%d+)%]") or 1)
            if (number) then 
              v = v:gsub("%[(%d+)%]", "")
              lastvalue = lastvalue[number]
            end
          else        
            if (lastvalue[v]) then lastvalue = lastvalue[v] end
          end
        end
        return lastvalue
    end
  end
  
  -- ----------------------------------------------------------
  -- Permet de retourné les infos de GEA à qui besoin
  -- ----------------------------------------------------------
  GEA.answer = function(params)
    if (tools.isNil(GEA.getGlobalValue(GEA.historyvariable))) then GEA.history = {} else GEA.history =  json.decode(GEA.getGlobalValue(GEA.historyvariable)) end 
    if (params.vdid) then
      for k, v in pairs(params) do
        if (type(v)=="string" and v:match("%[(%d+)%]") and type(GEA[v:gsub("%[(%d+)%]", "")]) == "table") then 
          local number = tonumber(v:match("%[(%d+)%]") or 1)
          if (number) then 
            v = v:gsub("%[(%d+)%]", "")
            fibaro:call(params.vdid, "setProperty", "ui."..k..".value", tools.iif(GEA[v][number], tools.tostring(GEA[v][number]), ""))
          end
        elseif (type(GEA[v]) ~= "function" and type(GEA[v]) ~= "nil") then
          fibaro:call(params.vdid, "setProperty", "ui."..k..".value", " " .. tools.tostring(GEA[v]))
        end
      end
    end
  end
  
  -- ----------------------------------------------------------
  -- Optimisation du code
  -- ----------------------------------------------------------
  GEA.optimise = function()
    tools.info(GEA.trad.optimization, "gray")
    GEA.answer = nil
    GEA.insert = nil
    GEA.searchPlugins = nil
    GEA.add = nil
    GEA.copyOption = nil
    GEA.init = nil
    setEvents = nil
    config = nil
    local depends = ""
    local notused = {}
    for k, v in pairs(GEA.options) do
      local found = false
      for _, w in pairs(GEA.usedoptions) do
        if (k == w) then
          found = true
          if (v.depends) then depends = depends .. table.concat(v.depends, " ") end
        end
      end
      if (not found) then table.insert(notused, k) end
    end
    for _, v in pairs(notused) do
      if (GEA.options[v] and GEA.options[v].optimize and (not depends:find(v))) then 
        if (v == "batteries") then GEA.batteries = nil end
        if (v == "frequency") then GEA.getFrequency = nil end
        tools.info(GEA.trad.removeuseless .. v, "gray")
        GEA.options[v] = nil 
      end
    end
    GEA.usedoptions = nil
    for k, _ in pairs(GEA.traduction) do if (k ~= string.lower(GEA.language) and k ~= "en") then tools.info(GEA.trad.removeuselesstrad .. k, "gray") GEA.traduction[k] = nil end end
  end
  
  -- ----------------------------------------------------------
  -- Lance le contrôle de toutes les entrées
  -- ----------------------------------------------------------
  GEA.nbRun = -1
  GEA.currentMainId = nil
  GEA.currentEntry = nil
  GEA.run = function() 
    GEA.running = true -- fibaro:isSceneEnabled(__fibaroSceneId)
    if (GEA.running) then
      GEA.runAt = os.time()
      GEA.forceRefreshValues = false
      GEA.globalvalue = GEA.getGlobalValue(GEA.globalvariables)
      GEA.nbRun = GEA.nbRun + 1
      if (GEA.nbRun > 0 and math.fmod(GEA.nbRun, 10) == 0) then 
        local garbage = collectgarbage("count")
        tools.info(string.format(GEA.trad.gea_run_since, GEA.getDureeInString(GEA.runAt-GEA.started)) .. " - " .. GEA.trad.memoryused .. string.format("%.2f", garbage) .. " KB" )
        table.insert(GEA.garbagevalues, tostring(garbage))
        if (#GEA.garbagevalues >= 5) then 
          local up = true
          local previous = 0
          for _, v in pairs(GEA.garbagevalues) do
            v = tonumber(v)
            if (previous == 0) then previous = v end
            if (v < previous) then up = false end
            previous = v
          end
          if (up) then tools.warning(GEA.trad.memoryused .. string.format("%.2f", previous) .. " KB" ) end
        end
        if (#GEA.garbagevalues >= 10) then table.remove(GEA.garbagevalues, 1) end
      else 
        if ((not GEA.debug) and GEA.auto) then tools.log(string.format(GEA.trad.gea_check_nbr, GEA.nbRun, (GEA.nbRun*GEA.checkEvery)), "cyan", true) end
        if (GEA.nbRun == 1) then GEA.optimise() GEA.optimise = nil end
      end
      local nbEntries = #GEA.entries
      if (nbEntries > 0) then
        for i = 1, nbEntries do
          GEA.currentMainId = GEA.entries[i].mainid
          GEA.currentEntry = GEA.entries[i]
          GEA.check(GEA.entries[i])
        end
        fibaro:setGlobal(GEA.globalvariables, GEA.globalvalue)
        fibaro:setGlobal(GEA.historyvariable, json.encode(GEA.history))
      end
      if (GEA.auto) then 
        --local nextstart = GEA.checkEvery - (os.time()-GEA.started*GEA.nbRun
        local nextstart = os.difftime(GEA.started+(GEA.nbRun+1)*GEA.checkEvery, os.time())
        setTimeout(function() GEA.run() end, nextstart * 1000) 
      end
    end
  end
  
  -- ----------------------------------------------------------
  -- Initialisation, démarrage de GEA
  -- ----------------------------------------------------------
  GEA.init = function()
    config()
    if (not GEA.language) then
      if (api) then GEA.language = api.get("/settings/info").defaultLanguage end
      if (not GEA.traduction[GEA.language]) then GEA.language = "en" end
    end
    GEA.trad = GEA.traduction[string.lower(GEA.language)]
    if (type(GEA.portables) ~= "table") then GEA.portables = {GEA.portables} end
    if (GEA.auto) then
      tools.info("--------------------------------------------------------------------------------", "cyan")
      tools.info(string.format(GEA.trad.gea_start, GEA.version, GEA.source.type), "cyan")
      tools.info("--------------------------------------------------------------------------------", "cyan")
      tools.info(string.format(GEA.trad.gea_minifier, tools.version), "yellow")    
      tools.info(string.format(GEA.trad.gea_check_every, GEA.checkEvery), "yellow")
      tools.info(string.format(GEA.trad.gea_global_create, GEA.globalvariables), "yellow")
      tools.info(string.format(GEA.trad.gea_global_create, GEA.historyvariable), "yellow")
    end
    if (GEA.source.type ~= "other") then tools.info("--------------------------------------------------------------------------------") end
    local line, result = nil, nil
    if (not GEA.auto) then
      GEA.event = nil
      if (GEA.source.type == "global") then
        GEA.event = GEA.source.name
      elseif (GEA.source.type == "property") then 
        GEA.event = GEA.source.deviceID
      elseif (GEA.source.type == "event") then
        GEA.event = GEA.source.event.data.deviceId
      elseif (GEA.source.type == "other" and fibaro:args()) then
        local params = {}
        for _, v in ipairs(fibaro:args()) do for h, w in pairs(v) do if h == "gealine" then line = w end if h == "result" then result = w end params[h] = w end end
        if (params.vdid) then
          GEA.answer(params)
          return
        end
      end
      if (GEA.source.type ~= "other") then tools.info(string.format(GEA.trad.gea_start_event, GEA.version, GEA.source.type, GEA.event), "cyan") end
    end
    GEA.searchPlugins()
    if (line and result) then 
      -- retour d'un plugin 
      if (not GEA.plugins.retour) then GEA.plugins.retour = {} end
      GEA.plugins.retour[line] = result
      fibaro:setGlobal(GEA.pluginsvariables, json.encode(GEA.plugins))
      return
    end     
    if (GEA.auto) then 
      tools.info(GEA.trad.gea_load_usercode, "yellow")
      tools.info("--------------------------------------------------------------------------------")
    end
    if (GEA.auto) then 
      if (tools.isNil(GEA.getGlobalValue(GEA.globalvariables))) then api.post("/globalVariables", {name=GEA.globalvariables, isEnum=0}) end
      if (tools.isNil(GEA.getGlobalValue(GEA.historyvariable))) then api.post("/globalVariables", {name=GEA.historyvariable, isEnum=0}) end
      fibaro:setGlobal(GEA.globalvariables, "") 
      fibaro:setGlobal(GEA.historyvariable, "")
      local histo = GEA.getGlobalValue(GEA.historyvariable)
      if (histo and histo ~= "") then GEA.history =  json.decode(histo) else GEA.history = {} end
    end
    GEA.globalvalue = GEA.getGlobalValue(GEA.globalvariables)
    setEvents()   
    tools.isdebug = GEA.debug
    if (#GEA.entries==0) then tools.warning(GEA.trad.gea_nothing) end
    tools.info("--------------------------------------------------------------------------------")
    GEA.control = false
    if (#GEA.entries>0) then
      GEA.started = os.time()
      if (GEA.auto) then tools.info(string.format(GEA.trad.gea_start_time, os.date(GEA.trad.date_format, GEA.started), os.date(GEA.trad.hour_format, GEA.started))) end
      GEA.run()
    else
      if (GEA.auto) then 
        tools.info(GEA.trad.gea_stopped_auto) 
        fibaro:abort()
      else
        tools.error(string.format(GEA.trad.no_entry_for_event, GEA.options.trigger.getValue()))
      end
    end
  end

end

-- ==========================================================
-- M A I N ... démarrage de GEA
-- ==========================================================
GEA.init()
