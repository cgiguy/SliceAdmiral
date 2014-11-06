-- Author      : Administrator
-- Create Date : 9/13/2008 10:16:36 AM
SA_BarTextures = {
  ["Aluminum"] = "Interface\\AddOns\\SliceAdmiral\\Images\\Aluminium.tga",
  ["BantoBar"] = "Interface\\AddOns\\SliceAdmiral\\Images\\BantoBar.tga",
  ["Gloss"] = "Interface\\AddOns\\SliceAdmiral\\Images\\Gloss.tga",
  ["HealBot"] = "Interface\\AddOns\\SliceAdmiral\\Images\\HealBot.tga",
  ["LiteStep"] = "Interface\\AddOns\\SliceAdmiral\\Images\\LiteStep.tga",
  ["Runes"] = "Interface\\AddOns\\SliceAdmiral\\Images\\Runes.tga",
  ["Smooth"] = "Interface\\AddOns\\SliceAdmiral\\Images\\Smooth.tga",
};
SA_Text = {}
for k,v in pairs(SA_BarTextures) do
 SA_Text[v]=k
end
SA_Sounds = {
  ["Price is WRONG"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\PriceIsWrong.ogg",
  ["Waaaah"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\Old Trumpet A 01.ogg",
  ["BassDrum"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\6OP00084.ogg",
  ["Tambourine"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\tambourine.ogg",
  ["Cowbell"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\cowtown.ogg",
  ["SliceClick"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\FXHit15.ogg",
  ["BoomBoomClap"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\HoleA.ogg",
  ["Marching Band"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\OldDrums2.ogg",
  ["High Hat 4"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\perc09_HH.ogg",
  ["BoomBoomThak"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\RawB.ogg",
  ["Arpeggiator C2"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\Arp31-C2.ogg",
  ["Arpeggiator C3"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\Arp31-C3.ogg",
  ["Arpeggiator C4"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\Arp31-C4.ogg",
  ["ScratchShot"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\ScratchShot.ogg",
  ["StunningHit"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\StunningHit.ogg",
  ["DNBLoop4"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\DNBLoop4.ogg",
  ["DNBLoop2"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\DNBLoop2.ogg",
  ["Scratch4"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\Scratch4.ogg",
  ["You Spin Me"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\youspin.ogg",
  ["What's the Deal?"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\whats-the-deal.ogg",
  ["ClubBeatJ"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\ClubBeatJ.ogg",
  ["Growl"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\growl.ogg",
  ["OH YEAH"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\OH-YEAH.ogg",
  ["Shaker"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\shaker.ogg",
  ["Pop"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\pop.ogg",
  ["Drum Rattle"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\drumrattle.ogg",
  ["Ping"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\pingit.ogg",
  ["Switch On/Off"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\switch-on-off.ogg",
  ["Eth Perc Short"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\perc-short.ogg",
  ["Eth Perc Long"] = "Interface\\AddOns\\SliceAdmiral\\Audio\\perc-long.ogg",
  ["None"] = "",
};
SA_ASounds = {};
for k,v in pairs(SA_Sounds) do
 SA_ASounds[v]=k
end

SA_SoundMenu = { --these are what populate the drop down menus ?
  ["Fail"] = { "None", "Waaaah", "BassDrum", "Price is WRONG", "Growl", "Drum Rattle", "Shaker"  },
  ["Tick"] = { "None", "Ping", "Drum Rattle", "Pop", "Shaker", "Tambourine",  "Growl" },
  ["Apply"] = { "None", "Drum Rattle", "SliceClick", "BoomBoomClap", "Marching Band", "BoomBoomThak",  "You Spin Me"},
  ["Energy"] = { "None","Switch On/Off", "Ping", "Drum Rattle", "Pop", "Shaker",  "DNBLoop2" },
}
