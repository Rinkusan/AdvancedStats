-- define slash command to Trigger Stat Tracking
SLASH_STATS1 = "/stats"
SLASH_HIDE1 = "/statshide"
-- define Attack Power calculation
local function AP()
	base, posBuff, negBuff = UnitAttackPower("player");
	return base + posBuff + negBuff;
end
-- define Stamina calculation
local function Stam()
	base, stat, posBuff, negBuff = UnitStat("player",3);
	return stat;
end
-- define Strength calculation
local function Str()
	base, stat, posBuff, negBuff = UnitStat("player",1);
	return stat;
end
-- define Agility calculation
local function Agi()
	base, stat, posBuff, negBuff = UnitStat("player",2);
	return stat;
end
-- define Defense calculation
local function Defense()
	skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(15);
	return skillRank + numTempPoints + skillModifier;
end
-- define Armor calculation
local function Armor()
	base, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player");
	return armor;
end
-- Function to calculate Tankiness Value
local function Tankiness()
	return math.floor((GetDodgeChance("player")*16.67) + (Armor()*0.23) + Stam() + (Agi()*0.92) + (Defense()*2));
end
-- Function to calculate Threat Value
local function Threat()
	return math.floor(Str() + (Agi()*0.45) + (AP()*0.5) + (GetCritChance("player")*8.97) + (GetHitModifier("player")*6.69) + (GetHaste("player")*9.01))
end
-- define frame and set attributes
local frame = CreateFrame("Frame", "MyFrame", UIParent)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:SetSize(150, 70) 
	frame:SetPoint("CENTER")
	frame.texture = frame:CreateTexture("Texture","BACKGROUND",UIParent)
	frame.texture:SetAllPoints()
	frame.text = frame:CreateFontString(nil,"ARTWORK",UIParent)
	frame.text:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE")
	frame.text:SetPoint("Left",0,0)
	frame.text:SetJustifyH("Left")
	frame:RegisterUnitEvent("UNIT_STATS", "player")
	frame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	frame:RegisterUnitEvent("UNIT_AURA", "player")
	frame:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
	frame:Hide()
-- define Text in Frame
local function Display(message)
	frame:Show()
	frame.text:SetText(message)
end
-- define Auto Update in Frame
local function AutoUpdate()
	Display("Hit Chance: " .. GetHitModifier("player").."\n".."Crit Chance: " .. math.floor(GetCritChance()+0.5).."\n".."Dodge Chance: " .. math.floor(GetDodgeChance()+0.5).."\n".."Attack Power: " .. AP().."\n".."Armor Rating: " .. Armor().."\n".."Defense Rating: " .. Defense().."\n".."Tankiness Value: " .. Tankiness().."\n".."Threat Value: " .. Threat());
end
-- Set Script to run AutoUpdate on Event
frame:SetScript("OnEvent", AutoUpdate)
-- define Addon Command for Stats
SlashCmdList["STATS"] = function()
	AutoUpdate()
end
-- define Addon Command for Hide/Unregister
SlashCmdList["HIDE"] = function()
	frame:Hide()
end

