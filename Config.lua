-- Author      : cgiguy
-- Create Date : 9/12/2008 9:43:03 PM
SliceAdmiral_Save = {
  ["ShowSnDBar"] = true,
  ["MasterVolume"] = false,
  ["Scale"] = 130,
  ["SortBars"] = true,
  ["RupBarShow"] = true,
  ["VendBarShow"] = true,
  ["Recup.Tick"] = "Tambourine",
  ["ShowDoTDmg"] = true,
  ["ShowEnvBar"] = true,
  ["Apply1"] = "None",
  ["Expire"] = "Waaaah",
  ["Recup.Expire"] = "Price is WRONG",
  ["Fail"] = "Waaaah",
  ["IsLocked"] = false,
  ["Energy1"] = 25,
  ["ShowRecupBar"] = true,
  ["Applied"] = "None",
  ["EnergySound2"] = "None",
  ["Recup.Refresh1"] = "Tambourine",
  ["BarMargin"] = "3",
  ["Recup.Refresh3"] = "Tambourine",
  ["HilightBuffed"] = false,
  ["EnergyTrans"] = 50,
  ["DPBarShow"] = true,
  ["Barsup"] = true,
  ["Recup.Fail"] = "Price is WRONG",
  ["Apply2"] = "None",
  ["Recup.Alert"] = "Tambourine",
  ["Tick3"] = "Tambourine",
  ["Tick2"] = "Tambourine",
  ["Energy2"] = 40,
  ["ShowStatBar"] = true,
  ["BarTexture"] = "Smooth",
  ["DoTCrits"] = true,
  ["EnergySound1"] = "None",
  ["HideCombo"] = false,
  ["PadLatency"] = true,
  ["Tick1"] = "Tambourine",
  ["HideEnergy"] = true,
  ["Recup.Refresh2"] = "Tambourine",
  ["Width"] = 130,
  ["CPBarShow"] = true,
  ["RuptAlert"] = "Shaker",
  ["RuptExpire"] = "BassDrum",
  ["VendAlert"] = "Ping",
  ["VendExpire"] = "Drum Rattle",
  ["Fade"] = 100,
};

function SA_Config_OnEvent(self, event, ...)
  if (event == "ADDON_LOADED") then
    local arg1 = select(1, ...);
    local localizedClass, englishClass = UnitClass("player");
    if (arg1 == "SliceAdmiral" and englishClass == "ROGUE") then
      SA_Config_LoadVars();
    end
  end
end


function SA_Config_Menu_OnClick(self) -- See note 1
  UIDropDownMenu_SetSelectedValue(self.owner, self.value);
  UIDropDownMenu_SetText(self.owner, self.value);
  SA_SoundTest(self.value);
end

function SA_Config_Menu_OnClickTexture(self) -- See note 1
  -- DEFAULT_CHAT_FRAME:AddMessage("Chose texture: " .. self.value);
  UIDropDownMenu_SetSelectedValue(self.owner, self.value);
  UIDropDownMenu_SetText(self.owner, self.value);
end

function SA_Config_Expire_Initialise(self) SA_Config_SoundMenu_Init(self,"Fail"); end
function SA_Config_Fail_Initialise(self) SA_Config_SoundMenu_Init(self,"Fail"); end
function SA_Config_Tick_Initialise(self) SA_Config_SoundMenu_Init(self,"Tick"); end
function SA_Config_Apply_Initialise(self) SA_Config_SoundMenu_Init(self,"Apply"); end
function SA_Config_Energy_Initialise(self) SA_Config_SoundMenu_Init(self,"Energy"); end

function SA_Config_Texture_Initialise(self,level)
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

function SA_Config_SoundMenu_Init(self,WhichMenu,level)
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

SA_Config_FailMenu = nil;
SA_Config_ExpireMenu = nil;
SA_Config_Tick3Menu = nil;
--[[SA_Config_Tick2Menu = nil;
SA_Config_Tick1Menu = nil;
SA_Config_Applied3Menu = nil;
SA_Config_Applied2Menu = nil;
SA_Config_Applied1Menu = nil;
SA_Config_AppliedMenu = nil;]]
SA_Config_Energy2Menu = nil;
SA_Config_Energy1Menu = nil;

SA_Config_Recup_AlertMenu = nil;
SA_Config_Recup_ExpireMenu = nil;
--SA_Config_Recup_FailMenu = nil;
--[[SA_Config_Recup_AppliedMenu = nil;
SA_Config_Recup_Refresh3Menu = nil;
SA_Config_Recup_Refresh2Menu = nil;
SA_Config_Recup_Refresh1Menu = nil;]]

SA_Config_Rupt_AlertMenu = nil;
SA_Config_Rupt_ExpireMenu = nil;

SA_Config_Vend_AlertMenu = nil;
SA_Config_Vend_ExpireMenu = nil;

SA_Config_BarTextureMenu = nil;


function SA_Config_OnLoad(panel)
  local localizedClass, englishClass = UnitClass("player");
  if (englishClass ~= "ROGUE") then
    return;
  end

  SA_Config:SetBackdrop(nil);
  SA_Config2:SetBackdrop(nil);
--  SA_MB:SetBackdrop(nil);

  panel:RegisterEvent("ADDON_LOADED");

  SA_Config_BarTextureMenu = CreateFrame("Frame", "SA_Config_BarTexture2M", panel, "UIDropDownMenuTemplate");
  SA_Config_BarTextureMenu:SetPoint("TOPLEFT", SA_Config_BarTextureStr, "TOPLEFT", 0, -20);
  UIDropDownMenu_SetWidth(SA_Config_BarTextureMenu, 142);
  UIDropDownMenu_SetButtonWidth(SA_Config_BarTextureMenu, 20);
  --  local foo = function(parent) SA_Config_Texture_Initialise(SA_Config_BarTextureMenu); end;
  --  UIDropDownMenu_Initialize(SA_Config_BarTextureMenu, foo);
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
  --ShowTimerBars.text = "Show Timer Barzzz";
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
  InterfaceOptions_AddCategory(panel);--]]

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

--  SA_MB.parent = "SliceAdmiral";
--  SA_MB.name = "Mark Test";
--  SA_MB.okay =    function (self) SA_Config_Okay(); end;
--  SA_MB.cancel =  function (self) SA_Config_Cancel();  end;
--  SA_MB.default = function (self) SA_Config_Default(); end;
--  InterfaceOptions_AddCategory(SA_MB);

  --Text at top of frames
  SA_Config3_Caption:SetText( SC_SPELL_RECUP .. " " .. SC_LANG_SOUNDS);
  SA_Config2_Caption:SetText( SC_SPELL_SND .. " " .. SC_LANG_SOUNDS);
--  SA_MB:SetText("Header Text");

  SA_Config_LoadVars();
end

function SA_Config_LoadVars()
  --UIDropDownMenu_SetSelectedValue(SA_Config_FailMenu, SliceAdmiral_Save.Fail );
  UIDropDownMenu_SetSelectedValue(SA_Config_ExpireMenu, SliceAdmiral_Save.Expire );
  UIDropDownMenu_SetText(SA_Config_ExpireMenu, SliceAdmiral_Save.Expire );
  UIDropDownMenu_SetSelectedValue(SA_Config_Tick3Menu, SliceAdmiral_Save.Tick3 );
  UIDropDownMenu_SetText(SA_Config_Tick3Menu, SliceAdmiral_Save.Tick3 );
  --UIDropDownMenu_SetSelectedValue(SA_Config_Tick2Menu, SliceAdmiral_Save.Tick2 );
  --UIDropDownMenu_SetSelectedValue(SA_Config_Tick1Menu, SliceAdmiral_Save.Tick1 );
  --UIDropDownMenu_SetSelectedValue(SA_Config_Applied3Menu, SliceAdmiral_Save.Apply3 );
  --UIDropDownMenu_SetSelectedValue(SA_Config_Applied2Menu, SliceAdmiral_Save.Apply2 );
  --UIDropDownMenu_SetSelectedValue(SA_Config_Applied1Menu, SliceAdmiral_Save.Apply1 );
  --UIDropDownMenu_SetSelectedValue(SA_Config_AppliedMenu, SliceAdmiral_Save.Applied );
  UIDropDownMenu_SetSelectedValue(SA_Config_Energy2Menu, SliceAdmiral_Save.EnergySound2 );
  UIDropDownMenu_SetText(SA_Config_Energy2Menu, SliceAdmiral_Save.EnergySound2 );
  UIDropDownMenu_SetSelectedValue(SA_Config_Energy1Menu, SliceAdmiral_Save.EnergySound1 );
  UIDropDownMenu_SetText(SA_Config_Energy1Menu, SliceAdmiral_Save.EnergySound1 );


  -- hunger for blood --
  UIDropDownMenu_SetSelectedValue(SA_Config_Recup_AlertMenu, SliceAdmiral_Save['Recup.Alert'] );
  UIDropDownMenu_SetText(SA_Config_Recup_AlertMenu, SliceAdmiral_Save['Recup.Alert'] );
  UIDropDownMenu_SetSelectedValue(SA_Config_Recup_ExpireMenu, SliceAdmiral_Save['Recup.Expire'] );
  UIDropDownMenu_SetText(SA_Config_Recup_ExpireMenu, SliceAdmiral_Save['Recup.Expire'] );
  --UIDropDownMenu_SetSelectedValue(SA_Config_Recup_FailMenu, SliceAdmiral_Save['Recup.Fail'] );
  --UIDropDownMenu_SetSelectedValue(SA_Config_Recup_AppliedMenu, SliceAdmiral_Save['Recup.Applied'] );
  --UIDropDownMenu_SetSelectedValue(SA_Config_Recup_Refresh3Menu, SliceAdmiral_Save['Recup.Refresh3'] );
  --UIDropDownMenu_SetSelectedValue(SA_Config_Recup_Refresh2Menu, SliceAdmiral_Save['Recup.Refresh2'] );
  --UIDropDownMenu_SetSelectedValue(SA_Config_Recup_Refresh1Menu, SliceAdmiral_Save['Recup.Refresh1'] );
  UIDropDownMenu_SetSelectedValue(SA_Config_Rupt_ExpireMenu, SliceAdmiral_Save['RuptExpire']);
  UIDropDownMenu_SetText(SA_Config_Rupt_ExpireMenu, SliceAdmiral_Save['RuptExpire']);
  UIDropDownMenu_SetSelectedValue(SA_Config_Rupt_AlertMenu, SliceAdmiral_Save['RuptAlert']);
  UIDropDownMenu_SetText(SA_Config_Rupt_AlertMenu, SliceAdmiral_Save['RuptAlert']);

  UIDropDownMenu_SetSelectedValue(SA_Config_Vend_ExpireMenu, SliceAdmiral_Save['VendExpire']);
  UIDropDownMenu_SetText(SA_Config_Vend_ExpireMenu, SliceAdmiral_Save['VendExpire']);
  UIDropDownMenu_SetSelectedValue(SA_Config_Vend_AlertMenu, SliceAdmiral_Save['VendAlert']);
  UIDropDownMenu_SetText(SA_Config_Vend_AlertMenu, SliceAdmiral_Save['VendAlert']);


  --  DEFAULT_CHAT_FRAME:AddMessage("Original menu texture value: " .. UIDropDownMenu_GetSelectedValue(SA_Config_BarTextureMenu));
  UIDropDownMenu_SetSelectedValue(SA_Config_BarTextureMenu, SliceAdmiral_Save.BarTexture);
  UIDropDownMenu_SetText(SA_Config_BarTextureMenu, SliceAdmiral_Save.BarTexture);
  --  DEFAULT_CHAT_FRAME:AddMessage("Trying to config texture to " .. SliceAdmiral_Save.BarTexture);


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

  SA_Config_ShowRupBar:SetChecked( SliceAdmiral_Save.RupBarShow );
  SA_Config_ShowVendBar:SetChecked( SliceAdmiral_Save.VendBarShow );
  SA_Config_ShowDPBar:SetChecked( SliceAdmiral_Save.DPBarShow );
  SA_Config_ShowCPBar:SetChecked( SliceAdmiral_Save.CPBarShow );

  SA_Config_ShowSnDBar:SetChecked( SliceAdmiral_Save.ShowSnDBar );
  if (SliceAdmiral_Save.MasterVolume) then
    SA_Config_MasterVolume:SetChecked( SliceAdmiral_Save.MasterVolume );
  end
  SA_Config_ShowRecupBar:SetChecked( SliceAdmiral_Save.ShowRecupBar );
  SA_Config_Barsup:SetChecked( SliceAdmiral_Save.Barsup );
  SA_Config_SortBars:SetChecked( SliceAdmiral_Save.SortBars );
  SA_Config_ShowDoTDmg:SetChecked( SliceAdmiral_Save.ShowDoTDmg );
  SA_Config_DoTCrits:SetChecked( SliceAdmiral_Save.DoTCrits );
  SA_Config_ShowStatBar:SetChecked( SliceAdmiral_Save.ShowStatBar );
  SA_Config_ShowEnvBar:SetChecked(SliceAdmiral_Save.ShowEnvBar );
  --SA_Config_HilightBuffed:SetChecked(SliceAdmiral_Save.HilightBuffed );
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


  --[[if (SliceAdmiral_Save.Barsup) then
  print("Done Loading Vars from Config (true)")
  else
  print("Done Loading Vars from Config (false)")
  end]]

end

function SA_SetScale(NewScale)
  if (NewScale >= 50) then
    SA:SetScale ( NewScale / 100 );
    VTimerEnergy:SetScale ( NewScale / 100 );
    if(SA_Data.BARS['Recup']['obj']) then
      SA_Data.BARS['Recup']['obj']:SetScale ( NewScale / 100 );
    end
    if (SA_Data.BARS['Rup']['obj']) then
      SA_Data.BARS['Rup']['obj']:SetScale ( NewScale / 100 );
    end
    if (SA_Data.BARS['Vend']['obj']) then
      SA_Data.BARS['Vend']['obj']:SetScale ( NewScale / 100 );
    end
    if (SA_Data.BARS['CP']['obj']) then
      SA_Data.BARS['CP']['obj']:SetScale ( NewScale / 100 );
    end
    if (SA_Data.BARS['DP']['obj']) then
      SA_Data.BARS['DP']['obj']:SetScale ( NewScale / 100 );
    end
    if (SA_Data.BARS['SnD']['obj']) then
      SA_Data.BARS['SnD']['obj']:SetScale ( NewScale / 100 );
    end
    if (SA_Data.BARS['Stat']['obj']) then
      SA_Data.BARS['Stat']['obj']:SetScale ( NewScale / 100 );
    end
    if (SA_Data.BARS['Env']['obj']) then
      SA_Data.BARS['Env']['obj']:SetScale ( NewScale / 100 );
    end
  end
end

function SA_SetWidth(w)
  if (w >= 25) then
    VTimerEnergy:SetWidth( w);
    if (SA_Data.BARS['Recup']['obj']) then
      SA_Data.BARS['Recup']['obj']:SetWidth( w );
    end
    if (SA_Data.BARS['CP']['obj']) then
      SA_Data.BARS['CP']['obj']:SetWidth( w );
    end
    if (SA_Data.BARS['Rup']['obj']) then
      SA_Data.BARS['Rup']['obj']:SetWidth( w );
    end
    if (SA_Data.BARS['Vend']['obj']) then
      SA_Data.BARS['Vend']['obj']:SetWidth( w );
    end
    if (SA_Data.BARS['DP']['obj']) then
      SA_Data.BARS['DP']['obj']:SetWidth( w );
    end
    if (SA_Data.BARS['SnD']['obj']) then
      SA_Data.BARS['SnD']['obj']:SetWidth( w );
    end
    if (SA_Data.BARS['Stat']['obj']) then
      SA_Data.BARS['Stat']['obj']:SetWidth( w );
    end
    if (SA_Data.BARS['Env']['obj']) then
      SA_Data.BARS['Env']['obj']:SetWidth( w );
    end

    SA_Spark1:SetPoint("TOPLEFT", VTimerEnergy, "TOPLEFT", (SliceAdmiral_Save.Energy1 / UnitManaMax("player") * w), 0);
    SA_Spark2:SetPoint("TOPLEFT", VTimerEnergy, "TOPLEFT", (SliceAdmiral_Save.Energy2 / UnitManaMax("player") * w), 0);
    SA_UpdateCPWidths();
    SA_UpdateStatWidths();
  end
end

function SA_Config_VarsChanged()
  SA_SetScale(SliceAdmiral_Save.Scale);
  SA_SetWidth(SliceAdmiral_Save.Width);

  if (SliceAdmiral_Save.HideEnergy == true) then
    VTimerEnergy:Hide();
  else
    VTimerEnergy:Show();
  end

  if (SliceAdmiral_Save.HideCombo == true) then
    SA_Combo:Hide();
    SA:UnregisterEvent("UNIT_COMBO_POINTS");
    SA:UnregisterEvent("PLAYER_TARGET_CHANGED");
  else
    SA_Combo:Show();
    SA:RegisterEvent("UNIT_COMBO_POINTS");
    SA:RegisterEvent("PLAYER_TARGET_CHANGED");
  end

  if (SliceAdmiral_Save.CPBarShow == true) then
    SA_Data.BARS['CP']['obj']:Show();
  else
    SA_Data.BARS['CP']['obj']:Hide();
  end
  if (SliceAdmiral_Save.ShowStatBar == true) then
    SA_Data.BARS['Stat']['obj']:Show();
  else
    SA_Data.BARS['Stat']['obj']:Hide();
  end

  SA_Config_RetextureBars();
  SA_Config_OtherVars();
end
function SA_Config_RetextureBars()
  local texture = SA_BarTexture();

  VTimerEnergy:SetStatusBarTexture(texture);
  SA_Data.BARS['Rup']['obj']:SetStatusBarTexture(texture);
  SA_Data.BARS['Vend']['obj']:SetStatusBarTexture(texture);
  SA_Data.BARS['DP']['obj']:SetStatusBarTexture(texture);
  SA_Data.BARS['SnD']['obj']:SetStatusBarTexture(texture);
  SA_Data.BARS['Recup']['obj']:SetStatusBarTexture(texture);
  SA_Data.BARS['Env']['obj']:SetStatusBarTexture(texture);

  for i = 1, 5 do
    SA_Data.BARS['CP']['obj'].combos[i].bg:SetTexture(texture);
  end

end


function SA_Config_OtherVars()
  local p1 = SliceAdmiral_Save.Energy1 / UnitManaMax("player") * SliceAdmiral_Save.Width;
  local p2 = SliceAdmiral_Save.Energy2 / UnitManaMax("player") * SliceAdmiral_Save.Width;

  SA_Spark1:SetPoint("TOPLEFT", VTimerEnergy, "TOPLEFT", p1, 0);
  SA_Spark2:SetPoint("TOPLEFT", VTimerEnergy, "TOPLEFT", p2, 0);
end

function SA_Config_Okay()
  if (SA_Config_Lock:GetChecked()) then
    SliceAdmiral_Save.IsLocked = true;
    SA:EnableMouse(false);
  else
    SliceAdmiral_Save.IsLocked = false;
    SA:EnableMouse(true);
  end
  if (SA_Config_HideE:GetChecked()) then
    SliceAdmiral_Save.HideEnergy = true;
  else
    SliceAdmiral_Save.HideEnergy = false;
  end


  if (SA_Config_PadLatency:GetChecked()) then
    SliceAdmiral_Save.PadLatency= true;
  else
    SliceAdmiral_Save.PadLatency= false;
  end

  if (SA_Config_ShowDPBar:GetChecked()) then
    SliceAdmiral_Save.DPBarShow= true;
  else
    SliceAdmiral_Save.DPBarShow= false;
  end

  if (SA_Config_ShowCPBar:GetChecked()) then
    SliceAdmiral_Save.CPBarShow= true;
  else
    SliceAdmiral_Save.CPBarShow= false;
  end
  if (SA_Config_ShowRupBar:GetChecked()) then
    SliceAdmiral_Save.RupBarShow= true;
  else
    SliceAdmiral_Save.RupBarShow= false;
  end
  if (SA_Config_ShowVendBar:GetChecked()) then
    SliceAdmiral_Save.VendBarShow= true;
  else
    SliceAdmiral_Save.VendBarShow= false;
  end
  --
  if (SA_Config_ShowSnDBar:GetChecked()) then
    SliceAdmiral_Save.ShowSnDBar= true;
  else
    SliceAdmiral_Save.ShowSnDBar= false;
  end
  if (SA_Config_MasterVolume:GetChecked()) then
    SliceAdmiral_Save.MasterVolume = true;
  else
    SliceAdmiral_Save.MasterVolume = false;
  end
  if (SA_Config_ShowRecupBar:GetChecked()) then
    SliceAdmiral_Save.ShowRecupBar= true;
  else
    SliceAdmiral_Save.ShowRecupBar= false;
  end
  if (SA_Config_Barsup:GetChecked()) then
    SliceAdmiral_Save.Barsup= true;
  else
    SliceAdmiral_Save.Barsup= false;
  end
  if (SA_Config_SortBars:GetChecked()) then
    SliceAdmiral_Save.SortBars= true;
  else
    SliceAdmiral_Save.SortBars= false;
  end
  if (SA_Config_ShowDoTDmg:GetChecked()) then
    SliceAdmiral_Save.ShowDoTDmg= true;
  else
    SliceAdmiral_Save.ShowDoTDmg= false;
  end
  if (SA_Config_DoTCrits:GetChecked()) then
    SliceAdmiral_Save.DoTCrits= true;
  else
    SliceAdmiral_Save.DoTCrits= false;
  end
  if (SA_Config_ShowStatBar:GetChecked()) then
    SliceAdmiral_Save.ShowStatBar= true;
  else
    SliceAdmiral_Save.ShowStatBar= false;
  end
  if (SA_Config_ShowEnvBar:GetChecked()) then
    SliceAdmiral_Save.ShowEnvBar= true;
  else
    SliceAdmiral_Save.ShowEnvBar= false;
  end
  if (SA_Config_HilightBuffed:GetChecked()) then
    SliceAdmiral_Save.HilightBuffed= true;
  else
    SliceAdmiral_Save.HilightBuffed= false;
  end
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

  SA_SetScale( SliceAdmiral_Save.Scale ); --HP: these are what are on screen
  SA_SetWidth( SliceAdmiral_Save.Width );

  SliceAdmiral_Save.Fail = UIDropDownMenu_GetSelectedValue( SA_Config_ExpireMenu );
  SliceAdmiral_Save.Expire = UIDropDownMenu_GetSelectedValue( SA_Config_ExpireMenu );
  SliceAdmiral_Save.Tick3 = UIDropDownMenu_GetSelectedValue( SA_Config_Tick3Menu );
  --[[SliceAdmiral_Save.Tick2 = UIDropDownMenu_GetSelectedValue( SA_Config_Tick2Menu );
  SliceAdmiral_Save.Tick1 = UIDropDownMenu_GetSelectedValue( SA_Config_Tick1Menu );
  SliceAdmiral_Save.Applied = UIDropDownMenu_GetSelectedValue( SA_Config_AppliedMenu );
  SliceAdmiral_Save.Apply3 = UIDropDownMenu_GetSelectedValue( SA_Config_Applied3Menu );
  SliceAdmiral_Save.Apply2 = UIDropDownMenu_GetSelectedValue( SA_Config_Applied2Menu );
  SliceAdmiral_Save.Apply1 = UIDropDownMenu_GetSelectedValue( SA_Config_Applied1Menu );]]
  SliceAdmiral_Save.EnergySound1 = UIDropDownMenu_GetSelectedValue( SA_Config_Energy1Menu );
  SliceAdmiral_Save.EnergySound2 = UIDropDownMenu_GetSelectedValue( SA_Config_Energy2Menu );

  -- page two --
  SliceAdmiral_Save['Recup.Alert'] = UIDropDownMenu_GetSelectedValue( SA_Config_Recup_AlertMenu );
  SliceAdmiral_Save['Recup.Expire'] = UIDropDownMenu_GetSelectedValue(SA_Config_Recup_ExpireMenu );
  SliceAdmiral_Save['Recup.Fail'] = UIDropDownMenu_GetSelectedValue(SA_Config_Recup_ExpireMenu );
  --[[SliceAdmiral_Save['Recup.Applied'] = UIDropDownMenu_GetSelectedValue(SA_Config_Recup_AppliedMenu );
  SliceAdmiral_Save['Recup.Refresh3'] = UIDropDownMenu_GetSelectedValue(SA_Config_Recup_Refresh3Menu );
  SliceAdmiral_Save['Recup.Refresh2'] = UIDropDownMenu_GetSelectedValue(SA_Config_Recup_Refresh2Menu );
  SliceAdmiral_Save['Recup.Refresh1'] = UIDropDownMenu_GetSelectedValue(SA_Config_Recup_Refresh1Menu );]]

  SliceAdmiral_Save['RuptAlert'] = UIDropDownMenu_GetSelectedValue( SA_Config_Rupt_AlertMenu );
  SliceAdmiral_Save['RuptExpire'] = UIDropDownMenu_GetSelectedValue( SA_Config_Rupt_ExpireMenu );
  --SliceAdmiral_Save['RuptFail'] =   --TODO add rupture failure!

  SliceAdmiral_Save['VendAlert'] = UIDropDownMenu_GetSelectedValue( SA_Config_Vend_AlertMenu );
  SliceAdmiral_Save['VendExpire'] = UIDropDownMenu_GetSelectedValue( SA_Config_Vend_ExpireMenu );

  SA_Config_VarsChanged();
end

function SA_Config_Cancel()
  SA_Config_LoadVars();
end

function SA_Config_Default()
  SliceAdmiral_Save.IsLocked = false;
  SliceAdmiral_Save.HideEnergy = true;
  SliceAdmiral_Save.Energy1 = 25;
  SliceAdmiral_Save.Energy2 = 40;
  SliceAdmiral_Save.Fail = 'Waaaah';
  SliceAdmiral_Save.Expire = 'BassDrum';
  SliceAdmiral_Save.Tick3 = 'Tambourine';
  SliceAdmiral_Save.Tick2 = 'Tambourine';
  SliceAdmiral_Save.Tick1 = 'Tambourine';
  SliceAdmiral_Save.Applied = 'None';
  SliceAdmiral_Save.Apply3 = 'None';
  SliceAdmiral_Save.Apply2 = 'None';
  SliceAdmiral_Save.Apply1 = 'None';
  SliceAdmiral_Save.EnergySound1 = 'None';
  SliceAdmiral_Save.EnergySound2 = 'None';
  SliceAdmiral_Save['Recup.Fail'] = 'Waaaah';
  SliceAdmiral_Save['Recup.Expire'] = 'Waaaah';
  SliceAdmiral_Save['Recup.Applied'] = 'None';
  SliceAdmiral_Save['Recup.Refresh3'] = 'None';
  SliceAdmiral_Save['Recup.Refresh2'] = 'None';
  SliceAdmiral_Save['Recup.Refresh1'] = 'None';
  SliceAdmiral_Save['Recup.Alert'] = 'None';
  SliceAdmiral_Save['Width'] = 110;
  SliceAdmiral_Save['Scale'] = 140;
  SliceAdmiral_Save['PadLatency'] = true;
  SliceAdmiral_Save['EnergyTrans'] = 50;
  SliceAdmiral_Save.BarMargin = 3;
  SliceAdmiral_Save.DPBarShow = true;
  SliceAdmiral_Save.RupBarShow = true;
  SliceAdmiral_Save.VendBarShow = true;
  SliceAdmiral_Save.ShowEnvBar = true;
  SliceAdmiral_Save.HilightBuffed = false;
  SliceAdmiral_Save.ShowSnDBar = true;
  SliceAdmiral_Save.ShowRecupBar = true;
  SliceAdmiral_Save.CPBarShow = true;
  SliceAdmiral_Save.Barsup = true;
  SliceAdmiral_Save.SortBars = true;
  SliceAdmiral_Save.ShowStatBar = true;
  SliceAdmiral_Save.MasterVolume = false;
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
    --SA_SetWidth( adjust );
    VTimerEnergy:SetAlpha( adjust / 100.0 );
  end
end

function SA_Config_Energy2_OnValueChanged(self)
  if (SA_Config_Energy2V) then
    SA_Config_Energy2V:SetText(self:GetValue());
  end
end

function SA_Config_Energy2V_OnTextChanged(self)
  SA_Config_Energy2:SetValue(self:GetText());
end
