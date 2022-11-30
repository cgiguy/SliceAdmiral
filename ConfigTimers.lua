local sliceadmiral = LibStub("AceAddon-3.0"):GetAddon("SliceAdmiral");
local L = LibStub("AceLocale-3.0"):GetLocale("SliceAdmiral", true);
local addon = sliceadmiral:NewModule("ShowTimer");
local LSM = LibStub("LibSharedMedia-3.0")

local function pandemic(val)
	local options = sliceadmiral.opt.ShowTimer
	local opt
	for k in pairs(SA_Spells) do
		if not SA_Spells[k].hidden then
		if SA_Spells[k].spec == 0 then
			opt = options.args.Shared.args
		elseif SA_Spells[k].spec == 1 then
			opt = options.args.Assassination.args
		elseif SA_Spells[k].spec == 2 then
			opt = options.args.Combat.args
		elseif SA_Spells[k].spec == 3 then 
			opt = options.args.Subtlety.args
		elseif SA_Spells[k].spec == 4 then
			opt = options.args.Talents.args
		end	
		if val then
			opt[SA_Spells[k].name].args.values.disabled = SA_Spells[k].pandemic
		else
			opt[SA_Spells[k].name].args.values.disabled = false
		end
		end
	end
end

function addon:OnInitialize()
local options = sliceadmiral.opt.ShowTimer 
local col = SAMod.ShowTimer.Colours
local BanditsGuilLocal, _ =  GetSpellInfo(84654)
local SPECS = {} --1 Assassination, 2 Combat, 3 Subtlety
for i = 1,3 do
	local _,SPEC,_ = GetSpecializationInfoForClassID(4,i);
	SPECS[i] = SPEC;
end

options.childGroups="tab";
options.args = { 
			GrowUp = {name=L["Bars/GrowUp"],type="toggle",order=1,
				get = function(info) return SAMod.ShowTimer.Options.Barsup; end,
				set = function(info,val) SAMod.ShowTimer.Options.Barsup = val; end
			},
			Sort = {name=L["Bars/Sort"],type="toggle",order=2,
				get = function(info) return SAMod.ShowTimer.Options.SortBars; end,
				set = function(info,val) SAMod.ShowTimer.Options.SortBars = val; end
			},
			Dynamic = {name=L["timer/dynamic"],desc=L["timers/dynamic/desc"], type="toggle",order=3,
				get = function(info) return SAMod.ShowTimer.Options.Dynamic; end,
				set = function(info,val) SAMod.ShowTimer.Options.Dynamic = val; pandemic(val); end, 
			},
			ShowDoT = {name=L["Bars/ShowDoT"],type="toggle",order=4,
				get = function(info) return SAMod.ShowTimer.Options.ShowDoTDmg; end,
				set = function(info,val) SAMod.ShowTimer.Options.ShowDoTDmg = val; end
			},
			DoTCrit = {name=L["Bars/DoTCrit"],type="toggle",order=5,
				get = function(info) return SAMod.ShowTimer.Options.DoTCrits; end,
				set = function(info,val) SAMod.ShowTimer.Options.DoTCrits = val; end
			},
			barTex = {name=L["Main/Texture"], type="select",order=6,dialogControl = 'LSM30_Statusbar',
				values = LSM:HashTable("statusbar"),
				get = function(info) return SAMod.ShowTimer.Options.BarTexture; end,
				set = function(info,val) SAMod.ShowTimer.Options.BarTexture = val, sliceadmiral:RetextureBars(LSM:Fetch("statusbar",val), "spells") end, 
			},
			MasterVolume = {name=L["Sound/MasterVolume"],desc=L["Sound/MasterDesc"],type="toggle",order=7,width="full",		
				get = function(info) return SAMod.Sound.MasterVolume; end,
				set = function(info,val) SAMod.Sound.MasterVolume = val; end
			},
			OutOfCombat = {name=L["Sound/OutOfCombat"],type="toggle",order=8,width="double",
				get = function(info) return SAMod.Sound.OutOfCombat; end,
				set = function(info,val) SAMod.Sound.OutOfCombat = val; end
			},
			Spellnames = {name=L["Bars/SpellNames"],desc=L["Bars/Spellnames/Desc"],type="toggle",order=10,
				get = function(info) return SAMod.ShowTimer.Options.ShowNames; end,
				set = function(info,val) SAMod.ShowTimer.Options.ShowNames = val; end
			},
			Shared = {name=L["SharedAbilites"],type="group",order=20,childGroups="tree",args={},},
			Assassination = {name=SPECS[1],type="group",order=30,childGroups="tree",args={},},
			Combat = {name=SPECS[2],type="group",order=40,childGroups="tree",args={},},
			Subtlety ={name=SPECS[3],type="group",order=50,childGroups="tree",args={},},
			Talents ={name=TALENTS,type="group",order=60,childGroups="tree",args={},},
		}
		
	local GetSpellDescription = GetSpellDescription
	for k in pairs(SA_Spells) do
		if not SA_Spells[k].hidden then
		if SA_Spells[k].spec == 0 then
			opt = options.args.Shared.args
		elseif SA_Spells[k].spec == 1 then
			opt = options.args.Assassination.args
		elseif SA_Spells[k].spec == 2 then
			opt = options.args.Combat.args
		elseif SA_Spells[k].spec == 3 then 
			opt = options.args.Subtlety.args
		elseif SA_Spells[k].spec == 4 then
			opt = options.args.Talents.args
		end	
		opt[SA_Spells[k].name] = {name=SA_Spells[k].name,desc=function(info) return GetSpellDescription(k); end, type="group",
			args = {
				enable = {name=L["ShowBar"],type="toggle", order=1,
					get = function(info) return SAMod.ShowTimer[k]; end,
					set = function(info,val) SAMod.ShowTimer[k] = val; if (SA_Spells[k].altId) then SAMod.ShowTimer[SA_Spells[k].altId] = val; end; end
				},
				sEnabled = {name=L["alerts/enabled"],type="toggle",order=2,
					get = function(info) return SAMod.Sound[k].enabled; end,
					set = function(info,val) SAMod.Sound[k].enabled = val; if (SA_Spells[k].altId) then SAMod.ShowTimer[SA_Spells[k].altId] = val; end; end,
				},
				values = {name=L["bar/prep"], type="range", order=3,
					min=1.0,max=math.min(15.0,math.max(3,SA_Spells[k].duration)), step=0.5,
					get = function(info) return SAMod.ShowTimer.Timers[k]; end,
					set = function(info,val) 
						SAMod.ShowTimer.Timers[k] = val; 
						SA_Data.BARS[SA_Spells[k].name]["obj"]:SetMinMaxValues(0,val); end,
				},
				texColor = { name=L["bars/color"], type="color", order=4,
					get = function(info) return col[k].r, col[k].g,col[k].b; end,
					set = function(info, r,g,b,a) SA_Data.BARS[SA_Spells[k].name]["obj"]:SetStatusBarColor(r, g, b); col[k].r = r; col[k].g = g; col[k].b = b;if (SA_Spells[k].altId) then col[SA_Spells[k].altId].r = r; col[SA_Spells[k].altId].b=b;col[SA_Spells[k].altId].g=g;end;end,
				},
				bar1 = {name=L["SoundSettings"],type="header",order=5},
				tick = {name=L["TickSound"],type="select",order=12, dialogControl = 'LSM30_Sound',
					values = LSM:HashTable("sound"),
					get = function(info) return SAMod.Sound[k].tick; end,
					set = function(info,val) SAMod.Sound[k].tick = val; if (SA_Spells[k].altId) then SAMod.Sound[SA_Spells[k].altId].tick = val; end; end,
				},
				alert = {name=L["AlertSound"],type="select",order=13, dialogControl = 'LSM30_Sound',
					values = LSM:HashTable("sound"),
					get = function(info) return SAMod.Sound[k].alert; end,
					set = function(info,val) SAMod.Sound[k].alert = val; if (SA_Spells[k].altId) then SAMod.Sound[SA_Spells[k].altId].alert = val; end;end,
				},
				tickCd = {name=L["bars/tickCd"], type="range", order=14,
					min=1.0,max=SA_Spells[k].duration, step=1.0,
					get = function(info) return SAMod.Sound[k].tickStart; end,
					set = function(info,val) SAMod.Sound[k].tickStart = val; if (SA_Spells[k].altId) then SAMod.Sound[SA_Spells[k].altId].tickStart = val; end;  end,
				},
			},
		}
		end
	end
	
	options.args.Subtlety.args[SA_Spells[SID_RUPTURE].name] = options.args.Assassination.args[SA_Spells[SID_RUPTURE].name];
	options.args.Subtlety.args[SA_Spells[SID_DEADLY_POISON].name] = options.args.Assassination.args[SA_Spells[SID_DEADLY_POISON].name];

	pandemic(SAMod.ShowTimer.Options.Dynamic)
	
end
