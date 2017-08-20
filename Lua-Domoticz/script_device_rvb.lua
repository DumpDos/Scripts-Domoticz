---------------------------------------------------------------------------
-- script_device_rvb.lua --------------------------------------------------
-- DumpDos 2017 -----------------------------------------------------------
---------------------------------------------------------------------------
-- Ce script permet le gestion d'un ruban LED RVB My Sensors --------------
-- à l'aide d'un interrupteur RVB -----------------------------------------
---------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
----------------------------------------- Variables à Editer ------------------------------------------------
-------------------------------------------------------------------------------------------------------------

local controler		= 'Ruban'	-- Controleur rvb
local led_rouge 	= 'RED'		-- Idx variateur couleur rouge 
local led_vert		= 'GREEN'	-- Idx variateur couleur verte 
local led_bleu		= 'BLUE'	-- Idx Variateur couleur bleue
local print_logs	= true		-- Affichage des données dans les logs

-------------------------------------------------------------------------------------------------------------
----------------------------------------------- Fonctions ---------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- Fonction debugging --
function logs (x, print_logs)
	 if (print_logs) then
     print (x)
	 end 
end

-- Fonction mise à jour des capteurs virtuels --
function update(idx, valeur1)
    local commande = string.format("%d|0|%.2f", idx, valeur1 )
    table.insert (commandArray, { ['UpdateDevice'] = commande } )
end

-- Fonction de conversion des couleurs hexadécimales en RGB -- 
function hex_rvb(couleur_hex)
	logs(couleur_hex, print_logs)
	local r, v, b = string.match(couleur_hex, "#(%w%w)(%w%w)(%w%w)")
	r_dec = (tonumber("0x"..r))
	v_dec = (tonumber("0x"..v))
	b_dec = (tonumber("0x"..b))
	logs("r: "..r_dec.." v: "..v_dec.." b: "..b_dec, print_logs)
	return r_dec, v_dec, b_dec
end

-- Fonction calcul poucentage --
function pourcentage(valeur, increments)
	var = tonumber(math.floor(((valeur*100)/increments)))
	logs(var, print_logs)
	return var
end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------- Fin ------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
 
commandArray = {}

-- Vérification des conditions --
 if devicechanged[controler] then

	 hex_rvb("#ff9a15")
	 -- Changement état leds rouge --
	 pourcentage(r_dec, 255)
	 commandArray[led_rouge]='Set Level '..var
	 
	 -- Changement état leds vert --
	 pourcentage(v_dec, 255)
	 commandArray[led_vert]='Set Level '..var
	 
	 -- Changement état leds bleu --
	 pourcentage(b_dec, 255)
	 commandArray[led_bleu]='Set Level '..var
end

return commandArray
