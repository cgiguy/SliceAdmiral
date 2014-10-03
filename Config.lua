-- Author      : cgiguy
-- Create Date : 9/12/2008 9:43:03 PM
SliceAdmiral_Save = {      
  ["BarMargin"] = "3",
  ["Barsup"] = true,
  ["BarTexture"] = "Smooth",
  ["CPBarShow"] = true,
  ["AntisCPShow"] = true,
  ["DoTCrits"] = true,
  ["DPBarShow"] = true,
  ["Energy1"] = 25,
  ["Energy2"] = 40,
  ["EnergySound1"] = "None",
  ["EnergySound2"] = "None",
  ["EnergyTrans"] = 50,
  ["Expire"] = "Waaaah",
  ["Fade"] = 100,
  ["Fail"] = "Waaaah",
  ["HideCombo"] = false,
  ["HideEnergy"] = true,
  ["HilightBuffed"] = false,
  ["IsLocked"] = false,
  ["MasterVolume"] = false,
  ["none"] = "none",
  ["PadLatency"] = true,
  ["Recup.Alert"] = "Tambourine",
  ["Recup.Expire"] = "Price is WRONG",
  ["Recup.Fail"] = "Price is WRONG",      
  ["Recup.Tick"] = "Tambourine",
  ["RevealBarShow"] = true,
  ["RevealExpire"] = "BassDrum",
  ["RevealAlert"] = "Shaker",
  ["RupBarShow"] = true,
  ["RuptAlert"] = "Shaker",
  ["RuptExpire"] = "BassDrum",
  ["Scale"] = 130,
  ["ShowDoTDmg"] = true,  
  ["ShowEnvBar"] = true,
  ["ShowFeintBar"] = true,
  ["ShowRecupBar"] = true,
  ["ShowSnDBar"] = true,
  ["ShowStatBar"] = true,
  ["ShowGuileBar"] = true,
  ["ShowHemoBar"] = true,
  ["SortBars"] = true,      
  ["Tick3"] = "Tambourine",
  ["VendAlert"] = "Ping",
  ["VendBarShow"] = true,
  ["VendExpire"] = "Drum Rattle",
  ["Width"] = 130,
};

function SA_Config_OnEvent(self, event, ...)
  if (event == "ADDON_LOADED") then
    local arg1 = ...;
    local localizedClass, englishClass = UnitClass("player");
    if (arg1 == "SliceAdmiral" and englishClass == "ROGUE") then
      SA_Config_LoadVars();
    end
  end
end

function SA_Config_Checkbutton_OnLoad(checkButton)	
    _G[checkButton:GetName() .. "Text"]:SetText(checkButton:GetText())	
end

local function SA_Config_Menu_OnClick(self) -- See note 1
  UIDropDownMenu_SetSelectedValue(self.owner, self.value);
  UIDropDownMenu_SetText(self.owner, self.value);
  SA_SoundTest(self.value);  
end

local function SA_Config_Menu_OnClickTexture(self) -- See note 1
  -- DEFAULT_CHAT_FRAME:AddMessage("Chose texture: " .. self.value);
  UIDropDownMenu_SetSelectedValue(self.owner, self.value);
  UIDropDownMenu_SetText(self.owner, self.value);
end

local function SA_Config_SoundMenu_Init(self,WhichMenu,level)
  local this = self or _G.this
  level = level or 1 --drop down menus can have sub menus. The value of "level" determines the drop down sub menu tier.

  local info = UIDropDownMenu_CreateInfo();
  local SoundName, SoundPath;

  for ignore, SoundName in pairs(SA_SoundMenu[WhichMenu]) do
    info.text = SoundName;
    info.value = SoundName;
    info.func = function(self) SA_Config_Menu_OnClick(self) end; --sets the function to execute when this item is clicked
    info.owner = self; --binds the drop down menu as the parent of the menu item. This is very important for dynamic drop down menues.
    info.checked = nil; --initially set the menu item to being unchecked with a yellow tick
    info.icon = nil; --we can use this to set an icon for the drop down menu item to accompany the text
    UIDropDownMenu_AddButton(info, level); --Adds the new button to the drop down menu specified in the UIDropDownMenu_Initialise function. In this case, it is MyDropDownMenu
  end
end

local function SA_Config_Expire_Initialise(self) SA_Config_SoundMenu_Init(self,"Fail"); end
local function SA_Config_Tick_Initialise(self) SA_Config_SoundMenu_Init(self,"Tick"); end
local function SA_Config_Energy_Initialise(self) SA_Config_SoundMenu_Init(self,"Energy"); end

local function SA_Config_Texture_Initialise(self,level)
  local this = self or _G.this
  level = level or 1 --drop down menus can have sub menus. The value of "level" determines the drop down sub menu tier.

  local info = UIDropDownMenu_CreateInfo();
  local key, value;

  for key, value in pairs(SA_BarTextures) do
    info.text = key;
    info.value = key;
    info.func = function(self) SA_Config_Menu_OnClickTexture(self) end; --sets the function to execute when this item is clicked
    --mb  info.owner = this:GetParent(); --binds the drop down menu as the parent of the menu item. This is very important for dynamic drop down menues.
    info.owner = self; --binds the drop down menu as the parent of the menu item. This is very important for dynamic drop down menues.
    info.checked = nil; --initially set the menu item to being unchecked with a yellow tick
    info.icon = nil; --we can use this to set an icon for the drop down menu item to accompany the text
    UIDropDownMenu_AddButton(info, level); --Adds the new button to the drop down menu specified in the UIDropDownMenu_Initialise function. In this case, it is MyDropDownMenu
  end
  UIDropDownMenu_SetSelectedValue(self,SliceAdmiral_Save.BarTexture);
  UIDropDownMenu_SetText(self,SliceAdmiral_Save.BarTexture);
end


local SA_Config_ExpireMenu = nil;
local SA_Config_Tick3Menu = nil;

local SA_Config_Energy2Menu = nil;
local SA_Config_Energy1Menu = nil;

local SA_Config_Recup_AlertMenu = nil;
local SA_Config_Recup_ExpireMenu = nil;

local SA_Config_Rupt_AlertMenu = nil;
local SA_Config_Rupt_ExpireMenu = nil;

local SA_Config_Reveal_AlertMenu = nil;
local SA_Config_Reveal_ExpireMenu = nil;

local SA_Config_Vend_AlertMenu = nil;
local SA_Config_Vend_ExpireMenu = nil;

local SA_Config_BarTextureMenu = nil;


function SA_Config_OnLoad(panel)
  local localizedClass, englishClass = UnitClass("player");
  if (englishClass ~= "ROGUE") then
    return;
  end

  SA_Config:SetBackdrop(nil);
  SA_Config2:SetBackdrop(nil);

  panel:RegisterEvent("ADDON_LOADED");

  SA_Config_BarTextureMenu = CreateFrame("Frame", "SA_Config_BarTexture2M", panel, "UIDropDownMenuTemplate");
  SA_Config_BarTextureMenu:SetPoint("TOPLEFT", SA_Config_BarTextureStr, "TOPLEFT", 0, -20);
  UIDropDownMenu_SetWidth(SA_Config_BarTextureMenu, 142);
  UIDropDownMenu_SetButtonWidth(SA_Config_BarTextureMenu, 20);
  UIDropDownMenu_Initialize(SA_Config_BarTextureMenu, SA_Config_Texture_Initialise);

  panel.name = "SliceAdmiral";
  panel.okay = function (self) SA_Config_Okay(); end;
  panel.cancel = function (self)  SA_Config_Cancel();  end;
  panel.default = function (self) SA_Config_Default(); end;
  InterfaceOptions_AddCategory(panel);

  ---  COMBO POINT FRAME ---
  panel = SA_Config_CPFrame
  panel:SetBackdrop(nil);
  panel.parent= "SliceAdmiral";
  panel.name= SC_TIMERBARS; --SC_LANG_CP;
  panel.okay = function (self) SA_Config_Okay(); end;
  panel.cancel = function (self)  SA_Config_Cancel();  end;
  panel.default = function (self) SA_Config_Default(); end;
  InterfaceOptions_AddCategory(panel);

  ---  Stat bar frame ---
  panel = SA_Config_StatBar
  panel:SetBackdrop(nil);
  panel.parent = "SliceAdmiral";
  panel.name = SC_COMBOANDSTATS;
  panel.okay = function (self) SA_Config_Okay(); end;
  panel.cancel = function (self)  SA_Config_Cancel();  end;
  panel.default = function (self) SA_Config_Default(); end;
  InterfaceOptions_AddCategory(panel);

  ---  ENERGY FRAME --- only sound drop downs
  panel = SA_Config_EnergyFrame;
  panel:SetBackdrop(nil);

  SA_Config_Energy1Menu = CreateFrame("Frame", "SA_Config_Energy1M", panel, "UIDropDownMenuTemplate");
  SA_Config_Energy1Menu:SetPoint("TOPLEFT", SA_Config_Energy1, "TOPLEFT", 0, -20);
  UIDropDownMenu_SetWidth(SA_Config_Energy1Menu, 142);
  UIDropDownMenu_SetButtonWidth(SA_Config_Energy1Menu, 20);
  UIDropDownMenu_Initialize(SA_Config_Energy1Menu, SA_Config_Energy_Initialise);

  SA_Config_Energy2Menu = CreateFrame("Frame", "SA_Config_Energy2M", panel, "UIDropDownMenuTemplate");
  SA_Config_Energy2Menu:SetPoint("TOPLEFT", SA_Config_Energy2, "TOPLEFT", 0, -20);
  UIDropDownMenu_SetWidth(SA_Config_Energy2Menu, 142);
  UIDropDownMenu_SetButtonWidth(SA_Config_Energy2Menu, 20);
  UIDropDownMenu_Initialize(SA_Config_Energy2Menu, SA_Config_Energy_Initialise);

  panel.parent = "SliceAdmiral";
  panel.name = SC_ENERGYBAR;
  panel.okay = function (self) SA_Config_Okay(); end;
  panel.cancel = function (self)  SA_Config_Cancel();  end;
  panel.default = function (self) SA_Config_Default(); end;
  InterfaceOptions_AddCategory(panel);


  ---  SLICE AND DICE CONFIG ---
  panel = SA_Config2;

  SA_Config_ExpireMenu = CreateFrame("Frame", "SA_Config_Expire", panel, "UIDropDownMenuTemplate");
  SA_Config_ExpireMenu:SetPoint("TOPLEFT", ExpireSnD_Str, "TOPLEFT", 0, -20);
  UIDropDownMenu_SetWidth(SA_Config_ExpireMenu, 142);
  UIDropDownMenu_SetButtonWidth(SA_Config_ExpireMenu, 20);
  UIDropDownMenu_Initialize(SA_Config_ExpireMenu, SA_Config_Expire_Initialise);

  SA_Config_Tick3Menu = CreateFrame("Frame", "SA_Config_Tick3", panel, "UIDropDownMenuTemplate");
  SA_Config_Tick3Menu:SetPoint("TOPLEFT", SA_Config_Tick3Str, "TOPLEFT", 0, -20);
  UIDropDownMenu_SetWidth(SA_Config_Tick3Menu, 142);
  UIDropDownMenu_SetButtonWidth(SA_Config_Tick3Menu, 20);
  UIDropDownMenu_Initialize(SA_Config_Tick3Menu, SA_Config_Tick_Initialise);


  SA_Config_Recup_ExpireMenu = CreateFrame("Frame", "SA_Config_Recup_Expire", panel, "UIDropDownMenuTemplate");
  SA_Config_Recup_ExpireMenu:SetPoint("TOPLEFT", SA_Config_Recup_ExpireStr, "TOPLEFT", 0, -20);
  UIDropDownMenu_SetWidth(SA_Config_Recup_ExpireMenu, 142);
  UIDropDownMenu_SetButtonWidth(SA_Config_Recup_ExpireMenu, 20);
  UIDropDownMenu_Initialize(SA_Config_Recup_ExpireMenu, SA_Config_Expire_Initialise);

  SA_Config_Recup_AlertMenu = CreateFrame("Frame", "SA_Config_Recup_Alert", panel, "UIDropDownMenuTemplate");
  SA_Config_Recup_AlertMenu:SetPoint("TOPLEFT", SA_Config_Recup_AlertStr, "TOPLEFT", 0, -20);
  UIDropDownMenu_SetWidth(SA_Config_Recup_AlertMenu, 142);
  UIDropDownMenu_SetButtonWidth(SA_Config_Recup_AlertMenu, 20);
  UIDropDownMenu_Initialize(SA_Config_Recup_AlertMenu, SA_Config_Tick_Initialise);

  ------------------------Recup sounds end


  SA_Config_Rupt_ExpireMenu = CreateFrame("Frame", "SA_Config_Rupt_ExpireMenu", panel, "UIDropDownMenuTemplate");
  SA_Config_Rupt_ExpireMenu:SetPoint("TOPLEFT", SA_Config_Rupt_ExpireStr, "TOPLEFT", 0, -20);
  UIDropDownMenu_SetWidth(SA_Config_Rupt_ExpireMenu, 142);
  UIDropDownMenu_SetButtonWidth(SA_Config_Rupt_ExpireMenu, 20);
  UIDropDownMenu_Initialize(SA_Config_Rupt_ExpireMenu, SA_Config_Expire_Initialise);

  SA_Config_Rupt_AlertMenu = CreateFrame("Frame", "SA_Config_Rupt_AlertMenu", panel, "UIDropDownMenuTemplate");
  SA_Config_Rupt_AlertMenu:SetPoint("TOPLEFT", SA_Config_Rupt_AlertStr, "TOPLEFT", 0, -20);
  UIDropDownMenu_SetWidth(SA_Config_Rupt_AlertMenu, 142);
  UIDropDownMenu_SetButtonWidth(SA_Config_Rupt_AlertMenu, 20);
  UIDropDownMenu_Initialize(SA_Config_Rupt_AlertMenu, SA_Config_Tick_Initialise);
  
  SA_Config_Reveal_ExpireMenu = CreateFrame("Frame", "SA_Config_Reveal_ExpireMenu", panel, "UIDropDownMenuTemplate");
  SA_Config_Reveal_ExpireMenu:SetPoint("TOPLEFT", SA_Config_Reveal_ExpireStr, "TOPLEFT", 0, -20);
  UIDropDownMenu_SetWidth(SA_Config_Reveal_ExpireMenu, 142);
  UIDropDownMenu_SetButtonWidth(SA_Config_Reveal_ExpireMenu, 20);
  UIDropDownMenu_Initialize(SA_Config_Reveal_ExpireMenu, SA_Config_Expire_Initialise);

  SA_Config_Reveal_AlertMenu = CreateFrame("Frame", "SA_Config_Reveal_AlertMenu", panel, "UIDropDownMenuTemplate");
  SA_Config_Reveal_AlertMenu:SetPoint("TOPLEFT", SA_Config_Reveal_AlertStr, "TOPLEFT", 0, -20);
  UIDropDownMenu_SetWidth(SA_Config_Reveal_AlertMenu, 142);
  UIDropDownMenu_SetButtonWidth(SA_Config_Reveal_AlertMenu, 20);
  UIDropDownMenu_Initialize(SA_Config_Reveal_AlertMenu, SA_Config_Tick_Initialise);

  SA_Config_Vend_ExpireMenu = CreateFrame("Frame", "SA_Config_Vend_ExpireMenu", panel, "UIDropDownMenuTemplate");
  SA_Config_Vend_ExpireMenu:SetPoint("TOPLEFT", SA_Config_Vend_ExpireStr, "TOPLEFT", 0, -20);
  UIDropDownMenu_SetWidth(SA_Config_Vend_ExpireMenu, 142);
  UIDropDownMenu_SetButtonWidth(SA_Config_Vend_ExpireMenu, 20);
  UIDropDownMenu_Initialize(SA_Config_Vend_ExpireMenu, SA_Config_Expire_Initialise);

  SA_Config_Vend_AlertMenu = CreateFrame("Frame", "SA_Config_Vend_AlertMenu", panel, "UIDropDownMenuTemplate");
  SA_Config_Vend_AlertMenu:SetPoint("TOPLEFT", SA_Config_Vend_AlertStr, "TOPLEFT", 0, -20);
  UIDropDownMenu_SetWidth(SA_Config_Vend_AlertMenu, 142);
  UIDropDownMenu_SetButtonWidth(SA_Config_Vend_AlertMenu, 20);
  UIDropDownMenu_Initialize(SA_Config_Vend_AlertMenu, SA_Config_Tick_Initialise);

  SA_Config2.parent = "SliceAdmiral";
  SA_Config2.name = SC_SOUNDEFFECTS;
  SA_Config2.okay =    function (self) SA_Config_Okay(); end;
  SA_Config2.cancel =  function (self) SA_Config_Cancel();  end;
  SA_Config2.default = function (self) SA_Config_Default(); end;
  InterfaceOptions_AddCategory(SA_Config2);

  --Text at top of frames
  SA_Config3_Caption:SetText( SC_SPELL_RECUP .. " " .. SC_LANG_SOUNDS);
  SA_Config2_Caption:SetText( SC_SPELL_SND .. " " .. SC_LANG_SOUNDS);
--  SA_MB:SetText("Header Text");

  SA_Config_LoadVars();
end

function SA_Config_LoadVars()
  UIDropDownMenu_SetSelectedValue(SA_Config_ExpireMenu, SliceAdmiral_Save.Expire );
  UIDropDownMenu_SetText(SA_Config_ExpireMenu, SliceAdmiral_Save.Expire );
  UIDropDownMenu_SetSelectedValue(SA_Config_Tick3Menu, SliceAdmiral_Save.Tick3 );
  UIDropDownMenu_SetText(SA_Config_Tick3Menu, SliceAdmiral_Save.Tick3 );
  UIDropDownMenu_SetSelectedValue(SA_Config_Energy2Menu, SliceAdmiral_Save.EnergySound2 );
  UIDropDownMenu_SetText(SA_Config_Energy2Menu, SliceAdmiral_Save.EnergySound2 );
  UIDropDownMenu_SetSelectedValue(SA_Config_Energy1Menu, SliceAdmiral_Save.EnergySound1 );
  UIDropDownMenu_SetText(SA_Config_Energy1Menu, SliceAdmiral_Save.EnergySound1 );

  -- hunger for blood --
  UIDropDownMenu_SetSelectedValue(SA_Config_Recup_AlertMenu, SliceAdmiral_Save["Recup.Alert"] );
  UIDropDownMenu_SetText(SA_Config_Recup_AlertMenu, SliceAdmiral_Save["Recup.Alert"] );
  UIDropDownMenu_SetSelectedValue(SA_Config_Recup_ExpireMenu, SliceAdmiral_Save["Recup.Expire"] );
  UIDropDownMenu_SetText(SA_Config_Recup_ExpireMenu, SliceAdmiral_Save["Recup.Expire"] );
  
  UIDropDownMenu_SetSelectedValue(SA_Config_Rupt_ExpireMenu, SliceAdmiral_Save["RuptExpire"]);
  UIDropDownMenu_SetText(SA_Config_Rupt_ExpireMenu, SliceAdmiral_Save["RuptExpire"]);
  UIDropDownMenu_SetSelectedValue(SA_Config_Rupt_AlertMenu, SliceAdmiral_Save["RuptAlert"]);
  UIDropDownMenu_SetText(SA_Config_Rupt_AlertMenu, SliceAdmiral_Save["RuptAlert"]);
  
  UIDropDownMenu_SetSelectedValue(SA_Config_Reveal_ExpireMenu, SliceAdmiral_Save["RevealExpire"]);
  UIDropDownMenu_SetText(SA_Config_Reveal_ExpireMenu, SliceAdmiral_Save["RevealExpire"]);
  UIDropDownMenu_SetSelectedValue(SA_Config_Reveal_AlertMenu, SliceAdmiral_Save["RevealAlert"]);
  UIDropDownMenu_SetText(SA_Config_Reveal_AlertMenu, SliceAdmiral_Save["RevealAlert"]);
  
  UIDropDownMenu_SetSelectedValue(SA_Config_Vend_ExpireMenu, SliceAdmiral_Save["VendExpire"]);
  UIDropDownMenu_SetText(SA_Config_Vend_ExpireMenu, SliceAdmiral_Save["VendExpire"]);
  UIDropDownMenu_SetSelectedValue(SA_Config_Vend_AlertMenu, SliceAdmiral_Save["VendAlert"]);
  UIDropDownMenu_SetText(SA_Config_Vend_AlertMenu, SliceAdmiral_Save["VendAlert"]);

  UIDropDownMenu_SetSelectedValue(SA_Config_BarTextureMenu, SliceAdmiral_Save.BarTexture);
  UIDropDownMenu_SetText(SA_Config_BarTextureMenu, SliceAdmiral_Save.BarTexture);

  SA_Config_HideE:SetChecked( SliceAdmiral_Save.HideEnergy );
  SA_Config_Lock:SetChecked( SliceAdmiral_Save.IsLocked );
  SA_Config_PadLatency:SetChecked( SliceAdmiral_Save.PadLatency );
  SA_Config_Energy1:SetValue( SliceAdmiral_Save.Energy1 );
  SA_Config_Energy1V:SetText( SliceAdmiral_Save.Energy1 );
  SA_Config_Energy2:SetValue( SliceAdmiral_Save.Energy2 );
  SA_Config_Energy2V:SetText( SliceAdmiral_Save.Energy2 );
  SA_Config_Scale:SetValue( SliceAdmiral_Save.Scale );
  SA_Config_ScaleV:SetText( SliceAdmiral_Save.Scale );

  if (not SliceAdmiral_Save.Fade) then
    SliceAdmiral_Save.Fade = 100; --new variable
  end
  SA_Fade:SetValue( SliceAdmiral_Save.Fade );
  SA_FadeV:SetText( SliceAdmiral_Save.Fade );
  if (not SliceAdmiral_Save.BarMargin) then
    SliceAdmiral_Save.BarMargin = 0;
  end
  SA_Config_BarMargin:SetText(SliceAdmiral_Save.BarMargin);
  SA_Config_NumStatsBar:SetChecked((SliceAdmiral_Save.numStats == 4))

  SA_Config_ShowCPBar:SetChecked( SliceAdmiral_Save.CPBarShow );
  SA_Config_ShowAntisiBar:SetChecked( SliceAdmiral_Save.AntisCPShow );
  SA_Config_ShowDoTDmg:SetChecked( SliceAdmiral_Save.ShowDoTDmg );
  SA_Config_ShowDPBar:SetChecked( SliceAdmiral_Save.DPBarShow );
  SA_Config_ShowEnvBar:SetChecked(SliceAdmiral_Save.ShowEnvBar );
  SA_Config_ShowGuileBar:SetChecked( SliceAdmiral_Save.ShowGuileBar);
  SA_Config_ShowFeintBar:SetChecked( SliceAdmiral_Save.ShowFeintBar );
  SA_Config_ShowRecupBar:SetChecked( SliceAdmiral_Save.ShowRecupBar );
  SA_Config_ShowRevealBar:SetChecked( SliceAdmiral_Save.RevealBarShow );
  SA_Config_ShowRupBar:SetChecked( SliceAdmiral_Save.RupBarShow );
  SA_Config_ShowSnDBar:SetChecked( SliceAdmiral_Save.ShowSnDBar );
  SA_Config_ShowStatBar:SetChecked( SliceAdmiral_Save.ShowStatBar );
  SA_Config_ShowHemoBar:SetChecked( SliceAdmiral_Save.ShowHemoBar );
  SA_Config_ShowVendBar:SetChecked( SliceAdmiral_Save.VendBarShow ); 
  SA_Config_MasterVolume:SetChecked( SliceAdmiral_Save.MasterVolume );
  SA_Config_NoCombatSound:SetChecked( SliceAdmiral_Save.OutOfCombat );
  SA_Config_Barsup:SetChecked( SliceAdmiral_Save.Barsup );
  SA_Config_SortBars:SetChecked( SliceAdmiral_Save.SortBars );
  SA_Config_DoTCrits:SetChecked( SliceAdmiral_Save.DoTCrits );

  SA_Config_HilightBuffed:SetChecked(SliceAdmiral_Save.HilightBuffed );
  if ( not SliceAdmiral_Save.EnergyTrans) then
    SliceAdmiral_Save.EnergyTrans = 20;
  end
  SA_Config_TransFull:SetValue(SliceAdmiral_Save.EnergyTrans);
  SA_Config_TransFullV:SetText(SliceAdmiral_Save.EnergyTrans);
  if ( not SliceAdmiral_Save.Width ) then
    SliceAdmiral_Save.Width = 200;
  end

  SA_Config_Width:SetValue( SliceAdmiral_Save.Width );
  SA_Config_WidthV:SetText( SliceAdmiral_Save.Width );

  if (SA) then
    SA_Config_VarsChanged();
    SA_Config_OtherVars();
  end
end

function SA_SetScale(NewScale)
  if (NewScale >= 50) then
    SA:SetScale ( NewScale / 100 );
    VTimerEnergy:SetScale ( NewScale / 100 );	
	for k,v in pairs(SA_Data.BARS) do
		SA_Data.BARS[k]["obj"]:SetScale(NewScale/100);
	end
  end
end

function SA_SetWidth(w)
  if (w >= 25) then
    VTimerEnergy:SetWidth( w);
	for k,v in pairs(SA_Data.BARS) do
		SA_Data.BARS[k]["obj"]:SetWidth(w);
	end
	local lUnitManaMax = UnitManaMax("player")
    SA_Spark1:SetPoint("TOPLEFT", VTimerEnergy, "TOPLEFT", (SliceAdmiral_Save.Energy1 / lUnitManaMax * w), 0);
    SA_Spark2:SetPoint("TOPLEFT", VTimerEnergy, "TOPLEFT", (SliceAdmiral_Save.Energy2 / lUnitManaMax * w), 0);
    SA_UpdateCPWidths();
    SA_UpdateStatWidths();
  end
end

local function SA_Config_RetextureBars()
  local texture = SA_BarTexture();  
  VTimerEnergy:SetStatusBarTexture(texture);
  
  for k,v in pairs(SA_Data.BARS) do
	if not (k == "CP" or k == "Stat") then
		SA_Data.BARS[k]["obj"]:SetStatusBarTexture(texture);
	end
  end

  for i = 1, 5 do
    SA_Data.BARS["CP"]["obj"].combos[i].bg:SetTexture(texture);
  end
end

function SA_Config_VarsChanged()
  SA_SetScale(SliceAdmiral_Save.Scale);
  SA_SetWidth(SliceAdmiral_Save.Width);

  if SliceAdmiral_Save.HideEnergy then
    VTimerEnergy:Hide();
  else
    VTimerEnergy:Show();
  end

  if SliceAdmiral_Save.HideCombo then
    SA_Combo:Hide();
    SA:UnregisterEvent("UNIT_COMBO_POINTS");
    SA:UnregisterEvent("PLAYER_TARGET_CHANGED");
  else
    SA_Combo:Show();
    SA:RegisterEvent("UNIT_COMBO_POINTS");
    SA:RegisterEvent("PLAYER_TARGET_CHANGED");
  end

  if SliceAdmiral_Save.CPBarShow then
    SA_Data.BARS["CP"]["obj"]:Show();
  else
    SA_Data.BARS["CP"]["obj"]:Hide();
  end
  if SliceAdmiral_Save.ShowStatBar then
    SA_Data.BARS["Stat"]["obj"]:Show();
  else
    SA_Data.BARS["Stat"]["obj"]:Hide();
  end

  SA_Config_RetextureBars();
  SA_Config_OtherVars();  
end

function SA_Config_OtherVars()
  local lUnitManaMax = UnitManaMax("player");
  local p1 = SliceAdmiral_Save.Energy1 / lUnitManaMax * SliceAdmiral_Save.Width;
  local p2 = SliceAdmiral_Save.Energy2 / lUnitManaMax * SliceAdmiral_Save.Width;

  SA_Spark1:SetPoint("TOPLEFT", VTimerEnergy, "TOPLEFT", p1, 0);
  SA_Spark2:SetPoint("TOPLEFT", VTimerEnergy, "TOPLEFT", p2, 0);
end

function SA_Config_Okay()
  SliceAdmiral_Save.IsLocked = SA_Config_Lock:GetChecked();  
  SliceAdmiral_Save.Barsup = SA_Config_Barsup:GetChecked();
  SliceAdmiral_Save.CPBarShow = SA_Config_ShowCPBar:GetChecked();
  SliceAdmiral_Save.AntisCPShow = SA_Config_ShowAntisiBar:GetChecked();
  SliceAdmiral_Save.DoTCrits= SA_Config_DoTCrits:GetChecked();
  SliceAdmiral_Save.DPBarShow = SA_Config_ShowDPBar:GetChecked();
  SliceAdmiral_Save.HideEnergy = SA_Config_HideE:GetChecked();
  SliceAdmiral_Save.HilightBuffed = SA_Config_HilightBuffed:GetChecked();
  SliceAdmiral_Save.MasterVolume = SA_Config_MasterVolume:GetChecked();
  SliceAdmiral_Save.OutOfCombat = SA_Config_NoCombatSound:GetChecked();
  SliceAdmiral_Save.PadLatency = SA_Config_PadLatency:GetChecked();
  SliceAdmiral_Save.RevealBarShow = SA_Config_ShowRevealBar:GetChecked();
  SliceAdmiral_Save.RupBarShow = SA_Config_ShowRupBar:GetChecked();
  SliceAdmiral_Save.ShowDoTDmg = SA_Config_ShowDoTDmg:GetChecked();
  SliceAdmiral_Save.ShowEnvBar = SA_Config_ShowEnvBar:GetChecked();
  SliceAdmiral_Save.ShowFeintBar = SA_Config_ShowFeintBar:GetChecked();
  SliceAdmiral_Save.ShowRecupBar = SA_Config_ShowRecupBar:GetChecked();
  SliceAdmiral_Save.ShowSnDBar = SA_Config_ShowSnDBar:GetChecked();
  SliceAdmiral_Save.ShowStatBar = SA_Config_ShowStatBar:GetChecked();
  SliceAdmiral_Save.ShowGuileBar = SA_Config_ShowGuileBar:GetChecked();
  SliceAdmiral_Save.ShowHemoBar = SA_Config_ShowHemoBar:GetChecked();
  SliceAdmiral_Save.SortBars = SA_Config_SortBars:GetChecked();
  SliceAdmiral_Save.VendBarShow = SA_Config_ShowVendBar:GetChecked();
  --
  SliceAdmiral_Save.Energy1 = SA_Config_Energy1:GetValue();
  SliceAdmiral_Save.Energy2 = SA_Config_Energy2:GetValue();
  SliceAdmiral_Save.Scale = SA_Config_Scale:GetValue();
  SliceAdmiral_Save.Fade = SA_Fade:GetValue();
  SliceAdmiral_Save.Width = SA_Config_Width:GetValue();
  SliceAdmiral_Save.EnergyTrans = SA_Config_TransFull:GetValue();
  SliceAdmiral_Save.BarTexture = UIDropDownMenu_GetSelectedValue( SA_Config_BarTextureMenu );
  SliceAdmiral_Save.BarMargin = SA_Config_BarMargin:GetText();
  if (not SliceAdmiral_Save.BarMargin) then
    SliceAdmiral_Save.BarMargin = 0;
  end
  if SA_Config_NumStatsBar:GetChecked() then
    SliceAdmiral_Save.numStats = 4
  else
	SliceAdmiral_Save.numStats = 3
  end

  SA_SetScale( SliceAdmiral_Save.Scale ); --HP: these are what are on screen
  SA_SetWidth( SliceAdmiral_Save.Width );

  SliceAdmiral_Save.Fail = UIDropDownMenu_GetSelectedValue( SA_Config_ExpireMenu );
  SliceAdmiral_Save.Expire = UIDropDownMenu_GetSelectedValue( SA_Config_ExpireMenu );
  SliceAdmiral_Save.Tick3 = UIDropDownMenu_GetSelectedValue( SA_Config_Tick3Menu );  
  SliceAdmiral_Save.EnergySound1 = UIDropDownMenu_GetSelectedValue( SA_Config_Energy1Menu );
  SliceAdmiral_Save.EnergySound2 = UIDropDownMenu_GetSelectedValue( SA_Config_Energy2Menu );

  -- page two --
  SliceAdmiral_Save["Recup.Alert"] = UIDropDownMenu_GetSelectedValue( SA_Config_Recup_AlertMenu );
  SliceAdmiral_Save["Recup.Expire"] = UIDropDownMenu_GetSelectedValue(SA_Config_Recup_ExpireMenu );
  SliceAdmiral_Save["Recup.Fail"] = UIDropDownMenu_GetSelectedValue(SA_Config_Recup_ExpireMenu );  

  SliceAdmiral_Save["RuptAlert"] = UIDropDownMenu_GetSelectedValue( SA_Config_Rupt_AlertMenu );
  SliceAdmiral_Save["RuptExpire"] = UIDropDownMenu_GetSelectedValue( SA_Config_Rupt_ExpireMenu );  
  SliceAdmiral_Save["RevealAlert"] = UIDropDownMenu_GetSelectedValue( SA_Config_Reveal_AlertMenu );
  SliceAdmiral_Save["RevealExpire"] = UIDropDownMenu_GetSelectedValue( SA_Config_Reveal_ExpireMenu );

  SliceAdmiral_Save["VendAlert"] = UIDropDownMenu_GetSelectedValue( SA_Config_Vend_AlertMenu );
  SliceAdmiral_Save["VendExpire"] = UIDropDownMenu_GetSelectedValue( SA_Config_Vend_ExpireMenu );

  SA_Config_VarsChanged();
end

function SA_Config_Cancel()
  SA_Config_LoadVars();
end

function SA_Config_Default()
  SliceAdmiral_Save.IsLocked = false;
  SliceAdmiral_Save.HideEnergy = true;
  SliceAdmiral_Save.numStats = 4;
  SliceAdmiral_Save.Energy1 = 25;
  SliceAdmiral_Save.Energy2 = 40;
  SliceAdmiral_Save.Fail = "Waaaah";
  SliceAdmiral_Save.Expire = "BassDrum";
  SliceAdmiral_Save.Tick3 = "Tambourine";    
  SliceAdmiral_Save.EnergySound1 = "None";
  SliceAdmiral_Save.EnergySound2 = "None";
  SliceAdmiral_Save["Recup.Fail"] = "Waaaah";
  SliceAdmiral_Save["Recup.Expire"] = "Waaaah";    
  SliceAdmiral_Save["Recup.Alert"] = "None";
  SliceAdmiral_Save["Width"] = 120;
  SliceAdmiral_Save["Scale"] = 140;
  SliceAdmiral_Save["PadLatency"] = true;
  SliceAdmiral_Save["EnergyTrans"] = 50;
  SliceAdmiral_Save["None"] = "None";
  SliceAdmiral_Save.BarMargin = 0;
  SliceAdmiral_Save.DPBarShow = true;
  SliceAdmiral_Save.RupBarShow = true;
  SliceAdmiral_Save.RevealBarShow = true;
  SliceAdmiral_Save.VendBarShow = true;
  SliceAdmiral_Save.ShowEnvBar = true;
  SliceAdmiral_Save.ShowFeintBar = true;
  SliceAdmiral_Save.HilightBuffed = false;
  SliceAdmiral_Save.ShowSnDBar = true;
  SliceAdmiral_Save.ShowRecupBar = true;
  SliceAdmiral_Save.ShowGuileBar = true;
  SliceAdmiral_Save.ShowHemoBar = true;
  SliceAdmiral_Save.CPBarShow = true;
  SliceAdmiral_Save.AntisCPShow = true;
  SliceAdmiral_Save.Barsup = true;
  SliceAdmiral_Save.SortBars = true;
  SliceAdmiral_Save.ShowStatBar = true;
  SliceAdmiral_Save.MasterVolume = false;
  SliceAdmiral_Save.OutOfCombat = false;
  SliceAdmiral_Save.BarTexture = "Smooth"
  SA_Config_LoadVars();
end

function SA_Config_TransFull_OnValueChanged(self)
  if (SA_Config_TransFullV) then
    SA_Config_TransFullV:SetText(self:GetValue());
  end
end

function SA_Config_TransFullV_OnTextChanged(self)
  local adjust = floor(self:GetText() + 0.5);
  if ( adjust > 0) then
    SA_Config_TransFull:SetValue( adjust );    
    VTimerEnergy:SetAlpha( adjust / 100.0 );
  end
end

function SA_Config_Energy2_OnValueChanged(self)
  if SA_Config_Energy2V then
    SA_Config_Energy2V:SetText(self:GetValue());
  end
end

function SA_Config_Energy2V_OnTextChanged(self)
  SA_Config_Energy2:SetValue(self:GetText());
end