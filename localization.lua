-- Author      : Administrator
-- Create Date : 12/5/2008 5:47:30 PM

if (GetLocale() == "frFR") then
	SC_SPELL_SND = "D\195\169biter";
	SC_SPELL_RECUP = "Recuprer";
	SC_SPELL_DP = "Poison mortel";
	SC_SPELL_RUP = "Rupture";
	SC_SPELL_VEND = "Vendetta";
    SC_SPELL_ENV = "Envenom";

	SC_LANG_CP = "Combo Points";
	SC_LANG_SETTINGS = "Options";
	SC_LANG_SOUNDS = "Sounds";
	
	SC_TIMERBARS = "Timer Bars";
    SC_ENERGYBAR = "Energy Bar";
    SC_COMBOANDSTATS = "Combo Points and Stats";
    SC_SOUNDEFFECTS = "Sound Effects";
    SC_SOUNDEFFECTS2 = "Sound Effects 2";
else
	if (GetLocale() == "deDE") then
		SC_SPELL_SND = "Zerhäckseln";
		SC_SPELL_RECUP = "Erholung";
		SC_SPELL_DP = "Tödliches Gift";
		SC_SPELL_RUP = "Blutung";
		SC_SPELL_VEND = "Blutrache";
        SC_SPELL_ENV = "Vergiften";
	
		SC_LANG_CP = "Combo Points";
		SC_LANG_SETTINGS = "Einstellungen";
		SC_LANG_SOUNDS = "Sounds";
		
		SC_TIMERBARS = "Timer Bars";
        SC_ENERGYBAR = "Energy Bar";
        SC_COMBOANDSTATS = "Combo Points and Stats";
        SC_SOUNDEFFECTS = "Sound Effects";
        SC_SOUNDEFFECTS2 = "Sound Effects 2";
	else
		SC_SPELL_SND = "Slice and Dice";
		SC_SPELL_RECUP = "Recuperate";
		SC_SPELL_DP = "Deadly Poison";
		SC_SPELL_RUP = "Rupture";
		SC_SPELL_VEND = "Vendetta";
        SC_SPELL_ENV = "Envenom";
	
		SC_LANG_CP = "Combo Points";
		SC_LANG_SETTINGS = "Settings";
		SC_LANG_SOUNDS = "Sounds";
        
        SC_TIMERBARS = "Timer Bars";
        SC_ENERGYBAR = "Energy Bar";
        SC_COMBOANDSTATS = "Combo Points and Stats";
        SC_SOUNDEFFECTS = "Sound Effects";
        SC_SOUNDEFFECTS2 = "Sound Effects 2";
	end
end