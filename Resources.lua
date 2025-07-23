-- Author      : Haghala/cgiguy
-- Create Date : 9/13/2008 10:16:36 AM

-- cgiguy: I don't like "random" numbers in code.  So, define a few Spell IDs
-- that we use here.  Note: If they change, you need to change these!

SliceAdmiral = {}

local flavorFromToc = C_AddOns.GetAddOnMetadata("SliceAdmiral", "X-Flavor")
local flavorFromTocToNumber = {
  Vanilla = 1,
  TBC = 2,
  Wrath = 3,
  Cata = 4,
  MoP = 5,
  Mainline = 10
}
local flavor = flavorFromTocToNumber[flavorFromToc]

function SliceAdmiral.IsClassicEra()
  return flavor == 1
end

function SliceAdmiral.IsWrathClassic()
  return flavor == 3
end

function SliceAdmiral.IsCataClassic()
  return flavor == 4
end

function SliceAdmiral.IsMoPClassic()
  return flavor == 5
end

function SliceAdmiral.IsRetail()
  return flavor == 10
end

function SliceAdmiral.IsClassicEraOrWrath()
  return SliceAdmiral.IsClassicEra() or SliceAdmiral.IsWrathClassic()
end

function SliceAdmiral.IsClassicEraOrCata()
  return SliceAdmiral.IsClassicEra() or SliceAdmiral.IsCataClassic()
end

function SliceAdmiral.IsWrathOrRetail()
  return SliceAdmiral.IsRetail() or SliceAdmiral.IsWrathClassic()
end

SID_SUBTERFUGE = 115192;        -- Subterfuge
SID_SND = 5171;			-- Slice and Dice
SID_RUPTURE = 1943;		-- Rupture
SID_FEINT = 1966;		-- Feint
SID_GARROTE = 703;		-- Garrote
-- SID_ANTICIPATION = 115189;	-- (this is probably wrong should be 114015)
--SID_ANTICIPATION = 114015;	-- Anticipation
SID_BURST_SPEED = 137573;	-- Burst of Speed
SID_INTERNAL_BLEEDING = 154953;	-- Internal Bleeding
SID_VENDETTA = 79140;		-- Vendetta
SID_DEATHMARK = 394331;         -- Deathmark
SID_ENVENOM = 32645;		-- Envenom
SID_ADRENALINE_RUSH = 13750;	-- Adrenaline Rush
SID_ADRENALINE_RUSH_T18 = 186286; -- Adrenaline Rush (w/ T18)
SID_HEMORRHAGE = 16511;	        -- Hemorrhage
SID_FIND_WEAKNESS = 91021;	-- Find Weakness
SID_MASTER_SUBTLETY = 31665;	-- Master of Subtlety
SID_GCD = 61304;		-- Global Cooldown
SID_MARKED_FOR_DEATH = 137619;  -- Marked for Death
SID_COMBAT_READINESS = 74001;	-- Combat Readiness
SID_KIDNEY_SHOT = 408;		-- Kidney Shot
SID_DEADLY_THROW = 26679;	-- Deadly Throw
SID_CLOAK_SHADOWS = 31224;	-- Cloak of Shadows
SID_SHADOW_REFLECTION = 152151;	-- Shadow Reflection
SID_EVASION = 5277;		-- Evasion
SID_GOUGE = 1776;		-- Gouge
SID_SPRINT = 2983;		-- Sprint
SID_BLIND = 2094;		-- Blind

SID_DEADLY_POISON = 2818;       -- Deadly Poison
SID_DEADLY_POISON_NEW = 113780; -- Deadly Poison (alt)
SID_BLADE_FLURRY = 13877;	-- Blade Flurry
SID_STEALTH = 1784;		-- Stealth
SID_STEALTH_NEW = 115191;	-- Stealth (alt)
SID_GHOSTLY_STRIKE = 196937;	-- Ghostly Strike
SID_HONOR_AMONG_THIEVES = 51699; -- Honor Among Thieves
SID_BACKSTAB = 53;		 -- Backstab
SID_AMBUSH = 8676;		 -- Ambush
SID_WOUND_POISON = 8680;	 -- Wound Poison
SID_CRIPPLING_POISON = 3409;	 -- Crippling Poison
SID_NERVE_STRIKE = 112947;	 -- Nerve Strike
SID_ROLL_BONES = 199603;	 -- Roll the Bones
SID_GRAND_MELEE = 193358;	 -- RtB Grand Melee
SID_SHARK_INFESTED = 193357;	 -- RtB Shark Infested Waters
SID_TRUE_BEARING = 193359;	 -- RtB True Bearing
SID_BURIED_TREASURE = 199600;	 -- RtB Buried Treasure
SID_BROADSIDE = 193356;		 -- RtB Broadside
SID_RIPOSTE = 199754;		 -- Riposte
SID_CRIMSON_VIAL = 185311;	 -- Crimson Vial
SID_NIGHT_TERRORS = 206760;	 -- Night Terrors
SID_NIGHTBLADE = 195452;	 -- Nightblade
SID_SHADOW_DANCE = 185422;	 -- Shadow Dance
SID_SHADOW_BLADES = 121471;	 -- Shadow Blades
SID_ELABORATE_PLANNING = 193641; -- Elaborate Planning
SID_SYMBOLS_DEATH = 212283;	 -- Symbols of Death
SID_OPPORTUNITY = 195627;	 -- Opportunity
SID_ALACRITY = 193538;		 -- Alacrity
SID_BETWEEN_EYES = 315341;	 -- Between the Eyes
SID_BLADE_RUSH = 271877;	 -- Blade Rush
if SliceAdmiral.IsClassicEra() then
  SID_CRIMSON_TEMPEST = 436611;	 -- Crimson Tempest Rune
else
  SID_CRIMSON_TEMPEST = 121411;    -- Crimson Tempest
end
SID_TOXIC_BLADE = 245389;        -- Toxic Blade
SID_DREADBLADES = 343142;        -- Dreadblades
SID_SEPSIS = 328305;             -- Sepsis (Covenant)
SID_SEPSIS_STEALTH = 347037      -- Sepsis (Stealth component)
SID_SHIV = 319504;               -- Shiv 
SID_KINGSBANE = 385627           -- Kingsbane
SID_BLADEDANCE = 400012          -- Blade Dance Rune (Classic SOD)
SID_RECUPERATE = 73651         -- Recuperate (Cataclysm Classic)


--0 Shared 1 Assassination, 2 Outlaw, 3 Subtlety 4 Talents
SA_Spells = { [SID_SND] = { target = "player", sort = true,duration=36, pandemic=true,spec=2,}, --Slice and Dice
	[SID_DEADLY_POISON] = { target = "target", sort = false, duration=12,pandemic=true,spec=1,}, --DeadlyPoison
	[SID_RUPTURE] = { target = "target", sort = true,duration=32, pandemic=true, spec=1,},  --Rupture
	[SID_FEINT]  = { target = "player", sort = false,duration=5,pandemic=false,spec=0, }, --Feint
	[SID_GARROTE] = { target = "target", sort = true,duration=18, pandemic=true,spec=1, }, --Garrote
	--[SID_BURST_SPEED] = { target = "player",sort = true,duration=4,pandemic=false,spec=4, }, --BurstOfSpeed
	[SID_INTERNAL_BLEEDING] = { target = "target", sort = true,duration=12,pandemic=false,spec=1, }, --InternalBleeding
--	[SID_VENDETTA] = { target = "target", sort=false,duration=20,pandemic=false,spec=1, }, --Vendetta
	[SID_DEATHMARK] = { target = "target", sort=false,duration=16,pandemic=false,spec=1, }, --Deathmark
	[SID_ENVENOM] = { target = "player",sort = true,duration=6,pandemic=false,spec=1,}, --Envenom
	[SID_ADRENALINE_RUSH] = { target = "player",sort=true,duration=20,pandemic=false,spec=2,altId=SID_ADRENALINE_RUSH_T18,}, --Adrenaline Rush	\w T18 p2
	[SID_ADRENALINE_RUSH_T18] = { target = "player",sort=true,duration=20,pandemic=false,spec=2,hidden=true,}, --T18 2 set
	[SID_HEMORRHAGE] = { target = "target",sort=true,duration=24,pandemic=true,spec=1, }, -- Hemorrhage
	[SID_FIND_WEAKNESS] = { target = "target",sort=true, duration=10,pandemic=false,spec=3, }, -- FindWeaknes
	[SID_MASTER_SUBTLETY] = { target = "player",sort=true, duration=5,pandemic=false,spec=3, }, -- Master of Subtlety
	[SID_GCD] = { target = "player", sort=true, duration=1, pandemic=false,spec=0,}, --GCD
	[SID_MARKED_FOR_DEATH] = { target= "target", sort=true, duration=60, pandemic=false,spec=4,}, --Marked for Death
	[SID_CRIMSON_TEMPEST] = { target= "target", sort=true, duration=12, pandemic=false,spec=4,}, --Crimson Tempest
	--[SID_COMBAT_READINESS] = {target="player", sort=true, duration=10, pandemic = false,spec=4,}, --Combat Rediness
	[SID_KIDNEY_SHOT] = {target="target", sort=true, duration=6, pandemic=false,spec=0,}, --Kidney Shot
	--[SID_DEADLY_THROW] ={target="target", sort=true, duration=6, pandemic=false,spec=4,}, --Deadly throw
	[SID_CLOAK_SHADOWS] ={target="player", sort=true, duration=5, pandemic=false,spec=0,}, --Cloak of Shadows
	--[SID_SHADOW_REFLECTION] = {target="player", sort=true, duration=8, pandemic=false,spec=4,}, --Shadow Reflection --player
	[SID_EVASION] = {target="player", sort=true, duration=10, pandemic=false,spec=0,}, --Evasion
	[SID_GOUGE] = {target="target", sort=true, duration=4, pandemic=false,spec=2,}, --Gouge
	[SID_SPRINT] =  {target="player", sort=true, duration=8, pandemic=false,spec=0,}, --Sprint
	[SID_BLIND] =  {target="target", sort=true, duration=60, pandemic=false,spec=0,}, --Blind
	[SID_SUBTERFUGE] = {target="player", sort=false, duration=3, pandemic=false,spec=4,}, --Subterfuge
	[SID_WOUND_POISON] = {target="target", sort=false, duration=12, pandemic=false,spec=1,}, --Wound Poison
	[SID_CRIPPLING_POISON] = {target="target", sort=false, duration=12, pandemic=false,spec=1,}, --Crippling Poison
--	[SID_CRIPPLING_POISON] = {target="target", sort=false, duration=12, pandemic=false, spec=1,}, --Agonizing Poison
	[SID_NERVE_STRIKE] = {target="target", sort=false, duration=6, pandemic=false,spec=4,}, --Nervestrike
	[SID_ROLL_BONES] = {target="player", sort=true, duration=42, pandemic=true, spec=2,}, --RtB JollyRoger
	[SID_GRAND_MELEE] = {target="player", sort=true, duration=42, pandemic=true, spec=2,},
	[SID_SHARK_INFESTED] = {target="player", sort=true, duration=42, pandemic=true, spec=2,},
	[SID_TRUE_BEARING] = {target="player", sort=true, duration=42, pandemic=true, spec=2,},
	[SID_BURIED_TREASURE] = {target="player", sort=true, duration=42, pandemic=true, spec=2,},
	[SID_BROADSIDE] = {target="player", sort=true, duration=42, pandemic=true, spec=2,},
	[SID_RIPOSTE] = {target="player", sort=true, duration=42, pandemic=true, spec=2,}, --Riposte
	[SID_CRIMSON_VIAL] = {target="player", sort=false, duration=6, pandemic=true, spec=0,}, --Crimson Vial
	[SID_NIGHT_TERRORS] = {target="target", sort=true, duration=16, pandemic=true, spec=3,}, --Night Terrors
	[SID_NIGHTBLADE] = {target="target", sort=true, duration=16, pandemic=true, spec=3,}, --Nightblade
	[SID_SHADOW_DANCE] = {target="player", sort=true, duration=3, pandemic=true, spec=3,}, --Shadowdance
	[SID_SHADOW_BLADES] = {target="player", sort=false, duration=12, pandemic=false, spec=3,}, --Shadow Blade
--	[206237] = {target="player", sort=true, duration=36, pandemic=true, spec=3,}, --Enveloping Shadows
	[SID_ELABORATE_PLANNING] = {target="player", sort=false, duration=5, pandemic=false, spec=1,}, --Elaborate Planning
	[SID_GHOSTLY_STRIKE] = {target="target", sort=true, duration=10, pandemic=false, spec=2,}, --Ghostly Strike
	[SID_SYMBOLS_DEATH] = {target="player",sort=false, duration=35, pandemic=false, spec=3,}, --Symbols of Death
	[SID_OPPORTUNITY] = {target="player", sort=false, duration=10, pandemic=false, spec=2,}, --QuickDraw/Oppurtunity
	[SID_ALACRITY] = {target="player", sort=false, duration=20, pandemic=false, spec=4,}, --Alacrity
	[SID_BETWEEN_EYES] = {target="target", sort=true, duration=5, pandemic=false, spec=2,}, --Between the Eyes
	[SID_BLADE_FLURRY] = {target="player", sort=true, duration=12, pandemic=false, spec=2,}, --Blade Flurry
	[SID_BLADE_RUSH] = {target="player", sort=true, duration=5, pandemic=false, spec=2,}, --Blade Rush
--	[199740] = {target="pet",sort=true,duration=300, pandemic=false, spec=2,}, --Bribe
	[SID_TOXIC_BLADE] = { target = "target", sort = true,duration=9, pandemic=false,spec=1, }, --Toxic Blade
	[SID_DREADBLADES] = {target="player", aurafilter="PLAYER HARMFUL", sort=true, duration=10, pandemic=false, spec=2,}, --Dreadblades
	[SID_SEPSIS] = {target="target", sort=true, duration=10, pandemic=false, spec=4,}, --Sepsis
	[SID_SEPSIS_STEALTH] = {target="player", altname="Sepsis (Stealth)", sort=true, duration=5, pandemic=false, spec=4,}, --Sepsis (Stealth component)
	[SID_SHIV] = {target="target", sort=true, duration=9, pandemic=false, spec=1,}, --Shiv
        [SID_KINGSBANE] = {target="target", sort=true, duration=14, pandemic=false, spec=1,}, --Kingsbane
	};

local SA_Classic = SliceAdmiral.IsClassicEra() or SliceAdmiral.IsCataClassic() or SliceAdmiral.IsMoPClassic()

if SliceAdmiral.IsClassicEra() then
  SA_Spells[SID_BLADEDANCE] = {target="player", sort=true, duration=30, pandemic=false,spec=0} --Blade Dance Rune (SOD)
end
if SliceAdmiral.IsCataClassic() then
  SA_Spells[SID_RECUPERATE] = {target="player", sort=true, duration=30, pandemic=false,spec=3} --Recuperate (Cataclysm Classic)
end

for k in pairs(SA_Spells) do
 local name, rank, icon
 if not SA_Classic then
   local spe = C_Spell.GetSpellInfo(k)
   name = spe.name
   icon = spe.iconID
 else
   name, rank, icon = GetSpellInfo(k)
 end
 
 SA_Spells[k].realname = name or "none"..k
-- if not name and not SA_Classic then print(string.format("SliceAdmiral: Unknown SpellId: %d",k)) end
 if SA_Spells[k].altname then
   SA_Spells[k].name = SA_Spells[k].altname
 else
   SA_Spells[k].name = SA_Spells[k].realname
 end
 SA_Spells[k].icon = icon or "blank"
 SA_Spells[k].id = k
 if SA_Classic and not name then
   SA_Spells[k].hidden = true
 end
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
