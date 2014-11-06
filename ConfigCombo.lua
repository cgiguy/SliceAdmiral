local sliceadmiral = LibStub("AceAddon-3.0"):GetAddon("SliceAdmiral");
local L = LibStub("AceLocale-3.0"):GetLocale("SliceAdmiral", true);
local addon = sliceadmiral:NewModule("Combo");

function addon:OnInitialize()
	local cpC = SAMod.Combo.CPColor
	local cpA = SAMod.Combo.AnColor	
	sliceadmiral.opt.Combo.args = {
				showcp = {name=L["combo/Show"],type="toggle",order=1,
					get = function(info) return SAMod.Combo.PointShow; end, 
					set = function(info,val) SAMod.Combo.PointShow=val;
						if not (SAMod.Combo.PointShow) and not SAMod.Combo.AnticipationShow then
							SA_Data.BARS["CP"]["obj"]:Hide();
						else
							SA_Data.BARS["CP"]["obj"]:Show();
						end
					end
				},
				cpColor = { name=L["Combo/Color"], type="color", order=2,width="double",
					get = function(info) return cpC.r, cpC.g,cpC.b,cpC.a; end,
					set = function(info, r,g,b,a) local combos = SA_Data.BARS["CP"]["obj"].combos;  for i = 1,5 do  
							combos[i]:SetBackdropColor(r,g,b); 
							end;
							cpC.r = r; cpC.g = g; cpC.b = b; end,
				},
				tAnticipation = {name=L["tShow/anticipation"], type="toggle", order=3,
					get = function(info) return SAMod.Combo.AnticipationShow; end,
					set = function(info,val) SAMod.Combo.AnticipationShow=val;
						if not (SAMod.Combo.PointShow) and not SAMod.Combo.AnticipationShow then
							SA_Data.BARS["CP"]["obj"]:Hide();
						else
							SA_Data.BARS["CP"]["obj"]:Show();
						end
					end,
				},
				apColor = { name=L["ComboA/Color"], type="color", order=4,width="double",
					get = function(info) return cpA.r, cpA.g,cpA.b,cpA.a; end,
					set = function(info, r,g,b,a) local antis = SA_Data.BARS["CP"]["obj"].antis; for i=1,5 do 
						antis[i]:SetBackdropColor(r,g,b); end;
						cpA.r = r; cpA.g = g; cpA.b = b; end,
				},
				bar = {name=L["combo/statsheader"],type="header",order=5, },
				showstats = {name=L["combo/showStats"], type="toggle", order=6,width="full",
					get = function(info) return SAMod.Combo.ShowStatBar; end,
					set = function(info,val) SAMod.Combo.ShowStatBar = val; 
							if (val) then
								SA_Data.BARS["Stat"]["obj"]:Show();
							else
								SA_Data.BARS["Stat"]["obj"]:Hide();
							end 
						end,
				},
				megabuff = {name=L["combo/megabuff"], type="toggle", order=7, width="double",
					get = function(info) return SAMod.Combo.HilightBuffed; end,
					set = function(info,val) SAMod.Combo.HilightBuffed=val end,
				},
				extrastat = {name=L["combo/armor"],desc=L["combo/guile/desc"], type="toggle", order=8,width="full",
					get = function(info) return SAMod.ShowTimer.Options.guileCount end,
					set = function(info,val) SAMod.ShowTimer.Options.guileCount = val; 
						if val then SA2.numStats=4 else SA2.numStats = 3 end;
						sliceadmiral:SA_UpdateStatWidths(); 
						SAMod.ShowTimer.Options.guileCount = val; end,
				},
				bladeflurry = {name=L["combo/bf"],desc=L["combo/bf/desc"], type="toggle", order=9,width="full",
					get = function(info) return SAMod.ShowTimer.Options.BladeFlurry end,
					set = function(info,val) SAMod.ShowTimer.Options.BladeFlurry = val;  end,
				}
			}
end
