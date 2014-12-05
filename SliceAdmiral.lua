-- Author      : Haghala
-- Create Date : 13/10/2014
local addon = LibStub("AceAddon-3.0"):NewAddon("SliceAdmiral","AceConsole-3.0","AceEvent-3.0");
local AceConfig = LibStub("AceConfig-3.0");
local AceConfigDialog = LibStub("AceConfigDialog-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("SliceAdmiral", true)
local S = LibStub("LibSmoothStatusBar-1.0")
SliceAdmiralVer = GetAddOnMetadata("SliceAdmiral", "Version")
----------------------------------------------------------------------------------------------------

addon.opt = {
	Main = {name = "SliceAdmiral", type = "group", args = {}};
	ShowTimer = {name = "Timer Bars", type = "group", args = {}};
	Combo = {name = "Combo Points and Stats", type = "group", args = {}};
	Energy = {name = "Energy Bar", type = "group", args = {}};
	Sound = {name = "Sound Effects", type = "group", args = {}};
}

SADefault = {
	data = {
		Version = SliceAdmiralVer,
		lastSort = 0,
		maxSortableBars = 0,
		topSortableBars = 0,
		sortPeriod = 0.5,
		tNow = 0,
		UpdateInterval = 0.05,
		TimeSinceLastUpdate = 0,
		numStats = 3,
	},
	Modules = {
		Main = {
			IsLocked = false,
			PadLatency = true,
			point = "TOPLEFT",
			xOfs = 100,
			yOfs = -150,
			Scale = 130,
			Width = 130,
			BarMargin = 1,
			Fade = 75,
			BarTexture = "Interface\\AddOns\\SliceAdmiral\\Images\\LiteStep.tga",
		},
		ShowTimer = {
			Options = {
				Barsup = true,
				SortBars = true,
				Dynamic = false,
				ShowDoTDmg = true,
				DoTCrits = true,
				BarTexture = "Interface\\AddOns\\SliceAdmiral\\Images\\Smooth.tga",
				guileCount = false,
				BladeFlurry = false,
			},
			Colours = { 
				[5171] = { r=255/255, g=74/255, b=18/255, a=0.9,},
				[73651] = {r=10/255, g=10/255, b=150/255,},
				[2818] =  {r=96/255, g=116/255, b=65/255,},
				[1943] = {r=130/255, g=15/255, b=0,},
				[1966]  = {r=155/255, g=155/255, b=255/255,},
				[703] = {r=130/255, g=15/255, b=0,},
				[115189] = {r=0,g=0,b=0,},
				[137573] = {r=135/255, g=135/255, b=255/255,},
				[154953] = {r=205/255, g=92/255, b=92/255,},
				[79140] = {r=130/255, g=130/255, b=0,},
				[32645] = {r=66/255, g=86/255, b=35/255,},
				[84617] =  {r=139/255, g=69/255, b=19/255,},
				[13750] = {r=240/255,g=128/255,b=128/255,},
				[84745] = {r=34/255, g=189/255, b=34/255,},
				[84746] = {r=255/255, g=215/255, b=0/255,},
				[84747] = {r=200/255, g=34/255, b=34/255,},
				[16511] = {r=255/255, g=5/255, b=5/255,},
				[122233] = {r=192/255,g=192/255,b=192/255},
				[51713] = {r=0/255, g=0/255, b=128/255,},
				[91021] = {r=130/255, g=130/255, b=0,},
			},
			Timers = {
				[5171] = 6.0, --Slice and Dice
				[84745] = 6.0, -- BanditsGuile
				[84746] = 6.0, -- BanditsGuile
				[84747] = 6.0, -- BanditsGuile
				[1943] = 6.0, --Rupture
				[73651] = 6.0, -- Recuperate
				[32645] = 6.0, -- Envenom
				[1966] = 5.0, -- Feint
				[137573] = 4.0, -- Burst of Speed
				[16511] = 6.0, --Hemorrhage
				[2818] = 6.0, --DeadlyPoison
				[79140] = 6.0, --Vendetta
				[84617] = 6.0, --RevealingStrike
				[703] = 6.0, -- Garrote
				[13750] = 6.0, --Adrenaline Rush
				[154953] = 6.0, --InteralBleeding
				[122233] = 6.0, -- Crimson Tempest
				[51713] = 6.0, -- ShadowDance
				[91021] = 6.0, --FindWeaknes
			},
			[5171] = true, --Slice and Dice
			[84745] = true, -- BanditsGuile
			[84746] = true, -- BanditsGuile
			[84747] = true, -- BanditsGuile
			[1943] = true, --Rupture
			[73651] = true, -- Recuperate
			[32645] = true, -- Envenom
			[1966] = true, -- Feint
			[137573] = false, -- Burst of Speed
			[91021] = true, --FindWeaknes
			[16511] = true, --Hemorrhage
			[2818] = true, --DeadlyPoison
			[79140] = false, --Vendetta
			[84617] = true, --RevealingStrike
			[703] = true, -- Garrote
			[13750] = false, --Adrenaline Rush
			[154953] = false, --InteralBleeding
			[122233] = true, -- Crimson Tempest
			[51713] = false, -- ShadowDance
		},
		Combo = {
			PointShow = true,
			AnticipationShow = true,
			ShowStatBar = true,
			HilightBuffed = false,
			CPColor = {r=1.0,g=0.86,b=0.1,a=1.0},
			AnColor = {r=0.1,g=0.86,b=1.0,a=1.0},
		},
		Energy  = {
			ShowEnergy = false,
			ShowComboText = true,
			AnticpationText = true,
			Energy1 = 25,
			Energy2 = 40,
			BarTexture = "Interface\\AddOns\\SliceAdmiral\\Images\\Runes.tga",
			EnergySound1 = "",
			EnergySound2 = "",
			EnergyTrans = 75,
			Color = { r=1.0, g=0.96, b=0.41, a=1.0}
		},
		Sound = {
			[5171] = {enabled=true, tick = "Interface\\AddOns\\SliceAdmiral\\Audio\\tambourine.ogg", alert = "Interface\\AddOns\\SliceAdmiral\\Audio\\Old Trumpet A 01.ogg",}, --Slice and Dice
			[73651] = {enabled=true, tick = "Interface\\AddOns\\SliceAdmiral\\Audio\\tambourine.ogg", alert = "",}, -- Recuperate
			[1943] = {enabled=true, tick = "Interface\\AddOns\\SliceAdmiral\\Audio\\shaker.ogg", alert = "Interface\\AddOns\\SliceAdmiral\\Audio\\6OP00084.ogg", }, --Rupture
			[79140] = {enabled=true, tick = "Interface\\AddOns\\SliceAdmiral\\Audio\\pingit.ogg", alert = "", }, --Vendetta
			[84617] = {enabled=true, tick = "Interface\\AddOns\\SliceAdmiral\\Audio\\6OP00084.ogg", alert = "Interface\\AddOns\\SliceAdmiral\\Audio\\shaker.ogg", },--RevealingStrike
			[16511] = {enabled=true, tick = "Interface\\AddOns\\SliceAdmiral\\Audio\\pingit.ogg", alert = "", }, --Hemorrhage
			[84745] = {enabled=false, tick = "", alert="", },
			[84746] = {enabled=false, tick = "", alert="", },
			[84747] = {enabled=false, tick = "", alert="", },
			[32645] = {enabled=false, tick = "", alert="", },
			[1966] = {enabled=false, tick = "", alert="", },
			[137573] = {enabled=false, tick = "", alert="", },
			[2818] = {enabled=false, tick = "", alert="", },
			[703] = {enabled=false, tick = "", alert="", },
			[13750] = {enabled=false, tick = "", alert="", },
			[154953] = {enabled=false, tick = "", alert="", },
			[122233] = {enabled=false, tick = "", alert="", },
			[51713] = {enabled=false, tick = "", alert="", },
			[91021] = {enabled=false, tick = "", alert="", },
			MasterVolume = false,
			OutOfCombat = false,			
			none = "none",
		},
	},  
}

SADefaults = {char = SADefault, realm = SADefault, profile = SADefault}
SAGlobals = {Version = SliceAdmiralVer}

SA_Data = {
	lastSort = 0,	-- Last time bars were sorted
	guile = 0,
	BladeFlurry = 0,
	buffer = 0,
	sortPeriod = 0.5, -- Only sort bars every sortPeriod seconds
	tNow = 0,
	BARS = { --TEH BARS
		["CP"] = {
			["obj"] = 0
		},
		["Stat"] = {
			["obj"] = 0,
		},
	}
};

local scaleUI = 0
local widthUI = 0

local UnitAffectingCombat = UnitAffectingCombat
local UnitAttackPower = UnitAttackPower
local UnitAttackSpeed = UnitAttackSpeed
local GetCritChance = GetCritChance
local lUnitMana = UnitMana
local lUnitManaMax = UnitManaMax
local UnitAura = UnitAura
local _,k,v,guileZero 
local bfhits = {}
local soundBuffer = {}
local sinister = true
local curCombo = 0

local Sa_filter = {	["player"] = "PLAYER", 
					["target"] = "PLAYER HARMFUL", };
					
local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function EnergyFade()
	local alpha = VTimerEnergy:GetAlpha()
	local eTransp = SAMod.Energy.EnergyTrans / 100.0
	
	if  (lUnitManaMax("player") == lUnitMana("player")) and not (alpha == eTransp) then
		UIFrameFadeOut(VTimerEnergy, 0.4, alpha, eTransp)
	elseif not (lUnitManaMax("player") == lUnitMana("player")) and not (alpha == 1.0) then
		UIFrameFadeIn(VTimerEnergy, 0.4, alpha, 1.0);
	end
	return
end

function addon:SA_SetScale(NewScale)
  if (NewScale >= 50) then
    SA:SetScale ( NewScale / 100 );
    VTimerEnergy:SetScale ( NewScale / 100 );	
	for k in pairs(SA_Data.BARS) do
		SA_Data.BARS[k]["obj"]:SetScale(NewScale/100);
	end
  end
end

function addon:SA_SetWidth(w)
  if (w >= 25) then
    VTimerEnergy:SetWidth(w);
	for k in pairs(SA_Data.BARS) do
		SA_Data.BARS[k]["obj"]:SetWidth(w);
	end	
	if SAMod.Energy.ShowEnergy then
		VTimerEnergy:Show();
		local lUnitManaMax = UnitManaMax("player")
		if (lUnitManaMax == 0) then
			lUnitManaMax = 100;
		end
		SA_Spark1:SetPoint("TOPLEFT", VTimerEnergy, "TOPLEFT", (SAMod.Energy.Energy1 / lUnitManaMax * w), 0);
		SA_Spark2:SetPoint("TOPLEFT", VTimerEnergy, "TOPLEFT", (SAMod.Energy.Energy2 / lUnitManaMax * w), 0);
	else
		VTimerEnergy:Hide();
	end
    addon:SA_UpdateCPWidths();
    addon:SA_UpdateStatWidths();
	
  end
end

function addon:RetextureBars(texture, object)
	if object == "Energy" then
		VTimerEnergy:SetStatusBarTexture(texture);
	end
	if object == "spells" then
		local bars =  SA_Data.BARS
		for k in pairs(bars) do
			if not (k == "CP" or k == "Stat") then
				bars[k]["obj"]:SetStatusBarTexture(texture);
			end	
		end
	end
	if object == "stats" then
		local combos = SA_Data.BARS["CP"]["obj"].combos
		SA_Data.BARS["CP"]["obj"].bg:SetTexture(texture);
		SA_Data.BARS["Stat"]["obj"].bg:SetTexture(texture);
		for i = 1, 5 do
			combos[i].bg:SetTexture(texture);
		end
	end	
end

function addon:SA_BarTexture(object)
	if object == "Energy" then
		return SAMod.Energy.BarTexture
	elseif object == "stats" then
		return SAMod.Main.BarTexture
	elseif object == "spells" then
		return SAMod.ShowTimer.Options.BarTexture
	else
		return SAMod.Main.BarTexture ;
	end
end

function addon:SA_Sound(saved,bufferd)
	if not UnitAffectingCombat("player") and not SAMod.Sound.OutOfCombat then return end
	if not saved then return end
	table.insert(soundBuffer,saved)
	if bufferd then
		C_Timer.After(0.3,addon.PlayBuffer)
	else
		addon:PlayBuffer()
	end
end

function addon:PlayBuffer()
	for k, v in pairs(soundBuffer) do
		if SAMod.Sound.MasterVolume then
			PlaySoundFile(v, "Master" );
		else
			PlaySoundFile(v);
		end
		table.remove(soundBuffer,k)
	end
end

function addon:SA_ChangeAnchor()
 local LastAnchor = VTimerEnergy;
 local offSetSize = SAMod.Main.BarMargin; -- other good values, -1, -2
 local GuileAnchor = LastAnchor
 local opt = SAMod.ShowTimer.Options
 local statsBar = SA_Data.BARS["Stat"]["obj"]
 local cpBar = SA_Data.BARS["CP"]["obj"]

 -- Stat bar goes first, because it's fucking awesome like that
 if SAMod.Combo.ShowStatBar then 
	statsBar:ClearAllPoints();
	statsBar:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize); 
 end

 --anchor CPs on stat bar if energy bar is hidden.
 if  not SAMod.Energy.ShowEnergy then
	LastAnchor = statsBar;
 end

 -- CP Bar --
 cpBar:ClearAllPoints(); --so it can move
 cpBar:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize); --CP bar on bottom of Stat Bar

 LastAnchor = statsBar; --timer bars grow off top of stat bar by default
 if opt.Barsup then
	if SAMod.Combo.ShowStatBar then
		LastAnchor = statsBar;
	else
		if SAMod.Energy.ShowEnergy then
			LastAnchor = VTimerEnergy;
			
		else
			LastAnchor = cpBar;
		end
	end
 else
	 if SAMod.Combo.PointShow then
		LastAnchor = cpBar;
	 else
		 if SAMod.Energy.ShowEnergy then
		 LastAnchor = VTimerEnergy;
			
		 else
			LastAnchor = statsBar;
		 end
	 end
 end	 
	 for i = 1, SA2.maxSortableBars do 
		local SortBar = SA_Data.BARORDER[i]
		 if (SortBar["Expires"] > 0) then
			SortBar["obj"]:ClearAllPoints();
			if opt.Barsup then
				SortBar["obj"]:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize); --bar on top
			else
				SortBar["obj"]:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize);
			end
			LastAnchor = SortBar["obj"];
		 end
	 end 
	for i = 1, SA2.topSortableBars do
		local SortBar = SA_Data.TOPORDER[i]
		if (SortBar["Expires"] > 0) then
			SortBar["obj"]:ClearAllPoints();
			if opt.Barsup then
				SortBar["obj"]:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize); --bar on top
			else
				SortBar["obj"]:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize);
			end
			LastAnchor = SortBar["obj"];
		 end
	end 
end

local function MB_SortBarsByTime(startIndex)
--[[ 
 Dumb ass sort. Simple shuffle of the lower bars to higher if
 they are refreshed. It will only run once every SA_Data.sortPeriod
 seconds, max. Also, we only call this if BARORDER contains a
 non-zero value for expiration. AND we start at the index we
 found the non-zero value at (because we know that the bars above
 that have 0 and we don't need to sort them).
 Also, we only call SA_ChangeAnchor() if something has changed to be
 a little lighter weight.
]]
	if ((SA_Data.tNow - SA_Data.lastSort) >= SA_Data.sortPeriod) then 
		table.sort(SA_Data.BARORDER, function(a,b) return a["Expires"] < b["Expires"] end)
		SA_Data.lastSort = SA_Data.tNow;
		addon:SA_ChangeAnchor();
	end
end

function addon:PET_BATTLE_OPENING_START()
	SA:Hide();
end

function addon:PET_BATTLE_CLOSE()
	SA:Show();
end

function addon:PLAYER_ENTERING_WORLD(...)
	addon:SA_TestTarget();
	VTimerEnergy:SetScript("OnHide", addon.SA_ChangeAnchor)
	VTimerEnergy:SetScript("OnShow", addon.SA_ChangeAnchor)	  
end

function addon:PLAYER_TARGET_CHANGED(...)
	addon:SA_TestTarget();
	addon:SA_SetComboPts("PLAYER_TARGET_CHANGED");	 
end

function addon:PLAYER_REGEN_DISABLED(...) --enter combat
	addon:SA_ResetBaseStats();
	UIFrameFadeIn(SA, 0.4, SA:GetAlpha(), 1.0);	
	if guileZero then
		guileZero:Cancel()
	end
end

function addon:resetGuile()	
	SA_Data.guile = 0; 
	addon:SA_UpdateStats();		
end

function addon:PLAYER_REGEN_ENABLED(...) --exit combat
	UIFrameFadeOut(SA, 0.4, SA:GetAlpha(), SAMod.Main.Fade/100)
	if SAMod.ShowTimer.Options.guileCount then
		guileZero = C_Timer.NewTimer(120,addon.resetGuile) --two minutes outsidecombat
	end
end

function addon:UNIT_COMBO_POINTS(...)
	addon:SA_SetComboPts("UNIT_COMBO_POINTS");
end

function addon:UNIT_AURA(event, ...)
	if ... == "player" then
		addon:SA_SetComboPts("UNIT_AURA");
	end
	if SAMod.Combo.ShowStatBar then
		addon:SA_UpdateStats();
	end  
end

function addon:UNIT_ATTACK_POWER(...)
	if SAMod.Combo.ShowStatBar then
		addon:SA_UpdateStats();
	end
end

function addon:UpdateBFText()
	SA_Data.BladeFlurry = tablelength(bfhits)
	bfhits = {}
	if SAMod.ShowTimer.Options.BladeFlurry and SA_Data.BFActive then
		SA_Data.BARS["Stat"]["obj"].stats[3].fs:SetText(SA_Data.BladeFlurry)
	end
end

local bfticker = C_Timer.NewTicker(10,addon.UpdateBFText)

function addon:UNIT_ATTACK_SPEED(...)
	if SAMod.Combo.ShowStatBar then
		addon:SA_UpdateStats();
	end	
	if SAMod.ShowTimer.Options.BladeFlurry then
		if bfticker then bfticker:Cancel() end
		local mhSpeed, ohSpeed = UnitAttackSpeed("player");
		bfticker = C_Timer.NewTicker(math.max(0.3,mhSpeed), addon.UpdateBFText)
	end
end

function addon:UNIT_POWER(...)
	if SAMod.Energy.ShowEnergy then
		EnergyFade()
	end
end

function addon:UNIT_MAXPOWER(...)
	if SAMod.Energy.ShowEnergy then
		VTimerEnergy:SetMinMaxValues(0,lUnitManaMax("player"));		
	end
end

function addon:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName = ...;
	local saTimerOp = SAMod.ShowTimer.Options
	local GetUnitName = GetUnitName
	local UnitName = UnitName
	local SA_Spells = SA_Spells
	local SABars = SA_Data.BARS
	if type =="UNIT_DIED" then
		soundBuffer = {}
	end
	if (type == "SPELL_AURA_REFRESH" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REMOVED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_PERIODIC_AURA_REMOVED" or type == "SPELL_PERIODIC_AURA_APPLIED" or type == "SPELL_PERIODIC_AURA_APPLIED_DOSE" or type == "SPELL_PERIODIC_AURA_REFRESH") then
		local spellId, spellName, spellSchool = select(12, ...);
		local isMySpell;
		isMySpell = (sourceName == UnitName("player")); 
		if (destName == UnitName("player")) then
			--Buffs EVENT --
			if SAMod.ShowTimer[spellId] then
				if (type == "SPELL_AURA_REMOVED") then 
					if SAMod.Sound[spellId].enabled then
						addon:SA_Sound(SAMod.Sound[spellId].alert,true)
					end
					SABars[SA_Spells[spellId].name]["Expires"] = 0;
					SABars[SA_Spells[spellId].name]["obj"]:Hide();
				else
					local name, rank, icon, count, debuffType, duration, expirationTime = UnitAura("player", SA_Spells[spellId].name);
					SABars[SA_Spells[spellId].name]["Expires"] = addon:CalcExpireTime(expirationTime);
					SABars[SA_Spells[spellId].name]["obj"]:Show();
					if saTimerOp.Dynamic then addon:UpdateMaxValue(spellId,duration) end
				end
				addon:SA_ChangeAnchor();
			end

			-- Anticipation event --
			if (spellId == SA_Spells[115189].id and SAMod.Combo.PointShow and type == "SPELL_AURA_REMOVED") then
				addon:SA_SetComboPts("SPELL_AURA_REMOVED");
			end
			-- BladeFlurry Switch --
			if spellId == 13877 and type == "SPELL_AURA_REMOVED" and saTimerOp.BladeFlurry then 
				SA_Data.BARS["Stat"]["obj"].stats[3].labelFrame.fs:SetText("Speed")
				SA_Data.BFActive = false
				bfticker:Cancel()
			elseif spellId == 13877 and type == "SPELL_AURA_APPLIED" and saTimerOp.BladeFlurry then
				SA_Data.BARS["Stat"]["obj"].stats[3].labelFrame.fs:SetText("Flurry")
				SA_Data.BFActive = true
				bfticker:Cancel()
				bfticker = C_Timer.NewTicker(2,addon.UpdateBFText)
			end
		else
			if (destName == GetUnitName("target",true)) then
				if isMySpell and SAMod.ShowTimer[spellId] then
					if (type == "SPELL_AURA_REMOVED") then 
						if SAMod.Sound[spellId].enabled then
							addon:SA_Sound(SAMod.Sound[spellId].alert,true)
						end
						SABars[SA_Spells[spellId].name]["Expires"] = 0;
						SABars[SA_Spells[spellId].name]["obj"]:Hide();
					else
						local name, rank, icon, count, debuffType, duration, expirationTime = UnitDebuff("target", SA_Spells[spellId].name, nil, "PLAYER");
						SABars[SA_Spells[spellId].name]["Expires"] = addon:CalcExpireTime(expirationTime);
						SABars[SA_Spells[spellId].name]["obj"]:Show();
						if saTimerOp.Dynamic then addon:UpdateMaxValue(spellId,duration) end
					end
					addon:SA_ChangeAnchor();
				end	
			end
		end
	end
	-- DOT monitors
	if (saTimerOp.ShowDoTDmg and (type == "SPELL_DAMAGE" or type == "SPELL_PERIODIC_DAMAGE" or type == "SPELL_PERIODIC_HEAL") and (destName == GetUnitName("target",true) or  destName == GetUnitName("player",true)) and sourceName == UnitName("player")) then
		local spellId, spellName, spellSchool = select(12, ...);
		if SAMod.ShowTimer[spellId] then
			local amount, overkill, school, resisted, blocked, absorbed, critical,_ = select(15, ...)
			local dotText = SA_Data.BARS[SA_Spells[spellId].name]["obj"].DoTtext
			
			dotText:SetAlpha(1);
			if (saTimerOp.DoTCrits and critical) then
				dotText:SetText(string.format("*%.0f*", amount));
				UIFrameFadeOut(dotText, 3, 1, 0);
			else
				dotText:SetText(amount);
				UIFrameFadeOut(dotText, 2, 1, 0);
			end
		end
	end
	if (type == "SPELL_DAMAGE") or (type == "SPELL_AURA_APPLIED") or (type == "SPELL_AURA_REMOVED") or (type == "SPELL_AURA_REFRESH") and saTimerOp.guileCount and (sourceName == UnitName("player")) then
	-- bandits guile--
		local spellId, spellName = select(12,...)
		local multistrike = select(25,...)
		if (spellId == 84745) or (spellId == 84746) or (spellId == 84747) or (spellId == 1752) and not (multistrike) then
			addon:GuileAdvance(spellId,type);
		end
		
	end
	if type=="SPELL_DAMAGE" and saTimerOp.BladeFlurry and (select(12,...) == 22482) then
		bfhits[destGUID] = true
	end
end

function addon:UpdateMaxValue(spellId,duration)
	if not SA_Spells[spellId] or not SA_Spells[spellId].dynamic then return end;
	local spelld = SA_Spells[spellId].duration
	if not duration then duration = spelld end;
	local dynvalue = duration*0.3
	
	if duration > spelld then
	 dynvalue = spelld*0.3
	end
	SA_Data.BARS[SA_Spells[spellId].name]["obj"]:SetMinMaxValues(0,dynvalue)
end

function addon:GuileAdvance(spellId,event)
	local insightBar = SA_Data.BARS["Stat"]["obj"].stats[4]
	if sinister and (spellId == 1752) then
		SA_Data.guile = SA_Data.guile + 1;
		addon:SA_UpdateStats()
	end
	if 	("SPELL_AURA_APPLIED" == event) then
		SA_Data.guile = 1
		sinister = false
		if (spellId == 84747) then
			SA_Data.guile = 0 
			insightBar.fs:Hide()
		end
	end
	if ("SPELL_AURA_REFRESH" == event) then
		SA_Data.guile = SA_Data.guile + 1;
	end
	if ("SPELL_AURA_REMOVED" == event) then
		SA_Data.guile = 0
		sinister = true
		if (spellId == 84747) then
			insightBar.fs:Show()
		end
	end	
end

function addon:SA_TestTarget()
	local showT = SAMod.ShowTimer
	local saBars = SA_Data.BARS
	
	for k,v in pairs(showT) do
		local spell = SA_Spells[k]
		if v and spell then
			local name, _, _, _, _, _, expirationTime, _ = UnitAura(spell.target, spell.name, nil, Sa_filter[spell.target]);
			if not (name) then
				saBars[spell.name]["Expires"] = 0;
				saBars[spell.name]["obj"]:Hide();
			else
				saBars[spell.name]["Expires"] = addon:CalcExpireTime(expirationTime);
				saBars[spell.name]["obj"]:Show();
			end
		end
	end
	addon:SA_ChangeAnchor(); 
end

function addon:GetComboPointsBufferd(event)
	local event = event or ""
	local points = GetComboPoints("player")
	local buffer = SA_Data.buffer or 0
	local cpTarget = UnitCanAttack("player","target")
	local gotCP = IsUsableSpell(5171)
	local gotTarget = UnitCanAttack("player","target")

	if cpTarget then
		SA_Data.buffer = points
		return points
	elseif ("UNIT_COMBO_POINTS" == event) and not cpTarget and not (buffer == 0) then
		SA_Data.buffer = buffer - 1 --should be every 10 sec outside combat
		return SA_Data.buffer
	elseif event == "PLAYER_TARGET_CHANGED" or event == "UNIT_AURA" then
		if gotCP then
			return buffer
		else
		   SA_Data.buffer = points
		   return points
		end
	end	
	return buffer or 0
end

function addon:SA_SetComboPts(event)
	local points = addon:GetComboPointsBufferd(event)
	local name, rank, icon, count = UnitAura("player", SA_Spells[115189].name)
	local cpBar = SA_Data.BARS["CP"]["obj"]
	count = count or 0
	local text = "0(0)"
	if count >= 0 and SAMod.Energy.AnticpationText and SAMod.Energy.ShowComboText then
		text = points .. "(" .. count.. ")"
	elseif count >= 0 and SAMod.Energy.AnticpationText then
		text = count
	else
		text = points
	end	
	if (SAMod.Energy.ShowComboText) or (SAMod.Energy.AnticpationText) then
		if (text == 0 or text == "0(0)") then
			SA_Combo:SetText("");
		else
			SA_Combo:SetText(text);
		end
	end
		
	if name and (count > 0) and SAMod.Combo.AnticipationShow then
		for i = 1, count do
			cpBar.antis[i]:Show();
		end	 
	else
		for i = 1, 5 do
			cpBar.antis[i]:Hide();
		end
	end
	if SAMod.Combo.PointShow then
		if (points > curCombo) then
			for i = curCombo + 1, points do
				cpBar.combos[i]:Show();
			end
		else
			for i = points + 1, curCombo do
				cpBar.combos[i]:Hide();
			end
		 end
		curCombo = points;
	end
end

function addon:SA_CPFrame()
	 local f = CreateFrame("Frame", nil, SA);
	 local width = widthUI --SA_Data.BARS["CP"]["obj"]:GetWidth();

	 f:ClearAllPoints();
	 f:SetWidth(width);
	 f:SetScale(scaleUI);
	 f:SetHeight(10); 
	 f:SetAllPoints(VTimerEnergy)
	 --f:SetPoint("TOPLEFT", VTimerEnergy, "BOTTOMLEFT", 1, 0);
	 
	 
	 f.bg = f:CreateTexture(nil, "BACKGROUND");
	 f.bg:ClearAllPoints();
	 --f.bg:SetAllPoints(f);
	 f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0);
	 f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0);
	 f.bg:SetTexture(addon:SA_BarTexture("stats"));
	 f.bg:SetVertexColor(0.3, 0.3, 0.3);
	 f.bg:SetAlpha(0.7);

	 f.combos = {};
	 f.antis = {};

	 local cx = 0;
	 local spacing = width/30; --orig:= 3
	 local cpwidth = ((width-(spacing*4))/9.2);

	 -- text
	 local font = "Fonts\\FRIZQT__.TTF";
	 local fontsize = 12;
	 local fontstyle = "OUTLINE";
	 local cpC = SAMod.Combo.CPColor
	 local cpA = SAMod.Combo.AnColor
	 local flvl = f:GetFrameLevel()
	 
	 for i = 1, 5 do
		local combo = CreateFrame("Frame", nil, f);
		combo:SetFrameLevel(flvl+1)
		combo:ClearAllPoints()
		combo:SetPoint("TOPLEFT", f, "TOPLEFT", cx, 0)
		combo:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cx + cpwidth, 0)

		combo:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			 edgeFile = "Interface/Tooltips/UI-Tooltip-Border", --"Interface/Tooltips/UI-Tooltip-Border"
			 tile = true, tileSize = 8, edgeSize = 8,
			 insets = { left = 2, right = 2, top = 2, bottom = 2 }});
		combo:SetBackdropColor( cpC.r, cpC.g, cpC.b);

		combo.bg = combo:CreateTexture(nil, "BACKGROUND") 
		combo:Hide()
		f.combos[i] = combo;
		
		cx = cx + cpwidth + spacing
	 end
	 cx = 0;
	 for i = 1, 5 do
		local anti = CreateFrame("Frame", nil, f);
		anti:SetFrameLevel(flvl+2); -- Better than f.combo[i] as parrent due to visibility
		anti:ClearAllPoints()
		anti:SetPoint("TOPLEFT", f, "TOPLEFT", cx, 0)
		anti:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cx + cpwidth, 0)

		anti:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			 edgeFile = "Interface/DialogFrame/UI-DialogBox-Gold-Border", --"Interface/Tooltips/UI-Tooltip-Border"
			 tile = true, tileSize = 8, edgeSize = 8,
			 insets = { left = 2, right = 2, top = 2, bottom = 2 }});
		anti:SetBackdropColor( cpA.r, cpA.g, cpA.b);

		anti.bg = anti:CreateTexture(nil, "BACKGROUND") 
		anti:Hide()
		f.antis[i] = anti;
		
		cx = cx + cpwidth + spacing
	 end

	 --f.overlay = CreateFrame("Frame", nil, f)
	 --f.overlay:ClearAllPoints()
	 --f.overlay:SetAllPoints(f)
	 f:Hide();
	 return f;
end

function addon:SA_UpdateCPWidths()
	local width = VTimerEnergy:GetWidth()
	local cx = 0;
	local spacing = width/30; --orig:= 3
	local cpwidth = ((width-(spacing*4))/5); --orig: ((width-(spacing*4))/5);

	local f = SA_Data.BARS["CP"]["obj"]
	local combo = SA_Data.BARS["CP"]["obj"].combos
	local anti = SA_Data.BARS["CP"]["obj"].antis
		
	for i = 1, 5 do
		combo[i]:ClearAllPoints()
		anti[i]:ClearAllPoints()
		combo[i]:SetPoint("TOPLEFT", f, "TOPLEFT", cx, 0)
		anti[i]:SetPoint("TOPLEFT", f, "TOPLEFT", cx, 0)
		combo[i]:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cx + cpwidth, 0)
		anti[i]:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cx + cpwidth, 0)

		cx = cx + cpwidth + spacing
	end
end

function addon:SA_UpdateStatWidths()
	local width = VTimerEnergy:GetWidth()

	local numStats = SA2.numStats or 3--HP TODO option for this
	local spacing = width/90;
	local cpwidth = ((width-(spacing*3))/(numStats));
	local cur_location = 0; --small initial offset

	local f = SA_Data.BARS["Stat"]["obj"];

	for i = 1, 4 do
		--Create the frame & space it
		local statText = SA_Data.BARS["Stat"]["obj"].stats[i];
		local labelFrame = SA_Data.BARS["Stat"]["obj"].stats[i].labelFrame;	
		statText:ClearAllPoints();
		statText:SetPoint("TOPLEFT", f, "TOPLEFT", cur_location, 0)
		statText:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cur_location + cpwidth, 0)

		labelFrame:ClearAllPoints();
		labelFrame:SetPoint("TOPLEFT", f, "TOPLEFT", cur_location, 0)
		labelFrame:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cur_location + cpwidth, 0)

		cur_location = cur_location + cpwidth + spacing;
		statText:Show()
		labelFrame:Show()
		if numStats < i then
			statText:Hide()
			labelFrame:Hide()
		end
	end
end

function addon:SA_CreateStatBar()
	local f = CreateFrame("StatusBar", nil, SA);
	local width = widthUI;

	f:ClearAllPoints();
	f:SetWidth(width);
	f:SetScale(scaleUI);
	f:SetHeight(15)
	f:SetPoint("BOTTOMLEFT", VTimerEnergy, "TOPLEFT", 0, 0) 

	f.bg = f:CreateTexture(nil, "BACKGROUND")
	f.bg:ClearAllPoints() 
	f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 1)
	f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, -1)
	f.bg:SetTexture(addon:SA_BarTexture("stats"))
	f.bg:SetVertexColor(0.3, 0.3, 0.3)
	f.bg:SetAlpha(0.7)

	f.stats = {}

	local numStats = SA2.numStats or 4; --HP TODO option for this
	local spacing = width/60;
	local cpwidth = ((width-(spacing*3))/(numStats));
	local cur_location = 1; --small initial offset

	-- text
	local font = "Fonts\\FRIZQT__.TTF"
	local fontsize = 9
	if (numStats > 3) then
		fontsize = 8;
	end

	local fontstyle = "OUTLINE"
	local lableText = {[1] = "AP",
						[2] = "Crit",
						[3] = "Speed",
						[4] = "Insight" }
	if SAMod.ShowTimer.Options.BladeFlurry and SA_Data.BFActive then lableText[3] = "Flurry" end
	for i = 1, 4 do	
		--Create the frame & space it
		local statText = CreateFrame("Frame", nil, f)
		statText:ClearAllPoints() 
		statText:SetPoint("TOPLEFT", f, "TOPLEFT", cur_location, 0)
		statText:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cur_location + cpwidth, 0)
		--Create stat FontString
		statText.fs = statText:CreateFontString("$parentText","ARTWORK","GameFontNormal");
		statText.fs:SetJustifyH("CENTER")
		statText.fs:SetJustifyV("TOP")
		statText.fs:SetFont(font, fontsize, fontstyle);
		statText.fs:SetAllPoints();
		statText.fs:SetText("");

		--Create stat label frame
		local labelFrame = CreateFrame("Frame", nil, f)	
		labelFrame:ClearAllPoints()
		labelFrame:SetPoint("TOPLEFT", f, "TOPLEFT", cur_location, 0) 
		----Create stat label FontString
		labelFrame.fs = labelFrame:CreateFontString("$parentText","ARTWORK","GameFontNormal");
		labelFrame.fs:SetJustifyH("CENTER")
		labelFrame.fs:SetJustifyV("BOTTOM")
		labelFrame.fs:SetFont(font, fontsize/1.6, "");
		labelFrame.fs:SetText(lableText[i]);
		labelFrame.fs:SetAllPoints(); 
		
		f.stats[i] = statText;
		f.stats[i].labelFrame = labelFrame;

		cur_location = cur_location + cpwidth + spacing;
	end

	return f;
end

function addon:SA_UpdateStats()
	local baseAP, buffAP, negAP = UnitAttackPower("player");
	local totalAP = baseAP+buffAP+negAP;
	local crit = GetCritChance();
	local mhSpeed, ohSpeed = UnitAttackSpeed("player");	 
	local guile = SA_Data.guile; 
	local barStats = SA_Data.BARS["Stat"]["obj"].stats
		
	if(totalAP > 99999) then 
		barStats[1].fs:SetText(string.format("%.1f", totalAP/1000).."k")
	else
		barStats[1].fs:SetText(totalAP);
	end
		
	barStats[2].fs:SetText(string.format("%.1f%%", crit));
	
	if SAMod.ShowTimer.Options.BladeFlurry and SA_Data.BFActive then
		barStats[3].fs:SetText(SA_Data.BladeFlurry)
	else
		barStats[3].fs:SetText(string.format("%.2f", mhSpeed));
	end
	
	if (barStats[4]) then
		barStats[4].fs:SetText(string.format("%s",SA_Data.guile));
	 end 
		
	if SAMod.Combo.HilightBuffed then
		addon:SA_flashBuffedStats(totalAP,buffAP,crit,mhSpeed,guile)
	end
end

function addon:SA_flashBuffedStats(totalAP,buffAP,crit,mhSpeed,guile) 
	local numStats = SA2.numStats or 3;
	if (not SA_Data.baseAP or SA_Data.baseAP == 0) then --initialize here since all stats = 0 when OnLoad is called.
		addon:SA_ResetBaseStats();
		return
	end

	local statCheck = {};
	statCheck[1] = ( (SA_Data.baseAP*2) < (totalAP - buffAP));
	statCheck[2] = (crit > (SA_Data.baseCrit * 1.5)) ;
	statCheck[3] = (mhSpeed < (SA_Data.baseSpeed / 1.5));
	statCheck[4] = (guile == 4 and UnitExists("target"));
	
	local barStats = SA_Data.BARS["Stat"]["obj"].stats
	 
	for i = 1, numStats do
		local alpha = barStats[i]:GetAlpha()
		if statCheck[i] then
		barStats[i].fs:SetTextColor(140/255, 15/255, 0);
			if (not UIFrameIsFading(barStats[i])) then --flash if not already flashing
				if (alpha > 0.5) then
					UIFrameFadeOut(barStats[i], 1, alpha, 0.1)
				else --UIFrameFlash likes to throw execeptions deep in the bliz ui?
					UIFrameFadeOut(barStats[i], 1, alpha, 1)
				end
			end
		else
			barStats[i].fs:SetTextColor(1, .82, 0); --default text color
			UIFrameFadeOut(barStats[i], 1, alpha, 1)
		end
	end
end

function addon:SA_NewFrame()
	 local f = CreateFrame("StatusBar", nil, SA);

	 f:SetWidth(widthUI);
	 f:SetScale(scaleUI);
	 f:SetHeight(12);
	 
	 f:SetPoint("BOTTOMLEFT", VTimerEnergy, "TOPLEFT", 2, 0);
	 
	 f:SetStatusBarTexture(addon:SA_BarTexture());
	 f:SetStatusBarColor(0.768627451, 0, 0, 1);
	 f:EnableMouse(false);
	 f:SetMinMaxValues(0, 6.0);
	 f:SetValue(0);

	 f:Hide();
	
	 f:SetBackdrop({
			 bgFile="Interface\\AddOns\\SliceAdmiral\\Images\\winco_stripe_128.tga",
			 edgeFile="",
			 tile=true, tileSize=1, edgeSize=0,
			 insets={left=0, right=0, top=0, bottom=0}
		 });
	 f:SetBackdropBorderColor(1,1,1,1);
	 f:SetBackdropColor(0,0,0,0.5);

	 -- text on the right --
	 if not f.text then
		f.text = f:CreateFontString(nil, nil, "GameFontWhite")
	 end
	 f.text:SetFontObject(SA_Data.BarFont2);
	 f.text:SetHeight(10)
	 f.text:SetWidth(30);
	 f.text:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2,0);
	 f.text:SetJustifyH("RIGHT") 
	 f.text:SetText("");

	 -- icon on the left --
	 if not f.icon then
		f.icon = f:CreateTexture(nil, "OVERLAY");
	 end
	 f.icon:SetHeight(f:GetHeight());
	 f.icon:SetWidth(f.icon:GetHeight());
	 f.icon:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0);
	 f.icon:SetBlendMode("ADD");
	 f.icon:SetAlpha(.99);

	 -- DoT Text --
	 if not f.DoTtext then
		f.DoTtext = f:CreateFontString(nil, nil, nil)
	 end
	 f.DoTtext:SetFontObject(SA_Data.BarFont2);
	 f.DoTtext:SetHeight(10)
	 f.DoTtext:SetWidth(60);
	 f.DoTtext:SetPoint("CENTER", f, "CENTER", 0 , 0);
	 f.DoTtext:SetJustifyH("CENTER")
	 f.DoTtext:SetText("");
	
	f:SetScript("OnHide", addon.SA_ChangeAnchor)
	f:SetScript("OnShow", addon.SA_ChangeAnchor)
	--f:SetScript("OnValueChanged", function(self,value) self.text:SetText(string.format("%0.1f", value)) end)
	 return f;

end

function addon:SA_ResetBaseStats()
	local baseAP, buffAP, negAP = UnitAttackPower("player");
	local crit = GetCritChance();
	local mhSpeed, ohSpeed = UnitAttackSpeed("player");

	SA_Data.baseAP = baseAP+buffAP;
	SA_Data.baseCrit = crit;
	SA_Data.baseSpeed = mhSpeed; 
end

function addon:SA_OnLoad()
	addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	addon:RegisterEvent("UNIT_COMBO_POINTS");
	addon:RegisterEvent("PLAYER_ENTERING_WORLD")
	addon:RegisterEvent("PLAYER_REGEN_ENABLED")
	addon:RegisterEvent("PLAYER_REGEN_DISABLED")
	addon:RegisterEvent("UNIT_AURA")
	addon:RegisterEvent("PLAYER_TARGET_CHANGED")
	addon:RegisterEvent("PET_BATTLE_CLOSE")
	addon:RegisterEvent("PET_BATTLE_OPENING_START")
	addon:RegisterEvent("UNIT_POWER")
	addon:RegisterEvent("UNIT_MAXPOWER")
	addon:RegisterEvent("UNIT_ATTACK_POWER")
	addon:RegisterEvent("UNIT_ATTACK_SPEED")
	SA_Data.BarFont = CreateFont("VTimerFont");
	SA_Data.BarFont:SetFont("Fonts\\FRIZQT__.TTF", 12);
	SA_Data.BarFont:SetShadowColor(0,0,0, 0.7);
	SA_Data.BarFont:SetTextColor(1,1,1,0.9);
	SA_Data.BarFont:SetShadowOffset(0.8, -0.8);
	
	SA_Data.BarFont2 = CreateFont("VTimerFont2");
	SA_Data.BarFont2:SetFont("Fonts\\FRIZQT__.TTF", 8)
	SA_Data.BarFont2:SetShadowColor(0,0,0, 0.7);
	SA_Data.BarFont2:SetTextColor(1,1,1,0.9);
	SA_Data.BarFont2:SetShadowOffset(0.8, -0.8);

	SA_Data.BarFont3 = CreateFont("VTimerFont1O");
	SA_Data.BarFont3:SetFont("Fonts\\FRIZQT__.TTF", 12);
	SA_Data.BarFont3:SetShadowColor(0,0,0, 1);
	SA_Data.BarFont3:SetTextColor(1,1,1,0.8);
	SA_Data.BarFont3:SetShadowOffset(0.8, -0.8);

	SA_Data.BarFont4 = CreateFont("VTimerFont4");
	SA_Data.BarFont4:SetFont("Fonts\\FRIZQT__.TTF", 8)
	SA_Data.BarFont4:SetShadowColor(0,0,0, 0.7); 
	SA_Data.BarFont4:SetShadowOffset(0.8, -0.8);

	VTimerEnergyTxt:SetFontObject(SA_Data.BarFont);
	SA_Combo:SetFontObject(SA_Data.BarFont3);

	VTimerEnergy:SetMinMaxValues(0,UnitManaMax("player"));
	VTimerEnergy:SetBackdrop({
				bgFile="Interface\\AddOns\\SliceAdmiral\\Images\\winco_stripe_128.tga",
				edgeFile="",
				tile=true, tileSize=1, edgeSize=0,
				insets={left=-1, right=-1, top=-1, bottom=0}
				});
		 
	VTimerEnergy:SetBackdropBorderColor(1,1,1,1);
	VTimerEnergy:SetBackdropColor(0,0,0,0.2);
	VTimerEnergy:SetStatusBarTexture(addon:SA_BarTexture("Energy"));
	VTimerEnergy:SetWidth(200);
	local oEner = SAMod.Energy.Color
	VTimerEnergy:SetStatusBarColor(oEner.r, oEner.g, oEner.b); 
	VTimerEnergy:SetScript("OnValueChanged",function(self,value)local mi, ma = self:GetMinMaxValues() if  (value == ma) then VTimerEnergyTxt:SetText("") else VTimerEnergyTxt:SetText(floor(value)) end end) 
	scaleUI = VTimerEnergy:GetScale();
	widthUI = VTimerEnergy:GetWidth();
		
	S:SmoothBar(VTimerEnergy);
		
	SA_Data.BARS["CP"]["obj"] = addon:SA_CPFrame();

	SA_Data.BARS["Stat"]["obj"] = addon:SA_CreateStatBar();
	local Sc = SAMod.ShowTimer.Colours
	
	for k in pairs(SA_Spells) do
		local color = Sc[k]
		local name = SA_Spells[k].name
		local icont = SA_Spells[k].icon
		local smax = SAMod.ShowTimer.Timers[k]
		
		if SA_Data.BARS[name] then
			SA_Data.BARS[name]["obj"] = addon:SA_NewFrame();
			SA_Data.BARS[name]["obj"]:SetStatusBarColor(color.r, color.g, color.b);
			SA_Data.BARS[name]["obj"].icon:SetTexture(icont);
			SA_Data.BARS[name]["obj"]:SetMinMaxValues(0,smax);
		end
	end

	SA_Data.BARORDER = {}; -- Initial order puts the longest towards the inside.
	SA_Data.TOPORDER = {};
	for k,v in pairs(SA_Spells) do
		if SA_Spells[k].sort then
			table.insert(SA_Data.BARORDER, SA_Data.BARS[SA_Spells[k].name])
		else
			table.insert(SA_Data.TOPORDER, SA_Data.BARS[SA_Spells[k].name])
		end
	end 
	
	SA2.maxSortableBars = tablelength(SA_Data.BARORDER)
	SA2.topSortableBars = tablelength(SA_Data.TOPORDER)
	if SAMod.Combo.ShowStatBar then
		addon:SA_UpdateStats();
	end
	print(string.format(L["SALoaded"], SliceAdmiralVer))
	if (SA) then
		addon:SA_Config_VarsChanged();
		addon:SA_Config_OtherVars();
		SA:SetAlpha(SAMod.Main.Fade/100);
	end
end

function addon:CalcExpireTime(expireTime)
	if expireTime and (expireTime > 0) and (SA_Data.tNow < expireTime) then 
		return expireTime - SA_Data.tNow;
	else
		return 0;
	end
end

function addon:SA_util_Time(unit, spell)
	local _, _, _, _, _, _, expirationTime = UnitAura(unit, spell, nil, Sa_filter[unit]);
	if expirationTime then
		return addon:CalcExpireTime(expirationTime);
	else
		return 0;
	end
end

local function SA_UpdateBar(unit, spell, sa_sound)
	local sa_time = addon:SA_util_Time(unit, spell);
	local sabars = SA_Data.BARS[spell]
	sabars["Expires"] = sa_time;
	
	if sa_time > 0 then
		if sabars then
			sabars["obj"]:SetValue(sa_time);
			sabars["obj"].text:SetText(string.format("%0.1f", sa_time));
		end
	else
		sabars["obj"]:Hide();	
		sabars["Expires"] = 0;
	end
	if (sa_time <= 3) and (sa_time > 0) then
		if (sabars["AlertPending"] == 3) then
			sabars["AlertPending"] = 2;
			addon:SA_Sound(sa_sound,false);
		else
			if sa_time <= 2 then
				 if (sabars["AlertPending"] == 2) then
					sabars["AlertPending"] = 1;
					addon:SA_Sound(sa_sound,false);
				 else
					if sa_time <= 1 then
						 if (sabars["AlertPending"] == 1) then
							sabars["AlertPending"] = 0;
							addon:SA_Sound(sa_sound,false);
						 end
					end
				 end
			end
		 end
	else
		sabars["AlertPending"] = 3;
	end
end

local function SA_QuickUpdateBar(unit, spell)
	local sa_time = addon:SA_util_Time(unit, spell);
	local sabars = SA_Data.BARS[spell]
	sabars["Expires"] = sa_time;
	
	if sa_time > 0 then
		if sabars then
			sabars["obj"]:SetValue(sa_time);
			sabars["obj"].text:SetText(string.format("%0.1f", sa_time));
		end
	else
		sabars["obj"]:Hide();
		sabars["Expires"] = 0;
	end	 
end

function addon:OnUpdate(elapsed)
SA2.TimeSinceLastUpdate = SA2.TimeSinceLastUpdate + elapsed;
if (SA2.TimeSinceLastUpdate > SA2.UpdateInterval) then	
	local SATimer = SAMod.ShowTimer
	
	if SAMod.Main.PadLatency then
		local down, up, lag = GetNetStats();
		SA_Data.tNow = GetTime() + (lag*2/1000);
	else
		SA_Data.tNow = GetTime();
	end 
	
	if SAMod.Energy.ShowEnergy then
		VTimerEnergy:SetValue(lUnitMana("player"));
	end
	
	for k,v in pairs(SATimer) do
		local spell = SA_Spells[k]
		local sound = SAMod.Sound[k]
		if v and sound and sound.enabled then
			SA_UpdateBar(spell.target,spell.name, sound.tick);
		elseif v and spell then
			SA_QuickUpdateBar(spell.target,spell.name);
		end
	end
	
	-- We need to do this sort here because something could have been
	-- auto refreshed by a proc and we don't get an Update event for that.
	-- But.. only do it once every SA_Data.sortPeriod seconds AND if we have
	-- non-zero timers 
	
	if SATimer.Options.SortBars then
		for i = 1, SA2.maxSortableBars do
			if (SA_Data.BARORDER[i]["Expires"] > 0) then
				MB_SortBarsByTime(i);
				break;
			end
		end
	end 
	SA2.TimeSinceLastUpdate = 0;
 end
end

function addon:SA_Config_VarsChanged()
	addon:SA_SetScale(SAMod.Main.Scale);
	addon:SA_SetWidth(SAMod.Main.Width);
	local eCo = SAMod.Energy.Color
	local cpC = SAMod.Combo.CPColor
	local cpA = SAMod.Combo.AnColor
	local SACombo = SAMod.Combo
	
	local combos = SA_Data.BARS["CP"]["obj"].combos; 
	local antis = SA_Data.BARS["CP"]["obj"].antis; 
						
	VTimerEnergy:SetStatusBarColor(eCo.r,eCo.g,eCo.b)
	for i = 1,5 do 
		combos[i]:SetBackdropColor(cpC.r,cpC.g,cpC.b); 
		antis[i]:SetBackdropColor(cpA.r,cpA.g,cpA.b)
	end;		
	
	if SAMod.Energy.ShowEnergy then
		VTimerEnergy:Show();		
	else
		VTimerEnergy:Hide();    
	end

	if not SACombo.PointShow and not SACombo.AnticipationShow  then   
		SA_Data.BARS["CP"]["obj"]:Hide();		
	else
		SA_Data.BARS["CP"]["obj"]:Show();		     		
	end
	if SAMod.Energy.ShowComboText then
		SA_Combo:Show();			
	else
		SA_Combo:Hide();
	end

	if SACombo.ShowStatBar then
		SA_Data.BARS["Stat"]["obj"]:Show();
	else
		SA_Data.BARS["Stat"]["obj"]:Hide();
	end

	addon:RetextureBars(addon:SA_BarTexture("spells"),"spells");
	addon:RetextureBars(addon:SA_BarTexture("Energy"),"Energy");
	addon:RetextureBars(addon:SA_BarTexture("stats"),"stats");
	addon:SA_Config_OtherVars();
end

function addon:SA_Config_OtherVars()
	local lManaMax = UnitManaMax("player");
	if (lManaMax == 0) then
		lManaMax = 100
	end
	local p1 = SAMod.Energy.Energy1 / lManaMax * SAMod.Main.Width;
	local p2 = SAMod.Energy.Energy2 / lManaMax * SAMod.Main.Width;

	SA_Spark1:SetPoint("TOPLEFT", VTimerEnergy, "TOPLEFT", p1, 0);
	SA_Spark2:SetPoint("TOPLEFT", VTimerEnergy, "TOPLEFT", p2, 0);
end

function addon:ResetConfig()
	addon.db:ResetProfile(false,true);
	ReloadUI();
end

function addon:OnInitialize()
	addon.db = LibStub("AceDB-3.0"):New("SliceAdmiralDB", SADefaults);
	addon.db.profile.playerName = UnitName("player")
	SAGlobal = addon.db.global
	SA2 = addon.db.profile.data
	SAMod = addon.db.profile.Modules
	addon.opt.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(addon.db);	
	addon.opt.Main.args = {
				version = {name = "SliceAdmiral "..L["Version"]..": "..GetAddOnMetadata("SliceAdmiral", "Version"),order=90,type = "header"},
				lockMovement = {name=L["ClickToMove"],type="toggle",order=1,		
					get = function(info) return SAMod.Main.IsLocked; end,
					set = function(info,val) SAMod.Main.IsLocked = val; SA:EnableMouse(not val); VTimerEnergy:EnableMouse( not val); end
				},
				padLatency = {name=L["PadLatency"],type="toggle",order=3, width="full",		
					get = function(info) return SAMod.Main.PadLatency; end,
					set = function(info,val) SAMod.Main.PadLatency = val; end
				},
				resetPost = {name=L["ResetPossition"], type = "execute", order=2,
					desc = L["ResetPositionDecs"],
					func = function()
						if (InCombatLockdown()) then 
							addon:Print(ERR_NOT_IN_COMBAT);
						else
							SA:ClearAllPoints();SA:SetPoint("TOPLEFT", 100, -150);
							SAMod.Main.point, _l, _l, SAMod.Main.xOfs, SAMod.Main.yOfs = SA:GetPoint()
						end
					end
				},
				mainInfo = {name = L["Main/info"], type = "description", order=4,width="full", },
				addonScale = {name=L["Main/Scale"],type="range",width="normal",order=11,
					min=50,max=200,step=1,
					get = function(info) return SAMod.Main.Scale; end,
					set = function(info,val) SAMod.Main.Scale = val; addon:SA_SetScale(val); end
				}, 
				barWidth = {name=L["Main/Width"],type="range",width="normal",order=12,
					min=25,max=300,step=5,
					get = function(info) return SAMod.Main.Width; end,
					set = function(info,val) SAMod.Main.Width = val; addon:SA_SetWidth(val); end
				},
				empty = {name="",type="description",order=13,},
				fade = {name=L["Main/oocFade"],type="range",width="normal",order=14,
					min=0,max=100,step=1,
					get = function(info) return SAMod.Main.Fade; end,
					set = function(info,val) SAMod.Main.Fade = val; SA:SetAlpha(val/100); end
				},
				barTexture = {name=L["Main/Texture"],type="select",order=15, dialogControl = 'LSM30_Statusbar',
					values = SA_BarTextures,
					get = function(info) return SA_Text[SAMod.Main.BarTexture]; end,
					set = function(info,val) SAMod.Main.BarTexture = SA_BarTextures[val]; addon:RetextureBars(SA_BarTextures[val],"stats"); end
				},
				reset = {name = L["ResetDatabase"],type = "execute",order=100,width="full",
					desc = L["ResetDatabaseDesc"],
					func = function()
						if (InCombatLockdown()) then 
							addon:Print(ERR_NOT_IN_COMBAT);
						else
							addon.db:ResetDB();
							ReloadUI();
						end
					end
				},
			}
	
	-- Add dual-spec support
	--local LibDualSpec = LibStub('LibDualSpec-1.0')
	--LibDualSpec:EnhanceDatabase(self.db, "SliceAdmiral")
	--LibDualSpec:EnhanceOptions(addon.opt.profile, self.db)
	-- Spec Setup
	addon.db.RegisterCallback(self, "OnNewProfile", "InitializeProfile")
	addon.db.RegisterCallback(self, "OnProfileChanged", "UpdateModuleConfigs")
	addon.db.RegisterCallback(self, "OnProfileCopied", "UpdateModuleConfigs")
	addon.db.RegisterCallback(self, "OnProfileReset", "UpdateModuleConfigs")
end

function addon:InitializeProfile()	
	self.db:RegisterDefaults(SADefaults)	
end

function addon:UpdateModuleConfigs()
	self.db:RegisterDefaults(SADefaults)	
end

function addon:AddOption(name, Table, displayName)
	AceConfig:RegisterOptionsTable("SliceAdmiral"..name, Table)
	AceConfigDialog:AddToBlizOptions("SliceAdmiral"..name, displayName, "SliceAdmiral")
end

function addon:OnEnable()
	AceConfig:RegisterOptionsTable("SliceAdmiral", addon.opt.Main)
	self.optionsFrame = AceConfigDialog:AddToBlizOptions("SliceAdmiral")	
	if addon:GetModule("ShowTimer", true) then addon:AddOption("ShowTimer Bars", addon.opt.ShowTimer, L["TimerBars"]) end	
    if addon:GetModule("Combo", true) then addon:AddOption("Combo Points", addon.opt.Combo, L["Combo"]) end
    if addon:GetModule("Energy", true) then addon:AddOption("Energy Bar", addon.opt.Energy, L["EnergyBar"]) end    
	--addon:AddOption("Profiles", addon.opt.profile, "Profiles"); --Localization Needed
	local localizedClass, englishClass = UnitClass("player");
	local point, xOfs, yOfs = SAMod.Main.point, SAMod.Main.xOfs, SAMod.Main.yOfs
	if (englishClass == "ROGUE") then
			for k in pairs(SA_Spells) do
			if not (k == 115189) then
				SA_Data.BARS[SA_Spells[k].name] = {	
						["obj"] = 0,
						["Expires"] = 0,		-- Actual time left to expire in seconds
						["AlertPending"] = 0, 		
				}
			end
		end
		addon:SA_OnLoad()
		SA:ClearAllPoints(); SA:SetPoint(point, xOfs, yOfs);
		SA:SetScript("OnUpdate", addon.OnUpdate);
		SA:SetScript("OnMouseDown", function(self) if (not SAMod.Main.IsLocked) then self:StartMoving() end end)
		SA:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing(); SAMod.Main.point, _l, _l, SAMod.Main.xOfs, SAMod.Main.yOfs = SA:GetPoint(); end )
		SA:EnableMouse(not SAMod.Main.IsLocked);
		VTimerEnergy:EnableMouse(not SAMod.Main.IsLocked);
		VTimerEnergy:SetScript("OnMouseDown", function(self) if (not SAMod.Main.IsLocked) then SA:StartMoving() end end)
		VTimerEnergy:SetScript("OnMouseUp", function(self) SA:StopMovingOrSizing(); SAMod.Main.point, _l, _l, SAMod.Main.xOfs, SAMod.Main.yOfs = SA:GetPoint(); end )	
		addon:SA_SetScale(SAMod.Main.Scale)
		addon:SA_SetWidth(SAMod.Main.Width)
		
	else
		addon:UnregisterAllEvents();
		SA:Hide();
		DisableAddOn("SliceAdmiral");
	end
end