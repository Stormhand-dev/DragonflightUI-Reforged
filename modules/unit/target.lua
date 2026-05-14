DFRL:NewDefaults("Target", {
    enabled = {true},
    targetDarkMode = {0, "slider", {0, 1}, nil, "Appearance", 1, "Adjust dark mode intensity", nil, nil},
    targetColor = {{1, 1, 1}, "colour", nil, nil, "Appearance", 2, "Change target color", nil, nil},
    frameScale = {1, "slider", {0.7, 1.3}, nil, "Appearance", 3, "Adjust frame size", nil, nil},
    textShow = {true, "checkbox", nil, nil, "Text", 4, "Show health and mana text", nil, nil},
    textMaxShow = {true, "checkbox", nil, "textShow", "Text", 5, "Show max health and mana text", nil, nil},
    noPercent = {true, "checkbox", nil, "textShow", "Text", 6, "Show only current values without percentages", nil, nil},
    useShaguHealth = {false, "checkbox", nil, "textShow", "Text", 7, "Use ShaguTweaks real health values when available", nil, nil},
    textColoringHealth = {false, "checkbox", nil, "textShow", "Text", 8, "Color text based on health percentage", nil, nil},
    textColoringResource = {false, "checkbox", nil, "textShow", "Text", 9, "Color text based on resource (mana/rage/energy) percentage", nil, nil},
    frameFont = {"FRIZQT__.TTF", "dropdown", {
        "FRIZQT__.TTF",
        "Expressway",
        "Homespun",
        "Hooge",
        "Myriad-Pro",
        "Prototype",
        "PT-Sans-Narrow-Bold",
        "PT-Sans-Narrow-Regular",
        "RobotoMono",
        "BigNoodleTitling",
        "Continuum",
        "DieDieDie"
    }, nil, "Text", 10, "Change the font used for the targetframe", nil, nil},
    healthSize = {15, "slider", {8, 20}, "textShow", "Text", 11, "Health text font size", nil, nil},
    manaSize = {9, "slider", {8, 20}, "textShow", "Text", 12, "Mana text font size", nil, nil},
    nameSize = {9, "slider", {6, 16}, nil, "Text", 13, "Target name text font size", nil, nil},
    levelSize = {9, "slider", {6, 16}, nil, "Text", 14, "Target level text font size", nil, nil},
    colorReaction = {true, "checkbox", nil, nil, "Health Bar", 15, "Color health bar based on target reaction", nil, nil},
    colorClass = {false, "checkbox", nil, nil, "Health Bar", 16, "Color health bar based on target class", nil, nil},
    enablePulse = {true, "checkbox", nil, nil, "Health Bar", 17, "Enable pulse animation on bars", nil, nil},
    pulseColor = {{1, 1, 1}, "colour", nil, "enablePulse", "Health Bar", 18, "Color for pulse animation", nil, nil},
    enableCutout = {true, "checkbox", nil, nil, "Health Bar", 19, "Enable cutout animation on bars", nil, nil},
    cutoutColor = {{1, 0, 0}, "colour", nil, "enableCutout", "Health Bar", 20, "Color for damage cutout effect", nil, nil},
})

DFRL:NewMod("Target", 1, function()
    local configCache = {
        noPercent = nil,
        textMaxShow = nil,
        textColoringHealth = nil,
        textColoringResource = nil,
        lastUpdate = 0
    }

    local Setup = {
        texpath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\tex\\unitframes\\",
        texpath2 = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\tex\\ui\\",
        fontpath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\",

        hideFrame = nil,
        healthPercentText = nil,

        combatOverlay = nil,
        combatOverlayTex = nil,

        texts = {
            healthPercent = nil,
            healthValue = nil,
            healthPercentShow = true,
            manaPercent = nil,
            manaValue = nil,
            manaPercentShow = true,
            config = {
                font = "Fonts\\FRIZQT__.TTF",
                healthFontSize = 12,
                manaFontSize = 9,
                nameFontSize = 9,
                levelFontSize = 9,
                outline = "OUTLINE",
                nameColor = {1, .82, 0},
                levelColor = {1, .82, 0},
                healthColor = {1, 1, 1},
                manaColor = {1, 1, 1},
            }
        },

        barColorState = {
            colorReaction = false,
            colorClass = false,
        }
    }

    function Setup:GetTargetHealth()
        if DFRL:GetTempDB("Target", "useShaguHealth") and ShaguTweaks and ShaguTweaks.libhealth and ShaguTweaks.libhealth.GetUnitHealth then
            local health, maxHealth = ShaguTweaks.libhealth:GetUnitHealth("target")
            if health and maxHealth then
                return health, maxHealth
            end
        end

        return UnitHealth("target"), UnitHealthMax("target")
    end

    function Setup:KillBlizz()
        TargetFrameHealthBar:SetScript("OnEnter", nil)
        TargetFrameHealthBar:SetScript("OnLeave", nil)
        TargetFrameNameBackground:SetTexture(nil)
    end

    function Setup:HealthBar()
        TargetFrameHealthBar:Hide()
        self.healthBar = CreateStatusBar(TargetFrame, 129, 30)
        self.healthBar:SetPoint('TOPRIGHT', TargetFrame, 'TOPRIGHT', -100, -29)
        self.healthBar:SetFrameLevel(TargetFrame:GetFrameLevel())
        self.healthBar:SetTextures(self.texpath .. 'healthDF2.tga')
        if UnitExists('target') then
            self.healthBar.max = UnitHealthMax('target')
            self.healthBar:SetValue(UnitHealth('target'))
        end
        local cutoutColor = DFRL:GetTempDB('Target', 'cutoutColor')
        local pulseColor = DFRL:GetTempDB('Target', 'pulseColor')
        self.healthBar:SetCutoutColor(cutoutColor[1], cutoutColor[2], cutoutColor[3], 1)
        self.healthBar:SetPulseColor(pulseColor[1], pulseColor[2], pulseColor[3], 1)
    end

    function Setup:HealthBarText()
        local cfg = self.texts.config

        self.texts.healthTextFrame = CreateFrame("Frame", nil, TargetFrame)
        self.texts.healthTextFrame:SetAllPoints(self.healthBar)
        self.texts.healthTextFrame:SetFrameStrata(TargetFrame:GetFrameStrata())
        self.texts.healthTextFrame:SetFrameLevel(TargetFrame:GetFrameLevel() + 2)

        self.texts.healthPercent = self.texts.healthTextFrame:CreateFontString(nil)
        self.texts.healthPercent:SetFont(cfg.font, cfg.healthFontSize, cfg.outline)
        self.texts.healthPercent:SetPoint('LEFT', self.healthBar, 'LEFT', 5, 0)

        self.texts.healthValue = self.texts.healthTextFrame:CreateFontString(nil)
        self.texts.healthValue:SetFont(cfg.font, cfg.healthFontSize, cfg.outline)
        self.texts.healthValue:SetPoint('RIGHT', self.healthBar, 'RIGHT', -5, 0)

        if GetCVar("statusBarText") == "1" then
            if TargetHPText then
                TargetHPText:Hide()
            end
            if TargetHPPercText then
                TargetHPPercText:Hide()
            end
        end
    end

    function Setup:ManaBar()
        TargetFrameManaBar:Hide()
        self.manaBar = CreateStatusBar(TargetFrame, 129, 12)
        self.manaBar:SetPoint('TOPRIGHT', TargetFrame, 'TOPRIGHT', -100, -53)
        self.manaBar:SetFrameLevel(TargetFrame:GetFrameLevel())
        self.manaBar:SetTextures(self.texpath .. 'UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana-Status.blp')
        if UnitExists('target') then
            local maxMana = UnitManaMax('target')
            if maxMana > 0 then
                self.manaBar:Show()
                self.manaBar.max = maxMana
                local mana = UnitMana('target')
                self.manaBar:SetValue(mana > 0 and mana or 0.001)
                local powerType = UnitPowerType('target')
                if powerType == 0 then
                    self.manaBar:SetFillColor(0, 0, 1, 1)
                elseif powerType == 1 then
                    self.manaBar:SetFillColor(1, 0, 0, 1)
                elseif powerType == 2 then
                    self.manaBar:SetFillColor(1, 1, 0, 1)
                elseif powerType == 3 then
                    self.manaBar:SetFillColor(1, 1, 0, 1)
                end
            else
                self.manaBar:Hide()
            end
        end
        local cutoutColor = DFRL:GetTempDB('Target', 'cutoutColor')
        local pulseColor = DFRL:GetTempDB('Target', 'pulseColor')
        self.manaBar:SetCutoutColor(cutoutColor[1], cutoutColor[2], cutoutColor[3], 1)
        self.manaBar:SetPulseColor(pulseColor[1], pulseColor[2], pulseColor[3], 1)
    end

    function Setup:ManaBarText()
        local cfg = self.texts.config

        self.texts.manaTextFrame = CreateFrame("Frame", nil, TargetFrame)
        self.texts.manaTextFrame:SetAllPoints(self.manaBar)
        self.texts.manaTextFrame:SetFrameStrata(TargetFrame:GetFrameStrata())
        self.texts.manaTextFrame:SetFrameLevel(TargetFrame:GetFrameLevel() + 2)

        self.texts.manaPercent = self.texts.manaTextFrame:CreateFontString(nil)
        self.texts.manaPercent:SetFont(cfg.font, cfg.manaFontSize, cfg.outline)
        self.texts.manaPercent:SetPoint('LEFT', self.manaBar, 'LEFT', 5, 0)

        self.texts.manaValue = self.texts.manaTextFrame:CreateFontString(nil)
        self.texts.manaValue:SetFont(cfg.font, cfg.manaFontSize, cfg.outline)
        self.texts.manaValue:SetPoint('RIGHT', self.manaBar, 'RIGHT', -12, 0)
    end

    function Setup:FrameTextures()
        TargetFrameBackground:SetWidth(256)
        TargetFrameBackground:SetHeight(128)
        TargetFrameBackground:SetPoint("TOPRIGHT", TargetFrame, "TOPRIGHT", 0, 0)
        TargetFrameBackground:SetTexture(self.texpath .. "UI-TargetingFrameDF1-Background.blp")
        if TargetFrameBackground.SetFrameLevel then
            TargetFrameBackground:SetFrameLevel(TargetFrame:GetFrameLevel() - 2)
        end
    end

    function Setup:Portrait()
        TargetFrame.portrait:SetHeight(61)
        TargetFrame.portrait:SetWidth(61)
    end

    function Setup:NameText()
        local cfg = self.texts.config
        TargetFrame.name:ClearAllPoints()
        TargetFrame.name:SetPoint("CENTER", TargetFrame, "CENTER", -40, 25)
        TargetFrame.name:SetJustifyH("RIGHT")
        TargetFrame.name:SetFont(cfg.font, cfg.nameFontSize, "")
        TargetFrame.name:SetTextColor(unpack(cfg.nameColor))
    end

    function Setup:LevelText()
        local cfg = self.texts.config
        TargetLevelText:ClearAllPoints()
        TargetLevelText:SetPoint("CENTER", TargetFrame, "CENTER", -102, 25)
        TargetLevelText:SetFont(cfg.font, cfg.levelFontSize, "")
        TargetLevelText:SetTextColor(unpack(cfg.levelColor))
    end

    function Setup:UpdateTexts()
        if not UnitExists("target") then return end

        local health, maxHealth = self:GetTargetHealth()
        local healthPercent = maxHealth > 0 and health / maxHealth or 0
        local healthPercentInt = math.floor(healthPercent * 100)

        local mana = UnitMana("target")
        local maxMana = UnitManaMax("target")
        local manaPercent = maxMana > 0 and mana / maxMana or 0
        local manaPercentInt = math.floor(manaPercent * 100)

        local now = GetTime()
        if not configCache.noPercent or not configCache.textColoringHealth or not configCache.textColoringResource or (now - configCache.lastUpdate > 1) then
            configCache.noPercent = DFRL:GetTempDB("Target", "noPercent")
            configCache.textColoringHealth = DFRL:GetTempDB("Target", "textColoringHealth")
            configCache.textColoringResource = DFRL:GetTempDB("Target", "textColoringResource")
            configCache.lastUpdate = now
        end

        local noPercentEnabled = configCache.noPercent
        local coloringHealthEnabled = configCache.textColoringHealth
        local coloringResourceEnabled = configCache.textColoringResource

        local isDead = UnitIsDead("target")

        if noPercentEnabled then
            self.texts.healthPercent:SetText("")
            if isDead then
                self.texts.healthValue:SetText("")
            else
                self.texts.healthValue:SetText(health .. (configCache.textMaxShow and "/" .. maxHealth or ""))
            end
            self.texts.healthValue:ClearAllPoints()
            self.texts.healthValue:SetPoint('CENTER', self.healthBar, 'CENTER', 0, 0)

            self.texts.manaPercent:SetText("")
            if maxMana > 0 then
                self.texts.manaValue:SetText(mana .. (configCache.textMaxShow and "/" .. maxMana or ""))
                self.texts.manaValue:ClearAllPoints()
                self.texts.manaValue:SetPoint('CENTER', self.manaBar, 'CENTER', -0, 0)
            else
                self.texts.manaValue:SetText("")
            end
        else
            if isDead then
                self.texts.healthPercent:SetText("")
                self.texts.healthValue:SetText("")
            else
                self.texts.healthPercent:SetText(healthPercentInt .. "%")
                self.texts.healthValue:SetText(health .. (configCache.textMaxShow and "/" .. maxHealth or ""))
            end
            self.texts.healthValue:ClearAllPoints()
            self.texts.healthValue:SetPoint('RIGHT', self.healthBar, 'RIGHT', -0, 0)

            if maxMana > 0 then
                self.texts.manaPercent:SetText(manaPercentInt .. "%")
                self.texts.manaValue:SetText(mana .. (configCache.textMaxShow and "/" .. maxMana or ""))
                self.texts.manaValue:ClearAllPoints()
                self.texts.manaValue:SetPoint('RIGHT', self.manaBar, 'RIGHT', -0, 0)
            else
                self.texts.manaPercent:SetText("")
                self.texts.manaValue:SetText("")
            end
        end

        local r, g, b

        if coloringHealthEnabled then
            r = 1
            g = healthPercent
            b = healthPercent
            self.texts.healthPercent:SetTextColor(r, g, b)
            self.texts.healthValue:SetTextColor(r, g, b)
        else
            self.texts.healthPercent:SetTextColor(1, 1, 1)
            self.texts.healthValue:SetTextColor(1, 1, 1)
        end

        if coloringResourceEnabled then
            r = 1
            g = manaPercent
            b = manaPercent
            self.texts.manaPercent:SetTextColor(r, g, b)
            self.texts.manaValue:SetTextColor(r, g, b)
        else
            self.texts.manaPercent:SetTextColor(1, 1, 1)
            self.texts.manaValue:SetTextColor(1, 1, 1)
        end
    end

    function Setup:HookDeadText()
        local originalCheckDead = _G.TargetFrame_CheckDead
        _G.TargetFrame_CheckDead = function()
            originalCheckDead()
            if TargetDeadText then
                TargetDeadText:SetFont(Setup.texts.config.font, 12, 'OUTLINE')
                TargetDeadText:SetTextColor(0.7, 0.7, 0.7)
                TargetDeadText:ClearAllPoints()
                TargetDeadText:SetPoint('CENTER', Setup.healthBar, 'CENTER', 0, 0)
            end
        end
    end

    function Setup:HookClassification()
        function _G.TargetFrame_CheckClassification()
            local classification = UnitClassification('target')
            if (classification == 'worldboss') then
                TargetFrameTexture:SetTexture(Setup.texpath .. 'UI-TargetingFrame-Boss.blp')
            elseif (classification == 'rareelite') then
                TargetFrameTexture:SetTexture(Setup.texpath .. 'UI-TargetingFrame-RareElite.blp')
            elseif (classification == 'elite') then
                TargetFrameTexture:SetTexture(Setup.texpath .. 'UI-TargetingFrame-Elite.blp')
            elseif (classification == 'rare') then
                TargetFrameTexture:SetTexture(Setup.texpath .. 'UI-TargetingFrame-Rare.blp')
            else
                TargetFrameTexture:SetTexture(Setup.texpath .. 'UI-TargetingFrameDF1.blp')
            end
        end
    end

    function Setup:CheckTargetTapped()
        if not UnitExists('target') or not self.healthBar then return end

        if UnitIsPlayer('target') then
            self.healthBar:SetFillColor(0, 1, 0, 1)
            return
        end

        if UnitIsTapped('target') and not UnitIsTappedByPlayer('target') then
            self.healthBar:SetFillColor(0.5, 0.5, 0.5, 1)
        else
            self.healthBar:SetFillColor(0, 1, 0, 1)
        end
    end

    function Setup:UpdateBarColor()
        if not UnitExists('target') or not self.healthBar then return end

        if not UnitIsPlayer('target') and UnitIsTapped('target') and not UnitIsTappedByPlayer('target') then
            self.healthBar:SetFillColor(0.5, 0.5, 0.5, 1)
            return
        end

        if self.barColorState.colorClass and UnitIsPlayer('target') then
            local _, class = UnitClass('target')
            if class and RAID_CLASS_COLORS[class] then
                local color = RAID_CLASS_COLORS[class]
                self.healthBar:SetFillColor(color.r, color.g, color.b, 1)
                return
            end
        end

        if self.barColorState.colorReaction then
            local reaction = UnitReaction('player', 'target')
            if reaction then
                if reaction <= 2 then
                    self.healthBar:SetFillColor(1, 0, 0, 1)  -- hostile - Red
                elseif reaction == 3 or reaction == 4 then
                    self.healthBar:SetFillColor(1, 1, 0, 1)  -- neutral - Yellow
                else
                    self.healthBar:SetFillColor(0, 1, 0, 1)  -- friendly - Green
                end
                return
            end
        end

        self.healthBar:SetFillColor(0, 1, 0, 1)
    end

    function Setup:Run()
        self:KillBlizz()
        self:FrameTextures()
        self:HealthBar()
        self:HealthBarText()
        self:ManaBar()
        self:ManaBarText()
        self:Portrait()
        self:NameText()
        self:LevelText()
        self:UpdateTexts()
        self:HookDeadText()
        self:HookClassification()
    end

    -- init setup
    Setup:Run()

    -- callbacks
    local callbacks = {}

    callbacks.targetDarkMode = function(value)
        local intensity = DFRL:GetTempDB("Target", "targetDarkMode")
        local targetColor = DFRL:GetTempDB("Target", "targetColor")
        local r, g, b = targetColor[1] * (1 - intensity), targetColor[2] * (1 - intensity), targetColor[3] * (1 - intensity)
        local color = value and {r, g, b} or {1, 1, 1}

        TargetFrameTexture:SetVertexColor(color[1], color[2], color[3])
        TargetFrameBackground:SetVertexColor(color[1], color[2], color[3])
    end

    callbacks.targetColor = function(value)
        local intensity = DFRL:GetTempDB("Target", "targetDarkMode")
        local r, g, b = value[1] * (1 - intensity), value[2] * (1 - intensity), value[3] * (1 - intensity)

        TargetFrameTexture:SetVertexColor(r, g, b)
        TargetFrameBackground:SetVertexColor(r, g, b)
    end

    callbacks.textShow = function(value)
        if value then
            Setup.texts.healthPercent:Show()
            Setup.texts.healthValue:Show()
            Setup.texts.manaPercent:Show()
            Setup.texts.manaValue:Show()
        else
            Setup.texts.healthPercent:Hide()
            Setup.texts.healthValue:Hide()
            Setup.texts.manaPercent:Hide()
            Setup.texts.manaValue:Hide()
        end
    end

    callbacks.textMaxShow = function(value)
        configCache.textMaxShow = value
        configCache.lastUpdate = GetTime()
        Setup:UpdateTexts()
    end

    callbacks.noPercent = function(value)
        configCache.noPercent = value
        configCache.lastUpdate = GetTime()
        Setup:UpdateTexts()
    end

    callbacks.useShaguHealth = function()
        Setup:UpdateTexts()
    end

    callbacks.textColoringHealth = function(value)
        configCache.textColoringHealth = value
        configCache.lastUpdate = GetTime()
        Setup:UpdateTexts()
    end

    callbacks.textColoringResource = function(value)
        configCache.textColoringResource = value
        configCache.lastUpdate = GetTime()
        Setup:UpdateTexts()
    end

    callbacks.healthSize = function(value)
        Setup.texts.config.healthFontSize = value
        Setup.texts.healthPercent:SetFont(Setup.texts.config.font, value, Setup.texts.config.outline)
        Setup.texts.healthValue:SetFont(Setup.texts.config.font, value, Setup.texts.config.outline)
    end

    callbacks.manaSize = function(value)
        Setup.texts.config.manaFontSize = value
        Setup.texts.manaPercent:SetFont(Setup.texts.config.font, value, Setup.texts.config.outline)
        Setup.texts.manaValue:SetFont(Setup.texts.config.font, value, Setup.texts.config.outline)
    end

    callbacks.nameSize = function(value)
        Setup.texts.config.nameFontSize = value
        TargetFrame.name:SetFont(Setup.texts.config.font, value, "")
    end

    callbacks.levelSize = function(value)
        Setup.texts.config.levelFontSize = value
        TargetLevelText:SetFont(Setup.texts.config.font, value, "")
    end

    callbacks.frameFont = function(value)
        local fontPath
        if value == "Expressway" then
            fontPath = Setup.fontpath .. "Expressway.ttf"
        elseif value == "Homespun" then
            fontPath = Setup.fontpath .. "Homespun.ttf"
        elseif value == "Hooge" then
            fontPath = Setup.fontpath .. "Hooge.ttf"
        elseif value == "Myriad-Pro" then
            fontPath = Setup.fontpath .. "Myriad-Pro.ttf"
        elseif value == "Prototype" then
            fontPath = Setup.fontpath .. "Prototype.ttf"
        elseif value == "PT-Sans-Narrow-Bold" then
            fontPath = Setup.fontpath .. "PT-Sans-Narrow-Bold.ttf"
        elseif value == "PT-Sans-Narrow-Regular" then
            fontPath = Setup.fontpath .. "PT-Sans-Narrow-Regular.ttf"
        elseif value == "RobotoMono" then
            fontPath = Setup.fontpath .. "RobotoMono.ttf"
        elseif value == "BigNoodleTitling" then
            fontPath = Setup.fontpath .. "BigNoodleTitling.ttf"
        elseif value == "Continuum" then
            fontPath = Setup.fontpath .. "Continuum.ttf"
        elseif value == "DieDieDie" then
            fontPath = Setup.fontpath .. "DieDieDie.ttf"
        else
            fontPath = "Fonts\\FRIZQT__.TTF"
        end

        Setup.texts.config.font = fontPath
        Setup.texts.healthPercent:SetFont(fontPath, Setup.texts.config.healthFontSize, "OUTLINE")
        Setup.texts.healthValue:SetFont(fontPath, Setup.texts.config.healthFontSize, "OUTLINE")
        Setup.texts.manaPercent:SetFont(fontPath, Setup.texts.config.manaFontSize, "OUTLINE")
        Setup.texts.manaValue:SetFont(fontPath, Setup.texts.config.manaFontSize, "OUTLINE")
        Setup:NameText()
        Setup:LevelText()
        if TargetDeadText then
            TargetDeadText:SetFont(fontPath, 12, 'OUTLINE')
            TargetDeadText:SetTextColor(0.7, 0.7, 0.7)
        end
    end

    callbacks.colorReaction = function(value)
        Setup.barColorState.colorReaction = value
        Setup:UpdateBarColor()
    end

    callbacks.colorClass = function(value)
        Setup.barColorState.colorClass = value
        Setup:UpdateBarColor()
    end

    callbacks.cutoutColor = function(value)
        if Setup.healthBar then
            Setup.healthBar:SetCutoutColor(value[1], value[2], value[3], 1)
        end
        if Setup.manaBar then
            Setup.manaBar:SetCutoutColor(value[1], value[2], value[3], 1)
        end
    end

    callbacks.pulseColor = function(value)
        if Setup.healthBar then
            Setup.healthBar:SetPulseColor(value[1], value[2], value[3], 1)
        end
        if Setup.manaBar then
            Setup.manaBar:SetPulseColor(value[1], value[2], value[3], 1)
        end
    end

    callbacks.enablePulse = function(value)
        if Setup.healthBar then
            Setup.healthBar:SetPulseAnimation(value)
        end
        if Setup.manaBar then
            Setup.manaBar:SetPulseAnimation(value)
        end
    end

    callbacks.enableCutout = function(value)
        if Setup.healthBar then
            Setup.healthBar:SetCutoutAnimation(value)
        end
        if Setup.manaBar then
            Setup.manaBar:SetCutoutAnimation(value)
        end
    end

    callbacks.frameScale = function(value)
        TargetFrame:SetScale(value)
    end

    -- event handler
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")
    f:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_HEALTH")
    f:RegisterEvent("UNIT_MANA")
    f:RegisterEvent("UNIT_ENERGY")
    f:RegisterEvent("UNIT_RAGE")
    f:RegisterEvent("UNIT_FOCUS")
    f:SetScript("OnEvent", function()
        if event == "PLAYER_TARGET_CHANGED" then
            if Setup.healthBar then Setup.healthBar:SuppressCutout() end
            if Setup.manaBar then Setup.manaBar:SuppressCutout() end
        elseif event == "UPDATE_SHAPESHIFT_FORMS" then
            if Setup.healthBar then Setup.healthBar:SuppressCutout() end
            if Setup.manaBar then Setup.manaBar:SuppressCutout() end
        end

        if event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
            if Setup.healthBar and UnitExists('target') then
                local health, maxHealth = Setup:GetTargetHealth()
                Setup.healthBar.max = maxHealth
                Setup.healthBar:SetValue(health > 0 and health or 0.001)
            end
            if Setup.manaBar and UnitExists('target') then
                local maxMana = UnitManaMax('target')
                if maxMana > 0 then
                    Setup.manaBar:Show()
                    Setup.manaBar.max = maxMana
                    local mana = UnitMana('target')
                    Setup.manaBar:SetValue(mana > 0 and mana or 0.001)
                    local powerType = UnitPowerType('target')
                    if powerType == 0 then
                        Setup.manaBar:SetFillColor(0, 0, 1, 1)
                    elseif powerType == 1 then
                        Setup.manaBar:SetFillColor(1, 0, 0, 1)
                    elseif powerType == 2 then
                        Setup.manaBar:SetFillColor(1, 1, 0, 1)
                    elseif powerType == 3 then
                        Setup.manaBar:SetFillColor(1, 1, 0, 1)
                    end
                else
                    Setup.manaBar:Hide()
                end
            end
            Setup:CheckTargetTapped()
            Setup:UpdateTexts()
            Setup:UpdateBarColor()
        elseif (event == "UNIT_HEALTH" and arg1 == "target") or
            (event == "UNIT_MANA" and arg1 == "target") or
            (event == "UNIT_ENERGY" and arg1 == "target") or
            (event == "UNIT_RAGE" and arg1 == "target") or
            (event == "UNIT_FOCUS" and arg1 == "target") then
            if Setup.healthBar and UnitExists('target') then
                local health, maxHealth = Setup:GetTargetHealth()
                Setup.healthBar.max = maxHealth
                Setup.healthBar:SetValue(health > 0 and health or 0.001)
            end
            if Setup.manaBar and UnitExists('target') then
                local maxMana = UnitManaMax('target')
                if maxMana > 0 then
                    Setup.manaBar:Show()
                    Setup.manaBar.max = maxMana
                    local mana = UnitMana('target')
                    Setup.manaBar:SetValue(mana > 0 and mana or 0.001)
                else
                    Setup.manaBar:Hide()
                end
            end
            Setup:CheckTargetTapped()
            Setup:UpdateTexts()
            Setup:UpdateBarColor()
        end

        if event == "PLAYER_ENTERING_WORLD" then
            f:UnregisterEvent("PLAYER_ENTERING_WORLD")
        end
    end)

    -- turtle challenge function
    local originalFunc = _G.TargetFrame_UpdateChallenges
    if originalFunc then
        _G.TargetFrame_UpdateChallenges = function(player)
            originalFunc(player)
            if string.find(TargetFrameTexture:GetTexture() or '', 'UI%-TargetingFrame_HC') then
                TargetFrameTexture:SetTexture(Setup.texpath .. 'UI-TargetingFrameDF1_HC.blp')
            end
        end
    end

    -- execute callbacks
    DFRL:NewCallbacks("Target", callbacks)
end)
