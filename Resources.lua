-- Author      : Administrator
-- Create Date : 9/13/2008 10:16:36 AM
SA_Spells = { [5171] = { target = "player", sort = true,duration=36, pandemic=true,}, --Slice and Dice
	[73651] = { target = "player", sort = true, duration=30,pandemic=true, }, -- Recuperate
	[2818] = { target = "target", sort = false, duration=12,pandemic=true,}, --DeadlyPoison
	[1943] = { target = "target", sort = true,duration=24, pandemic=true, },  --Rupture
	[1966]  = { target = "player", sort = false,duration=5,pandemic=false, }, --Feint
	[703] = { target = "target", sort = true,duration=18, pandemic=true, }, --Garrote
	[115189] = { target = "player",sort = true,duration=15,pandemic=false, }, --Anticipation
	[137573] = { target = "player",sort = true,duration=4,pandemic=false, }, --BurstOfSpeed
	[154953] = { target = "target", sort = true,duration=12,pandemic=false, }, --InternalBleeding
	[79140] = { target = "target", sort=false,duration=20,pandemic=false, }, --Vendetta
	[32645] = { target = "player",sort = true,duration=6,pandemic=false,}, --Envenom
	[84617] = { target = "target", sort=true,duration=24,pandemic=true,}, --RevealingStrike
	[13750] = { target = "player",sort=true,duration=15,pandemic=false,}, --Adrenaline Rush
	[84745] = { target = "player",sort=false,duration=15,pandemic=false, }, --Guile Rank 1
	[84746] = { target = "player",sort=false,duration=15,pandemic=false,}, --Guile Rank 2
	[84747] = { target = "player",sort=false,duration=15,pandemic=false,}, --Guile Rank 3
	[16511] = { target = "target",sort=true,duration=24,pandemic=true, }, -- Hemorrhage	
	[122233] = { target="target",sort=true, duration=12,pandemic=false,}, --CrimsonTempest
	[51713] = { target = "player",sort=false,duration=8,pandemic=false,}, --ShadowDance
	[91021] = { target = "target",sort=true, duration=10,pandemic=false, }, -- FindWeaknes
	[157562] = { target = "player",sort=true, duration=6,pandemic=false, }, -- Crimson Poison
	[31665] = { target = "player",sort=true, duration=5,pandemic=false, }, -- Master of Subtlety
	[137586] = { target = "player", sort=true, duration=10, pandemic=false,}, --Shuriken Toss
	[61304] = { target = "player", sort=true, duration=1, pandemic=false,}, --GCD
	[137619] = { target= "target", sort=true, duration=60, pandemic=false,}, --Marked for Death
	[74001] = {target="player", sort=true, duration=10, pandemic = false,}, --Combat Rediness
	[408] = {target="target", sort=true, duration=6, pandemic=false,}, --Kidney Shot
	[26679] ={target="target", sort=true, duration=6, pandemic=false,}, --Deadly throw
	[31224] ={target="player", sort=true, duration=5, pandemic=false,}, --Cloak of Shadows
	[152151] = {target="player", sort=true, duration=8, pandemic=false,}, --Shadow Reflection --player
	[5277] = {target="player", sort=true, duration=10, pandemic=false,}, --Evasion
	[1776] = {target="target", sort=true, duration=4, pandemic=false,}, --Gouge
	[2983] =  {target="player", sort=true, duration=8, pandemic=false,}, --Sprint
	[2094] =  {target="target", sort=true, duration=60, pandemic=false,}, --Blind
	[115192] = {target="player", sort=false, duration=3, pandemic=false,}, --Subterfuge
	};

for k in pairs(SA_Spells) do
 local name, rank, icon, _ = GetSpellInfo(k)
 local desc = GetSpellDescription(k)
	SA_Spells[k].name = name
	SA_Spells[k].icon = icon
	SA_Spells[k].id = k	
	SA_Spells[k].desc = desc
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
