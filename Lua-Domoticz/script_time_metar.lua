---------------------------------------------------------------------------
-- script_time_metar.lua --------------------------------------------------
-- DumpDos 2017 -----------------------------------------------------------
---------------------------------------------------------------------------
-- Ce script est dédié à la récupération des METAR ------------------------
---------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------
----------------------------------------- Variables à Editer ------------------------------------------------
-------------------------------------------------------------------------------------------------------------


local OACI_code		= "LFLS"	-- Code OACI de l'aérodrome
local Speed		= "KMH"		-- Unité vitesse KMH (Kilomètres par heure) ou KTS (Noeuds)
local Distance		= "KM"		-- Unité distace KM (Kilomètre) ou NM (Miles Nautique)
local Pressure		= "HPA"		-- Unité pression atmosphérique HPA (Héctopacale) ou INHG (Pouce de mercure)
local Metar_disp	= "962"		-- Idx du capteur texte
local Temp_disp		= ""		-- Idx du capteur de température
local Wind_disp		= ""		-- Idx de l'anémomètre
local Patm_disp		= ""		-- Idx du capteur de pression atmophérique
local Visi_disp		= ""		-- Idx du capteur de distance
local Print_logs	= true		-- Affichage des données dans les logs

-------------------------------------------------------------------------------------------------------------
---------------------------------------- Variables de Travail -----------------------------------------------
-------------------------------------------------------------------------------------------------------------

local fichier 		= "metar.xml"
local kts_kmh 		= 1.852
local inhg_hpa		= 33.86
local time_UTC		= 1
local weather_table 	= {}

--------------------------------------------------------------------------------------------------------------
---------------------------------------------- Fonctions -----------------------------------------------------
--------------------------------------------------------------------------------------------------------------

-- Fonction debugging --
function logs (x, Print_logs)
	 if (Print_logs) then
     print (x)
	 end 
end

-- Fonction arrondi --
function arrondi(nombre, decimales)
  local conversion = 10^(decimales or 0)
  return math.floor(nombre * conversion + 0.5) / conversion
end

-- Fonction mise à jour des capteurs virtuels --
function update(idx, valeur1)
    local commande = string.format("%d|0|%.2f", idx, valeur1 )
    table.insert (commandArray, { ['UpdateDevice'] = commande } )
end

-- Fonction type météo --
function weather_type(wx_value)
     	if wx_value == "VC" then return "Au voisinage"
     	elseif wx_value == "MI" then return "Mince"
     	elseif wx_value == "PR" then return "Partiel"
     	elseif wx_value == "DR" then return "Chasse basse"
     	elseif wx_value == "BL" then return "Chasse haute"
     	elseif wx_value == "FZ" then return "Se congelant"
     	elseif wx_value == "RE" then return "Récent"
    	elseif wx_value == "BC" then return "Bancs"
     	elseif wx_value == "SH" then return "Averse"
	elseif wx_value == "XX" then return "Violent"
	elseif wx_value == "RA" then return "Pluie"
	elseif wx_value == "SN" then return "Neige"
	elseif wx_value == "GR" then return "Grêle"
	elseif wx_value == "DZ" then return "Pluie fine"
	elseif wx_value == "Pl" then return "Granules de glace"
	elseif wx_value == "GS" then return "Grésil"
	elseif wx_value == "SG" then return "Neige en grains"
	elseif wx_value == "IC" then return "Critaux"
	elseif wx_value == "UP" then return "Inconnue"
	elseif wx_value == "BR" then return "Brume"
	elseif wx_value == "FG" then return "Brouillard"
	elseif wx_value == "HZ" then return "Brume sèche"
	elseif wx_value == "FU" then return "Fumée"
	elseif wx_value == "SA" then return "Sable"
	elseif wx_value == "DU" then return "Poussière"
	elseif wx_value == "VA" then return "Cendre"
	elseif wx_value == "PO" then return "Tourbillons de poussière"
	elseif wx_value == "SS" then return "Tempête de sable"
	elseif wx_value == "DS" then return "Tempête de poussière"
	elseif wx_value == "SQ" then return "Ligne de grain"
	elseif wx_value == "FC" then return "Tornade" -- J'espère que cette ligne ne servira jamais D:
	elseif wx_value == "TS" then return "Orage"
     	else return "Type météo non defini" end
end

--------------------------------------------------------------------------------------------------------------
------------------------------------------------ Fin ---------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
commandArray = {}

-- Récupération de l'heure --
time = os.date("*t")

-- Vérification des conditions --
if time.min % 1 == 0 then

-- Affichage d'éxécution --
print('script_time_metar.lua')

	 -- Récupération des données --
     os.execute("wget -q -O "..fichier.." 'https://aviationweather.gov/adds/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&stationString="..OACI_code.."&hoursBeforeNow=0.6'")
     local f = io.open(fichier, "r")

	 -- Lecture des données --
     local dataXML = f:read("*all")
     f:close()

	 -- Décodage des données --
	 for data_decode in dataXML:gmatch("<METAR>(.-)</METAR>") do
	 local obs_rawd		= data_decode:match('<raw_text>(.-)</raw_text>')
	 local obs_airp		= data_decode:match('<station_id>(.-)</station_id>')
	 local obs_time		= data_decode:match('<observation_time>(.-)</observation_time>')
	 local obs_temp		= data_decode:match('<temp_c>(.-)</temp_c>')
	 local obs_dewp 	= data_decode:match('<dewpoint_c>(.-)</dewpoint_c>')
	 local obs_windir 	= data_decode:match('<wind_dir_degrees>(.-)</wind_dir_degrees>')
	 local obs_winspd 	= data_decode:match('<wind_speed_kt>(.-)</wind_speed_kt>')
	 local obs_visimi 	= data_decode:match('<visibility_statute_mi>(.-)</visibility_statute_mi>')
	 local obs_atmprs 	= data_decode:match('<altim_in_hg>(.-)</altim_in_hg>')
	 local obs_wxstat	= data_decode:match('<wx_string>(.-)</wx_string>')
	 local obs_skysta	= data_decode:match('<sky_condition(.-)/>')
	 local obs_flcate	= data_decode:match('<flight_category>(.-)</flight_category>')
	 
	 -- Récupération de la date et de l'heure --
	 local annee, mois, jour, hour, minute, second = string.match (obs_time, "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)Z")
	 local h = (hour + time_UTC)
	 local m = minute
	 local s = second
	 
	 -- Conversion vitesse en kts ou Km/h --
	 local kts = tonumber (obs_winspd)
	 
		 -- Vérification des conditions --
		 if Speed == "KMH" then
			 wind_spd_raw 	= ( kts * kts_kmh )
			 unite_spd 		= "Km/h"
		 else
			 wind_spd_raw 	= kts
			 unite_spd 		= "Kts"
		 end
		 
		 local wind_spd = arrondi(wind_spd_raw,1)
	 
	 -- Conversion distance en Nm en Km --
	 local mi = tonumber (obs_visimi)
	 
		 -- Vérification des conditions --
		 if Distance == "KM" then
			 visibil_raw 	= (mi * kts_kmh)
			 unite_dis		= "Km"
		 else
			 visibil_raw 	= mi
			 unite_dis		= "Nm"
		 end
		 
		 local visibil = arrondi(visibil_raw,1)
		 
	 -- Conversion pouce de mercure en hPa --
	 local inhg = tonumber (obs_atmprs)
	 
		 -- Vérification des conditions --
		 if Pressure == "HPA" then
			 atm_pre_raw	= ( inhg * inhg_hpa)
			 unite_atm		= "hPa"
		 else
			 atm_pre_raw	= inhg
			 unite_atm		= "inHg"
		 end
		 
		 local atm_pre = arrondi(atm_pre_raw,2)
	 
	 -- Conversion Azimuth --
	 local angle_degres = tonumber (obs_windir)
		 -- Définition point de compas -- 
		 if angle_degres == 0 then direction = "Variable"
		 elseif angle_degres >= 1 and angle_degres < 11.5 then direction = "N"
		 elseif angle_degres >= 11.5 and angle_degres < 34 then direction = "NNE"
		 elseif angle_degres >= 34 and angle_degres < 56.5 then direction = "NE"
		 elseif angle_degres >= 56.5 and angle_degres < 79 then direction = "ENE"
		 elseif angle_degres >= 79 and angle_degres < 90 then direction = "E"
		 elseif angle_degres >= 90 and angle_degres < 101.5 then direction = "E"
		 elseif angle_degres >= 101.5 and angle_degres < 124 then direction = "ESE"
		 elseif angle_degres >= 124 and angle_degres < 146.5 then direction = "SE"
		 elseif angle_degres >= 146.5 and angle_degres < 169 then direction = "SSE"
		 elseif angle_degres >= 169 and angle_degres < 180 then direction = "S"
		 elseif angle_degres >= 180 and angle_degres < 191.5 then irection = "S"
		 elseif angle_degres >= 191.5 and angle_degres < 214 then direction = "SSO"
		 elseif angle_degres >= 214 and angle_degres < 236.5 then direction = "SO"
		 elseif angle_degres >= 236.5 and angle_degres < 259 then direction = "OSO"
		 elseif angle_degres >= 259 and angle_degres < 270 then direction = "O"
		 elseif angle_degres >= 270 and angle_degres < 281.5 then direction = "O"
		 elseif angle_degres >= 281.5 and angle_degres < 304 then direction = "ONO"
		 elseif angle_degres >= 304 and angle_degres < 326.5 then direction = "NO"
		 elseif angle_degres >= 326.5 and angle_degres < 349 then direction = "NON"
		 elseif angle_degres >= 349 and angle_degres <= 360 then direction = "N"
		 end

	 -- Vérification des conditions --
	 if obs_wxstat ~= nil then
	     wx_phenomenon = true
		 
		 -- Récupération chaine de données --
		 for wx in string.gmatch(obs_wxstat, "%a+") do
			 
			 -- Création tableau -- 
			 table.insert(weather_table, wx)
			 
			 -- initialisation des varibles --
			 table_1 = weather_table[1]
			 table_2 = weather_table[2]
			 table_3 = weather_table[3]
			 table_4 = weather_table[4]
		 end
		 
			 -- conversion valeurs --
			 wx_var_1 = weather_type(table_1)
			 
			 if table_2 ~= nil then
				 wx_var_2 = weather_type(table_2)
			 else
				 wx_var_2 = ""
			 end
			 
			 if table_3 ~= nil then
				 wx_var_3 = weather_type(table_3)
			 else
				 wx_var_3 = ""
			 end
			 
			 if table_4 ~= nil then
				 wx_var_4 = weather_type(table_4)
			 else
				 wx_var_4 = ""
			 end
	 else
		 wx_phenomenon = false 
	 end
	 
	 -- Affichage logs --
	 logs ("-- METAR de "..obs_airp.." relevé le "..jour.."/"..mois.."/"..annee.." à "..h..":"..m.." --" , Print_logs)
	 logs (obs_rawd, Print_logs)
	 logs ("-- Décodage des données --", Print_logs)
	 logs ("Température : "..obs_temp.." °C", Print_logs)
	 logs ("Point de rosée : "..obs_dewp.." °C", Print_logs)
	 logs ("Vent : "..wind_spd.." "..unite_spd..", Provenance : " ..direction, Print_logs)
	 logs ("Visibilité : "..visibil.." "..unite_dis, Print_logs)
	 logs ("Pression : "..atm_pre.." "..unite_atm, Print_logs)
	 logs ("Conditions : "..obs_flcate, Print_logs)
	 if wx_phenomenon then
		 logs ("Phénomènes :", Print_logs)
		 logs (" "..wx_var_1, Print_logs)
		 logs (" "..wx_var_2, Print_logs)
		 logs (" "..wx_var_3, Print_logs)
		 logs (" "..wx_var_4, Print_logs)
	 end
	 
	 -- Mise à jour du capteur texte --
	 if wx_phenomenon then
	 
		 commandArray['UpdateDevice']= Metar_disp ..'|0|'..''..h..':'..m..' Température : '..obs_temp..' °C, Point de rosée : '..obs_dewp..' °C, Pression : '..atm_pre..' '..unite_atm..', Vent : '..wind_spd..' '..unite_spd..' Provenance '..direction..', Visibilité : '..visibil.." "..unite_dis..", Conditions : "..obs_flcate
	 else
	 
		 commandArray['UpdateDevice']= Metar_disp ..'|0|'..''..h..':'..m..' Température : '..obs_temp..' °C, Point de rosée : '..obs_dewp..' °C, Pression : '..atm_pre..' '..unite_atm..', Vent : '..wind_spd..' '..unite_spd..' Provenance '..direction..', Visibilité : '..visibil.." "..unite_dis..", Conditions : "..obs_flcate
	 end
end
end
return commandArray
