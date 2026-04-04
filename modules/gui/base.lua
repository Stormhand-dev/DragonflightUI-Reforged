DFRL:NewDefaults("Gui-base", {
    enabled = {true},
})

DFRL:NewMod("Gui-base", 2, function()
    local GetTime = GetTime
    local GetFramerate = GetFramerate

    local Setup = {
        font = DFRL:GetInfoOrCons("font"),
        path = DFRL:GetInfoOrCons("media"),

        CONSTANTS = {
            MAIN_FRAME_WIDTH = 980,
            MAIN_FRAME_HEIGHT = 640,
            TAB_FRAME_WIDTH = 150,
            TITLE_FRAME_HEIGHT = 30,
            SUB_FRAME_HEIGHT = 30,
            SUB_FRAME_WIDTH = 460,
            TAB_BUTTON_HEIGHT = 32,
            TAB_BUTTON_WIDTH = 136,

            LEFT_PANEL_RATIO = 1.5,
            RIGHT_PANEL_RATIO = 3,
            BACKGROUND_ALPHA = 0.9,
            RIGHT_TEX_DIMMED_ALPHA = 0.55,

            TAB_VERTICAL_SPACING = 33,
            TAB_GROUP_SEPARATOR = 20,
            TITLE_FRAME_OFFSET = 200,
            SUB_FRAME_OFFSET = 20,

            FADE_DURATION = 0.2,
            PULSE_UPDATE_INTERVAL = 0.01,
            PULSE_MIN_ALPHA = 0.1,
            PULSE_ALPHA_STEP = 0.02,

            TITLE_FONT_SIZE = 18,
            TAB_FONT_SIZE = 15,

            SCROLL_SPEED = 15,
            SCROLL_STEP_SIZE = 250,
        },

        mainFrame = nil,
        tabFrame = nil,
        titleFrame = nil,
        subFrame = nil,
        scrollFrame = nil,
        rightTex = nil,
        selectedTab = 1,
        tabButtons = {},
        fadeFrame = nil,
        slider = nil,
        scrollChildren = {},
        panelTitle = nil,
        eventFrame = nil,
        reloadFrame = nil,
        reloadFont = nil,
        reloadBtn = nil,

        targetScroll = 0,
        currentScroll = 0,
        isScrolling = false,
        scrollRange = 0,

        fadeTargetAlpha = 0,
        fadeCurrentAlpha = 0,
        fadeStartTime = 0,
        panelFading = false,

        tabs = {
            [1] = "Home",
            [2] = "Info",
            [3] = "Profiles",
            [4] = "Modules",
            [5] = "ShaguTweaks",

            [6] = "Actionbars",
            [7] = "Bags",
            [8] = "Castbar",
            [9] = "Chat",
            [10] = "Interface",
            [11] = "Micromenu",
            [12] = "Minimap",
            [13] = "Third Party",
            [14] = "Unitframes",
            [15] = "Xprep",
        }
    }

    function Setup:ApplyPanelStyle(frame, alpha)
        if not frame then return end
        frame:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 8, edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        frame:SetBackdropColor(0, 0, 0, alpha or self.CONSTANTS.BACKGROUND_ALPHA)
        frame:SetBackdropBorderColor(1, 0.82, 0, 0.35)
    end

    function Setup:StyleTabButton(tab, active)
        if not tab then return end
        if active then
            tab.bg:SetVertexColor(0.14, 0.14, 0.14, 0.95)
            tab.border:SetVertexColor(1, 0.82, 0, 0.75)
            tab:GetFontString():SetTextColor(1, 0.95, 0.75, 1)
        else
            tab.bg:SetVertexColor(0.05, 0.05, 0.05, 0.75)
            tab.border:SetVertexColor(1, 0.82, 0, 0.18)
            tab:GetFontString():SetTextColor(0.82, 0.82, 0.82, 1)
        end
    end

    function Setup:MainFrame()
        if not self.mainFrame then
            self.mainFrame = CreateFrame("Frame", "DFRLMainFrame", UIParent)
            self.mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
            self.mainFrame:SetHeight(self.CONSTANTS.MAIN_FRAME_HEIGHT)
            self.mainFrame:SetWidth(self.CONSTANTS.MAIN_FRAME_WIDTH)
            self.mainFrame:SetFrameStrata("DIALOG")
            self.mainFrame:SetClampedToScreen(true)
            self.mainFrame:SetToplevel(true)
            self.mainFrame:EnableMouse(true)
            self.mainFrame:SetMovable(true)
            self.mainFrame:SetScript("OnMouseDown", function() this:StartMoving() end)
            self.mainFrame:SetScript("OnMouseUp", function() this:StopMovingOrSizing() end)
            self:ApplyPanelStyle(self.mainFrame, self.CONSTANTS.BACKGROUND_ALPHA)

            tinsert(UISpecialFrames, self.mainFrame:GetName()) -- shagutweaks buggs this out, disable when debugging

            local leftTex = self.mainFrame:CreateTexture(nil, "BACKGROUND")
            leftTex:SetTexture("Interface\\Buttons\\WHITE8X8")
            leftTex:SetPoint("TOPLEFT", self.mainFrame, "TOPLEFT", 0, 0)
            leftTex:SetWidth(self.mainFrame:GetWidth() / self.CONSTANTS.LEFT_PANEL_RATIO)
            leftTex:SetHeight(self.mainFrame:GetHeight())
            leftTex:SetVertexColor(0.02, 0.02, 0.02, self.CONSTANTS.BACKGROUND_ALPHA)

            self.rightTex = self.mainFrame:CreateTexture(nil, "BACKGROUND")
            self.rightTex:SetTexture("Interface\\Buttons\\WHITE8X8")
            self.rightTex:SetPoint("TOPRIGHT", self.mainFrame, "TOPRIGHT", 0, 0)
            self.rightTex:SetWidth(self.mainFrame:GetWidth() / self.CONSTANTS.RIGHT_PANEL_RATIO)
            self.rightTex:SetHeight(self.mainFrame:GetHeight())
            self.rightTex:SetVertexColor(0.04, 0.04, 0.04, self.CONSTANTS.BACKGROUND_ALPHA)

            T.GradientLine(self.mainFrame, "TOP", 3)
            T.GradientLine(self.mainFrame, "BOTTOM", -3)
        end
    end

    function Setup:TabFrame()
        if not self.tabFrame then
            self.tabFrame = CreateFrame("Frame", "DFRLTabFrame", self.mainFrame)
            self.tabFrame:SetPoint("RIGHT", self.mainFrame, "LEFT", 0, 0)
            self.tabFrame:SetHeight(self.mainFrame:GetHeight() - self.CONSTANTS.TITLE_FRAME_HEIGHT)
            self.tabFrame:SetWidth(self.CONSTANTS.TAB_FRAME_WIDTH)

            self:ApplyPanelStyle(self.tabFrame, self.CONSTANTS.BACKGROUND_ALPHA)

            local tex = self.tabFrame:CreateTexture(nil, "BACKGROUND")
            tex:SetTexture("Interface\\Buttons\\WHITE8X8")
            tex:SetAllPoints(self.tabFrame)
            tex:SetVertexColor(0.01, 0.01, 0.01, self.CONSTANTS.BACKGROUND_ALPHA)

            self.tabHeader = self.tabFrame:CreateFontString(nil, "OVERLAY")
            self.tabHeader:SetFont(self.font.. "BigNoodleTitling.ttf", 14, "OUTLINE")
            self.tabHeader:SetTextColor(1, .82, 0, 1)
            self.tabHeader:SetPoint("TOP", self.tabFrame, "TOP", 0, -8)
            self.tabHeader:SetText(DFRL:TR("Navigation"))
        end
    end

    function Setup:TitleFrame()
        if not self.titleFrame then
            self.titleFrame = CreateFrame("Frame", "DFRLTitleFrame", UIParent)
            self.titleFrame:SetPoint("BOTTOM", self.mainFrame, "TOP", 0, 2)
            self.titleFrame:SetHeight(self.CONSTANTS.TITLE_FRAME_HEIGHT)
            self.titleFrame:SetWidth(self.mainFrame:GetWidth() - self.CONSTANTS.TITLE_FRAME_OFFSET)
            self.titleFrame:SetFrameStrata("DIALOG")
            self.titleFrame:SetClampedToScreen(true)
            self.titleFrame:SetToplevel(true)
            self:ApplyPanelStyle(self.titleFrame, self.CONSTANTS.BACKGROUND_ALPHA)

            local tex = self.titleFrame:CreateTexture(nil, "BACKGROUND")
            tex:SetTexture("Interface\\Buttons\\WHITE8X8")
            tex:SetAllPoints(self.titleFrame)
            tex:SetVertexColor(0.02, 0.02, 0.02, self.CONSTANTS.BACKGROUND_ALPHA)

            tinsert(UISpecialFrames, self.titleFrame:GetName())

            self.titleFrame:SetScript("OnHide", function()
                if not self.mainFrame:IsVisible() and not self.titleFrame:IsVisible() then
                    self.mainFrame:SetScript("OnUpdate", nil)
                    DFRL.activeScripts["GUI LogoPulse"] = false
                end
            end)
        end
    end

    function Setup:TitleText()
        if not self.dragonText then
            self.dragonText = self.titleFrame:CreateFontString(nil, "OVERLAY")
            self.dragonText:SetFont(self.font.. "BigNoodleTitling.ttf", self.CONSTANTS.TITLE_FONT_SIZE, "OUTLINE")
            self.dragonText:SetTextColor(1, .82, 0, 1)
            self.dragonText:SetPoint("LEFT", self.titleFrame, "LEFT", 30, 0)
            self.dragonText:SetText("Dragonflight:")

            self.reloadedText = self.titleFrame:CreateFontString(nil, "OVERLAY")
            self.reloadedText:SetFont(self.font.. "BigNoodleTitling.ttf", self.CONSTANTS.TITLE_FONT_SIZE, "OUTLINE")
            self.reloadedText:SetTextColor(1, 1, 1, 1)
            self.reloadedText:SetPoint("LEFT", self.dragonText, "RIGHT", 5, 0)
            self.reloadedText:SetText("Reforged")

            local fadeOut = true
            local updateScript = function()
                if (this.tick or 0) > GetTime() then return end
                this.tick = GetTime() + self.CONSTANTS.PULSE_UPDATE_INTERVAL
                DFRL.activeScripts["GUI LogoPulse"] = true

                local currentAlpha = self.reloadedText:GetAlpha()
                local newAlpha = fadeOut and currentAlpha - self.CONSTANTS.PULSE_ALPHA_STEP or currentAlpha + self.CONSTANTS.PULSE_ALPHA_STEP

                if newAlpha <= self.CONSTANTS.PULSE_MIN_ALPHA then
                    newAlpha = self.CONSTANTS.PULSE_MIN_ALPHA
                    fadeOut = false
                elseif newAlpha >= 1 then
                    newAlpha = 1
                    fadeOut = true
                end

                self.reloadedText:SetAlpha(newAlpha)
            end

            self.titleFrame:SetScript("OnUpdate", updateScript)

            self.titleFrame:SetScript("OnShow", function()
                this:SetScript("OnUpdate", updateScript)
                DFRL.activeScripts["GUI LogoPulse"] = true
            end)
        end
    end

    function Setup:SubFrame()
        if not self.subFrame then
            self.subFrame = CreateFrame("Frame", "DFRLSubFrame", self.mainFrame)
            self.subFrame:SetPoint("TOPRIGHT", self.mainFrame, "BOTTOMRIGHT", -self.CONSTANTS.SUB_FRAME_OFFSET, -2)
            self.subFrame:SetHeight(self.CONSTANTS.SUB_FRAME_HEIGHT)
            self.subFrame:SetWidth(self.CONSTANTS.SUB_FRAME_WIDTH)

            self:ApplyPanelStyle(self.subFrame, self.CONSTANTS.BACKGROUND_ALPHA)

            local tex = self.subFrame:CreateTexture(nil, "BACKGROUND")
            tex:SetTexture("Interface\\Buttons\\WHITE8X8")
            tex:SetAllPoints(self.subFrame)
            tex:SetVertexColor(0.02, 0.02, 0.02, self.CONSTANTS.BACKGROUND_ALPHA)

            self.profileText = self.subFrame:CreateFontString(nil, "OVERLAY")
            self.profileText:SetFont(self.font.. "BigNoodleTitling.ttf", 14, "OUTLINE")
            self.profileText:SetTextColor(1, .82, 0, 1)
            self.profileText:SetPoint("LEFT", self.subFrame, "LEFT", 10, 0)

            local charName = UnitName("player")
            local profileName = DFRL_CUR_PROFILE[charName] or "Default"
            self.profileText:SetText(DFRL:TR("Profile") .. ":   |cffffffff" .. DFRL:DisplayProfileName(profileName) .. "|r")

            self.fpsText = self.subFrame:CreateFontString(nil, "OVERLAY")
            self.fpsText:SetFont(self.font.. "BigNoodleTitling.ttf", 14, "OUTLINE")
            self.fpsText:SetTextColor(1, .82, 0, 1)
            self.fpsText:SetPoint("RIGHT", self.subFrame, "RIGHT", -10, 0)

            self.helpText = self.subFrame:CreateFontString(nil, "OVERLAY")
            self.helpText:SetFont(self.font.. "BigNoodleTitling.ttf", 11, "OUTLINE")
            self.helpText:SetTextColor(0.75, 0.75, 0.75, 1)
            self.helpText:SetPoint("CENTER", self.subFrame, "CENTER", 0, 0)
            self.helpText:SetText(DFRL:TR("Drag to move - ESC to close"))

            self.subFrame:SetScript("OnUpdate", function()
                if (this.fpsTimer or 0) > GetTime() then return end
                this.fpsTimer = GetTime() + 0.5
                DFRL.activeScripts["GUI SubFrame"] = true
                self.fpsText:SetText(DFRL:TR("FPS:") .. " |cffffffff" .. format("%.1f", GetFramerate()) .. "|r")
                self.profileText:SetText(DFRL:TR("Profile") .. ":   |cffffffff" .. DFRL:DisplayProfileName(DFRL_CUR_PROFILE[UnitName("player")] or "Default") .. "|r")
            end)

            self.subFrame:SetScript("OnShow", function()
                DFRL.activeScripts["GUI SubFrame"] = true
            end)

            self.subFrame:SetScript("OnHide", function()
                DFRL.activeScripts["GUI SubFrame"] = false
            end)
        end
    end

    function Setup:TabButtons()
        if not self.tabsCreated then
            for i = 1, table.getn(Setup.tabs) do
                local tab = CreateFrame("Button", "DFRLTab" .. i, self.tabFrame)
                tab:SetHeight(self.CONSTANTS.TAB_BUTTON_HEIGHT)
                tab:SetWidth(self.CONSTANTS.TAB_BUTTON_WIDTH)

                local yOffset = -30 - (i - 1) * self.CONSTANTS.TAB_VERTICAL_SPACING
                if i > 5 then
                    yOffset = yOffset - self.CONSTANTS.TAB_GROUP_SEPARATOR
                end
                tab:SetPoint("TOP", self.tabFrame, "TOP", 0, yOffset)

                local bg = tab:CreateTexture(nil, "BACKGROUND")
                bg:SetTexture("Interface\\Buttons\\WHITE8X8")
                bg:SetAllPoints(tab)
                tab.bg = bg

                local border = tab:CreateTexture(nil, "BORDER")
                border:SetTexture("Interface\\Buttons\\WHITE8X8")
                border:SetPoint("TOPLEFT", tab, "TOPLEFT", 2, -2)
                border:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", -2, 2)
                tab.border = border

                local highlight = tab:CreateTexture(nil, "OVERLAY")
                highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
                highlight:SetAllPoints(tab)
                highlight:SetBlendMode("ADD")
                highlight:Hide()
                tab.highlight = highlight

                local text = tab:CreateFontString(nil, "OVERLAY")
                text:SetFont(self.font.. "BigNoodleTitling.ttf", self.CONSTANTS.TAB_FONT_SIZE, "OUTLINE")
                text:SetTextColor(.7, .7, .7, 1)
                text:SetPoint("CENTER", tab, "CENTER")
                tab:SetFontString(text)
                tab:SetText(DFRL:TR(Setup.tabs[i]))

                local tabIndex = i
                tab:SetScript("OnClick", function()
                    self:SelectTab(tabIndex)
                end)

                tab:SetScript("OnEnter", function()
                    if tabIndex ~= self.selectedTab then
                        tab.highlight:Show()
                        tab.bg:SetVertexColor(0.10, 0.10, 0.10, 0.92)
                        tab.border:SetVertexColor(1, 0.82, 0, 0.45)
                    end
                end)

                tab:SetScript("OnLeave", function()
                    if tabIndex ~= self.selectedTab then
                        tab.highlight:Hide()
                        self:StyleTabButton(tab, false)
                    end
                end)

                self:StyleTabButton(tab, false)
                self.tabButtons[i] = tab
            end
            self.tabButtons[13]:Disable()
            self.tabButtons[13]:GetFontString():SetTextColor(.4, .4, .4, 1)
            if self.tabButtons[13].border then self.tabButtons[13].border:SetVertexColor(0.4, 0.4, 0.4, 0.1) end
            self.tabsCreated = true
        end
    end

    function Setup:SelectTab(tabIndex)
        for i = 1, table.getn(self.tabs) do
            self.tabButtons[i].highlight:Hide()
            self:StyleTabButton(self.tabButtons[i], false)
        end

        self.tabButtons[tabIndex].highlight:Show()
        self:StyleTabButton(self.tabButtons[tabIndex], true)
        self.selectedTab = tabIndex



        -- instant so it shows up in gui
        DFRL.activeScripts["GUI SmoothScroll"] = false

        if self.isScrolling then
            self.isScrolling = false
            DFRL.activeScripts["GUI SmoothScroll"] = false
        end


        for i = 1, table.getn(self.tabs) do
            if self.scrollChildren[i] then
                self.scrollChildren[i]:Hide()
            end
        end


        if self.scrollChildren[tabIndex] then
            self.scrollChildren[tabIndex]:Show()
        end

        self.scrollFrame:SetScrollChild(self.scrollChildren[tabIndex])

        self.scrollFrame:SetVerticalScroll(0)
        self.slider:SetValue(0)
        self.targetScroll = 0
        self.currentScroll = 0
        self.scrollFrame:Show()
        if tabIndex == 1 or tabIndex == 3 or tabIndex == 4 then
            self.slider:Hide()
        else
            self.slider:Show()
        end
        if tabIndex ~= 1 then
            self.panelTitle:SetText(DFRL:TR(self.tabs[tabIndex]))
        else
            self.panelTitle:SetText("")
        end

        self.scrollRange = self.scrollFrame:GetVerticalScrollRange()
        if tabIndex == 5 then
            if not self.reloadFrame then
                self.reloadFrame = CreateFrame("Frame", "DFRLReloadFrame", self.mainFrame)
                self.reloadFrame:SetFrameLevel(self.scrollFrame:GetFrameLevel() + 1)
                self.reloadFrame:SetPoint("TOP", self.scrollFrame, "TOP", -20, -20)
                self.reloadFrame:SetWidth(200)
                self.reloadFrame:SetHeight(80)

                self.reloadFont = DFRL.tools.CreateFont(self.reloadFrame, 14, "Changes take effect after reload:", {0.5, 0.5, 0.5}, "CENTER")
                self.reloadFont:SetPoint("TOP", self.reloadFrame, "TOP", 0, 0)

                self.reloadBtn = DFRL.tools.CreateButton(self.reloadFrame, "Reload UI", 140, 30, true, {1, 0.5, 0.5})
                self.reloadBtn:SetScript("OnClick", function()
                    ReloadUI()
                end)
                self.reloadBtn:SetPoint("TOP", self.reloadFont, "BOTTOM", 0, -5)
            end
            self.reloadFrame:Show()
        else
            if self.reloadFrame then
                self.reloadFrame:Hide()
            end
        end

        self.fadeTargetAlpha = tabIndex > 4 and DFRL:GetTempDB("GUI-Dragonflight", "sideView") or self.CONSTANTS.BACKGROUND_ALPHA
        self.fadeCurrentAlpha = self.rightTex:GetAlpha()
        self.fadeStartTime = GetTime()
        self.panelFading = true
        DFRL.activeScripts["GUI PanelFade"] = true
    end

    function Setup:Panels()

        if not self.panelsCreated then

            self.scrollFrame = CreateFrame("ScrollFrame", "DFRLScrollFrame", self.mainFrame)
            self.scrollFrame:SetPoint("TOPLEFT", self.mainFrame, "TOPLEFT", 10, -60)
            self.scrollFrame:SetPoint("BOTTOMRIGHT", self.mainFrame, "BOTTOMRIGHT", -30, 10)
            self.scrollFrame:EnableMouseWheel(true)

            self.scrollFrame:SetScript("OnMouseWheel", function()
                local delta = arg1 * self.CONSTANTS.SCROLL_STEP_SIZE
                local currentPos = self.scrollFrame:GetVerticalScroll()
                self.targetScroll = currentPos - delta
                if self.targetScroll < 0 then self.targetScroll = 0 end
                if self.targetScroll > self.scrollRange then
                    self.targetScroll = self.scrollRange
                end
                self:SmoothScroll()
            end)

            self.slider = CreateFrame("Slider", "DFRLSlider", self.mainFrame)
            self.slider:SetPoint("RIGHT", self.scrollFrame, "RIGHT", 30, 0)
            self.slider:SetPoint("TOP", self.scrollFrame, "TOP", 0, 0)
            self.slider:SetPoint("BOTTOM", self.scrollFrame, "BOTTOM", 0, 0)
            self.slider:SetWidth(16)
            self.slider:SetOrientation("VERTICAL")
            self.slider:SetMinMaxValues(0, 2000)
            self.slider:SetValue(0)
            self.slider:SetValueStep(10)
            self.slider:Hide()

            local thumb = self.slider:CreateTexture(nil, "OVERLAY")
            thumb:SetTexture("Interface\\Buttons\\WHITE8X8")
            thumb:SetWidth(4)
            thumb:SetHeight(16)
            thumb:SetVertexColor(1, .82, 0)
            self.slider:SetThumbTexture(thumb)

            self.slider:SetScript("OnValueChanged", function()
                if not self.isScrolling then
                    self.scrollFrame:SetVerticalScroll(this:GetValue())
                end
            end)

            self.scrollFrame:SetScript("OnScrollRangeChanged", function()
                self.scrollRange = this:GetVerticalScrollRange()
                self.slider:SetMinMaxValues(0, self.scrollRange)
                self.slider:SetValue(this:GetVerticalScroll())
            end)

            for i = 1, table.getn(self.tabs) do
                local scrollChild = CreateFrame("Frame", "DFRLScrollChild" .. i, self.scrollFrame)
                scrollChild:SetWidth(800)

                if i == 5 or i == 2 then
                    scrollChild:SetHeight(1800)
                elseif i == 6 then
                    scrollChild:SetHeight(3500)
                else
                    scrollChild:SetHeight(1000)
                end

                scrollChild:EnableMouse(true)
                scrollChild:SetScript("OnMouseDown", function() self.mainFrame:StartMoving() end)
                scrollChild:SetScript("OnMouseUp", function() self.mainFrame:StopMovingOrSizing() end)

                self.scrollChildren[i] = scrollChild
            end


            self.panelsCreated = true
        end
    end

    function Setup:SmoothScroll()
        if not self.isScrolling then
            self.currentScroll = self.scrollFrame:GetVerticalScroll()
            self.isScrolling = true
            DFRL.activeScripts["GUI SmoothScroll"] = true
        end
    end

    function Setup:PanelTitles()
        if not self.panelTitle then
            self.panelTitle = self.mainFrame:CreateFontString(nil, "OVERLAY")
            self.panelTitle:SetFont(self.font.. "BigNoodleTitling.ttf", 22, "OUTLINE")
            self.panelTitle:SetTextColor(1, .82, 0, 1)
            self.panelTitle:SetPoint("TOP", self.scrollFrame, "TOP", -20, 28)

        end
    end

    function Setup:UpdateShaguTweaksButton()
        for i = 1, table.getn(Setup.tabs) do
            if Setup.tabs[i] == "ShaguTweaks" and self.tabButtons[i] then
                local tab = self.tabButtons[i]
                local text = tab:GetFontString()
                if DFRL.addon1 then
                    text:SetTextColor(.7, .7, .7, 1)
                    tab:Enable()
                    tab:SetScript("OnClick", function()
                        self:SelectTab(i)
                    end)
                    tab:SetScript("OnEnter", function()
                        if i ~= self.selectedTab then
                            tab.highlight:Show()
                        end
                    end)
                    tab:SetScript("OnLeave", function()
                        if i ~= self.selectedTab then
                            tab.highlight:Hide()
                        end
                    end)
                else
                    text:SetTextColor(.2, .2, .2, 1)
                    tab:Disable()
                end
                break
            end
        end
    end

    --=================
    -- INIT
    --=================
    function Setup:InitScrollHandler()
        if not self.fadeFrame then
            self.fadeFrame = CreateFrame("Frame")

            self.fadeFrame:SetScript("OnUpdate", function()
                if self.isScrolling then
                    local diff = self.targetScroll - self.currentScroll
                    if diff > -0.5 and diff < 0.5 then
                        self.currentScroll = self.targetScroll
                        self.scrollFrame:SetVerticalScroll(self.currentScroll)
                        self.slider:SetValue(self.currentScroll)
                        self.isScrolling = false
                        DFRL.activeScripts["GUI SmoothScroll"] = false
                    else
                        self.currentScroll = self.currentScroll + diff * 0.1
                        self.scrollFrame:SetVerticalScroll(self.currentScroll)
                        self.slider:SetValue(self.currentScroll)
                    end
                end

                if self.panelFading then
                    local elapsed = GetTime() - self.fadeStartTime
                    if elapsed >= 0.3 then
                        self.rightTex:SetVertexColor(0, 0, 0, self.fadeTargetAlpha)
                        self.panelFading = false
                        DFRL.activeScripts["GUI PanelFade"] = false
                    else
                        local progress = elapsed / 0.3
                        local newAlpha = self.fadeCurrentAlpha + (self.fadeTargetAlpha - self.fadeCurrentAlpha) * progress
                        self.rightTex:SetVertexColor(0, 0, 0, newAlpha)
                    end
                end
            end)
        end
    end

    function Setup:Run()

        Setup:MainFrame()
        Setup:TabFrame()
        Setup:TitleFrame()
        Setup:SubFrame()

        Setup:TitleText()
        Setup:TabButtons()
        Setup:Panels()
        Setup:PanelTitles()

        Setup:InitScrollHandler()

        self.eventFrame = CreateFrame("Frame")
        self.eventFrame:RegisterEvent("VARIABLES_LOADED")
        self.eventFrame:SetScript("OnEvent", function()
            Setup:UpdateShaguTweaksButton()
            self.eventFrame:UnregisterEvent("VARIABLES_LOADED")
        end)

        Setup:SelectTab(1)
    end

    Setup:Run()

    --=================
    -- EXPOSE
    --=================
    DFRL.gui.Base = Setup
    DFRLSetup = Setup -- Need to move this to .gui

    --=================
    -- DEBUG
    --=================
    local DEBUG_MODE = false

    if DEBUG_MODE then
        Setup.mainFrame:Show()
        else
        Setup.mainFrame:Hide()
        Setup.titleFrame:Hide()
    end
end)