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
local color = "|cffe6cc80"

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
    else
        print(prefix .. color .. "Help")
        print(prefix .. color .. "All of these functions are macro compatable.")
        print(prefix .. color .. "/AA")
        print(prefix .. color .. "/AmazingAzeroth")
        print(prefix .. color .. "/AA Purge")
        print(prefix .. color .. "/AA ReRoll")
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
    elseif(r == searchForRank) then
        FinishRolling(n, r, 2)
        rerollAgain = false
    elseif(n:lower():find(searchForName)) then
        FinishRolling(n, r, 1)
        rerollAgain = false
    else end
    if (rerollAgain == true) then AmAz:ScheduleTimer(function()RerollEnchantment() end, 2) end
end

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
    elseif(arg:sub(0,4) == "name") then searchForName = arg:sub(6) print(prefix .. color .. "Now searching for random enchant including " .. searchForName .. " in the name.")
    else Help("reroll") end
end

-- Base Command Handling
local function AAHandle(msg, chatbox)
        local _, _, cmd, arg = string.find(msg, "%s?(%w+)%s?(.*)") if(cmd==nil) then else cmd = string.lower(cmd) end if(arg==nil) then else arg = string.lower(arg) end
        if(cmd == "purge") then PurgeHandle(arg)
        elseif(cmd == "reroll") then RerollHandle(arg)
        else Help(arg) end
end

SlashCmdList["AA"] = AAHandle