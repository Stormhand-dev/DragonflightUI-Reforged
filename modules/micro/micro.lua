DFRL:NewDefaults("Micro", {
    enabled = {true},
    microDarkMode = {0, "slider", {0, 1}, nil, "appearance", 1, "Adjust dark mode intensity", nil, nil},
    microColor = {{1, 1, 1}, "colour", nil, nil, "appearance", 2, "Change micro color", nil, nil},
    switchColor = {true, "checkbox", nil, nil, "micro basic", 3, "Switch between gray and colorfull micro menu", nil, nil},
    microScale = {0.85, "slider", {0.5, 1.5}, nil, "micro basic", 4, "Adjusts the scale of the micro menu", nil, nil},
    microAlpha = {1, "slider", {0.1, 1}, nil, "micro basic", 5, "Adjusts the transparency of the micro menu", nil, nil},
    microSpacing = {3, "slider", {0.5, 15}, nil, "micro basic", 6, "Adjusts spacing between micro menu buttons", nil, nil},
    smallFPS = {false, "checkbox", nil, nil, "tweaks", 7, "Show smaller FPS/MS watcher (CTRL+R)", nil, nil},
})

DFRL:NewMod("Micro", 1, function()
    -- setup
    local Setup = {
        texpath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\tex\\micromenu\\",
        fontpath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\",

        buttons = {},
        microMenuContainer = nil,
        pvpButton = nil,
        lftButton = nil,
        ebcButton = nil,
        ijStandaloneButton = nil,

        msText = nil,
        bwText = nil,
        fpsText = nil,
        netStatsFrame = nil,
        netStatsFrameBG = nil,
        latencyIndicator = nil,
        latencyTexture = nil,

        appearance = {
            scale = 0.85,
            alpha = 1.0,
            microDarkMode = false,
        },

        buttonWidth = 20,
        buttonHeight = 30,
        buttonSpacing = 2,
    }

    function Setup:CreateContainer()
        self.microMenuContainer = CreateFrame("Frame", "DFRLMicroMenuContainer", UIParent)
        self.microMenuContainer:SetWidth((self.buttonWidth + 2) * 10)
        self.microMenuContainer:SetHeight(self.buttonHeight)
        self.microMenuContainer:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -15, 15)
        self.microMenuContainer:SetClampedToScreen(true)
    end

    function Setup:BlizzardButtons()
        self.buttons = {
            CharacterMicroButton,
            SpellbookMicroButton,
            TalentMicroButton,
            QuestLogMicroButton,
            SocialsMicroButton,
            WorldMapMicroButton,
            MainMenuMicroButton,
            HelpMicroButton,
        }
        self.worldMapBtn  = WorldMapMicroButton
        self.mainMenuBtn  = MainMenuMicroButton
        self.helpBtn      = HelpMicroButton
        for _, button in ipairs(self.buttons) do
            if button then
                button:Show()
                button:Enable()
                button:SetAlpha(1)
            end
        end
    end

    function Setup:PvPButton()
        self.pvpButton = CreateFrame("Button", "DFRLPvPMicroButton", self.microMenuContainer)
        self.pvpButton:SetWidth(self.buttonWidth)
        self.pvpButton:SetHeight(self.buttonHeight)
        self.pvpButton:SetHitRectInsets(0, 0, 0, 0)
        self.pvpButton:Show()
        self.pvpButton:Enable()
        self.pvpButton:SetScript("OnClick", function()
            if BattlefieldFrame and BattlefieldFrame:IsVisible() then
                ToggleGameMenu()
            elseif ShowTWBGQueueMenu then
                ShowTWBGQueueMenu()
            end
        end)
        self.pvpButton:SetScript("OnEnter", function()
            GameTooltip:SetOwner(self.pvpButton, "ANCHOR_RIGHT")
            GameTooltip:SetText("Player vs Player", 1, 1, 1)
            GameTooltip:AddLine("Queue for battlegrounds and view PvP statistics.")
            GameTooltip:AddLine("Right-click to toggle honor system.")
            GameTooltip:Show()
        end)
        self.pvpButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    function Setup:LFTButton()
        self.lftButton = CreateFrame("Button", "DFRLLFTMicroButton", self.microMenuContainer)
        self.lftButton:SetWidth(self.buttonWidth)
        self.lftButton:SetHeight(self.buttonHeight)
        self.lftButton:SetHitRectInsets(0, 0, 0, 0)
        self.lftButton:Show()
        self.lftButton:Enable()
        self.lftButton:SetScript("OnClick", LFT_Toggle)
        self.lftButton:SetScript("OnEnter", function()
            GameTooltip:SetOwner(self.lftButton, "ANCHOR_RIGHT")
            GameTooltip:SetText("Looking For Team", 1, 1, 1)
            GameTooltip:AddLine("Open the Group Finder interface to find a team,")
            GameTooltip:AddLine("be aware that you must travel to the dungeon manually.")
            GameTooltip:Show()
        end)
        self.lftButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    function Setup:EBCButton()
        self.ebcButton = CreateFrame("Button", "DFRLEBCMicroButton", self.microMenuContainer)
        self.ebcButton:SetWidth(self.buttonWidth)
        self.ebcButton:SetHeight(self.buttonHeight)
        self.ebcButton:SetHitRectInsets(0, 0, 0, 0)
        self.ebcButton:Show()
        self.ebcButton:Enable()
        self.ebcButton:SetScript("OnClick", function()
            if not EBCMinimapDropdown then return end

            EBCMinimapDropdown:ClearAllPoints()
            EBCMinimapDropdown:SetParent(UIParent)
            EBCMinimapDropdown:SetPoint("CENTER", self.ebcButton, 0, 65)

            ShowEBCMinimapDropdown()

            EBCMinimapDropdown:SetFrameStrata("TOOLTIP")
            EBCMinimapDropdown:SetFrameLevel(200)
            EBCMinimapDropdown:Raise()

            local children = {EBCMinimapDropdown:GetChildren()}
            for i = 1, table.getn(children) do
                local child = children[i]
                if child then
                    child:SetFrameStrata("TOOLTIP")
                    child:SetFrameLevel(200 + i)
                    if child.Raise then
                        child:Raise()
                    end
                end
            end
        end)
        self.ebcButton:SetScript("OnEnter", function()
            GameTooltip:SetOwner(self.ebcButton, "ANCHOR_RIGHT")
            GameTooltip:SetText("Everlook Broadcasting Co.", 1, 1, 1, 1, true)
            GameTooltip:AddLine("Listen to some awesome tunes while you play Turtle WoW.", nil, nil, nil, true)
            GameTooltip:Show()
        end)
        self.ebcButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end


    function Setup:CreateInstanceJournalStandaloneButton()
        if self.ijStandaloneButton then return end

        self.ijStandaloneButton = CreateFrame("Button", "DFRLIJStandaloneButton", self.microMenuContainer)
        self.ijStandaloneButton:SetWidth(self.buttonWidth)
        self.ijStandaloneButton:SetHeight(self.buttonHeight)
        self.ijStandaloneButton:SetHitRectInsets(0, 0, 0, 0)
        self.ijStandaloneButton:Show()
        self.ijStandaloneButton:Enable()

        self.ijStandaloneButton:SetScript("OnClick", function()
            if _G["InstanceJournal"] and InstanceJournal.ToggleInstanceJournal then
                InstanceJournal:ToggleInstanceJournal()
            elseif _G["ToggleInstanceJournal"] then
                ToggleInstanceJournal()
            end
        end)

        self.ijStandaloneButton:SetScript("OnEnter", function()
            GameTooltip:SetOwner(self.ijStandaloneButton, "ANCHOR_RIGHT")
            GameTooltip:SetText("Instance Journal", 1, 1, 1)
            GameTooltip:AddLine("Open the Instance Journal.")
            GameTooltip:Show()
        end)

        self.ijStandaloneButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    function Setup:PositionInstanceJournalStandaloneButton(spacing)
        if not self.ijStandaloneButton or not self.buttons or not self.buttons[table.getn(self.buttons)] then return end
        local lastButton = self.buttons[table.getn(self.buttons)]
        self.ijStandaloneButton:ClearAllPoints()
        self.ijStandaloneButton:SetPoint("TOPLEFT", lastButton, "TOPRIGHT", spacing or self.buttonSpacing, 0)
        self.ijStandaloneButton:SetParent(self.microMenuContainer)
        self.ijStandaloneButton:SetFrameStrata(lastButton:GetFrameStrata())
        self.ijStandaloneButton:SetFrameLevel(lastButton:GetFrameLevel())
    end

    function Setup:ApplyInstanceJournalStandaloneStyle(useColor)
        if not self.ijStandaloneButton then return end
        local colorpath = self.texpath .. "color_micro\\"
        if useColor then
            self.ijStandaloneButton:SetNormalTexture(colorpath .. "instancejournal-regular.tga")
            self.ijStandaloneButton:SetPushedTexture(colorpath .. "instancejournal-faded.tga")
            self.ijStandaloneButton:SetHighlightTexture(colorpath .. "instancejournal-highlight.tga")
        else
            self.ijStandaloneButton:SetNormalTexture(colorpath .. "instancejournal-faded.tga")
            self.ijStandaloneButton:SetPushedTexture(colorpath .. "instancejournal-faded.tga")
            self.ijStandaloneButton:SetHighlightTexture(colorpath .. "instancejournal-highlight.tga")
        end
        if self.ijStandaloneButton:GetNormalTexture() then
            self.ijStandaloneButton:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            self.ijStandaloneButton:GetNormalTexture():Show()
        end
        if self.ijStandaloneButton:GetPushedTexture() then
            self.ijStandaloneButton:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
        end
        if self.ijStandaloneButton:GetHighlightTexture() then
            self.ijStandaloneButton:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
        end
    end

    function Setup:LowLevelTalentButton()
        if not DFRL.lowLevelTalentsButton then
            local lowLevelTalentsButton = CreateFrame("Button", "DFRLLowLevelTalentsButton", Setup.microMenuContainer)
            lowLevelTalentsButton:SetWidth(Setup.buttonWidth)
            lowLevelTalentsButton:SetHeight(Setup.buttonHeight)
            lowLevelTalentsButton:SetPoint("TOPLEFT", Setup.buttons[2], "TOPLEFT", Setup.buttonWidth + Setup.buttonSpacing, 0)
            lowLevelTalentsButton:SetNormalTexture(Setup.texpath.. "color_micro\\talents-disabled.tga")
            lowLevelTalentsButton:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)

            lowLevelTalentsButton:SetScript("OnEnter", function()
                GameTooltip:SetOwner(lowLevelTalentsButton, "ANCHOR_RIGHT")
                GameTooltip:SetText("Talents", 1, 1, 1)
                GameTooltip:AddLine("You must reach level 10 to use talents.")
                GameTooltip:Show()
            end)

            lowLevelTalentsButton:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)

            DFRL.lowLevelTalentsButton = lowLevelTalentsButton

            local function UpdateTalentButtonVisibility()
                local playerLevel = UnitLevel("player")
                if playerLevel < 10 then
                    lowLevelTalentsButton:Show()
                    Setup.buttons[3]:Hide()
                else
                    lowLevelTalentsButton:Hide()
                    Setup.buttons[3]:Show()
                end
            end

            local talentVisibilityFrame = CreateFrame("Frame")
            talentVisibilityFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
            talentVisibilityFrame:RegisterEvent("PLAYER_LEVEL_UP")
            talentVisibilityFrame:SetScript("OnEvent", function()
                UpdateTalentButtonVisibility()
                talentVisibilityFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
            end)

            UpdateTalentButtonVisibility()
        end
    end

    function Setup:ArrangeButtons()
        -- insert custom buttons after SocialsMicroButton (index 5)
        local newButtons = {}
        for i, button in ipairs(self.buttons) do
            table.insert(newButtons, button)
            if i == 5 then
                if ShowTWBGQueueMenu then
                    table.insert(newButtons, self.pvpButton)
                else
                    self.pvpButton:Hide()
                end
                if LFT_Toggle then
                    table.insert(newButtons, self.lftButton)
                else
                    self.lftButton:Hide()
                end
                if ShowEBCMinimapDropdown then
                    table.insert(newButtons, self.ebcButton)
                else
                    self.ebcButton:Hide()
                end
            end
        end
        self.buttons = newButtons

        for i, button in ipairs(self.buttons) do
            button:Show()
            button:Enable()
            button:SetParent(self.microMenuContainer)
            button:ClearAllPoints()
            local xOffset = (i-1) * (self.buttonWidth + self.buttonSpacing)
            button:SetPoint("TOPLEFT", self.microMenuContainer, "TOPLEFT", xOffset, 0)
            button:SetWidth(self.buttonWidth)
            button:SetHeight(self.buttonHeight)
            button:SetHitRectInsets(0, 0, 0, 0)
            if button == self.pvpButton or button == self.lftButton then
                local regions = {button:GetRegions()}
                for _, region in ipairs(regions) do
                    if region:GetObjectType() == "Texture" then
                        region:Hide()
                    end
                end
            end
        end

        local charBtn = self.buttons[1]
        if charBtn then
            local path = self.texpath .. "uimicromenu2x.tga"
            charBtn:SetNormalTexture(path)
            if charBtn:GetNormalTexture() then
                charBtn:GetNormalTexture():SetTexCoord(2/256, 37/256, 324/512, 372/512)
                charBtn:GetNormalTexture():Show()
            end
            charBtn:SetPushedTexture(path)
            if charBtn:GetPushedTexture() then
                charBtn:GetPushedTexture():SetTexCoord(82/256, 116/256, 216/512, 264/512)
            end
            charBtn:SetHighlightTexture(path)
            if charBtn:GetHighlightTexture() then
                charBtn:GetHighlightTexture():SetTexCoord(82/256, 116/256, 216/512, 264/512)
            end
        end
    end

    function Setup:HideOtherUI()
        if MicroButtonPortrait then MicroButtonPortrait:Hide() end
        if ShopMicroButton then ShopMicroButton:Hide() end
        if PVPMicroButton then PVPMicroButton:Hide() end

        if LFT then LFT:Hide() end
        if MinimapShopFrame then MinimapShopFrame:Hide() end
        if TWMiniMapBattlefieldFrame then TWMiniMapBattlefieldFrame:Hide() end
    end

    function Setup:DisableBlizzardFPS()
        UIPARENT_MANAGED_FRAME_POSITIONS["FramerateLabel"] = nil
        if FramerateLabel then
            FramerateLabel:ClearAllPoints()
            FramerateLabel:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
            FramerateLabel:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
            FramerateLabel:SetTextColor(1, 1, 1, 0)
        end
        if FramerateText then
            FramerateText:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
            FramerateText:SetTextColor(1, 1, 1, 0)
        end
    end

    function Setup:NetStats()
        self.netStatsFrame = CreateFrame("Frame", "DFRL_NetStatsFrame", UIParent)
        self.netStatsFrame:SetPoint("BOTTOMRIGHT", CharacterMicroButton, "BOTTOMLEFT", -10, -1)
        self.netStatsFrame:SetWidth(98)
        self.netStatsFrame:SetHeight(26)
        self.netStatsFrame:SetClampedToScreen(true)

        self.netStatsFrameBG = self.netStatsFrame:CreateTexture(nil, "BACKGROUND")
        self.netStatsFrameBG:SetAllPoints(self.netStatsFrame)
        self.netStatsFrameBG:SetTexture(0, 0, 0, 0.3)

        local size = 9

        self.msText = self.netStatsFrame:CreateFontString(nil, "OVERLAY")
        self.msText:SetPoint("TOPRIGHT", self.netStatsFrame, "TOPRIGHT", -8, -2)
        self.msText:SetFont("Fonts\\FRIZQT__.TTF", size, "")
        self.msText:SetTextColor(1, 1, 1, 1)

        self.bwText = self.netStatsFrame:CreateFontString(nil, "OVERLAY")
        self.bwText:SetPoint("TOPRIGHT", self.msText, "BOTTOMRIGHT", 0, -3)
        self.bwText:SetFont("Fonts\\FRIZQT__.TTF", size, "")
        self.bwText:SetTextColor(1, 1, 1, 1)

        self.fpsText = self.netStatsFrame:CreateFontString(nil, "OVERLAY")
        self.fpsText:SetPoint("RIGHT", self.msText, "LEFT", -10, 0)
        self.fpsText:SetFont("Fonts\\FRIZQT__.TTF", size, "")
        self.fpsText:SetTextColor(1, 1, 1, 1)

        self.latencyIndicator = CreateFrame("Frame", "DFRL_LatencyIndicator", UIParent)
        self.latencyIndicator:SetPoint("TOP", HelpMicroButton, "BOTTOM", 0, 7)
        self.latencyIndicator:SetWidth(20)
        self.latencyIndicator:SetHeight(15)

        self.latencyTexture = self.latencyIndicator:CreateTexture(nil, "ARTWORK")
        self.latencyTexture:SetAllPoints(self.latencyIndicator)

        self.netStatsFrame:SetScript("OnUpdate", function()
            if (this.tick or 0) > GetTime() then return end
            this.tick = GetTime() + 0.5

            local bandwidthIn, bandwidthOut, latencyHome = GetNetStats()
            self.msText:SetText(string.format("MS: %d", latencyHome))
            self.bwText:SetText(string.format("UL/DL: %.1f / %.1f", bandwidthIn, bandwidthOut))
            self.fpsText:SetText(string.format("FPS: %d", GetFramerate()))
        end)

        self.latencyIndicator:SetScript("OnUpdate", function()
            if (this.tick or 0) > GetTime() then return end
            this.tick = GetTime() + 2

            local _, _, latencyHome = GetNetStats()
            if latencyHome < 200 then
                self.latencyTexture:SetTexture(self.texpath.. "LatencyGreen.tga")
            elseif latencyHome < 300 then
                self.latencyTexture:SetTexture(self.texpath.. "LatencyYellow.tga")
            else
                self.latencyTexture:SetTexture(self.texpath.. "LatencyRed.tga")
            end
        end)

        self.netStatsFrame:Hide()

        hooksecurefunc("ToggleFramerate", function()
            local checkTimer = CreateFrame("Frame")
            checkTimer:SetScript("OnUpdate", function()
                if (this.tick or 0) > GetTime() then return end
                this.tick = GetTime() + 0.1

                if FramerateLabel and FramerateLabel:IsVisible() then
                    self.netStatsFrame:Show()
                    DFRL.activeScripts["NetStatsFrameScript"] = true
                else
                    self.netStatsFrame:Hide()
                    DFRL.activeScripts["NetStatsFrameScript"] = false
                end
                checkTimer:SetScript("OnUpdate", nil)
            end)
        end)
    end

    function Setup:Run()
        self:CreateContainer()
        self:BlizzardButtons()
        self:PvPButton()
        self:LFTButton()
        self:EBCButton()
        self:ArrangeButtons()
        self:CreateInstanceJournalStandaloneButton()
        self:PositionInstanceJournalStandaloneButton(self.buttonSpacing)
        self:ApplyInstanceJournalStandaloneStyle(DFRL:GetTempDB("Micro", "switchColor"))
        self:HideOtherUI()

        self:DisableBlizzardFPS()
        self:NetStats()
    end

    -- init setup
    Setup:Run()

    -- expose
    DFRL.microMenuContainer = Setup.microMenuContainer
    DFRL.netStatsFrame = Setup.netStatsFrame
    DFRL.gameMenuButton = MainMenuMicroButton

    -- callbacks
    local callbacks = {}

    callbacks.microDarkMode = function(value)
        local intensity = DFRL:GetTempDB("Micro", "microDarkMode")
        local microColor = DFRL:GetTempDB("Micro", "microColor")
        local r, g, b = microColor[1] * (1 - intensity), microColor[2] * (1 - intensity), microColor[3] * (1 - intensity)
        local color = value and {r, g, b} or {1, 1, 1}

        for _, button in ipairs(Setup.buttons) do
            local normalTexture = button:GetNormalTexture()
            if normalTexture then
                normalTexture:SetVertexColor(color[1], color[2], color[3])
            end
        end

        if DFRL.lowLevelTalentsButton then
            local normalTexture = DFRL.lowLevelTalentsButton:GetNormalTexture()
            if normalTexture then
                normalTexture:SetVertexColor(color[1], color[2], color[3])
            end
        end
    end

    callbacks.microColor = function(value)
        local intensity = DFRL:GetTempDB("Micro", "microDarkMode")
        local r, g, b = value[1] * (1 - intensity), value[2] * (1 - intensity), value[3] * (1 - intensity)

        for _, button in ipairs(Setup.buttons) do
            local normalTexture = button:GetNormalTexture()
            if normalTexture then
                normalTexture:SetVertexColor(r, g, b)
            end
        end

        if DFRL.lowLevelTalentsButton then
            local normalTexture = DFRL.lowLevelTalentsButton:GetNormalTexture()
            if normalTexture then
                normalTexture:SetVertexColor(r, g, b)
            end
        end
    end

    callbacks.microScale = function(value)
        if DFRL.microMenuContainer then
            DFRL.microMenuContainer:SetScale(value)
        end
    end

    callbacks.microAlpha = function(value)
        if DFRL.microMenuContainer then
            DFRL.microMenuContainer:SetAlpha(value)
        end
    end

    callbacks.microSpacing = function(value)
        if DFRL.microMenuContainer and Setup.buttons then
            for i, button in ipairs(Setup.buttons) do
                button:ClearAllPoints()
                local xOffset = (i-1) * (Setup.buttonWidth + value)
                button:SetPoint("TOPLEFT", DFRL.microMenuContainer, "TOPLEFT", xOffset, 0)
            end

            DFRL.microMenuContainer:SetWidth((Setup.buttonWidth + value) * table.getn(Setup.buttons))
            Setup:PositionInstanceJournalStandaloneButton(value)
        end
    end

    callbacks.switchColor = function(value)
        if value then
            local colorpath = Setup.texpath.. "color_micro\\"

            if Setup.buttons[2] then
                Setup.buttons[2]:SetNormalTexture(colorpath .. "spellbook-regular.tga")
                Setup.buttons[2]:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[2]:SetPushedTexture(colorpath .. "spellbook-faded.tga")
                Setup.buttons[2]:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[2]:SetHighlightTexture(colorpath .. "spellbook-highlight.tga")
                Setup.buttons[2]:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            if Setup.buttons[3] then
                Setup.buttons[3]:SetNormalTexture(colorpath .. "talents-regular.tga")
                Setup.buttons[3]:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[3]:SetPushedTexture(colorpath .. "talents-faded.tga")
                Setup.buttons[3]:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[3]:SetHighlightTexture(colorpath .. "talents-highlight.tga")
                Setup.buttons[3]:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            Setup:LowLevelTalentButton()

            if Setup.buttons[4] then
                Setup.buttons[4]:SetNormalTexture(colorpath .. "quest-regular.tga")
                Setup.buttons[4]:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[4]:SetPushedTexture(colorpath .. "quest-faded.tga")
                Setup.buttons[4]:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[4]:SetHighlightTexture(colorpath .. "quest-highlight.tga")
                Setup.buttons[4]:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            if Setup.buttons[5] then
                Setup.buttons[5]:SetNormalTexture(colorpath .. "tabard-regular.tga")
                Setup.buttons[5]:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[5]:SetPushedTexture(colorpath .. "tabard-faded.tga")
                Setup.buttons[5]:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.buttons[5]:SetHighlightTexture(colorpath .. "tabard-highlight.tga")
                Setup.buttons[5]:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            -- Turtle WoW exclusive buttons (only apply if available)
            if ShowTWBGQueueMenu and Setup.pvpButton then
                Setup.pvpButton:SetNormalTexture(colorpath .. "book-regular.tga")
                Setup.pvpButton:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.pvpButton:SetPushedTexture(colorpath .. "book-faded.tga")
                Setup.pvpButton:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.pvpButton:SetHighlightTexture(colorpath .. "book-highlight.tga")
                Setup.pvpButton:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            if LFT_Toggle and Setup.lftButton then
                Setup.lftButton:SetNormalTexture(colorpath .. "eye-regular.tga")
                Setup.lftButton:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.lftButton:SetPushedTexture(colorpath .. "eye-faded.tga")
                Setup.lftButton:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.lftButton:SetHighlightTexture(colorpath .. "eye-highlight.tga")
                Setup.lftButton:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            if ShowEBCMinimapDropdown and Setup.ebcButton then
                Setup.ebcButton:SetNormalTexture(colorpath .. "horseshoe-regular.tga")
                Setup.ebcButton:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.ebcButton:SetPushedTexture(colorpath .. "horseshoe-faded.tga")
                Setup.ebcButton:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.ebcButton:SetHighlightTexture(colorpath .. "horseshoe-highlight.tga")
                Setup.ebcButton:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            -- Fixed Blizzard buttons (always present)
            if Setup.worldMapBtn then
                Setup.worldMapBtn:SetNormalTexture(colorpath .. "shield-regular.tga")
                Setup.worldMapBtn:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.worldMapBtn:SetPushedTexture(colorpath .. "shield-faded.tga")
                Setup.worldMapBtn:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.worldMapBtn:SetHighlightTexture(colorpath .. "shield-highlight.tga")
                Setup.worldMapBtn:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            if Setup.mainMenuBtn then
                Setup.mainMenuBtn:SetNormalTexture(colorpath .. "wow-regular.tga")
                Setup.mainMenuBtn:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.mainMenuBtn:SetPushedTexture(colorpath .. "wow-faded.tga")
                Setup.mainMenuBtn:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.mainMenuBtn:SetHighlightTexture(colorpath .. "wow-highlight.tga")
                Setup.mainMenuBtn:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end

            if Setup.helpBtn then
                Setup.helpBtn:SetNormalTexture(colorpath .. "question-regular.tga")
                Setup.helpBtn:GetNormalTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.helpBtn:SetPushedTexture(colorpath .. "question-faded.tga")
                Setup.helpBtn:GetPushedTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
                Setup.helpBtn:SetHighlightTexture(colorpath .. "question-highlight.tga")
                Setup.helpBtn:GetHighlightTexture():SetTexCoord(36/128, 86/128, 29/128, 98/128)
            end
        else
            if Setup.buttons[2] then
                Setup.buttons[2]:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[2]:GetNormalTexture():SetTexCoord(122/256, 157/256, 54/512, 102/512)
                Setup.buttons[2]:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[2]:GetPushedTexture():SetTexCoord(190/256, 225/256, 432/512, 480/512)
                Setup.buttons[2]:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[2]:GetHighlightTexture():SetTexCoord(190/256, 225/256, 432/512, 480/512)
            end

            if Setup.buttons[3] then
                Setup.buttons[3]:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[3]:GetNormalTexture():SetTexCoord(162/256, 197/256, 0/512, 48/512)
                Setup.buttons[3]:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[3]:GetPushedTexture():SetTexCoord(82/256, 117/256, 0/512, 48/512)
                Setup.buttons[3]:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[3]:GetHighlightTexture():SetTexCoord(82/256, 117/256, 0/512, 48/512)
            end

            Setup:LowLevelTalentButton()

            if Setup.buttons[4] then
                Setup.buttons[4]:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[4]:GetNormalTexture():SetTexCoord(202/256, 237/256, 270/512, 318/512)
                Setup.buttons[4]:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[4]:GetPushedTexture():SetTexCoord(42/256, 77/256, 432/512, 480/512)
                Setup.buttons[4]:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[4]:GetHighlightTexture():SetTexCoord(42/256, 77/256, 432/512, 480/512)
            end

            if Setup.buttons[5] then
                Setup.buttons[5]:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[5]:GetNormalTexture():SetTexCoord(42/256, 76/256, 54/512, 102/512)
                Setup.buttons[5]:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[5]:GetPushedTexture():SetTexCoord(42/256, 77/256, 0/512, 48/512)
                Setup.buttons[5]:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.buttons[5]:GetHighlightTexture():SetTexCoord(42/256, 77/256, 0/512, 48/512)
            end

            -- Fixed Blizzard buttons (always present)
            if Setup.worldMapBtn then
                Setup.worldMapBtn:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.worldMapBtn:GetNormalTexture():SetTexCoord(0/256, 37/256, 269/512, 319/512)
                Setup.worldMapBtn:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.worldMapBtn:GetPushedTexture():SetTexCoord(161/256, 197/256, 161/512, 211/512)
                Setup.worldMapBtn:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.worldMapBtn:GetHighlightTexture():SetTexCoord(161/256, 197/256, 161/512, 211/512)
            end

            if Setup.mainMenuBtn then
                Setup.mainMenuBtn:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.mainMenuBtn:GetNormalTexture():SetTexCoord(0/256, 38/256, 161/512, 211/512)
                Setup.mainMenuBtn:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.mainMenuBtn:GetPushedTexture():SetTexCoord(41/256, 78/256, 107/512, 157/512)
                Setup.mainMenuBtn:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.mainMenuBtn:GetHighlightTexture():SetTexCoord(41/256, 78/256, 107/512, 157/512)
            end

            if Setup.helpBtn then
                Setup.helpBtn:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.helpBtn:GetNormalTexture():SetTexCoord(82/256, 119/256, 325/512, 374/512)
                Setup.helpBtn:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.helpBtn:GetPushedTexture():SetTexCoord(82/256, 119/256, 378/512, 429/512)
                Setup.helpBtn:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.helpBtn:GetHighlightTexture():SetTexCoord(82/256, 119/256, 378/512, 429/512)
            end

            -- Turtle WoW exclusive buttons (gray fallback, only if present)
            if ShowTWBGQueueMenu and Setup.pvpButton then
                Setup.pvpButton:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.pvpButton:GetNormalTexture():SetTexCoord(162/256, 196/256, 107/512, 157/512)
                Setup.pvpButton:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.pvpButton:GetPushedTexture():SetTexCoord(202/256, 237/256, 54/512, 102/512)
                Setup.pvpButton:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.pvpButton:GetHighlightTexture():SetTexCoord(202/256, 237/256, 54/512, 102/512)
            end

            if LFT_Toggle and Setup.lftButton then
                Setup.lftButton:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.lftButton:GetNormalTexture():SetTexCoord(2/256, 37/256, 107/512, 157/512)
                Setup.lftButton:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.lftButton:GetPushedTexture():SetTexCoord(122/256, 157/256, 323/512, 372/512)
                Setup.lftButton:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.lftButton:GetHighlightTexture():SetTexCoord(122/256, 157/256, 323/512, 372/512)
            end

            if ShowEBCMinimapDropdown and Setup.ebcButton then
                Setup.ebcButton:SetNormalTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.ebcButton:GetNormalTexture():SetTexCoord(202/256, 237/256, 215/512, 265/512)
                Setup.ebcButton:SetPushedTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.ebcButton:GetPushedTexture():SetTexCoord(162/256, 198/256, 215/512, 265/512)
                Setup.ebcButton:SetHighlightTexture(Setup.texpath .. "uimicromenu2x.tga")
                Setup.ebcButton:GetHighlightTexture():SetTexCoord(162/256, 198/256, 215/512, 265/512)
            end
        end

        Setup:ApplyInstanceJournalStandaloneStyle(value)
        callbacks.microColor(DFRL:GetTempDB("Micro", "microColor"))
    end

    callbacks.smallFPS = function(value)
        if not Setup.netStatsFrame or not Setup.fpsText or not Setup.msText or not Setup.bwText then return end

        local smallFontSize = 8
        local normalFontSize = 9
        local fontPath = "Fonts\\FRIZQT__.TTF"

        if value then
            Setup.bwText:SetAlpha(0)
            Setup.fpsText:ClearAllPoints()
            Setup.fpsText:SetPoint("TOPRIGHT", Setup.netStatsFrame, "TOPRIGHT", -6, -2)
            Setup.msText:ClearAllPoints()
            Setup.msText:SetPoint("TOPRIGHT", Setup.netStatsFrame, "TOPRIGHT", -6, -14)

            Setup.fpsText:SetFont(fontPath, smallFontSize, "")
            Setup.msText:SetFont(fontPath, smallFontSize, "")

            Setup.netStatsFrame:SetWidth(45)
            Setup.netStatsFrame:SetHeight(25)
        else
            Setup.bwText:SetAlpha(1)
            Setup.msText:ClearAllPoints()
            Setup.msText:SetPoint("TOPRIGHT", Setup.netStatsFrame, "TOPRIGHT", -8, -2)
            Setup.fpsText:ClearAllPoints()
            Setup.fpsText:SetPoint("RIGHT", Setup.msText, "LEFT", -10, 0)

            Setup.fpsText:SetFont(fontPath, normalFontSize, "")
            Setup.msText:SetFont(fontPath, normalFontSize, "")

            Setup.netStatsFrame:SetWidth(98)
            Setup.netStatsFrame:SetHeight(26)
        end
    end

    DFRL.activeScripts["NetStatsFrameScript"] = false

    -- execute callbacks
    DFRL:NewCallbacks("Micro", callbacks)
end)