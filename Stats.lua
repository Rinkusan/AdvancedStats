-- define slash command
SLASH_STATS1 = "/stats"
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
--define Resistance Calculations
local function FireRes()
	base, total, bonus, minus = UnitResistance("player",2)
	return total;
end
local function NatureRes()
	base, total, bonus, minus = UnitResistance("player",3)
	return total;
end
local function FrostRes()
	base, total, bonus, minus = UnitResistance("player",4)
	return total;
end
local function ShadowRes()
	base, total, bonus, minus = UnitResistance("player",5)
	return total;
end
local function ArcaneRes()
	base, total, bonus, minus = UnitResistance("player",6)
	return total;
end
-- Function to calculate Bear Tankiness Value
local function Tankiness()
	return math.floor((GetDodgeChance("player")*16.67) + (Armor()*0.23) + Stam() + (Agi()*0.92) + (Defense()*2));
end
-- Function to calculate Bear Threat Value
local function Threat()
	return math.floor(Str() + (Agi()*0.45) + (AP()*0.5) + (GetCritChance("player")*8.97) + (GetHitModifier("player")*6.69) + (GetHaste("player")*9.01))
end
-- Define UnitClass
local function PlayerClass()
	localizedClass, englishClass, classIndex = UnitClass("player");
	return englishClass;
end
-- Define Functions for Different Druid Form Information
local function Bear()
	return "Hit Chance: " .. GetHitModifier("player").."\n".."Crit Chance: " .. math.floor(GetCritChance()+0.5).."\n".."Dodge Chance: " .. math.floor(GetDodgeChance()+0.5).."\n".."Attack Power: " .. AP().."\n".."Armor Rating: " .. Armor().."\n".."Defense Rating: " .. Defense().."\n".."Tankiness Value: " .. Tankiness().."\n".."Threat Value: " .. Threat();
end
local function Druid()
	return "Bonus Spell Damage: " .. GetSpellBonusDamage(7).."\n".."Bonus Healing: " .. GetSpellBonusHealing().."\n".."Spell Crit Chance: " .. math.floor(GetSpellCritChance()+0.5).."\n".."Spell Hit Modifier: " .. GetSpellHitModifier().."\n".."Fire Resistance: " .. FireRes().."\n".."Frost Resistance: " .. FrostRes().."\n".."Nature Resistance: " .. NatureRes().."\n".."Shadow Resistance: " .. ShadowRes().."\n".."Arcane Resistance: " .. ArcaneRes();
end
local Travel = [[I'm in Travel Form]]
local function Cat()
	return "Hit Chance: " .. GetHitModifier("player").."\n".."Crit Chance: " .. math.floor(GetCritChance()+0.5).."\n".."Attack Power: " .. AP();
end
local function Boomkin()
	return "Bonus Spell Damage: " .. GetSpellBonusDamage(7).."\n".."Bonus Healing: " .. GetSpellBonusHealing().."\n".."Spell Crit Chance: " .. math.floor(GetSpellCritChance()+0.5).."\n".."Spell Hit Modifier: " .. GetSpellHitModifier().."\n".."Fire Resistance: " .. FireRes().."\n".."Frost Resistance: " .. FrostRes().."\n".."Nature Resistance: " .. NatureRes().."\n".."Shadow Resistance: " .. ShadowRes().."\n".."Arcane Resistance: " .. ArcaneRes();
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
	frame:RegisterUnitEvent("UNIT_ATTACK_POWER", "player")
	frame:RegisterUnitEvent("UNIT_ATTACK_SPEED", "player")
	frame:RegisterUnitEvent("UNIT_DAMAGE", "player")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterUnitEvent("UNIT_RESISTANCES", "player")
	frame:RegisterEvent("PLAYER_DAMAGE_DONE_MODS")
	frame:Hide()
-- define Text in Frame
local function Display(message)
	frame.text:SetText(message)
end
-- define Auto Update in Frame
local function AutoUpdate()
	if PlayerClass() == "DRUID"
		then
			if GetShapeshiftFormID() == 8 then Display(Bear())
			elseif GetShapeshiftFormID() == 1 then Display(Cat())
			elseif GetShapeshiftFormID() == 3 then Display(Travel)
			elseif GetShapeshiftFormID() == 5 then Display(Bear())
			elseif GetShapeshiftFormID() == 31 then Display(Boomkin())
			else Display(Druid())
			end
		else Display(Druid())
	end
--	Display("Hit Chance: " .. GetHitModifier("player").."\n".."Crit Chance: " .. math.floor(GetCritChance()+0.5).."\n".."Dodge Chance: " .. math.floor(GetDodgeChance()+0.5).."\n".."Attack Power: " .. AP().."\n".."Armor Rating: " .. Armor().."\n".."Defense Rating: " .. Defense().."\n".."Tankiness Value: " .. Tankiness().."\n".."Threat Value: " .. Threat());
end
-- Set Script to run AutoUpdate on Event
frame:SetScript("OnEvent", AutoUpdate)
-- Set Slash Command Function
SlashCmdList["STATS"] = function()
	frame:SetShown(not frame:IsVisible());
	if frame:IsVisible() then AutoUpdate() end;
end