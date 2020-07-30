AmAz = LibStub("AceAddon-3.0"):NewAddon("AmAz", "AceTimer-3.0")

SLASH_AA1 = "/aa"
SLASH_AA2 = "/amazingazeroth"

local purgeGoldUse = false
local rerollUseGold = false
local searchForRank = 2
local searchForName = "null"
local rerollAgain = false
local rankColor = "|cff1eff00"
local prefix = "|cffff8000AmazingAzeroth: "
local eprefix = "|cffff8000AmazingAzeroth: "
local color = "|cffe6cc80"
local searchforhigher = true
local version = "132"
local didReminder = false

local function Help(arg)
    if(arg == "purge") then
        print(prefix .. color .. "Purge Help")
        print(prefix .. color .. "/AA Purge Ability")
        print(prefix .. color .. "/AA Purge Talent")
        print(prefix .. color .. "/AA Purge Both")
        print(prefix .. color .. "/AA Purge UseGold (True or False)")
    elseif(arg == "reroll") then
        print(prefix .. color .. "ReRoll Help")
        print(prefix .. color .. "/AA ReRoll Name (Enchant Name)")
        print(prefix .. color .. "/AA ReRoll Rarity (Rare, Epic, or Legendary)")
        print(prefix .. color .. "/AA ReRoll UseGold (True or False)")
        print(prefix .. color .. "/AA ReRoll Start")
        print(prefix .. color .. "/AA ReRoll Clear")
        print(prefix .. color .. "/AA ReRoll HigherRarity (True or False)")
    else
        print(prefix .. color .. "Help")
        print(prefix .. color .. "All of these functions are macro compatable.")
        print(prefix .. color .. "/AA")
        print(prefix .. color .. "/AA Purge")
        print(prefix .. color .. "/AA ReRoll")
        print(prefix .. color .. "/AA ItemLevel")
        print(prefix .. color .. "/AA Version")
    end
end

local function FinishRolling(n, r, t)
    if(r == 3) then rarity = "Rare" elseif(r == 4) then rarity = "Epic" elseif(r==5) then rarity = "Legendary" end
    if(t == 1) then print(prefix .. color .."Finished Auto Roll After Finding " .. rankColor .. n .. color .. ".") end
    if(t == 2) then print(prefix .. color .. "Finished Auto Roll After Finding " .. rankColor .. n .. color .." rarity of " .. rankColor .. rarity .. color .. ".") end
end

local function RerollEnchantment()
    count = GetItemCount(98462)
    if(rerollUseGold == false and count > 0) then EnchantReRollFrameRollButton:GetScript("OnMouseDown")(EnchantReRollFrameRollButton) end
    if(rerollUseGold == false and count == 0) then print(prefix .. color .. "Unable to reroll again. Not enough Mystic Runes.") rerollAgain = false end
    if(rerollUseGold == true) then EnchantReRollFrameRollButton:GetScript("OnMouseDown")(EnchantReRollFrameRollButton) end
end

local function AutomateRoll(n, r)
    if(searchForRank == 2) then if(searchForName == "null") then
        rerollAgain = false end
    elseif(r >= searchForRank) then
        if(searchforhigher == false) then
            if(searchForRank == r) then
                FinishRolling(n, r, 2)
                rerollAgain = false end
        else
            FinishRolling(n, r, 2)
            rerollAgain = false end
    elseif(n:lower():find(searchForName)) then
        FinishRolling(n, r, 1)
        rerollAgain = false
    else end
    if (rerollAgain == true) then AmAz:ScheduleTimer(function()RerollEnchantment() end, 2) end
end

local vRequest = CreateFrame("Frame", "AAVSend", WorldFrame);
vRequest:RegisterEvent("PLAYER_ENTERING_WORLD");
vRequest:SetScript("OnEvent", function()
    SendAddonMessage("AARequest", "getVersion", "GUILD")
    SendAddonMessage("AARequest", "getVersion", "PARTY")
    SendAddonMessage("AARequest", "getVersion", "RAID")
end)

local vCheck = CreateFrame("Frame", "AAVCheck", WorldFrame);
vCheck:RegisterEvent("CHAT_MSG_ADDON");
vCheck:SetScript("OnEvent", function(s,e,prefix,msg,form,player)
    if prefix and not prefix:find("AAzeroth") then return else
        if (tonumber(msg) > tonumber(version)) then
            if(form == "WHISPER") then
                if(didReminder == false) then
                    print(eprefix .. color .. "Found Newer Version " .. msg .. " you have " .. version .. ".")
                    didReminder = true
                end
            end
        end
    end
end)

local AARequest = CreateFrame("Frame", "AARequest", WorldFrame);
AARequest:RegisterEvent("CHAT_MSG_ADDON");
AARequest:SetScript("OnEvent", function(s,e,prefix,msg,form,player)
    if prefix and not prefix:find("AARequest") then return else
        if(msg == "getVersion") then
            SendAddonMessage("AAzeroth", version, "WHISPER", player)
        end
    end
end)

local enchantHandlerFrame = CreateFrame("Frame", "AAEnchantFrame", WorldFrame);
enchantHandlerFrame:RegisterEvent("CHAT_MSG_ADDON");
enchantHandlerFrame:SetScript("OnEvent", function(s,e,prefix,msg,form,player)
    if prefix and not prefix:find("SAIO") then return else
        if(msg:len() >= 47) then if(msg:sub(24,48) == "EnchantReRollMain_Reforge") then spellID = msg:sub(51, msg:len()-2)
        name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spellID) -- ranks: 2 = uncommon, 3 = rare, 4 = epic, 5 = legendary
        if(rank == "Rank 2") then rankNum = 2 rankColor = "|cff1eff00" elseif(rank == "Rank 3") then rankNum = 3 rankColor = "|cff0070dd" elseif(rank == "Rank 4") then rankNum = 4 rankColor = "|cffa335ee" elseif(rank == "Rank 5") then rankNum = 5 rankColor = "|cffff8000" end
        AutomateRoll(name, rankNum)
        end end
    end
end)

-- Purge Management
local function PurgeTalentPoints()
    count = GetItemCount(383083)
    if(purgeGoldUse) then ResetButton_yesTalents:GetScript("OnMouseUp")(ResetButton_yesTalents)
    else if(count > 0) then ResetButton_yesTalents:GetScript("OnMouseUp")(ResetButton_yesTalents) else print(prefix .. color .. "Unable to purge talents again. Not enough Talent Purges.") end end
end

local function PurgeAbilityPoints()
    count = GetItemCount(383082)
    if(purgeGoldUse) then ResetButton_yes:GetScript("OnMouseUp")(ResetButton_yes)
    else if(count > 0) then ResetButton_yes:GetScript("OnMouseUp")(ResetButton_yes) else print(prefix .. color .. "Unable to purge abilities again. Not enough Ability Purges.") end end
end

-- Sub Command Handling
local function PurgeHandle(arg)
    if(arg == "ability") then PurgeAbilityPoints()
    elseif(arg == "talent") then PurgeTalentPoints()
    elseif(arg == "both") then PurgeAbilityPoints() PurgeTalentPoints()
    elseif(arg == "usegold true") then purgeGoldUse = true print(prefix .. color .. "Now using gold for purges.")
    elseif(arg == "usegold false") then purgeGoldUse = false print(prefix .. color .. "No longer using gold for purges.")
    else Help("purge") end
end

local function RerollHandle(arg)
    if(arg == "rarity rare") then searchForRank = 3 print(prefix .. color .. "Reroll rarity set to " .. "|cff0070ddRare")
    elseif(arg == "rarity epic") then searchForRank = 4 print(prefix .. color .. "Reroll rarity set to " .. "|cffa335eeEpic")
    elseif(arg == "rarity legendary") then searchForRank = 5 print(prefix .. color .. "Reroll rarity set to " .. "|cffff8000Legendary")
    elseif(arg == "usegold true") then rerollUseGold = true print(prefix .. color .. "Now using gold for rerolls.")
    elseif(arg == "usegold false") then rerollUseGold = false print(prefix .. color .. "No longer using gold for rerolls.")
    elseif(arg == "start") then rerollAgain = true RerollEnchantment()
    elseif(arg == "clear") then searchForName = "null" searchForRank = 2 print(prefix .. color .. "No longer searching for name or rarity previously defined.")
    elseif(arg == "higherrarity true") then searchforhigher = true print(prefix .. color .. "Now searching for any rarity above defined rarity.")
    elseif(arg == "higherrarity false") then searchforhigher = false print(prefix .. color .. "Now searching for exactly the defined rarity.")
    elseif(arg:sub(0,4) == "name") then searchForName = arg:sub(6) print(prefix .. color .. "Now searching for random enchant including " .. searchForName .. " in the name.")
    else Help("reroll") end
end

local function ItemlevelHandle()
    if(UnitExists("target") and CanInspect("target")) then InspectUnit("target")
        local t,c,u,k=0,0,UnitExists("target")and"target"or"player"for i=1,18 do k=GetInventoryItemLink(u,i)if i~=4 and k then t=t+select(4,GetItemInfo(k))c=c+1 end end c=c>0 and print(t/c)
        InspectFrame:Hide()
    else InspectUnit("player")
        local t,c,u,k=0,0,UnitExists("target")and"target"or"player"for i=1,18 do k=GetInventoryItemLink(u,i)if i~=4 and k then t=t+select(4,GetItemInfo(k))c=c+1 end end c=c>0 and print(t/c)
        InspectFrame:Hide()
    end
end

-- Base Command Handling
local function AAHandle(msg, chatbox)
        local _, _, cmd, arg = string.find(msg, "%s?(%w+)%s?(.*)") if(cmd==nil) then else cmd = string.lower(cmd) end if(arg==nil) then else arg = string.lower(arg) end
        if(cmd == "purge") then PurgeHandle(arg)
        elseif(cmd == "reroll") then RerollHandle(arg)
        elseif(cmd == "version") then 
            print(prefix .. color .. "Sent version request. If you don't see any updates within 10 seconds you most likely have the newest version.")
            didReminder = false
            SendAddonMessage("AARequest", "getVersion", "GUILD")
            SendAddonMessage("AARequest", "getVersion", "PARTY")
            SendAddonMessage("AARequest", "getVersion", "RAID")
        elseif(cmd == "itemlevel") then ItemlevelHandle()
        else Help(arg) end
end

SlashCmdList["AA"] = AAHandle