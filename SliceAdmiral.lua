-- Author :cgiguy
-- Create Date : 9/10/2008 6:44:47 PM
-- This damn thing needs a full rewrite so bad I can hardly stand it
-- I wish I had the time.

SA_Version = GetAddOnMetadata("SliceAdmiral", "Version") 
local S = LibStub("LibSmoothStatusBar-1.0")

SA_Data = {};
SA_Data.lastSort = 0;	 -- Last time bars were sorted
SA_Data.maxSortableBars = 6 -- How many sortable non-DP/Envenom timer type bars do we have?
SA_Data.sortPeriod = 0.5; -- Only sort bars every sortPeriod seconds
SA_Data.tNow = 0;
SA_Data.UpdateInterval = 0.05;
SA_Data.TimeSinceLastUpdate = 0;

local scaleUI = 0
local widthUI = 0

local CalcExpireTime -- local is good
local SA_SetComboPts
local SA_UpdateStats
local SA_flashBuffedStats
local SA_ResetBaseStats
local SA_TestTarget
local UnitAffectingCombat = UnitAffectingCombat
SA_Data.BARS = { --TEH BARS
 ["CP"] = {
 ["obj"] = 0
 },
 [SC_SPELL_RECUP] = {
 ["obj"] = 0,
 ["Expires"] = 0,		-- Actual time left to expire in seconds
 ["AlertPending"] = 0, 
 },
 [SC_SPELL_SND] = {
 ["obj"] = 0,
 ["Expires"] = 0,
	["AlertPending"] = 0, 
 },
 [SC_SPELL_DP] = {
 ["obj"] = 0,
 ["Expires"] = 0, 
 },
 [SC_SPELL_RUP] = {
 ["obj"] = 0,
 ["Expires"] = 0, 
	["AlertPending"] = 0,
 },
 [SC_SPELL_VEND] = {
 ["obj"] = 0,
 ["Expires"] = 0, 
	["AlertPending"] = 0,
 },
 [SC_SPELL_ENV] = {
 ["obj"] = 0,
 ["Expires"] = 0, 
 },
 [SC_SPELL_REVEAL] = {
 ["obj"] = 0,
 ["Expires"] = 0, 
	["AlertPending"] = 0,
 },
 [SC_SPELL_HEMO] = {
	["obj"] = 0,
	["Expires"] = 0,
 },
 [SC_SPELL_FEINT] = {
	["obj"] = 0,
	["Expires"] = 0,	
 },
 [SC_SPELL_BAND1] = {
 ["obj"] = 0,
 ["Expires"] = 0, 
 },
 [SC_SPELL_BAND2] = {
 ["obj"] = 0,
 ["Expires"] = 0, 
 },
 [SC_SPELL_BAND3] = {
 ["obj"] = 0,
 ["Expires"] = 0, 
 },
 ["Stat"] = {
 ["obj"] = 0,
 },
};

function SA_BarTexture()
	if SliceAdmiral_Save.BarTexture and (SA_BarTextures[ SliceAdmiral_Save.BarTexture ]) then
		return SA_BarTextures[ SliceAdmiral_Save.BarTexture ];
	else
		return "Interface\\AddOns\\SliceAdmiral\\Images\\Smooth.tga";
	end
end

function SA_SoundTest(name)
 if SA_Sounds[name] then
	 if SliceAdmiral_Save.MasterVolume then
		PlaySoundFile( SA_Sounds[name], "Master" );
	 else
		PlaySoundFile( SA_Sounds[name] );
	 end
 end
end

local function SA_Sound(saved)
	if not UnitAffectingCombat("player") and not SliceAdmiral_Save.OutOfCombat then return end
	if SliceAdmiral_Save[saved] then
		if SliceAdmiral_Save.MasterVolume then
			PlaySoundFile( SA_Sounds[ SliceAdmiral_Save[saved] ], "Master" );
		else
			PlaySoundFile( SA_Sounds[ SliceAdmiral_Save[saved] ] );
		end
	else
		print(string.format("%s%s", "Soundsave not found: ", saved));
	end
end

local function SA_ChangeAnchor()
 local LastAnchor = VTimerEnergy;
 local offSetSize = SliceAdmiral_Save.BarMargin; -- other good values, -1, -2
 local GuileAnchor = LastAnchor

 -- Stat bar goes first, because it's fucking awesome like that
 if SliceAdmiral_Save.ShowStatBar then 
	SA_Data.BARS["Stat"]["obj"]:ClearAllPoints();
	SA_Data.BARS["Stat"]["obj"]:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize); 
 end

 --anchor CPs on stat bar if energy bar is hidden.
 if SliceAdmiral_Save.HideEnergy then
	LastAnchor = SA_Data.BARS["Stat"]["obj"];
 end

 -- CP Bar --
 SA_Data.BARS["CP"]["obj"]:ClearAllPoints(); --so it can move
 SA_Data.BARS["CP"]["obj"]:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize); --CP bar on bottom of Stat Bar

 LastAnchor = SA_Data.BARS["Stat"]["obj"]; --timer bars grow off top of stat bar by default
 if SliceAdmiral_Save.Barsup then
	if SliceAdmiral_Save.ShowStatBar then
		LastAnchor = SA_Data.BARS["Stat"]["obj"];
	else
		if SliceAdmiral_Save.HideEnergy then
			LastAnchor = SA_Data.BARS["CP"]["obj"];
		else
			LastAnchor = VTimerEnergy;
		end
	end
 else
	 if SliceAdmiral_Save.CPBarShow then
		LastAnchor = SA_Data.BARS["CP"]["obj"];
	 else
		 if SliceAdmiral_Save.HideEnergy then
			LastAnchor = SA_Data.BARS["Stat"]["obj"];
		 else
			LastAnchor = VTimerEnergy;
		 end
	 end
 end
 for i = 1, SA_Data.maxSortableBars do 
	 if (SA_Data.BARORDER[i]["Expires"] > 0) then
		SA_Data.BARORDER[i]["obj"]:ClearAllPoints();
		if SliceAdmiral_Save.Barsup then
			SA_Data.BARORDER[i]["obj"]:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize); --bar on top
		else
			SA_Data.BARORDER[i]["obj"]:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize);
		end
		LastAnchor = SA_Data.BARORDER[i]["obj"];
	 end
 end --end loop

 -- Deadly Poison -- DP always on the outside since it's auto-refreshed for the rogue
 if (SA_Data.BARS[SC_SPELL_DP]["Expires"] ~= 0) then
	SA_Data.BARS[SC_SPELL_DP]["obj"]:ClearAllPoints();
	if (SliceAdmiral_Save.Barsup) then
		SA_Data.BARS[SC_SPELL_DP]["obj"]:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize);
	else
		SA_Data.BARS[SC_SPELL_DP]["obj"]:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize);
	end
	LastAnchor = SA_Data.BARS[SC_SPELL_DP]["obj"];
 end

 -- Envenom -- Envenom to finish this shiznit out.
 if (SA_Data.BARS[SC_SPELL_ENV]["Expires"] ~= 0) then
	SA_Data.BARS[SC_SPELL_ENV]["obj"]:ClearAllPoints();
	if (SliceAdmiral_Save.Barsup) then
		SA_Data.BARS[SC_SPELL_ENV]["obj"]:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize);
	else
		SA_Data.BARS[SC_SPELL_ENV]["obj"]:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize);
	end
	LastAnchor = SA_Data.BARS[SC_SPELL_ENV]["obj"];
 end
 
 -- Feint 
 if (SA_Data.BARS[SC_SPELL_FEINT]["Expires"] ~= 0) then
	SA_Data.BARS[SC_SPELL_FEINT]["obj"]:ClearAllPoints();
	if (SliceAdmiral_Save.Barsup) then
		SA_Data.BARS[SC_SPELL_FEINT]["obj"]:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize);
	else
		SA_Data.BARS[SC_SPELL_FEINT]["obj"]:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize);
	end
	LastAnchor = SA_Data.BARS[SC_SPELL_FEINT]["obj"];
 end
 
 -- Bandits Guile
 if (SA_Data.BARS[SC_SPELL_BAND1]["Expire"] ~= 0)  then
	SA_Data.BARS[SC_SPELL_BAND1]["obj"]:ClearAllPoints();	
	if (SliceAdmiral_Save.Barsup) then
		SA_Data.BARS[SC_SPELL_BAND1]["obj"]:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize);
	else
		SA_Data.BARS[SC_SPELL_BAND1]["obj"]:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize);
	end
	GuileAnchor = LastAnchor
	LastAnchor = SA_Data.BARS[SC_SPELL_BAND1]["obj"];	
 end 
 if (SA_Data.BARS[SC_SPELL_BAND2]["Expire"] ~= 0)  then	
	SA_Data.BARS[SC_SPELL_BAND2]["obj"]:ClearAllPoints();	
	if (SliceAdmiral_Save.Barsup) then
		SA_Data.BARS[SC_SPELL_BAND2]["obj"]:SetPoint("BOTTOMLEFT", GuileAnchor, "TOPLEFT", 0, offSetSize);
	else
		SA_Data.BARS[SC_SPELL_BAND2]["obj"]:SetPoint("TOPLEFT", GuileAnchor, "BOTTOMLEFT", 0, -1 * offSetSize);
	end
	LastAnchor = SA_Data.BARS[SC_SPELL_BAND2]["obj"];
 end 
 if (SA_Data.BARS[SC_SPELL_BAND3]["Expire"] ~= 0) then	
	SA_Data.BARS[SC_SPELL_BAND3]["obj"]:ClearAllPoints();
	if (SliceAdmiral_Save.Barsup) then
		SA_Data.BARS[SC_SPELL_BAND3]["obj"]:SetPoint("BOTTOMLEFT", GuileAnchor, "TOPLEFT", 0, offSetSize);
	else
		SA_Data.BARS[SC_SPELL_BAND3]["obj"]:SetPoint("TOPLEFT", GuileAnchor, "BOTTOMLEFT", 0, -1 * offSetSize);
	end
	LastAnchor = SA_Data.BARS[SC_SPELL_BAND3]["obj"];
 end 
end

-- We only call this if SliceAdmiral_Save.SortBars
-- and we haven't done it in the last SA_Data.sortPeriod seconds
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
	SA_ChangeAnchor();
 end
end

function SA_OnEvent(self, event, ...)
 if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
	local timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName = ...;
	if (type == "SPELL_AURA_REFRESH" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REMOVED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_PERIODIC_AURA_REMOVED" or type == "SPELL_PERIODIC_AURA_APPLIED" or type == "SPELL_PERIODIC_AURA_APPLIED_DOSE" or type == "SPELL_PERIODIC_AURA_REFRESH") then
		local spellId, spellName, spellSchool = select(12, ...);
		local isMySpell;
		-- print ("spellId = " .. spellId .. " (" .. spellName .. ")");
		-- spellName = GetSpellInfo(spellId);
		-- print("SourceName: " .. sourceName);
		isMySpell = (sourceName == UnitName("player")); 
		if (destName == UnitName("player")) then
			--SLICE N DICE EVENT --
			if (spellId == SC_SPELL_SND_ID and SliceAdmiral_Save.ShowSnDBar) then
				if (type == "SPELL_AURA_REMOVED") then					
					SA_Sound("Expire");								
					SA_Data.BARS[SC_SPELL_SND]["Expires"] = 0;				
					SA_Data.BARS[SC_SPELL_SND]["obj"]:Hide();				
				else
					local name, rank, icon, count, debuffType, duration, expirationTime = UnitAura("player", SC_SPELL_SND);					
					SA_Data.BARS[SC_SPELL_SND]["obj"]:Show();					
					SA_Data.BARS[SC_SPELL_SND]["Expires"] = CalcExpireTime(expirationTime);				
				end
				SA_ChangeAnchor();
			end
			-- Bandits Guile --
			if (spellId == SC_SPELL_BAND1_ID and SliceAdmiral_Save.ShowGuileBar) then
				if (type == "SPELL_AURA_REMOVED") then									
					SA_Data.BARS[SC_SPELL_BAND1]["Expires"] = 0;				
					SA_Data.BARS[SC_SPELL_BAND1]["obj"]:Hide();				
				else
					local name, rank, icon, count, debuffType, duration, expirationTime = UnitAura("player", SC_SPELL_BAND1);					
					SA_Data.BARS[SC_SPELL_BAND1]["obj"]:Show();					
					SA_Data.BARS[SC_SPELL_BAND1]["Expires"] = CalcExpireTime(expirationTime);						
				end
				SA_ChangeAnchor();
			end
			if (spellId == SC_SPELL_BAND2_ID and SliceAdmiral_Save.ShowGuileBar) then
				if (type == "SPELL_AURA_REMOVED") then								
					SA_Data.BARS[SC_SPELL_BAND2]["Expires"] = 0;				
					SA_Data.BARS[SC_SPELL_BAND2]["obj"]:Hide();				
				else
					local name, rank, icon, count, debuffType, duration, expirationTime = UnitAura("player", SC_SPELL_BAND2);
					SA_Data.BARS[SC_SPELL_BAND2]["obj"]:Show();					
					SA_Data.BARS[SC_SPELL_BAND2]["Expires"] = CalcExpireTime(expirationTime);						
				end
				SA_ChangeAnchor();
			end
			if (spellId == SC_SPELL_BAND3_ID and SliceAdmiral_Save.ShowGuileBar) then
				if (type == "SPELL_AURA_REMOVED") then								
					SA_Data.BARS[SC_SPELL_BAND3]["Expires"] = 0;				
					SA_Data.BARS[SC_SPELL_BAND3]["obj"]:Hide();				
				else
					local name, rank, icon, count, debuffType, duration, expirationTime = UnitAura("player", SC_SPELL_BAND3);					
					SA_Data.BARS[SC_SPELL_BAND3]["obj"]:Show();					
					SA_Data.BARS[SC_SPELL_BAND3]["Expires"] = CalcExpireTime(expirationTime);									
				end
				SA_ChangeAnchor();
			end
			-- RECUPERATE EVENT --
			if (spellId == SC_SPELL_RECUP_ID and SliceAdmiral_Save.ShowRecupBar) then
				 if (type == "SPELL_AURA_REMOVED") then					
					SA_Sound("Recup.Expire");					
					SA_Data.BARS[SC_SPELL_RECUP]["Expires"] = 0;
					SA_Data.BARS[SC_SPELL_RECUP]["obj"]:Hide();
				 else
					local name, rank, icon, count, debuffType, duration, expirationTime = UnitAura("player", SC_SPELL_RECUP);								
					SA_Data.BARS[SC_SPELL_RECUP]["Expires"] = CalcExpireTime(expirationTime);
					SA_Data.BARS[SC_SPELL_RECUP]["obj"]:Show();			
				 end
				 SA_ChangeAnchor();
			end
			-- ENVENOM EVENT --
			if (spellId == SC_SPELL_ENV_ID and SliceAdmiral_Save.ShowEnvBar) then
				 if (type == "SPELL_AURA_REMOVED") then								
					SA_Data.BARS[SC_SPELL_ENV]["Expires"] = 0;			
					SA_Data.BARS[SC_SPELL_ENV]["obj"]:Hide();
				 else
					local name, rank, icon, count, debuffType, duration, expirationTime = UnitAura("player", SC_SPELL_ENV);								
					SA_Data.BARS[SC_SPELL_ENV]["Expires"] = CalcExpireTime(expirationTime);
					SA_Data.BARS[SC_SPELL_ENV]["obj"]:Show();
				 end
				 SA_ChangeAnchor();
			end
			-- Anticipation event --
			if (spellId == SC_SPELL_ANTICI_ID and SliceAdmiral_Save.CPBarShow and type == "SPELL_AURA_REMOVED") then		
				SA_SetComboPts();
			end
			-- Feint --
			if (spellId == SC_SPELL_FEINT_ID and SliceAdmiral_Save.ShowFeintBar) then
				if (type == "SPELL_AURA_REMOVED") then					
					SA_Data.BARS[SC_SPELL_FEINT]["Expires"] = 0;				
					SA_Data.BARS[SC_SPELL_FEINT]["obj"]:Hide();				
				else
					local name, rank, icon, count, debuffType, duration, expirationTime = UnitAura("player", SC_SPELL_FEINT);
					SA_Data.BARS[SC_SPELL_FEINT]["obj"]:Show();					
					SA_Data.BARS[SC_SPELL_FEINT]["Expires"] = CalcExpireTime(expirationTime);				
				end
				SA_ChangeAnchor();
			end
		else
			if (destName == GetUnitName("target",true)) then
				 -- DEADLY POISON EVENT --		 
				 if (isMySpell and spellId == SC_SPELL_DP_ID and SliceAdmiral_Save.DPBarShow) then
					if (type == "SPELL_AURA_REMOVED") then						
						SA_Data.BARS[SC_SPELL_DP]["Expires"] = 0;
						SA_Data.BARS[SC_SPELL_DP]["obj"]:Hide();
					else
						local name, rank, icon, count, debuffType, duration, expirationTime = UnitDebuff("target", SC_SPELL_DP, nil, "PLAYER");						
						SA_Data.BARS[SC_SPELL_DP]["Expires"] = CalcExpireTime(expirationTime);			
						SA_Data.BARS[SC_SPELL_DP]["obj"]:Show();
					end
					SA_ChangeAnchor();
				 end
				-- RUPTURE EVENT --
				if (isMySpell and spellId == SC_SPELL_RUP_ID and SliceAdmiral_Save.RupBarShow) then			
					if (type == "SPELL_AURA_REMOVED") then						
						SA_Sound("RuptExpire");						
						SA_Data.BARS[SC_SPELL_RUP]["Expires"] = 0;
						SA_Data.BARS[SC_SPELL_RUP]["obj"]:Hide();
					else
						 local name, rank, icon, count, debuffType, duration, expirationTime = UnitDebuff("target", SC_SPELL_RUP, nil, "PLAYER");						
						 SA_Data.BARS[SC_SPELL_RUP]["Expires"] = CalcExpireTime(expirationTime);
						 SA_Data.BARS[SC_SPELL_RUP]["obj"]:Show();
					end
					SA_ChangeAnchor();
				end
				-- HagTest REVEALING STRIKE EVENT --
				if (isMySpell and spellId == SC_SPELL_REVEAL_ID and SliceAdmiral_Save.RevealBarShow) then			
					if (type == "SPELL_AURA_REMOVED") then
						 SA_Sound("RevealExpire");						  
						 SA_Data.BARS[SC_SPELL_REVEAL]["Expires"] = 0;
						 SA_Data.BARS[SC_SPELL_REVEAL]["obj"]:Hide();
					else
						 local name, rank, icon, count, debuffType, duration, expirationTime = UnitDebuff("target", SC_SPELL_REVEAL, nil, "PLAYER");
						 SA_Data.BARS[SC_SPELL_REVEAL]["Expires"] = CalcExpireTime(expirationTime);
						 SA_Data.BARS[SC_SPELL_REVEAL]["obj"]:Show();
					end
					SA_ChangeAnchor();
				end
				-- Hemorrhage --
				if (isMySpell and spellId == SC_SPELL_HEMO_ID and SliceAdmiral_Save.ShowHemoBar) then			
					if (type == "SPELL_AURA_REMOVED") then
						 SA_Data.BARS[SC_SPELL_HEMO]["Expires"] = 0;
						 SA_Data.BARS[SC_SPELL_HEMO]["obj"]:Hide();
					else
						 local name, rank, icon, count, debuffType, duration, expirationTime = UnitDebuff("target", SC_SPELL_HEMO, nil, "PLAYER");
						 SA_Data.BARS[SC_SPELL_HEMO]["Expires"] = CalcExpireTime(expirationTime);
						 SA_Data.BARS[SC_SPELL_HEMO]["obj"]:Show();
					end
					SA_ChangeAnchor();
				end
				-- VENDETTA EVENT --
				if (isMySpell and spellId == SC_SPELL_VEND_ID and SliceAdmiral_Save.VendBarShow) then
					if (type == "SPELL_AURA_REMOVED") then						
						SA_Sound("VendExpire");										
						SA_Data.BARS[SC_SPELL_VEND]["Expires"] = 0;
						SA_Data.BARS[SC_SPELL_VEND]["obj"]:Hide();
					else
						local name, rank, icon, coun, debuffType, duration, expirationTime = UnitDebuff("target", SC_SPELL_VEND, nil, "PLAYER");						
						SA_Data.BARS[SC_SPELL_VEND]["Expires"] = CalcExpireTime(expirationTime);
						SA_Data.BARS[SC_SPELL_VEND]["obj"]:Show();
					end
					SA_ChangeAnchor();
				end
			end
		end
	end -- "SPELL_AURA_REFRESH" or ...
	-- DOT monitors
	if (SliceAdmiral_Save.ShowDoTDmg and type == "SPELL_PERIODIC_DAMAGE" and destName == GetUnitName("target",true) and sourceName == UnitName("player")) then
		local spellId, spellName, spellSchool = select(12, ...); 
		if (spellId == SC_SPELL_RUP_ID and SliceAdmiral_Save.RupBarShow) then
			local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(15, ...)
			SA_Data.BARS[SC_SPELL_RUP]["obj"].DoTtext:SetAlpha(1);
			if (SliceAdmiral_Save.DoTCrits and critical) then
				SA_Data.BARS[SC_SPELL_RUP]["obj"].DoTtext:SetText(string.format("*%.0f*", amount));
				UIFrameFadeOut(SA_Data.BARS[SC_SPELL_RUP]["obj"].DoTtext, 3, 1, 0);
			else
				SA_Data.BARS[SC_SPELL_RUP]["obj"].DoTtext:SetText(amount);
				UIFrameFadeOut(SA_Data.BARS[SC_SPELL_RUP]["obj"].DoTtext, 2, 1, 0);
			end
		end
		if (spellId == SC_SPELL_DP_ID and SliceAdmiral_Save.DPBarShow) then
			local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(15, ...)
			SA_Data.BARS[SC_SPELL_DP]["obj"].DoTtext:SetAlpha(1);
			if (SliceAdmiral_Save.DoTCrits and critical) then
				SA_Data.BARS[SC_SPELL_DP]["obj"].DoTtext:SetText(string.format("*%.0f*", amount));
				UIFrameFadeOut(SA_Data.BARS[SC_SPELL_DP]["obj"].DoTtext, 3, 1, 0);
			else
				SA_Data.BARS[SC_SPELL_DP]["obj"].DoTtext:SetText(amount);
				UIFrameFadeOut(SA_Data.BARS[SC_SPELL_DP]["obj"].DoTtext, 2, 1, 0);
			end
		end
	end
end -- event == "COMBAT_LOG_EVENT_UNFILTERED"

 if (event == "UNIT_COMBO_POINTS") then
	 local unit = ...;
	 if (unit and unit == "player") then
		SA_SetComboPts();
	 end
 end
	if event == "PLAYER_TARGET_CHANGED" then
		SA_SetComboPts();
		SA_TestTarget();		
	end
	
	if event == "PLAYER_ENTERING_WORLD" then	
		SA_TestTarget();	
		VTimerEnergy:SetScript("OnHide", SA_ChangeAnchor)
		VTimerEnergy:SetScript("OnShow", SA_ChangeAnchor)
	end
	 
	if not UnitAffectingCombat("player") and not (SA:GetAlpha() == SA_Fade:GetValue()/100) then
		UIFrameFadeOut(SA, 0.4, SA:GetAlpha(), SA_Fade:GetValue()/100)
	elseif UnitAffectingCombat("player") and not (SA:GetAlpha() == 1.0) then
		UIFrameFadeIn(SA, 0.4, SA:GetAlpha(), 1.0);
	end
end

function SA_TestTarget() 
 if SliceAdmiral_Save.DPBarShow then
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster = UnitDebuff("target", SC_SPELL_DP, nil, "PLAYER");
	 if not name then		
		SA_Data.BARS[SC_SPELL_DP]["Expires"] = 0;
		SA_Data.BARS[SC_SPELL_DP]["obj"]:Hide();
	 else
		if (unitCaster == "player") then			
			SA_Data.BARS[SC_SPELL_DP]["Expires"] = CalcExpireTime(expirationTime);		
			SA_Data.BARS[SC_SPELL_DP]["obj"]:Show();
		else			
			SA_Data.BARS[SC_SPELL_DP]["Expires"] = 0;
			SA_Data.BARS[SC_SPELL_DP]["obj"]:Hide();
		end
	 end
 end
 if SliceAdmiral_Save.RupBarShow then
	 local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster = UnitDebuff("target", SC_SPELL_RUP, nil, "PLAYER");
	 if not name then		 
		 SA_Data.BARS[SC_SPELL_RUP]["Expires"] = 0;
		 SA_Data.BARS[SC_SPELL_RUP]["obj"]:Hide();
	else
		if (unitCaster == "player") then			
			SA_Data.BARS[SC_SPELL_RUP]["Expires"] = CalcExpireTime(expirationTime);
			SA_Data.BARS[SC_SPELL_RUP]["obj"]:Show();
		else			
			SA_Data.BARS[SC_SPELL_RUP]["Expires"] = 0;
			SA_Data.BARS[SC_SPELL_RUP]["obj"]:Hide();		
		end
	 end	
 end
 if SliceAdmiral_Save.RevealBarShow then
	 local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster = UnitDebuff("target", SC_SPELL_REVEAL, nil, "PLAYER");
	 if not name then		 
		 SA_Data.BARS[SC_SPELL_REVEAL]["Expires"] = 0;
		 SA_Data.BARS[SC_SPELL_REVEAL]["obj"]:Hide();
	 else
		if (unitCaster == "player") then			
			SA_Data.BARS[SC_SPELL_REVEAL]["Expires"] = CalcExpireTime(expirationTime);
			SA_Data.BARS[SC_SPELL_REVEAL]["obj"]:Show();
		else			
			SA_Data.BARS[SC_SPELL_REVEAL]["Expires"] = 0;
			SA_Data.BARS[SC_SPELL_REVEAL]["obj"]:Hide();
		end
	 end	
 end
 if SliceAdmiral_Save.VendBarShow then
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster = UnitDebuff("target", SC_SPELL_VEND, nil, "PLAYER");
	 if not name then		
		SA_Data.BARS[SC_SPELL_VEND]["Expires"] = 0;
		SA_Data.BARS[SC_SPELL_VEND]["obj"]:Hide();
	else
		if (unitCaster == "player") then			
			SA_Data.BARS[SC_SPELL_VEND]["Expires"] = CalcExpireTime(expirationTime);
			SA_Data.BARS[SC_SPELL_VEND]["obj"]:Show();
		else			
			SA_Data.BARS[SC_SPELL_VEND]["Expires"] = 0;
			SA_Data.BARS[SC_SPELL_VEND]["obj"]:Hide();
		end
	end	
 end
 SA_ChangeAnchor(); 
end

local curCombo = 0

function SA_SetComboPts() 
	local points = GetComboPoints("player");
	local name, rank, icon, count = UnitAura("player", SC_SPELL_ANTICI) 
	count = count or 0
	local text = "0(0)"
	if count > 0 then
		text = points .. "(" .. count.. ")"
	else
		text = points
	end
	if SliceAdmiral_Save.CPBarShow then	
		if name and (count > 0) and SliceAdmiral_Save.AntisCPShow then
			for i = 1, count do
				SA_Data.BARS["CP"]["obj"].antis[i]:Show();
			end	 
		else
			for i = 1, 5 do
				SA_Data.BARS["CP"]["obj"].antis[i]:Hide();
			end
		end 
		if (points > curCombo) then
			for i = curCombo + 1, points do
				SA_Data.BARS["CP"]["obj"].combos[i]:Show();
			end		
			SA_Combo:SetText(text);
		else
			for i = points + 1, curCombo do
				SA_Data.BARS["CP"]["obj"].combos[i]:Hide();
			end
			SA_Combo:SetText(text);
			if (points == count and count == 0) then
				SA_Combo:SetText("");
			end
		 end 
		curCombo = points; 
	else
		if (points == 0 and count == 0) then
			SA_Combo:SetText("");
		else
			SA_Combo:SetText(text);
		end	
	end
end

local function SA_Unload()
 SA:UnregisterAllEvents();
 SA:Hide();
 DisableAddOn("SliceAdmiral");
end

local function SA_NewFrame()
 local f = CreateFrame("StatusBar", nil, SA);

 f:SetWidth(widthUI);
 f:SetScale(scaleUI);
 f:SetHeight(12);
 
 f:SetPoint("BOTTOMLEFT", VTimerEnergy, "TOPLEFT", 2, 0);
 
 f:SetStatusBarTexture(SA_BarTexture());
 f:SetStatusBarColor(0.768627451, 0, 0, 1);
 f:EnableMouse(false);
 f:SetMinMaxValues(0, 6.0);
 f:SetValue(0);

 f:Hide();

 f:SetBackdrop({
		 bgFile="Interface\\AddOns\\SliceAdmiral\\Images\\winco_stripe_128.tga",
		 edgeFile="",
		 tile=true, tileSize=1, edgeSize=0,
		 insets={left=-1, right=-1, top=-1, bottom=-3}
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
 f.text:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -1);
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

 -- text on the left --
 if not f.text2 then
	f.text2 = f:CreateFontString(nil, nil, nil)
 end
 f.text2:SetFontObject(SA_Data.BarFont2);
 f.text2:SetHeight(10)
 f.text2:SetWidth(60);
 f.text2:SetPoint("TOPLEFT", f, "TOPLEFT", f.icon:GetWidth() + SliceAdmiral_Save.BarMargin + 1, 0);
 f.text2:SetJustifyH("LEFT")
 f.text2:SetText("");

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

 return f;

end

local function SA_CPFrame()
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
 f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -1, 1);
 f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 1, -2);
 f.bg:SetTexture(SA_BarTexture());
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

 for i = 1, 5 do
	local combo = CreateFrame("Frame", nil, f);	
	combo:ClearAllPoints()
	combo:SetPoint("TOPLEFT", f, "TOPLEFT", cx, 0)
	combo:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cx + cpwidth, 0)

	combo:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		 edgeFile = "Interface/Tooltips/UI-Tooltip-Border", --"Interface/Tooltips/UI-Tooltip-Border"
		 tile = true, tileSize = 8, edgeSize = 8,
		 insets = { left = 2, right = 2, top = 2, bottom = 2 }});
	combo:SetBackdropColor( 1, 0.86, 0.1);

	combo.bg = combo:CreateTexture(nil, "BACKGROUND") 
	combo:Hide()	
	f.combos[i] = combo;	
	
	cx = cx + cpwidth + spacing
 end
 cx = 0; 
 for i = 1, 5 do
	local anti = CreateFrame("Frame", nil, f);
	anti:SetFrameLevel(14); -- Better than f.combo[i] as parrent due to visibility
	anti:ClearAllPoints()
	anti:SetPoint("TOPLEFT", f, "TOPLEFT", cx, 0)
	anti:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cx + cpwidth, 0)

	anti:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		 edgeFile = "Interface/DialogFrame/UI-DialogBox-Gold-Border", --"Interface/Tooltips/UI-Tooltip-Border"
		 tile = true, tileSize = 8, edgeSize = 8,
		 insets = { left = 2, right = 2, top = 2, bottom = 2 }});
	anti:SetBackdropColor( 0.1, 0.86, 1);

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

function SA_UpdateCPWidths()
 local width = VTimerEnergy:GetWidth()
 local cx = 0;
 local spacing = width/30; --orig:= 3
 local cpwidth = ((width-(spacing*4))/5); --orig: ((width-(spacing*4))/5);

 local f = SA_Data.BARS["CP"]["obj"]

 for i = 1, 5 do
	local combo = SA_Data.BARS["CP"]["obj"].combos[i]
	local anti = SA_Data.BARS["CP"]["obj"].antis[i]
	combo:ClearAllPoints()	
	anti:ClearAllPoints()
	combo:SetPoint("TOPLEFT", f, "TOPLEFT", cx, 0)
	anti:SetPoint("TOPLEFT", f, "TOPLEFT", cx, 0)
	combo:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cx + cpwidth, 0)
	anti:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cx + cpwidth, 0)

	cx = cx + cpwidth + spacing
 end
end

function SA_UpdateStatWidths()
 local width = VTimerEnergy:GetWidth()

 local numStats = SliceAdmiral_Save.numStats or 4--HP TODO option for this
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

local function SA_CreateStatBar()
 local f = CreateFrame("StatusBar", nil, SA);
 local width = widthUI;

 f:ClearAllPoints();
 f:SetWidth(width);
 f:SetScale(scaleUI);
 f:SetHeight(15)
 f:SetPoint("BOTTOMLEFT", VTimerEnergy, "TOPLEFT", 0, 1) 

 f.bg = f:CreateTexture(nil, "BACKGROUND")
 f.bg:ClearAllPoints() 
 f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -1, 1)
 f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 1, -1)
 f.bg:SetTexture(SA_BarTexture())
 f.bg:SetVertexColor(0.3, 0.3, 0.3)
 f.bg:SetAlpha(0.7)

 f.stats = {}

 local numStats = SliceAdmiral_Save.numStats or 4; --HP TODO option for this
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
					[4] = "Armor" }
 
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

function SA_UpdateStats()
 local baseAP, buffAP, negAP = UnitAttackPower("player");
 local totalAP = baseAP+buffAP+negAP;
 local crit = GetCritChance();
 local mhSpeed, ohSpeed = UnitAttackSpeed("player");
 local name, _, icon, count = UnitAura("target", SC_SPELL_WEAKEN, nil, "HARMFUL");
 local armor = (count or 0)*4; 

 if (SA_Data.BARS["Stat"]["obj"].stats[1]) then
	local text = totalAP
	if(totalAP > 99999) then text = string.format("%.1f", totalAP/1000).."k" end
	SA_Data.BARS["Stat"]["obj"].stats[1].fs:SetText(text);
 end
 if (SA_Data.BARS["Stat"]["obj"].stats[2]) then
	SA_Data.BARS["Stat"]["obj"].stats[2].fs:SetText(string.format("%.1f%%", crit));
 end
 if (SA_Data.BARS["Stat"]["obj"].stats[3]) then
	SA_Data.BARS["Stat"]["obj"].stats[3].fs:SetText(string.format("%.2f", mhSpeed));
 end
 if (SA_Data.BARS["Stat"]["obj"].stats[4]) then
	SA_Data.BARS["Stat"]["obj"].stats[4].fs:SetText(string.format("%i%%", armor));
 end
	
 if SliceAdmiral_Save.HilightBuffed then
	SA_flashBuffedStats(totalAP,buffAP,crit,mhSpeed,armor)
 end
end

function SA_flashBuffedStats(totalAP,buffAP,crit,mhSpeed,armor) 
 local numStats = SliceAdmiral_Save.numStats or 4;
 if (not SA_Data.baseAP or SA_Data.baseAP == 0) then --initialize here since all stats = 0 when OnLoad is called.
	 SA_ResetBaseStats();
	 return
 end

 local statCheck = {};
 statCheck[1] = ( totalAP > (totalAP - buffAP));
 statCheck[2] = (crit > (SA_Data.baseCrit * 1.5)) ;
 statCheck[3] = (mhSpeed < (SA_Data.baseSpeed / 2));
 statCheck[4] = (armor == 0 and UnitExists("target"));
 
 for i = 1, numStats do
	 if statCheck[i] then
	 SA_Data.BARS["Stat"]["obj"].stats[i].fs:SetTextColor(140/255, 15/255, 0);
		 if (not UIFrameIsFading(SA_Data.BARS["Stat"]["obj"].stats[i])) then --flash if not already flashing
			if (SA_Data.BARS["Stat"]["obj"].stats[i]:GetAlpha() > 0.5) then
				UIFrameFadeOut(SA_Data.BARS["Stat"]["obj"].stats[i], 1, SA_Data.BARS["Stat"]["obj"].stats[i]:GetAlpha(), 0.1)
			else --UIFrameFlash likes to throw execeptions deep in the bliz ui?
				UIFrameFadeOut(SA_Data.BARS["Stat"]["obj"].stats[i], 1, SA_Data.BARS["Stat"]["obj"].stats[i]:GetAlpha(), 1)
			end
		 end
	 else
		SA_Data.BARS["Stat"]["obj"].stats[i].fs:SetTextColor(1, .82, 0); --default text color
		UIFrameFadeOut(SA_Data.BARS["Stat"]["obj"].stats[i], 1, SA_Data.BARS["Stat"]["obj"].stats[i]:GetAlpha(), 1) --SA_Data.BARS["Stat"]["obj"].stats[i]:SetAlpha(1);
	 end
 end
end

function SA_ResetBaseStats()
 local baseAP, buffAP, negAP = UnitAttackPower("player");
 local crit = GetCritChance();
 local mhSpeed, ohSpeed = UnitAttackSpeed("player");

 SA_Data.baseAP = baseAP+buffAP;
 SA_Data.baseCrit = crit;
 SA_Data.baseSpeed = mhSpeed; 
end

function SA_OnLoad()
 local localizedClass, englishClass = UnitClass("player");
 if (englishClass == "ROGUE") then
	 SA:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	 SA:RegisterEvent("UNIT_COMBO_POINTS");
	 SA:RegisterEvent("PLAYER_ENTERING_WORLD")
	 SA_Data.BarFont = CreateFont("VTimerFont");
	 SA_Data.BarFont:SetFont("Fonts\\FRIZQT__.TTF", 12);
	 SA_Data.BarFont:SetShadowColor(0,0,0, 0.7);
	 SA_Data.BarFont:SetTextColor(1,1,1,1);
	 SA_Data.BarFont:SetShadowOffset(0.8, -0.8);

	 SA_Data.BarFont2 = CreateFont("VTimerFont2");
	 SA_Data.BarFont2:SetFont("Fonts\\FRIZQT__.TTF", 8)
	 SA_Data.BarFont2:SetShadowColor(0,0,0, 0.7);
	 SA_Data.BarFont2:SetTextColor(213/255,200/255,184/255,1);
	 SA_Data.BarFont2:SetShadowOffset(0.8, -0.8);

	 SA_Data.BarFont3 = CreateFont("VTimerFont1O");
	 SA_Data.BarFont3:SetFont("Fonts\\FRIZQT__.TTF", 12);
	 SA_Data.BarFont3:SetShadowColor(0,0,0, 0.2);
	 SA_Data.BarFont3:SetTextColor(0,0,0,1);
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
	VTimerEnergy:SetStatusBarTexture(SA_BarTexture());
	VTimerEnergy:SetWidth(200);
	VTimerEnergy:SetStatusBarColor(254/255, 246/255, 226/255);

	scaleUI = VTimerEnergy:GetScale();
	widthUI = VTimerEnergy:GetWidth();
	
	S:SmoothBar(VTimerEnergy);
	
	SA_Data.BARS["CP"]["obj"] = SA_CPFrame();

	SA_Data.BARS["Stat"]["obj"] = SA_CreateStatBar();

	SA_Data.BARS[SC_SPELL_SND]["obj"] = SA_NewFrame();
	SA_Data.BARS[SC_SPELL_SND]["obj"]:SetStatusBarColor(255/255, 74/255, 18/255, 0.9);
	SA_Data.BARS[SC_SPELL_SND]["obj"].icon:SetTexture("Interface\\Icons\\Ability_Rogue_SliceDice");

	SA_Data.BARS[SC_SPELL_RUP]["obj"] = SA_NewFrame();
	SA_Data.BARS[SC_SPELL_RUP]["obj"]:SetStatusBarColor(130/255, 15/255, 0);
	SA_Data.BARS[SC_SPELL_RUP]["obj"].text2:SetFontObject(SA_Data.BarFont4);
	SA_Data.BARS[SC_SPELL_RUP]["obj"].icon:SetTexture("Interface\\Icons\\Ability_Rogue_Rupture");

	SA_Data.BARS[SC_SPELL_VEND]["obj"] = SA_NewFrame();
	SA_Data.BARS[SC_SPELL_VEND]["obj"]:SetStatusBarColor(130/255, 130/255, 0);
	SA_Data.BARS[SC_SPELL_VEND]["obj"].text2:SetFontObject(SA_Data.BarFont4);
	SA_Data.BARS[SC_SPELL_VEND]["obj"].icon:SetTexture("Interface\\Icons\\Ability_Rogue_Deadliness");

	SA_Data.BARS[SC_SPELL_RECUP]["obj"] = SA_NewFrame();
	SA_Data.BARS[SC_SPELL_RECUP]["obj"]:SetStatusBarColor(10/255, 10/255, 150/255);
	SA_Data.BARS[SC_SPELL_RECUP]["obj"].icon:SetTexture("Interface\\Icons\\Ability_Rogue_Recuperate");

	SA_Data.BARS[SC_SPELL_DP]["obj"] = SA_NewFrame();
	SA_Data.BARS[SC_SPELL_DP]["obj"]:SetStatusBarColor(96/255, 116/255, 65/255); 
	SA_Data.BARS[SC_SPELL_DP]["obj"].icon:SetTexture("Interface\\Icons\\Ability_Rogue_DualWeild");

	SA_Data.BARS[SC_SPELL_ENV]["obj"] = SA_NewFrame();
	SA_Data.BARS[SC_SPELL_ENV]["obj"]:SetStatusBarColor(66/255, 86/255, 35/255);
	SA_Data.BARS[SC_SPELL_ENV]["obj"].text2:SetFontObject(SA_Data.BarFont4);
	SA_Data.BARS[SC_SPELL_ENV]["obj"].icon:SetTexture("Interface\\Icons\\Ability_Rogue_Disembowel");
	
	SA_Data.BARS[SC_SPELL_FEINT]["obj"] = SA_NewFrame();
	SA_Data.BARS[SC_SPELL_FEINT]["obj"]:SetStatusBarColor(155/255, 155/255, 255/255);
	SA_Data.BARS[SC_SPELL_FEINT]["obj"]:SetMinMaxValues(0, 5.0);
	SA_Data.BARS[SC_SPELL_FEINT]["obj"].text2:SetFontObject(SA_Data.BarFont4);
	SA_Data.BARS[SC_SPELL_FEINT]["obj"].icon:SetTexture("Interface\\Icons\\Ability_Rogue_Feint");
	
	SA_Data.BARS[SC_SPELL_BAND1]["obj"] = SA_NewFrame();
	SA_Data.BARS[SC_SPELL_BAND1]["obj"]:SetStatusBarColor(34/255, 189/255, 34/255); 
	SA_Data.BARS[SC_SPELL_BAND1]["obj"].icon:SetTexture("Interface\\Icons\\Inv_Bijou_Green");
	
	SA_Data.BARS[SC_SPELL_BAND2]["obj"] = SA_NewFrame();
	SA_Data.BARS[SC_SPELL_BAND2]["obj"]:SetStatusBarColor(255/255, 215/255, 0/255); 
	SA_Data.BARS[SC_SPELL_BAND2]["obj"].icon:SetTexture("Interface\\Icons\\Inv_Bijou_Yellow");
	
	SA_Data.BARS[SC_SPELL_BAND3]["obj"] = SA_NewFrame();
	SA_Data.BARS[SC_SPELL_BAND3]["obj"]:SetStatusBarColor(200/255, 34/255, 34/255); 
	SA_Data.BARS[SC_SPELL_BAND3]["obj"].icon:SetTexture("Interface\\Icons\\Inv_Bijou_Red");
	
	SA_Data.BARS[SC_SPELL_REVEAL]["obj"] = SA_NewFrame();
	SA_Data.BARS[SC_SPELL_REVEAL]["obj"]:SetStatusBarColor(139/255, 69/255, 19/255); 
	SA_Data.BARS[SC_SPELL_REVEAL]["obj"].icon:SetTexture("Interface\\Icons\\Inv_Sword_97");
	
	SA_Data.BARS[SC_SPELL_HEMO]["obj"] = SA_NewFrame();
	SA_Data.BARS[SC_SPELL_HEMO]["obj"]:SetStatusBarColor(255/255, 5/255, 5/255); 
	SA_Data.BARS[SC_SPELL_HEMO]["obj"].icon:SetTexture("Interface\\Icons\\Spell_Shadow_Lifedrain");

	SA_Data.BARORDER = {}; -- Initial order puts the longest towards the inside.
	--SA_Data.BARORDER[] = SA_Data.BARS[""]; --Expose Armor 30sec, Anticipation 15sec, Bandits Guile 15 sec, Hemmorrage 24 sec, Feint 5-7 sec.	
	SA_Data.BARORDER[1] = SA_Data.BARS[SC_SPELL_SND]; -- 12-36 sec
	SA_Data.BARORDER[2] = SA_Data.BARS[SC_SPELL_RECUP]; -- 6 - 30 sec
	SA_Data.BARORDER[3] = SA_Data.BARS[SC_SPELL_RUP]; -- 8-24 sec
	SA_Data.BARORDER[4] = SA_Data.BARS[SC_SPELL_VEND]; -- 20 sec
	SA_Data.BARORDER[5] = SA_Data.BARS[SC_SPELL_REVEAL]; -- 18 sec
	SA_Data.BARORDER[6] = SA_Data.BARS[SC_SPELL_HEMO]; -- 24 sec	

	print("SliceAdmiral " .. SA_Version .. " loaded!! Options are under the SliceAdmiral tab in the Addons Interface menu")
 else
	SA_Unload();
	return;
 end 
end

function SA_talent()
local currentSpec = GetSpecialization();
local id, currentSpecName = GetSpecializationInfo(currentSpec);
print("Your current spec:", currentSpecName);
end

function CalcExpireTime(expireTime)	 
	if expireTime and (expireTime > 0) and (SA_Data.tNow < expireTime) then 
		return expireTime - SA_Data.tNow;
	else
		return 0;
	end
end

local Sa_filter = {	["player"] = "PLAYER", 
					["target"] = "PLAYER HARMFUL", };

local function SA_util_Time(unit, spell)
	local _, _, _, _, _, _, expirationTime = UnitAura(unit, spell, nil, Sa_filter[unit]);
	if expirationTime then		
		return CalcExpireTime(expirationTime);
	else		
		return 0;
	end
end

local function SA_UpdateBar(unit, spell, sa_sound)
	local sa_time = SA_util_Time(unit, spell);	
	SA_Data.BARS[spell]["Expires"] = sa_time;
	
	if sa_time > 0 then
		if SA_Data.BARS[spell] then
			SA_Data.BARS[spell]["obj"]:SetValue(sa_time);
			SA_Data.BARS[spell]["obj"].text:SetText(string.format("%0.1f", sa_time));
		end
	else
		SA_Data.BARS[spell]["obj"]:Hide();		
		SA_Data.BARS[spell]["Expires"] = 0;
	end	 
	
	if (sa_time <= 3) and (sa_time > 0) then
		if (SA_Data.BARS[spell]["AlertPending"] == 3) then
			SA_Data.BARS[spell]["AlertPending"] = 2;
			SA_Sound(sa_sound);
		else
			if sa_time <= 2 then
				 if (SA_Data.BARS[spell]["AlertPending"] == 2) then		 
					SA_Data.BARS[spell]["AlertPending"] = 1;
					SA_Sound(sa_sound);
				 else
					if sa_time <= 1 then
						 if (SA_Data.BARS[spell]["AlertPending"] == 1) then
							SA_Data.BARS[spell]["AlertPending"] = 0;
							SA_Sound(sa_sound);
						 end
					end
				 end
			end
		 end
	else
		SA_Data.BARS[spell]["AlertPending"] = 3;	 
	end

end

local function SA_QuickUpdateBar(unit, spell)
	local sa_time = SA_util_Time(unit, spell);	
	SA_Data.BARS[spell]["Expires"] = sa_time;
	
	if sa_time > 0 then
		if SA_Data.BARS[spell] then
			SA_Data.BARS[spell]["obj"]:SetValue(sa_time);
			SA_Data.BARS[spell]["obj"].text:SetText(string.format("%0.1f", sa_time));
		end
	else
		SA_Data.BARS[spell]["obj"]:Hide();		
		SA_Data.BARS[spell]["Expires"] = 0;
	end	 
end

function SA_OnUpdate(self, elapsed)
SA_Data.TimeSinceLastUpdate = SA_Data.TimeSinceLastUpdate + elapsed;
if (SA_Data.TimeSinceLastUpdate > SA_Data.UpdateInterval) then	
	if SliceAdmiral_Save.PadLatency then
		local down, up, lag = GetNetStats();
		SA_Data.tNow = GetTime() + (lag*2/1000);
	else
		SA_Data.tNow = GetTime();
	end
	if not SliceAdmiral_Save.HideEnergy then
		local lUnitMana = UnitMana("player");
		local lUnitManaMax = UnitManaMax("player");		

		VTimerEnergy:SetValue(lUnitMana);
		VTimerEnergy:SetMinMaxValues(0,lUnitManaMax);

		if (lUnitManaMax == lUnitMana) then
			VTimerEnergyTxt:SetText("");			
		else
			VTimerEnergyTxt:SetText(lUnitMana);			
		end
		if  (lUnitManaMax == lUnitMana) and not (VTimerEnergy:GetAlpha() == SliceAdmiral_Save.EnergyTrans / 100.0) then
			UIFrameFadeOut(VTimerEnergy, 0.4, VTimerEnergy:GetAlpha(), SliceAdmiral_Save.EnergyTrans / 100.0)
		elseif not (lUnitManaMax == lUnitMana) and not (VTimerEnergy:GetAlpha() == 1.0) then
			UIFrameFadeIn(VTimerEnergy, 0.4, VTimerEnergy:GetAlpha(), 1.0);
		end

		SA_Config_OtherVars();
	end
	
	if SliceAdmiral_Save.ShowSnDBar then		
		SA_UpdateBar("player",SC_SPELL_SND, "Tick3"); 
	end
	if SliceAdmiral_Save.RupBarShow then
		SA_UpdateBar("target", SC_SPELL_RUP, "RuptAlert"); 
	end
	if SliceAdmiral_Save.RevealBarShow then
		SA_UpdateBar("target", SC_SPELL_REVEAL, "RevealAlert");	
	end
	if SliceAdmiral_Save.ShowEnvBar then 
		SA_QuickUpdateBar("player",SC_SPELL_ENV);
	end
	if SliceAdmiral_Save.ShowFeintBar then
		SA_QuickUpdateBar("player",SC_SPELL_FEINT);
	end
	if SliceAdmiral_Save.VendBarShow then
		SA_UpdateBar("target",SC_SPELL_VEND, "VendAlert"); 
	end
	if SliceAdmiral_Save.ShowRecupBar then
		SA_UpdateBar("player", SC_SPELL_RECUP, "Recup.Alert"); 
	end
	if SliceAdmiral_Save.DPBarShow then 
		SA_QuickUpdateBar("target",SC_SPELL_DP);
	end
	if SliceAdmiral_Save.ShowGuileBar then
		SA_QuickUpdateBar("player",SC_SPELL_BAND1);
		SA_QuickUpdateBar("player",SC_SPELL_BAND2);
		SA_QuickUpdateBar("player",SC_SPELL_BAND3);
	end
	if SliceAdmiral_Save.ShowHemoBar then
		SA_QuickUpdateBar("target",SC_SPELL_HEMO);
	end

	-- We need to do this sort here because something could have been
	-- auto refreshed by a proc and we don't get an Update event for that.
	-- But.. only do it once every SA_Data.sortPeriod seconds AND if we have
	-- non-zero timers
	 if SliceAdmiral_Save.SortBars then
		 for i = 1, SA_Data.maxSortableBars do
			 if (SA_Data.BARORDER[i]["Expires"] > 0) then
				MB_SortBarsByTime(i);
				break;
			 end
		 end
	 end

	if SliceAdmiral_Save.ShowStatBar then
		SA_UpdateStats();
	end 
	SA_Data.TimeSinceLastUpdate = 0;
 end
end