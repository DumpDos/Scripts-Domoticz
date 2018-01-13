---------------------------------------------------------------------------
-- script_time_renass.lua -------------------------------------------------
-- DumpDos ----------------------------------------------------------------
---------------------------------------------------------------------------
-- Ce script est dédié à la récupération des données fournies par l'api ---
-- du RéNaSS --------------------------------------------------------------
---------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------
-------------------------------------------- Informations ---------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- Site 		: http://renass.unistra.fr
-- API XML  		: http://renass.unistra.fr/fdsnws/event/1/query?latitude=46.6&longitude=1.9&maxradius=9&minmagnitude=1&orderby=time&starttime=2016-11-28&endtime=2016-11-29&format=qml
-- API JSON 		: http://renass.unistra.fr/fdsnws/event/1/query?latitude=46.6&longitude=1.9&maxradius=9&minmagnitude=1&orderby=time&starttime=2016-11-28&endtime=2016-11-29&format=json
-- Post forum		: https://easydomoticz.com/forum/viewtopic.php?f=17&t=2884
-- Script inspiré de 	: https://easydomoticz.com/forum/viewtopic.php?f=17&t=2310

-------------------------------------------------------------------------------------------------------------
----------------------------------------- Variables à Editer ------------------------------------------------
-------------------------------------------------------------------------------------------------------------

local Lat		= "45.0000"	-- Latitude de votre logement
local Lon		= "5.0000"	-- Longitude de votre logement
local Ville		= "Ville"	-- Lieu de résidence
local Magnitude 	= "0.1"		-- Magnitude minimale de détection des séismes
local Rayon		= "2"		-- Rayon de détection des séismes
local Plage_horaire	= "2"		-- Plage horaire de détection
local Seisme_disp	= "391"		-- Idx du capteur texte
local Magnitude_disp	= "610"		-- Idx du capteur graphique magnitude (false = Désactivé)
local Distance_disp	= false		-- Idx du capteur graphique distance (false = Désactivé)
local Magnitude_noti	= 4		-- Magnitude minimale de notification (false = Désactivé)
local Print_logs	= false		-- Affichage des données dans les logs
 
-------------------------------------------------------------------------------------------------------------
---------------------------------------- Variables de Travail -----------------------------------------------
-------------------------------------------------------------------------------------------------------------
noti 		= tonumber(Magnitude_noti)
year		= tonumber(os.date("%Y"));
month		= tonumber(os.date("%m"));
day		= tonumber(os.date("%d"));
heure		= tonumber(os.date("%H")) - tonumber (Plage_horaire);
rayon_terre	= 6378

--------------------------------------------------------------------------------------------------------------
---------------------------------------------- Fonctions -----------------------------------------------------
--------------------------------------------------------------------------------------------------------------

-- Fonction conversion radian --
function radian(valeur)
return ((math.pi * valeur)/180)
end

-- Fonction arrondi --
function arrondi(nombre, decimales)
  local conversion = 10^(decimales or 0)
  return math.floor(nombre * conversion + 0.5) / conversion
end

-- Fonction debugging --
function logs (x, Print_logs)
	 if (Print_logs) then
     print (x)
	 end 
end

-- Fonction mise à jour des capteurs virtuels --
function update(idx, valeur1)
    local commande = string.format("%d|0|%.2f", idx, valeur1 )
    table.insert (commandArray, { ['UpdateDevice'] = commande } )
end

--------------------------------------------------------------------------------------------------------------
------------------------------------------------ Fin ---------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

commandArray = {}

now = os.date("*t")

-- Execution du script toutes les 30 minutes --
if now.min % 1 == 0 then
	
	-- Vérification des conditions --
	if Lat ~= nil and Lon ~= nil and  Ville ~= nil and Seisme_disp ~= nil then
	
	  -- Affichage d'éxécution --
	  print('script_time_renass_json.lua')
	
	-- Emplacement du fichier JSON.lua --
	json = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()
	--json = (loadfile "D:\\Domoticz\\scripts\\lua\\json.lua")()  -- Windows
	--json = (loadfile "/volume1/@appstore/domoticz/var/scripts/lua/JSON.lua")() -- Synology

	  -- Decodage des données 
      local config=assert(io.popen('curl --connect-timeout 10 "https://renass.unistra.fr/fdsnws/event/1/query?latitude='.. Lat ..'&longitude='.. Lon ..'&maxradius='.. Rayon ..'&minmagnitude='.. Magnitude ..'&starttime='.. year ..'-'.. month ..'-'.. day ..'T'..heure..':00:00&orderby=time-asc&format=json"'))
      local data     = config:read('*all')
      local jsondata = json:decode(data)
      config:close()
		 
      -- Récupération des données --
      if jsondata ~= nil then 
            for i, resultat in pairs(jsondata.features) do
		seisme			= resultat.properties
		localisation 	= resultat.geometry

			 -- Récupération des propriétés --
			local releve_brut		= localisation ["coordinates"]	-- Localisation ( Chaîne )
			local releve_description	= seisme ["description"]	-- Description 
			local releve_mode		= seisme ["evaluationMode"]	-- Mode de récupération et validation du séisme par le RéNaSS ( Automatique ou Manuel )
			local releve_magnitude		= seisme ["mag"]		-- Magnitude
			local releve_unitmag		= seisme ["magType"]		-- Unité Magnitude
			local releve_lieu		= seisme ["place"]		-- Pays d'origine			
			local releve_date		= seisme ["time"]		-- Date et Heure (UTC) du séisme ( Chaîne )
			local releve_type		= seisme ["type"]		-- Relevé Type :  séisme / tir de carrière
			local releve_url		= seisme ["url"]		-- URL page originale de l'événement
			
			
			
			 -- Récupération de la localisation --
			local releve_decode1	= table.concat(releve_brut, ",")
			local lon, lat, pro	= string.match (releve_decode1, "(%d+%p%d+),(%d+%p%d+),(.%d+)" )
			
			 -- Récupération de l'heure --
			local releve_decode2	= tostring (releve_date)
			local h, m, s		= string.match (releve_decode2, "(%d+):(%d+):(%d%d)")
			local releve_heure	= (tonumber (h) + 1)
			local releve_minute	= m
			
			-- Récupération type de séisme --
			if releve_type == "earthquake" then
				 seisme_type = "Séisme"
				 
			elseif releve_type == "quarry blast" then
				 seisme_type = "Tir de carrière"
			end
			
			 -- Affichage des données dans logs --
			logs ("Description = "..releve_description, Print_logs)
			logs ("Magnitude = "..releve_magnitude, Print_logs)
			logs ("Latitude = "..lat, Print_logs)
			logs ("Longitude = "..lon, Print_logs)
			logs ("Profondeur = "..pro.." km ", Print_logs)
			logs ("Heure Locale = "..releve_heure..":"..releve_minute, Print_logs)
			logs ("Pays = "..releve_lieu, Print_logs)
			
			 -- Initialisation des variables --
			local lat_a	= tonumber(radian(Lat))
			local lon_a	= tonumber(radian(Lon))
			local lat_b	= tonumber(radian(lat))
			local lon_b	= tonumber(radian(lon))
			 
			 -- Calcul de la distance --
			local distance_brut = rayon_terre * (math.pi/2 - math.asin( math.sin(lat_b) * math.sin(lat_a) + math.cos(lon_b - lon_a) * math.cos(lat_b) * math.cos(lat_a)))
			 
			 -- Calcul angle -- 
			local dy	= lat_b - lat_a
			local dx	= math.cos(math.pi/180*lat_a)*(lon_b - lon_a)
			local angle	= math.atan(dy/dx)
			 
			 -- Calcul Azimuth --
			 -- Quart Nord-Est --
			if (lat_b >= lat_a) and (lon_b >= lon_a) then
				 
				 -- Calcul --
				 angle_degres = ((math.pi/2)- angle)/(( math.pi / 2 ) / 90 )
				
				 -- Définition point de compas -- 
				if angle_degres > 0 and angle_degres < 11.5 then
					 direction = "N"
				end
				if angle_degres >= 11.5 and angle_degres < 34 then
					 direction = "NNE"
				end
				if angle_degres >= 34 and angle_degres < 56.5 then
					 direction = "NE"
				end
				if angle_degres >= 56.5 and angle_degres < 79 then
					 direction = "ENE"
				end	
				if angle_degres >= 79 and angle_degres < 90 then
					 direction = "E"
				end				
			end
			 
			 -- Quart Sud-Est --
			if (lat_b <= lat_a) and (lon_b >= lon_a) then
				 
				 -- Calcul --
				 angle_degres =  90 + (((angle) - (angle*2)) / (( math.pi / 2 ) / 90 ))
				 
				 -- Définition point de compas -- 
				if angle_degres >= 90 and angle_degres < 101.5 then
					 direction = "E"
				end
				if angle_degres >= 101.5 and angle_degres < 124 then
					 direction = "ESE"
				end
				if angle_degres >= 124 and angle_degres < 146.5 then
					 direction = "SE"
				end
				if angle_degres >= 146.5 and angle_degres < 169 then
					 direction = "SSE"
				end	
				if angle_degres >= 169 and angle_degres < 180 then
					 direction = "S"
				end	
			end
			 
			 -- Quart Sud-Ouest --
			if (lat_b <= lat_a) and (lon_b <= lon_a) then
			 
				 -- Calcul --
				 angle_degres = 180 + (((math.pi/2)- angle) / (( math.pi / 2 ) / 90 ))
				 
				 -- Définition point de compas -- 
				if angle_degres >= 180 and angle_degres < 191.5 then
					 direction = "S"
				end
				if angle_degres >= 191.5 and angle_degres < 214 then
					 direction = "SSO"
				end
				if angle_degres >= 214 and angle_degres < 236.5 then
					 direction = "SO"
				end
				if angle_degres >= 236.5 and angle_degres < 259 then
					 direction = "OSO"
				end	
				if angle_degres >= 259 and angle_degres < 270 then
					 direction = "O"
				end
			end
			 
			 --Quart Nord-Ouest --
			if (lat_b >= lat_a) and (lon_b <= lon_a) then
				 
				 -- Calcul --
				 angle_degres =  270 + (((angle) - (angle*2)) / (( math.pi / 2 ) / 90 ))
				 
				 -- Définition point de compas -- 
				if angle_degres >= 270 and angle_degres < 281.5 then
					 direction = "O"
				end
				if angle_degres >= 281.5 and angle_degres < 304 then
					 direction = "ONO"
				end
				if angle_degres >= 304 and angle_degres < 326.5 then
					 direction = "NO"
				end
				if angle_degres >= 326.5 and angle_degres < 349 then
					 direction = "NON"
				end	
				if angle_degres >= 349 and angle_degres <= 360 then
					 direction = "N"
				end
			 
			end
			
			-- Récupération validation séisme --
			if releve_mode == "manual" then
			
				releve_validation = "Validé"
			elseif releve_mode == "automatic" then
			
			    releve_validation = "Non Validé"	
			end
			
			 -- Arrondi valeur azimuth --
			local azimuth = arrondi(angle_degres, 0)
			
			 -- Arrondi valeur distance --
			local distance = arrondi(distance_brut,1)

			 -- Affichage des données dans logs --
			logs ("Distance = "..distance.." km", Print_logs)
			logs ("Azimuth = "..azimuth.." °", Print_logs)
			logs ("Point de compas = "..direction, Print_logs)
			logs ("Validité = "..releve_validation, Print_logs)
			logs ("<a href="..releve_url.."> Page originale de l'événement </a>", Print_logs)
			
			 -- Mise à jour du capteur virtuel -- 
			commandArray['UpdateDevice']= Seisme_disp ..'|0|'..''..seisme_type..' de magnitude : '..releve_magnitude..' '..releve_unitmag..', Profondeur : '..pro..' km, '..releve_heure..' h '..releve_minute..', '..distance..' km '..direction..' ('..azimuth..'°) de '..Ville..', '..releve_validation
				 
				 -- Vérification des conditions --
				if Magnitude_disp ~= false then
					 
					 -- Mise à jour du capteur virtuel --
					 update(Magnitude_disp, releve_magnitude)
					 
				end
				
				 -- Vérification des conditions --
				if Distance_disp ~= false then
					 
					 -- Mise à jour du capteur virtuel --
					 update(Distance_disp, distance)
					 
				end
				
				 -- Vérification des conditions
				if (Magnitude_noti ~= false) and (releve_magnitude >= noti) then
				
				 	 -- Envoi de la notification --
				 	commandArray['SendNotification'] = 'Séisme#Événement de magnitude : '..releve_magnitude..' '..releve_unitmag..', Profondeur : '..pro..' km, '..releve_heure..' h '..releve_minute..', '..distance..' km '..direction..' ('..azimuth..'°) de '..Ville..', '..releve_validation..''
				
				end
			end
	  end
	  
	-- Vérificatiuon debugging logs --
	else
	 
	logs ("Indiquez la latitude, la longitude, la ville ou l'id de vôtre afficheur virtuel.", Print_logs)
	end
end
return commandArray
