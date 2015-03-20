local sliceadmiral = LibStub("AceAddon-3.0"):GetAddon("SliceAdmiral");
local L = LibStub("AceLocale-3.0"):GetLocale("SliceAdmiral", true);
local LSM  = LibStub("LibSharedMedia-3.0")
local addon = sliceadmiral:NewModule("Energy");
local UnitPowerMax = UnitPowerMax("player")

function addon:OnInitialize()
	local energy = UnitPowerMax
	local Co = SAMod.Energy.Color;
	local tCo = SAMod.Energy.TextColor;
	local cCo = SAMod.Energy.ComboTextColor
	if (energy < 50) then
		energy = 100
	end
	sliceadmiral.opt.Energy.args = { 
			enable = {name=L["energy/Show"],type="toggle",order=1,	
				get = function(info) return SAMod.Energy.ShowEnergy; end,
				set = function(info,val) SAMod.Energy.ShowEnergy = val;
							if val then 
								VTimerEnergy:Show();
							else
								VTimerEnergy:Hide();
							end
						end,
			},
			showcp = {name=L["energy/ShowCombo"],type="toggle",order=4,
					get = function(info) return SAMod.Energy.ShowComboText; end, 
					set = function(info,val) SAMod.Energy.ShowComboText=val;
						if not (SAMod.Energy.ShowComboText) and not (SAMod.Energy.AnticpationText) then
							SA_Combo:Hide();							
						else
							SA_Combo:Show();							
						end
					end,
				},
			showanti = {name=L["energy/ShowAnti"],type="toggle",order=7,width="full",
					get = function(info) return SAMod.Energy.AnticpationText; end, 
					set = function(info,val) SAMod.Energy.AnticpationText=val;
						if not (SAMod.Energy.ShowComboText) and not (SAMod.Energy.AnticpationText) then
							SA_Combo:Hide();							
						else
							SA_Combo:Show();							
						end
					end,
				},
			marker1 = {name=L["energy/mark1"],type="range",order=8,
				min=1,max=energy,step=1,
				get = function(info) return SAMod.Energy.Energy1; end,
				set = function(info,val) SAMod.Energy.Energy1 = val; 
						local p1 = val / energy * SAMod.Main.Width;
						SA_Spark1:SetPoint("TOPLEFT", VTimerEnergy, "TOPLEFT", p1, 0);
					end,
			},
			marker2 = {name=L["energy/mark2"],type="range",order=9,
				min=1,max=energy,step=1,
				get = function(info) return SAMod.Energy.Energy2; end,
				set = function(info,val) SAMod.Energy.Energy2 = val; 
						local p2 = val / energy * SAMod.Main.Width;
						SA_Spark2:SetPoint("TOPLEFT", VTimerEnergy, "TOPLEFT", p2, 0);
					end,
			},
			empty1 = {name="",type="description",order=6,},
			ealert1 = {name=L["AlertSound"],type="select",order=13,disabled=true,
				values = LSM:HashTable("sound"),
				get = function(info) return SAMod.Energy.EnergySound1; end,
				set = function(info,val) SAMod.Energy.EnergySound1 = val;			
				end
			},
			ealert2 = {name=L["AlertSound"],type="select",order=14,disabled=true,
				values = LSM:HashTable("sound"),
				get = function(info) return SAMod.Energy.EnergySound2; end,
				set = function(info,val) SAMod.Energy.EnergySound2 = val;			
				end
			},
			empty = {name="", type="description", order=15, },
			trancp = { name=L["energy/transp"],type="range",order=16,
				min=1,max=100,step=1,
				get =function(info) return SAMod.Energy.EnergyTrans; end,
				set = function(info,val) SAMod.Energy.EnergyTrans = val; end,
			},
			texture = {name=L["Main/Texture"],type="select",order=17, dialogControl = 'LSM30_Statusbar',
				values = LSM:HashTable("statusbar"),				
				get = function(info) return SAMod.Energy.BarTexture; end,				
				set = function(info,val) SAMod.Energy.BarTexture = val; sliceadmiral:RetextureBars(LSM:Fetch("statusbar",val),"Energy") end,
			},
			texColor = { name=L["energy/Color"], type="color", order=2,
				get = function(info) return Co.r, Co.g,Co.b,Co.a; end,
				set = function(info, r,g,b,a) VTimerEnergy:SetStatusBarColor(r,g,b); Co.r = r; Co.g = g; Co.b = b; end,
			},
			textColor = { name=L["energy/TextColor"], type="color", order=3,
				get = function(info) return tCo.r, tCo.g,tCo.b,tCo.a; end,
				set = function(info, r,g,b,a) VTimerEnergyTxt:SetTextColor(r,g,b,a); tCo.r = r; tCo.g = g; tCo.b = b;tCo.a = a; end,
			},
			combotextColor = { name=L["energy/CoTextColor"], type="color", order=5,
				get = function(info) return cCo.r, cCo.g,cCo.b,cCo.a; end,
				set = function(info, r,g,b,a) SA_Combo:SetTextColor(r,g,b,a); cCo.r = r; cCo.g = g; cCo.b = b;cCo.a = a; end,
			},
			
		};
end