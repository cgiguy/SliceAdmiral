-- Author      : cgiguy
-- Create Date : 7/19/2011

-- Spell ID List
SC_SPELL_SND_ID = 5171;
SC_SPELL_RECUP_ID = 73651;
SC_SPELL_DP_ID = 2818;
SC_SPELL_RUP_ID = 1943;
SC_SPELL_WEAKEN_ID = 113746; --Expose Armor (Same as Druids and Warriors)
SC_SPELL_ANTICI_ID = 115189; --Anticipation Talent
--Assasination Specific
SC_SPELL_VEND_ID = 79140;
SC_SPELL_ENV_ID = 32645;
--Combat Specific
SC_SPELL_REVEAL_ID = 84617; --Revealing Strike
SC_SPELL_BAND1_ID = 84745;
SC_SPELL_BAND2_ID = 84746;
SC_SPELL_BAND3_ID = 84747;
--Subtley Specific
SC_SPELL_HEMO_ID = 89775; -- Hemorage


-- Generate the localized name for each spell
SC_SPELL_SND = GetSpellInfo(SC_SPELL_SND_ID);
SC_SPELL_RECUP = GetSpellInfo(SC_SPELL_RECUP_ID);
SC_SPELL_DP = GetSpellInfo(SC_SPELL_DP_ID);
SC_SPELL_RUP = GetSpellInfo(SC_SPELL_RUP_ID);
SC_SPELL_VEND = GetSpellInfo(SC_SPELL_VEND_ID);
SC_SPELL_ENV = GetSpellInfo(SC_SPELL_ENV_ID);
SC_SPELL_BAND1 = GetSpellInfo(SC_SPELL_BAND1_ID);
SC_SPELL_BAND2 = GetSpellInfo(SC_SPELL_BAND2_ID);
SC_SPELL_BAND3 =  GetSpellInfo(SC_SPELL_BAND3_ID);
SC_SPELL_REVEAL = GetSpellInfo(SC_SPELL_REVEAL_ID);
SC_SPELL_WEAKEN = GetSpellInfo(SC_SPEll_WEAKEN_ID);
SC_SPELL_ANTICI = GetSpellInfo(SC_SPELL_ANTICI_ID);
SC_SPELL_HEMO = GetSpellInfo(SC_SPELL_HEMO_ID);

SC_LANG_CP = "Combo Points";
SC_LANG_SETTINGS = "Options";
SC_LANG_SOUNDS = "Sounds";

SC_TIMERBARS = "Timer Bars";
SC_ENERGYBAR = "Energy Bar";
SC_COMBOANDSTATS = "Combo Points and Stats";
SC_SOUNDEFFECTS = "Sound Effects";
SC_SOUNDEFFECTS2 = "Sound Effects 2";

if (GetLocale() == "deDE") then
  SC_LANG_SETTINGS = "Einstellungen";
end
