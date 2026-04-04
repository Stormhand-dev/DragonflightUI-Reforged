DFRL:NewDefaults("Gui-prof", {
    enabled = {true},

})

DFRL:NewMod("Gui-prof", 4, function()
    --=================
    -- SETUP
    --=================
    local pairs = pairs

    local Base = DFRL.gui.Base
    local panel = Base.scrollChildren[3]
    local Setup = {
        grid = DFRL.tools.CreateGrid(Base.scrollChildren[3], 33, 25),
        headers = false,

        allProf = DFRL_PROFILES,
        curProf = DFRL_CUR_PROFILE,
        tempProfile = {},

        default = (function()
            local sanitized = {["Default"] = {}}
            for prof, data in pairs(DFRL.defaults) do
                sanitized["Default"][prof] = {}
                for key, value in pairs(data) do
                    sanitized["Default"][prof][key] = value[1]
                end
            end
            return sanitized
        end)(),

        font = DFRL:GetInfoOrCons("font"),
        TEXT_SIZE = 14,

        ui = {
            frame = nil,
            curText = nil,
            spacer = nil,
            usageText = nil,
            texts = {},
            copyBtns = {},
            delBtns = {},
            switchBtns = {},
            newProfileBtn = nil,
            resetBtn = nil,
            saveBtn = nil,
            warner = nil
        }
    }

    function Setup:ListFrame()
        if not self.headers then
            self.grid:AddElement(2, 1, DFRL.tools.CreateCategoryHeader(nil, "Manage"))
            self.headers = true
        end

        if not self.ui.usageText then
            self.ui.usageText = DFRL.tools.CreateFont(panel, 14, "Profiles help text", {.65, .65, .65}, "LEFT")
            self.grid:AddElement(5, 4, self.ui.usageText)
        end
        if not self.ui.frame then
            self.ui.frame = CreateFrame("Frame", nil, panel)
            self.ui.frame:SetWidth(320)
            self.ui.frame:SetHeight(420)
            self.grid:AddElement(2, 3, self.ui.frame)
            T.GradientLine(self.ui.frame, "TOP", 20, 2)
            T.GradientLine(self.ui.frame, "TOP", 60, 2)
            T.GradientLine(self.ui.frame, "BOTTOM", 0)
        end

        local char = UnitName("player")
        local curProf = self.curProf[char] or "Default"
        if not self.ui.curText then
            self.ui.curText = self.ui.frame:CreateFontString(nil, "OVERLAY")
            self.ui.curText:SetFont(self.font .. "BigNoodleTitling.ttf", self.TEXT_SIZE, "OUTLINE")
            self.ui.curText:SetPoint("TOPLEFT", self.ui.frame, "TOPLEFT", 10, -10)
        end
        self.ui.curText:SetText(DFRL:TR("Current") .. ":   |cff80ff80" .. DFRL:DisplayProfileName(curProf) .. "|r")
        for _, text in pairs(self.ui.texts) do
            text:Hide()
        end
        for _, btn in pairs(self.ui.copyBtns) do
            btn:Hide()
        end
        for _, btn in pairs(self.ui.delBtns) do
            btn:Hide()
        end
        for _, btn in pairs(self.ui.switchBtns) do
            btn:Hide()
        end

        self.ui.texts = {}
        self.ui.copyBtns = {}
        self.ui.delBtns = {}
        self.ui.switchBtns = {}
        local yOffset = -50
        local profCount = 0
        local sortedProfiles = {}
        for name in pairs(self.allProf) do
            if name ~= "Default" then
                table.insert(sortedProfiles, name)
            end
        end
        table.sort(sortedProfiles, function(a, b)
            return string.lower(a) < string.lower(b)
        end)
        table.insert(sortedProfiles, 1, "Default")

        for _, name in ipairs(sortedProfiles) do
            profCount = profCount + 1

            local text = self.ui.frame:CreateFontString(nil, "OVERLAY")
            text:SetFont(self.font .. "BigNoodleTitling.ttf", self.TEXT_SIZE, "OUTLINE")
            text:SetPoint("TOPLEFT", self.ui.frame, "TOPLEFT", 10, yOffset)
            text:SetText(DFRL:DisplayProfileName(name))
            table.insert(self.ui.texts, text)
            if name ~= "Default" then
                local profName = name
                local switchBtn = DFRL.tools.CreateButton(self.ui.frame, "Switch", 55, 20, true, {0.5, 1, 0.5})
                switchBtn:SetPoint("TOPLEFT", self.ui.frame, "TOPLEFT", 135, yOffset)
                switchBtn.profName = profName
                switchBtn:SetScript("OnClick", function()
                    local clickedName = this.profName
                    DFRL:SwitchProfile(clickedName)
                    Setup:Update()
                    if DFRL.gui.Base.UpdateHandler then
                        DFRL.gui.Base:UpdateHandler()
                    end
                    if not Setup.ui.warner then
                        Setup.ui.warner = DFRL.tools.CreateFontWarner(panel, 14, "", {0, 1, 0}, true, 3)
                        Setup.ui.warner:SetPoint("TOP", Setup.ui.frame, "BOTTOM", 0, 25)
                    end
                    Setup.ui.warner:SetTextColor(0, 1, 0)
                    if DFRL:IsFrench() then
                        Setup.ui.warner:SetText(DFRL:TR("switched to") .. " " .. clickedName)
                    else
                        Setup.ui.warner:SetText("switched to " .. clickedName)
                    end
                    Setup.ui.warner:Show()
                    Setup:RestartWarnerPulse()
                end)
                table.insert(self.ui.switchBtns, switchBtn)
                local copyBtn = DFRL.tools.CreateButton(self.ui.frame, "Copy", 55, 20, true)
                copyBtn:SetPoint("TOPLEFT", self.ui.frame, "TOPLEFT", 195, yOffset)
                copyBtn.profName = profName
                copyBtn:SetScript("OnClick", function()
                    local clickedName = this.profName
                    DFRL:LoadProfile(clickedName)
                    Setup:Update()
                    if DFRL.gui.Base.UpdateHandler then
                        DFRL.gui.Base:UpdateHandler()
                    end
                    if not Setup.ui.warner then
                        Setup.ui.warner = DFRL.tools.CreateFontWarner(panel, 14, "", {1, 1, 0}, true, 3)
                        Setup.ui.warner:SetPoint("TOP", Setup.ui.frame, "BOTTOM", 0, 25)
                    end
                    Setup.ui.warner:SetTextColor(1, 1, 0)
                    if DFRL:IsFrench() then
                        Setup.ui.warner:SetText(DFRL:TR("profile copied from") .. " " .. clickedName)
                    else
                        Setup.ui.warner:SetText("profile copied from " .. clickedName)
                    end
                    Setup.ui.warner:Show()
                    Setup:RestartWarnerPulse()
                end)
                table.insert(self.ui.copyBtns, copyBtn)
                local delBtn = DFRL.tools.CreateButton(self.ui.frame, "Delete", 55, 20, true, {1, 0.5, 0.5})
                delBtn:SetPoint("TOPLEFT", self.ui.frame, "TOPLEFT", 255, yOffset)
                delBtn.profName = profName
                delBtn:SetScript("OnClick", function()
                    local clickedName = this.profName
                    DFRL:DeleteProfile(clickedName)
                    DFRL:SwitchProfile("Default")
                    DFRL.gui.Base:UpdateHandler()
                    Setup:Update()
                    if not Setup.ui.warner then
                        Setup.ui.warner = DFRL.tools.CreateFontWarner(panel, 14, "", {1, 0, 0}, true, 3)
                        Setup.ui.warner:SetPoint("TOP", Setup.ui.frame, "BOTTOM", 0, 25)
                    end
                    Setup.ui.warner:SetTextColor(1, 0, 0)
                    if DFRL:IsFrench() then
                        Setup.ui.warner:SetText(clickedName .. " " .. DFRL:TR("deleted"))
                    else
                        Setup.ui.warner:SetText(clickedName .. " deleted")
                    end
                    Setup.ui.warner:Show()
                    Setup:RestartWarnerPulse()
                end)
                table.insert(self.ui.delBtns, delBtn)
            end

            yOffset = yOffset - 20
        end

    end

    function Setup:RestartWarnerPulse()
        if not self.ui.warnerFrame then
            self.ui.warnerFrame = CreateFrame("Frame")
        end
        self.ui.warnerFrame.elapsed = 0
        self.ui.warnerFrame.totalTime = 3
        self.ui.warnerFrame.direction = -1
        self.ui.warnerFrame.alpha = 1
        self.ui.warnerFrame:SetScript("OnUpdate", function()
            if not Setup.ui.warner:IsVisible() then
                this:SetScript("OnUpdate", nil)
                return
            end
            this.elapsed = this.elapsed + arg1
            this.alpha = this.alpha + this.direction * arg1 * 2
            if this.alpha <= 0.3 then
                this.alpha = 0.3
                this.direction = 1
            elseif this.alpha >= 1 then
                this.alpha = 1
                this.direction = -1
            end
            Setup.ui.warner:SetAlpha(this.alpha)
            if this.totalTime > 0 and this.elapsed >= this.totalTime then
                Setup.ui.warner:Hide()
                this:SetScript("OnUpdate", nil)
            end
        end)
    end

    function Setup:Update()
        Setup:ListFrame()
    end

    function Setup:ExtraButtons()
        if not self.ui.actionsHeader then
            self.ui.actionsHeader = DFRL.tools.CreateCategoryHeader(panel, "Quick Actions", false, 150, 24, 14)
            self.ui.actionsHeader:SetPoint("BOTTOMLEFT", self.ui.frame, "TOPRIGHT", 10, -22)
        end

        if not self.ui.newProfileBtn then
            self.ui.newProfileBtn = DFRL.tools.CreateButton(panel, "New Profile", 130, 30, true)
            self.ui.newProfileBtn:SetPoint("TOPLEFT", self.ui.frame, "TOPRIGHT", 20, -25)
            self.ui.newProfileBtn:SetScript("OnClick", function()
                local count = 0
                for _ in pairs(self.allProf) do
                    count = count + 1
                end
                if count >= 10 then
                    if not Setup.ui.warner then
                        Setup.ui.warner = DFRL.tools.CreateFontWarner(panel, 14, "", {1, 0, 0}, true, 3)
                        Setup.ui.warner:SetPoint("TOP", Setup.ui.frame, "BOTTOM", 0, 25)
                    end
                    Setup.ui.warner:SetTextColor(1, 0, 0)
                    Setup.ui.warner:SetText(DFRL:TR("MAX PROFILES REACHED"))
                    Setup.ui.warner:Show()
                    Setup:RestartWarnerPulse()
                    return
                end
                if not self.ui.editBox then
                    self.ui.editBox = DFRL.tools.CreateEditBox(panel, 200, 30, true, nil, 10)
                    self.ui.editBox:SetPoint("TOP", self.ui.frame, "BOTTOM", 0, -6)
                    self.ui.editBoxLabel = DFRL.tools.CreateFontWarner(panel, 14, "enter profile name", {.9, .9, .9})
                    self.ui.editBoxLabel:SetPoint("TOP", Setup.ui.frame, "BOTTOM", 0, -45)
                    self.ui.editBox:SetScript("OnEnterPressed", function()
                        local profileName = self.ui.editBox:GetText()
                        if profileName and profileName ~= "" then
                            DFRL:CreateProfile(profileName)
                            DFRL:SwitchProfile(profileName)
                            DFRL:SetTempDBNoCallback("Generic", "firstRun", true)
                            Setup:Update()
                            if DFRL.gui.Base.UpdateHandler then
                                DFRL.gui.Base:UpdateHandler()
                            end

                            if not Setup.ui.warner then
                                Setup.ui.warner = DFRL.tools.CreateFontWarner(panel, 14, "", {0, 1, 0}, true, 3)
                                Setup.ui.warner:SetPoint("TOP", Setup.ui.frame, "BOTTOM", 0, 25)
                            end
                            Setup.ui.warner:SetTextColor(0, 1, 0)
                            Setup.ui.warner:SetText(DFRL:TR("new profile created"))
                            Setup.ui.warner:Show()
                            Setup:RestartWarnerPulse()
                        end
                        self.ui.editBox:Hide()
                        self.ui.editBoxLabel:Hide()
                        self.ui.editBox:SetText("")
                    end)
                end
                self.ui.editBox:Show()
                self.ui.editBoxLabel:Show()
                self.ui.editBox:SetFocus()
            end)

        end
        if not self.ui.resetBtn then
            self.ui.resetBtn = DFRL.tools.CreateButton(panel, "Reset", 130, 30, true, {1, 0.5, 0.5})
            self.ui.resetBtn:SetPoint("TOPLEFT", self.ui.newProfileBtn, "BOTTOMLEFT", 0, -10)
            self.ui.resetBtn:SetScript("OnClick", function()
                local success, _ = pcall(function()
                    DFRL:CopyProfile(nil, Setup.default["Default"])
                    DFRL.gui.Base:UpdateHandler()
                end)
                if success then
                    if not Setup.ui.warner then
                        Setup.ui.warner = DFRL.tools.CreateFontWarner(panel, 14, "", {0, 1, 0}, true, 3)
                        Setup.ui.warner:SetPoint("TOP", Setup.ui.frame, "BOTTOM", 0, 25)
                    end
                    Setup.ui.warner:SetTextColor(0, 1, 0)
                    Setup.ui.warner:SetText(DFRL:TR("CURRENT PROFILE RESET"))
                    Setup.ui.warner:Show()
                    Setup:RestartWarnerPulse()
                else
                    if not Setup.ui.warner then
                        Setup.ui.warner = DFRL.tools.CreateFontWarner(panel, 14, "", {1, 0, 0}, true, 3)
                        Setup.ui.warner:SetPoint("TOP", Setup.ui.frame, "BOTTOM", 0, 25)
                    end
                    Setup.ui.warner:SetTextColor(1, 0, 0)
                    Setup.ui.warner:SetText(DFRL:TR("PROFILE RESET FAILED"))
                    Setup.ui.warner:Show()
                    Setup:RestartWarnerPulse()
                end
            end)

        end
        if not self.ui.saveBtn then
            self.ui.saveBtn = DFRL.tools.CreateButton(panel, "Save Profile", 130, 30, true, {0.5, 1, 0.5})
            self.ui.saveBtn:SetPoint("TOPLEFT", self.ui.resetBtn, "BOTTOMLEFT", 0, -10)
            self.ui.saveBtn:SetScript("OnClick", function()
                DFRL:SaveTempDB()
                if not Setup.ui.warner then
                    Setup.ui.warner = DFRL.tools.CreateFontWarner(panel, 14, "", {0, 1, 0}, true, 3)
                    Setup.ui.warner:SetPoint("TOP", Setup.ui.frame, "BOTTOM", 0, 25)
                end
                Setup.ui.warner:SetTextColor(0, 1, 0)
                Setup.ui.warner:SetText(DFRL:TR("profile saved"))
                Setup.ui.warner:Show()
                Setup:RestartWarnerPulse()
            end)
        end
    end

    --=================
    -- INIT
    --=================
    function Setup:Run()
        Setup.grid:Init()
        self:ListFrame()
        self:ExtraButtons()
        self:Update()
    end

    Setup:Run()
    panel:EnableMouseWheel(true)
    panel:SetScript("OnMouseWheel", function() end)
end)