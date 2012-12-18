-- Author       :cgiguy
-- Create Date : 9/10/2008 6:44:47 PM
--   This damn thing needs a full rewrite so bad I can hardly stand it
--   I wish I had the time.

SA_Version = GetAddOnMetadata("SliceAdmiral", "Version") 

SA_Data = {};
SA_Data.AlertPending = 0;
SA_Data.BarFont = 0;
SA_Data.curCombo = 0;
SA_Data.DPExpires = 0;
SA_Data.EnvExpires = 0;
SA_Data.GuilExpires = 0;	-- HagTest
SA_Data.LastEnergy = 0;
SA_Data.LastSliceExpire = 0;
SA_Data.lastSort = 0;	       -- Last time bars were sorted
SA_Data.LastTime = 0;
SA_Data.maxSortableBars = 5    -- How many sortable non-DP/Envenom timer type bars do we have?
SA_Data.RecupExpires = 0;
SA_Data.RevealAlertPending = 0; --HagTest
SA_Data.RevealExpires = 0;	-- HagTest
SA_Data.RupExpires = 0;	-- Expiration timers based on GetTime() time
SA_Data.RuptAlertPending = 0;
SA_Data.SliceExpires = 0;
SA_Data.sortPeriod = 0.5;      -- Only sort bars every sortPeriod seconds
SA_Data.tNow = 0;
SA_Data.VendAlertPending = 0;
SA_Data.VendExpires = 0;

local showStatBar = 1    -- show stat bar   AP, crit, etc
local barsup = 1         -- bars group up or down
local flashStats = 1     -- flashes statbar stats when they get mega-buffed

-- fade
local fadein = 0.5       -- fade delay for each combo point frame
local fadeout = 0.5      -- fade delay for each combo point frame
local framefadein = 0.2  -- fade delay for entering combat
local framefadeout = 0.2 -- fade delay for leaving combat
local scaleUI = 0
local widthUI = 0

SA_Data.BARS = { --TEH BARS
  ["CP"] = {
    ["obj"] = 0
  },
  ["Recup"] = {
    ["obj"] = 0,
    ["Expires"] = 0,		-- Actual time left to expire in seconds
    ["AlertPending"] = 0,
    ["Title"] = "Recup"
  },
  ["SnD"] = {
    ["obj"] = 0,
    ["Expires"] = 0,
    ["Title"] = "SnD"
  },
  ["DP"] = {
    ["obj"] = 0,
    ["Expires"] = 0,
    ["Title"] = "DP"
  },
  ["Rup"] = {
    ["obj"] = 0,
    ["Expires"] = 0,
    ["Title"] = "Rup"
  },
  ["Vend"] = {
    ["obj"] = 0,
    ["Expires"] = 0,
    ["Title"] = "Vend"
  },
  ["Env"] = {
    ["obj"] = 0,
    ["Expires"] = 0,
    ["Title"] = "Env"
  },
  ["Reveal"] = {
    ["obj"] = 0,
    ["Expires"] = 0,
    ["Title"] = "Reveal"
  },
  ["Guil1"] = {
    ["obj"] = 0,
    ["Expires"] = 0,
    ["Title"] = "Guil1"
  },
  ["Guil2"] = {
    ["obj"] = 0,
    ["Expires"] = 0,
    ["Title"] = "Guil2"
  },
  ["Guil3"] = {
    ["obj"] = 0,
    ["Expires"] = 0,
    ["Title"] = "Guil3"
  },
  ["Stat"] = {
    ["obj"] = 0,
  },
};

function SA_MoveStart(self, button)
  if (button == "LeftButton") then
    if (SliceAdmiral_Save.IsLocked == false) then
      SA:StartMoving();
    else
      SA:EnableMouse(false);
    end
  end

  --if (button == "RightButton") then
  --local x, y = GetCursorPosition();
  --local scale = UIParent:GetEffectiveScale()
  --ToggleDropDownMenu(1, nil, MyDropDownMenu, UIParent, x/scale, y/scale);
  --end
end

function SA_MoveStop()
  if (SliceAdmiral_Save.IsLocked == false) then
    SA:StopMovingOrSizing();
  end
end

function MyDropDownMenu_OnLoad()
  info = {};
  if SliceAdmiral_Save.IsLocked then
    info.text = "Unlock Position";
  else
    info.text = "Lock Position";
  end
  info.value = "OptionVariable";
  info.func = SA_ToggleIsLocked

  UIDropDownMenu_AddButton(info);

  info2            = {};
  info2.text       = "Close"--"Recalibrate Base Stats";
  info2.value      = "OptionVariable";
  --info2.func       = SA_UpdateStats

  UIDropDownMenu_AddButton(info2);
end

function SA_ToggleIsLocked()
  if SliceAdmiral_Save.IsLocked then
    SliceAdmiral_Save.IsLocked = false;
    --SA:EnableMouse(true);
  else
    SliceAdmiral_Save.IsLocked = true;
    --SA:EnableMouse(false);
  end
end

function SA_BarTexture()
  if SliceAdmiral_Save.BarTexture then
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

function SA_Sound(saved)
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

function SA_ChangeAnchor()
  local LastAnchor = VTimerEnergy;
  local offSetSize = SliceAdmiral_Save.BarMargin; -- other good values, -1, -2

  -- Stat bar goes first, because it"s fucking awesome like that
  if (showStatBar == 1) then
    --if (SliceAdmiral_Save.Barsup) then
    SA_Data.BARS["Stat"]["obj"]:ClearAllPoints();
    SA_Data.BARS["Stat"]["obj"]:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize);
    --end
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
  for i = 1, 5 do
    --print(i .. ":" .. SA_Data.BARORDER[i]["Title"] .. " = " .. SA_Data.BARORDER[i]["Expires"]);
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

  -- Deadly Poison --   DP always on the outside since it"s auto-refreshed for the rogue
  if (SA_Data.DPExpires ~= 0) then
    SA_Data.BARS["DP"]["obj"]:ClearAllPoints();
    if (SliceAdmiral_Save.Barsup) then
      SA_Data.BARS["DP"]["obj"]:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize);
    else
      SA_Data.BARS["DP"]["obj"]:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize);
    end
    LastAnchor = SA_Data.BARS["DP"]["obj"];
  end

  -- Envenom --   Envenom to finish this shiznit out.
  if (SA_Data.EnvExpires ~= 0) then
    SA_Data.BARS["Env"]["obj"]:ClearAllPoints();
    if (SliceAdmiral_Save.Barsup) then
      SA_Data.BARS["Env"]["obj"]:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize);
    else
      SA_Data.BARS["Env"]["obj"]:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize);
    end
    LastAnchor = SA_Data.BARS["DP"]["obj"];
  end
  -- HagTest -- Bandits Guile Hackatron
  if (SA_Data.GuilExpires ~= 0) then
	--Lots of hacky stuff sins its 3
  end
end


-- We only call this if SliceAdmiral_Save.SortBars
-- and we haven't done it in the last SA_Data.sortPeriod seconds
function MB_SortBarsByTime(startIndex)
--[[ 
     Dumb ass sort.  Simple shuffle of the lower bars to higher if
     they are refreshed.  It will only run once every SA_Data.sortPeriod
     seconds, max.  Also, we only call this if BARORDER contains a
     non-zero value for expiration.  AND we start at the index we
     found the non-zero value at (because we know that the bars above
     that have 0 and we don't need to sort them).
     Also, we only call SA_ChangeAnchor() if something has changed to be
     a little lighter weight.
]]
  if ((SA_Data.tNow - SA_Data.lastSort) >= SA_Data.sortPeriod) then
    local anchorChange = false;
    SA_Data.lastSort = SA_Data.tNow;
    for i = startIndex, SA_Data.maxSortableBars-1 do
      if (SA_Data.BARORDER[i]["Expires"] > SA_Data.BARORDER[i+1]["Expires"]) then
		local tmp = SA_Data.BARORDER[i];
		SA_Data.BARORDER[i] = SA_Data.BARORDER[i+1];
		SA_Data.BARORDER[i+1] = tmp;
		anchorChange = true;
      end
    end
    if anchorChange then	-- change anchor if something changed in sort order
      SA_ChangeAnchor();
    end
--    print(startIndex .. ":" .. SA_Data.tNow);
--    for i = 1, SA_Data.maxSortableBars do
--      print(i .. ":" .. SA_Data.BARORDER[i]["Title"] .. " = " .. SA_Data.BARORDER[i]["Expires"])
--    end
  end
end

function SA_SortBarsByTime()
--[[
  Simple shuffle of the lower bars to higher if they are refreshed. It
  doesnt guarantee perfect order on 1 run, but its run often enough to
  not matter.  It's done in this wierd way because we want to
  determine if any piece of the order has changed.  That way, we don't
  call ChangeAnchor() a bazillion times.. which would be *very* bad.
]]
  if not SliceAdmiral_Save.SortBars then
    return;
  end

  if (SA_Data.BARORDER[1]["Expires"] > SA_Data.BARORDER[2]["Expires"]) then
    local tmp = SA_Data.BARORDER[1];
    SA_Data.BARORDER[1] = SA_Data.BARORDER[2];
    SA_Data.BARORDER[2] = tmp;
    SA_ChangeAnchor();
  end
  if (SA_Data.BARORDER[2]["Expires"] > SA_Data.BARORDER[3]["Expires"]) then
    local tmp = SA_Data.BARORDER[2];
    SA_Data.BARORDER[2] = SA_Data.BARORDER[3];
    SA_Data.BARORDER[3] = tmp;
    SA_ChangeAnchor();
  end
  if (SA_Data.BARORDER[3]["Expires"] > SA_Data.BARORDER[4]["Expires"]) then
    local tmp = SA_Data.BARORDER[3];
    SA_Data.BARORDER[3] = SA_Data.BARORDER[4];
    SA_Data.BARORDER[4] = tmp;
    SA_ChangeAnchor();
  end
  if (SA_Data.BARORDER[4]["Expires"] > SA_Data.BARORDER[5]["Expires"]) then
    local tmp = SA_Data.BARORDER[4];
    SA_Data.BARORDER[4] = SA_Data.BARORDER[5];
    SA_Data.BARORDER[5] = tmp;
    SA_ChangeAnchor();
  end
end

function SA_OnEvent(self, event, ...)
  if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
    local timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = select(1, ...);
    if (type == "SPELL_AURA_REFRESH" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REMOVED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_PERIODIC_AURA_REMOVED" or type == "SPELL_PERIODIC_AURA_APPLIED" or type == "SPELL_PERIODIC_AURA_APPLIED_DOSE" or type == "SPELL_PERIODIC_AURA_REFRESH") then
      local spellId, spellName, spellSchool = select(12, ...);
      local isMySpell;
      --   print ("spellId = " .. spellId .. " (" .. spellName .. ")");
      --   spellName = GetSpellInfo(spellId);
      --   print("SourceName: " .. sourceName);
      if (sourceName == UnitName("player")) then
        isMySpell = true;
      else
		isMySpell = false;
      end
      if (destName == UnitName("player")) then
        --print("Spell on player: " .. spellName);
		if (spellId == SC_SPELL_SND_ID and SliceAdmiral_Save.ShowSnDBar) then
			if (type == "SPELL_AURA_REMOVED") then
				if (UnitAffectingCombat("player")) then
					SA_Sound("Expire");
				end
				SA_Data.SliceExpires = 0;
				SA_Data.BARS["SnD"]["Expires"] = 0;				
				SA_Data.BARS["SnD"]["obj"]:Hide();				
			else
				local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nspellId = UnitAura("player", SC_SPELL_SND);
				--local timeLeftOnLast = SA_Data.SliceExpires - GetTime();
				SA_Data.BARS["SnD"]["obj"]:Show();
				SA_Data.SliceExpires = expirationTime;
				SA_Data.BARS["SnD"]["Expires"] = CalcExpireTime(expirationTime);				
			end
			SA_ChangeAnchor();
		end
	-- RECUPERATE EVENT --
		if (spellId == SC_SPELL_RECUP_ID and SliceAdmiral_Save.ShowRecupBar) then
		  if (type == "SPELL_AURA_REMOVED") then
			if (UnitAffectingCombat("player")) then
			  SA_Sound("Recup.Expire");
			end
			SA_Data.RecupExpires = 0;
			SA_Data.BARS["Recup"]["Expires"] = 0;
			SA_Data.BARS["Recup"]["obj"]:Hide();
		  else
			local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nSpellId = UnitAura("player", SC_SPELL_RECUP);
			--local timeLeftOnLast = SA_Data.RecupExpires - GetTime();
			SA_Data.RecupExpires = expirationTime;
			SA_Data.BARS["Recup"]["Expires"] = CalcExpireTime(expirationTime);
			SA_Data.BARS["Recup"]["obj"]:Show();			
		  end
		  SA_ChangeAnchor();
		end
	-- ENVENOM EVENT --
		if (spellId == SC_SPELL_ENV_ID and SliceAdmiral_Save.ShowEnvBar) then
		  if (type == "SPELL_AURA_REMOVED") then
			if (UnitAffectingCombat("player")) then
			  --SA_Sound("Env.Expire");
			end
			SA_Data.EnvExpires = 0;
			SA_Data.BARS["Env"]["Expires"] = 0;			
			SA_Data.BARS["Env"]["obj"]:Hide();
		  else
			local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nSpellId = UnitAura("player", SC_SPELL_ENV);
			--local timeLeftOnLast = SA_Data.EnvExpires - GetTime();
			SA_Data.EnvExpires = expirationTime;
			SA_Data.BARS["Env"]["Expires"] = CalcExpireTime(expirationTime);
			SA_Data.BARS["Env"]["obj"]:Show();
		  end
		  SA_ChangeAnchor();
		end
      else
		if (destName == UnitName("target")) then
		  -- DEADLY POISON EVENT --
		  --print("Spell on target: " .. spellName .. "(" .. type .. ")");
		  if (isMySpell and spellId == SC_SPELL_DP_ID and SliceAdmiral_Save.DPBarShow) then
			if (type == "SPELL_AURA_REMOVED") then
			  SA_Data.DPExpires = 0;
			  SA_Data.BARS["DP"]["Expires"] = 0;
			  SA_Data.BARS["DP"]["obj"]:Hide();
			else
			  local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nspellId = UnitDebuff("target", SC_SPELL_DP, nil, "PLAYER");
			  SA_Data.DPExpires = expirationTime;
			  SA_Data.BARS["DP"]["Expires"] = CalcExpireTime(expirationTime);
			-- SA_Data.BARS["DP"]["obj"].text2:SetText("x" .. string.format("%i", count1));
			  SA_Data.BARS["DP"]["obj"]:Show();
			end
			SA_ChangeAnchor();
		  end
		  -- RUPTURE EVENT --
		  if (isMySpell and spellId == SC_SPELL_RUP_ID and SliceAdmiral_Save.RupBarShow) then
			-- print("Rupture event: " .. type);
			if (type == "SPELL_AURA_REMOVED") then
			  if (UnitAffectingCombat("player")) then
				SA_Sound("RuptExpire");
			  end
			  SA_Data.RupExpires = 0;
			  SA_Data.BARS["Rup"]["Expires"] = 0;
			  SA_Data.BARS["Rup"]["obj"]:Hide();
			else
			  local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nSpellId = UnitDebuff("target", SC_SPELL_RUP, nil, "PLAYER");
			  SA_Data.RupExpires = expirationTime;
			  SA_Data.BARS["Rup"]["Expires"] = CalcExpireTime(expirationTime);
			  SA_Data.BARS["Rup"]["obj"]:Show();
			end
			SA_ChangeAnchor();
		  end
		  -- HagTest REVEALING STRIKE EVENT --
		  if (isMySpell and spellId == SC_SPELL_REVEAL_ID and SliceAdmiral_Save.RevealBarShow) then
			-- print("Rupture event: " .. type);
			if (type == "SPELL_AURA_REMOVED") then
			  if (UnitAffectingCombat("player")) then
				SA_Sound("RevealExpire");
			  end
			  SA_Data.RevealExpires = 0;
			  SA_Data.BARS["Reveal"]["Expires"] = 0;
			  SA_Data.BARS["Reveal"]["obj"]:Hide();
			else
			  local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nSpellId = UnitDebuff("target", SC_SPELL_REVEAL, nil, "PLAYER");
			  SA_Data.RevealExpires = expirationTime;
			  SA_Data.BARS["Reveal"]["Expires"] = CalcExpireTime(expirationTime);
			  SA_Data.BARS["Reveal"]["obj"]:Show();
			end
			SA_ChangeAnchor();
		  end
		  -- VENDETTA EVENT --
		  if (isMySpell and spellId == SC_SPELL_VEND_ID and SliceAdmiral_Save.VendBarShow) then
			if (type == "SPELL_AURA_REMOVED") then
			  if (UnitAffectingCombat("player")) then
				SA_Sound("VendExpire");
			  end
			  SA_Data.VendExpires = 0;
			  SA_Data.BARS["Vend"]["Expires"] = 0;
			  SA_Data.BARS["Vend"]["obj"]:Hide();
			else
			  local name, rank, icon, coun, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nSpellId = UnitDebuff("target", SC_SPELL_VEND, nil, "PLAYER");
			  SA_Data.VendExpires = expirationTime;
			  SA_Data.BARS["Vend"]["Expires"] = CalcExpireTime(expirationTime);
			  SA_Data.BARS["Vend"]["obj"]:Show();
			end
			SA_ChangeAnchor();
		  end
		end
      end
    end -- "SPELL_AURA_REFRESH" or ...
    -- DOT monitors
    if (SliceAdmiral_Save.ShowDoTDmg and type == "SPELL_PERIODIC_DAMAGE" and destName == UnitName("target") and sourceName == UnitName("player")) then
      local spellId, spellName, spellSchool = select(12, ...);
      -- spellName = GetSpellInfo(spellId);
      if (spellId == SC_SPELL_RUP_ID and SliceAdmiral_Save.RupBarShow) then
		local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(15, ...)
		SA_Data.BARS["Rup"]["obj"].DoTtext:SetAlpha(1);
		if (SliceAdmiral_Save.DoTCrits and critical) then
		  SA_Data.BARS["Rup"]["obj"].DoTtext:SetText(string.format("*%.0f*", amount));
		  UIFrameFadeOut(SA_Data.BARS["Rup"]["obj"].DoTtext, 3, 1, 0);
		else
		  SA_Data.BARS["Rup"]["obj"].DoTtext:SetText(amount);
		  UIFrameFadeOut(SA_Data.BARS["Rup"]["obj"].DoTtext, 2, 1, 0);
		end
      end
      if (spellId == SC_SPELL_DP_ID and SliceAdmiral_Save.DPBarShow) then
		local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(15, ...)
		SA_Data.BARS["DP"]["obj"].DoTtext:SetAlpha(1);
		if (SliceAdmiral_Save.DoTCrits and critical) then
		  SA_Data.BARS["DP"]["obj"].DoTtext:SetText(string.format("*%.0f*", amount));
		  UIFrameFadeOut(SA_Data.BARS["DP"]["obj"].DoTtext, 3, 1, 0);
		else
		  SA_Data.BARS["DP"]["obj"].DoTtext:SetText(amount);
		  UIFrameFadeOut(SA_Data.BARS["DP"]["obj"].DoTtext, 2, 1, 0);
		end
      end
    end
  end -- event == "COMBAT_LOG_EVENT_UNFILTERED"

  if (event == "UNIT_COMBO_POINTS") then
    local unit = select(1, ...);
    if (unit and unit == "player") then
      SA_SetComboPts();
    end
  end
  if event == "PLAYER_TARGET_CHANGED" then
    SA_SetComboPts();
    SA_TestTarget();
  end

  if UnitAffectingCombat("player") then
    SA:SetAlpha(1.0);
  else
    SA:SetAlpha(SA_Fade:GetValue()/100);
  end
end

function SA_TestTarget() 
  if SliceAdmiral_Save.DPBarShow then
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nspellId = UnitDebuff("target", SC_SPELL_DP, nil, "PLAYER");
    if not name then
      SA_Data.DPExpires = 0;
      SA_Data.BARS["DP"]["Expires"] = 0;
      SA_Data.BARS["DP"]["obj"]:Hide();
    else
      if (isMine == "player") then
		SA_Data.DPExpires = expirationTime;
		SA_Data.BARS["DP"]["Expires"] = CalcExpireTime(expirationTime);
		--SA_Data.BARS["DP"]["obj"].text2:SetText("x" .. string.format("%i", count));
		SA_Data.BARS["DP"]["obj"]:Show();
      else
		SA_Data.DPExpires = 0;
		SA_Data.BARS["DP"]["Expires"] = 0;
		SA_Data.BARS["DP"]["obj"]:Hide();
      end
    end
  end

  if SliceAdmiral_Save.RupBarShow then
    local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nSpellId = UnitDebuff("target", SC_SPELL_RUP, nil, "PLAYER");
    if not name then
      SA_Data.RupExpires = 0;
      SA_Data.BARS["Rup"]["Expires"] = 0;
      SA_Data.BARS["Rup"]["obj"]:Hide();
    else
      if (isMine == "player") then
		SA_Data.RupExpires = expirationTime;
		SA_Data.BARS["Rup"]["Expires"] = CalcExpireTime(expirationTime);
		SA_Data.BARS["Rup"]["obj"]:Show();
      else
		SA_Data.RupExpires = 0;
		SA_Data.BARS["Rup"]["Expires"] = 0;
		SA_Data.BARS["Rup"]["obj"]:Hide();		
      end
    end
	SA_ChangeAnchor();--change les ancres
  end
  if SliceAdmiral_Save.RevealBarShow then
    local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nSpellId = UnitDebuff("target", SC_SPELL_REVEAL, nil, "PLAYER");
    if not name then
      SA_Data.RevealExpires = 0;
      SA_Data.BARS["Reveal"]["Expires"] = 0;
      SA_Data.BARS["Reveal"]["obj"]:Hide();
    else
      if (isMine == "player") then
		SA_Data.RupExpires = expirationTime;
		SA_Data.BARS["Reveal"]["Expires"] = CalcExpireTime(expirationTime);
		SA_Data.BARS["Reveal"]["obj"]:Show();
      else
		SA_Data.RupExpires = 0;
		SA_Data.BARS["Reveal"]["Expires"] = 0;
		SA_Data.BARS["Reveal"]["obj"]:Hide();
      end
    end
	SA_ChangeAnchor();--change les ancres
  end
  if SliceAdmiral_Save.VendBarShow then
    local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nSpellId = UnitDebuff("target", SC_SPELL_VEND, nil, "PLAYER");
    if not name then
      SA_Data.VendExpires = 0;
      SA_Data.BARS["Vend"]["Expires"] = 0;
      SA_Data.BARS["Vend"]["obj"]:Hide();
    else
      if (isMine == "player") then
		SA_Data.VendExpires = expirationTime;
		SA_Data.BARS["Vend"]["Expires"] = CalcExpireTime(expirationTime);
		SA_Data.BARS["Vend"]["obj"]:Show();
      else
		SA_Data.VendExpires = 0;
		SA_Data.BARS["Vend"]["Expires"] = 0;
		SA_Data.BARS["Vend"]["obj"]:Hide();
      end
    end
	SA_ChangeAnchor();
  end
end

local curCombo = 0

function SA_SetComboPts()
  local points = GetComboPoints("player");
  if SliceAdmiral_Save.CPBarShow then
    if points == curCombo then
      if curCombo == 0 and not incombat and visible then
		--UIFrameFadeOut(SA_Data.BARS["CP"]["obj"], framefadeout);
		visible = false;
      elseif curCombo > 0 and not visible then
		--UIFrameFadeIn(SA_Data.BARS["CP"]["obj"], framefadein);
		visible = true;
      end
      return
    end
    if (points > curCombo) then
      for i = curCombo + 1, points do
		SA_Data.BARS["CP"]["obj"].combos[i]:Show();
      end
      SA_Combo:SetText(points);
    else
      for i = points + 1, curCombo do
		SA_Data.BARS["CP"]["obj"].combos[i]:Hide();
      end
      SA_Combo:SetText("");
    end
    --[[if points > 0 then
    SA_Data.BARS["CP"]["obj"].comboText:SetText(points);
    else
    SA_Data.BARS["CP"]["obj"].comboText:SetText("");
    end]]
    curCombo = points;
    if curCombo == 0 and not incombat and visible then
      --UIFrameFadeOut(SA_Data.BARS["CP"]["obj"], framefadeout);
      visible = false;
    elseif curCombo > 0 and not visible then
      --UIFrameFadeIn(SA_Data.BARS["CP"]["obj"], framefadein);
      visible = true;
    end
  else
    if (points > curCombo) then
      SA_Combo:SetText(points);
    else
      SA_Combo:SetText("");
    end
  end
end

function SA_Unload()
  SA:UnregisterAllEvents();
  SA:Hide();
  SA_Config_CPFrame:Hide();
end

function SA_NewFrame()
  local f = CreateFrame("StatusBar", nil, SA);

  f:SetWidth(widthUI);
  f:SetScale(scaleUI);
  f:SetHeight(12);

  --f:SetPoint("BOTTOMLEFT", SA_Data.BARS["Stat"]["obj"], "TOPLEFT", 0, 2);
  --if (SliceAdmiral_Save.Barsup) then
  -- print("True while creating timer bar")
  f:SetPoint("BOTTOMLEFT", VTimerEnergy, "TOPLEFT", 0, 2);
  --else
  -- f:SetPoint("TOPLEFT", VTimerEnergy, "BOTTOMLEFT", 0, -2); --orig (goes down)
  --end

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
  f.text:SetPoint("TOPRIGHT", f, "TOPRIGHT",  -5, 0);
  f.text:SetJustifyH("RIGHT")
  f.text:SetText("");

  -- icon on the left --
  if not f.icon then
    f.icon = f:CreateTexture(nil, "OVERLAY");
  end
  f.icon:SetHeight(f:GetHeight());
  f.icon:SetWidth(f.icon:GetHeight());
  f.icon:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1);
  f.icon:SetBlendMode("ADD");
  f.icon:SetAlpha(.99);

  -- text on the left --
  if not f.text2 then
    f.text2 = f:CreateFontString(nil, nil, nil)
  end
  f.text2:SetFontObject(SA_Data.BarFont2);
  f.text2:SetHeight(10)
  f.text2:SetWidth(60);
  f.text2:SetPoint("TOPLEFT", f, "TOPLEFT",  f.icon:GetWidth() + SliceAdmiral_Save.BarMargin + 1, 0);
  f.text2:SetJustifyH("LEFT")
  f.text2:SetText("");

  -- DoT Text --
  if not f.DoTtext then
    f.DoTtext = f:CreateFontString(nil, nil, nil)
  end
  f.DoTtext:SetFontObject(SA_Data.BarFont2);
  f.DoTtext:SetHeight(10)
  f.DoTtext:SetWidth(60);
  f.DoTtext:SetPoint("CENTER", f, "CENTER",  0 , 0);
  f.DoTtext:SetJustifyH("CENTER")
  f.DoTtext:SetText("");

  return f;

end

function SA_CPFrame()
  local f = CreateFrame("StatusBar", nil, SA);
  local width = widthUI --SA_Data.BARS["CP"]["obj"]:GetWidth();

  f:ClearAllPoints();
  f:SetWidth(width);
  f:SetScale(scaleUI);
  f:SetHeight(10)
  --if (SliceAdmiral_Save.Barsup) then
  --   print("True while creating CP bar")
  f:SetPoint("TOPLEFT", VTimerEnergy, "BOTTOMLEFT", 0, -3);
  --else
  -- f:SetPoint("BOTTOMLEFT", VTimerEnergy, "TOPLEFT", 0, 3); --orig (top?)
  --end
  f.bg = f:CreateTexture(nil, "BACKGROUND")
  f.bg:ClearAllPoints()
  --f.bg:SetAllPoints(f)
  f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -2, 2)
  f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 2, -2)
  f.bg:SetTexture(SA_BarTexture())
  f.bg:SetVertexColor(0.3, 0.3, 0.3)
  f.bg:SetAlpha(0.7)

  f.combos = {}

  local cx = 0;
  local spacing = width/30; --orig:= 3
  local cpwidth = ((width-(spacing*4))/9.2);

  -- text
  local font = "Fonts\\FRIZQT__.TTF"
  local fontsize = 12
  local fontstyle = "OUTLINE"

  for i = 1, 5 do
    local combo = CreateFrame("Frame", nil, f)
    combo:ClearAllPoints()
    combo:SetPoint("TOPLEFT", f, "TOPLEFT", cx, 0)
    combo:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cx + cpwidth, 0)

    combo:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		       edgeFile = "Interface/Tooltips/UI-Tooltip-Border", --"Interface/Tooltips/UI-Tooltip-Border"
		       tile = true, tileSize = 8, edgeSize = 8,
		       insets = { left = 2, right = 2, top = 2, bottom = 2 }});
    combo:SetBackdropColor( 1, 0.86, 0.1);

    combo.bg = combo:CreateTexture(nil, "BACKGROUND")
    --[[combo.bg:ClearAllPoints()
    combo.bg:SetAllPoints(combo)
    combo.bg:SetTexture(SA_BarTexture())
    combo.bg:SetVertexColor(1, 0.86, 0.1)
    combo.bg:SetAlpha(1)]]
    combo:Hide()

    f.combos[i] = combo
    cx = cx + cpwidth + spacing
  end

  f.overlay = CreateFrame("Frame", nil, f)
  f.overlay:ClearAllPoints()
  f.overlay:SetAllPoints(f)
  --[[f.comboText = f.overlay:CreateFontString(nil, "OVERLAY")
  f.comboText:SetFont(font, fontsize, fontstyle)
  f.comboText:SetShadowOffset(1, -1)
  f.comboText:SetShadowColor(0, 0, 0, 1)
  f.comboText:SetJustifyH("CENTER")
  f.comboText:ClearAllPoints()
  f.comboText:SetAllPoints(f.overlay)
  --f.comboText:SetText("5")]]

  visible = false
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
    combo:ClearAllPoints()
    combo:SetPoint("TOPLEFT", f, "TOPLEFT", cx, 0)
    combo:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cx + cpwidth, 0)

    cx = cx + cpwidth + spacing
  end
end

function SA_UpdateStatWidths()
  local width = VTimerEnergy:GetWidth()

  local numStats = 3 --HP TODO option for this
  local spacing = width/90;
  local cpwidth = ((width-(spacing*3))/(numStats));
  local cur_location = 0; --small initial offset

  local f = SA_Data.BARS["Stat"]["obj"];

  for i = 1, numStats do
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
  end
end

function SA_CreateStatBar()
  local f = CreateFrame("StatusBar", nil, SA);
  local width = widthUI;

  f:ClearAllPoints();
  f:SetWidth(width);
  f:SetScale(scaleUI);
  f:SetHeight(15)

  --if (SliceAdmiral_Save.Barsup) then
  --    print("True while creating stat bar")
  f:SetPoint("BOTTOMLEFT", VTimerEnergy, "TOPLEFT", 0, 3)
  --else
  --    print("FAlse while creating stat bar")
  -- f:SetPoint("TOPLEFT", VTimerEnergy, "BOTTOMLEFT", 0, -3)
  --end

  f.bg = f:CreateTexture(nil, "BACKGROUND")
  f.bg:ClearAllPoints()
  --f.bg:SetAllPoints(f)
  f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -2, 2)
  f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 2, -2)
  f.bg:SetTexture(SA_BarTexture())
  f.bg:SetVertexColor(0.3, 0.3, 0.3)
  f.bg:SetAlpha(0.7)
  --[[f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
  edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
  tile = true, tileSize = 8, edgeSize = 8,
  insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  f:SetBackdropColor(0,0,0,1);]]

  f.stats = {}

  local numStats = 3; --HP TODO option for this
  local spacing = width/60;
  local cpwidth = ((width-(spacing*3))/(numStats*1.5));
  local cur_location = 2; --small initial offset

  -- text
  local font = "Fonts\\FRIZQT__.TTF"
  local fontsize = 9
  if (numStats > 3) then
    fontsize = 7;
  end

  local fontstyle = "OUTLINE"

  for i = 1, numStats do
    --Create the frame & space it
    local statText = CreateFrame("Frame", nil, f)
    statText:ClearAllPoints()
    --statText:SetBackdropBorderColor(1,0.1,0.1);
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
    labelFrame:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cur_location + cpwidth, 0)
    ----Create stat label FontString
    labelFrame.fs = labelFrame:CreateFontString("$parentText","ARTWORK","GameFontNormal");
    labelFrame.fs:SetJustifyH("CENTER")
    labelFrame.fs:SetJustifyV("BOTTOM")
    labelFrame.fs:SetFont(font, fontsize/1.8, "");
    labelFrame.fs:SetAllPoints();
    if (i == 1) then
      labelFrame.fs:SetText("ap");
    elseif (i == 2) then
      labelFrame.fs:SetText("crit");
    elseif (i == 3) then
      labelFrame.fs:SetText("speed");
    elseif (i == 4) then
      labelFrame.fs:SetText("Stat 4");
    end

    f.stats[i] = statText;
    f.stats[i].labelFrame = labelFrame;

    cur_location = cur_location + cpwidth + spacing;
  end

  return f;
end

function SA_UpdateStats()

  if not SliceAdmiral_Save.ShowStatBar then
    return;
  end

  local baseAP, buffAP, negAP = UnitAttackPower("player");
  local totalAP = baseAP+buffAP+negAP;
  local crit = GetCritChance();
  local mhSpeed, ohSpeed = UnitAttackSpeed("player");

  if (SA_Data.BARS["Stat"]["obj"].stats[1]) then
    SA_Data.BARS["Stat"]["obj"].stats[1].fs:SetText(totalAP);
  end
  if (SA_Data.BARS["Stat"]["obj"].stats[2]) then
    SA_Data.BARS["Stat"]["obj"].stats[2].fs:SetText(string.format("%.1f%%", crit));
  end
  if (SA_Data.BARS["Stat"]["obj"].stats[3]) then
    SA_Data.BARS["Stat"]["obj"].stats[3].fs:SetText(string.format("%.2f", mhSpeed));
  end

  if SliceAdmiral_Save.HilightBuffed then
    SA_flashBuffedStats()
  end
end

function SA_flashBuffedStats()
  local numStats = 3;
  local baseAP, buffAP, negAP = UnitAttackPower("player");
  local totalAP = baseAP+buffAP+negAP;
  local crit = GetCritChance();
  local mhSpeed, ohSpeed = UnitAttackSpeed("player");

  if (not SA_Data.baseAP or SA_Data.baseAP == 0) then --initialize here since all stats = 0 when OnLoad is called.
    SA_ResetBaseStats();
    return
  end

  local statCheck = {};
  statCheck[1] = false;
  statCheck[2] = false;
  statCheck[3] = false;
  statCheck[4] = false;

  if ( totalAP > (SA_Data.baseAP * 1.01)) then --TODO explain
    statCheck[1] = true;
  end

  if (crit > (SA_Data.baseCrit * 1.5)) then
    statCheck[2] = true;
  end

  if (mhSpeed < (SA_Data.baseSpeed / 2)) then
    statCheck[3] = true;
  end

  for i = 1, numStats do
    if statCheck[i] then
      SA_Data.BARS["Stat"]["obj"].stats[i].fs:SetTextColor(140/255, 15/255, 0);
      if (not UIFrameIsFading(SA_Data.BARS["Stat"]["obj"].stats[i])) then --flash if not already flashing
		if  (SA_Data.BARS["Stat"]["obj"].stats[i]:GetAlpha() > 0.5) then
		  UIFrameFadeOut(SA_Data.BARS["Stat"]["obj"].stats[i], 1, 1, 0.1)
		else  --UIFrameFlash likes to throw execeptions deep in the bliz ui?
		  UIFrameFadeOut(SA_Data.BARS["Stat"]["obj"].stats[i], 1, 0.1, 1)
		end
      end
    else
      SA_Data.BARS["Stat"]["obj"].stats[i].fs:SetTextColor(1, .82, 0); --default text color
      SA_Data.BARS["Stat"]["obj"].stats[i]:SetAlpha(1);
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
  --print("Base#s: ".. SA_Data.baseAP .. " " .. SA_Data.baseCrit .. " " .. SA_Data.baseSpeed);
end

function SA_OnLoad()
  local localizedClass, englishClass = UnitClass("player");
  if (englishClass == "ROGUE") then
    SA:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    SA:RegisterEvent("UNIT_COMBO_POINTS");
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
    --SA_Data.BarFont4:SetTextColor(213/255,200/255,184/255,1);
    SA_Data.BarFont3:SetTextColor(0,0,0,1);
    SA_Data.BarFont4:SetShadowOffset(0.8, -0.8);

    SA_Data.LastEnergy = UnitMana("player");

    VTimerEnergyTxt:SetFontObject(SA_Data.BarFont);
    SA_Combo:SetFontObject(SA_Data.BarFont3);

    VTimerEnergy:SetMinMaxValues(0,UnitManaMax("player"));
    VTimerEnergy:SetBackdrop({
			       bgFile="Interface\\AddOns\\SliceAdmiral\\Images\\winco_stripe_128.tga",
			       edgeFile="",
			       tile=true, tileSize=1, edgeSize=0,
			       insets={left=-1, right=-1, top=-1, bottom=0}
			   });
    --"Interface\\TargetingFrame\\UI-StatusBar"
    VTimerEnergy:SetBackdropBorderColor(1,1,1,1);
    VTimerEnergy:SetBackdropColor(0,0,0,0.2);
    VTimerEnergy:SetStatusBarTexture(SA_BarTexture());
    VTimerEnergy:SetWidth(200);
    VTimerEnergy:SetStatusBarColor(254/255, 246/255, 226/255);

    scaleUI = VTimerEnergy:GetScale();
    widthUI = VTimerEnergy:GetWidth();

    SA_Data.BARS["CP"]["obj"] = SA_CPFrame();

    SA_Data.BARS["Stat"]["obj"] = SA_CreateStatBar();

    SA_Data.BARS["SnD"]["obj"] = SA_NewFrame();
    SA_Data.BARS["SnD"]["obj"]:SetStatusBarColor(255/255, 74/255, 18/255, 0.9);
    SA_Data.BARS["SnD"]["obj"].icon:SetTexture("Interface\\Icons\\Ability_Rogue_SliceDice");

    SA_Data.BARS["Rup"]["obj"] = SA_NewFrame();
    SA_Data.BARS["Rup"]["obj"]:SetStatusBarColor(130/255, 15/255, 0);
    SA_Data.BARS["Rup"]["obj"].text2:SetFontObject(SA_Data.BarFont4);
    SA_Data.BARS["Rup"]["obj"].icon:SetTexture("Interface\\Icons\\Ability_Rogue_Rupture");

    SA_Data.BARS["Vend"]["obj"] = SA_NewFrame();
    SA_Data.BARS["Vend"]["obj"]:SetStatusBarColor(130/255, 130/255, 0);
    SA_Data.BARS["Vend"]["obj"].text2:SetFontObject(SA_Data.BarFont4);
    SA_Data.BARS["Vend"]["obj"].icon:SetTexture("Interface\\Icons\\Ability_Rogue_Deadliness");

    SA_Data.BARS["Recup"]["obj"] = SA_NewFrame();
    SA_Data.BARS["Recup"]["obj"]:SetStatusBarColor(10/255, 10/255, 150/255);
    SA_Data.BARS["Recup"]["obj"].icon:SetTexture("Interface\\Icons\\Ability_Rogue_Recuperate");

    SA_Data.BARS["DP"]["obj"] = SA_NewFrame();
    SA_Data.BARS["DP"]["obj"]:SetStatusBarColor(96/255, 116/255, 65/255);
    --SA_Data.BARS["DP"]["obj"].text2:SetFontObject(SA_Data.BarFont4);
    SA_Data.BARS["DP"]["obj"].icon:SetTexture("Interface\\Icons\\Ability_Rogue_DualWeild");

    SA_Data.BARS["Env"]["obj"] = SA_NewFrame();
    SA_Data.BARS["Env"]["obj"]:SetStatusBarColor(66/255, 86/255, 35/255);
    SA_Data.BARS["Env"]["obj"].text2:SetFontObject(SA_Data.BarFont4);
    SA_Data.BARS["Env"]["obj"].icon:SetTexture("Interface\\Icons\\Ability_Rogue_Disembowel");
	
	SA_Data.BARS["Guil1"]["obj"] = SA_NewFrame();
    SA_Data.BARS["Guil1"]["obj"]:SetStatusBarColor(34/255, 189/255, 34/255);
    --SA_Data.BARS["Guil1"]["obj"].text2:SetFontObject(SA_Data.BarFont4);
    SA_Data.BARS["Guil1"]["obj"].icon:SetTexture("Interface\\Icons\\Inv_Bijou_Green");
	
	SA_Data.BARS["Guil2"]["obj"] = SA_NewFrame();
    SA_Data.BARS["Guil2"]["obj"]:SetStatusBarColor(255/255, 215/255, 0/255);
   -- SA_Data.BARS["Guil2"]["obj"].text2:SetFontObject(SA_Data.BarFont4);
    SA_Data.BARS["Guil2"]["obj"].icon:SetTexture("Interface\\Icons\\Inv_Bijou_Yellow");
	
	SA_Data.BARS["Guil3"]["obj"] = SA_NewFrame();
    SA_Data.BARS["Guil3"]["obj"]:SetStatusBarColor(200/255, 34/255, 34/255);
    --SA_Data.BARS["Guil3"]["obj"].text2:SetFontObject(SA_Data.BarFont4);
    SA_Data.BARS["Guil3"]["obj"].icon:SetTexture("Interface\\Icons\\Inv_Bijou_Red");
	
	SA_Data.BARS["Reveal"]["obj"] = SA_NewFrame();
    SA_Data.BARS["Reveal"]["obj"]:SetStatusBarColor(139/255, 69/255, 19/255);
    SA_Data.BARS["Reveal"]["obj"].text2:SetFontObject(SA_Data.BarFont4);
    SA_Data.BARS["Reveal"]["obj"].icon:SetTexture("Interface\\Icons\\Inv_Sword_97");

    SA_Data.BARORDER = {}; -- Initial order puts the longest towards the inside.
    --SA_Data.BARORDER[] = SA_Data.BARS[""]; --Expose Armor 30sec, Anticipation 15sec, Bandits Guile 15 sec, Hemmorrage 24 sec.
	SA_Data.BARORDER[1] = SA_Data.BARS["SnD"]; -- 12-36 sec
	SA_Data.BARORDER[2] = SA_Data.BARS["Recup"]; -- 6 - 30 sec
    SA_Data.BARORDER[3] = SA_Data.BARS["Rup"]; -- 8-24 sec
    SA_Data.BARORDER[4] = SA_Data.BARS["Vend"]; -- 20 sec
	SA_Data.BARORDER[5] = SA_Data.BARS["Reveal"]; -- 18 sec

    SA_OnUpdate();
    SA_SetComboPts();
    SA_TestTarget();

    print("SliceAdmiral " .. SA_Version .. " loaded!! Options are under the SliceAdmiral tab in the Addons Interface menu")
  else
    SA_Unload();
    return;
  end
end

function CalcExpireTime(expireTime)
  if (expireTime == nil) then
    return 0
  end

  if ((expireTime > 0) and (SA_Data.tNow < expireTime)) then
    -- print ("Expires: " .. expireTime - SA_Data.tNow);
    return expireTime - SA_Data.tNow;
  else
    return 0;
  end
end

function SA_util_SnDBuffTime()
  local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nSpellId = UnitAura("player", SC_SPELL_SND);
  if expirationTime then
    --   print ("SND ETime: " .. expirationTime);
    SA_Data.SliceExpires = expirationTime;
  else
    return 0;
  end
  return CalcExpireTime(expirationTime);
end

function SA_util_RecupTime()
  local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nSpellId = UnitAura("player", SC_SPELL_RECUP);
  --   print ("RECUP ETime: " .. expirationTime);
  if (expirationTime) then
    SA_Data.RecupExpires = expirationTime;
  else
    SA_Data.RecupExpires = 0;
    return 0;
  end
  return CalcExpireTime(expirationTime);
end

-- Envenom can"t be refreshed by anything
function SA_util_EnvenomTime()
  if ((SA_Data.EnvExpires > 0) and (SA_Data.tNow < SA_Data.EnvExpires)) then
    return SA_Data.EnvExpires - SA_Data.tNow;
  else
    SA_Data.EnvExpires = 0;
    return 0;
  end
end

function SA_util_DPTime()
  local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nSpellId = UnitDebuff("target", SC_SPELL_DP,nil, "PLAYER");
  if expirationTime then
    --   print ("DP ETime: " .. expirationTime);
    SA_Data.DPExpires = expirationTime;
  else
    SA_Data.DPExpires = 0;
    return 0;
  end
  return CalcExpireTime(expirationTime);
end

function SA_util_RupTime()
  local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nSpellId = UnitDebuff("target", SC_SPELL_RUP, nil, "PLAYER");
  if (expirationTime) then
    -- print ("RUP ETime: " .. expirationTime);
    SA_Data.RupExpires = expirationTime;
  else
    SA_Data.RupExpires = 0;
    return 0;
  end
  return CalcExpireTime(SA_Data.RupExpires);
end

function SA_util_RevealTime()
  local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable, shouldConsolidate, nSpellId = UnitDebuff("target", SC_SPELL_REVEAL, nil, "PLAYER");
  if (expirationTime) then
    -- print ("RUP ETime: " .. expirationTime);
    SA_Data.RevealExpires = expirationTime;
  else
    SA_Data.RevealExpires = 0;
    return 0;
  end
  return CalcExpireTime(SA_Data.RevealExpires);
end


-- Vendetta can't be refreshed by anything
function SA_util_VendTime()
  return CalcExpireTime(SA_Data.VendExpires);
end

function SA_RupBar()
  local x = SA_util_RupTime();
  SA_Data.BARS["Rup"]["Expires"] = x;

  if (x > 0) then
    if (SA_Data.BARS["Rup"]) then
      SA_Data.BARS["Rup"]["obj"]:SetValue(x);
      SA_Data.BARS["Rup"]["obj"].text:SetText(string.format("%0.1f", x));
    end
  else
    --SA_Data.BARS["Rup"]["obj"].text2:SetText(isMine2);
    SA_Data.BARS["Rup"]["obj"]:Hide();
    SA_Data.RupExpires = 0;
    SA_Data.BARS["Rup"]["Expires"] = 0;
  end

  xSound = "RuptAlert";
  if (x > 0) then
    if (x <= 3) then
      if (SA_Data.RuptAlertPending == 3) then
		SA_Sound(xSound);
		SA_Data.RuptAlertPending = 2;
      else
		if (x <= 2) then
		  if (SA_Data.RuptAlertPending == 2) then
			SA_Sound(xSound);
			SA_Data.RuptAlertPending = 1;
		  else
			if (x <= 1) then
			  if (SA_Data.RuptAlertPending == 1) then
				SA_Sound(xSound);
				SA_Data.RuptAlertPending = 0;
			  end
			end
		  end
		end
      end
    else
      SA_Data.RuptAlertPending = 3;
    end
  end
end

function SA_RevealBar()
  local x = SA_util_RevealTime();
  SA_Data.BARS["Reveal"]["Expires"] = x;

  if (x > 0) then
    if (SA_Data.BARS["Reveal"]) then
      SA_Data.BARS["Reveal"]["obj"]:SetValue(x);
      SA_Data.BARS["Reveal"]["obj"].text:SetText(string.format("%0.1f", x));
    end
  else
    --SA_Data.BARS["Reveal"]["obj"].text2:SetText(isMine2);
    SA_Data.BARS["Reveal"]["obj"]:Hide();
    SA_Data.RevealExpires = 0;
    SA_Data.BARS["Reveal"]["Expires"] = 0;
  end

  xSound = "RevealAlert";
  if (x > 0) then
    if (x <= 3) then
      if (SA_Data.RevealAlertPending == 3) then
		SA_Sound(xSound);
		SA_Data.RevealAlertPending = 2;
      else
		if (x <= 2) then
		  if (SA_Data.RevealAlertPending == 2) then
			SA_Sound(xSound);
			SA_Data.RevealAlertPending = 1;
		  else
			if (x <= 1) then
			  if (SA_Data.RevealAlertPending == 1) then
				SA_Sound(xSound);
				SA_Data.RevealAlertPending = 0;
			  end
			end
		  end
		end
      end
    else
      SA_Data.RevealAlertPending = 3;
    end
  end
end

function SA_VendBar()
  local x = SA_util_VendTime();
  SA_Data.BARS["Vend"]["Expires"] = x;

  if (x > 0) then
    if (SA_Data.BARS["Vend"]) then
      SA_Data.BARS["Vend"]["obj"]:SetValue(x);
      SA_Data.BARS["Vend"]["obj"].text:SetText(string.format("%0.1f", x));
    end
  else
    --SA_Data.BARS["Vend"]["obj"].text2:SetText(isMine2);
    SA_Data.BARS["Vend"]["obj"]:Hide();
    SA_Data.VendExpires = 0;
    SA_Data.BARS["Vend"]["Expires"] = 0;
  end

  xSound = "VendAlert";
  if (x > 0) then
    if (x <= 3) then
      if (SA_Data.VendAlertPending == 3) then
		SA_Sound(xSound);
		SA_Data.VendAlertPending = 2;
      else
		if (x <= 2) then
		  if (SA_Data.VendAlertPending == 2) then
			SA_Sound(xSound);
			SA_Data.VendAlertPending = 1;
		  else
			if (x <= 1) then
			  if (SA_Data.VendAlertPending == 1) then
				SA_Sound(xSound);
				SA_Data.VendAlertPending = 0;
			  end
			end
		  end
		end
      end
    else
      SA_Data.VendAlertPending = 3;
    end
  end
end

function SA_DataPBar()
  local x = SA_util_DPTime();

  if (x > 0) then
    if (SA_Data.BARS["DP"]) then
      SA_Data.BARS["DP"]["obj"]:SetValue(x);
      SA_Data.BARS["DP"]["obj"].text:SetText(string.format("%0.1f", x));
    end
  else
    SA_Data.DPExpires = 0;
    SA_Data.BARS["DP"]["Expires"] = 0;
    SA_Data.BARS["DP"]["obj"]:Hide(); --no need to update anchors since its always on the outside
  end
end

function SA_RecupBar()
  local x = SA_util_RecupTime();
  SA_Data.BARS["Recup"]["Expires"] = x;
  local recup = SA_Data.BARS["Recup"];

  if (x > 0) then
    if (SA_Data.BARS["Recup"]) then
      SA_Data.BARS["Recup"]["obj"]:SetValue(x);
      SA_Data.BARS["Recup"]["obj"].text:SetText(string.format("%0.1f", x));
    end

    if (x <= 3) then
      if (recup.AlertPending == 3) then
		SA_Sound("Recup.Alert");
		recup.AlertPending = 2;
      else
		if (x <= 2) then
		  if (recup.AlertPending == 2) then
			SA_Sound("Recup.Alert");
			recup.AlertPending = 1;
		  else
			if (x <= 1) then
			  if (recup.AlertPending == 1) then
				SA_Sound("Recup.Alert");
				recup.AlertPending = 0;
			  end
			end
		  end
		end
      end
    else
      recup.AlertPending = 3;
    end

  end
end

function SA_EnvenomBar()
  local x = SA_util_EnvenomTime();
  SA_Data.BARS["Env"]["Expires"] = x;

  if (x > 0) then
    if (SA_Data.BARS["Env"]) then
      SA_Data.BARS["Env"]["obj"]:SetValue(x);
      SA_Data.BARS["Env"]["obj"].text:SetText(string.format("%0.1f", x));
    end
  end
end

function SA_SNDCooldown()
  if SliceAdmiral_Save.PadLatency then
    local down, up, lag = GetNetStats();
    SA_Data.tNow = SA_Data.tNow + (lag*2/1000);
  end

  local x = SA_util_SnDBuffTime();
  SA_Data.BARS["SnD"]["Expires"] = x;

  if (SA_Data.BARS["SnD"]) then
    if (SA_Data.BARS["SnD"]["obj"]) then
      SA_Data.BARS["SnD"]["obj"]:SetValue(x);
      if (x > 0) then
		SA_Data.BARS["SnD"]["obj"].text:SetText(string.format("%0.1f", x));
      else
		SA_Data.BARS["SnD"]["obj"].text:SetText("");
      end
    end
  end

  xSound = "Tick3";
  if (x > 0) then
    if (x <= 3) then
      if (SA_Data.AlertPending == 3) then
		SA_Sound(xSound);
		SA_Data.AlertPending = 2;
      else
		if (x <= 2) then
		  if (SA_Data.AlertPending == 2) then
			SA_Sound(xSound);
			SA_Data.AlertPending = 1;
		  else
			if (x <= 1) then
			  if (SA_Data.AlertPending == 1) then
				SA_Sound(xSound);
				SA_Data.AlertPending = 0;
			  end
			end
		  end
		end
      end
    else
      SA_Data.AlertPending = 3;
    end
  end

end

--[[
function SA_SoundCheck()
  SA_Data.tNow = GetTime();
  if (SliceAdmiral_Save.PadLatency) then
    local down, up, lag = GetNetStats();
    SA_Data.tNow = SA_Data.tNow + (lag*2/1000);
  end

  local x = SA_Data.BARORDER[1]["Expires"];
  xSound = SA_Data.BARORDER[1]["AlertSound"];
  if (x == 0) then
    if (SA_Data.BARORDER[2]["Expires"] > 0) then
      x = SA_Data.BARORDER[2]["Expires"]
      xSound = SA_Data.BARORDER[2]["AlertSound"];
    else
      x = SA_Data.BARORDER[3]["Expires"]
      xSound = SA_Data.BARORDER[3]["AlertSound"];
    end
  end --this picks the bar with the lowest timer.
  xSound = "Tick3";

  --TODO need a y (x equiv) for the 2nd lowest bar
  --TODO need an AlertPending for each bar...

  if (x > 0) then
    if (x <= 3) then
      if (SA_Data.AlertPending == 3) then
	SA_Sound(xSound);
	SA_Data.AlertPending = 2;
      else
	if (x <= 2) then
	  if (SA_Data.AlertPending == 2) then
	    SA_Sound(xSound);
	    SA_Data.AlertPending = 1;
	  else
	    if (x <= 1) then
	      if (SA_Data.AlertPending == 1) then
		SA_Sound(xSound);
		SA_Data.AlertPending = 0;
	      end
	    end
	  end
	end
      end
    else
      SA_Data.AlertPending = 3;
    end
  end
end
]]

function SA_OnUpdate()
  SA_Data.tNow = GetTime();

  VTimerEnergy:SetValue(UnitMana("player"));
  VTimerEnergy:SetMinMaxValues(0,UnitManaMax("player"));

  if (UnitManaMax("player") == UnitMana("player")) then
    VTimerEnergyTxt:SetText("");
  else
    VTimerEnergyTxt:SetText(UnitMana("player"));
  end

  SA_Config_OtherVars();

  if (SA_Data.LastEnergy < UnitMana("player")) then
    if (UnitManaMax("player") == UnitMana("player")) then
      --VTimerEnergy:Hide();
      VTimerEnergy:SetAlpha(SliceAdmiral_Save.EnergyTrans / 100.0);
    else
      --VTimerEnergy:Show();
      VTimerEnergy:SetAlpha(1.0);
    end
  end

  SA_Data.LastEnergy = UnitMana("player");

  if SliceAdmiral_Save.ShowSnDBar then
    SA_SNDCooldown();
  end
  if SliceAdmiral_Save.RupBarShow then
    SA_RupBar();
  end
  if SliceAdmiral_Save.RevealBarShow then
	SA_RevealBar();
  end
  if SliceAdmiral_Save.ShowEnvBar then
    SA_EnvenomBar();
  end
  if SliceAdmiral_Save.VendBarShow then
    SA_VendBar();
  end
  if SliceAdmiral_Save.ShowRecupBar then
    SA_RecupBar();
  end
  if SliceAdmiral_Save.DPBarShow then
    SA_DataPBar();
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

  if (showStatBar == 1) then
    SA_UpdateStats();
  end
end
