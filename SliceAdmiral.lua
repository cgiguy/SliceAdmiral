-- Author      : Administrator
-- Create Date : 9/10/2008 6:44:47 PM
SLICECMDR = { };
SLICECMDR.AlertPending = 0;
SLICECMDR.RuptAlertPending = 0;
SLICECMDR.VendAlertPending = 0;
SLICECMDR.curCombo = 0;
SLICECMDR.LastTime = 0;
SLICECMDR.BarFont = 0;
SLICECMDR.LastEnergy = 0;
SLICECMDR.RupExpires = 0;
SLICECMDR.VendExpires = 0;
SLICECMDR.DPExpires = 0;
SLICECMDR.EnvExpires = 0;
SLICECMDR.SliceExpires = 0;
SLICECMDR.RecupExpires = 0;
SLICECMDR.LastSliceExpire = 0;
SLICECMDR.tNow = 0;

local showStatBar = 1		--show stat bar   AP, crit, etc
local barsup = 1		    --bars group up or down
local flashStats = 1        --flashes statbar stats when they get mega-buffed

-- fade
local fadein = 0.5       -- fade delay for each combo point frame
local fadeout = 0.5      -- fade delay for each combo point frame
local framefadein = 0.2  -- fade delay for entering combat
local framefadeout = 0.2 -- fade delay for leaving combat
local scaleUI = 0
local widthUI = 0	

SLICECMDR.BARS = { --TEH BARS
	['CP'] = {
			['obj'] = 0
			},
	['Recup'] = {
			['obj'] = 0,
			['Expires'] = 0,
			['AlertPending'] = 0
			},
	['SnD'] = {
			['obj'] = 0,
			['Expires'] = 0
			},
	['DP'] = {
			['obj'] = 0,
			['Expires'] = 0
			},
	['Rup'] = {
			['obj'] = 0,
			['Expires'] = 0
			},
	['Vend'] = {
			['obj'] = 0,
			['Expires'] = 0
			},
        ['Env'] = {
			['obj'] = 0,
			['Expires'] = 0
			},
	['Stat'] = {
			['obj'] = 0,
			},
};

function SliceCmdr_MoveStart(self, button)
	if (button == "LeftButton") then
		if (SliceAdmiral_Save.IsLocked == false) then
			SliceCmdr:StartMoving();
		else
			SliceCmdr:EnableMouse(false);
		end
	end
	
	--if (button == "RightButton") then 
		--local x, y = GetCursorPosition();
		--local scale = UIParent:GetEffectiveScale() 
		--ToggleDropDownMenu(1, nil, MyDropDownMenu, UIParent, x/scale, y/scale);
	--end
end

function SliceCmdr_MoveStop()
	if (SliceAdmiral_Save.IsLocked == false) then
		SliceCmdr:StopMovingOrSizing();
	end		
end

function MyDropDownMenu_OnLoad()
    info            = {};
	if (SliceAdmiral_Save.IsLocked == true) then
		info.text       = "Unlock Position";
	else
		info.text       = "Lock Position";
	end
    info.value    	  	= "OptionVariable";
    info.func       	= RogueMod_ToggleIsLocked 
           
    UIDropDownMenu_AddButton(info);
	   
	info2            = {};
    info2.text       = "Close"--"Recalibrate Base Stats";
    info2.value      = "OptionVariable";
    --info2.func       = RogueMod_UpdateStats 
	   
	UIDropDownMenu_AddButton(info2);
end

function RogueMod_ToggleIsLocked()
	if (SliceAdmiral_Save.IsLocked == true) then
		SliceAdmiral_Save.IsLocked = false;
		--SliceCmdr:EnableMouse(true);
	else
		SliceAdmiral_Save.IsLocked = true;
		--SliceCmdr:EnableMouse(false);
	end
end
   
function SliceCmdr_BarTexture() 
	if (SliceAdmiral_Save.BarTexture) then
		return SliceCmdr_BarTextures[ SliceAdmiral_Save.BarTexture ];
	else
		return "Interface\\AddOns\\SliceAdmiral\\Images\\Smooth.tga";
	end
end
	

function SliceCmdr_SoundTest(name) 
	if (SliceCmdr_Sounds[name]) then
		PlaySoundFile( SliceCmdr_Sounds[name] );
	end
end

function SliceCmdr_Sound(saved) 
	if (SliceAdmiral_Save[saved]) then
		PlaySoundFile( SliceCmdr_Sounds[ SliceAdmiral_Save[saved] ] );
	else
		print(string.format("%s%s", "Soundsave not found: ", saved)); 
	end
end

function SliceCmdr_ChangeAnchor()
	local LastAnchor = VTimerEnergy;
	local offSetSize = SliceAdmiral_Save.BarMargin; -- other good values, -1, -2
	
	-- Stat bar goes first, because it's fucking awesome like that
	if (showStatBar == 1) then
		--if (SliceAdmiral_Save.Barsup) then
		     	SLICECMDR.BARS['Stat']['obj']:ClearAllPoints();
			SLICECMDR.BARS['Stat']['obj']:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize);
                --end
	end
    
	--anchor CPs on stat bar if energy bar is hidden. 
	if (SliceAdmiral_Save.HideEnergy == true) then
		LastAnchor = SLICECMDR.BARS['Stat']['obj'];
	end
	
    -- CP Bar --
    SLICECMDR.BARS['CP']['obj']:ClearAllPoints(); --so it can move
    SLICECMDR.BARS['CP']['obj']:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize); --CP bar on bottom of Stat Bar
    
    LastAnchor = SLICECMDR.BARS['Stat']['obj']; --timer bars grow off top of stat bar by default
    if (SliceAdmiral_Save.Barsup) then
        if (SliceAdmiral_Save.ShowStatBar) then
            LastAnchor = SLICECMDR.BARS['Stat']['obj'];
        else
            if (SliceAdmiral_Save.HideEnergy) then
                LastAnchor = SLICECMDR.BARS['CP']['obj'];
            else
                LastAnchor = VTimerEnergy;
            end
        end
    else
        if (SliceAdmiral_Save.CPBarShow) then
            LastAnchor = SLICECMDR.BARS['CP']['obj'];
        else
            if (SliceAdmiral_Save.HideEnergy) then
                LastAnchor = SLICECMDR.BARS['Stat']['obj'];
            else
                LastAnchor = VTimerEnergy;
            end
        end
    end
		for i = 1, 4 do
			if (SLICECMDR.BARORDER[i]['Expires'] > 0) then
                                SLICECMDR.BARORDER[i]['obj']:ClearAllPoints();
				if (SliceAdmiral_Save.Barsup) then
					SLICECMDR.BARORDER[i]['obj']:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize); --bar on top
				else
					SLICECMDR.BARORDER[i]['obj']:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize); 
				end
				LastAnchor = SLICECMDR.BARORDER[i]['obj'];
			end
		end --end loop
	
	-- deadly poison --   DP always on the outside since it's auto-refreshed for the rogue
	if (SLICECMDR.DPExpires ~= 0) then
        SLICECMDR.BARS['DP']['obj']:ClearAllPoints();
		if (SliceAdmiral_Save.Barsup) then
			SLICECMDR.BARS['DP']['obj']:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize);
		else
			SLICECMDR.BARS['DP']['obj']:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize);
		end
		LastAnchor = SLICECMDR.BARS['DP']['obj'];
	end
    
    -- Envenom --   Envnom to finish this shiznit out. 
	if (SLICECMDR.EnvExpires ~= 0) then
        SLICECMDR.BARS['Env']['obj']:ClearAllPoints();
		if (SliceAdmiral_Save.Barsup) then
			SLICECMDR.BARS['Env']['obj']:SetPoint("BOTTOMLEFT", LastAnchor, "TOPLEFT", 0, offSetSize);
		else
			SLICECMDR.BARS['Env']['obj']:SetPoint("TOPLEFT", LastAnchor, "BOTTOMLEFT", 0, -1 * offSetSize);
		end
		LastAnchor = SLICECMDR.BARS['DP']['obj'];
	end
end

function RogueMod_SortBarsByTime()
--[[simple shuffle of the lower bars to higher if they are refreshed. It doesnt garantee perfect order on 1 run, 
    but its run often enough to not matter.]]
    
    if (SliceAdmiral_Save.SortBars == false) then
        return;
    end
    
	if (SLICECMDR.BARORDER[1]['Expires'] > SLICECMDR.BARORDER[2]['Expires']) then
		local tmp = SLICECMDR.BARORDER[1];
		SLICECMDR.BARORDER[1] = SLICECMDR.BARORDER[2];
		SLICECMDR.BARORDER[2] = tmp;
		SliceCmdr_ChangeAnchor();
	end
	if (SLICECMDR.BARORDER[2]['Expires'] > SLICECMDR.BARORDER[3]['Expires']) then
		local tmp = SLICECMDR.BARORDER[2];
		SLICECMDR.BARORDER[2] = SLICECMDR.BARORDER[3];
		SLICECMDR.BARORDER[3] = tmp;
		SliceCmdr_ChangeAnchor();
	end
end

function SliceCmdr_OnEvent(self, event, ...)
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		local timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = select(1, ...);
		if (type == "SPELL_AURA_REFRESH" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REMOVED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_PERIODIC_AURA_REMOVED" or type == "SPELL_PERIODIC_AURA_APPLIED" or type == "SPELL_PERIODIC_AURA_APPLIED_DOSE" or type == "SPELL_PERIODIC_AURA_REFRESH") then
			local spellId, spellName, spellSchool = select(12, ...);
			spellName = GetSpellInfo(spellId);			
			--print ("spellId = " .. spellId .. " (" .. spellName .. ")");
			if (destName == UnitName("player")) then
				if (spellName == SC_SPELL_SND and SliceAdmiral_Save.ShowSnDBar) then
					if (type == "SPELL_AURA_REMOVED") then			
						if (UnitAffectingCombat("player")) then
							SliceCmdr_Sound("Expire");
						end					
						SLICECMDR.SliceExpires = 0;
						SLICECMDR.BARS['SnD']['Expires'] = 0;
						SliceCmdr_ChangeAnchor();
						SLICECMDR.BARS['SnD']['obj']:Hide();
					else
						local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitAura("player", SC_SPELL_SND);
						local timeLeftOnLast = SLICECMDR.SliceExpires - GetTime();
						SLICECMDR.BARS['SnD']['obj']:Show();
						SLICECMDR.SliceExpires = expirationTime;
						SLICECMDR.BARS['SnD']['Expires'] = expirationTime;
						SliceCmdr_ChangeAnchor(); --change les ancres des bares
					end
				end
				
				-- RECUPERATE EVENT --
				if (spellName == SC_SPELL_RECUP and SliceAdmiral_Save.ShowRecupBar == true) then
					if (type == "SPELL_AURA_REMOVED") then
						if (UnitAffectingCombat("player")) then
							SliceCmdr_Sound("Recup.Expire");
						end
						SLICECMDR.RecupExpires = 0;
						SLICECMDR.BARS['Recup']['Expires'] = 0;
						SliceCmdr_ChangeAnchor();--change les ancres des bares
						SLICECMDR.BARS['Recup']['obj']:Hide();
					else
						local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitAura("player", SC_SPELL_RECUP);
						local timeLeftOnLast = SLICECMDR.RecupExpires - GetTime();
						SLICECMDR.RecupExpires = expirationTime;
						SLICECMDR.BARS['Recup']['Expires'] = expirationTime;
						SLICECMDR.BARS['Recup']['obj']:Show();
						SliceCmdr_ChangeAnchor();--change les ancres
					end
				end

                -- envenom EVENT --
				if (spellName == SC_SPELL_ENV and SliceAdmiral_Save.ShowEnvBar == true) then
					if (type == "SPELL_AURA_REMOVED") then
                                                if (UnitAffectingCombat("player")) then
							--SliceCmdr_Sound("Env.Expire");
						end
						SLICECMDR.EnvExpires = 0;
						SLICECMDR.BARS['Env']['Expires'] = 0;
						SliceCmdr_ChangeAnchor();--change les ancres des bares
						SLICECMDR.BARS['Env']['obj']:Hide();
					else
						local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitAura("player", SC_SPELL_ENV);
						local timeLeftOnLast = SLICECMDR.EnvExpires - GetTime();
						SLICECMDR.EnvExpires = expirationTime;
						SLICECMDR.BARS['Env']['Expires'] = expirationTime;
						SLICECMDR.BARS['Env']['obj']:Show();
						SliceCmdr_ChangeAnchor();--change les ancres
					end
				end
			else
				if (destName == UnitName("target")) then
					-- DEADLY POISON --
					if (spellName == SC_SPELL_DP and SliceAdmiral_Save.DPBarShow == true) then
						local name1, rank1, icon1, count1, debuffType1, duration1, expirationTime1, isMine1, isStealable1 = UnitDebuff("target", SC_SPELL_DP);
						if (isMine1 == "player") then
							SLICECMDR.DPExpires = expirationTime1;
							SLICECMDR.BARS['DP']['Expires'] = expirationTime1;
							SLICECMDR.BARS['DP']['obj'].text2:SetText("x" .. string.format("%i", count1));
							SLICECMDR.BARS['DP']['obj']:Show();
							SliceCmdr_ChangeAnchor();--change les ancres
						end
					end
					-- RUPTURE --
					if (spellName == SC_SPELL_RUP and SliceAdmiral_Save.RupBarShow == true) then
						local name2, rank2, icon2, count2, debuffType2, duration2, expirationTime2, isMine2, isStealable2 = UnitDebuff("target", SC_SPELL_RUP);						
						if (isMine2 == "player") then
							SLICECMDR.RupExpires = expirationTime2;
							SLICECMDR.BARS['Rup']['Expires'] = expirationTime2;
							SLICECMDR.BARS['Rup']['obj']:Show();
						end
                                                if (type == "SPELL_AURA_REMOVED") then			
						    if (UnitAffectingCombat("player")) then
							    SliceCmdr_Sound("RuptExpire");
						    end
                                                end
						SliceCmdr_ChangeAnchor();
					end
					-- VENDETTA --
					if (spellName == SC_SPELL_VEND and SliceAdmiral_Save.VendBarShow == true) then
						local name2, rank2, icon2, count2, debuffType2, duration2, expirationTime2, isMine2, isStealable2 = UnitDebuff("target", SC_SPELL_VEND);						
						if (isMine2 == "player") then
							SLICECMDR.VendExpires = expirationTime2;
							SLICECMDR.BARS['Vend']['Expires'] = expirationTime2;
							SLICECMDR.BARS['Vend']['obj']:Show();
						end
                                                if (type == "SPELL_AURA_REMOVED") then			
						    if (UnitAffectingCombat("player")) then
							    SliceCmdr_Sound("VendExpire");
						    end
                                                end
						SliceCmdr_ChangeAnchor();
					end
				end
			end	
		end -- "SPELL_AURA_REFRESH" or ...
		-- DOT monitors
		if (SliceAdmiral_Save.ShowDoTDmg == true and type == "SPELL_PERIODIC_DAMAGE" and destName == UnitName("target")and sourceName == UnitName("player")) then
			local spellId, spellName, spellSchool = select(12, ...);
			spellName = GetSpellInfo(spellId);			
			if (spellName == SC_SPELL_RUP and SliceAdmiral_Save.RupBarShow == true) then
				local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(15, ...)
				SLICECMDR.BARS['Rup']['obj'].DoTtext:SetAlpha(1);
                if (SliceAdmiral_Save.DoTCrits and critical) then
                    SLICECMDR.BARS['Rup']['obj'].DoTtext:SetText(string.format("*%.0f*", amount));
                    UIFrameFadeOut(SLICECMDR.BARS['Rup']['obj'].DoTtext, 3, 1, 0);
                else
                    SLICECMDR.BARS['Rup']['obj'].DoTtext:SetText(amount);
                    UIFrameFadeOut(SLICECMDR.BARS['Rup']['obj'].DoTtext, 2, 1, 0);
                end
								
												
			end
			if (spellName == SC_SPELL_DP and SliceAdmiral_Save.DPBarShow == true) then
				local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(15, ...)
				SLICECMDR.BARS['DP']['obj'].DoTtext:SetAlpha(1);
                if (SliceAdmiral_Save.DoTCrits and critical) then
                    SLICECMDR.BARS['DP']['obj'].DoTtext:SetText(string.format("*%.0f*", amount));
                    UIFrameFadeOut(SLICECMDR.BARS['DP']['obj'].DoTtext, 3, 1, 0);
                else
                    SLICECMDR.BARS['DP']['obj'].DoTtext:SetText(amount);
					UIFrameFadeOut(SLICECMDR.BARS['DP']['obj'].DoTtext, 2, 1, 0);								
			    end
            end
		end
	end -- event == "COMBAT_LOG_EVENT_UNFILTERED"
	
	if (event == "UNIT_COMBO_POINTS") then
		local unit = select(1, ...);
		if (unit and unit == "player") then 
			SliceCmdr_SetComboPts();
		end
	end
	if (event == "PLAYER_TARGET_CHANGED") then
		SliceCmdr_SetComboPts();
		SliceCmdr_TestTarget();
	end
	
	if (UnitAffectingCombat("player")) then
		SliceCmdr:SetAlpha(1.0);
	else
		SliceCmdr:SetAlpha(SliceCmdr_Fade:GetValue()/100);
	end
end

function SliceCmdr_TestTarget()
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitDebuff("target", SC_SPELL_DP);
	if (SliceAdmiral_Save.DPBarShow == true) then
		if not name then
			SLICECMDR.DPExpires = 0;
			SLICECMDR.BARS['DP']['Expires'] = 0;
			SLICECMDR.BARS['DP']['obj']:Hide();
		else
			if (isMine == "player") then
				SLICECMDR.DPExpires = expirationTime;
				SLICECMDR.BARS['DP']['Expires'] = expirationTime;
				SLICECMDR.BARS['DP']['obj']:Show();
			else
				SLICECMDR.DPExpires = 0;
				SLICECMDR.BARS['DP']['Expires'] = 0;
				SLICECMDR.BARS['DP']['obj']:Hide();
			end
		end
	end
	
	if (SliceAdmiral_Save.RupBarShow == true) then	
		name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitDebuff("target", SC_SPELL_RUP);
		if not name then
			SLICECMDR.RupExpires = 0;
			SLICECMDR.BARS['Rup']['Expires'] = 0;
			SLICECMDR.BARS['Rup']['obj']:Hide();
			SliceCmdr_ChangeAnchor();--change les ancres
		else
			if (isMine == "player") then
				SLICECMDR.RupExpires = expirationTime;
				SLICECMDR.BARS['Rup']['Expires'] = expirationTime;
				SLICECMDR.BARS['Rup']['obj']:Show();
				SliceCmdr_ChangeAnchor();--change les ancres
			else
				SLICECMDR.RupExpires = 0;
				SLICECMDR.BARS['Rup']['Expires'] = 0;
				SLICECMDR.BARS['Rup']['obj']:Hide();
				SliceCmdr_ChangeAnchor();--change les ancres
			end
		end
	end	
	if (SliceAdmiral_Save.VendBarShow == true) then	
		name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitDebuff("target", SC_SPELL_VEND);
		if not name then
			SLICECMDR.VendExpires = 0;
			SLICECMDR.BARS['Vend']['Expires'] = 0;
			SLICECMDR.BARS['Vend']['obj']:Hide();
			SliceCmdr_ChangeAnchor();
		else
			if (isMine == "player") then
				SLICECMDR.VendExpires = expirationTime;
				SLICECMDR.BARS['Vend']['Expires'] = expirationTime;
				SLICECMDR.BARS['Vend']['obj']:Show();
				SliceCmdr_ChangeAnchor();
			else
				SLICECMDR.VendExpires = 0;
				SLICECMDR.BARS['Vend']['Expires'] = 0;
				SLICECMDR.BARS['Vend']['obj']:Hide();
				SliceCmdr_ChangeAnchor();
			end
		end
	end	
end

local curCombo = 0

function SliceCmdr_SetComboPts()
	local points = GetComboPoints("player");
	if (SliceAdmiral_Save.CPBarShow == true) then 
		if points == curCombo then
			if curCombo == 0 and not incombat and visible then
				--UIFrameFadeOut(SLICECMDR.BARS['CP']['obj'], framefadeout);
				visible = false;
			elseif curCombo > 0 and not visible then
				--UIFrameFadeIn(SLICECMDR.BARS['CP']['obj'], framefadein);
				visible = true;
			end
			return
		end
		
		if (points > curCombo) then
			for i = curCombo + 1, points do
				SLICECMDR.BARS['CP']['obj'].combos[i]:Show();
			end
			SliceCmdr_Combo:SetText(points);
		else
			for i = points + 1, curCombo do
				SLICECMDR.BARS['CP']['obj'].combos[i]:Hide();
			end
			SliceCmdr_Combo:SetText("");
		end	

		
		--[[if points > 0 then
			SLICECMDR.BARS['CP']['obj'].comboText:SetText(points);
		else
			SLICECMDR.BARS['CP']['obj'].comboText:SetText("");
		end]]
		
		curCombo = points;
		
		if curCombo == 0 and not incombat and visible then
			--UIFrameFadeOut(SLICECMDR.BARS['CP']['obj'], framefadeout);
			visible = false;
		elseif curCombo > 0 and not visible then
			--UIFrameFadeIn(SLICECMDR.BARS['CP']['obj'], framefadein);
			visible = true;
		end
	else
		if (points > curCombo) then
			SliceCmdr_Combo:SetText(points);
		else
			SliceCmdr_Combo:SetText("");
		end	
	end		
end

function SliceCmdr_Unload()
	SliceCmdr:UnregisterAllEvents();
	SliceCmdr:Hide();
	SliceCmdr_Config_CPFrame:Hide();
end
		
function SliceCmdr_NewFrame()
	local f = CreateFrame("StatusBar", nil, SliceCmdr);
	
	f:SetWidth(widthUI);
	f:SetScale(scaleUI);
	f:SetHeight(12);

    --f:SetPoint("BOTTOMLEFT", SLICECMDR.BARS['Stat']['obj'], "TOPLEFT", 0, 2);
	--if (SliceAdmiral_Save.Barsup) then
       -- print("True while creating timer bar")
		f:SetPoint("BOTTOMLEFT", VTimerEnergy, "TOPLEFT", 0, 2);
	--else
	--	f:SetPoint("TOPLEFT", VTimerEnergy, "BOTTOMLEFT", 0, -2); --orig (goes down)
	--end
		
	f:SetStatusBarTexture(SliceCmdr_BarTexture());
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
	f.text:SetFontObject(SLICECMDR.BarFont2);
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
	f.text2:SetFontObject(SLICECMDR.BarFont2);
	f.text2:SetHeight(10)
	f.text2:SetWidth(60);
	f.text2:SetPoint("TOPLEFT", f, "TOPLEFT",  f.icon:GetWidth() + SliceAdmiral_Save.BarMargin + 1, 0);
	f.text2:SetJustifyH("LEFT")
	f.text2:SetText("");
	
	-- DoT Text --
	if not f.DoTtext then
		f.DoTtext = f:CreateFontString(nil, nil, nil)
	end
	f.DoTtext:SetFontObject(SLICECMDR.BarFont2);
	f.DoTtext:SetHeight(10)
	f.DoTtext:SetWidth(60);
	f.DoTtext:SetPoint("CENTER", f, "CENTER",  0 , 0);
	f.DoTtext:SetJustifyH("CENTER")
	f.DoTtext:SetText("");
	
	return f;
	
end

function SliceCmdr_CPFrame()
	local f = CreateFrame("StatusBar", nil, SliceCmdr);
	local width = widthUI --SLICECMDR.BARS['CP']['obj']:GetWidth();

	f:ClearAllPoints();
	f:SetWidth(width);
	f:SetScale(scaleUI);
	f:SetHeight(10)
	--if (SliceAdmiral_Save.Barsup) then
    --   print("True while creating CP bar")
		f:SetPoint("TOPLEFT", VTimerEnergy, "BOTTOMLEFT", 0, -3);
	--else
	--	f:SetPoint("BOTTOMLEFT", VTimerEnergy, "TOPLEFT", 0, 3); --orig (top?)
	--end
	f.bg = f:CreateTexture(nil, "BACKGROUND")
	f.bg:ClearAllPoints()
	--f.bg:SetAllPoints(f)
	f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -2, 2)
	f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 2, -2)
	f.bg:SetTexture(SliceCmdr_BarTexture())
	f.bg:SetVertexColor(0.3, 0.3, 0.3)
	f.bg:SetAlpha(0.7)
	
	f.combos = {}
	
	local cx = 0;
	local spacing = width/30;	--orig:= 3
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
		combo.bg:SetTexture(SliceCmdr_BarTexture())
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

function RogueMod_UpdateCPWidths()
	local width = VTimerEnergy:GetWidth()
	local cx = 0;
	local spacing = width/30;	--orig:= 3
	local cpwidth = ((width-(spacing*4))/5);	--orig: ((width-(spacing*4))/5);
	
	local f = SLICECMDR.BARS['CP']['obj']
	
	for i = 1, 5 do
		local combo = SLICECMDR.BARS['CP']['obj'].combos[i]
		combo:ClearAllPoints()
		combo:SetPoint("TOPLEFT", f, "TOPLEFT", cx, 0)
		combo:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cx + cpwidth, 0)

		cx = cx + cpwidth + spacing
	end
end

function RogueMod_UpdateStatWidths()
	local width = VTimerEnergy:GetWidth()
	
	local numStats = 3 --HP TODO option for this
	local spacing = width/90;
	local cpwidth = ((width-(spacing*3))/(numStats));
	local cur_location = 0; --small initial offset

	local f = SLICECMDR.BARS['Stat']['obj'];

	for i = 1, numStats do
		--Create the frame & space it
		local statText = SLICECMDR.BARS['Stat']['obj'].stats[i];
        local labelFrame = SLICECMDR.BARS['Stat']['obj'].stats[i].labelFrame;
		statText:ClearAllPoints();
		statText:SetPoint("TOPLEFT", f, "TOPLEFT", cur_location, 0)
		statText:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cur_location + cpwidth, 0)
        
        labelFrame:ClearAllPoints();
		labelFrame:SetPoint("TOPLEFT", f, "TOPLEFT", cur_location, 0)
		labelFrame:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", cur_location + cpwidth, 0)
	
		cur_location = cur_location + cpwidth + spacing;
	end
end

function RogueMod_CreateStatBar()
	local f = CreateFrame("StatusBar", nil, SliceCmdr);
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
	--	f:SetPoint("TOPLEFT", VTimerEnergy, "BOTTOMLEFT", 0, -3)
	--end
	
	f.bg = f:CreateTexture(nil, "BACKGROUND")
	f.bg:ClearAllPoints()
	--f.bg:SetAllPoints(f)
	f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -2, 2)
	f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 2, -2)
	f.bg:SetTexture(SliceCmdr_BarTexture())
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

function RogueMod_UpdateStats()

	if (SliceAdmiral_Save.ShowStatBar == false) then
		return
	end
	
	local baseAP, buffAP, negAP = UnitAttackPower('player');
	local totalAP = baseAP+buffAP+negAP;
	local crit = GetCritChance(); 
	local mhSpeed, ohSpeed = UnitAttackSpeed("player");
	
	if (SLICECMDR.BARS['Stat']['obj'].stats[1]) then	
	    SLICECMDR.BARS['Stat']['obj'].stats[1].fs:SetText(totalAP);
    end
    if (SLICECMDR.BARS['Stat']['obj'].stats[2]) then
	    SLICECMDR.BARS['Stat']['obj'].stats[2].fs:SetText(string.format("%.1f%%", crit));
    end
    if (SLICECMDR.BARS['Stat']['obj'].stats[3]) then
	    SLICECMDR.BARS['Stat']['obj'].stats[3].fs:SetText(string.format("%.2f", mhSpeed));
    end
    
    if (SliceAdmiral_Save.HilightBuffed == true) then
        RogueMod_flashBuffedStats()
    end
end	


function RogueMod_flashBuffedStats()
    local numStats = 3;
    local baseAP, buffAP, negAP = UnitAttackPower('player');
	local totalAP = baseAP+buffAP+negAP;
	local crit = GetCritChance(); 
	local mhSpeed, ohSpeed = UnitAttackSpeed("player");
	
    if (not SLICECMDR.baseAP or SLICECMDR.baseAP == 0) then --initialize here since all stats = 0 when OnLoad is called. 
        RogueMod_ResetBaseStats();
        return
    end
    
    local statCheck = {};
    statCheck[1] = false;
    statCheck[2] = false;
    statCheck[3] = false;
    statCheck[4] = false;
    
	if ( totalAP > (SLICECMDR.baseAP * 1.01)) then --TODO explain
        statCheck[1] = true;
	end
    
    if (crit > (SLICECMDR.baseCrit * 1.5)) then
        statCheck[2] = true;
	end
  
    if (mhSpeed < (SLICECMDR.baseSpeed / 2)) then
        statCheck[3] = true;
	end
    
    for i = 1, numStats do
        if (statCheck[i] == true) then
            SLICECMDR.BARS['Stat']['obj'].stats[i].fs:SetTextColor(140/255, 15/255, 0);
            if (not UIFrameIsFading(SLICECMDR.BARS['Stat']['obj'].stats[i])) then --flash if not already flashing
                if  (SLICECMDR.BARS['Stat']['obj'].stats[i]:GetAlpha() > 0.5) then
                    UIFrameFadeOut(SLICECMDR.BARS['Stat']['obj'].stats[i], 1, 1, 0.1)
                else  --UIFrameFlash likes to throw execeptions deep in the bliz ui? 
                    UIFrameFadeOut(SLICECMDR.BARS['Stat']['obj'].stats[i], 1, 0.1, 1)
                end
            end
        else
            SLICECMDR.BARS['Stat']['obj'].stats[i].fs:SetTextColor(1, .82, 0); --default text color
            SLICECMDR.BARS['Stat']['obj'].stats[i]:SetAlpha(1);
        end
    end
    
end
		
function RogueMod_ResetBaseStats()
    local baseAP, buffAP, negAP = UnitAttackPower('player');
	local crit = GetCritChance(); 
	local mhSpeed, ohSpeed = UnitAttackSpeed("player");
    
    SLICECMDR.baseAP = baseAP+buffAP;
    SLICECMDR.baseCrit = crit;
    SLICECMDR.baseSpeed = mhSpeed;
    --print("Base#s: ".. SLICECMDR.baseAP .. " " .. SLICECMDR.baseCrit .. " " .. SLICECMDR.baseSpeed);
end
            
function SliceCmdr_OnLoad()
	local localizedClass, englishClass = UnitClass("player");
	if (englishClass == "ROGUE") then
		SliceCmdr:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		SliceCmdr:RegisterEvent("UNIT_COMBO_POINTS");
		SLICECMDR.BarFont = CreateFont("VTimerFont");
		SLICECMDR.BarFont:SetFont("Fonts\\FRIZQT__.TTF", 12);
		SLICECMDR.BarFont:SetShadowColor(0,0,0, 0.7);
		SLICECMDR.BarFont:SetTextColor(1,1,1,1);
		SLICECMDR.BarFont:SetShadowOffset(0.8, -0.8);
		
		SLICECMDR.BarFont2 = CreateFont("VTimerFont2");
		SLICECMDR.BarFont2:SetFont("Fonts\\FRIZQT__.TTF", 8)
		SLICECMDR.BarFont2:SetShadowColor(0,0,0, 0.7);
		SLICECMDR.BarFont2:SetTextColor(213/255,200/255,184/255,1);
		SLICECMDR.BarFont2:SetShadowOffset(0.8, -0.8);
		
		SLICECMDR.BarFont3 = CreateFont("VTimerFont1O");
		SLICECMDR.BarFont3:SetFont("Fonts\\FRIZQT__.TTF", 12);
		SLICECMDR.BarFont3:SetShadowColor(0,0,0, 0.2);
		SLICECMDR.BarFont3:SetTextColor(0,0,0,1);
		SLICECMDR.BarFont3:SetShadowOffset(0.8, -0.8);
		
		SLICECMDR.BarFont4 = CreateFont("VTimerFont4");
		SLICECMDR.BarFont4:SetFont("Fonts\\FRIZQT__.TTF", 8)
		SLICECMDR.BarFont4:SetShadowColor(0,0,0, 0.7);
		--SLICECMDR.BarFont4:SetTextColor(213/255,200/255,184/255,1);
		SLICECMDR.BarFont3:SetTextColor(0,0,0,1);
		SLICECMDR.BarFont4:SetShadowOffset(0.8, -0.8);
		
		SLICECMDR.LastEnergy = UnitMana('player');
		
		VTimerEnergyTxt:SetFontObject(SLICECMDR.BarFont);
		SliceCmdr_Combo:SetFontObject(SLICECMDR.BarFont3);
		
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
		VTimerEnergy:SetStatusBarTexture(SliceCmdr_BarTexture());
		VTimerEnergy:SetWidth(200);
		VTimerEnergy:SetStatusBarColor(254/255, 246/255, 226/255);
		
		scaleUI = VTimerEnergy:GetScale();
		widthUI = VTimerEnergy:GetWidth();
		
		SLICECMDR.BARS['CP']['obj'] = SliceCmdr_CPFrame();
		
		SLICECMDR.BARS['Stat']['obj'] = RogueMod_CreateStatBar();
        

		SLICECMDR.BARS['SnD']['obj'] = SliceCmdr_NewFrame();
		SLICECMDR.BARS['SnD']['obj']:SetStatusBarColor(255/255, 74/255, 18/255, 0.9);
		SLICECMDR.BARS['SnD']['obj'].icon:SetTexture("Interface\\Icons\\Ability_Rogue_SliceDice");
		
		SLICECMDR.BARS['Rup']['obj'] = SliceCmdr_NewFrame();
		SLICECMDR.BARS['Rup']['obj']:SetStatusBarColor(130/255, 15/255, 0);
		SLICECMDR.BARS['Rup']['obj'].text2:SetFontObject(SLICECMDR.BarFont4);
		SLICECMDR.BARS['Rup']['obj'].icon:SetTexture("Interface\\Icons\\Ability_Rogue_Rupture");

		SLICECMDR.BARS['Vend']['obj'] = SliceCmdr_NewFrame();
		SLICECMDR.BARS['Vend']['obj']:SetStatusBarColor(130/255, 130/255, 0);
		SLICECMDR.BARS['Vend']['obj'].text2:SetFontObject(SLICECMDR.BarFont4);
		SLICECMDR.BARS['Vend']['obj'].icon:SetTexture("Interface\\Icons\\Ability_Rogue_Deadliness");

		SLICECMDR.BARS['Recup']['obj'] = SliceCmdr_NewFrame();
		SLICECMDR.BARS['Recup']['obj']:SetStatusBarColor(10/255, 10/255, 150/255);		
		SLICECMDR.BARS['Recup']['obj'].icon:SetTexture("Interface\\Icons\\Ability_Rogue_Recuperate");
		
		SLICECMDR.BARS['DP']['obj'] = SliceCmdr_NewFrame();
		SLICECMDR.BARS['DP']['obj']:SetStatusBarColor(96/255, 116/255, 65/255);
		SLICECMDR.BARS['DP']['obj'].text2:SetFontObject(SLICECMDR.BarFont4);
		SLICECMDR.BARS['DP']['obj'].icon:SetTexture("Interface\\Icons\\Ability_Rogue_DualWeild");		

        	SLICECMDR.BARS['Env']['obj'] = SliceCmdr_NewFrame();
		SLICECMDR.BARS['Env']['obj']:SetStatusBarColor(66/255, 86/255, 35/255);
		SLICECMDR.BARS['Env']['obj'].text2:SetFontObject(SLICECMDR.BarFont4);
		SLICECMDR.BARS['Env']['obj'].icon:SetTexture("Interface\\Icons\\Ability_Rogue_Disembowel");
		
		SLICECMDR.BARORDER = {}; -- Initial order puts the longest towards the inside. 
		SLICECMDR.BARORDER[1] = SLICECMDR.BARS['Recup'];
		SLICECMDR.BARORDER[2] = SLICECMDR.BARS['SnD'];
		SLICECMDR.BARORDER[3] = SLICECMDR.BARS['Rup'];
		SLICECMDR.BARORDER[4] = SLICECMDR.BARS['Vend'];
        
		SliceCmdr_OnUpdate();
 		SliceCmdr_SetComboPts();
		SliceCmdr_TestTarget();
        
		print("SliceAdmiral 1.0 loaded!! Options are under the SliceAdmiral tab in the Addons Interface menu")
	else
		SliceCmdr_Unload();

		return;
    end
end

function SliceCmdr_util_SnDBuffTime()
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitAura("player", SC_SPELL_SND);
	if (expirationTime) then
--	  print ("ETime: " .. expirationTime);
	  SLICECMDR.SliceExpires = expirationTime;
	else
	  return 0;
        end
	if (SLICECMDR.tNow < SLICECMDR.SliceExpires) then
		return SLICECMDR.SliceExpires - SLICECMDR.tNow;
	else
		return 0;
	end
end

function SliceCmdr_util_RecupTime()
	if ((SLICECMDR.RecupExpires > 0) and (SLICECMDR.tNow < SLICECMDR.RecupExpires)) then
		return SLICECMDR.RecupExpires - SLICECMDR.tNow;
	else
		return 0;
	end
end

function RogueMod_util_EnvenomTime()
	if ((SLICECMDR.EnvExpires > 0) and (SLICECMDR.tNow < SLICECMDR.EnvExpires)) then
		return SLICECMDR.EnvExpires - SLICECMDR.tNow;
	else
		return 0;
	end
end

function SliceCmdr_util_DPTime()
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitDebuff("target", SC_SPELL_DP);
	if (expirationTime) then
--	  print ("DP ETime: " .. expirationTime);
	  SLICECMDR.DPExpires = expirationTime;
	else
	  return 0;
        end
	if (SLICECMDR.tNow < SLICECMDR.DPExpires) then
		return SLICECMDR.DPExpires - SLICECMDR.tNow;
	else
		return 0;
	end
end

function SliceCmdr_util_RupTime()
	if ((SLICECMDR.RupExpires > 0) and (SLICECMDR.tNow < SLICECMDR.RupExpires)) then
		return SLICECMDR.RupExpires - SLICECMDR.tNow;
	else
		return 0;
	end
end

function SliceCmdr_util_VendTime()
	if ((SLICECMDR.VendExpires > 0) and (SLICECMDR.tNow < SLICECMDR.VendExpires)) then
		return SLICECMDR.VendExpires - SLICECMDR.tNow;
	else
		return 0;
	end
end

function SliceCmdr_RupBar()
	local x = SliceCmdr_util_RupTime();
	SLICECMDR.BARS['Rup']['Expires'] = x;
	
	if (x > 0) then
		if (SLICECMDR.BARS['Rup']) then
			SLICECMDR.BARS['Rup']['obj']:SetValue(x);
			SLICECMDR.BARS['Rup']['obj'].text:SetText(string.format("%0.1f", x));
		end
	else
		if (x == 0) then 
			SLICECMDR.BARS['Rup']['obj'].text2:SetText(isMine2);
			SLICECMDR.BARS['Rup']['obj']:Hide();
			SLICECMDR.RupExpires = 0;
			SLICECMDR.BARS['Rup']['Expires'] = 0;
		end
	end	
	
	xSound = "RuptAlert";
	if (x > 0) then
		if (x <= 3) then
			if (SLICECMDR.RuptAlertPending == 3) then
				SliceCmdr_Sound(xSound);
				SLICECMDR.RuptAlertPending = 2;
			else 
				if (x <= 2) then
					if (SLICECMDR.RuptAlertPending == 2) then
						SliceCmdr_Sound(xSound);
						SLICECMDR.RuptAlertPending = 1;
					else 
						if (x <= 1) then
							if (SLICECMDR.RuptAlertPending == 1) then
								SliceCmdr_Sound(xSound);
								SLICECMDR.RuptAlertPending = 0;
							end
						end
					end
				end
			end
		else
			SLICECMDR.RuptAlertPending = 3;
		end
		
	end
	
	
end

function SliceCmdr_VendBar()
	local x = SliceCmdr_util_VendTime();
	SLICECMDR.BARS['Vend']['Expires'] = x;
	
	if (x > 0) then
		if (SLICECMDR.BARS['Vend']) then
			SLICECMDR.BARS['Vend']['obj']:SetValue(x);
			SLICECMDR.BARS['Vend']['obj'].text:SetText(string.format("%0.1f", x));
		end
	else
		if (x == 0) then 
			SLICECMDR.BARS['Vend']['obj'].text2:SetText(isMine2);
			SLICECMDR.BARS['Vend']['obj']:Hide();
			SLICECMDR.VendExpires = 0;
			SLICECMDR.BARS['Vend']['Expires'] = 0;
		end
	end	
	
	xSound = "VendAlert";
	if (x > 0) then
		if (x <= 3) then
			if (SLICECMDR.VendAlertPending == 3) then
				SliceCmdr_Sound(xSound);
				SLICECMDR.VendAlertPending = 2;
			else 
				if (x <= 2) then
					if (SLICECMDR.VendAlertPending == 2) then
						SliceCmdr_Sound(xSound);
						SLICECMDR.VendAlertPending = 1;
					else 
						if (x <= 1) then
							if (SLICECMDR.VendAlertPending == 1) then
								SliceCmdr_Sound(xSound);
								SLICECMDR.VendAlertPending = 0;
							end
						end
					end
				end
			end
		else
			SLICECMDR.VendAlertPending = 3;
		end
	end
end

function SliceCmdr_DPBar()
	local x = SliceCmdr_util_DPTime();
	
	if (x > 0) then
		if (SLICECMDR.BARS['DP']) then
			SLICECMDR.BARS['DP']['obj']:SetValue(x);
			SLICECMDR.BARS['DP']['obj'].text:SetText(string.format("%0.1f", x));
		end
	end
	if (x == 0) then
		SLICECMDR.DPExpires = 0;
		SLICECMDR.BARS['DP']['Expires'] = 0;
		SLICECMDR.BARS['DP']['obj']:Hide(); --no need to update anchors since its always on the outside
	end
end

function SliceCmdr_RecupBar()
	local x = SliceCmdr_util_RecupTime();
	SLICECMDR.BARS['Recup']['Expires'] = x;
	local recup = SLICECMDR.BARS['Recup'];
	
	if (x > 0) then
		if (SLICECMDR.BARS['Recup']) then
			SLICECMDR.BARS['Recup']['obj']:SetValue(x);
			SLICECMDR.BARS['Recup']['obj'].text:SetText(string.format("%0.1f", x));
		end
		
		if (x <= 3) then
			if (recup.AlertPending == 3) then
				SliceCmdr_Sound('Recup.Alert');
				recup.AlertPending = 2;
			else 
				if (x <= 2) then
					if (recup.AlertPending == 2) then
						SliceCmdr_Sound('Recup.Alert');
						recup.AlertPending = 1;
					else 
						if (x <= 1) then
							if (recup.AlertPending == 1) then
								SliceCmdr_Sound('Recup.Alert');
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

function RogueMod_EnvenomBar()
	local x = RogueMod_util_EnvenomTime();
	SLICECMDR.BARS['Env']['Expires'] = x;
	
	if (x > 0) then
		if (SLICECMDR.BARS['Env']) then
			SLICECMDR.BARS['Env']['obj']:SetValue(x);
			SLICECMDR.BARS['Env']['obj'].text:SetText(string.format("%0.1f", x));
		end
	end	
end

function SliceCmdr_SNDCooldown() 
	SLICECMDR.tNow = GetTime();
	if (SliceAdmiral_Save.PadLatency) then
		local down, up, lag = GetNetStats();
		SLICECMDR.tNow = SLICECMDR.tNow + (lag*2/1000);
	end	
		
	local x = SliceCmdr_util_SnDBuffTime();
	SLICECMDR.BARS['SnD']['Expires'] = x;
	
	if (SLICECMDR.BARS['SnD']) then
		if (SLICECMDR.BARS['SnD']['obj']) then
			SLICECMDR.BARS['SnD']['obj']:SetValue(x);
			if (x > 0) then
				SLICECMDR.BARS['SnD']['obj'].text:SetText(string.format("%0.1f", x));
			else
				SLICECMDR.BARS['SnD']['obj'].text:SetText("");
			end		
		end			
	end
	
	xSound = "Tick3";
	if (x > 0) then
		if (x <= 3) then
			if (SLICECMDR.AlertPending == 3) then
				SliceCmdr_Sound(xSound);
				SLICECMDR.AlertPending = 2;
			else 
				if (x <= 2) then
					if (SLICECMDR.AlertPending == 2) then
						SliceCmdr_Sound(xSound);
						SLICECMDR.AlertPending = 1;
					else 
						if (x <= 1) then
							if (SLICECMDR.AlertPending == 1) then
								SliceCmdr_Sound(xSound);
								SLICECMDR.AlertPending = 0;
							end
						end
					end
				end
			end
		else
			SLICECMDR.AlertPending = 3;
		end
		
	end
	
end

function RogueMod_SoundCheck() 
	SLICECMDR.tNow = GetTime();
	if (SliceAdmiral_Save.PadLatency) then
		local down, up, lag = GetNetStats();
		SLICECMDR.tNow = SLICECMDR.tNow + (lag*2/1000);
	end	
		
	local x = SLICECMDR.BARORDER[1]['Expires'];
	xSound = SLICECMDR.BARORDER[1]['AlertSound'];
	if (x == 0) then
		if (SLICECMDR.BARORDER[2]['Expires'] > 0) then
			x = SLICECMDR.BARORDER[2]['Expires']
			xSound = SLICECMDR.BARORDER[2]['AlertSound'];
		else
			x = SLICECMDR.BARORDER[3]['Expires']
			xSound = SLICECMDR.BARORDER[3]['AlertSound'];
		end
	end --this picks the bar with the lowest timer. 
	xSound = "Tick3";
	
	--TODO need a y (x equiv) for the 2nd lowest bar
	--TODO need an AlertPending for each bar... 
	
	if (x > 0) then
		if (x <= 3) then
			if (SLICECMDR.AlertPending == 3) then
				SliceCmdr_Sound(xSound);
				SLICECMDR.AlertPending = 2;
			else 
				if (x <= 2) then
					if (SLICECMDR.AlertPending == 2) then
						SliceCmdr_Sound(xSound);
						SLICECMDR.AlertPending = 1;
					else 
						if (x <= 1) then
							if (SLICECMDR.AlertPending == 1) then
								SliceCmdr_Sound(xSound);
								SLICECMDR.AlertPending = 0;
							end
						end
					end
				end
			end
		else
			SLICECMDR.AlertPending = 3;
		end
		
	end
end

function SliceCmdr_OnUpdate()
	VTimerEnergy:SetValue(UnitMana("player"));
	VTimerEnergy:SetMinMaxValues(0,UnitManaMax("player"));
	
	if (UnitManaMax("player") == UnitMana('player')) then
		VTimerEnergyTxt:SetText("");
	else
		VTimerEnergyTxt:SetText(UnitMana("player"));
	end			
	
	SliceCmdr_Config_OtherVars();
	
	if (SLICECMDR.LastEnergy < UnitMana('player')) then
		if (UnitManaMax("player") == UnitMana('player')) then
			--VTimerEnergy:Hide();
			VTimerEnergy:SetAlpha(SliceAdmiral_Save.EnergyTrans / 100.0);
		else
			--VTimerEnergy:Show();
			VTimerEnergy:SetAlpha(1.0);
		end
	end
	
	SLICECMDR.LastEnergy = UnitMana('player');
	SliceCmdr_SNDCooldown();
	SliceCmdr_RecupBar();
	SliceCmdr_DPBar();
	SliceCmdr_RupBar();
	SliceCmdr_VendBar();
        RogueMod_EnvenomBar();
	RogueMod_SortBarsByTime();
	--RogueMod_SoundCheck();
	if (showStatBar == 1) then
		RogueMod_UpdateStats();
	end
end


