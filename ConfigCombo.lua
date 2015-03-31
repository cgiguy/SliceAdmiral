local sliceadmiral = LibStub("AceAddon-3.0"):GetAddon("SliceAdmiral");
local L = LibStub("AceLocale-3.0"):GetLocale("SliceAdmiral", true);
local addon = sliceadmiral:NewModule("Combo");
local LSM = LibStub("LibSharedMedia-3.0")

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
					set = function(info, r,g,b,a) SA_Data.BARS["CP"]["obj"].combo:SetStatusBarColor(r,g,b);							
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
					set = function(info, r,g,b,a) SA_Data.BARS["CP"]["obj"].anti:SetStatusBarColor(r,g,b);
						cpA.r = r; cpA.g = g; cpA.b = b; end,
				},
				barTex = {name=L["combo/texture"], type="select",order=5,dialogControl = 'LSM30_Statusbar',
					values = LSM:HashTable("statusbar"),
					get = function(info) return SAMod.Combo.Texture; end,
					set = function(info,val) SAMod.Combo.Texture = val, sliceadmiral:RetextureBars(LSM:Fetch("statusbar",val), "combo") end, 
				},
				bar = {name=L["combo/statsheader"],type="header",order=6, },
				
				showstats = {name=L["combo/showStats"], type="toggle", order=7,width="full",
					get = function(info) return SAMod.Combo.ShowStatBar; end,
					set = function(info,val) SAMod.Combo.ShowStatBar = val; 
							if (val) then
								SA_Data.BARS["Stat"]["obj"]:Show();
							else
								SA_Data.BARS["Stat"]["obj"]:Hide();
							end 
						end,
				},
				megabuff = {name=L["combo/megabuff"], type="toggle", order=8, width="double",
					get = function(info) return SAMod.Combo.HilightBuffed; end,
					set = function(info,val) SAMod.Combo.HilightBuffed=val; if val and not sliceadmiral.LightTick then 
					sliceadmiral.LightTick = C_Timer.NewTicker(1, sliceadmiral.SA_flashBuffedStats); 
					else if not val and sliceadmiral.LightTick then sliceadmiral.LightTick:Cancel() end; end; end,
				},
				extrastat = {name=L["combo/armor"],desc=L["combo/guile/desc"], type="toggle", order=9,width="full",
					get = function(info) return SAMod.ShowTimer.Options.guileCount end,
					set = function(info,val) SAMod.ShowTimer.Options.guileCount = val; 
						if val then SA2.numStats=4 else SA2.numStats = 3 end;
						sliceadmiral:SA_UpdateStatWidths(); 
						SAMod.ShowTimer.Options.guileCount = val; end,
				},
				bladeflurry = {name=L["combo/bf"],desc=L["combo/bf/desc"], type="toggle", order=10,width="full",
					get = function(info) return SAMod.ShowTimer.Options.BladeFlurry end,
					set = function(info,val) SAMod.ShowTimer.Options.BladeFlurry = val;  end,
				}
			}
end
