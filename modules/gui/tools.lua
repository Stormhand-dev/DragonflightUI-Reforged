setfenv(1, DFRL:GetEnv())

function DFRL.tools.GradientLine(frame, anchor, yOffset, height, width)
    width = width or frame:GetWidth() - 10

    local left = frame:CreateTexture(nil, "OVERLAY")
    left:SetTexture("Interface\\Buttons\\WHITE8x8")
    if anchor == "TOP" then
        left:SetPoint("TOP", frame, "TOP", 0, yOffset -1)
        left:SetPoint("RIGHT", frame, "TOP", 0, yOffset -1)
    else
        left:SetPoint("BOTTOM", frame, "BOTTOM", 0, yOffset + 1)
        left:SetPoint("RIGHT", frame, "BOTTOM", 0, yOffset + 1)
    end
    left:SetWidth(width / 2)
    left:SetHeight(height or 2)
    left:SetGradientAlpha("HORIZONTAL", 1, 0.82, 0, 0, 1, 0.82, 0, 1)

    local right = frame:CreateTexture(nil, "OVERLAY")
    right:SetTexture("Interface\\Buttons\\WHITE8x8")
    if anchor == "TOP" then
        right:SetPoint("TOP", frame, "TOP", 0, yOffset - 1)
        right:SetPoint("LEFT", frame, "TOP", 0, yOffset - 1)
    else
        right:SetPoint("BOTTOM", frame, "BOTTOM", 0, yOffset +1)
        right:SetPoint("LEFT", frame, "BOTTOM", 0, yOffset +1)
    end
    right:SetWidth(width / 2)
    right:SetHeight(height or 2)
    right:SetGradientAlpha("HORIZONTAL", 1, 0.82, 0, 1, 1, 0.82, 0, 0)
end

function DFRL.tools.MoveFrame(f, dirX, dirY, time, dist)
    f.elapsed = 0
    f.totalMoveX = 0
    f.totalMoveY = 0
    f.targetMoveX = dist * dirX
    f.targetMoveY = dist * dirY

    f:SetScript("OnUpdate", function()
        this.elapsed = this.elapsed + arg1

        if this.elapsed >= time then
            local remainingX = this.targetMoveX - this.totalMoveX
            local remainingY = this.targetMoveY - this.totalMoveY

            if math.abs(remainingX) > 0.1 or math.abs(remainingY) > 0.1 then
                local currentX, currentY = this:GetCenter()
                this:ClearAllPoints()
                this:SetPoint("CENTER", UIParent, "BOTTOMLEFT", currentX + remainingX, currentY + remainingY)
            end

            this:SetScript("OnUpdate", nil)
        else
            local progress = this.elapsed / time
            local targetX = this.targetMoveX * progress
            local targetY = this.targetMoveY * progress

            local moveX = targetX - this.totalMoveX
            local moveY = targetY - this.totalMoveY

            this.totalMoveX = this.totalMoveX + moveX
            this.totalMoveY = this.totalMoveY + moveY

            local currentX, currentY = this:GetCenter()
            this:ClearAllPoints()
            this:SetPoint("CENTER", UIParent, "BOTTOMLEFT", currentX + moveX, currentY + moveY)
        end
    end)
end

function DFRL.tools.CreateDFRLFrame(parent, w, h, gradPos, alpha, mouse)
    parent = parent or UIParent
    local f = CreateFrame("Frame", nil, parent)
    f:SetWidth(w or 100)
    f:SetHeight(h or 100)
    f:EnableMouse(mouse or false)
    f:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8"})
    f:SetBackdropColor(0, 0, 0, alpha or 0.5)
    DFRL.tools.GradientLine(f, gradPos or "TOP", -1, 3)
    return f
end

function DFRL.tools.CreateDFRLFrameName(parent, w, h, gradPos, alpha, mouse, name)
    parent = parent or UIParent
    local f = CreateFrame("Frame", name, parent)
    f:SetWidth(w or 100)
    f:SetHeight(h or 100)
    f:EnableMouse(mouse or false)
    f:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8"})
    f:SetBackdropColor(0, 0, 0, alpha or 0.5)
    DFRL.tools.GradientLine(f, gradPos or "TOP", -1, 3)
    return f
end

function DFRL.tools.CreateFont(parent, size, text, colour, align)
    local font = parent:CreateFontString(nil, "OVERLAY")
    font:SetFont(DFRL:GetInfoOrCons("font") .. "BigNoodleTitling.ttf", size or 14, "OUTLINE")
    colour = colour or {1, 1, 1}
    font:SetTextColor(colour[1], colour[2], colour[3])
    font.rawText = text
    font:SetText(DFRL:TR(text or ""))
    font.align = align or "CENTER"

    function font:SetLocalizedText(newText)
        self.rawText = newText
        self:SetText(DFRL:TR(newText or ""))
    end

    return font
end

function DFRL.tools.CreateButton(parent, text, width, height, noBackdrop, textColor)
    local btn = CreateFrame("Button", nil, parent or UIParent)
    btn:SetWidth(width or 140)
    btn:SetHeight(height or 30)

    if not noBackdrop then
        btn:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 14,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        btn:SetBackdropColor(0.04, 0.04, 0.04, .88)
        btn:SetBackdropBorderColor(1, 0.82, 0, 0.35)
    else
        local bg = btn:CreateTexture(nil, "BACKGROUND")
        bg:SetTexture("Interface\\Buttons\\WHITE8X8")
        bg:SetPoint("TOPLEFT", btn, "TOPLEFT", 1, -1)
        bg:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -1, 1)
        bg:SetVertexColor(0.08, 0.08, 0.08, 0.28)
        btn._bg = bg

        local border = btn:CreateTexture(nil, "BORDER")
        border:SetTexture("Interface\\Buttons\\WHITE8X8")
        border:SetPoint("TOPLEFT", btn, "TOPLEFT", 0, 0)
        border:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 0, 0)
        border:SetVertexColor(1, 0.82, 0, 0.16)
        btn._border = border
    end

    local btnTxt = btn:CreateFontString(nil, "OVERLAY")
    btnTxt:SetFont(DFRL:GetInfoOrCons("font") .. "BigNoodleTitling.ttf", 12, "OUTLINE")
    btnTxt:SetPoint("CENTER", btn, "CENTER", 0, 0)
    btn.rawText = text
    btnTxt:SetText(DFRL:TR(text or ""))

    if textColor then
        btnTxt:SetTextColor(textColor[1], textColor[2], textColor[3])
    else
        btnTxt:SetTextColor(1, 1, 1)
    end

    btn.text = btnTxt

    function btn:SetLocalizedText(newText)
        self.rawText = newText
        self.text:SetText(DFRL:TR(newText or ""))
    end

    local origEnable = btn.Enable
    local origDisable = btn.Disable

    btn.Enable = function(self)
        origEnable(self)
        if textColor then
            btnTxt:SetTextColor(textColor[1], textColor[2], textColor[3])
        else
            btnTxt:SetTextColor(1, 1, 1)
        end
        if self.SetBackdropBorderColor and not noBackdrop then
            self:SetBackdropBorderColor(1, 0.82, 0, 0.35)
        end
    end

    btn.Disable = function(self)
        origDisable(self)
        btnTxt:SetTextColor(0.5, 0.5, 0.5)
        if self.SetBackdropBorderColor and not noBackdrop then
            self:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.2)
        end
    end

    local highlight = btn:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    highlight:SetPoint("TOPLEFT", btn, "TOPLEFT", 2, -4)
    highlight:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -2, 4)
    highlight:SetBlendMode("ADD")

    btn:SetScript("OnEnter", function()
        if noBackdrop then
            if this._bg then this._bg:SetVertexColor(0.12, 0.12, 0.12, 0.45) end
            if this._border then this._border:SetVertexColor(1, 0.82, 0, 0.45) end
        else
            this:SetBackdropBorderColor(1, 0.82, 0, 0.65)
        end
    end)

    btn:SetScript("OnLeave", function()
        if noBackdrop then
            if this._bg then this._bg:SetVertexColor(0.08, 0.08, 0.08, 0.28) end
            if this._border then this._border:SetVertexColor(1, 0.82, 0, 0.16) end
        else
            this:SetBackdropBorderColor(1, 0.82, 0, 0.35)
        end
    end)

    return btn
end

function DFRL.tools.CreateIndiCheckbox(parent, name, text)
    local checkbox = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
    checkbox:SetWidth(20)
    checkbox:SetHeight(20)

    local label = checkbox:CreateFontString(nil, "BACKGROUND")
    label:SetFont(DFRL:GetInfoOrCons("font") .. "BigNoodleTitling.ttf", 12, "OUTLINE")
    label:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
    label:SetText(DFRL:TR(text or "Checkbox"))
    label:SetTextColor(.9,.9,.9)
    checkbox.label = label

    checkbox:SetChecked(false)

    local origEnable = checkbox.Enable
    local origDisable = checkbox.Disable

    checkbox.Enable = function(self)
        origEnable(self)
        self.label:SetTextColor(.9,.9,.9)
    end

    checkbox.Disable = function(self)
        origDisable(self)
        self.label:SetTextColor(0.5, 0.5, 0.5)
    end

    return checkbox
end

function DFRL.tools.CreateIndiSlider(parent, name, text, minVal, maxVal, step)
    local slider = CreateFrame("Slider", name, parent)
    slider:SetWidth(136)
    slider:SetHeight(24)
    slider:SetOrientation("HORIZONTAL")
    slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    slider:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 8, edgeSize = 10,
        insets = { left = 3, right = 3, top = 6, bottom = 6 }
    })
    slider:SetBackdropColor(0.03, 0.03, 0.03, 0.85)
    slider:SetBackdropBorderColor(1, 0.82, 0, 0.18)

    slider:SetMinMaxValues(minVal or 0, maxVal or 5)
    slider:SetValueStep(step or 0.1)

    local label = slider:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("BOTTOMLEFT", slider, "TOPLEFT", 0, -0)
    label:SetText(DFRL:TR(text or "Slider"))
    label:SetFont(DFRL:GetInfoOrCons("font") .. "BigNoodleTitling.ttf", 12, "OUTLINE")
    label:SetTextColor(.9,.9,.9)
    slider.label = label

    local valueText = slider:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    valueText:SetPoint("LEFT", slider, "RIGHT", 1, -0)
    valueText:SetTextColor(1, 1, 1)
    valueText:SetFont(DFRL:GetInfoOrCons("font") .. "BigNoodleTitling.ttf", 12, "OUTLINE")
    slider.valueText = valueText

    slider:SetValue(minVal or 0)
    valueText:SetText(string.format("%.1f", minVal or 0))

    local function updateValueText()
        local newValue = slider:GetValue()
        local roundedValue = math.floor(newValue * 10 + 0.5) / 10
        valueText:SetText(string.format("%.1f", roundedValue))
    end

    slider.updateValueText = updateValueText
    slider:SetScript("OnValueChanged", updateValueText)

    slider:EnableMouseWheel(true)
    slider:SetScript("OnMouseWheel", function()
        local wheelStep = step or 0.1
        local value = this:GetValue()
        local minValue, maxValue = this:GetMinMaxValues()

        if arg1 > 0 then
            value = math.min(value + wheelStep, maxValue)
        else
            value = math.max(value - wheelStep, minValue)
        end
        this:SetValue(value)
    end)

    local origEnable = slider.Enable
    local origDisable = slider.Disable

    slider.Enable = function(self)
        origEnable(self)
        self.label:SetTextColor(.9,.9,.9)
        self.valueText:SetTextColor(1, 1, 1)
    end

    slider.Disable = function(self)
        origDisable(self)
        self.label:SetTextColor(0.5, 0.5, 0.5)
        self.valueText:SetTextColor(0.5, 0.5, 0.5)
    end

    return slider
end

function DFRL.tools.CreateIndiDropDown(parent, text, items, width, height)
    local btn = DFRL.tools.CreateButton(parent, text or "Dropdown", width or 120, height or 25)

    local popup = CreateFrame("Frame", nil, UIParent)
    popup:SetWidth(btn:GetWidth())
    popup:SetHeight(table.getn(items) * 22 + 10)
    popup:SetPoint("TOP", btn, "BOTTOM", 0, -2)
    popup:SetFrameLevel(btn:GetFrameLevel() + 1)
    popup:SetFrameStrata("DIALOG")
    popup:EnableMouse(true)
    popup:Hide()

    local bg = popup:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\Buttons\\WHITE8X8")
    bg:SetAllPoints(popup)
    bg:SetVertexColor(0, 0, 0, 0.8)

    btn.popup = popup
    btn.selectedValue = items[1]
    btn.text:SetText(DFRL:TR(btn.selectedValue))

    for i = 1, table.getn(items) do
        local itemBtn = DFRL.tools.CreateButton(popup, items[i], popup:GetWidth() - 4, 20, true)
        itemBtn.itemValue = items[i]
        itemBtn:SetPoint("TOP", popup, "TOP", 0, -(i - 1) * 22 - 5)
        itemBtn:SetScript("OnClick", function()
            btn.text:SetText(DFRL:TR(this.itemValue))
            btn.selectedValue = this.itemValue
            popup:Hide()
        end)
    end

    btn:SetScript("OnClick", function()
        if popup:IsVisible() then
            popup:Hide()
        else
            popup:Show()
        end
    end)

    local origEnable = btn.Enable
    local origDisable = btn.Disable

    btn.Enable = function(self)
        origEnable(self)
        self.text:SetTextColor(1, 1, 1)
    end

    btn.Disable = function(self)
        origDisable(self)
        self.text:SetTextColor(0.5, 0.5, 0.5)
    end

    return btn
end

function DFRL.tools.CreateEditBox(parent, width, height, letters, numbers, max)
    local box = CreateFrame("EditBox", nil, parent or UIParent)
    box:SetWidth(width or 100)
    box:SetHeight(height or 20)
    box:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 8, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    box:SetBackdropColor(0.02, 0.02, 0.02, 0.9)
    box:SetBackdropBorderColor(1, 0.82, 0, 0.25)
    box:SetFont(DFRL:GetInfoOrCons("font") .. "BigNoodleTitling.ttf", 14, "OUTLINE")
    box:SetTextColor(1, 1, 1)
    box:SetTextInsets(5, 5, 5, 5)
    box:SetAutoFocus(false)
    box:SetMaxLetters(max or 33)

    box.clickCatcher = CreateFrame("Frame", nil, UIParent)
    box.clickCatcher:SetFrameStrata("TOOLTIP")
    box.clickCatcher:SetAllPoints(UIParent)
    box.clickCatcher:EnableMouse(true)
    box.clickCatcher:Hide()

    box.clickCatcher:SetScript("OnMouseDown", function()
        box:SetText("")
        box:ClearFocus()
        box:Hide()
        this:Hide()
    end)

    box:SetScript("OnEditFocusGained", function()
        box.clickCatcher:Show()
    end)

    box:SetScript("OnEditFocusLost", function()
        box.clickCatcher:Hide()
    end)

    box:SetScript("OnEscapePressed", function()
        this:SetText("")
        this:ClearFocus()
        this:Hide()
    end)

    box:SetScript("OnEnterPressed", function()
        this:ClearFocus()
    end)

    if letters then
        box:SetScript("OnChar", function()
            if not string.find(arg1, "[a-zA-Z]") then
                this:SetText(string.gsub(this:GetText(), "[^a-zA-Z]", ""))
            end
        end)
    elseif numbers then
        box:SetScript("OnChar", function()
            if not string.find(arg1, "[0-9]") then
                this:SetText(string.gsub(this:GetText(), "[^0-9]", ""))
            end
        end)
    end

    return box
end

function DFRL.tools.CreateCategoryHeader(parent, categoryName, noBG, width, height, txtSize)
    local categoryBg = CreateFrame("Frame", nil, parent)
    categoryBg:SetWidth(width or 180)
    categoryBg:SetHeight(height or 25)

    if not noBG then
        categoryBg:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        categoryBg:SetBackdropColor(0.05, 0.05, 0.05, 0.78)
        categoryBg:SetBackdropBorderColor(1, 0.82, 0, 0.22)
    end

    local categoryTitle = categoryBg:CreateFontString(nil, "OVERLAY")
    categoryTitle:SetFont(DFRL:GetInfoOrCons("font") .. "BigNoodleTitling.ttf", txtSize or 14, "OUTLINE")
    categoryTitle:SetPoint("CENTER", categoryBg, "CENTER", 0, 1)
    categoryBg.title = categoryTitle
    categoryBg.rawCategoryName = categoryName

    function categoryBg:RefreshText()
        local localizedName = DFRL:TR(self.rawCategoryName or "")
        if DFRL:IsFrench() then
            self.title:SetText(localizedName)
        else
            local words = string.gfind(localizedName, "%S+")
            local capitalizedWords = {}
            for word in words do
                table.insert(capitalizedWords, string.upper(string.sub(word, 1, 1)) .. string.sub(word, 2))
            end
            self.title:SetText(table.concat(capitalizedWords, " "))
        end
    end

    categoryBg:RefreshText()
    categoryTitle:SetTextColor(1, 0.82, 0)

    return categoryBg
end

function DFRL.tools.CreateCheckbox(parent, name, moduleName, key, noCall)
    local checkbox = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
    checkbox:SetWidth(20)
    checkbox:SetHeight(20)

    local label = checkbox:CreateFontString(nil, "BACKGROUND")
    label:SetFont(DFRL:GetInfoOrCons("font") .. "BigNoodleTitling.ttf", 12, "OUTLINE")
    label:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
    local displayTxt = DFRL:GetOptionLabel(moduleName, key)
    label:SetText(displayTxt)
    label:SetTextColor(.9,.9,.9)
    checkbox.label = label

    local currentValue = DFRL:GetTempDB(moduleName, key)
    checkbox:SetChecked(currentValue)

    checkbox:SetScript("OnClick", function()
        local isChecked = this:GetChecked()
        if noCall then
            DFRL:SetTempDBNoCallback(moduleName, key, isChecked == 1)
        else
            DFRL:SetTempDB(moduleName, key, isChecked == 1)
        end
    end)

    return checkbox
end

function DFRL.tools.CreateShaguCheckbox(parent, name, key)
    local checkbox = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
    checkbox:SetWidth(20)
    checkbox:SetHeight(20)

    local label = checkbox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetFont(DFRL:GetInfoOrCons("font") .. "BigNoodleTitling.ttf", 14, "OUTLINE")
    label:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
    label:SetText(DFRL:TR(key))
    label:SetTextColor(.9,.9,.9)
    checkbox.label = label

    local initial = (ShaguTweaks_config and ShaguTweaks_config[key] == 1)
    checkbox:SetChecked(initial)

    checkbox:SetScript("OnClick", function()
        local checked = checkbox:GetChecked() and true or false

        if checked then
            ShaguTweaks_config[key] = 1
            local mod = ShaguTweaks.mods[key]
            if mod and mod.enable then
                mod:enable()
            end
        else
            ShaguTweaks_config[key] = 0
            local mod = ShaguTweaks.mods[key]
            if mod and mod.disable then
                mod:disable()
            end
        end
    end)

    return checkbox
end

function DFRL.tools.CreateSlider(parent, name, moduleName, key, minVal, maxVal, step, noCall)
    local slider = CreateFrame("Slider", name, parent)
    slider:SetWidth(136)
    slider:SetHeight(24)
    slider:SetOrientation("HORIZONTAL")
    slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    slider:SetBackdrop({
        bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
        edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
        tile = true, tileSize = 8, edgeSize = 8,
        insets = { left = 3, right = 3, top = 6, bottom = 6 }
    })

    slider:SetMinMaxValues(minVal or 0, maxVal or 5)

    local label = slider:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("BOTTOMLEFT", slider, "TOPLEFT", 0, -0)
    local displayTxt = DFRL:GetOptionLabel(moduleName, key)
    label:SetText(displayTxt)
    label:SetFont(DFRL:GetInfoOrCons("font") .. "BigNoodleTitling.ttf", 12, "OUTLINE")
    label:SetTextColor(.9,.9,.9)
    slider.label = label

    local valueText = slider:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    valueText:SetPoint("LEFT", slider, "RIGHT", 1, -0)
    valueText:SetTextColor(1, 1, 1)
    valueText:SetFont(DFRL:GetInfoOrCons("font") .. "BigNoodleTitling.ttf", 12, "OUTLINE")
    slider.valueText = valueText

    slider.moduleName = moduleName
    slider.configKey = key

    local currentValue = DFRL:GetTempDB(moduleName, key)
    slider:SetValue(currentValue)
    valueText:SetText(string.format("%.1f", currentValue))

    slider:SetScript("OnValueChanged", function()
        local newValue = this:GetValue()
        local roundedValue = math.floor(newValue * 10 + 0.5) / 10
        this.valueText:SetText(string.format("%.1f", roundedValue))
        if noCall then
            DFRL:SetTempDBNoCallback(this.moduleName, this.configKey, roundedValue)
        else
            DFRL:SetTempDB(this.moduleName, this.configKey, roundedValue)
        end
    end)

    slider:EnableMouseWheel(true)
    slider:SetScript("OnMouseWheel", function()
        local wheelStep = step or 0.1
        local value = this:GetValue()
        local minValue, maxValue = this:GetMinMaxValues()

        if arg1 > 0 then
            value = math.min(value + wheelStep, maxValue)
        else
            value = math.max(value - wheelStep, minValue)
        end
        this:SetValue(value)
    end)

    return slider
end

function DFRL.tools.CreateColour(parent, name, moduleName, key)

    local BASIC_COLORS = {
        -- red variants
        {1.0, 0.0, 0.0},      -- red
        {1.0, 0.6, 0.6},      -- light red
        {0.8, 0.0, 0.2},      -- exotic red
        -- white variants
        {1.0, 1.0, 1.0},      -- white
        {0.9, 0.9, 0.9},      -- light white (gray)
        {1.0, 0.95, 0.9},     -- exotic white (ivory)
        -- blue variants
        {0.0, 0.0, 1.0},      -- blue
        {0.6, 0.6, 1.0},      -- light blue
        {0.0, 0.2, 0.8},      -- exotic blue (deep)
        -- yellow variants
        {1.0, 1.0, 0.0},      -- yellow
        {1.0, 1.0, 0.6},      -- light yellow
        {0.8, 0.8, 0.0},      -- exotic yellow (mustard)
        -- magenta variants
        {1.0, 0.0, 1.0},      -- magenta
        {1.0, 0.6, 1.0},      -- light magenta
        {0.7, 0.0, 0.7},      -- exotic magenta (deep pink)
        -- cyan variants
        {0.0, 1.0, 1.0},      -- cyan
        {0.6, 1.0, 1.0},      -- light cyan
        {0.0, 0.7, 0.7},      -- exotic cyan (teal)
        -- orange variants
        {1.0, 0.5, 0.0},      -- orange
        {1.0, 0.75, 0.4},     -- light orange
        {0.8, 0.3, 0.0},      -- exotic orange (burnt)
        -- purple variants
        {0.5, 0.0, 1.0},      -- purple
        {0.8, 0.6, 1.0},      -- light purple
        {0.4, 0.0, 0.6},      -- exotic purple (violet)
        -- teal variants
        {0.0, 0.5, 0.5},      -- teal
        {0.4, 0.8, 0.8},      -- light teal
        {0.0, 0.4, 0.6},      -- exotic teal (deep sea)
        -- gold variants
        {1.0, 0.82, 0.0},     -- gold
        {1.0, 0.9, 0.5},      -- light gold
        {0.8, 0.65, 0.0},     -- exotic gold (bronze)
    }

    local COLOR_COUNT = 30

    local slider = CreateFrame("Slider", name, parent)
    slider:SetWidth(136)
    slider:SetHeight(24)
    slider:SetOrientation("HORIZONTAL")
    slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    slider:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 8, edgeSize = 10,
        insets = { left = 3, right = 3, top = 6, bottom = 6 }
    })
    slider:SetBackdropColor(0.03, 0.03, 0.03, 0.85)
    slider:SetBackdropBorderColor(1, 0.82, 0, 0.18)

    slider:SetMinMaxValues(1, COLOR_COUNT)
    slider:SetValueStep(1)

    local label = slider:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("BOTTOMLEFT", slider, "TOPLEFT", 0, -0)
    local displayText = DFRL:GetOptionLabel(moduleName, key)
    label:SetText(displayText)
    label:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
    label:SetTextColor(.9,.9,.9)
    slider.label = label

    local valueText = slider:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    valueText:SetPoint("LEFT", slider, "RIGHT", 1, -0)
    valueText:SetTextColor(1, 1, 1)
    valueText:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    slider.valueText = valueText

    slider.moduleName = moduleName
    slider.configKey = key

    local colorSwatch = parent:CreateTexture(nil, "ARTWORK")
    colorSwatch:SetWidth(20)
    colorSwatch:SetHeight(20)
    colorSwatch:SetPoint("LEFT", valueText, "RIGHT", 5, 0)
    colorSwatch:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")

    local currentValue = DFRL:GetTempDB(moduleName, key)
    local initialIndex = 1

    if type(currentValue) == "table" and table.getn(currentValue) >= 3 then
        local r, g, b = currentValue[1], currentValue[2], currentValue[3]

        colorSwatch:SetVertexColor(r, g, b)

        for i=1, COLOR_COUNT do
            if BASIC_COLORS[i][1] == r and BASIC_COLORS[i][2] == g and BASIC_COLORS[i][3] == b then
                initialIndex = i
                break
            end
        end
    else
        colorSwatch:SetVertexColor(BASIC_COLORS[1][1], BASIC_COLORS[1][2], BASIC_COLORS[1][3])
    end

    slider:SetValue(initialIndex)
    valueText:SetText(initialIndex)

    slider:SetScript("OnValueChanged", function()
        local newValue = this:GetValue()
        local index = math.floor(newValue + 0.5)
        if index < 1 then index = 1 end
        if index > COLOR_COUNT then index = COLOR_COUNT end

        valueText:SetText(index)
        colorSwatch:SetVertexColor(BASIC_COLORS[index][1], BASIC_COLORS[index][2], BASIC_COLORS[index][3])
        DFRL:SetTempDB(moduleName, key, BASIC_COLORS[index])
    end)

    slider:EnableMouseWheel(true)
    slider:SetScript("OnMouseWheel", function()
        local step = 1
        local value = this:GetValue()
        local minValue, maxValue = this:GetMinMaxValues()

        if arg1 > 0 then
            value = math.min(value + step, maxValue)
        else
            value = math.max(value - step, minValue)
        end
        this:SetValue(value)
    end)
    return slider
end

function DFRL.tools.CreateDropDown(parent, name, moduleName, key, items, noCall, h, w)
    local BUTTON_HEIGHT = 20
    local Y_SPACING = 25

    local btn = DFRL.tools.CreateButton(parent, nil, w, h)
    local btnTxt = btn:CreateFontString(nil, "OVERLAY")
    btnTxt:SetFont(DFRL:GetInfoOrCons("font") .. "BigNoodleTitling.ttf", 12, "OUTLINE")
    btnTxt:SetPoint("CENTER", btn, "CENTER", 0, 0)
    local displayTxt = DFRL:GetOptionLabel(moduleName, key)
    btnTxt:SetText(displayTxt)
    btnTxt:SetTextColor(1, 1, 1)
    btn.text = btnTxt

    if name then
        local label = DFRL.tools.CreateFont(parent, 12, name)
        label:SetPoint("RIGHT", btn, "LEFT", -5, 0)
    end

    local currentValue = DFRL:GetTempDB(moduleName, key)
    if currentValue then
        btnTxt:SetText(DFRL:TR(currentValue))
    end

    if not btn.popup then
        local popup = CreateFrame("Frame", nil, UIParent)
        popup:SetWidth(btn:GetWidth() - 1)
        popup:SetHeight((table.getn(items) - 1) * Y_SPACING + BUTTON_HEIGHT + 10)
        popup:SetPoint("TOP", btn, "BOTTOM", 0, 3)
        popup:SetFrameLevel(btn:GetFrameLevel() + 1)
        popup:SetFrameStrata("DIALOG")
        popup:SetToplevel(true)
        popup:EnableMouse(true)
        popup:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 8, edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        popup:SetBackdropColor(0.02, 0.02, 0.02, 0.95)
        popup:SetBackdropBorderColor(1, 0.82, 0, 0.25)
        DFRL.tools.GradientLine(popup, "TOP", 2)

        local bg = popup:CreateTexture(nil, "BACKGROUND")
        bg:SetTexture("Interface\\Buttons\\WHITE8X8")
        bg:SetAllPoints(popup)
        bg:SetVertexColor(0.02, 0.02, 0.02, .92)

        popup:Hide()
        btn.popup = popup
        popup.isHovered = false

        if items then
            for i = 1, table.getn(items) do
                local itemBtn = DFRL.tools.CreateButton(popup, items[i], popup:GetWidth() - 5, BUTTON_HEIGHT, true)
                itemBtn:SetFrameLevel(popup:GetFrameLevel() + 1)
                itemBtn:SetPoint("TOP", popup, "TOP", 0, -(i - 1) * Y_SPACING - 5)
                itemBtn.itemText = items[i]

                itemBtn:SetScript("OnClick", function()
                    btn.text:SetText(DFRL:TR(this.itemText))
                    if noCall then
                        DFRL:SetTempDBNoCallback(moduleName, key, this.itemText)
                    else
                        DFRL:SetTempDB(moduleName, key, this.itemText)
                    end
                    popup:Hide()
                end)
                itemBtn:SetScript("OnEnter", function()
                    popup.isHovered = true
                end)
                itemBtn:SetScript("OnLeave", function()
                    popup.isHovered = false
                end)
            end
        end

        popup:SetScript("OnEnter", function()
            popup.isHovered = true
        end)
    end

    btn:SetScript("OnClick", function()
        if btn.popup:IsVisible() then
            btn.popup:Hide()
        else
            btn.popup:Show()
        end
    end)

    btn:SetScript("OnEnter", function()
        btn.popup.isHovered = true
    end)

    btn:SetScript("OnLeave", function()
        btn.popup.isHovered = false
    end)

    btn.popup:SetScript("OnLeave", function()
        btn.popup.isHovered = false
        local f = CreateFrame("Frame")
        f.elapsed = 0
        f:SetScript("OnUpdate", function()
            this.elapsed = this.elapsed + arg1
            if this.elapsed > 0.1 then
                if not btn.popup.isHovered then
                    btn.popup:Hide()
                end
                this:SetScript("OnUpdate", nil)
            end
        end)
    end)

    return btn
end

function DFRL.tools.CreateGrid(parent, rowSpacing, lineSpacing)
    local grid = {
        gridRows = {},
        yOffsets = {},
        ROW_SPACING = rowSpacing or 33,
        LINE_SPACING = lineSpacing or 20,
    }

    function grid:Init()
        local columnWidth = (parent:GetWidth() - 5*self.ROW_SPACING) / 6
        for i = 1, 6 do
            local frame = CreateFrame("Frame", nil, parent)
            local xPos = (i-1) * (columnWidth + self.ROW_SPACING)
            frame:SetPoint("TOPLEFT", parent, "TOPLEFT", xPos, 0)
            frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", xPos + columnWidth - parent:GetWidth(), 0)
            self.gridRows[i] = frame
            self.yOffsets[i] = -10
        end
    end

    function grid:AddElement(row, line, element)
        if line then
            element:SetParent(self.gridRows[row])
            local yPos = -10 - (line - 1) * self.LINE_SPACING
            if element.align == "LEFT" then
                element:SetPoint("TOPLEFT", self.gridRows[row], "TOPLEFT", 0, yPos)
            elseif element.align == "RIGHT" then
                element:SetPoint("TOPRIGHT", self.gridRows[row], "TOPRIGHT", 0, yPos)
            else
                element:SetPoint("TOP", self.gridRows[row], "TOP", 0, yPos)
            end
        else
            element:SetParent(self.gridRows[row])
            if element.align == "LEFT" then
                element:SetPoint("TOPLEFT", self.gridRows[row], "TOPLEFT", 0, self.yOffsets[row])
            elseif element.align == "RIGHT" then
                element:SetPoint("TOPRIGHT", self.gridRows[row], "TOPRIGHT", 0, self.yOffsets[row])
            else
                element:SetPoint("TOP", self.gridRows[row], "TOP", 0, self.yOffsets[row])
            end
            self.yOffsets[row] = self.yOffsets[row] - 30
        end
    end

    function grid:AddSpace(row, pixels)
        self.yOffsets[row] = self.yOffsets[row] - pixels
    end

    return grid
end

function DFRL.tools.CreateFontWarner(parent, size, text, colour, pulse, time)
    local fontString = parent:CreateFontString(nil, "OVERLAY")
    fontString:SetFont(DFRL:GetInfoOrCons("font") .. "BigNoodleTitling.ttf", size or 14, "OUTLINE")

    if colour then
        fontString:SetTextColor(colour[1], colour[2], colour[3])
    else
        fontString:SetTextColor(1, 1, 1)
    end

    fontString.rawText = text
    fontString:SetText(DFRL:TR(text or ""))

    function fontString:SetLocalizedText(newText)
        self.rawText = newText
        self:SetText(DFRL:TR(newText or ""))
    end

    if pulse or time then
        local frame = CreateFrame("Frame")
        frame.elapsed = 0
        frame.totalTime = time or 0
        frame.direction = -1
        frame.alpha = 1

        frame:SetScript("OnUpdate", function()
            if not fontString:IsVisible() then
                this:SetScript("OnUpdate", nil)
                DFRL.activeScripts["GUI WarnerPulse"] = false
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

            fontString:SetAlpha(this.alpha)

            if this.totalTime > 0 and this.elapsed >= this.totalTime then
                fontString:Hide()
                this:SetScript("OnUpdate", nil)
                DFRL.activeScripts["GUI WarnerPulse"] = false
            end
        end)
        DFRL.activeScripts["GUI WarnerPulse"] = true
    end

    return fontString
end

DFRL.activeScripts["GUI WarnerPulse"] = false
