DFRL:NewDefaults("GUI-Dragonflight", {
    enabled = {true},
    globalFont = {"FRIZQT__.TTF", "dropdown", {
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
    }, nil, "Home Screen", 1, "Change all fonts in the GUI", nil, nil},
    smallerFrame = {true, "checkbox", nil, nil, "Home Screen", 2, "Changes the scale of the mainframe", nil, nil},
    sideView = {.3, "slider", {.1, .8}, nil, "Home Screen", 3, "Changes the alpha of the side view", "", nil},
    homeMinMaxColor = {{1, .82, 0}, "colour", nil, nil, "Home Screen", 4, "Changes the color of the close and min button", nil, nil},
    homeTimeColor = {{1, .82, 0}, "colour", nil, nil, "Home Screen", 5, "Changes the color of the time on the home screen", nil, nil},
    language = {(GetLocale() == "frFR" and "Francais" or "English"), "dropdown", {"English", "Francais"}, nil, "localization", 6, "Select the language used in the configuration UI", nil, nil},
})

DFRL:NewMod("GUI-Dragonflight", 4, function()
    local Base = DFRL.gui.Base
    local Home = DFRL.gui.Home
    local Setup = {
        frame = nil,
        button = nil,
        timeText = nil,
        dateText = nil,
        donateText = nil,
        closeBtn = nil,
        minBtn = nil,
        gamemenuBtn = nil,
        animRan = false,
        timeRan = false
    }

    function Setup:Panel()
        if not self.frame then
            self.frame = CreateFrame("Frame", "DFRL_SupportFrame", Base.scrollChildren[1])
            self.frame:SetWidth(100)
            self.frame:SetHeight(0)
            self.frame:SetPoint("CENTER", Base.scrollChildren[1], "CENTER", 2, 0)
            self.frame:EnableMouse(true)
            T.GradientLine(self.frame, "BOTTOM", 0)
            self.button = CreateFrame("Button", nil, self.frame)
            self.button:SetWidth(80)
            self.button:SetHeight(35)
            self.button:SetPoint("CENTER", self.frame, "CENTER", 0, 0)
            -- self.button:SetScript("OnClick", function() Setup:Donate() end)

            self.timeText = DFRL.tools.CreateFont(Base.scrollChildren[1], 24, "")
            self.timeText:SetPoint("CENTER", Base.scrollChildren[1], "CENTER", 2, 60)
            self.timeText:SetAlpha(0)
            self.dateText = DFRL.tools.CreateFont(Base.scrollChildren[1], 12, "")
            self.dateText:SetPoint("TOP", self.timeText, "BOTTOM", 0, -10)
            self.dateText:SetAlpha(0)
            self.frame:Hide()
            self.button:Hide()
        end
    end

    function Setup:Animate()
        if self.animRan then return end
        self.animRan = true

        if DFRL:GetTempDB("GUI-Dragonflight", "noDonation") then
            local animFrame = CreateFrame("Frame")
            local script = function()
                if Home.logoStarted then
                    self.animComplete = true
                    animFrame:SetScript("OnUpdate", nil)
                end
            end
            animFrame:SetScript("OnUpdate", script)
            self:Time()
            return
        end

        self.animComplete = false

        local started = false
        local heightDone = false
        local buttonDone = false
        local time = 0
        local animFrame = CreateFrame("Frame")

        local script = function()
            if (this.tick or 0) > GetTime() then return end
            this.tick = GetTime() + 0.01

            if not started and Home.logoStarted then
                started = true
                self.frame:Show()
            end

            if started and not heightDone then
                time = time + 0.01
                local h = time * 150
                if h >= 30 then
                    h = 30
                    heightDone = true
                    UIFrameFadeIn(self.button, 0.2, 0, 1)
                end
                self.frame:SetHeight(h)
            end

            if heightDone and not buttonDone then
                if self.button:GetAlpha() >= 1 then
                    buttonDone = true
                    animFrame:SetScript("OnUpdate", nil)
                    self.animComplete = true
                end
            end
        end

        animFrame:SetScript("OnUpdate", script)
        self:Time()
    end

    function Setup:Time()
        if self.timeRan then return end
        self.timeRan = true

        local fadedIn = false
        local fadeStarted = false
        local timeFrame = CreateFrame("Frame")
        local lastUpdate = 0

        local script = function()
            if not Base.mainFrame:IsShown() then return end

            if not self.animComplete then
                return
            end

            DFRL.activeScripts["GUI TimeScript"] = true

            local now = GetTime()

            if not fadedIn then
                if now - lastUpdate < 0.1 then
                    return
                end
                lastUpdate = now

                local time = date("%H:%M")
                local dateStr = date("%d.%m.%Y")
                self.timeText:SetText(time)
                self.dateText:SetText(dateStr)

                if not fadeStarted then
                    UIFrameFadeIn(self.timeText, 0.3, 0, 1)
                    UIFrameFadeIn(self.dateText, 0.3, 0, 1)
                    fadeStarted = true
                elseif self.timeText:GetAlpha() >= 1 then
                    fadedIn = true
                    lastUpdate = now
                end
            else
                if now - lastUpdate < 10 then
                    return
                end
                lastUpdate = now

                local time = date("%H:%M")
                local dateStr = date("%d.%m.%Y")
                self.timeText:SetText(time)
                self.dateText:SetText(dateStr)
            end
        end

        timeFrame:SetScript("OnUpdate", script)
    end

    function Setup:Donate()
        -- if not self.donateText then
        --     self.donateText = DFRL.tools.CreateFont(Base.scrollChildren[1], 16, "greetings turtles =)\n\n\ni hope you like |cFFFFD700dragonflight:|r reloaded,\n\nI'm a solo basement developer working on this addon.\nif you want to support me,\nyou can send me a Giftcard or paysafecard to my email.\n\n\n|cFFFFD700guzruul.live @ gmail.com - Discord @Guzruul|r\n\n\notherwise - Enjoy |cFFFFD700Dragonflight:|r Reloaded.\n\n\nsafe travels,\n\nGuzruul")
        --     self.donateText:SetPoint("TOP", Base.scrollChildren[1], "TOP", 1, -50)
        --     self.donateText:Hide()
        -- end

        -- if self.donateText:IsShown() then
        --     self.donateText:Hide()
        --     Home.logoTex:Show()
        --     Home.logoText:Show()
        --     Home.leftLine:Show()
        --     Home.rightLine:Show()
        -- else
        --     self.donateText:Show()
        --     Home.logoTex:Hide()
        --     Home.logoText:Hide()
        --     Home.leftLine:Hide()
        --     Home.rightLine:Hide()
        -- end
    end

    function Setup:MinMaxClose()
        local function Toggle()
            if Base.mainFrame:IsShown() and Base.mainFrame:GetAlpha() > 0 and Base.titleFrame:IsShown() and Base.titleFrame:GetAlpha() > 0 then
                UIFrameFadeOut(Base.mainFrame, 0.3, 1, 0)
                UIFrameFadeOut(Base.titleFrame, 0.3, 1, 0)
                Base.mainFrame.fadeInfo.finishedFunc = Base.mainFrame.Hide
                Base.mainFrame.fadeInfo.finishedArg1 = Base.mainFrame
                Base.titleFrame.fadeInfo.finishedFunc = function() Base.titleFrame:Hide() end
            elseif Base.titleFrame:IsShown() and Base.titleFrame:GetAlpha() > 0 and (not Base.mainFrame:IsShown() or Base.mainFrame:GetAlpha() == 0) then
                UIFrameFadeOut(Base.titleFrame, 0.3, 1, 0)
                Base.titleFrame.fadeInfo.finishedFunc = function() Base.titleFrame:Hide() end
            else
                Base.mainFrame.fadeInfo = nil
                Base.titleFrame.fadeInfo = nil
                Base.mainFrame:SetAlpha(0)
                Base.titleFrame:SetAlpha(0)
                Base.mainFrame:Show()
                Base.titleFrame:Show()
                -- redFrame(Base.mainFrame)
                Base.mainFrame:ClearAllPoints()
                Base.mainFrame:SetPoint("CENTER", UIParent, "CENTER", 40, 50)
                UIFrameFadeIn(Base.mainFrame, 0.3, 0, 1)
                UIFrameFadeIn(Base.titleFrame, 0.3, 0, 1)
            end
        end

        local function MinMax()
            if Base.mainFrame:IsShown() then
                UIFrameFadeOut(Base.mainFrame, 0.3, 1, 0)
                Base.mainFrame.fadeInfo.finishedFunc = Base.mainFrame.Hide
                Base.mainFrame.fadeInfo.finishedArg1 = Base.mainFrame
            else
                Base.mainFrame:Show()
                UIFrameFadeIn(Base.mainFrame, 0.3, 0, 1)
            end
        end

        if not self.closeBtn then
            self.closeBtn = DFRL.tools.CreateButton(Base.titleFrame, "close", 50, 20, true, {1,0,0})
            self.closeBtn:SetPoint("TOPRIGHT", Base.mainFrame, "TOPRIGHT", -115, 28)
            self.closeBtn:SetScript("OnClick", function()
                Toggle()
            end)
        end

        if not self.minBtn then
            self.minBtn = DFRL.tools.CreateButton(Base.titleFrame, "min", 50, 20, true, {1,0,0})
            self.minBtn:SetPoint("RIGHT", self.closeBtn, "LEFT", 2, 0)
            self.minBtn:SetScript("OnClick", function()
                MinMax()
            end)
        end

        _G["SLASH_DFRL1"] = "/dfrl"
        _G.SlashCmdList["DFRL"] = function()
            Toggle()
        end
    end

    function Setup:GameMenuButton()
        if not self.gamemenuBtn then
            self.gamemenuBtn = CreateFrame("Button", "DFRLGameMenuButton", GameMenuFrame, "GameMenuButtonTemplate")
            self.gamemenuBtn:SetText("|cFFFFD100Dragonflight:|r Reloaded")
            self.gamemenuBtn:SetPoint("TOP", GameMenuFrame, "TOP", 0, -35)
            self.gamemenuBtn:SetHeight(30)
            self.gamemenuBtn:SetWidth(150)
            self.gamemenuBtn:SetScript("OnClick", function()
                HideUIPanel(GameMenuFrame)
                Base.mainFrame:ClearAllPoints()
                Base.mainFrame:SetPoint("CENTER", UIParent, "CENTER", 40, 50)
                Base.mainFrame:Show()
                Base.titleFrame:Show()
                UIFrameFadeIn(Base.mainFrame, 0.5, 0, 1)
                UIFrameFadeIn(Base.titleFrame, 0.2, 0, 1)
            end)

            GameMenuButtonShop:ClearAllPoints()
            GameMenuButtonShop:SetPoint("TOP", self.gamemenuBtn, "BOTTOM", 0, -15)

            GameMenuFrame:SetWidth(GameMenuFrame:GetWidth() + 10)
            GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + 60)
        end
    end

    function Setup:Run()
        Setup:Panel()
        Setup:Animate()
        Setup:Time()
        Setup:GameMenuButton()
        Setup:MinMaxClose()
    end

    Setup:Run()

    DFRL.activeScripts["GUI TimeScript"] = false

    local function UpdateAllFonts(frame, newFont)
        local regions = {frame:GetRegions()}
        for i = 1, table.getn(regions) do
            local region = regions[i]
            if region and region.SetFont then
                local _, size, flags = region:GetFont()
                region:SetFont(newFont, size, flags)
            end
        end

        local children = {frame:GetChildren()}
        for i = 1, table.getn(children) do
            local child = children[i]
            if child then
                UpdateAllFonts(child, newFont)
            end
        end
    end

    -- callbacks
    local callbacks = {}
    local lastAppliedLanguage = nil

    callbacks.homeTimeColor = function (value)
        Setup.timeText:SetTextColor(value[1], value[2], value[3])
    end

    callbacks.homeMinMaxColor = function (value)
        Setup.closeBtn.text:SetTextColor(value[1], value[2], value[3])
        Setup.minBtn.text:SetTextColor(value[1], value[2], value[3])
    end

    callbacks.smallerFrame = function (value)
        local x, y = Base.mainFrame:GetLeft(), Base.mainFrame:GetTop()
        local oldScale = Base.mainFrame:GetScale()

        local newScale
        if value then
            newScale = 0.85
            Base.mainFrame:SetScale(newScale)
            Base.titleFrame:SetScale(newScale)
        else
            newScale = 1
            Base.mainFrame:SetScale(newScale)
            Base.titleFrame:SetScale(newScale)
        end

        local adjustedX = x * oldScale / newScale
        local adjustedY = y * oldScale / newScale

        Base.mainFrame:ClearAllPoints()
        Base.mainFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", adjustedX, adjustedY)
    end

    callbacks.sideView = function (value)
        if Base.selectedTab > 4 then
            Base.rightTex:SetAlpha(value)
        end
    end

    callbacks.language = function(value)
        if not lastAppliedLanguage then
            lastAppliedLanguage = value
            return
        end

        if lastAppliedLanguage == value then
            return
        end

        lastAppliedLanguage = value
        DFRL:SaveTempDB()
        ReloadUI()
    end

    callbacks.globalFont = function(value)
        local fontPath
        if value == 'Expressway' then
            fontPath = 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Expressway.ttf'
        elseif value == 'Homespun' then
            fontPath = 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Homespun.ttf'
        elseif value == 'Hooge' then
            fontPath = 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Hooge.ttf'
        elseif value == 'Myriad-Pro' then
            fontPath = 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Myriad-Pro.ttf'
        elseif value == 'Prototype' then
            fontPath = 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Prototype.ttf'
        elseif value == 'PT-Sans-Narrow-Bold' then
            fontPath = 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\PT-Sans-Narrow-Bold.ttf'
        elseif value == 'PT-Sans-Narrow-Regular' then
            fontPath = 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\PT-Sans-Narrow-Regular.ttf'
        elseif value == 'RobotoMono' then
            fontPath = 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\RobotoMono.ttf'
        elseif value == 'BigNoodleTitling' then
            fontPath = 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\BigNoodleTitling.ttf'
        elseif value == 'Continuum' then
            fontPath = 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Continuum.ttf'
        elseif value == 'DieDieDie' then
            fontPath = 'Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\DieDieDie.ttf'
        else
            fontPath = 'Fonts\\FRIZQT__.TTF'
        end

        UpdateAllFonts(Base.mainFrame, fontPath)
        UpdateAllFonts(Base.titleFrame, fontPath)
        UpdateAllFonts(Base.subFrame, fontPath)
        if DFRL.menuframe then UpdateAllFonts(DFRL.menuframe, fontPath) end
        if DFRL.addonFrame then UpdateAllFonts(DFRL.addonFrame, fontPath) end
    end

    -- execute callbacks
    DFRL:NewCallbacks("GUI-Dragonflight", callbacks)
end)
