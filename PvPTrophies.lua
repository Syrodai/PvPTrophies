local KillEventFrame = CreateFrame("Frame")

-- initializing

local myGUID = UnitGUID("player")
local myFaction = C_CreatureInfo.GetFactionInfo(select(3,UnitRace("player")))["groupTag"]

local function initializeTrophyCase()
	if PvPTrophyCase == nil then PvPTrophyCase = {} end
	if PvPTrophyCase["Human"] == nil then PvPTrophyCase["Human"] = 0 end
	if PvPTrophyCase["Orc"] == nil then PvPTrophyCase["Orc"] = 0 end
	if PvPTrophyCase["Dwarf"] == nil then PvPTrophyCase["Dwarf"] = 0 end
	if PvPTrophyCase["NightElf"] == nil then PvPTrophyCase["NightElf"] = 0 end
	if PvPTrophyCase["Scourge"] == nil then PvPTrophyCase["Scourge"] = 0 end
	if PvPTrophyCase["Tauren"] == nil then PvPTrophyCase["Tauren"] = 0 end
	if PvPTrophyCase["Gnome"] == nil then PvPTrophyCase["Gnome"] = 0 end
	if PvPTrophyCase["Troll"] == nil then PvPTrophyCase["Troll"] = 0 end
	if PvPTrophyCase["BloodElf"] == nil then PvPTrophyCase["BloodElf"] = 0 end
	if PvPTrophyCase["Draenei"] == nil then PvPTrophyCase["Draenei"] = 0 end
end

local function initializeSettings()
	if PvPTrophiesSettings == nil then PvPTrophiesSettings = {} end
	if PvPTrophiesSettings["TrophyCollecting"] == nil then PvPTrophiesSettings["TrophyCollecting"] = true end
	if PvPTrophiesSettings["ShowCollectionInChat"] == nil then PvPTrophiesSettings["ShowCollectionInChat"] = true end
	if PvPTrophiesSettings["ShowCollectionScrolling"] == nil then PvPTrophiesSettings["ShowCollectionScrolling"] = true end
end

--[[if PvPTophiesSettings == nil then
	PvPTrophiesSettings = {}
	PvPTrophiesSettings["TrophyCollecting"] = true
	PvPTrophiesSettings["ShowCollectionInChat"] = true
	PvPTrophiesSettings["ShowCollectionScrolling"] = true
end]]

local raceEnglish = {
	["Human"] = 	{id = 1,	itemName = "Human Eye",				itemTexture = "133884"},
	["Orc"] = 		{id = 2,	itemName = "Orc Teeth",				itemTexture = "133724"},
	["Dwarf"] = 	{id = 3,	itemName = "Dwarf Hand",			itemTexture = "132963"},
	["NightElf"] = 	{id = 4,	itemName = "Night Elf Ear",			itemTexture = "133856"},
	["Scourge"] = 	{id = 5,	itemName = "Forsaken Femur",		itemTexture = "133718"},
	["Tauren"] = 	{id = 6,	itemName = "Tauren Hoof",			itemTexture = "132368"},
	["Gnome"] = 	{id = 7,	itemName = "Tuft of Gnome Hair",	itemTexture = "134323"},
	["Troll"] = 	{id = 8,	itemName = "Troll Tusk",			itemTexture = "133721"},
	["BloodElf"] = 	{id = 10,	itemName = "Blood Elf Ear",			itemTexture = "133854"},
	["Draenei"] = 	{id = 11, 	itemName = "Draenei Horn",			itemTexture = "133722"},
}

-- On Load Event
local AddonLoadEvent = CreateFrame("Frame")
AddonLoadEvent:RegisterEvent("ADDON_LOADED")
AddonLoadEvent:HookScript("OnEvent", function(self, event, addonName)
	if event == "ADDON_LOADED" and addonName == "PvPTrophies" then
		--print("PvPTrophies loaded")
		initializeTrophyCase()
		initializeSettings()
		if PvPTrophiesSettings["TrophyCollecting"] then
			KillEventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			print("PvP Trophy Collecting is currently enabled.")
		else
			print("PvP Trophy Collecting is currently disabled.")
		end
	end
end)

-- Trophy Case Frame
local TrophyCaseFrame = CreateFrame("Frame", "TrophyCaseFrame", UIParent, "BackdropTemplate")
TrophyCaseFrame.width = 210
TrophyCaseFrame.height = 210
TrophyCaseFrame:SetSize(TrophyCaseFrame.width,TrophyCaseFrame.height)
TrophyCaseFrame:SetPoint("CENTER", 0, 0)
TrophyCaseFrame:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
TrophyCaseFrame:SetBackdropColor(0,0,0,0.5)
TrophyCaseFrame:EnableMouse(true)
TrophyCaseFrame:SetMovable(true)
TrophyCaseFrame:RegisterForDrag("LeftButton")
TrophyCaseFrame:SetScript("OnDragStart", TrophyCaseFrame.StartMoving)
TrophyCaseFrame:SetScript("OnDragStop", TrophyCaseFrame.StopMovingOrSizing)
TrophyCaseFrame:SetScript("OnHide", TrophyCaseFrame.StopMovingOrSizing)
TrophyCaseFrame.CloseButton = CreateFrame("Button", nil, TrophyCaseFrame, "UIPanelCloseButton")
TrophyCaseFrame.CloseButton:SetPoint("TOPRIGHT", TrophyCaseFrame, "TOPRIGHT")
TrophyCaseFrame.CloseButton:SetScript("OnClick", function() TrophyCaseFrame:Hide() end)
TrophyCaseFrame.title = TrophyCaseFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
TrophyCaseFrame.title:SetPoint("TOP", 0, -10)
TrophyCaseFrame.title:SetText("Trophy Case")

TrophyCaseFrame.race1 = TrophyCaseFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
TrophyCaseFrame.race2 = TrophyCaseFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
TrophyCaseFrame.race3 = TrophyCaseFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
TrophyCaseFrame.race4 = TrophyCaseFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
TrophyCaseFrame.race5 = TrophyCaseFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")


local function UpdateTrophyCase()
	if myFaction == "Horde" then
		TrophyCaseFrame.race1:SetText("|T" .. raceEnglish["Human"].itemTexture .. ":32|t |cFFFFFFFF[" .. raceEnglish["Human"].itemName .. "]|r x" .. PvPTrophyCase["Human"])
		TrophyCaseFrame.race2:SetText("|T" .. raceEnglish["Dwarf"].itemTexture .. ":32|t |cFFFFFFFF[" .. raceEnglish["Dwarf"].itemName .. "]|r x" .. PvPTrophyCase["Dwarf"])
		TrophyCaseFrame.race3:SetText("|T" .. raceEnglish["NightElf"].itemTexture .. ":32|t |cFFFFFFFF[" .. raceEnglish["NightElf"].itemName .. "]|r x" .. PvPTrophyCase["NightElf"])
		TrophyCaseFrame.race4:SetText("|T" .. raceEnglish["Gnome"].itemTexture .. ":32|t |cFFFFFFFF[" .. raceEnglish["Gnome"].itemName .. "]|r x" .. PvPTrophyCase["Gnome"])
		TrophyCaseFrame.race5:SetText("|T" .. raceEnglish["Draenei"].itemTexture .. ":32|t |cFFFFFFFF[" .. raceEnglish["Draenei"].itemName .. "]|r x" .. PvPTrophyCase["Draenei"])
	elseif myFaction == "Alliance" then
		TrophyCaseFrame.race1:SetText("|T" .. raceEnglish["Orc"].itemTexture .. ":32|t |cFFFFFFFF[" .. raceEnglish["Orc"].itemName .. "]|r x" .. PvPTrophyCase["Orc"])
		TrophyCaseFrame.race2:SetText("|T" .. raceEnglish["Scourge"].itemTexture .. ":32|t |cFFFFFFFF[" .. raceEnglish["Scourge"].itemName .. "]|r x" .. PvPTrophyCase["Scourge"])
		TrophyCaseFrame.race3:SetText("|T" .. raceEnglish["Tauren"].itemTexture .. ":32|t |cFFFFFFFF[" .. raceEnglish["Tauren"].itemName .. "]|r x" .. PvPTrophyCase["Tauren"])
		TrophyCaseFrame.race4:SetText("|T" .. raceEnglish["Troll"].itemTexture .. ":32|t |cFFFFFFFF[" .. raceEnglish["Troll"].itemName .. "]|r x" .. PvPTrophyCase["Troll"])
		TrophyCaseFrame.race5:SetText("|T" .. raceEnglish["BloodElf"].itemTexture .. ":32|t |cFFFFFFFF[" .. raceEnglish["BloodElf"].itemName .. "]|r x" .. PvPTrophyCase["BloodElf"])
	end
	TrophyCaseFrame.race1:SetPoint("TOP", TrophyCaseFrame.race1:GetStringWidth()/2-(TrophyCaseFrame.width/2-10), -30)
	TrophyCaseFrame.race2:SetPoint("TOP", TrophyCaseFrame.race2:GetStringWidth()/2-(TrophyCaseFrame.width/2-10), -65)
	TrophyCaseFrame.race3:SetPoint("TOP", TrophyCaseFrame.race3:GetStringWidth()/2-(TrophyCaseFrame.width/2-10), -100)
	TrophyCaseFrame.race4:SetPoint("TOP", TrophyCaseFrame.race4:GetStringWidth()/2-(TrophyCaseFrame.width/2-10), -135)
	TrophyCaseFrame.race5:SetPoint("TOP", TrophyCaseFrame.race5:GetStringWidth()/2-(TrophyCaseFrame.width/2-10), -170)
end
TrophyCaseFrame:HookScript("OnShow", UpdateTrophyCase)
TrophyCaseFrame:Hide()

-- collection animation
local animationFrame = CreateFrame("Frame", "animationFrame", UIParent)
animationFrame:SetSize(20,100)
animationFrame:SetPoint("CENTER", 250, 25)
animationFrame.text = {}
animationFrame:Show()

function randomKey()
	local str = ""
	for i=1, 16 do 
		str = str .. string.char(math.random(97,122))
	end
	return str
end

local function PlayAnimation(textString)
	local key = randomKey()
	animationFrame.text[key] = animationFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	animationFrame.text[key]:SetTextScale(2)
	animationFrame.text[key]:SetPoint("CENTER", 0, 0)
	animationFrame.text[key]:SetText(textString)
	local animGroup = animationFrame.text[key]:CreateAnimationGroup()
	local animSlide = animGroup:CreateAnimation("Translation")
	animSlide:SetOffset(0, -210)
	animSlide:SetDuration(5.1)
	local animFade = animGroup:CreateAnimation("Alpha")
	animFade:SetFromAlpha(1)
	animFade:SetToAlpha(0)
	animFade:SetDuration(5.1)
	
	animationFrame:Show()
	animGroup:Play()
	C_Timer.After(5, function() animationFrame.text[key]:Hide() end)
	C_Timer.After(5.5, function() animationFrame.text[key]:SetFontObject(nil) end)
end

-- On Killing blow event
KillEventFrame:SetScript("OnEvent", function()
	local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName = CombatLogGetCurrentEventInfo()
	if event == "PARTY_KILL"
	and strfind(destGUID, "Player")
	and ( sourceGUID == myGUID or ( UnitExists("pet") and sourceGUID == UnitGUID("pet") ) ) then
		local classLocal, classEng, raceLocal, raceEng, gender, name, realm = GetPlayerInfoByGUID(destGUID)
		if C_CreatureInfo.GetFactionInfo(raceEnglish[raceEng].id)["groupTag"] ~= myFaction then
			C_Timer.After(1, function()
				local chatString = "You recieve loot: "
				chatString = "|cFF00AA00" .. chatString .. "|r|cFFFFFFFF[" .. raceEnglish[raceEng].itemName .. "]|r|cFF00AA00.|r"
				if PvPTrophiesSettings["ShowCollectionInChat"] then print(chatString) end
				if PvPTrophiesSettings["ShowCollectionScrolling"] then PlayAnimation(chatString) end
				PlaySound(1189, "sound")
				if PvPTrophyCase[raceEng] == nil then PvPTrophyCase[raceEng] = 0 end
				PvPTrophyCase[raceEng] = PvPTrophyCase[raceEng]+1
				if TrophyCaseFrame:IsShown() then UpdateTrophyCase() end
			end)
		end
	end
end)

-- /trophies
local function b2t(bool)
	if bool then return "|cFF00FF00on|r" else return "|cFFFF0000off|r" end
end

local PvPTrophiesCmd = function(option)
	if option == "" then
		if TrophyCaseFrame:IsShown() then
			TrophyCaseFrame:Hide()
		else
			TrophyCaseFrame:Show()
		end
	elseif option == "chat" then
		if PvPTrophiesSettings["ShowCollectionInChat"] then
			PvPTrophiesSettings["ShowCollectionInChat"] = false
			print("Show Trophy Collection In Chat Disabled.")
		else
			PvPTrophiesSettings["ShowCollectionInChat"] = true
			print("Show Trophy Collection In Chat Enabled.")
		end
	elseif option == "scroll" then
		if PvPTrophiesSettings["ShowCollectionScrolling"] then
			PvPTrophiesSettings["ShowCollectionScrolling"] = false
			print("Show Trophy Collection Scrolling Disabled.")
		else
			PvPTrophiesSettings["ShowCollectionScrolling"] = true
			print("Show Trophy Collection Scrolling Enabled.")
		end
	elseif option == "on" or option == "enable" or option == "1" then
		KillEventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		PvPTrophiesSettings["TrophyCollecting"] = true
		print("Trophy Collecting is enabled.")
	elseif option == "off" or option == "disable" or option == "0" then
		KillEventFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		PvPTrophiesSettings["TrophyCollecting"] = false
		print("Trophy Collecting is disabled.")
	else
		print("Usage: /trophies          -- shows trophy case")
		print("       /trophies [on/off] " .. b2t(PvPTrophiesSettings["TrophyCollecting"]) .. " -- enables or disables trophy collection")
		print("       /trophies chat     " .. b2t(PvPTrophiesSettings["ShowCollectionInChat"]) .. " -- toggles chat message when trophy recieved")
		print("       /trophies scroll   " .. b2t(PvPTrophiesSettings["ShowCollectionScrolling"]) .. " -- toggles scrolling text when trophy recieved")
	end
end
SLASH_TROPHIES1 = "/trophies"
SlashCmdList["TROPHIES"] = PvPTrophiesCmd