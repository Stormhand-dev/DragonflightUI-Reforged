DFRL:NewDefaults("Menu", {
    enabled = { true },
})

DFRL:NewMod("Menu", 1, function()
    local Setup = {
        menuframe = nil,
        w = 200,
        h = ShopFrame_Toggle and 370 or 315,
        gap = 0,
        space = 15,
        btnw = 120,
        btnh = 30,
    }

    function Setup:KillBlizz()
        KillFrame(GameMenuFrame)

        _G.ToggleGameMenu = function()
            if StaticPopup_EscapePressed() then
                return
            elseif Setup.menuframe:IsVisible() then
                Setup.menuframe:Hide()
            else
                local closedMenus = CloseMenus()
                local closedWindows = CloseAllWindows()
                if not (closedMenus or closedWindows) then
                    if UnitExists("target") then
                        ClearTarget()
                    else
                        Setup.menuframe:Show()
                    end
                end
            end
        end

        local origShowUIPanel = ShowUIPanel
        _G.ShowUIPanel = function(frame, force)
            if frame == GameMenuFrame then
                return
            end
            return origShowUIPanel(frame, force)
        end

        local frames = {OptionsFrame, SoundOptionsFrame, UIOptionsFrame}
        for _, frame in ipairs(frames) do
            if frame then
                local origOnShow = frame:GetScript("OnShow")
                frame:SetScript("OnShow", function()
                    if origOnShow then origOnShow() end
                    Disable_BagButtons()
                end)

                local origOnHide = frame:GetScript("OnHide")
                frame:SetScript("OnHide", function()
                    if origOnHide then origOnHide() end
                    Enable_BagButtons()
                end)
            end
        end
    end

    function Setup:MenuFrame()
        if not self.menuframe then
            self.menuframe = T.CreateDFRLFrame(nil, self.w, self.h)
            self.menuframe:SetPoint("CENTER", 0,0)
            self.menuframe:EnableMouse(true)
            self.menuframe:Hide()

          self.menuframe:SetScript("OnShow", function()
    UpdateMicroButtons()
    Disable_BagButtons()

    if SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPEN then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
    else
        PlaySound("igMainMenuOpen")
    end
end)

self.menuframe:SetScript("OnHide", function()
    UpdateMicroButtons()
    Enable_BagButtons()

    if SOUNDKIT and SOUNDKIT.IG_MAINMENU_CLOSE then
        PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE)
    else
        PlaySound("igMainMenuClose")
    end
end)


            local drBtn = DFRL.tools.CreateButton(self.menuframe, "|cFFFFD100DFUI:|r Reforged", self.btnw, self.btnh)
            drBtn:SetPoint("TOP", self.menuframe, "TOP", 0, -self.space)
            drBtn:SetScript("OnClick", function()
                self.menuframe:Hide()
                local Base = DFRL.gui and DFRL.gui.Base
                if not Base or not Base.mainFrame then return end

                if Base.mainFrame:IsShown() and Base.mainFrame:GetAlpha() > 0
                and Base.titleFrame:IsShown() and Base.titleFrame:GetAlpha() > 0 then
                    UIFrameFadeOut(Base.mainFrame, 0.3, 1, 0)
                    UIFrameFadeOut(Base.titleFrame, 0.3, 1, 0)
                    if Base.mainFrame.fadeInfo then
                        Base.mainFrame.fadeInfo.finishedFunc = Base.mainFrame.Hide
                        Base.mainFrame.fadeInfo.finishedArg1 = Base.mainFrame
                    end
                    if Base.titleFrame.fadeInfo then
                        Base.titleFrame.fadeInfo.finishedFunc = function() Base.titleFrame:Hide() end
                    end
                elseif Base.titleFrame:IsShown() and Base.titleFrame:GetAlpha() > 0
                and (not Base.mainFrame:IsShown() or Base.mainFrame:GetAlpha() == 0) then
                    UIFrameFadeOut(Base.titleFrame, 0.3, 1, 0)
                    if Base.titleFrame.fadeInfo then
                        Base.titleFrame.fadeInfo.finishedFunc = function() Base.titleFrame:Hide() end
                    end
                else
                    Base.mainFrame.fadeInfo = nil
                    Base.titleFrame.fadeInfo = nil
                    Base.mainFrame:SetAlpha(0)
                    Base.titleFrame:SetAlpha(0)
                    Base.mainFrame:Show()
                    Base.titleFrame:Show()
                    Base.mainFrame:ClearAllPoints()
                    Base.mainFrame:SetPoint("CENTER", UIParent, "CENTER", 40, 50)
                    UIFrameFadeIn(Base.mainFrame, 0.3, 0, 1)
                    UIFrameFadeIn(Base.titleFrame, 0.3, 0, 1)
                end
            end)

            local addonsBtn = DFRL.tools.CreateButton(self.menuframe, "Addon Manager", self.btnw, self.btnh)
            addonsBtn:SetPoint("TOP", drBtn, "BOTTOM", 0, -self.gap)
            addonsBtn:SetScript("OnClick", function()
                self.menuframe:Hide()
                if DFRL.addonFrame then
                    DFRL.addonFrame:Show()
                end
            end)

            local donationBtn = DFRL.tools.CreateButton(self.menuframe, "|cFFFFD100Donation Rewards", self.btnw, self.btnh)
            donationBtn:SetPoint("TOP", addonsBtn, "BOTTOM", 0, -self.space)
            if ShopFrame_Toggle then
                donationBtn:SetScript("OnClick", function()
                    self.menuframe:Hide()
                    ShopFrame_Toggle()
                end)
            else
                donationBtn:Hide()
            end

            local videoBtn = DFRL.tools.CreateButton(self.menuframe, "Options", self.btnw, self.btnh)
            if ShopFrame_Toggle then
                videoBtn:SetPoint("TOP", donationBtn, "BOTTOM", 0, -self.space)
            else
                videoBtn:SetPoint("TOP", addonsBtn, "BOTTOM", 0, -self.space)
            end
            videoBtn:SetScript("OnClick", function()
                self.menuframe:Hide()
                ShowUIPanel(OptionsFrame)
            end)

            local keyBtn = DFRL.tools.CreateButton(self.menuframe, "Key Bindings", self.btnw, self.btnh)
            keyBtn:SetPoint("TOP", videoBtn, "BOTTOM", 0, -self.space)
            keyBtn:SetScript("OnClick", function()
                self.menuframe:Hide()
                KeyBindingFrame_LoadUI()
                if KeyBindingFrame then
                    local origOnShow = KeyBindingFrame:GetScript("OnShow")
                    KeyBindingFrame:SetScript("OnShow", function()
                        if origOnShow then origOnShow() end
                        Disable_BagButtons()
                    end)
                    local origOnHide = KeyBindingFrame:GetScript("OnHide")
                    KeyBindingFrame:SetScript("OnHide", function()
                        if origOnHide then origOnHide() end
                        Enable_BagButtons()
                    end)
                end
                ShowUIPanel(KeyBindingFrame)
            end)

            local macroBtn = DFRL.tools.CreateButton(self.menuframe, "Macros", self.btnw, self.btnh)
            macroBtn:SetPoint("TOP", keyBtn, "BOTTOM", 0, -self.gap)
            macroBtn:SetScript("OnClick", function()
                self.menuframe:Hide()
                ShowMacroFrame()
                if MacroFrame then
                    local origOnShow = MacroFrame:GetScript("OnShow")
                    MacroFrame:SetScript("OnShow", function()
                        if origOnShow then origOnShow() end
                        Disable_BagButtons()
                    end)
                    local origOnHide = MacroFrame:GetScript("OnHide")
                    MacroFrame:SetScript("OnHide", function()
                        if origOnHide then origOnHide() end
                        Enable_BagButtons()
                    end)
                end
            end)

            local logBtn = DFRL.tools.CreateButton(self.menuframe, "Logout", self.btnw, self.btnh)
            logBtn:SetPoint("TOP", macroBtn, "BOTTOM", 0, -self.space)
            logBtn:SetScript("OnClick", function()
                self.menuframe:Hide()
                Logout()
            end)

            local exitBtn = DFRL.tools.CreateButton(self.menuframe, "Exit Game", self.btnw, self.btnh)
            exitBtn:SetPoint("TOP", logBtn, "BOTTOM", 0, -self.gap)
            exitBtn:SetScript("OnClick", function()
                self.menuframe:Hide()
                Quit()
            end)

            local resumeBtn = DFRL.tools.CreateButton(self.menuframe, "Resume Game", self.btnw, self.btnh)
            resumeBtn:SetPoint("TOP", exitBtn, "BOTTOM", 0, -self.gap)
            resumeBtn:SetScript("OnClick", function()
                self.menuframe:Hide()
            end)
        end
    end

    function Setup:Run()
        self:KillBlizz()
        self:MenuFrame()
    end

    Setup:Run()

    -- expose
    DFRL.menuframe = Setup.menuframe
end)
