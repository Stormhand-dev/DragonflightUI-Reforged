DFRL:NewDefaults("Gui-info", {
    enabled = {true},
})

DFRL:NewMod("Gui-info", 5, function()
    --=================
    -- SETUP
    --=================
    local Base = DFRL.gui.Base
    local panel = Base.scrollChildren[2]
    local Setup = {
        font = DFRL:GetInfoOrCons("font"),
        grid = DFRL.tools.CreateGrid(Base.scrollChildren[2], 33, 25),

        AREA_LINE = 1,

        dfFrame = nil,
        perfFrame = nil,
        scriptsFrame = nil,
        addonsFrame = nil,

        scriptTexts = {},
        statusTexts = {},
        addonTexts = {},
        perfTexts = {},
        totalText = nil,
        totalCountText = nil,
        spacesAdded = false,

        UPDATE_INTERVAL = 0.1,
        TEXT_SIZE = 14,
    }

    function Setup:DFInfo()
        if not self.dfinfo then
            self.dfFrame = CreateFrame("Frame", nil, panel)
            self.dfFrame:SetHeight(1)
            self.dfFrame:SetWidth(300)
            self.grid:AddElement(2, 2, self.dfFrame)
            self.grid:AddElement(2, 1, DFRL.tools.CreateCategoryHeader(nil, "Dragonflight Info"))
            self.grid:AddElement(1, 3, DFRL.tools.CreateCategoryHeader(nil, "System", nil, 100))
            self.grid:AddElement(3, 3, DFRL.tools.CreateCategoryHeader(nil, "Info", nil, 100))
            self.grid:AddElement(1, 5, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, "Addon Version:", nil, "LEFT"))
            self.grid:AddElement(3, 5, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, DFRL:GetInfoOrCons("version"), {0.5, 1, 0.5}))
            self.grid:AddElement(1, 6, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, "Database Version:", nil, "LEFT"))
            self.grid:AddElement(3, 6, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, DFRL.DBversion, {0.5, 1, 0.5}))
            local total = 0
            for _ in pairs(DFRL.performance) do
                total = total + 1
            end
            self.grid:AddElement(1, 7, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, "Last Update:", nil, "LEFT"))
            self.grid:AddElement(3, 7, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, (DFRL_DB_SETUP and DFRL_DB_SETUP.lastVersionCheck and DFRL_DB_SETUP.lastVersionCheck.date) or "Never", {0.5, 1, 0.5}))
            self.grid:AddElement(1, 8, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, "Active Modules:", nil, "LEFT"))
            self.grid:AddElement(3, 8, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, total, {0.5, 1, 0.5}))

            local clientVersion, buildNumber, _, _ = GetBuildInfo()
            local locale = GetLocale()
            local realm = GetRealmName()

            self.grid:AddElement(1, 10, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, "Client Version:", nil, "LEFT"))
            self.grid:AddElement(3, 10, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, clientVersion, {0.5, 0.5, 0.5}))
            self.grid:AddElement(1, 11, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, "Build Number:", nil, "LEFT"))
            self.grid:AddElement(3, 11, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, buildNumber, {0.5, 0.5, 0.5}))
            self.grid:AddElement(1, 12, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, "Locale:", nil, "LEFT"))
            self.grid:AddElement(3, 12, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, locale, {0.5, 0.5, 0.5}))
            self.grid:AddElement(1, 13, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, "Realm:", nil, "LEFT"))
            self.grid:AddElement(3, 13, DFRL.tools.CreateFont(self.dfFrame, self.TEXT_SIZE, realm, {0.5, 0.5, 0.5}))
            T.GradientLine(self.dfFrame, "TOP", 35)
            T.GradientLine(self.dfFrame, "TOP", -5)
            self.dfinfo = true
        end
    end

    function Setup:SupportedAddons()
        if not self.addons then
            self.addonsFrame = CreateFrame("Frame", nil, panel)
            self.addonsFrame:SetHeight(1)
            self.addonsFrame:SetWidth(300)
            self.grid:AddElement(5, 2, self.addonsFrame)
            self.grid:AddElement(5, 1, DFRL.tools.CreateCategoryHeader(nil, "Supported Addons"))
            self.grid:AddElement(4, 3, DFRL.tools.CreateCategoryHeader(nil, "Addon", nil, 100))
            self.grid:AddElement(6, 3, DFRL.tools.CreateCategoryHeader(nil, "Status", nil, 100))
            self.grid:AddElement(4, 5, DFRL.tools.CreateFont(self.addonsFrame, self.TEXT_SIZE, "ShaguTweaks", nil, "LEFT"))
            self.grid:AddElement(6, 5, DFRL.tools.CreateFont(self.addonsFrame, self.TEXT_SIZE, DFRL.addon1 and "Installed" or "Not installed", DFRL.addon1 and {0.5, 1, 0.5} or {0.5, 0.5, 0.5}))
            self.grid:AddElement(4, 6, DFRL.tools.CreateFont(self.addonsFrame, self.TEXT_SIZE, "ShaguTweaks-extras", nil, "LEFT"))
            self.grid:AddElement(6, 6, DFRL.tools.CreateFont(self.addonsFrame, self.TEXT_SIZE, DFRL.addon2 and "Installed" or "Not installed", DFRL.addon2 and {0.5, 1, 0.5} or {0.5, 0.5, 0.5}))
            self.grid:AddElement(4, 7, DFRL.tools.CreateFont(self.addonsFrame, self.TEXT_SIZE, "Bagshui", nil, "LEFT"))
            self.grid:AddElement(6, 7, DFRL.tools.CreateFont(self.addonsFrame, self.TEXT_SIZE, DFRL.addon3 and "Installed" or "Not installed", DFRL.addon3 and {0.5, 1, 0.5} or {0.5, 0.5, 0.5}))

self.grid:AddElement(4, 8,
    DFRL.tools.CreateFont(self.addonsFrame, self.TEXT_SIZE, "Immersion", nil, "LEFT")
)

self.grid:AddElement(6, 8,
    DFRL.tools.CreateFont(
        self.addonsFrame,
        self.TEXT_SIZE,
        DFRL.addon4 and "Installed" or "Not installed",
        DFRL.addon4 and {0.5, 1, 0.5} or {0.5, 0.5, 0.5}
    )
)

            T.GradientLine(self.addonsFrame, "TOP", 35)
            T.GradientLine(self.addonsFrame, "TOP", -5)
            self.addons = true
        end
    end

    function Setup:Performance()
        if not self.perf then
            self.perfFrame = CreateFrame("Frame", nil, panel)
            self.perfFrame:SetHeight(1)
            self.perfFrame:SetWidth(300)
            self.grid:AddElement(2, 17 + self.AREA_LINE, self.perfFrame)
            self.grid:AddElement(2, 16 + self.AREA_LINE, DFRL.tools.CreateCategoryHeader(nil, "Performance"))
            self.grid:AddElement(1, 18 + self.AREA_LINE, DFRL.tools.CreateCategoryHeader(nil, "Module", nil, 100))
            self.grid:AddElement(2, 18 + self.AREA_LINE, DFRL.tools.CreateCategoryHeader(nil, "Time (ms)", nil, 100))
            self.grid:AddElement(3, 18 + self.AREA_LINE, DFRL.tools.CreateCategoryHeader(nil, "Memory (kb)", nil, 100))
            T.GradientLine(self.perfFrame, "TOP", 35)
            T.GradientLine(self.perfFrame, "TOP", -5)
            self.perf = true
        end

        local gui = {}
        local other = {}
        local totalTime = 0
        local totalMem = 0

        for modName, perfData in pairs(DFRL.performance) do
            local entry = {name = modName, data = perfData}
            totalTime = totalTime + perfData.time
            totalMem = totalMem + perfData.memory
            if string.upper(string.sub(modName, 1, 3)) == "GUI" then
                table.insert(gui, entry)
            else
                table.insert(other, entry)
            end
        end

        table.sort(gui, function(a, b) return a.data.memory > b.data.memory end)
        table.sort(other, function(a, b) return a.data.memory > b.data.memory end)

        local line = 20 + self.AREA_LINE
        if not self.perfTexts[1] then
            self.perfTexts[1] = DFRL.tools.CreateFont(self.perfFrame, self.TEXT_SIZE, "TOTAL:", {1, 0.5, 0.5}, "LEFT")
            self.perfTexts[2] = DFRL.tools.CreateFont(self.perfFrame, self.TEXT_SIZE, "", {0.5, 1, 0.5})
            self.perfTexts[3] = DFRL.tools.CreateFont(self.perfFrame, self.TEXT_SIZE, "", {0.5, 1, 0.5})
            self.grid:AddElement(1, line, self.perfTexts[1])
            self.grid:AddElement(2, line, self.perfTexts[2])
            self.grid:AddElement(3, line, self.perfTexts[3])

        end
        self.perfTexts[2]:SetText(string.format("%.2f", totalTime * 1000))
        self.perfTexts[3]:SetText(string.format("%.1f", totalMem))
        line = line + 2

        local idx = 4
        for i = 1, table.getn(gui) do
            local entry = gui[i]
            if not self.perfTexts[idx] then
                self.perfTexts[idx] = DFRL.tools.CreateFont(self.perfFrame, self.TEXT_SIZE, "", nil, "LEFT")
                self.perfTexts[idx+1] = DFRL.tools.CreateFont(self.perfFrame, self.TEXT_SIZE, "")
                self.perfTexts[idx+2] = DFRL.tools.CreateFont(self.perfFrame, self.TEXT_SIZE, "")
                self.grid:AddElement(1, line, self.perfTexts[idx])
                self.grid:AddElement(2, line, self.perfTexts[idx+1])
                self.grid:AddElement(3, line, self.perfTexts[idx+2])
            end
            self.perfTexts[idx]:SetText(entry.name)
            self.perfTexts[idx+1]:SetText(string.format("%.2f", entry.data.time * 1000))
            self.perfTexts[idx+2]:SetText(string.format("%.1f", entry.data.memory))
            line = line + 1
            idx = idx + 3
        end

        line = line + 1

        for i = 1, table.getn(other) do
            local entry = other[i]
            if not self.perfTexts[idx] then
                self.perfTexts[idx] = DFRL.tools.CreateFont(self.perfFrame, self.TEXT_SIZE, "", nil, "LEFT")
                self.perfTexts[idx+1] = DFRL.tools.CreateFont(self.perfFrame, self.TEXT_SIZE, "")
                self.perfTexts[idx+2] = DFRL.tools.CreateFont(self.perfFrame, self.TEXT_SIZE, "")
                self.grid:AddElement(1, line, self.perfTexts[idx])
                self.grid:AddElement(2, line, self.perfTexts[idx+1])
                self.grid:AddElement(3, line, self.perfTexts[idx+2])
            end
            self.perfTexts[idx]:SetText(entry.name)
            self.perfTexts[idx+1]:SetText(string.format("%.2f", entry.data.time * 1000))
            self.perfTexts[idx+2]:SetText(string.format("%.1f", entry.data.memory))
            line = line + 1
            idx = idx + 3
        end
    end

    function Setup:ActiveScripts()
        if not self.scripts then
            self.scriptsFrame = CreateFrame("Frame", nil, panel)
            self.scriptsFrame:SetHeight(1)
            self.scriptsFrame:SetWidth(300)
            self.grid:AddElement(5, 17 + self.AREA_LINE, self.scriptsFrame)
            self.grid:AddElement(5, 16 + self.AREA_LINE, DFRL.tools.CreateCategoryHeader(nil, "Active Scripts"))
            self.grid:AddElement(4, 18 + self.AREA_LINE, DFRL.tools.CreateCategoryHeader(nil, "Script", nil, 100))
            self.grid:AddElement(6, 18 + self.AREA_LINE, DFRL.tools.CreateCategoryHeader(nil, "Status", nil, 100))
            T.GradientLine(self.scriptsFrame, "TOP", 35)
            T.GradientLine(self.scriptsFrame, "TOP", -5)
            self.scripts = true
        end

        local totalScripts = 0
        local activeCount = 0
        for _, status in pairs(DFRL.activeScripts) do
            totalScripts = totalScripts + 1
            if status then
                activeCount = activeCount + 1
            end
        end

        local line = 20 + self.AREA_LINE
        if not self.totalText then
            self.totalText = DFRL.tools.CreateFont(self.scriptsFrame, self.TEXT_SIZE, "TOTAL:", {1, 0.5, 0.5}, "LEFT")
            self.grid:AddElement(4, line, self.totalText)
        end
        if not self.totalCountText then
            self.totalCountText = DFRL.tools.CreateFont(self.scriptsFrame, self.TEXT_SIZE, "", {0.5, 1, 0.5})
            self.grid:AddElement(6, line, self.totalCountText)
        end
        self.totalCountText:SetText(activeCount .. " / " .. totalScripts)
        line = line + 2

        local gui = {}
        local other = {}

        for scriptName, status in pairs(DFRL.activeScripts) do
            if string.upper(string.sub(scriptName, 1, 3)) == "GUI" then
                table.insert(gui, scriptName)
            else
                table.insert(other, scriptName)
            end
        end

        table.sort(gui)
        table.sort(other)

        local index = 1

        for i = 1, table.getn(gui) do
            local scriptName = gui[i]
            local scriptText = self.scriptTexts[index]
            if not scriptText then
                scriptText = DFRL.tools.CreateFont(self.scriptsFrame, self.TEXT_SIZE, "", nil, "LEFT")
                self.scriptTexts[index] = scriptText
            end
            self.grid:AddElement(4, line, scriptText)
            scriptText:Show()

            local statusText = self.statusTexts[index]
            if not statusText then
                statusText = DFRL.tools.CreateFont(self.scriptsFrame, self.TEXT_SIZE, "", nil)
                self.statusTexts[index] = statusText
            end
            self.grid:AddElement(6, line, statusText)
            statusText:Show()

            scriptText:SetText(scriptName)
            scriptText:SetTextColor(1, 1, 1)

            statusText:SetText(DFRL:TR(DFRL.activeScripts[scriptName] and "ON" or "OFF"))
            statusText:SetTextColor(DFRL.activeScripts[scriptName] and 0 or 0.5, DFRL.activeScripts[scriptName] and 1 or 0.5, DFRL.activeScripts[scriptName] and 0 or 0.5)

            index = index + 1
            line = line + 1
        end

        line = line + 1

        for i = 1, table.getn(other) do
            local scriptName = other[i]
            local scriptText = self.scriptTexts[index]
            if not scriptText then
                scriptText = DFRL.tools.CreateFont(self.scriptsFrame, self.TEXT_SIZE, "", nil, "LEFT")
                self.scriptTexts[index] = scriptText
            end
            self.grid:AddElement(4, line, scriptText)
            scriptText:Show()

            local statusText = self.statusTexts[index]
            if not statusText then
                statusText = DFRL.tools.CreateFont(self.scriptsFrame, self.TEXT_SIZE, "", nil)
                self.statusTexts[index] = statusText
            end
            self.grid:AddElement(6, line, statusText)
            statusText:Show()

            scriptText:SetText(scriptName)
            scriptText:SetTextColor(1, 1, 1)

            statusText:SetText(DFRL:TR(DFRL.activeScripts[scriptName] and "ON" or "OFF"))
            statusText:SetTextColor(DFRL.activeScripts[scriptName] and 0 or 0.5, DFRL.activeScripts[scriptName] and 1 or 0.5, DFRL.activeScripts[scriptName] and 0 or 0.5)

            index = index + 1
            line = line + 1
        end

        for i = index, table.getn(self.scriptTexts) do
            if self.scriptTexts[i] then
                self.scriptTexts[i]:Hide()
            end
            if self.statusTexts[i] then
                self.statusTexts[i]:Hide()
            end
        end
    end

    --=================
    -- INIT
    --=================
    function Setup:Run()
        Setup.grid:Init()
        Setup:DFInfo()
        Setup:ActiveScripts()
    end

    Setup:Run()

    --=================
    -- EVENT
    --=================
    local f = CreateFrame("Frame")
    local lastUpdate = 0
    local perfDone = false
    f:SetScript("OnUpdate", function()
        local time = GetTime()
        if time - lastUpdate >= Setup.UPDATE_INTERVAL then
            Setup:ActiveScripts()
            if not perfDone then
                Setup:Performance()
                        Setup:SupportedAddons()

                perfDone = true
            end
            lastUpdate = time
        end
    end)
end)