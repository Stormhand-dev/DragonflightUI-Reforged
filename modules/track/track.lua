DFRL:NewDefaults("UpdateNotifier", {
    enabled = {true},
    updateDays = {"7"},
})

DFRL:NewMod("UpdateNotifier", 1, function()
    local Setup = {
        font = DFRL:GetInfoOrCons("font"),
        version = DFRL:GetInfoOrCons("version"),
        updateDays = 7,
        frame = nil,
        txt1 = nil,
        txt2 = nil,
        dd = nil,
        btn = nil,
        closeBtn = nil,
    }

    function Setup:ParseDate(dateStr)
        local slash1 = string.find(dateStr, "/")
        local slash2 = string.find(dateStr, "/", slash1 + 1)
        if slash1 and slash2 then
            local day = tonumber(string.sub(dateStr, 1, slash1 - 1))
            local month = tonumber(string.sub(dateStr, slash1 + 1, slash2 - 1))
            local year = tonumber(string.sub(dateStr, slash2 + 1))
            if day and month and year then
                local timestamp = time({year = year, month = month, day = day})
                return timestamp
            end
        end
        return nil
    end

    function Setup:CheckVersionUpdate()
        local stored = DFRL_DB_SETUP.lastVersionCheck

        if not stored or stored.version ~= self.version then
            DFRL_DB_SETUP.lastVersionCheck = {
                version = self.version,
                date = date("%d/%m/%Y")
            }
        end
    end

    function Setup:IsUpdateOverdue()
        local stored = DFRL_DB_SETUP.lastVersionCheck

        if stored and stored.date then
            local setting = DFRL:GetTempDB("UpdateNotifier", "updateDays")

            if setting == "never" then
                return false
            end

            local days = tonumber(setting) or self.updateDays

            local storedTime = self:ParseDate(stored.date)
            local todayTime = time()

            if storedTime then
                local daysDiff = math.floor((todayTime - storedTime) / 86400)
                local overdue = daysDiff >= days
                return overdue
            end
        end
        return false
    end

    function Setup:ShowNotification()
        if not self.frame then
            self.frame = DFRL.tools.CreateDFRLFrame(nil, 400, 120, "BOTTOM")
            self.frame:SetPoint("TOP", UIParent, "TOP", 0, 120)
            self.frame:SetFrameStrata("HIGH")
        end
        DFRL.tools.MoveFrame(self.frame, 0, -1, .3, 120)

        local stored = DFRL_DB_SETUP.lastVersionCheck
        local lastDate = "UNKNOWN"
        if stored and stored.date then
            lastDate = tostring(stored.date)
        end

        if not self.txt1 then
            self.txt1 = DFRL.tools.CreateFont(self.frame, 13, "LAST UPDATE WAS ON |CFFFF0000" .. lastDate .. "|r.")
            self.txt1:SetPoint("TOP", self.frame, "TOP", 0, -15)
        end

        if not self.txt2 then
            self.txt2 = DFRL.tools.CreateFont(self.frame, 13, "Remember to update |cFFFFD100Dragonflight:|r Reloaded.")
            self.txt2:SetPoint("TOP", self.txt1, "BOTTOM", 0, -5)
        end

        if not self.dd then
            self.dd = DFRL.tools.CreateDropDown(self.frame, "Days to remind again:", "UpdateNotifier", "updateDays", {"7", "14", "30", "never"}, true, 20, 60)
            self.dd:SetPoint("CENTER", self.frame, "CENTER", 0, -15)
        end

        if not self.btn then
            self.btn = DFRL.tools.CreateButton(self.frame, "OK", 60, 20)
            self.btn:SetPoint("BOTTOM", self.frame, "BOTTOM", 0, 10)
            self.btn:SetScript("OnClick", function()
                DFRL_DB_SETUP.lastVersionCheck.date = date("%d/%m/%Y")
                DFRL.tools.MoveFrame(self.frame, 0, 1, .3, 120)
            end)
        end

        if not self.closeBtn then
            self.closeBtn = CreateFrame("Button", nil, self.frame)
            self.closeBtn:SetWidth(18)
            self.closeBtn:SetHeight(18)
            self.closeBtn:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -6, -6)
            self.closeBtn:SetFrameStrata(self.frame:GetFrameStrata())

            self.closeBtn.text = self.closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self.closeBtn.text:SetAllPoints()
            self.closeBtn.text:SetText("X")

            self.closeBtn:SetScript("OnEnter", function()
                if self.closeBtn.text then
                    self.closeBtn.text:SetTextColor(1, 0.2, 0.2)
                end
            end)

            self.closeBtn:SetScript("OnLeave", function()
                if self.closeBtn.text then
                    self.closeBtn.text:SetTextColor(1, 0.82, 0)
                end
            end)

            self.closeBtn:SetScript("OnClick", function()
                DFRL.tools.MoveFrame(self.frame, 0, 1, .3, 120)
            end)

            self.closeBtn.text:SetTextColor(1, 0.82, 0)
        end
    end

    function Setup:Run()
        self:CheckVersionUpdate()
    end

    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function()
        Setup:Run()
        local start = time()
        f:SetScript("OnUpdate", function()
            if time() - start >= 3 then
                f:SetScript("OnUpdate", nil)
                if Setup:IsUpdateOverdue() then
                    Setup:ShowNotification()
                end
                f:UnregisterEvent("PLAYER_ENTERING_WORLD")
            end
        end)
    end)
end)
