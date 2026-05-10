
DFRL:NewDefaults("RangeIndicator", {
    enabled = { true },
    indicatorDark = {false, "checkbox", nil, nil, "appearance", 1, "Use dark color instead of red", nil, nil},
    indicatorFade = {true, "checkbox", nil, nil, "appearance", 2, "Enable fade in/out animation", nil, nil},
    indicatorAlpha = {.5, "slider", {0, 1}, nil, "appearance", 3, "Adjust range indicator opacity", nil, nil},
    indicatorSimple = {false, "checkbox", nil, nil, "appearance", 4, "Use simple X instead of texture", nil, nil},
})

DFRL:NewMod("RangeIndicator", 1, function()
    -- =================
    -- SETUP
    -- =================
    local Setup = {
        texpath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\tex\\actionbars\\",
        rangeIndicatorFrame = nil,
        rangeIndicatorUpdateTimer = 0,
        buttonTypes = {
            "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
            "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton",
        }
    }

    function Setup:KillBlizz()
        function _G.ActionButton_UpdateHotkeys() end
    end

    function Setup:CreateIndicatorTexture(button)
        if button.rangeIndicator then
            return
        end

        self.useSimple = DFRL:GetTempDB("RangeIndicator", "indicatorSimple")
        self.useDark = DFRL:GetTempDB("RangeIndicator", "indicatorDark")

        if self.useSimple then
            self.indicator = button:CreateFontString(nil, "OVERLAY")
            self.indicator:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE")
            self.indicator:SetText("X")
            if self.useDark then
                self.indicator:SetTextColor(0, 0, 0)
            else
                self.indicator:SetTextColor(1, 0.2, 0.2)
            end
            self.indicator:SetPoint("TOPRIGHT", button, "TOPRIGHT", -0, 3)
        else
            self.indicator = button:CreateTexture(nil, "OVERLAY")
            self.indicator:SetTexture(self.texpath .. "indicator_.tga")
            if self.useDark then
                self.indicator:SetVertexColor(0, 0, 0)
            else
                self.indicator:SetVertexColor(1, 0, 0)
            end
            self.indicator:SetAllPoints(button)
            self.indicator:SetPoint("CENTER", button, "CENTER", -0, -0)
        end

        self.indicator:Hide()
        self.indicator.showing = false
        self.indicator.useFade = true
        self.indicator.isSimple = self.useSimple

        button.rangeIndicator = self.indicator
    end

    function Setup:CheckButtonRange(button)
        if not button or not button:IsVisible() then
            return true
        end

        local slot = ActionButton_GetPagedID(button)
        if not slot or slot == 0 then
            return true
        end

        if not UnitExists("target") then
            return true
        end

        if not UnitCanAttack("player", "target") then
            return true
        end

        local inRange = IsActionInRange(slot)
        if inRange == 0 then
            return false
        end

        return true
    end

    function Setup:UpdateIndicatorVisibility(button)
        if not button.rangeIndicator then
            return
        end

        local inRange = self:CheckButtonRange(button)
        local alpha = DFRL:GetTempDB("RangeIndicator", "indicatorAlpha")

        if inRange and button.rangeIndicator.showing then
            if button.rangeIndicator.useFade then
                UIFrameFadeOut(button.rangeIndicator, 0.2, alpha, 0)
            else
                button.rangeIndicator:Hide()
            end
            button.rangeIndicator.showing = false
        elseif not inRange and not button.rangeIndicator.showing then
            if button.rangeIndicator.useFade then
                UIFrameFadeIn(button.rangeIndicator, 0.2, 0, alpha)
            else
                button.rangeIndicator:SetAlpha(alpha)
                button.rangeIndicator:Show()
            end
            button.rangeIndicator.showing = true
        end
    end

    function Setup:ProcessAllButtons(func)
        for _, buttonType in ipairs(self.buttonTypes) do
            local i = 1
            while true do
                local button = getglobal(buttonType .. i)
                if not button then
                    break
                end
                func(self, button)
                i = i + 1
            end
        end
    end

    function Setup:RangeIndicator()
        self:ProcessAllButtons(self.CreateIndicatorTexture)
    end

    -- =================
    -- INIT
    -- =================
    function Setup:Run()
        self:KillBlizz()
        self:RangeIndicator()
    end

    Setup:Run()

    -- =================
    -- CALLBACKS
    -- =================
    local callbacks = {}

    callbacks.indicatorAlpha = function(value)
        for _, buttonType in ipairs(Setup.buttonTypes) do
            local i = 1
            while true do
                local button = getglobal(buttonType .. i)
                if not button then
                    break
                end
                if button.rangeIndicator then
                    button.rangeIndicator:SetAlpha(value)
                end
                i = i + 1
            end
        end
    end

    callbacks.indicatorDark = function(value)
        for _, buttonType in ipairs(Setup.buttonTypes) do
            local i = 1
            while true do
                local button = getglobal(buttonType .. i)
                if not button then
                    break
                end
                if button.rangeIndicator then
                    if button.rangeIndicator.isSimple then
                        if value then
                            button.rangeIndicator:SetTextColor(0, 0, 0)
                        else
                            button.rangeIndicator:SetTextColor(1, 0.2, 0.2)
                        end
                    else
                        if value then
                            button.rangeIndicator:SetVertexColor(0, 0, 0)
                        else
                            button.rangeIndicator:SetVertexColor(1, 0, 0)
                        end
                    end
                end
                i = i + 1
            end
        end
    end

    callbacks.indicatorFade = function(value)
        for _, buttonType in ipairs(Setup.buttonTypes) do
            local i = 1
            while true do
                local button = getglobal(buttonType .. i)
                if not button then
                    break
                end
                if button.rangeIndicator then
                    button.rangeIndicator.useFade = value
                end
                i = i + 1
            end
        end
    end

    callbacks.indicatorSimple = function(value)
        for _, buttonType in ipairs(Setup.buttonTypes) do
            local i = 1
            while true do
                local button = getglobal(buttonType .. i)
                if not button then
                    break
                end
                if button.rangeIndicator then
                    button.rangeIndicator:Hide()
                    button.rangeIndicator = nil
                end
                i = i + 1
            end
        end
        Setup:ProcessAllButtons(Setup.CreateIndicatorTexture)
    end

    -- =================
    -- EVENT
    -- =================
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")
    f:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
    f:RegisterEvent("SPELLS_CHANGED")
    f:SetScript("OnEvent", function()
        Setup:ProcessAllButtons(Setup.CreateIndicatorTexture)
        Setup:ProcessAllButtons(Setup.UpdateIndicatorVisibility)
    end)

    local updateTimer = 0
    f:SetScript("OnUpdate", function()
        updateTimer = updateTimer + arg1
        if updateTimer >= 0.1 then
            Setup:ProcessAllButtons(Setup.UpdateIndicatorVisibility)
            updateTimer = 0
            DFRL.activeScripts["RangeIndicatorScript"] = true
        else
            DFRL.activeScripts["RangeIndicatorScript"] = false
        end
    end)

    DFRL.activeScripts["RangeIndicatorScript"] = false

    DFRL:NewCallbacks("RangeIndicator", callbacks)
end)
