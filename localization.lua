-- Author      : cgiguy
-- Create Date : 7/19/2011

SA_Spells = { [5171] = { target = "player", sort = true,duration=36, dynamic=true,}, --Slice and Dice
	[73651] = { target = "player", sort = true, duration=30,dynamic=true, }, -- Recuperate
	[2818] = { target = "target", sort = false, duration=12,dynamic=true,}, --DeadlyPoison
	[1943] = { target = "target", sort = true,duration=24, dynamic=true, },  --Rupture
	[1966]  = { target = "player", sort = false,duration=5,dynamic=false, }, --Feint
	[703] = { target = "target", sort = true,duration=18, dynamic=true, }, --Garrote
	[115189] = { target = "player",sort = true,duration=15,dynamic=false, }, --Anticipation
	[137573] = { target = "player",sort = true,duration=4,dynamic=false, }, --BurstOfSpeed
	[154953] = { target = "target", sort = true,duration=12,dynamic=false, }, --InternalBleeding
	[79140] = { target = "target", sort=false,duration=20,dynamic=false, }, --Vendetta
	[32645] = { target = "player",sort = true,duration=6,dynamic=false,}, --Envenom
	[84617] = { target = "target", sort=true,duration=24,dynamic=true,}, --RevealingStrike
	[13750] = { target = "player",sort=true,duration=15,dynamic=false,}, --Adrenaline Rush
	[84745] = { target = "player",sort=false,duration=15,dynamic=false, }, --Guile Rank 1
	[84746] = { target = "player",sort=false,duration=15,dynamic=false,}, --Guile Rank 2
	[84747] = { target = "player",sort=false,duration=15,dynamic=false,}, --Guile Rank 3
	[16511] = { target = "target",sort=true,duration=24,dynamic=true, }, -- Hemorrhage	
	[122233] = { target="target",sort=true, duration=12,dynamic=false,}, --CrimsonTempest
	[51713] = { target = "player",sort=false,duration=8,dynamic=false,}, --ShadowDance
	[91021] = { target = "target",sort=true, duration=10,dynamic=false, }, -- FindWeaknes
	[157562] = { target = "player",sort=true, duration=6,dynamic=false, }, -- Crimson Poison
	[31665] = { target = "player",sort=true, duration=5,dynamic=false, }, -- Master of Subtlety
	};

for k in pairs(SA_Spells) do
 local name, rank, icon, _ = GetSpellInfo(k)
	SA_Spells[k].name = name
	SA_Spells[k].icon = icon
	SA_Spells[k].id = k	
end
	
local L = LibStub("AceLocale-3.0"):NewLocale("SliceAdmiral", "enUS", true)
L["SALoaded"] = "SliceAdmiral %s loaded!! Options are under the SliceAdmiral tab in the Addons Interface menu"
L["ClickToMove"] = "Disable Click to Move"
L["PadLatency"] = "Pad Alerts with Latency"
L["ResetPossition"] = "Reset Position"
L["ResetPositionDecs"] = "Resets SliceAdmiral's position to upper left."
L["Main/info"] = "Click the + next to 'SliceAdmiral' in the list to the left for more options."
L["Main/Scale"] = "AddOn Scale"
L["Main/Width"] =  "Bar Width"
L["Main/oocFade"] = "Out of Combat Fade"
L["Main/Texture"] = "Bar Texture"
L["Main/Hide"] = "Hide outside combat"

L["Version"] = "Version"
L["TimerBars"] = "Timer Bars"
L["Combo"] = "Combo Points and Stats"
L["EnergyBar"] = "Energy Bar"
L["SoundEffects"] = "Sound Effects"
L["ResetDatabase"] = "Reset Database"
L["ResetDatabaseDesc"] = "Will Reset the Entire Database. This Should Fix most problems."

L["timer/dynamic"] = "Dynamic Timers"
L["timers/dynamic/desc"] = "Timers will start to decrease at 30% of their full duration. Does not work for certain abilities."
L["bar/prep"] = "Statusbar Countdown." --need new name
L["SoundSettings"] = "Sound Settings"
L["TickSound"] = "Tick Sound"
L["AlertSound"] = "Alert Sound"
L["alerts/enabled"] = "Enable Sounds"
L["SharedAbilites"] = "Shared Abilities"
L["Assassination"] = "Assassination"
L["Combat"] = "Combat"
L["Subtlety"]= "Subtlety"

L["BanditsGuile"] = "Bandit's Guile"

L["ShowBar"] = "Show timer bar"
L["SliceNDice/Seconds"] = ""

L["Bars/GrowUp"] = "Bars grow up"
L["Bars/Sort"] = "Sort bars by duration"
L["Bars/ShowDoT"] = "Show DoT ticks"
L["Bars/DoTCrit"] = "Highlight DoT crits"
L["bars/color"] = "Bar Color"
L["bars/tickCd"] = "Tick Countdown"

L["Sound/MasterVolume"] = "Use Master Volume."
L["Sound/MasterDesc"] = "Play sound when sound effects are disabled."
L["Sound/OutOfCombat"] = "Play sound outside of combat."
L["Sound/Preview"] = "Pre-play Sound in options menu."

L["Frames/Custom"] = "Custom"
L["Frames/Tank"]=  "Tanky"
L["Frames/DPS"] = "DIPS"
L["Frames/Healer"] = "HolY"

L["combo/Show"] = "Show Combo Points"
L["tShow/anticipation"] = "Show Anticipation"
L["combo/statsheader"] = "Stats Bar Settings"
L["combo/showStats"] = "Show Stat Bar"
L["combo/megabuff"] = "Highlight when mega-buffed"
L["combo/armor"] = "Show Bandit's Guile Advancement"
L["combo/guile/desc"] = "Show counter on the statsbar for next advancement on Bandit's Guile"
L["ComboA/Color"] = "Anticipation Colour"
L["Combo/Color"] = "ComboPoints Colour"
L["combo/bf"] = "Blade Flurry target counter"
L["combo/bf/desc"] = "Replace Attack Speed with a Blade Flurry target counter. This only happens when you activate Blade Flurry."

L["energy/Show"] = "Show Energy Bar"
L["energy/ShowCombo"] = "Show Combopoint text"
L["energy/ShowAnti"] = "Show Anticipation text"
L["energy/mark1"] = "Energy Marker 1"
L["energy/mark2"] = "Energy Marker 2"
L["energy/transp"] = "Energy Transperancy"
L["energy/Color"] = "Energy Bar Colour"
L["energy/TextColor"] = "Energy Text Colour"
L["energy/CoTextColor"] = "Combo Point Text Color"
