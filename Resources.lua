-- Author      : Administrator
-- Create Date : 9/13/2008 10:16:36 AM
--0 Shared 1 Assassination, 2 Combat, 3 Subtlety 4 Talents
SA_Spells = { [5171] = { target = "player", sort = true,duration=36, pandemic=true,spec=2,}, --Slice and Dice
	[2818] = { target = "target", sort = false, duration=12,pandemic=true,spec=1,}, --DeadlyPoison
	[1943] = { target = "target", sort = true,duration=24, pandemic=true, spec=1,},  --Rupture
	[1966]  = { target = "player", sort = false,duration=5,pandemic=false,spec=0, }, --Feint
	[703] = { target = "target", sort = true,duration=18, pandemic=true,spec=1, }, --Garrote
	--[137573] = { target = "player",sort = true,duration=4,pandemic=false,spec=4, }, --BurstOfSpeed
	[154953] = { target = "target", sort = true,duration=12,pandemic=false,spec=1, }, --InternalBleeding
	[79140] = { target = "target", sort=false,duration=20,pandemic=false,spec=1, }, --Vendetta
	[32645] = { target = "player",sort = true,duration=6,pandemic=false,spec=1,}, --Envenom
	[13750] = { target = "player",sort=true,duration=15,pandemic=false,spec=2,altId=186286,}, --Adrenaline Rush	\w T18 p2
	[186286] = { target = "player",sort=true,duration=4,pandemic=false,spec=2,hidden=true,}, --T18 2 set
	[16511] = { target = "target",sort=true,duration=24,pandemic=true,spec=1, }, -- Hemorrhage
	[91021] = { target = "target",sort=true, duration=10,pandemic=false,spec=3, }, -- FindWeaknes
	[31665] = { target = "player",sort=true, duration=5,pandemic=false,spec=3, }, -- Master of Subtlety
	[61304] = { target = "player", sort=true, duration=1, pandemic=false,spec=0,}, --GCD
	[137619] = { target= "target", sort=true, duration=60, pandemic=false,spec=4,}, --Marked for Death
	--[74001] = {target="player", sort=true, duration=10, pandemic = false,spec=4,}, --Combat Rediness
	[408] = {target="target", sort=true, duration=6, pandemic=false,spec=0,}, --Kidney Shot
	--[26679] ={target="target", sort=true, duration=6, pandemic=false,spec=4,}, --Deadly throw
	[31224] ={target="player", sort=true, duration=5, pandemic=false,spec=0,}, --Cloak of Shadows
	--[152151] = {target="player", sort=true, duration=8, pandemic=false,spec=4,}, --Shadow Reflection --player
	[5277] = {target="player", sort=true, duration=10, pandemic=false,spec=0,}, --Evasion
	[1776] = {target="target", sort=true, duration=4, pandemic=false,spec=2,}, --Gouge
	[2983] =  {target="player", sort=true, duration=8, pandemic=false,spec=0,}, --Sprint
	[2094] =  {target="target", sort=true, duration=60, pandemic=false,spec=0,}, --Blind
	[115192] = {target="player", sort=false, duration=3, pandemic=false,spec=4,}, --Subterfuge
	[8680] = {target="target", sort=false, duration=12, pandemic=false,spec=1,}, --Wound Poison
	[3409] = {target="target", sort=false, duration=12, pandemic=false,spec=1,}, --Crippling Poison
	[112947] = {target="target", sort=false, duration=6, pandemic=false,spec=4,}, --Nervestrike
	[199603] = {target="player", sort=false, duration=42, pandemic=true, spec=2,}, --RtB JollyRoger
	[193358] = {target="player", sort=false, duration=42, pandemic=true, spec=2,},
	[193357] = {target="player", sort=false, duration=42, pandemic=true, spec=2,},
	[193359] = {target="player", sort=false, duration=42, pandemic=true, spec=2,},
	[199600] = {target="player", sort=false, duration=42, pandemic=true, spec=2,},
	[193356] = {target="player", sort=false, duration=42, pandemic=true, spec=2,},
	[199754] = {target="player", sort=true, duration=42, pandemic=true, spec=2,}, --Riposte
	[185311] = {target="player", sort=false, duration=6, pandemic=true, spec=0,}, --Crimson Vial
	[206760] = {target="target", sort=true, duration=16, pandemic=true, spec=3,}, --Nightterror
	[195452] = {target="target", sort=true, duration=16, pandemic=true, spec=3,}, --Nightblade
	[185422] = {target="player", sort=true, duration=3, pandemic=true, spec=3,}, --Shadowdance
	[121471] = {target="player", sort=false, duration=12, pandemic=false, spec=3,}, --Shadow Blade
	[206237] = {target="player", sort=true, duration=36, pandemic=true, spec=3,}, --Enveloping Shadows
	[193641] = {target="player", sort=false, duration=5, pandemic=false, spec=1,}, --Elaborate Planing
	[3409] = {target="target", sort=false, duration=12, pandemic=false, spec=1,}, --Agonizing Poison
	[196937] = {target="target", sort=false, duration=15, pandemic=false, spec=2,}, --Ghostly Strike
	[212283] = {target="player",sort=false, duration=35, pandemic=false, spec=3,}, --Symbols of Death
	[195627] = {target="player", sort=false, duration=10, pandemic=false, spec=2,}, --QuickDraw/Oppurtunity
	};

for k in pairs(SA_Spells) do
 local name, rank, icon, _ = GetSpellInfo(k)
 if not name then print(k) end
	SA_Spells[k].name = name or "none"..k
	SA_Spells[k].icon = icon or "blank"
	SA_Spells[k].id = k
end

local LSM = LibStub("LibSharedMedia-3.0")
local SA_BarTextures = {
  ["Aluminium"] = "Interface\\AddOns\\SliceAdmiral\\Images\\Aluminium.tga",
  ["BantoBar"] = "Interface\\AddOns\\SliceAdmiral\\Images\\BantoBar.tga",
  ["Gloss"] = "Interface\\AddOns\\SliceAdmiral\\Images\\Gloss.tga",
  ["Healbot"] = "Interface\\AddOns\\SliceAdmiral\\Images\\HealBot.tga",
  ["LiteStep"] = "Interface\\AddOns\\SliceAdmiral\\Images\\LiteStep.tga",
  ["Runes"] = "Interface\\AddOns\\SliceAdmiral\\Images\\Runes.tga",
  ["Smooth"] = "Interface\\AddOns\\SliceAdmiral\\Images\\Smooth.tga",
};
for k,v in pairs(SA_BarTextures) do 
	LSM:Register("STATUSBAR", k, v)	
end

local SA_Sounds = {
  ["Price is WRONG"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\PriceIsWrong.ogg",
  ["Waaaah"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\Old Trumpet A 01.ogg",
  ["BassDrum"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\6OP00084.ogg",
  ["Tambourine"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\tambourine.ogg",
  ["Cowbell"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\cowtown.ogg",
  ["SliceClick"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\FXHit15.ogg",
  ["BoomBoomClap"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\HoleA.ogg",
  ["Marching Band"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\OldDrums2.ogg",
  ["High Hat 4"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\perc09_HH.ogg",
  ["BoomBoomThak"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\RawB.ogg",
  ["Arpeggiator C2"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\Arp31-C2.ogg",
  ["Arpeggiator C3"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\Arp31-C3.ogg",
  ["Arpeggiator C4"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\Arp31-C4.ogg",
  ["ScratchShot"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\ScratchShot.ogg",
  ["StunningHit"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\StunningHit.ogg",
  ["DNBLoop4"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\DNBLoop4.ogg",
  ["DNBLoop2"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\DNBLoop2.ogg",
  ["Scratch4"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\Scratch4.ogg",
  ["You Spin Me"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\youspin.ogg",
  ["What's the Deal?"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\whats-the-deal.ogg",
  ["ClubBeatJ"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\ClubBeatJ.ogg",
  ["Growl"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\growl.ogg",
  ["OH YEAH"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\OH-YEAH.ogg",
  ["Shaker"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\shaker.ogg",
  ["Pop"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\pop.ogg",
  ["Drum Rattle"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\drumrattle.ogg",
  ["Ping"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\pingit.ogg",
  ["Switch On/Off"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\switch-on-off.ogg",
  ["Eth Perc Short"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\perc-short.ogg",
  ["Eth Perc Long"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\perc-long.ogg",
  ["None"] = "Interface\Quiet.ogg",
};

for k,v in pairs(SA_Sounds) do
	LSM:Register("SOUND", k,v)	
end
