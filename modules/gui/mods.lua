DFRL:NewDefaults("Gui-mods", {
    enabled = {true},

})

DFRL:NewMod("Gui-mods", 3, function()
    --=================
    -- SETUP
    --=================
    local Base = DFRL.gui.Base
    local panel = Base.scrollChildren[4]
    local Setup = {
        font = DFRL:GetInfoOrCons("font"),
        grid = DFRL.tools.CreateGrid(panel, 33, 25),

        descFont = nil,
        reloadFont = nil,
        reloadBtn = nil,
        TEXT_SIZE = 14,
        init = false
    }

    function Setup:Modules()
        if not self.init then
            self.descFont = DFRL.tools.CreateFont(panel, self.TEXT_SIZE, "Enable or disable addon modules. Changes require UI reload to take effect.", {0.5, 0.5, 0.5}, "CENTER")
            self.descFont:SetPoint("TOP", panel, "TOP", 0, -60)

            local modules = {}

            for moduleName, _ in pairs(DFRL.modules) do
                if not string.find(string.upper(moduleName), "GUI") then
                    table.insert(modules, moduleName)
                end
            end
            T.GradientLine(panel, "TOP", -20, 2, 400)
            T.GradientLine(panel, "TOP", -400, 2, 400)

            table.sort(modules)

            local row, line, count = 1, 6, 0
            local maxPerRow = 4

            for i = 1, table.getn(modules) do
                if count >= maxPerRow then
                    row = row + 1
                    line = 6
                    count = 0
                end

                local moduleName = modules[i]
                local checkbox = DFRL.tools.CreateCheckbox(nil, nil, moduleName, "enabled", true)
                checkbox.label:SetText(DFRL:TR(moduleName))
                self.grid:AddElement(row, line, checkbox)

                line = line + 1
                count = count + 1
            end

            self.reloadFont = DFRL.tools.CreateFont(panel, self.TEXT_SIZE, "Changes take effect after reload:", {0.5, 0.5, 0.5}, "CENTER")
            self.reloadFont:SetPoint("CENTER", panel, "CENTER", 12, 60)
            self.reloadBtn = DFRL.tools.CreateButton(panel, "Reload UI", 140, 30, true, {1, 0.5, 0.5})
            self.reloadBtn:SetPoint("TOP", self.reloadFont, "BOTTOM", 0, -5)
            self.reloadBtn:SetScript("OnClick", function()
                ReloadUI()
            end)
            self.init = true
        end
    end

    --=================
    -- INIT
    --=================
    function Setup:Run()
        Setup.grid:Init()
        Setup:Modules()
    end

    Setup:Run()
    panel:EnableMouseWheel(true)
    panel:SetScript("OnMouseWheel", function() end)
end)