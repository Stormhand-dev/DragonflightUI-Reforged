DFRL:NewDefaults("Bars", {
    enabled = {true},
    movable = {true},
    barsDarkMode = {0, "slider", {0, 1}, nil, "appearance", 1, "Adjust dark mode intensity", nil, nil},
    barsColor = {{1, 1, 1}, "colour", nil, nil, "appearance", 2, "Change bars color", nil, nil},
    mainBarBG = {true, "checkbox", nil, nil, "mainbar", 3, "Show or hide main action bar background", nil, nil},
    mainBarScale = {1, "slider", {0.5, 2}, nil, "mainbar", 4, "Adjusts the scale of the main action bar", nil, nil},
    mainBarSpacing = {6, "slider", {0, 20}, nil, "mainbar", 5, "Adjusts spacing between main action bar buttons", nil, nil},
    mainBarAlpha = {1, "slider", {0.1, 1}, nil, "mainbar", 6, "Adjusts transparency of main action bar", nil, nil},
    mainBarGrid = {1, "slider", {1, 6}, nil, "mainbar", 7, "Changes the grid layout of main action bar", nil, nil},
    highlightColor = {{1, 0.82, 0}, "colour", nil, nil, "mainbar", 8, "Changes the colour of action button highlights", nil, nil},
    multiBarOneShow = {false, "checkbox", nil, nil, "multibar 1", 9, "Show or hide bottom left action bar", nil, nil},
    multiBarOneScale = {1, "slider", {0.2, 2}, nil, "multibar 1", 10, "Adjusts scale of bottom left action bar", nil, nil},
    multiBarOneSpacing = {6, "slider", {0.1, 20}, nil, "multibar 1", 11, "Adjusts spacing between bottom left action bar buttons", nil, nil},
    multiBarOneAlpha = {1, "slider", {0.1, 1}, nil, "multibar 1", 12, "Adjusts transparency of bottom left action bar", nil, nil},
    multiBarOneGrid = {1, "slider", {1, 6}, nil, "multibar 1", 13, "Changes the grid layout of bottom left action bar", nil, nil},
    multiBarTwoShow = {false, "checkbox", nil, nil, "multibar 2", 14, "Show or hide bottom right action bar", nil, nil},
    multiBarTwoScale = {1, "slider", {0.2, 2}, nil, "multibar 2", 15, "Adjusts scale of bottom right action bar", nil, nil},
    multiBarTwoSpacing = {6, "slider", {0.1, 20}, nil, "multibar 2", 16, "Adjusts spacing between bottom right action bar buttons", nil, nil},
    multiBarTwoAlpha = {1, "slider", {0.1, 1}, nil, "multibar 2", 17, "Adjusts transparency of bottom right action bar", nil, nil},
    multiBarTwoGrid = {1, "slider", {1, 6}, nil, "multibar 2", 18, "Changes the grid layout of bottom right action bar", nil, nil},
    multiBarThreeShow = {false, "checkbox", nil, nil, "multibar 3", 19, "Show or hide left side action bar", nil, nil},
    multiBarThreeScale = {0.8, "slider", {0.2, 2}, nil, "multibar 3", 20, "Adjusts scale of left action bar", nil, nil},
    multiBarThreeSpacing = {6, "slider", {0.1, 20}, nil, "multibar 3", 21, "Adjusts spacing between left action bar buttons", nil, nil},
    multiBarThreeAlpha = {1, "slider", {0.1, 1}, nil, "multibar 3", 22, "Adjusts transparency of left action bar", nil, nil},
    multiBarThreeGrid = {6, "slider", {1, 6}, nil, "multibar 3", 23, "Changes the grid layout of left action bar", nil, nil},
    multiBarFourShow = {true, "checkbox", nil, nil, "multibar 4", 24, "Show or hide right side action bar", nil, nil},
    multiBarFourScale = {0.8, "slider", {0.2, 2}, nil, "multibar 4", 25, "Adjusts scale of right action bar", nil, nil},
    multiBarFourSpacing = {6, "slider", {0.1, 20}, nil, "multibar 4", 26, "Adjusts spacing between right action bar buttons", nil, nil},
    multiBarFourAlpha = {1, "slider", {0.1, 1}, nil, "multibar 4", 27, "Adjusts transparency of right action bar", nil, nil},
    multiBarFourGrid = {6, "slider", {1, 6}, nil, "multibar 4", 28, "Changes the grid layout of right action bar", nil, nil},
    showGryphoon = {true, "checkbox", nil, nil, "mainbar deco", 29, "Show or hide the gryphon/wyvern decorations", nil, nil},
    altGryphoon = {false, "checkbox", nil, nil, "mainbar deco", 30, "Use the alternative gryphon/wyvern textures", nil, nil},
    flipGryphoon = {false, "checkbox", nil, nil, "mainbar deco", 31, "Flip the gryphon/wyvern textures", nil, nil},
    gryphoonScale = {1, "slider", {0.2, 2}, nil, "mainbar deco", 32, "Adjusts the size of the gryphon/wyvern decorations", nil, nil},
    gryphoonX = {-48, "slider", {-200, 200, 3}, nil, "mainbar deco", 33, "Adjusts horizontal position of gryphon/wyvern decorations", nil, nil},
    gryphoonY = {10, "slider", {-200, 200, 3}, nil, "mainbar deco", 34, "Adjusts vertical position of gryphon/wyvern decorations", nil, nil},
    gryphoonAlpha = {1, "slider", {0.1, 1}, nil, "mainbar deco", 35, "Adjusts transparency of gryphon/wyvern decorations", nil, nil},
    pagingShow = {true, "checkbox", nil, nil, "mainbar paging", 36, "Show or hide the action bar paging buttons", nil, nil},
    pagingSwap = {true, "checkbox", nil, nil, "mainbar paging", 37, "Swap the anchorpoint of the paging buttons", nil, nil},
    pagingX = {15, "slider", {0, 150}, nil, "mainbar paging", 38, "Adjusts horizontal position of paging buttons", nil, nil},
    pagingScale = {0.9, "slider", {0.7, 1.8}, nil, "mainbar paging", 39, "Adjusts the scale of the paging buttons", nil, nil},
    hotkeyFont = {"FRIZQT__.TTF", "dropdown", {"FRIZQT__.TTF", "Expressway", "Homespun", "Hooge", "Myriad-Pro", "Prototype", "PT-Sans-Narrow-Bold", "PT-Sans-Narrow-Regular", "RobotoMono", "BigNoodleTitling", "Continuum", "DieDieDie"}, nil, "text settings", 40, "Change the font used for the hotkeys and macros", nil, nil},
    hotkeyColour = {{1, 0.82, 0}, "colour", nil, nil, "text settings", 41, "Changes the colour of keybind text on action buttons", nil, nil},
    hotkeyShow = {true, "checkbox", nil, nil, "text settings", 42, "Show or hide keybind text on action buttons", nil, nil},
    hotkeyScale = {1.4, "slider", {0.5, 2}, nil, "text settings", 43, "Adjusts the size of keybind text on action buttons", nil, nil},
    hotkeyX = {0, "slider", {-50, 50}, nil, "text settings", 44, "Adjusts horizontal position of keybind text", nil, nil},
    hotkeyY = {-2, "slider", {-50, 50}, nil, "text settings", 45, "Adjusts vertical position of keybind text", nil, nil},
    macroColour = {{1, 1, 1}, "colour", nil, nil, "text settings", 46, "Changes the colour of macro text on action buttons", nil, nil},
    macroShow = {true, "checkbox", nil, nil, "text settings", 47, "Show or hide macro text on action buttons", nil, nil},
    macroScale = {1.3, "slider", {0.5, 2}, nil, "text settings", 48, "Adjusts the size of macro text on action buttons", nil, nil},
    macroX = {0, "slider", {-50, 50}, nil, "text settings", 49, "Adjusts horizontal position of macro text", nil, nil},
    macroY = {2, "slider", {-50, 50}, nil, "text settings", 50, "Adjusts vertical position of macro text", nil, nil},
    petbarScale = {0.8, "slider", {0.2, 2}, nil, "pet bar", 51, "Adjusts the scale of the pet action bar", nil, nil},
    petbarSpacing = {6, "slider", {0.1, 20}, nil, "pet bar", 52, "Adjusts spacing between pet action bar buttons", nil, nil},
    petbarAlpha = {1, "slider", {0.1, 1}, nil, "pet bar", 53, "Adjusts transparency of pet action bar", nil, nil},
    petbarGrid = {1, "slider", {1, 6}, nil, "pet bar", 54, "Changes the grid layout of pet action bar", "5 = 2 columns x 5 rows", nil},
    shapeshiftScale = {0.8, "slider", {0.2, 2}, nil, "shapeshift bar", 55, "Adjusts the scale of the shapeshift bar", nil, nil},
    shapeshiftSpacing = {6, "slider", {0.1, 20}, nil, "shapeshift bar", 56, "Adjusts spacing between shapeshift buttons", nil, nil},
    shapeshiftAlpha = {1, "slider", {0.1, 1}, nil, "shapeshift bar", 57, "Adjusts transparency of shapeshift bar", nil, nil},
})

DFRL:NewMod("Bars", 1, function()
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function()
        f:UnregisterEvent("PLAYER_ENTERING_WORLD")

        local Setup = {
            texpath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\tex\\actionbars\\",
            fontpath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\",

            mainBar = nil,
            actionBarFrame = nil,
            newPetBar = nil,
            newShapeshiftBar = nil,
            pagingContainer = nil,
            actionBarBGleft = nil,
            actionBarBGright = nil,
            gryphonContainer = nil,
            leftGryphon = nil,
            rightGryphon = nil,

            buttonTypes = {
                "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
                "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton",
                "ShapeshiftButton", "PetActionButton"
            },

            layouts = {
                [1] = {rows = 1, cols = 12},
                [2] = {rows = 2, cols = 6},
                [3] = {rows = 3, cols = 4},
                [4] = {rows = 4, cols = 3},
                [5] = {rows = 6, cols = 2},
                [6] = {rows = 12, cols = 1}
            },

            hightlightColor = {1, 0.82, 0},

            texts = {
                hotkey = nil,
                macro = nil,
                config = {
                    font = "Fonts\\FRIZQT__.TTF",
                    hotkeyFontSize = 10,
                    macroFontSize = 9,
                    hotkeyColor = {1, 0.82, 0},
                    macroColor = {1, 1, 1},
                    outline = "OUTLINE",
                }
            }
        }

        -- ✅ PATCH: Immersion compat helper (não força alpha quando Immersion estiver ativo)
        local _IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
        local function DFRL_IsImmersionLoaded()
            return _IsAddOnLoaded and _IsAddOnLoaded("Immersion")
        end

        function Setup:HideBlizzard()
            HideFrameTextures(MainMenuBar)
            HideFrameTextures(MainMenuBarArtFrame)
            HideFrameTextures(PetActionBarFrame)

            MainMenuBar:EnableMouse(false)
            MainMenuBarArtFrame:EnableMouse(false)
            PetActionBarFrame:EnableMouse(false)

            KillFrame(_G.ExhaustionTick)

            SlidingActionBarTexture0:SetTexture(nil)
            SlidingActionBarTexture1:SetTexture(nil)

            BonusActionBarTexture0:Hide()
            BonusActionBarTexture1:Hide()

            ShapeshiftBarLeft:Hide()
            ShapeshiftBarMiddle:Hide()
            ShapeshiftBarRight:Hide()
            ShapeshiftBarLeft:SetAlpha(0)
            ShapeshiftBarMiddle:SetAlpha(0)
            ShapeshiftBarRight:SetAlpha(0)

            for i = 1, 10 do
                local button = _G["ShapeshiftButton"..i]
                if button then
                    local name = button:GetName()
                    local background = _G[name.."Background"]
                    local normalTexture = _G[name.."NormalTexture"]
                    if background then background:Hide() end
                    if normalTexture then normalTexture:Hide() end
                end
            end
        end

        function Setup:MainBarFrames()
            UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"] = nil

            self.mainBar = CreateFrame("Frame", "DFRL_MainBar", UIParent)
            self.mainBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 55)
            self.mainBar:SetHeight(45)
            self.mainBar:SetWidth(500)
            self.mainBar:SetClampedToScreen(true)
            self.mainBar:SetFrameStrata("LOW")
            self.mainBar:SetFrameLevel(1)

            ActionButton1:ClearAllPoints()
            ActionButton1:SetPoint("BOTTOMLEFT", self.mainBar, "BOTTOMLEFT", 0, 0)

            BonusActionButton1:ClearAllPoints()
            BonusActionButton1:SetPoint("BOTTOMLEFT", self.mainBar, "BOTTOMLEFT", 0, 0)

            self.actionBarFrame = CreateFrame("Frame", "DFRL_ActionBar", UIParent)
            self.actionBarFrame:SetPoint("TOPLEFT", ActionButton1, "TOPLEFT", 0, 0)
            self.actionBarFrame:SetPoint("BOTTOMRIGHT", ActionButton12, "BOTTOMRIGHT", 0, 0)
            self.actionBarFrame:SetFrameStrata("LOW")
            self.actionBarFrame:SetFrameLevel(2)
        end

        function Setup:RepositionBars()
            local function RepositionBars()
                local movable = DFRL:GetTempDB("Bars", "movable")
                if movable ~= true then return end

                local bottomLeftState = _G["SHOW_MULTI_ACTIONBAR_1"]
                local bottomRightState = _G["SHOW_MULTI_ACTIONBAR_2"]

                if not (DFRL_FRAMEPOS and DFRL_FRAMEPOS["MultiBarBottomRight"]) then
                    MultiBarBottomRight:ClearAllPoints()
                    if bottomLeftState then
                        MultiBarBottomRight:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 10)
                    else
                        MultiBarBottomRight:SetPoint("BOTTOM", self.actionBarFrame, "TOP", 0, 10)
                    end
                end

                if self.newPetBar and not (DFRL_FRAMEPOS and DFRL_FRAMEPOS["DFRL_PetBar"]) then
                    self.newPetBar:ClearAllPoints()
                    if bottomLeftState and bottomRightState then
                        self.newPetBar:SetPoint("BOTTOM", MultiBarBottomRight, "TOP", 0, 9)
                    elseif bottomLeftState then
                        self.newPetBar:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 9)
                    elseif bottomRightState then
                        self.newPetBar:SetPoint("BOTTOM", MultiBarBottomRight, "TOP", 0, 9)
                    else
                        self.newPetBar:SetPoint("BOTTOM", self.actionBarFrame, "TOP", 0, 9)
                    end
                end

                if self.newShapeshiftBar and not (DFRL_FRAMEPOS and DFRL_FRAMEPOS["DFRL_ShapeshiftBar"]) then
                    self.newShapeshiftBar:ClearAllPoints()
                    if bottomLeftState and bottomRightState then
                        self.newShapeshiftBar:SetPoint("BOTTOM", MultiBarBottomRight, "TOP", 0, 9)
                    elseif bottomLeftState then
                        self.newShapeshiftBar:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 9)
                    elseif bottomRightState then
                        self.newShapeshiftBar:SetPoint("BOTTOM", MultiBarBottomRight, "TOP", 0, 9)
                    else
                        self.newShapeshiftBar:SetPoint("BOTTOM", self.actionBarFrame, "TOP", 0, 9)
                    end
                end
            end

            local updateTimer = 0
            local barPositionFrame = CreateFrame("Frame")
            barPositionFrame:RegisterEvent("CVAR_UPDATE")
            barPositionFrame:SetScript("OnEvent", function()
                updateTimer = 1
                barPositionFrame:SetScript("OnUpdate", function()
                    updateTimer = updateTimer - arg1
                    if updateTimer <= 0 then
                        RepositionBars()
                        barPositionFrame:SetScript("OnUpdate", nil)
                        DFRL.activeScripts["BarRepositionScript"] = false
                    else
                        DFRL.activeScripts["BarRepositionScript"] = true
                    end
                end)
            end)

            RepositionBars()
        end

        function Setup:MainBarBackground()
            self.actionBarBGleft = self.actionBarFrame:CreateTexture("DFRL_ActionBarLeftTexture", "BACKGROUND")
            self.actionBarBGleft:SetTexture(self.texpath .. "HDActionBar.tga")
            self.actionBarBGleft:SetPoint("LEFT", self.actionBarFrame, "LEFT", -6, 0)
            self.actionBarBGleft:SetPoint("RIGHT", self.actionBarFrame, "CENTER", 0, 0)
            self.actionBarBGleft:SetPoint("TOP", self.actionBarFrame, "TOP", 0, 14)
            self.actionBarBGleft:SetPoint("BOTTOM", self.actionBarFrame, "BOTTOM", 0, -14)

            self.actionBarBGright = self.actionBarFrame:CreateTexture("DFRL_ActionBarRightTexture", "BACKGROUND")
            self.actionBarBGright:SetTexture(self.texpath .. "HDActionBar.tga")
            self.actionBarBGright:SetPoint("LEFT", self.actionBarFrame, "CENTER", 0, 0)
            self.actionBarBGright:SetPoint("RIGHT", self.actionBarFrame, "RIGHT", 6, 0)
            self.actionBarBGright:SetPoint("TOP", self.actionBarFrame, "TOP", 0, 14)
            self.actionBarBGright:SetPoint("BOTTOM", self.actionBarFrame, "BOTTOM", 0, -14)
            self.actionBarBGright:SetTexCoord(1, 0, 0, 1)

        end

        function Setup:ButtonBackgroundsAndBorders()
            local buttonBgTexture = self.texpath .. "HDActionBarBtn.tga"
            local borderTexture = self.texpath .. "border.blp"

            for i = 1, 12 do
                local bgTexture = self.actionBarFrame:CreateTexture("DFRL_ActionButtonBg" .. i, "BORDER")
                bgTexture:SetTexture(buttonBgTexture)
                bgTexture:SetPoint("CENTER", _G["ActionButton" .. i], "CENTER", 0, 0)
                bgTexture:SetWidth(ActionButton1:GetWidth() + 5)
                bgTexture:SetHeight(ActionButton1:GetHeight() + 5)

                local borderTex = self.actionBarFrame:CreateTexture("DFRL_ActionButtonBorder" .. i, "BORDER")
                borderTex:SetTexture(borderTexture)
                borderTex:SetPoint("CENTER", _G["ActionButton" .. i], "CENTER", 0, 0)
                borderTex:SetWidth(ActionButton1:GetWidth() + 5)
                borderTex:SetHeight(ActionButton1:GetHeight() + 5)
            end
        end

        function Setup:ButtonBorderHighlight()
            local borderTexture = self.texpath .. "border.blp"
            local highlightTexture = self.texpath .. "uiactionbariconframehighlight.tga"

            for _, buttonType in ipairs(self.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button and not button.DFRL_BorderOverlay then
                        local overlayName = button:GetName() .. "DFRL_BorderOverlay"
                        local overlay = button:CreateTexture(overlayName, "OVERLAY")
                        overlay:SetTexture(borderTexture)
                        overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
                        overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
                        overlay:SetVertexColor(0.9, 0.9, 0.9, 1)
                        button.DFRL_BorderOverlay = overlay

                        button:SetHighlightTexture(highlightTexture)
                        local highlight = button:GetHighlightTexture()
                        highlight:SetAllPoints(button)
                        highlight:SetBlendMode("ADD")
                        overlay:Show()
                    end
                end
            end
        end

        function Setup:PositionMultiBars()
            MultiBarBottomLeft:ClearAllPoints()
            MultiBarBottomLeft:SetPoint("BOTTOM", self.actionBarFrame, "TOP", 0, 12)
            MultiBarBottomLeft:SetClampedToScreen(true)
            MultiBarBottomLeft:SetFrameStrata("LOW")
            MultiBarBottomLeft:SetFrameLevel(1)

            MultiBarBottomRight:ClearAllPoints()
            MultiBarBottomRight:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 10)
            MultiBarBottomRight:SetClampedToScreen(true)
            MultiBarBottomRight:SetFrameStrata("LOW")
            MultiBarBottomRight:SetFrameLevel(1)

            MultiBarRight:ClearAllPoints()
            MultiBarRight:SetPoint("RIGHT", UIParent, "RIGHT", -15, -50)
            MultiBarRight:SetClampedToScreen(true)
            MultiBarRight:SetFrameStrata("LOW")
            MultiBarRight:SetFrameLevel(1)

            MultiBarLeft:SetClampedToScreen(true)
            MultiBarLeft:SetFrameStrata("LOW")
            MultiBarLeft:SetFrameLevel(1)
        end

        function Setup:PetBar()
            self.newPetBar = CreateFrame("Frame", "DFRL_PetBar", UIParent)
            self.newPetBar:SetPoint("BOTTOM", self.actionBarFrame, "TOP", 0, 8)
            self.newPetBar:SetHeight(36)
            self.newPetBar:SetWidth(360)
            self.newPetBar:SetFrameStrata("LOW")
            self.newPetBar:SetFrameLevel(1)

            for i = 1, 10 do
                local button = _G["PetActionButton"..i]
                button:SetParent(self.newPetBar)
                button:ClearAllPoints()
                button:SetPoint("LEFT", self.newPetBar, "LEFT", (i-1)*36, 0)
            end

            self:PetBarAutoCastVisuals()
        end

        function Setup:PetBarAutoCastVisuals()
            if self.petBarAutoCastFrame then return end

            local function softenTexture(tex, alpha)
                if tex and tex.SetAlpha then
                    tex:SetAlpha(alpha)
                end
            end

            local function applyPetAutoCastLook()
                for i = 1, 10 do
                    local button = _G["PetActionButton" .. i]
                    if button then
                        local name = button:GetName()
                        local shine = button.Shine or _G[name .. "Shine"]
                        local autoCast = button.AutoCastable or _G[name .. "AutoCastable"]
                        local autoCast2 = button.AutoCast or _G[name .. "AutoCast"]

                        softenTexture(shine, 0.28)
                        softenTexture(autoCast, 0.40)
                        softenTexture(autoCast2, 0.40)
                    end
                end
            end

            self.petBarAutoCastFrame = CreateFrame("Frame")
            self.petBarAutoCastFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
            self.petBarAutoCastFrame:RegisterEvent("UNIT_PET")
            self.petBarAutoCastFrame:RegisterEvent("PET_BAR_UPDATE")
            self.petBarAutoCastFrame:RegisterEvent("PET_BAR_UPDATE_USABLE")
            self.petBarAutoCastFrame:RegisterEvent("PET_UI_UPDATE")
            self.petBarAutoCastFrame:SetScript("OnEvent", applyPetAutoCastLook)

            local elapsed = 0
            self.petBarAutoCastFrame:SetScript("OnUpdate", function()
                elapsed = elapsed + arg1
                if elapsed > 0.25 then
                    elapsed = 0
                    applyPetAutoCastLook()
                end
            end)

            applyPetAutoCastLook()
        end

        function Setup:ShapeshiftBar()
            self.newShapeshiftBar = CreateFrame("Frame", "DFRL_ShapeshiftBar", UIParent)
            self.newShapeshiftBar:SetPoint("BOTTOM", self.newPetBar, "TOP", 0, 8)
            self.newShapeshiftBar:SetHeight(36)
            self.newShapeshiftBar:SetWidth(360)
            self.newShapeshiftBar:SetFrameStrata("LOW")
            self.newShapeshiftBar:SetFrameLevel(1)

            for i = 1, 10 do
                local button = _G["ShapeshiftButton"..i]
                button:SetParent(self.newShapeshiftBar)
                button:ClearAllPoints()
                button:SetPoint("LEFT", self.newShapeshiftBar, "LEFT", (i-1)*43, 0)
            end
        end

        function Setup:BonusBarWatcher()
            local bonusBarWatcher = CreateFrame("Frame")
            bonusBarWatcher:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
            bonusBarWatcher:SetScript("OnEvent", function()
                local bonusBarActive = GetBonusBarOffset() > 0
                for i = 1, 12 do
                    if bonusBarActive then
                        _G["ActionButton"..i]:SetAlpha(0)
                        _G["ActionButton"..i]:EnableMouse(false)
                    else
                        -- ✅ PATCH: não forçar alpha quando Immersion estiver carregado
                        if not DFRL_IsImmersionLoaded() then
                            _G["ActionButton"..i]:SetAlpha(1)
                        end
                        _G["ActionButton"..i]:EnableMouse(true)
                    end
                end
            end)
        end

        function Setup:PagingButtons()
            self.pagingContainer = CreateFrame("Frame", "DFRL_PagingContainer", UIParent)
            self.pagingContainer:SetWidth(ActionBarUpButton:GetWidth())
            self.pagingContainer:SetHeight(65)
            self.pagingContainer:SetPoint("LEFT", ActionButton12, "RIGHT", 15, -1)
            self.pagingContainer:SetFrameStrata("MEDIUM")
            self.pagingContainer:SetFrameLevel(5)

            ActionBarUpButton:SetNormalTexture(self.texpath.. "page_up_normal.tga")
            ActionBarUpButton:SetPushedTexture(self.texpath.. "page_up_pushed.tga")
            ActionBarUpButton:SetHighlightTexture(self.texpath.. "page_up_highlight.tga")

            ActionBarDownButton:SetNormalTexture(self.texpath.. "page_down_normal.tga")
            ActionBarDownButton:SetPushedTexture(self.texpath.. "page_down_pushed.tga")
            ActionBarDownButton:SetHighlightTexture(self.texpath.. "page_down_highlight.tga")

            ActionBarUpButton:ClearAllPoints()
            ActionBarUpButton:SetPoint("TOP", self.pagingContainer, "TOP", -1, 0)
            ActionBarUpButton:SetFrameStrata("MEDIUM")
            ActionBarUpButton:SetFrameLevel(6)
            ActionBarUpButton:SetHeight(25)
            ActionBarUpButton:SetWidth(25)

            MainMenuBarPageNumber:ClearAllPoints()
            MainMenuBarPageNumber:SetParent(self.pagingContainer)
            MainMenuBarPageNumber:SetPoint("CENTER", self.pagingContainer, "CENTER", -1, 1)

            ActionBarDownButton:ClearAllPoints()
            ActionBarDownButton:SetPoint("BOTTOM", self.pagingContainer, "BOTTOM", 1, 0)
            ActionBarDownButton:SetFrameStrata("MEDIUM")
            ActionBarDownButton:SetFrameLevel(6)
            ActionBarDownButton:SetHeight(25)
            ActionBarDownButton:SetWidth(25)
        end

        function Setup:HotkeyMacroText()
            local config = self.texts.config

            local commandMap = {
                ["ActionButton"] = "ACTIONBUTTON",
                ["MultiBarBottomLeftButton"] = "MULTIACTIONBAR1BUTTON",
                ["MultiBarBottomRightButton"] = "MULTIACTIONBAR2BUTTON",
                ["MultiBarRightButton"] = "MULTIACTIONBAR3BUTTON",
                ["MultiBarLeftButton"] = "MULTIACTIONBAR4BUTTON",
                ["BonusActionButton"] = "ACTIONBUTTON",
                ["ShapeshiftButton"] = "SHAPESHIFTBUTTON",
                ["PetActionButton"] = "BONUSACTIONBUTTON"
            }

            local function UpdateHotkeys()
                for _, buttonType in ipairs(Setup.buttonTypes) do
                    for i = 1, 12 do
                        local button = _G[buttonType .. i]
                        if button and button.DFRL_KeybindText then
                            local key1 = GetBindingKey(commandMap[buttonType] .. i)
                            if key1 then
                                key1 = string.gsub(key1, "BUTTON", "M")
                                key1 = string.gsub(key1, "SHIFT%-", "S-")
                                key1 = string.gsub(key1, "CTRL%-", "C-")
                                key1 = string.gsub(key1, "ALT%-", "A-")
                                key1 = string.gsub(key1, "SPACE", "SP")
                                key1 = string.gsub(key1, "NUMPAD", "NP-")
                                key1 = string.gsub(key1, "MOUSEWHEELUP", "MWU")
                                key1 = string.gsub(key1, "MOUSEWHEELDOWN", "MWD")
                                button.DFRL_KeybindText:SetText(key1)
                            else
                                button.DFRL_KeybindText:SetText("")
                            end
                        end
                    end
                end
            end

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button then
                        local hotkey = _G[button:GetName() .. "HotKey"]
                        if hotkey then
                            hotkey:Hide()
                        end

                        local keybindText = button:CreateFontString(button:GetName() .. "DFRL_KeybindText", "OVERLAY")
                        keybindText:SetPoint("BOTTOM", button, "BOTTOM", 0, -2)
                        keybindText:SetFont(config.font, config.hotkeyFontSize, config.outline)
                        keybindText:SetTextColor(unpack(config.hotkeyColor))
                        button.DFRL_KeybindText = keybindText

                        local macroName = _G[button:GetName() .. "Name"]
                        if macroName then
                            macroName:SetFont(config.font, config.macroFontSize, config.outline)
                            macroName:SetTextColor(unpack(config.macroColor))
                        end
                    end
                end
            end

            if not self.hotkeyBindingFrame then
                self.hotkeyBindingFrame = CreateFrame("Frame", "DFRL_HotkeyBinding")
                self.hotkeyBindingFrame:RegisterEvent("UPDATE_BINDINGS")
                self.hotkeyBindingFrame:SetScript("OnEvent", function()
                    UpdateHotkeys()
                end)
            end

            UpdateHotkeys()
        end

        function Setup:Gryphoons()
            self.gryphonContainer = CreateFrame("Frame", "DFRL_GryphonContainer", UIParent)
            self.gryphonContainer:SetFrameStrata("LOW")
            self.gryphonContainer:SetFrameLevel(3)
            self.gryphonContainer:SetAllPoints(self.actionBarFrame)

            self.leftGryphon = self.gryphonContainer:CreateTexture("DFRL_LeftGryphon", "OVERLAY")
            self.rightGryphon = self.gryphonContainer:CreateTexture("DFRL_RightGryphon", "OVERLAY")

            self.leftGryphon:SetPoint("RIGHT", self.actionBarFrame, "LEFT", 45, 10)
            self.rightGryphon:SetPoint("LEFT", self.actionBarFrame, "RIGHT", -45, 10)

            local faction = UnitFactionGroup("player")
            local texturePath
            if faction == "Alliance" then
                texturePath = self.texpath .. "GryphonNew.tga"
            else
                texturePath = self.texpath .. "WyvernNew.tga"
            end

            self.leftGryphon:SetTexture(texturePath)
            self.rightGryphon:SetTexture(texturePath)

            self.leftGryphon:SetWidth(180)
            self.leftGryphon:SetHeight(180)
            self.rightGryphon:SetWidth(180)
            self.rightGryphon:SetHeight(180)

            self.rightGryphon:SetTexCoord(1, 0, 0, 1)
        end

        function Setup:Run()
            self:HideBlizzard()
            self:MainBarFrames()
            self:PositionMultiBars()
            self:PetBar()
            self:ShapeshiftBar()
            self:BonusBarWatcher()
            self:ButtonBorderHighlight()
            self:PagingButtons()
            self:MainBarBackground()
            self:ButtonBackgroundsAndBorders()
            self:HotkeyMacroText()
            self:Gryphoons()
        end

        Setup:Run()

        -- expose
        DFRL.mainBar = Setup.mainBar
        DFRL.actionBarFrame = Setup.actionBarFrame
        DFRL.newPetBar = Setup.newPetBar
        DFRL.newShapeshiftBar = Setup.newShapeshiftBar
        DFRL.pagingContainer = Setup.pagingContainer
        DFRL.actionBarBGleft = Setup.actionBarBGleft
        DFRL.actionBarBGright = Setup.actionBarBGright

        -- callbacks
        local callbacks = {}
        local helpers = {
            getFontPath = function(fontName)
                if fontName == 'Expressway' then
                    return 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Expressway.ttf'
                elseif fontName == 'Homespun' then
                    return 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Homespun.ttf'
                elseif fontName == 'Hooge' then
                    return 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Hooge.ttf'
                elseif fontName == 'Myriad-Pro' then
                    return 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Myriad-Pro.ttf'
                elseif fontName == 'Prototype' then
                    return 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Prototype.ttf'
                elseif fontName == 'PT-Sans-Narrow-Bold' then
                    return 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\PT-Sans-Narrow-Bold.ttf'
                elseif fontName == 'PT-Sans-Narrow-Regular' then
                    return 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\PT-Sans-Narrow-Regular.ttf'
                elseif fontName == 'RobotoMono' then
                    return 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\RobotoMono.ttf'
                elseif fontName == 'BigNoodleTitling' then
                    return 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\BigNoodleTitling.ttf'
                elseif fontName == 'Continuum' then
                    return 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Continuum.ttf'
                elseif fontName == 'DieDieDie' then
                    return 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\DieDieDie.ttf'
                else
                    return 'Fonts\\FRIZQT__.TTF'
                end
            end,

            setGridLayout = function(barFrame, buttonPrefix, value, spacingKey, maxButtons)
                maxButtons = maxButtons or 12
                local layoutIndex = math.floor(value + 0.5)
                if layoutIndex < 1 then layoutIndex = 1 end
                if layoutIndex > 6 then layoutIndex = 6 end
                local layout = Setup.layouts[layoutIndex]
                if not layout then return end

                local spacing = DFRL:GetTempDB('Bars', spacingKey)
                local firstButton = _G[buttonPrefix .. '1']
                if not firstButton then return end
                local buttonSize = firstButton:GetWidth()
                local isReversed = buttonPrefix == 'MultiBarLeftButton' or buttonPrefix == 'MultiBarRightButton'
                local isPetBar = buttonPrefix == 'PetActionButton'
                local effectiveCols = math.min(layout.cols, maxButtons)
                local effectiveRows = math.ceil(maxButtons / effectiveCols)

                for i = (isReversed and maxButtons or 1), (isReversed and 1 or maxButtons), (isReversed and -1 or 1) do
                    local button = _G[buttonPrefix .. i]
                    if button then
                        button:ClearAllPoints()
                        local index = isReversed and (maxButtons + 1 - i) or i
                        local row = math.floor((index - 1) / effectiveCols)
                        local col = (index - 1) - (row * effectiveCols)

                        if isPetBar and effectiveRows > 1 then
                            button:SetPoint('TOPLEFT', barFrame, 'TOPLEFT', col * (buttonSize + spacing), -row * (buttonSize + spacing))
                        else
                            button:SetPoint('BOTTOMLEFT', barFrame, 'BOTTOMLEFT', col * (buttonSize + spacing), row * (buttonSize + spacing))
                        end
                    end
                end

                barFrame:SetHeight((buttonSize + spacing) * effectiveRows - spacing)
                barFrame:SetWidth((buttonSize + spacing) * effectiveCols - spacing)
            end,

            iterateButtons = function(callback)
                for _, buttonType in ipairs(Setup.buttonTypes) do
                    for i = 1, 12 do
                        local button = _G[buttonType .. i]
                        if button then
                            callback(button, buttonType, i)
                        end
                    end
                end
            end,

            setSpacing = function(buttonPrefix, spacing, direction, maxButtons)
                maxButtons = maxButtons or 12
                for i = 2, maxButtons do
                    local button = _G[buttonPrefix .. i]
                    if button then
                        button:ClearAllPoints()
                        if direction == 'vertical' then
                            button:SetPoint('TOP', _G[buttonPrefix .. (i-1)], 'BOTTOM', 0, -spacing)
                        else
                            button:SetPoint('LEFT', _G[buttonPrefix .. (i-1)], 'RIGHT', spacing, 0)
                        end
                    end
                end
            end
        }

        


        callbacks.multiBarOneScale = function(value)
            MultiBarBottomLeft:SetScale(value)
        end

        callbacks.multiBarOneSpacing = function(value)
            helpers.setSpacing('MultiBarBottomLeftButton', value)
        end

        callbacks.multiBarOneAlpha = function(value)
            MultiBarBottomLeft:SetAlpha(value)
        end

        callbacks.multiBarTwoScale = function(value)
            MultiBarBottomRight:SetScale(value)
        end

        callbacks.multiBarTwoSpacing = function(value)
            local gridLayout = DFRL:GetTempDB('Bars', 'multiBarTwoGrid')
            if math.floor(gridLayout + 0.5) ~= 1 then return end
            helpers.setSpacing('MultiBarBottomRightButton', value)
        end

        callbacks.multiBarTwoAlpha = function(value)
            MultiBarBottomRight:SetAlpha(value)
        end

        callbacks.multiBarThreeScale = function(value)
            MultiBarLeft:SetScale(value)
        end

        callbacks.multiBarThreeSpacing = function(value)
            helpers.setSpacing('MultiBarLeftButton', value, 'vertical')
        end

        callbacks.multiBarThreeAlpha = function(value)
            MultiBarLeft:SetAlpha(value)
        end

        callbacks.multiBarFourScale = function(value)
            MultiBarRight:SetScale(value)
        end

        callbacks.multiBarFourSpacing = function(value)
            helpers.setSpacing('MultiBarRightButton', value, 'vertical')
        end

        callbacks.multiBarFourAlpha = function(value)
            MultiBarRight:SetAlpha(value)
        end

        callbacks.gryphoonScale = function(value)
            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]

            if leftGryphon then
                leftGryphon:SetWidth(180 * value)
                leftGryphon:SetHeight(180 * value)
            end

            if rightGryphon then
                rightGryphon:SetWidth(180 * value)
                rightGryphon:SetHeight(180 * value)
            end
        end

        callbacks.showGryphoon = function(value)
            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]

            if leftGryphon then
                if value then
                    leftGryphon:Show()
                else
                    leftGryphon:Hide()
                end
            end

            if rightGryphon then
                if value then
                    rightGryphon:Show()
                else
                    rightGryphon:Hide()
                end
            end
        end

        callbacks.gryphoonX = function(value)
            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]
            local yOffset = DFRL:GetTempDB("Bars", "gryphoonY")

            if leftGryphon then
                leftGryphon:ClearAllPoints()
                leftGryphon:SetPoint("RIGHT", DFRL.actionBarFrame, "LEFT", -value, yOffset)
            end

            if rightGryphon then
                rightGryphon:ClearAllPoints()
                rightGryphon:SetPoint("LEFT", DFRL.actionBarFrame, "RIGHT", value, yOffset)
            end
        end

        callbacks.gryphoonY = function(value)
            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]
            local xOffset = DFRL:GetTempDB("Bars", "gryphoonX")

            if leftGryphon then
                leftGryphon:ClearAllPoints()
                leftGryphon:SetPoint("RIGHT", DFRL.actionBarFrame, "LEFT", -xOffset, value)
            end

            if rightGryphon then
                rightGryphon:ClearAllPoints()
                rightGryphon:SetPoint("LEFT", DFRL.actionBarFrame, "RIGHT", xOffset, value)
            end
        end

        callbacks.gryphoonAlpha = function(value)
            local leftGryphon = _G['DFRL_LeftGryphon']
            local rightGryphon = _G['DFRL_RightGryphon']

            if leftGryphon then
                leftGryphon:SetAlpha(value)
            end

            if rightGryphon then
                rightGryphon:SetAlpha(value)
            end
        end

        callbacks.barsDarkMode = function(value)
            local intensity = DFRL:GetTempDB("Bars", "barsDarkMode")
            local barsColor = DFRL:GetTempDB("Bars", "barsColor")
            local r, g, b = barsColor[1] * (1 - intensity), barsColor[2] * (1 - intensity), barsColor[3] * (1 - intensity)
            local color = value and {r, g, b} or {1, 1, 1}

            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]
            if leftGryphon then leftGryphon:SetVertexColor(color[1], color[2], color[3]) end
            if rightGryphon then rightGryphon:SetVertexColor(color[1], color[2], color[3]) end

            local leftTexture = _G["DFRL_ActionBarLeftTexture"]
            local rightTexture = _G["DFRL_ActionBarRightTexture"]
            if leftTexture then leftTexture:SetVertexColor(color[1], color[2], color[3]) end
            if rightTexture then rightTexture:SetVertexColor(color[1], color[2], color[3]) end

            for i = 1, 12 do
                local borderTex = _G["DFRL_ActionButtonBorder" .. i]
                if borderTex then borderTex:SetVertexColor(color[1], color[2], color[3]) end
            end

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button then
                        local overlay = _G[button:GetName() .. "DFRL_BorderOverlay"]
                        if overlay then overlay:SetVertexColor(color[1], color[2], color[3]) end
                    end
                end
            end
        end

        callbacks.barsColor = function(value)
            local intensity = DFRL:GetTempDB("Bars", "barsDarkMode")
            local r, g, b = value[1] * (1 - intensity), value[2] * (1 - intensity), value[3] * (1 - intensity)

            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]
            if leftGryphon then leftGryphon:SetVertexColor(r, g, b) end
            if rightGryphon then rightGryphon:SetVertexColor(r, g, b) end

            local leftTexture = _G["DFRL_ActionBarLeftTexture"]
            local rightTexture = _G["DFRL_ActionBarRightTexture"]
            if leftTexture then leftTexture:SetVertexColor(r, g, b) end
            if rightTexture then rightTexture:SetVertexColor(r, g, b) end

            for i = 1, 12 do
                local borderTex = _G["DFRL_ActionButtonBorder" .. i]
                if borderTex then borderTex:SetVertexColor(r, g, b) end
            end

            for _, buttonType in ipairs(Setup.buttonTypes) do
                for i = 1, 12 do
                    local button = _G[buttonType .. i]
                    if button then
                        local overlay = _G[button:GetName() .. "DFRL_BorderOverlay"]
                        if overlay then overlay:SetVertexColor(r, g, b) end
                    end
                end
            end
        end

        callbacks.pagingShow = function(value)
            if DFRL.pagingContainer then
                if value then
                    DFRL.pagingContainer:Show()
                    ActionBarUpButton:Show()
                    ActionBarDownButton:Show()
                    MainMenuBarPageNumber:Show()
                else
                    DFRL.pagingContainer:Hide()
                    ActionBarUpButton:Hide()
                    ActionBarDownButton:Hide()
                    MainMenuBarPageNumber:Hide()
                end
            end
        end

        callbacks.pagingScale = function(value)
            DFRL.pagingContainer:SetScale(value)
        end

        callbacks.hotkeyColour = function(value)
            local r, g, b = unpack(value)
            helpers.iterateButtons(function(button)
                if button.DFRL_KeybindText then
                    button.DFRL_KeybindText:SetTextColor(r, g, b)
                end
            end)
        end

        callbacks.hotkeyShow = function(value)
            helpers.iterateButtons(function(button)
                if button.DFRL_KeybindText then
                    if value then
                        button.DFRL_KeybindText:Show()
                    else
                        button.DFRL_KeybindText:Hide()
                    end
                end
            end)
        end

        callbacks.hotkeyScale = function(value)
            local fontPath = helpers.getFontPath(DFRL:GetTempDB('Bars', 'hotkeyFont'))
            helpers.iterateButtons(function(button)
                if button.DFRL_KeybindText then
                    button.DFRL_KeybindText:SetFont(fontPath, 10 * value, 'OUTLINE')
                end
            end)
        end

        callbacks.hotkeyX = function(value)
            local yOffset = DFRL.tempDB['Bars']['hotkeyY']
            helpers.iterateButtons(function(button)
                if button.DFRL_KeybindText then
                    button.DFRL_KeybindText:ClearAllPoints()
                    button.DFRL_KeybindText:SetPoint('BOTTOM', button, 'BOTTOM', value, yOffset)
                end
            end)
        end

        callbacks.hotkeyY = function(value)
            local xOffset = DFRL.tempDB['Bars']['hotkeyX']
            helpers.iterateButtons(function(button)
                if button.DFRL_KeybindText then
                    button.DFRL_KeybindText:ClearAllPoints()
                    button.DFRL_KeybindText:SetPoint('BOTTOM', button, 'BOTTOM', xOffset, value)
                end
            end)
        end

        callbacks.macroColour = function(value)
            local r, g, b = unpack(value)
            helpers.iterateButtons(function(button)
                local macroName = _G[button:GetName() .. 'Name']
                if macroName then
                    macroName:SetTextColor(r, g, b)
                end
            end)
        end

        callbacks.macroShow = function(value)
            helpers.iterateButtons(function(button)
                local macroName = _G[button:GetName() .. 'Name']
                if macroName then
                    if value then
                        macroName:Show()
                    else
                        macroName:Hide()
                    end
                end
            end)
        end

        callbacks.macroScale = function(value)
            local fontPath = helpers.getFontPath(DFRL:GetTempDB('Bars', 'hotkeyFont'))
            helpers.iterateButtons(function(button)
                local macroName = _G[button:GetName() .. 'Name']
                if macroName then
                    macroName:SetFont(fontPath, 9 * value, 'OUTLINE')
                end
            end)
        end

        callbacks.macroX = function(value)
            local yOffset = DFRL.tempDB['Bars']['macroY']
            helpers.iterateButtons(function(button)
                local macroName = _G[button:GetName() .. 'Name']
                if macroName then
                    macroName:ClearAllPoints()
                    macroName:SetPoint('TOP', button, 'TOP', value, yOffset)
                end
            end)
        end

        callbacks.macroY = function(value)
            local xOffset = DFRL.tempDB['Bars']['macroX']
            helpers.iterateButtons(function(button)
                local macroName = _G[button:GetName() .. 'Name']
                if macroName then
                    macroName:ClearAllPoints()
                    macroName:SetPoint('TOP', button, 'TOP', xOffset, value)
                end
            end)
        end

        callbacks.petbarScale = function(value)
            if DFRL.newPetBar then
                DFRL.newPetBar:SetScale(value)
            end
        end

        callbacks.shapeshiftScale = function(value)
            if DFRL.newShapeshiftBar then
                DFRL.newShapeshiftBar:SetScale(value)
            end
        end

        callbacks.petbarSpacing = function(value)
            local gridLayout = DFRL:GetTempDB('Bars', 'petbarGrid')
            if math.floor(gridLayout + 0.5) ~= 1 then
                helpers.setGridLayout(DFRL.newPetBar, 'PetActionButton', gridLayout, 'petbarSpacing', 10)
                return
            end
            helpers.setSpacing('PetActionButton', value, 'horizontal', 10)
            if DFRL.newPetBar and PetActionButton1 then
                local buttonSize = PetActionButton1:GetWidth()
                DFRL.newPetBar:SetWidth((buttonSize + value) * 10 - value)
                DFRL.newPetBar:SetHeight(buttonSize)
            end
        end

        callbacks.petbarAlpha = function(value)
            if DFRL.newPetBar then
                DFRL.newPetBar:SetAlpha(value)
            end
        end

        callbacks.shapeshiftSpacing = function(value)
            helpers.setSpacing('ShapeshiftButton', value, 'horizontal', 10)
        end

        callbacks.shapeshiftAlpha = function(value)
            if DFRL.newShapeshiftBar then
                DFRL.newShapeshiftBar:SetAlpha(value)
            end
        end

        callbacks.flipGryphoon = function (value)
            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]

            if value then
                leftGryphon:SetTexCoord(1, 0, 0, 1)
                rightGryphon:SetTexCoord(0, 1, 0, 1)
            else
                leftGryphon:SetTexCoord(0, 1, 0, 1)
                rightGryphon:SetTexCoord(1, 0, 0, 1)
            end
        end

        callbacks.altGryphoon = function(value)
            local leftGryphon = _G["DFRL_LeftGryphon"]
            local rightGryphon = _G["DFRL_RightGryphon"]

            local faction = UnitFactionGroup("player")
            local texturePath

            if value then
                if faction == "Alliance" then
                    texturePath = Setup.texpath.. "altGyph.tga"
                else
                    texturePath = Setup.texpath.. "altWyv.tga"
                end
            else
                if faction == "Alliance" then
                    texturePath = Setup.texpath.. "GryphonNew.tga"
                else
                    texturePath = Setup.texpath.. "WyvernNew.tga"
                end
            end

            if leftGryphon and rightGryphon then
                leftGryphon:SetTexture(texturePath)
                rightGryphon:SetTexture(texturePath)

                -- maintain flip
                local isFlipped = DFRL:GetTempDB("Bars", "flipGryphoon")
                if isFlipped then
                    leftGryphon:SetTexCoord(1, 0, 0, 1)
                    rightGryphon:SetTexCoord(0, 1, 0, 1)
                else
                    leftGryphon:SetTexCoord(0, 1, 0, 1)
                    rightGryphon:SetTexCoord(1, 0, 0, 1)
                end
            end
        end

        callbacks.pagingSwap = function(value)
            if DFRL.pagingContainer then
                DFRL.pagingContainer:ClearAllPoints()
                if value then
                    DFRL.pagingContainer:SetPoint("RIGHT", ActionButton1, "LEFT", -15, -1)
                else
                    DFRL.pagingContainer:SetPoint("LEFT", ActionButton12, "RIGHT", 15, -1)
                end
            end
        end

        callbacks.pagingX = function(value)
            if DFRL.pagingContainer then
                local isSwapped = DFRL:GetTempDB("Bars", "pagingSwap")
                DFRL.pagingContainer:ClearAllPoints()
                if isSwapped then
                    DFRL.pagingContainer:SetPoint("RIGHT", ActionButton1, "LEFT", -value, -1)
                else
                    DFRL.pagingContainer:SetPoint("LEFT", ActionButton12, "RIGHT", value, -1)
                end
            end
        end

        callbacks.multiBarOneGrid = function(value)
            helpers.setGridLayout(MultiBarBottomLeft, 'MultiBarBottomLeftButton', value, 'multiBarOneSpacing')
        end

        callbacks.multiBarTwoGrid = function(value)
            if not MultiBarBottomRight then return end
            helpers.setGridLayout(MultiBarBottomRight, 'MultiBarBottomRightButton', value, 'multiBarTwoSpacing')
        end

        callbacks.multiBarThreeGrid = function(value)
            helpers.setGridLayout(MultiBarLeft, 'MultiBarLeftButton', value, 'multiBarThreeSpacing')
        end

        callbacks.multiBarFourGrid = function(value)
            helpers.setGridLayout(MultiBarRight, 'MultiBarRightButton', value, 'multiBarFourSpacing')
        end

        callbacks.petbarGrid = function(value)
            if not DFRL.newPetBar then return end
            helpers.setGridLayout(DFRL.newPetBar, 'PetActionButton', value, 'petbarSpacing', 10)
        end

        callbacks.mainBarScale = function(value)
            DFRL.mainBar:SetScale(value)
            DFRL.actionBarFrame:SetScale(value)

            for i = 1, 12 do
                local button = _G["ActionButton"..i]
                button:SetScale(value)

                local bonusButton = _G["BonusActionButton"..i]
                bonusButton:SetScale(value)

                if i > 1 then
                    button:ClearAllPoints()
                    button:SetPoint("LEFT", _G["ActionButton"..(i-1)], "RIGHT", 6, 0)

                    bonusButton:ClearAllPoints()
                    bonusButton:SetPoint("LEFT", _G["BonusActionButton"..(i-1)], "RIGHT", 6, 0)
                end
            end
        end

        callbacks.mainBarSpacing = function(value)
            local gridLayout = DFRL:GetTempDB('Bars', 'mainBarGrid')
            if math.floor(gridLayout + 0.5) ~= 1 then return end
            
            local buttonSize = ActionButton1:GetWidth()

            for i = 2, 12 do
                local button = _G["ActionButton"..i]
                button:ClearAllPoints()
                button:SetPoint("LEFT", _G["ActionButton"..(i-1)], "RIGHT", value, 0)

                local bonusButton = _G["BonusActionButton"..i]
                bonusButton:ClearAllPoints()
                bonusButton:SetPoint("LEFT", _G["BonusActionButton"..(i-1)], "RIGHT", value, 0)
            end

            local totalWidth = (buttonSize * 12) + (value * 11)
            DFRL.mainBar:SetWidth(totalWidth)
            DFRL.actionBarFrame:SetWidth(totalWidth)
        end

        callbacks.mainBarAlpha = function(value)
            DFRL.mainBar:SetAlpha(value)
            DFRL.actionBarFrame:SetAlpha(value)

            for i = 1, 12 do
                local button = _G["ActionButton"..i]
                button:SetAlpha(value)

                local bonusButton = _G["BonusActionButton"..i]
                bonusButton:SetAlpha(value)
            end
        end

        callbacks.mainBarBG = function(value)
            local gridLayout = DFRL:GetTempDB('Bars', 'mainBarGrid')
            local layoutIndex = math.floor(gridLayout + 0.5)
            local showBG = value and layoutIndex == 1

            if DFRL.actionBarBGleft then
                if showBG then
                    DFRL.actionBarBGleft:Show()
                else
                    DFRL.actionBarBGleft:Hide()
                end
            end

            if DFRL.actionBarBGright then
                if showBG then
                    DFRL.actionBarBGright:Show()
                else
                    DFRL.actionBarBGright:Hide()
                end
            end
        end

        callbacks.hotkeyFont = function(value)
            local fontPath = helpers.getFontPath(value)
            helpers.iterateButtons(function(button, buttonType, i)
                if button.DFRL_KeybindText then
                    button.DFRL_KeybindText:SetFont(fontPath, 10 * DFRL:GetTempDB('Bars', 'hotkeyScale'), 'OUTLINE')
                end
                local macroName = _G[buttonType .. i .. 'Name']
                if macroName then
                    macroName:SetFont(fontPath, 10 * DFRL:GetTempDB('Bars', 'macroScale'), 'OUTLINE')
                end
            end)
        end

        callbacks.multiBarOneShow = function(value)
            if value then
                MultiBarBottomLeft:Show()
                _G["SHOW_MULTI_ACTIONBAR_1"] = 1
                Setup:RepositionBars()
            else
                MultiBarBottomLeft:Hide()
                _G["SHOW_MULTI_ACTIONBAR_1"] = nil
                Setup:RepositionBars()
            end
        end

        callbacks.multiBarTwoShow = function(value)
            if value then
                MultiBarBottomRight:Show()
                _G["SHOW_MULTI_ACTIONBAR_2"] = 1
                Setup:RepositionBars()
            else
                MultiBarBottomRight:Hide()
                _G["SHOW_MULTI_ACTIONBAR_2"] = nil
                Setup:RepositionBars()
            end
        end

        callbacks.multiBarThreeShow = function(value)
            if value then
                MultiBarLeft:Show()
                _G["SHOW_MULTI_ACTIONBAR_3"] = 1
            else
                MultiBarLeft:Hide()
                _G["SHOW_MULTI_ACTIONBAR_3"] = nil
            end
        end

        callbacks.multiBarFourShow = function(value)
            if value then
                MultiBarRight:Show()
                _G["SHOW_MULTI_ACTIONBAR_4"] = 1
            else
                MultiBarRight:Hide()
                _G["SHOW_MULTI_ACTIONBAR_4"] = nil
            end
        end

        callbacks.highlightColor = function(value)
            Setup.hightlightColor = value
            helpers.iterateButtons(function(button)
                local highlight = button:GetHighlightTexture()
                if highlight then
                    highlight:SetVertexColor(unpack(value))
                end
            end)
        end

        callbacks.mainBarGrid = function(value)
            if not ActionButton1 or not DFRL.mainBar then return end
            local layoutIndex = math.floor(value + 0.5)
            if layoutIndex < 1 then layoutIndex = 1 end
            if layoutIndex > 6 then layoutIndex = 6 end
            local layout = Setup.layouts[layoutIndex]
            if not layout then return end

            local spacing = DFRL:GetTempDB('Bars', 'mainBarSpacing')
            local buttonSize = ActionButton1:GetWidth()

            for i = 1, 12 do
                local button = _G['ActionButton' .. i]
                local bonusButton = _G['BonusActionButton' .. i]
                if button then
                    button:ClearAllPoints()
                    local row = math.floor((i - 1) / layout.cols)
                    local col = (i - 1) - (row * layout.cols)
                    button:SetPoint('BOTTOMLEFT', DFRL.mainBar, 'BOTTOMLEFT', col * (buttonSize + spacing), row * (buttonSize + spacing))
                end
                if bonusButton then
                    bonusButton:ClearAllPoints()
                    local row = math.floor((i - 1) / layout.cols)
                    local col = (i - 1) - (row * layout.cols)
                    bonusButton:SetPoint('BOTTOMLEFT', DFRL.mainBar, 'BOTTOMLEFT', col * (buttonSize + spacing), row * (buttonSize + spacing))
                end
            end

            local newWidth = (buttonSize + spacing) * layout.cols - spacing
            local newHeight = (buttonSize + spacing) * layout.rows - spacing
            DFRL.mainBar:SetWidth(newWidth)
            DFRL.mainBar:SetHeight(newHeight)
            DFRL.actionBarFrame:SetWidth(newWidth)
            DFRL.actionBarFrame:SetHeight(newHeight)

            if layoutIndex == 1 then
                if DFRL.actionBarBGleft then DFRL.actionBarBGleft:Show() end
                if DFRL.actionBarBGright then DFRL.actionBarBGright:Show() end
            else
                if DFRL.actionBarBGleft then DFRL.actionBarBGleft:Hide() end
                if DFRL.actionBarBGright then DFRL.actionBarBGright:Hide() end
            end

            local leftGryphon = _G['DFRL_LeftGryphon']
            local rightGryphon = _G['DFRL_RightGryphon']
            local xOffset = DFRL:GetTempDB('Bars', 'gryphoonX')
            local yOffset = DFRL:GetTempDB('Bars', 'gryphoonY')

            if leftGryphon then
                leftGryphon:ClearAllPoints()
                leftGryphon:SetPoint('RIGHT', ActionButton1, 'LEFT', -xOffset, yOffset)
            end

            if rightGryphon then
                rightGryphon:ClearAllPoints()
                local rightCornerButton = _G['ActionButton' .. layout.cols]
                rightGryphon:SetPoint('LEFT', rightCornerButton, 'RIGHT', xOffset, yOffset)
            end
        end

        DFRL.activeScripts["BarRepositionScript"] = false

        -- execute callbacks
        DFRL:NewCallbacks("Bars", callbacks)

        _G["MultiActionBar_Update"] = function() end

        local checkboxes = {33, 34, 35, 36}
        for i = 1, 4 do
            local checkbox = _G["UIOptionsFrameCheckButton" .. checkboxes[i]]
            if checkbox then
                checkbox:Hide()
            end
        end
    end)
end)
