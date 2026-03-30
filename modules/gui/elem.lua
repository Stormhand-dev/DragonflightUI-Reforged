DFRL:NewDefaults("Gui-elem", {
    enabled = {true},
})

DFRL:NewMod("Gui-elem", 3, function()

    --=================
    -- SETUP THE BEAST
    --=================
    local pairs = pairs
    local ipairs = ipairs
    local table = table
    local string = string
    local type = type
    local tonumber = tonumber

    local Base = DFRL.gui.Base
    local Setup = {
        font = DFRL:GetInfoOrCons("font"),

        metadata = {},
        checkboxes = {},
        sliders = {},
        dropdowns = {},
        colours = {},
        descriptionLabels = {},
        extraDescriptionLabels = {},
        headers = {},
        moduleHeaders = {},
        dependenciesSetup = false,
        tabPositions = {},
        configCache = {},

        DESCRIPTION_FONT_SIZE = 15,
        EXTRA_DESCRIPTION_FONT_SIZE = 11,
        VALUE_FONT_SIZE = 14,

        MODULE_TOP_SPACING = 40,
        MODULE_BOTTOM_SPACING = 40,
        HEADER_TOP_SPACING = 40,
        HEADER_BOTTOM_SPACING = 25,
        CHECKBOX_TOP_SPACING = 25,
        CHECKBOX_ROW_SPACING = 25,
        SLIDER_TOP_SPACING = 25,
        SLIDER_ROW_SPACING = 25,
        DROPDOWN_TOP_SPACING = 17,
        DROPDOWN_ROW_SPACING = 25,
        COLOUR_TOP_SPACING = 25,
        COLOUR_ROW_SPACING = 25,
        MODULE_SPACING = 25,
                --             [1] = "Home",
                --             [2] = "Info",
                --             [3] = "Profiles",
                --             [4] = "Modules",
                --             [5] = "ShaguTweaks",

                --             [6] = "Actionbars",
                --             [7] = "Bags",
                --             [8] = "Castbar",
                --             [9] = "Chat",
                --             [10] = "Interface",
                --             [11] = "Micromenu",
                --             [12] = "Minimap",
                --             [13] = "Tooltip",
                --             [14] = "Unitframes",
                --             [15] = "Xprep",
        moduleMapping = {
            ["Bars"]    = {6, 1},
            ["RangeIndicator"]    = {6, 2},
            ["Bags"]    = {7, 1},
            ["Cast"]    = {8, 1},
            ["Chat"]    = {9, 1},
            ["GUI-Dragonflight"]   = {10, 1},
            ["Errors"]      = {10, 2},
            ["Tooltip"]      = {10, 3},
            ["Ui"]      = {10, 4},
            ["Micro"]   = {11, 1},
            ["Collector"] = {12, 1},
            ["Map"]     = {12, 2},
            ["Player"]  = {14, 1},
            ["PVPIcon"]  = {14, 2},
            ["Target"]  = {14, 3},
            ["Mini"]    = {14, 4},
            ["Xprep"]   = {15, 1},
        },
    }

    function Setup:MetaData()

        for moduleName, defaults in pairs(DFRL.defaults) do
            for elementName, valueTable in pairs(defaults) do
                if elementName ~= "enabled" and table.getn(valueTable) > 1 then

                    local typeMeta = valueTable[3]
                    if valueTable[2] == "slider" and type(typeMeta) == "table" then
                        typeMeta = {
                            min = typeMeta[1],
                            max = typeMeta[2],
                            step = typeMeta[3]
                        }
                    elseif valueTable[2] == "dropdown" and type(typeMeta) == "table" then
                        typeMeta = {
                            items = typeMeta
                        }
                    end

                    self.metadata[moduleName .. "." .. elementName] = {
                        elementType = valueTable[2],
                        elementTypeMeta = typeMeta,
                        dependency = valueTable[4],
                        category = valueTable[5],
                        categoryIndex = valueTable[6],
                        description = valueTable[7],
                        extraDescription = valueTable[8],
                        status = valueTable[9]
                    }
                end
            end
        end

        local count = 0
        for _ in pairs(self.metadata) do
            count = count + 1
        end


    end

    function Setup:Elements()

        -- group elements by module and category
        local moduleElements = {}
        local moduleCategories = {}

        -- process each module directly from dfrl.defaults
        for moduleName, defaults in pairs(DFRL.defaults) do
            if self.moduleMapping[moduleName] then
                local enabledValue = DFRL.tempDB[moduleName] and DFRL.tempDB[moduleName].enabled
                if enabledValue == true then
                local tabIndex = self.moduleMapping[moduleName][1]

                if not moduleElements[moduleName] then
                    moduleElements[moduleName] = {}
                    moduleCategories[moduleName] = {}
                end

                for elementName, valueTable in pairs(defaults) do
                    if elementName ~= "enabled" and table.getn(valueTable) > 1 then
                        local metaKey = moduleName .. "." .. elementName
                        local data = self.metadata[metaKey]

                        if data then
                            if data.category then
                                local categoryKey = tabIndex .. "_" .. moduleName .. "_" .. data.category
                                if not moduleCategories[moduleName][categoryKey] then
                                    moduleCategories[moduleName][categoryKey] = {
                                        category = data.category,
                                        tabIndex = tabIndex,
                                        categoryIndex = data.categoryIndex or 1
                                    }
                                end
                            end

                            if data.elementType == "checkbox" or data.elementType == "slider" or data.elementType == "dropdown" or data.elementType == "colour" then
                                local categoryKey = tabIndex .. "_" .. moduleName .. "_" .. (data.category or "default")

                                if not moduleElements[moduleName][categoryKey] then
                                    moduleElements[moduleName][categoryKey] = {}
                                end

                                table.insert(moduleElements[moduleName][categoryKey], {
                                    name = elementName,
                                    data = data,
                                    module = moduleName,
                                    tabIndex = tabIndex
                                })
                            end
                        end
                    end
                end
                end
            end
        end

        -- create sorted list of modules by their order
        local sortedModules = {}
        for moduleName, moduleData in pairs(self.moduleMapping) do
            if moduleElements[moduleName] then
                table.insert(sortedModules, {
                    name = moduleName,
                    order = moduleData[2] -- second value is the order
                })
            end
        end
        table.sort(sortedModules, function(a, b)
            return a.order < b.order
        end)

        -- process each module in order
        for _, moduleInfo in ipairs(sortedModules) do
            local moduleName = moduleInfo.name
            local tabIndex = self.moduleMapping[moduleName][1]
            local scrollChild = Base.scrollChildren[tabIndex]



            if not self.tabPositions[tabIndex] then
                self.tabPositions[tabIndex] = -self.HEADER_TOP_SPACING
            end

            local moduleKey = tabIndex .. "_" .. moduleName
            if not self.moduleHeaders[moduleKey] then
                local moduleHeader = DFRL.tools.CreateCategoryHeader(scrollChild, moduleName, nil, 300, 50, 30)
                moduleHeader:SetPoint("TOP", scrollChild, "TOP", -200, self.tabPositions[tabIndex] - 40)
                self.moduleHeaders[moduleKey] = moduleHeader
                self.tabPositions[tabIndex] = self.tabPositions[tabIndex] - self.MODULE_TOP_SPACING - self.MODULE_BOTTOM_SPACING
            end

            local sortedCategories = {}
            for categoryKey, categoryData in pairs(moduleCategories[moduleName] or {}) do
                table.insert(sortedCategories, {key = categoryKey, data = categoryData})
            end
            table.sort(sortedCategories, function(a, b)
                local aIndex = tonumber(a.data.categoryIndex) or 999
                local bIndex = tonumber(b.data.categoryIndex) or 999
                return aIndex < bIndex
            end)

            for i, categoryInfo in ipairs(sortedCategories) do
                local categoryKey = categoryInfo.key
                local categoryData = categoryInfo.data

                if i > 1 then
                    self.tabPositions[tabIndex] = self.tabPositions[tabIndex] - self.HEADER_TOP_SPACING
                end

                local yOffset = self.tabPositions[tabIndex]

                if not self.headers[categoryKey] then
                    local header = DFRL.tools.CreateCategoryHeader(scrollChild, categoryData.category)
                    header:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 10, yOffset - 25)
                    self.headers[categoryKey] = header

                    self.tabPositions[tabIndex] = yOffset - self.HEADER_BOTTOM_SPACING
                end

                local elements = moduleElements[moduleName][categoryKey] or {}
                table.sort(elements, function(a, b)
                    local aIndex = tonumber(a.data.categoryIndex) or 999
                    local bIndex = tonumber(b.data.categoryIndex) or 999
                    return aIndex < bIndex
                end)

                for _, element in ipairs(elements) do
                    local elementName = element.name
                    local data = element.data
                    local elementModule = element.module

                    local currentValue = self:GetCache(elementModule, elementName)
                    local dependencyEnabled = true

                    if data.dependency then
                        local depValue = self:GetCache(elementModule, data.dependency)
                        dependencyEnabled = depValue == true
                    end

                    local topSpacing = self.CHECKBOX_TOP_SPACING
                    local rowSpacing = self.CHECKBOX_ROW_SPACING
                    if data.elementType == "slider" then
                        topSpacing = self.SLIDER_TOP_SPACING
                        rowSpacing = self.SLIDER_ROW_SPACING
                    elseif data.elementType == "dropdown" then
                        topSpacing = self.DROPDOWN_TOP_SPACING
                        rowSpacing = self.DROPDOWN_ROW_SPACING
                    elseif data.elementType == "colour" then
                        topSpacing = self.COLOUR_TOP_SPACING
                        rowSpacing = self.COLOUR_ROW_SPACING
                    end

                    local spacing = topSpacing + rowSpacing
                    self.tabPositions[tabIndex] = self.tabPositions[tabIndex] - spacing
                    local currentY = self.tabPositions[tabIndex]

                    if data.elementType == "checkbox" then
                        local elementKey = elementModule .. "." .. elementName
                        if not self.checkboxes[elementKey] then
                            local descLabel = scrollChild:CreateFontString(nil, "BACKGROUND")
                            descLabel:SetFont(self.font .. "BigNoodleTitling.ttf", self.DESCRIPTION_FONT_SIZE, "OUTLINE")
                            descLabel:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 10, currentY - 3)
                            descLabel:SetText(DFRL:TR(data.description or ""))
                            descLabel:SetTextColor(.9,.9,.9)

                            if data.extraDescription then
                                local extraDescLabel = scrollChild:CreateFontString(nil, "BACKGROUND")
                                extraDescLabel:SetFont(self.font .. "BigNoodleTitling.ttf", self.EXTRA_DESCRIPTION_FONT_SIZE, "OUTLINE")
                                extraDescLabel:SetPoint("LEFT", descLabel, "RIGHT", 10, 0)
                                extraDescLabel:SetText(DFRL:TR(data.extraDescription))
                                extraDescLabel:SetTextColor(1, 0.5, 0.5)
                                self.extraDescriptionLabels[elementName] = extraDescLabel
                            end

                            local checkbox = DFRL.tools.CreateCheckbox(scrollChild, nil, elementModule, elementName)
                            checkbox:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -150, currentY)
                            checkbox:SetChecked(currentValue)
                            if checkbox.label then
                                checkbox.label:SetFont(self.font .. "BigNoodleTitling.ttf", self.VALUE_FONT_SIZE, "OUTLINE")
                            end

                            self.checkboxes[elementKey] = checkbox
                            self.descriptionLabels[elementKey] = descLabel
                        end

                        local checkbox = self.checkboxes[elementKey]
                        local descLabel = self.descriptionLabels[elementKey]
                        local extraDescLabel = self.extraDescriptionLabels[elementKey]

                        if not dependencyEnabled then
                            if checkbox and checkbox.Disable then
                                checkbox:Disable()
                            end
                            if checkbox and checkbox.label then
                                checkbox.label:SetTextColor(0.5, 0.5, 0.5)
                            end
                            if descLabel then
                                descLabel:SetTextColor(0.5, 0.5, 0.5)
                            end
                            if extraDescLabel then
                                extraDescLabel:SetTextColor(0.5, 0.5, 0.5)
                            end
                        else
                            if checkbox and checkbox.Enable then
                                checkbox:Enable()
                            end
                            if checkbox and checkbox.label then
                                checkbox.label:SetTextColor(1, 1, 1)
                            end
                            if descLabel then
                                descLabel:SetTextColor(.9, .9, .9)
                            end
                            if extraDescLabel then
                                extraDescLabel:SetTextColor(1, 0.5, 0.5)
                            end
                        end

                    elseif data.elementType == "slider" then
                        local elementKey = elementModule .. "." .. elementName
                        if not self.sliders[elementKey] then
                            local descLabel = scrollChild:CreateFontString(nil, "BACKGROUND")
                            descLabel:SetFont(self.font .. "BigNoodleTitling.ttf", self.DESCRIPTION_FONT_SIZE, "OUTLINE")
                            descLabel:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 10, currentY - 6)
                            descLabel:SetText(DFRL:TR(data.description or ""))
                            descLabel:SetTextColor(.9,.9,.9)

                            if data.extraDescription then
                                local extraDescLabel = scrollChild:CreateFontString(nil, "BACKGROUND")
                                extraDescLabel:SetFont(self.font .. "BigNoodleTitling.ttf", self.EXTRA_DESCRIPTION_FONT_SIZE, "OUTLINE")
                                extraDescLabel:SetPoint("LEFT", descLabel, "RIGHT", 10, 0)
                                extraDescLabel:SetText(DFRL:TR(data.extraDescription))
                                extraDescLabel:SetTextColor(1, 0.5, 0.5)
                                self.extraDescriptionLabels[elementKey] = extraDescLabel
                            end

                            local typeMeta = data.elementTypeMeta
                            local slider = DFRL.tools.CreateSlider(scrollChild, nil, elementModule, elementName, typeMeta.min, typeMeta.max, typeMeta.step)
                            slider:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -30, currentY)
                            slider:SetValue(currentValue)
                            if slider.label then
                                slider.label:SetFont(self.font .. "BigNoodleTitling.ttf", self.VALUE_FONT_SIZE, "OUTLINE")
                            end

                            self.sliders[elementKey] = slider
                            self.descriptionLabels[elementKey] = descLabel
                        end

                        local slider = self.sliders[elementKey]
                        local descLabel = self.descriptionLabels[elementKey]
                        local extraDescLabel = self.extraDescriptionLabels[elementKey]

                        if not dependencyEnabled then
                            if slider and slider.Disable then
                                slider:Disable()
                            elseif slider then
                                slider.isDisabled = true
                                slider:EnableMouse(false)
                                slider:SetBackdropColor(0.5, 0.5, 0.5, 1)
                                slider:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
                                local thumbTexture = slider:GetThumbTexture()
                                if thumbTexture then
                                    thumbTexture:SetVertexColor(0.5, 0.5, 0.5)
                                end
                            end
                            if slider and slider.label then
                                slider.label:SetTextColor(0.5, 0.5, 0.5)
                            end
                            if slider and slider.valueText then
                                slider.valueText:SetTextColor(0.5, 0.5, 0.5)
                            end
                            if descLabel then
                                descLabel:SetTextColor(0.5, 0.5, 0.5)
                            end
                            if extraDescLabel then
                                extraDescLabel:SetTextColor(0.5, 0.5, 0.5)
                            end
                        else
                            if slider and slider.Enable then
                                slider:Enable()
                            elseif slider then
                                slider.isDisabled = false
                                slider:EnableMouse(true)
                                slider:SetBackdropColor(1, 1, 1, 1)
                                slider:SetBackdropBorderColor(1, 1, 1, 1)
                                local thumbTexture = slider:GetThumbTexture()
                                if thumbTexture then
                                    thumbTexture:SetVertexColor(1, 1, 1)
                                end
                            end
                            if slider and slider.label then
                                slider.label:SetTextColor(1, 1, 1)
                            end
                            if slider and slider.valueText then
                                slider.valueText:SetTextColor(1, 1, 1)
                            end
                            if descLabel then
                                descLabel:SetTextColor(.9, .9, .9)
                            end
                            if extraDescLabel then
                                extraDescLabel:SetTextColor(1, 0.5, 0.5)
                            end
                        end

                    elseif data.elementType == "dropdown" then
                        local elementKey = elementModule .. "." .. elementName
                        if not self.dropdowns[elementKey] then
                            local descLabel = scrollChild:CreateFontString(nil, "BACKGROUND")
                            descLabel:SetFont(self.font .. "BigNoodleTitling.ttf", self.DESCRIPTION_FONT_SIZE, "OUTLINE")
                            descLabel:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 10, currentY - 10)
                            descLabel:SetText(DFRL:TR(data.description or ""))
                            descLabel:SetTextColor(.9,.9,.9)

                            if data.extraDescription then
                                local extraDescLabel = scrollChild:CreateFontString(nil, "BACKGROUND")
                                extraDescLabel:SetFont(self.font .. "BigNoodleTitling.ttf", self.EXTRA_DESCRIPTION_FONT_SIZE, "OUTLINE")
                                extraDescLabel:SetPoint("LEFT", descLabel, "RIGHT", 10, 0)
                                extraDescLabel:SetText(DFRL:TR(data.extraDescription))
                                extraDescLabel:SetTextColor(1, 0.5, 0.5)
                                self.extraDescriptionLabels[elementKey] = extraDescLabel
                            end

                            local typeMeta = data.elementTypeMeta
                            local dropdown = DFRL.tools.CreateDropDown(scrollChild, nil, elementModule, elementName, typeMeta.items)
                            dropdown:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -27, currentY)
                            if dropdown.text then
                                dropdown.text:SetFont(self.font .. "BigNoodleTitling.ttf", self.VALUE_FONT_SIZE, "OUTLINE")
                            end

                            self.dropdowns[elementKey] = dropdown
                            self.descriptionLabels[elementKey] = descLabel
                        end

                        local dropdown = self.dropdowns[elementKey]
                        local descLabel = self.descriptionLabels[elementKey]
                        local extraDescLabel = self.extraDescriptionLabels[elementKey]

                        if not dependencyEnabled then
                            if dropdown and dropdown.Disable then
                                dropdown:Disable()
                            end
                            if dropdown and dropdown.text then
                                dropdown.text:SetTextColor(0.5, 0.5, 0.5)
                            end
                            if descLabel then
                                descLabel:SetTextColor(0.5, 0.5, 0.5)
                            end
                            if extraDescLabel then
                                extraDescLabel:SetTextColor(0.5, 0.5, 0.5)
                            end
                        else
                            if dropdown and dropdown.Enable then
                                dropdown:Enable()
                            end
                            if dropdown and dropdown.text then
                                dropdown.text:SetTextColor(1, 1, 1)
                            end
                            if descLabel then
                                descLabel:SetTextColor(.9, .9, .9)
                            end
                            if extraDescLabel then
                                extraDescLabel:SetTextColor(1, 0.5, 0.5)
                            end
                        end

                    elseif data.elementType == "colour" then
                        local elementKey = elementModule .. "." .. elementName
                        if not self.colours[elementKey] then
                            local descLabel = scrollChild:CreateFontString(nil, "BACKGROUND")
                            descLabel:SetFont(self.font .. "BigNoodleTitling.ttf", self.DESCRIPTION_FONT_SIZE, "OUTLINE")
                            descLabel:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 10, currentY - 6)
                            descLabel:SetText(DFRL:TR(data.description or ""))
                            descLabel:SetTextColor(.9,.9,.9)

                            if data.extraDescription then
                                local extraDescLabel = scrollChild:CreateFontString(nil, "BACKGROUND")
                                extraDescLabel:SetFont(self.font .. "BigNoodleTitling.ttf", self.EXTRA_DESCRIPTION_FONT_SIZE, "OUTLINE")
                                extraDescLabel:SetPoint("LEFT", descLabel, "RIGHT", 10, 0)
                                extraDescLabel:SetText(DFRL:TR(data.extraDescription))
                                extraDescLabel:SetTextColor(1, 0.5, 0.5)
                                self.extraDescriptionLabels[elementKey] = extraDescLabel
                            end

                            local colour = DFRL.tools.CreateColour(scrollChild, nil, elementModule, elementName)
                            colour:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -30, currentY)
                            if colour.label then
                                colour.label:SetFont(self.font .. "BigNoodleTitling.ttf", self.VALUE_FONT_SIZE, "OUTLINE")
                            end

                            self.colours[elementKey] = colour
                            self.descriptionLabels[elementKey] = descLabel
                        end

                        local colour = self.colours[elementKey]
                        local descLabel = self.descriptionLabels[elementKey]
                        local extraDescLabel = self.extraDescriptionLabels[elementKey]

                        if not dependencyEnabled then
                            if colour and colour.Disable then
                                colour:Disable()
                            elseif colour then
                                colour.isDisabled = true
                                colour:EnableMouse(false)
                                colour:SetBackdropColor(0.5, 0.5, 0.5, 1)
                                colour:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
                                local thumbTexture = colour:GetThumbTexture()
                                if thumbTexture then
                                    thumbTexture:SetVertexColor(0.5, 0.5, 0.5)
                                end
                            end
                            if colour and colour.label then
                                colour.label:SetTextColor(0.5, 0.5, 0.5)
                            end
                            if colour and colour.valueText then
                                colour.valueText:SetTextColor(0.5, 0.5, 0.5)
                            end
                            if descLabel then
                                descLabel:SetTextColor(0.5, 0.5, 0.5)
                            end
                            if extraDescLabel then
                                extraDescLabel:SetTextColor(0.5, 0.5, 0.5)
                            end
                        else
                            if colour and colour.Enable then
                                colour:Enable()
                            elseif colour then
                                colour.isDisabled = false
                                colour:EnableMouse(true)
                                colour:SetBackdropColor(1, 1, 1, 1)
                                colour:SetBackdropBorderColor(1, 1, 1, 1)
                                local thumbTexture = colour:GetThumbTexture()
                                if thumbTexture then
                                    thumbTexture:SetVertexColor(1, 1, 1)
                                end
                            end
                            if colour and colour.label then
                                colour.label:SetTextColor(1, 1, 1)
                            end
                            if colour and colour.valueText then
                                colour.valueText:SetTextColor(1, 1, 1)
                            end
                            if descLabel then
                                descLabel:SetTextColor(.9, .9, .9)
                            end
                            if extraDescLabel then
                                extraDescLabel:SetTextColor(1, 0.5, 0.5)
                            end
                        end
                    end
                end
            end

            if moduleInfo ~= sortedModules[table.getn(sortedModules)] then
                self.tabPositions[tabIndex] = self.tabPositions[tabIndex] - self.MODULE_SPACING
            end
        end


    end

    function Setup:DependencyHandler()

        if not self.dependenciesSetup then
            for moduleName, defaults in pairs(DFRL.defaults) do
                if self.moduleMapping[moduleName] then
                    for elementName, valueTable in pairs(defaults) do
                        if elementName ~= "enabled" and table.getn(valueTable) > 1 then
                            local metaKey = moduleName .. "." .. elementName
                            local data = self.metadata[metaKey]

                            if data and data.dependency then

                                local elementKey = moduleName .. "." .. elementName
                                local depKey = moduleName .. "." .. data.dependency
                                local dep = self.checkboxes[elementKey] or self.sliders[elementKey] or self.dropdowns[elementKey] or self.colours[elementKey]
                                local ctrl = self.checkboxes[depKey] or self.sliders[depKey] or self.dropdowns[depKey] or self.colours[depKey]

                                if ctrl and dep then

                                    local click = ctrl:GetScript("OnClick")
                                    local capDep = dep
                                    local capCtrl = ctrl
                                    local capMod = moduleName
                                    local capName = elementName
                                    local capCtrlName = data.dependency
                                    local capDesc = self.descriptionLabels[elementKey]
                                    local capExtraDesc = self.extraDescriptionLabels[elementKey]

                                    capCtrl:SetScript("OnClick", function()

                                if click then
                                    click()
                                end

                                local enabled = capCtrl:GetChecked()

                                if not enabled then
                                    if capDep.SetChecked then
                                        capDep.originalChecked = capDep:GetChecked()
                                        capDep:SetChecked(false)
                                        DFRL:SetTempDB(capMod, capName, false)
                                    elseif capDep.SetValue and not self.colours[capMod .. "." .. capName] then
                                        local def = DFRL.defaults[capMod][capName][1]
                                        capDep:SetValue(def)
                                        DFRL:SetTempDB(capMod, capName, def)
                                    elseif capDep.text then
                                        local def = DFRL.defaults[capMod][capName][1]
                                        capDep.text:SetText(def)
                                        DFRL:SetTempDB(capMod, capName, def)
                                    elseif self.colours[capMod .. "." .. capName] then
                                        local def = DFRL.defaults[capMod][capName][1]
                                        capDep:SetValue(1)
                                        DFRL:SetTempDB(capMod, capName, def)
                                    end
                                    if capDep.Disable then
                                        capDep:Disable()
                                    elseif capDep.SetScript then
                                        capDep.isDisabled = true
                                        capDep:EnableMouse(false)
                                        capDep.originalMouseWheel = capDep:GetScript("OnMouseWheel")
                                        capDep:SetScript("OnMouseWheel", nil)
                                        if capDep.valueText then
                                            capDep.valueText:SetTextColor(0.5, 0.5, 0.5)
                                        end
                                        capDep:SetBackdropColor(0.5, 0.5, 0.5, 1)
                                        capDep:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
                                        local thumb = capDep:GetThumbTexture()
                                        if thumb then
                                            thumb:SetVertexColor(0.5, 0.5, 0.5)
                                        end
                                    end
                                    if capDep.label then
                                        capDep.label:SetTextColor(0.5, 0.5, 0.5)
                                    end
                                    if capDep.text then
                                        capDep.text:SetTextColor(0.5, 0.5, 0.5)
                                    end
                                    if capDesc then
                                        capDesc:SetTextColor(0.5, 0.5, 0.5)
                                    end
                                    if capExtraDesc then
                                        capExtraDesc:SetTextColor(0.5, 0.5, 0.5)
                                    end
                                else
                                    if capDep.Enable then
                                        capDep:Enable()
                                        if capDep.SetChecked and capDep.originalChecked then
                                            capDep:SetChecked(capDep.originalChecked)
                                            DFRL:SetTempDB(capMod, capName, capDep.originalChecked)
                                        end
                                    elseif capDep.SetScript then
                                        capDep.isDisabled = false
                                        capDep:EnableMouse(true)
                                        if capDep.originalMouseWheel then
                                            capDep:SetScript("OnMouseWheel", capDep.originalMouseWheel)
                                        end
                                        if capDep.valueText then
                                            capDep.valueText:SetTextColor(1, 1, 1)
                                        end
                                        capDep:SetBackdropColor(1, 1, 1, 1)
                                        capDep:SetBackdropBorderColor(1, 1, 1, 1)
                                        local thumb = capDep:GetThumbTexture()
                                        if thumb then
                                            thumb:SetVertexColor(1, 1, 1)
                                        end
                                    end
                                    if capDep.label then
                                        capDep.label:SetTextColor(.9,.9,.9)
                                    end
                                    if capDep.text then
                                        capDep.text:SetTextColor(1, 1, 1)
                                    end
                                    if capDesc then
                                        capDesc:SetTextColor(.9,.9,.9)
                                    end
                                    if capExtraDesc then
                                        capExtraDesc:SetTextColor(.9,.9,.9)
                                    end
                                end
                            end)
                                end
                            end
                        end
                    end
                end
            end
            self.dependenciesSetup = true
        end
    end

    function Setup:UpdateHandler()
        self.configCache = {}

        local all = {}
        for name, element in pairs(self.checkboxes) do
            all[name] = {element = element, type = "checkbox"}
        end
        for name, element in pairs(self.sliders) do
            all[name] = {element = element, type = "slider"}
        end
        for name, element in pairs(self.dropdowns) do
            all[name] = {element = element, type = "dropdown"}
        end
        for name, element in pairs(self.colours) do
            all[name] = {element = element, type = "colour"}
        end

        for elementKey, data in pairs(all) do
            local element = data.element

            local module = nil
            local name = nil
            for mod, _ in pairs(self.moduleMapping) do
                local modPrefix = mod .. "."
                if string.sub(elementKey, 1, string.len(modPrefix)) == modPrefix then
                    module = mod
                    name = string.sub(elementKey, string.len(modPrefix) + 1)
                    break
                end
            end

            if module and name then
                local metaKey = module .. "." .. name
                local meta = self.metadata[metaKey]
                local value = self:GetCache(module, name)

                if data.type == "checkbox" then
                    element:SetChecked(value)
                elseif data.type == "slider" then
                    element:SetValue(value)
                elseif data.type == "dropdown" then
                    element.text:SetText(value)
                elseif data.type == "colour" then
                    if type(value) == "table" and table.getn(value) >= 3 then
                        for i = 1, 30 do
                            local color = element.BASIC_COLORS and element.BASIC_COLORS[i]
                            if color and color[1] == value[1] and color[2] == value[2] and color[3] == value[3] then
                                element:SetValue(i)
                                break
                            end
                        end
                    end
                end

                local enabled = true
                if meta and meta.dependency then
                    enabled = self:GetCache(module, meta.dependency) == true
                end

                local r, g, b = enabled and .9 or 0.5, enabled and .9 or 0.5, enabled and .9 or 0.5

                if element.label then
                    element.label:SetTextColor(r, g, b)
                end
                if element.valueText then
                    element.valueText:SetTextColor(enabled and 1 or 0.5, enabled and 1 or 0.5, enabled and 1 or 0.5)
                end
                if element.text then
                    element.text:SetTextColor(enabled and 1 or 0.5, enabled and 1 or 0.5, enabled and 1 or 0.5)
                end
                if self.descriptionLabels[elementKey] then
                    self.descriptionLabels[elementKey]:SetTextColor(r, g, b)
                end

                if enabled then
                    if element.Enable then
                        element:Enable()
                    else
                        element.isDisabled = false
                        element:EnableMouse(true)
                        element:SetBackdropColor(1, 1, 1, 1)
                        element:SetBackdropBorderColor(1, 1, 1, 1)
                        element:GetThumbTexture():SetVertexColor(1, 1, 1)
                    end
                else
                    if element.Disable then
                        element:Disable()
                    else
                        element.isDisabled = true
                        element:EnableMouse(false)
                        element:SetBackdropColor(0.5, 0.5, 0.5, 1)
                        element:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
                        element:GetThumbTexture():SetVertexColor(0.5, 0.5, 0.5)
                    end
                end

            end
        end

        DFRL:TriggerAllCallbacks()
    end

    function Setup:GetCache(moduleName, key)
        local cacheKey = moduleName .. "." .. key
        if not self.configCache[cacheKey] then
            if DFRL.tempDB[moduleName] and DFRL.tempDB[moduleName][key] ~= nil then
                self.configCache[cacheKey] = DFRL:GetTempDB(moduleName, key)
            else
                return nil
            end
        end
        return self.configCache[cacheKey]
    end

    Base.UpdateHandler = function()
        Setup:UpdateHandler()
    end

    --=================
    -- INIT THE BEAST
    --=================
    function Setup:Run()
        Setup:MetaData()
        Setup:Elements()
        Setup:DependencyHandler()
    end

    Setup:Run()

    --=================
    -- CALLBACKS
    --=================
end)
