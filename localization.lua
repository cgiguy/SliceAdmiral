-- Author      : cgiguy
-- Create Date : 7/19/2011

-- Spell ID List
SC_SPELL_SND_ID = 5171;
SC_SPELL_RECUP_ID = 73651;
SC_SPELL_DP_ID = 2818;
SC_SPELL_RUP_ID = 1943;
SC_SPELL_VEND_ID = 79140;
SC_SPELL_ENV_ID = 32645;

-- Generate the localized name for each spell
SC_SPELL_SND = GetSpellInfo(SC_SPELL_SND_ID);
SC_SPELL_RECUP = GetSpellInfo(SC_SPELL_RECUP_ID);
SC_SPELL_DP = GetSpellInfo(SC_SPELL_DP_ID);
SC_SPELL_RUP = GetSpellInfo(SC_SPELL_RUP_ID);
SC_SPELL_VEND = GetSpellInfo(SC_SPELL_VEND_ID);
SC_SPELL_ENV = GetSpellInfo(SC_SPELL_ENV_ID);

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
