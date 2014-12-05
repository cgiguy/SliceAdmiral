local sliceadmiral = LibStub("AceAddon-3.0"):GetAddon("SliceAdmiral");
local L = LibStub("AceLocale-3.0"):GetLocale("SliceAdmiral", true);
local addon = sliceadmiral:NewModule("ShowTimer");

function addon:OnInitialize()
local options = sliceadmiral.opt.ShowTimer 
local col = SAMod.ShowTimer.Colours
options.childGroups="tab";
options.args = { 
			GrowUp = {name=L["Bars/GrowUp"],type="toggle",order=1,		
				get = function(info) return SAMod.ShowTimer.Options.Barsup; end,
				set = function(info,val) SAMod.ShowTimer.Options.Barsup = val; end
			},
			Sort = {name=L["Bars/Sort"],type="toggle",order=2,			
				get = function(info) return SAMod.ShowTimer.Options.SortBars; end,
				set = function(info,val) SAMod.ShowTimer.Options.SortBars = val; end
			},
			Dynamic = {name=L["timer/dynamic"],desc=L["timers/dynamic/desc"], type="toggle",order=3,
				get = function(info) return SAMod.ShowTimer.Options.Dynamic; end,
				set = function(info,val) SAMod.ShowTimer.Options.Dynamic = val; end, 
			},
			ShowDoT = {name=L["Bars/ShowDoT"],type="toggle",order=4,		
				get = function(info) return SAMod.ShowTimer.Options.ShowDoTDmg; end,
				set = function(info,val) SAMod.ShowTimer.Options.ShowDoTDmg = val; end
			},
			DoTCrit = {name=L["Bars/DoTCrit"],type="toggle",order=5,		
				get = function(info) return SAMod.ShowTimer.Options.DoTCrits; end,
				set = function(info,val) SAMod.ShowTimer.Options.DoTCrits = val; end
			},
			barTex = {name=L["Main/Texture"], type="select",order=6,
				values = SA_Text,
				get = function(info) return SAMod.ShowTimer.Options.BarTexture; end,
				set = function(info,val) SAMod.ShowTimer.Options.BarTexture = val, sliceadmiral:RetextureBars(val, "spells") end, 
			},
			MasterVolume = {name=L["Sound/MasterVolume"],desc=L["Sound/MasterDesc"],type="toggle",order=7,width="full",		
				get = function(info) return SAMod.Sound.MasterVolume; end,
				set = function(info,val) SAMod.Sound.MasterVolume = val; end
			},
			OutOfCombat = {name=L["Sound/OutOfCombat"],type="toggle",order=8,width="double",		
				get = function(info) return SAMod.Sound.OutOfCombat; end,
				set = function(info,val) SAMod.Sound.OutOfCombat = val; end
			},
			preview = {name=L["Sound/Preview"],type="toggle",order=9,width="full",			
				get = function(info) return SAMod.Sound.Preview; end,
				set = function(info,val) SAMod.Sound.Preview = val; end
			},
			Shared = {name=L["SharedAbilites"],type="group",order=20,childGroups="tree",args={},},
			Assassination = {name=L["Assassination"],type="group",order=30,childGroups="tree",args={},},
			Combat = {name=L["Combat"],type="group",order=40,childGroups="tree",args={},},
			Subtlety ={name=L["Subtlety"],type="group",order=50,childGroups="tree",args={},},			
		}
	local SA_talents = {[5171] = "Shared", [73651]= "Shared", [154953]= "Shared", [137573]= "Shared", [1966]= "Shared", [703]= "Shared",
			[1943] = "Assassination", [79140]="Assassination", [32645]="Assassination", [2818]="Assassination",
			[84617] = "Combat" ,[13750] = "Combat", [122233]= "Combat",
			[91021]= "Subtlety", [16511]= "Subtlety",[51713]= "Subtlety",
	};	
	
	for k,v in pairs(SA_talents) do		
		if v == "Shared" then
			opt = options.args.Shared.args
		elseif v == "Assassination" then
			opt = options.args.Assassination.args
		elseif v == "Combat" then
			opt = options.args.Combat.args
		elseif v == "Subtlety" then 
			opt = options.args.Subtlety.args
		end	
		opt[SA_Spells[k].name] = {name=SA_Spells[k].name, type="group",
			args = {
				enable = {name=L["ShowBar"],type="toggle", order=1,
					get = function(info) return SAMod.ShowTimer[k]; end,
					set = function(info,val) SAMod.ShowTimer[k] = val; end
				},
				sEnabled = {name=L["alerts/enabled"],type="toggle",order=2,
					get = function(info) return SAMod.Sound[k].enabled; end,
					set = function(info,val) SAMod.Sound[k].enabled = val; end,
				},
				valuses = {name=L["bar/prep"], type="range", order=3,
					min=1.0,max=12.0, step=0.5,
					get = function(info) return SAMod.ShowTimer.Timers[k]; end,
					set = function(info,val) 
						SAMod.ShowTimer.Timers[k] = val; 
						SA_Data.BARS[SA_Spells[k].name]["obj"]:SetMinMaxValues(0,val); end,
				},
				texColor = { name=L["bars/color"], type="color", order=4,
					get = function(info) return col[k].r, col[k].g,col[k].b; end,
					set = function(info, r,g,b,a) SA_Data.BARS[SA_Spells[k].name]["obj"]:SetStatusBarColor(r, g, b); col[k].r = r; col[k].g = g; col[k].b = b; end,
				},
				bar1 = {name=L["SoundSettings"],type="header",order=5},				
				tick = {name=L["TickSound"],type="select",order=12,
					values = SA_ASounds,
					get = function(info) return SAMod.Sound[k].tick; end,
					set = function(info,val)
						SAMod.Sound[k].tick = val;
						sliceadmiral:SA_SoundTest(val);
					end
				},
				alert = {name=L["AlertSound"],type="select",order=13,
					values = SA_ASounds,
					get = function(info) return SAMod.Sound[k].alert; end,
					set = function(info,val) SAMod.Sound[k].alert = val;
					sliceadmiral:SA_SoundTest(val);				
					end
				},
			},
		}
	end
	
	options.args.Combat.args["BanditsGuile"] = {name=L["BanditsGuile"],type="group",
		args = {
			enable = {name=L["ShowBar"],type="toggle", order=1,
				get = function(info) return SAMod.ShowTimer[84745]; end,
				set = function(info,val) SAMod.ShowTimer[84745] = val;SAMod.ShowTimer[84746] = val;SAMod.ShowTimer[84747] = val; end
			},			
			sEnabled = {name=L["alerts/enabled"],type="toggle",order=2,
				get = function(info) return SAMod.Sound[84745].enabled; end,
				set = function(info,val) SAMod.Sound[84745].enabled = val; SAMod.Sound[84746].enabled = val;SAMod.Sound[84747].enabled = val;end,
			},			
			valuses1 = {name=SA_Spells[84745].name, type="range", order=3,
				min=1.0,max=12.0, step=0.5,
				get = function(info) return SAMod.ShowTimer.Timers[84745]; end,
				set = function(info,val) 
					SAMod.ShowTimer.Timers[84745] = val; 
					SA_Data.BARS[SA_Spells[84745].name]["obj"]:SetMinMaxValues(0,val);
					end,
			},
			texColor1 = { name=SA_Spells[84745].name, type="color", order=4,
				get = function(info) return col[84745].r, col[84745].g,col[84745].b; end,
				set = function(info, r,g,b,a) SA_Data.BARS[SA_Spells[84745].name]["obj"]:SetStatusBarColor(r, g, b); col[84745].r = r; col[84745].g = g; col[84745].b = b; end,
			},
			valuses2 = {name=SA_Spells[84746].name, type="range", order=5,
				min=1.0,max=12.0, step=0.5,
				get = function(info) return SAMod.ShowTimer.Timers[84746]; end,
				set = function(info,val) 					
					SAMod.ShowTimer.Timers[84746] = val; 
					SA_Data.BARS[SA_Spells[84746].name]["obj"]:SetMinMaxValues(0,val);
					end,
			},
			texColor2 = { name=SA_Spells[84746].name, type="color", order=6,
				get = function(info) return col[84746].r, col[84746].g,col[84746].b; end,
				set = function(info, r,g,b,a) SA_Data.BARS[SA_Spells[84746].name]["obj"]:SetStatusBarColor(r, g, b); col[84746].r = r; col[84746].g = g; col[84746].b = b; end,
			},
			valuses3 = {name=SA_Spells[84747].name, type="range", order=7,
				min=1.0,max=12.0, step=0.5,
				get = function(info) return SAMod.ShowTimer.Timers[84747]; end,
				set = function(info,val) 					
					SAMod.ShowTimer.Timers[84747] = val; 
					SA_Data.BARS[SA_Spells[84747].name]["obj"]:SetMinMaxValues(0,val);end,
			},
			texColor3 = { name=SA_Spells[84747].name, type="color", order=8,
				get = function(info) return col[84747].r, col[84747].g,col[84747].b; end,
				set = function(info, r,g,b,a) SA_Data.BARS[SA_Spells[84747].name]["obj"]:SetStatusBarColor(r, g, b); col[84747].r = r; col[84747].g = g; col[84747].b = b; end,
			},
			bar1 = {name=L["SoundSettings"],type="header",order=9},	
			bar2 = {name=SA_Spells[84745].name,type="description",order=10,},
			tick = {name=L["TickSound"],type="select",order=11,
				values = SA_ASounds,
				get = function(info) return SAMod.Sound[84745].tick; end,
				set = function(info,val)
					SAMod.Sound[84745].tick = val;					
					sliceadmiral:SA_SoundTest(val);
				end
			},
			alert = {name=L["AlertSound"],type="select",order=12,
				values = SA_ASounds,
				get = function(info) return SAMod.Sound[84745].alert; end,
				set = function(info,val) SAMod.Sound[84745].alert = val;				
				sliceadmiral:SA_SoundTest(val);
				end
			},
			bar3 = {name=SA_Spells[84746].name,type="description",order=13,width="double",},	
			tick1 = {name=L["TickSound"],type="select",order=14,
				values = SA_ASounds,
				get = function(info) return SAMod.Sound[84746].tick; end,
				set = function(info,val)
					SAMod.Sound[84746].tick = val;					
					sliceadmiral:SA_SoundTest(val);
				end
			},
			alert1 = {name=L["AlertSound"],type="select",order=15,
				values = SA_ASounds,
				get = function(info) return SAMod.Sound[84746].alert; end,
				set = function(info,val) SAMod.Sound[84746].alert = val;				
				sliceadmiral:SA_SoundTest(val);
				end
			},
			bar4 = {name=SA_Spells[84747].name,type="description",order=16,width="double",},	
			tick2 = {name=L["TickSound"],type="select",order=17,
				values = SA_ASounds,
				get = function(info) return SAMod.Sound[84747].tick; end,
				set = function(info,val)
					SAMod.Sound[84747].tick = val;					
					sliceadmiral:SA_SoundTest(val);
				end
			},
			alert2 = {name=L["AlertSound"],type="select",order=18,
				values = SA_ASounds,
				get = function(info) return SAMod.Sound[84747].alert; end,
				set = function(info,val) SAMod.Sound[84747].alert = val;				
				sliceadmiral:SA_SoundTest(val);
				end
			},
			
		},
	};
	options.args.Subtlety.args[SA_Spells[1943].name] = options.args.Assassination.args[SA_Spells[1943].name];
	options.args.Subtlety.args[SA_Spells[2818].name] = options.args.Assassination.args[SA_Spells[2818].name];	
	options.args.Subtlety.args[SA_Spells[122233].name] = options.args.Combat.args[SA_Spells[122233].name];

end