DFRL:NewDefaults("Mini", {
    enabled = {true},
    miniDarkMode = {0, "slider", {0, 1}, nil, "Appearance", 1, "Adjust dark mode intensity", nil, nil},
    miniColor = {{1, 1, 1}, "colour", nil, nil, "Appearance", 2, "Change mini color", nil, nil},
    petFrameScale = {1, "slider", {0.7, 1.3}, nil, "Appearance", 3, "Adjust pet frame size", nil, nil},
    totFrameScale = {1, "slider", {0.7, 1.3}, nil, "Appearance", 4, "Adjust target of target frame size", nil, nil},
    partyFrameScale = {1, "slider", {0.7, 1.3}, nil, "Appearance", 5, "Adjust party frame size", nil, nil},
    miniTextShow = {true, "checkbox", nil, nil, "Text", 6, "Show pet/target of target/party health and mana text", nil, nil},
    frameFont = {"FRIZQT__.TTF", "dropdown", {
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
    }, nil, "Text", 7, "Change the font used for all smaller frames", nil, nil},
    noPetPercent = {true, "checkbox", nil, "miniTextShow", "Pet Text", 8, "Hide pet health and mana percent text", nil, nil},
    miniPetTextMaxShow = {true, "checkbox", nil, "miniTextShow", "Pet Text", 9, "Show pet max health and mana text", nil, nil},
    noTotPercent = {true, "checkbox", nil, "miniTextShow", "Target of Target Text", 10, "Hide target of target health and mana percent text", nil, nil},
    miniTotTextMaxShow = {true, "checkbox", nil, "miniTextShow", "Target of Target Text", 11, "Show target of target max health and mana text", nil, nil},
    noPartyPercent = {true, "checkbox", nil, "miniTextShow", "Party Text", 12, "Hide party health and mana percent text", nil, nil},
    miniPartyTextMaxShow = {true, "checkbox", nil, "miniTextShow", "Party Text", 13, "Show party max health and mana text", nil, nil},
    colorReaction = {true, "checkbox", nil, nil, "Health Bars", 14, "Color target of target health bars based on reaction", nil, nil},
    colorClass = {false, "checkbox", nil, nil, "Health Bars", 15, "Color target of target and party health bars based on class", nil, nil},
    enablePulse = {true, "checkbox", nil, nil, "Health Bars", 16, "Enable pulse animation on low health for all mini frames", nil, nil},
    pulseColor = {{1, 1, 1}, "colour", nil, "enablePulse", "Health Bars", 17, "Color for pulse animation on all mini frames", nil, nil},
    enableCutout = {true, "checkbox", nil, nil, "Health Bars", 18, "Enable cutout animation on damage for all mini frames", nil, nil},
    cutoutColor = {{1, 0, 0}, "colour", nil, "enableCutout", "Health Bars", 19, "Color for cutout animation on all mini frames", nil, nil},
})

DFRL:NewMod("Mini", 1, function()
    local configCache = {
        noPetPercent = nil,
        miniPetTextMaxShow = nil,
        noTotPercent = nil,
        miniTotTextMaxShow = nil,
        noPartyPercent = nil,
        miniPartyTextMaxShow = nil,
        lastUpdate = 0
    }

    -- setup
    local Setup = {
        path = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\tex\\unitframes\\",
        healthPercentText = nil,
        healthValueText = nil,
        manaPercentText = nil,
        manaValueText = nil,
        partyHealthPercentTexts = {},
        partyCustomBorders = {},
        totHealthPercentText = nil,
        totHealthValueText = nil,
        totManaPercentText = nil,
        totManaValueText = nil,
        petHealthBar = nil,
        petManaBar = nil,
        petXPBar = nil,       -- Hunter pet XP bar (PetXPBar merge)
        totHealthBar = nil,
        totManaBar = nil,
        partyHealthBars = {},
        partyManaBars = {},
        framesState = {
            colorReaction = false,
            colorClass = false,
        },
        UpdatePetTexts = nil,
    }

    function Setup:KillBlizz()

        -- Hard-disable vanilla pet bars/texts so they can never reappear under DFRL
        if PetFrameHealthBar then
            PetFrameHealthBar:Hide()
            PetFrameHealthBar.Show = function() end
        end
        if PetFrameManaBar then
            PetFrameManaBar:Hide()
            PetFrameManaBar.Show = function() end
        end

        -- Vanilla pet health texts (optional, but prevents pop-back / overlap)
        if PetFrameHealthBarText then
            PetFrameHealthBarText:Hide()
            PetFrameHealthBarText.Show = function() end
        end
        if PetFrameHealthBarTextLeft then
            PetFrameHealthBarTextLeft:Hide()
            PetFrameHealthBarTextLeft.Show = function() end
        end
        if PetFrameHealthBarTextRight then
            PetFrameHealthBarTextRight:Hide()
            PetFrameHealthBarTextRight.Show = function() end
        end

        -- Vanilla pet mana texts (optional, but prevents pop-back / overlap)
        if PetFrameManaBarText then
            PetFrameManaBarText:Hide()
            PetFrameManaBarText.Show = function() end
        end
        if PetFrameManaBarTextLeft then
            PetFrameManaBarTextLeft:Hide()
            PetFrameManaBarTextLeft.Show = function() end
        end
        if PetFrameManaBarTextRight then
            PetFrameManaBarTextRight:Hide()
            PetFrameManaBarTextRight.Show = function() end
        end
        TargetofTargetHealthBar:Hide()
        TargetofTargetManaBar:Hide()

        for i = 1, 4 do
            local healthBar = _G['PartyMemberFrame' .. i .. 'HealthBar']
            local manaBar = _G['PartyMemberFrame' .. i .. 'ManaBar']
            local borderTexture = _G['PartyMemberFrame' .. i .. 'Texture']
            if healthBar then healthBar:Hide() end
            if manaBar then manaBar:Hide() end
            if borderTexture then borderTexture:SetAlpha(0) end
        end
    end

    function Setup:PetFrameTexts()
        self.healthPercentText = self.petHealthBar:CreateFontString(nil, "OVERLAY")
        self.healthPercentText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        self.healthPercentText:SetPoint("LEFT", 5, 0)
        self.healthPercentText:SetTextColor(1, 1, 1)
        self.healthValueText = self.petHealthBar:CreateFontString(nil, "OVERLAY")
        self.healthValueText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        self.healthValueText:SetPoint("RIGHT", -5, 0)
        self.healthValueText:SetTextColor(1, 1, 1)
        self.manaPercentText = self.petManaBar:CreateFontString(nil, "OVERLAY")
        self.manaPercentText:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
        self.manaPercentText:SetPoint("LEFT", 5, 0)
        self.manaPercentText:SetTextColor(1, 1, 1)
        self.manaValueText = self.petManaBar:CreateFontString(nil, "OVERLAY")
        self.manaValueText:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
        self.manaValueText:SetPoint("RIGHT", -5, 0)
        self.manaValueText:SetTextColor(1, 1, 1)
    end

    function Setup:PetFrameSetup()
        self.petHealthBar = CreateStatusBar(PetFrame, 69, 19)
        self.petHealthBar:SetPoint('CENTER', PetFrame, 'CENTER', 15, 3)
        self.petHealthBar:SetTextures(self.path .. 'healthDF2.tga')
        self.petHealthBar:SetFillColor(0, 1, 0)
        self.petHealthBar.max = 100

        self.petManaBar = CreateStatusBar(PetFrame, 69, 7)
        self.petManaBar:SetPoint('CENTER', PetFrame, 'CENTER', 15, -7)
        self.petManaBar:SetTextures(self.path .. 'UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana-Status.blp')
        self.petManaBar:SetFillColor(0, 0, 1)
        self.petManaBar.max = 100

        -- Hunter pet XP bar (from PetXPBar) --
        -- Border dimensions are computed first so the bar height matches,
        -- ensuring the status bar fill covers the full interior of the border frame.
        local xpBarWidth = self.petManaBar:GetWidth() * 0.95  -- 95% of mana bar width
        local xpBorderWidth = xpBarWidth * 1.2
        local xpBorderHeight = xpBorderWidth / (120 / 18)  -- ~12.42px, preserves aspect ratio

        local xpBar = CreateFrame("StatusBar", "PetXPBar", PetFrame, "TextStatusBar")
        xpBar:SetWidth(xpBarWidth)
        xpBar:SetHeight(xpBorderHeight / 1.25)  -- inset within border vertically
        xpBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
        xpBar:SetStatusBarColor(1, 0, 1)  -- magenta
        xpBar:ClearAllPoints()
        xpBar:SetPoint("TOP", self.petManaBar, "BOTTOM", 0, -2)
        local xpBg = xpBar:CreateTexture(nil, "BACKGROUND")
        xpBg:SetAllPoints(xpBar)
        xpBg:SetVertexColor(0, 0, 0, 0.5)
        -- Border overlay: centered on the bar, offset left by half the extra width
        -- so the bar sits in the middle of the border horizontally.
        local xpBorder = xpBar:CreateTexture(nil, "OVERLAY")
        xpBorder:SetWidth(xpBorderWidth)
        xpBorder:SetHeight(xpBorderHeight)
        xpBorder:SetTexture([[Interface\CharacterFrame\UI-CharacterFrame-GroupIndicator]])
        xpBorder:SetPoint("CENTER", xpBar, "CENTER", 0, 0)
        xpBorder:SetTexCoord(0.0234375, 0.6875, 1.0, 0.0)
        xpBar:Hide()  -- hidden by default; shown only for hunter pets
        self.petXPBar = xpBar
        -- End pet XP bar setup --

        -- Move pet debuffs below the XP bar
        for i = 1, 4 do
            local debuff = _G["PetFrameDebuff" .. i]
            if debuff then
                debuff:ClearAllPoints()
                debuff:SetPoint("TOPLEFT", xpBar, "BOTTOMLEFT", (i - 1) * 18, -4)
            end
        end

        local petEventFrame = CreateFrame('Frame')
        petEventFrame:RegisterEvent('UNIT_HEALTH')
        petEventFrame:RegisterEvent('UNIT_MANA')
        petEventFrame:RegisterEvent('UNIT_ENERGY')
        petEventFrame:RegisterEvent('UNIT_RAGE')
        petEventFrame:RegisterEvent('UNIT_FOCUS')
        petEventFrame:SetScript('OnEvent', function()
            if arg1 == 'pet' and UnitExists('pet') then
                local health, maxHealth = UnitHealth('pet'), UnitHealthMax('pet')
                local mana, maxMana = UnitMana('pet'), UnitManaMax('pet')
                Setup.petHealthBar.max = maxHealth
                Setup.petHealthBar:SetValue(health)
                if maxMana > 0 then
                    Setup.petManaBar:Show()
                    Setup.petManaBar.max = maxMana
                    Setup.petManaBar:SetValue(mana > 0 and mana or 0.001)
                else
                    Setup.petManaBar:Hide()
                end
            end
        end)

        local new_PetFrame_Update = _G.PetFrame_Update
        _G.PetFrame_Update = function()
            new_PetFrame_Update()
            PetFrameHealthBar:SetWidth(0)
            PetFrameHealthBar:SetHeight(0)
            PetFrameHealthBar:SetAlpha(0)
            PetFrameHealthBar:Hide()
            PetFrameManaBar:SetWidth(0)
            PetFrameManaBar:SetHeight(0)
            PetFrameManaBar:SetAlpha(0)
            PetFrameManaBar:Hide()
            PetFrameTexture:SetTexture(Setup.path .. "pet")
            PetFrameTexture:SetDrawLayer("BACKGROUND")
            PetFrame:ClearAllPoints()
            PetFrame:SetPoint("BOTTOM", PlayerFrame, -10, -30)
            PetName:ClearAllPoints()
            PetName:SetPoint("CENTER", PetFrame, "CENTER", 5, 16)

            if UnitExists('pet') then
                local health, maxHealth = UnitHealth('pet'), UnitHealthMax('pet')
                local mana, maxMana = UnitMana('pet'), UnitManaMax('pet')
                Setup.petHealthBar.max = maxHealth
                Setup.petHealthBar:SetValue(health)
                Setup.petManaBar.max = maxMana
                Setup.petManaBar:SetValue(mana > 0 and mana or 0.001)

                local powerType = UnitPowerType('pet')
                if powerType == 0 then
                    Setup.petManaBar:SetFillColor(0, 0, 1)
                elseif powerType == 1 then
                    Setup.petManaBar:SetFillColor(1, 0, 0)
                elseif powerType == 2 then
                    Setup.petManaBar:SetFillColor(1, 1, 0)
                end
            end

            Setup.UpdatePetTexts()
        end
    end

    -- Updates the hunter pet XP bar visibility and value.
    -- Only shown when HasPetUI() indicates a hunter pet (isHunterPet == 1) below level 60.
    -- Debuffs are repositioned below the XP bar when visible, or below the mana bar when hidden.
    function Setup:UpdatePetXPBar()
        if not self.petXPBar then return end
        local hasPetInterface, isHunterPet = HasPetUI()
        local showXP = hasPetInterface == 1 and isHunterPet == 1 and (UnitLevel("pet") or 0) < 60
        if showXP then
            local curXP, maxXP = GetPetExperience()
            if maxXP and maxXP > 0 then
                self.petXPBar:SetMinMaxValues(0, maxXP)
                self.petXPBar:SetValue(curXP or 0)
                self.petXPBar:Show()
            else
                self.petXPBar:Hide()
                showXP = false
            end
        else
            self.petXPBar:Hide()
        end
        -- Reposition debuffs depending on whether the XP bar is visible
        local debuffAnchor = showXP and self.petXPBar or self.petManaBar
        for i = 1, 4 do
            local debuff = _G["PetFrameDebuff" .. i]
            if debuff then
                debuff:ClearAllPoints()
                debuff:SetPoint("TOPLEFT", debuffAnchor, "BOTTOMLEFT", (i - 1) * 18, -4)
            end
        end
    end

    function Setup:TargetOfTargetSetup()
        self.totHealthBar = CreateStatusBar(TargetofTargetFrame, 60, 13)
        self.totHealthBar:SetPoint('LEFT', TargetofTargetFrame, 'LEFT', 40, 1)
        self.totHealthBar:SetTextures(self.path .. 'healthDF2.tga')
        self.totHealthBar:SetFillColor(0, 1, 0)
        self.totHealthBar.max = 100

        self.totManaBar = CreateStatusBar(TargetofTargetFrame, 60, 7)
        self.totManaBar:SetPoint('TOPLEFT', self.totHealthBar, 'BOTTOMLEFT', 0, 1)
        self.totManaBar:SetTextures(self.path .. 'UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana-Status.blp')
        self.totManaBar:SetFillColor(0, 0, 1)
        self.totManaBar.max = 100

        TargetofTargetTexture:SetTexture(self.path .. "pet")

        -- mana/rage hook
        hooksecurefunc("TargetofTarget_Update", function()
            TargetofTargetHealthBar:Hide()
            TargetofTargetManaBar:Hide()
            if UnitExists('targettarget') then
                local health, maxHealth = UnitHealth('targettarget'), UnitHealthMax('targettarget')
                local mana, maxMana = UnitMana('targettarget'), UnitManaMax('targettarget')
                if maxHealth > 0 and health >= 0 then
                    Setup.totHealthBar.max = maxHealth
                    Setup.totHealthBar.val_ = health
                    Setup.totHealthBar:SetValue(health > 0 and health or 0.001)
                else
                    Setup.totHealthBar:Hide()
                    Setup.totManaBar:Hide()
                    return
                end
                if maxMana > 0 then
                    Setup.totManaBar:Show()
                    Setup.totManaBar.max = maxMana
                    Setup.totManaBar.val_ = mana
                    Setup.totManaBar:SetValue(mana > 0 and mana or 0.001)
                else
                    Setup.totManaBar:Hide()
                end

                local powerType = UnitPowerType('targettarget')
                if powerType == 0 then
                    Setup.totManaBar:SetFillColor(0, 0, 1)
                elseif powerType == 1 then
                    Setup.totManaBar:SetFillColor(1, 0, 0)
                elseif powerType == 2 then
                    Setup.totManaBar:SetFillColor(1, 1, 0)
                elseif powerType == 3 then
                    Setup.totManaBar:SetFillColor(1, 1, 0)
                end

                TargetofTargetFrame.name:SetText(AbbreviateName(UnitName("targettarget")))
            end
            Setup:UpdateTargetOfTargetTexts()
        end)

        TargetofTargetTexture:SetTexCoord(0, 1, 0, 1)
        TargetofTargetTexture:SetPoint("TOPLEFT", -0, 0)
        TargetofTargetTexture:SetPoint("BOTTOMRIGHT", 20, -15)
        TargetofTargetFrame:ClearAllPoints()
        TargetofTargetFrame:SetPoint("TOPLEFT", TargetFrame, "BOTTOM", 0, 20)
        TargetofTargetPortrait:SetHeight(32)
        TargetofTargetPortrait:SetWidth(32)
        TargetofTargetFrameDebuff1:ClearAllPoints()
        TargetofTargetFrameDebuff1:SetPoint("TOPLEFT", TargetofTargetFrame, "BOTTOMLEFT", 40, 5)
        TargetofTargetBackground:ClearAllPoints()
        TargetofTargetBackground:SetWidth(60)
        TargetofTargetBackground:SetPoint("LEFT", TargetofTargetFrame, "LEFT", 40, -2)

        TargetofTargetFrame.name:SetPoint("TOPLEFT", TargetofTargetFrame, "TOPLEFT", 40, 25)
    end

    function Setup:TargetOfTargetTexts()
        local textFrame = CreateFrame('Frame', nil, TargetofTargetFrame)
        textFrame:SetFrameLevel(TargetofTargetFrame:GetFrameLevel() + 10)
        textFrame:SetAllPoints(TargetofTargetFrame)

        self.totHealthPercentText = textFrame:CreateFontString(nil, 'OVERLAY')
        self.totHealthPercentText:SetFont('Fonts\\FRIZQT__.TTF', 9, 'OUTLINE')
        self.totHealthPercentText:SetPoint('LEFT', self.totHealthBar, 'LEFT', 5, 0)
        self.totHealthPercentText:SetTextColor(1, 1, 1)
        self.totHealthValueText = textFrame:CreateFontString(nil, 'OVERLAY')
        self.totHealthValueText:SetFont('Fonts\\FRIZQT__.TTF', 9, 'OUTLINE')
        self.totHealthValueText:SetPoint('RIGHT', self.totHealthBar, 'RIGHT', -5, 0)
        self.totHealthValueText:SetTextColor(1, 1, 1)
        self.totManaPercentText = textFrame:CreateFontString(nil, 'OVERLAY')
        self.totManaPercentText:SetFont('Fonts\\FRIZQT__.TTF', 8, 'OUTLINE')
        self.totManaPercentText:SetPoint('LEFT', self.totManaBar, 'LEFT', 5, 0)
        self.totManaPercentText:SetTextColor(1, 1, 1)
        self.totManaValueText = textFrame:CreateFontString(nil, 'OVERLAY')
        self.totManaValueText:SetFont('Fonts\\FRIZQT__.TTF', 8, 'OUTLINE')
        self.totManaValueText:SetPoint('RIGHT', self.totManaBar, 'RIGHT', -5, 0)
        self.totManaValueText:SetTextColor(1, 1, 1)
    end

    function Setup:PartyFramesSetup()
        PartyMemberFrame1:ClearAllPoints()
        PartyMemberFrame1:SetPoint("LEFT", UIParent, "LEFT", 10, 220)
        for i = 1, 4 do
            local frame = _G["PartyMemberFrame" .. i]
            local name = _G["PartyMemberFrame" .. i .. "Name"]
            local healthBar = _G["PartyMemberFrame" .. i .. "HealthBar"]
            local manaBar = _G["PartyMemberFrame" .. i .. "ManaBar"]


            local customBorder = frame:CreateTexture(nil, "OVERLAY")
            customBorder:SetTexture(self.path .. "pet")
            customBorder:SetDrawLayer("BORDER", 1)
            customBorder:SetPoint("CENTER", frame, 0, 0)
            customBorder:SetWidth(128)
            customBorder:SetHeight(64)
            self.partyCustomBorders[i] = customBorder

            local portrait = _G["PartyMemberFrame" .. i .. "Portrait"]
            if portrait then
                portrait:SetHeight(35)
                portrait:SetWidth(35)
                portrait:SetDrawLayer("BACKGROUND",1)
                portrait:ClearAllPoints()
                portrait:SetPoint("CENTER", frame, -40, 8.25)
            end

            local borderTexture = _G["PartyMemberFrame" .. i .. "Texture"]
            if borderTexture and borderTexture.SetFrameLevel then
                borderTexture:SetFrameLevel(frame:GetFrameLevel() - 2)
            end

            if name and frame then
                name:ClearAllPoints()
                name:SetPoint("CENTER", frame, "CENTER", 6, 23)
                name:SetDrawLayer("BORDER", 2)
            end

            if healthBar and manaBar and frame then
                healthBar:Hide()
                manaBar:Hide()

                self.partyHealthBars[i] = CreateStatusBar(frame, 69, 18)
                self.partyHealthBars[i]:SetPoint('CENTER', frame, 'CENTER', 15, 10)
                self.partyHealthBars[i]:SetFrameLevel(frame:GetFrameLevel() - 1)
                self.partyHealthBars[i]:SetTextures(self.path .. 'healthDF2.tga')
                self.partyHealthBars[i]:SetFillColor(0, 1, 0)
                self.partyHealthBars[i].max = 100

                self.partyManaBars[i] = CreateStatusBar(frame, 69, 7)
                self.partyManaBars[i]:SetPoint('CENTER', frame, 'CENTER', 15, 0.5)
                self.partyManaBars[i]:SetFrameLevel(frame:GetFrameLevel() - 1)
                self.partyManaBars[i]:SetTextures(self.path .. 'UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana-Status.blp')
                self.partyManaBars[i]:SetFillColor(0, 0, 1)
                self.partyManaBars[i].max = 100

                local healthBg = self.partyHealthBars[i]:CreateTexture(nil, 'BACKGROUND')
                healthBg:SetTexture('Interface\\Buttons\\WHITE8X8')
                healthBg:SetVertexColor(0, 0, 0, 0.3)
                healthBg:SetAllPoints()

                local manaBg = self.partyManaBars[i]:CreateTexture(nil, 'BACKGROUND')
                manaBg:SetTexture('Interface\\Buttons\\WHITE8X8')
                manaBg:SetVertexColor(0, 0, 0, 0.3)
                manaBg:SetAllPoints()

                local partyHealthText = self.partyHealthBars[i]:CreateFontString(nil, "OVERLAY")
                partyHealthText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
                partyHealthText:SetPoint("CENTER", 0, 0)
                partyHealthText:SetTextColor(1, 1, 1)
                self.partyHealthPercentTexts[i] = partyHealthText

                local offlineBg = frame:CreateTexture(nil, 'BACKGROUND')
                offlineBg:SetTexture('Interface\\Buttons\\WHITE8X8')
                offlineBg:SetVertexColor(0, 0, 0, 0.5)
                offlineBg:SetPoint('CENTER', frame, 'CENTER', 15, 5.25)
                offlineBg:SetWidth(69)
                offlineBg:SetHeight(25)
                offlineBg:Hide()
                self.partyOfflineBgs = self.partyOfflineBgs or {}
                self.partyOfflineBgs[i] = offlineBg

                local offlineText = frame:CreateFontString(nil, 'OVERLAY')
                offlineText:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')
                offlineText:SetPoint('CENTER', frame, 'CENTER', 15, 5.25)
                offlineText:SetTextColor(0.7, 0.7, 0.7)
                offlineText:SetText('OFFLINE')
                offlineText:Hide()
                self.partyOfflineTexts = self.partyOfflineTexts or {}
                self.partyOfflineTexts[i] = offlineText
            end
        end
    end

    function Setup:UpdateTexts()
        self.UpdatePetTexts = function()
            if not UnitExists("pet") then return end

            local health = UnitHealth("pet")
            local maxHealth = UnitHealthMax("pet")
            local healthPercent = maxHealth > 0 and math.floor((health / maxHealth) * 100) or 0

            local mana = UnitMana("pet")
            local maxMana = UnitManaMax("pet")
            local manaPercent = maxMana > 0 and math.floor((mana / maxMana) * 100) or 0

            local now = GetTime()
            if not configCache.noPetPercent or (now - configCache.lastUpdate > 1) then
                configCache.noPetPercent = DFRL:GetTempDB("Mini", "noPetPercent")
                configCache.lastUpdate = now
            end

            local noPetPercentEnabled = configCache.noPetPercent
            local isMaxHealthManaEnabled = configCache.miniPetTextMaxShow

            if noPetPercentEnabled then
                Setup.healthPercentText:SetText("")
                Setup.healthValueText:SetText(health .. (isMaxHealthManaEnabled and "/" .. maxHealth or ""))
                Setup.healthValueText:ClearAllPoints()
                Setup.healthValueText:SetPoint("CENTER", Setup.petHealthBar, "CENTER", 0, 0)

                Setup.manaPercentText:SetText("")
                if maxMana > 0 then
                    Setup.manaValueText:SetText(mana .. (isMaxHealthManaEnabled and "/" .. maxMana or ""))
                    Setup.manaValueText:ClearAllPoints()
                    Setup.manaValueText:SetPoint("CENTER", Setup.petManaBar, "CENTER", 0, 0)
                else
                    Setup.manaValueText:SetText("")
                end
            else
                Setup.healthPercentText:SetText(healthPercent .. "%")
                Setup.healthValueText:SetText(health .. (isMaxHealthManaEnabled and "/" .. maxHealth or ""))
                Setup.healthValueText:ClearAllPoints()
                Setup.healthValueText:SetPoint("RIGHT", Setup.petHealthBar, "RIGHT", -5, 0)

                if maxMana > 0 then
                    Setup.manaPercentText:SetText(manaPercent .. "%")
                    Setup.manaValueText:SetText(mana .. (isMaxHealthManaEnabled and "/" .. maxMana or ""))
                    Setup.manaValueText:ClearAllPoints()
                    Setup.manaValueText:SetPoint("RIGHT", Setup.petManaBar, "RIGHT", -5, 0)
                else
                    Setup.manaPercentText:SetText("")
                    Setup.manaValueText:SetText("")
                end
            end
        end
    end

    function Setup:UpdateTargetOfTargetTexts()
        if not UnitExists("targettarget") then
            self.totHealthPercentText:SetText("")
            self.totHealthValueText:SetText("")
            self.totManaPercentText:SetText("")
            self.totManaValueText:SetText("")
            return
        end
        local health = UnitHealth("targettarget")
        local maxHealth = UnitHealthMax("targettarget")
        local healthPercent = maxHealth > 0 and math.floor((health / maxHealth) * 100) or 0
        local mana = UnitMana("targettarget")
        local maxMana = UnitManaMax("targettarget")
        local manaPercent = maxMana > 0 and math.floor((mana / maxMana) * 100) or 0
        local now = GetTime()
        local isMaxHealthManaEnabled = configCache.miniTotTextMaxShow
        if not configCache.noTotPercent or (now - configCache.lastUpdate > 0.5) then
            configCache.noTotPercent = DFRL:GetTempDB("Mini", "noTotPercent")
            configCache.lastUpdate = now
        end
        local noTotPercentEnabled = configCache.noTotPercent
        local isDead = UnitIsDead("targettarget") or UnitIsGhost("targettarget")
        if isDead then
            self.totHealthPercentText:SetText("")
            self.totHealthValueText:SetText("")
            self.totManaPercentText:SetText("")
            self.totManaValueText:SetText("")
            return
        end
        if noTotPercentEnabled then
            self.totHealthPercentText:SetText("")
            self.totHealthValueText:SetText(health .. (isMaxHealthManaEnabled and "/" .. maxHealth or ""))
            self.totHealthValueText:ClearAllPoints()
            self.totHealthValueText:SetPoint("CENTER", self.totHealthBar, "CENTER", 0, 0)

            self.totManaPercentText:SetText("")
            if maxMana > 0 then
                self.totManaValueText:SetText(mana .. (isMaxHealthManaEnabled and "/" .. maxMana or ""))
                self.totManaValueText:ClearAllPoints()
                self.totManaValueText:SetPoint("CENTER", self.totManaBar, "CENTER", 0, 0)
            else
                self.totManaValueText:SetText("")
            end
        else
            self.totHealthPercentText:SetText(healthPercent .. "%")
            self.totHealthValueText:SetText(health .. (isMaxHealthManaEnabled and "/" .. maxHealth or ""))
            self.totHealthValueText:ClearAllPoints()
            self.totHealthValueText:SetPoint("RIGHT", self.totHealthBar, "RIGHT", -5, 0)

            if maxMana > 0 then
                self.totManaPercentText:SetText(manaPercent .. "%")
                self.totManaValueText:SetText(mana .. (isMaxHealthManaEnabled and "/" .. maxMana or ""))
                self.totManaValueText:ClearAllPoints()
                self.totManaValueText:SetPoint("RIGHT", self.totManaBar, "RIGHT", -5, 0)
            else
                self.totManaPercentText:SetText("")
                self.totManaValueText:SetText("")
            end
        end
    end

    function Setup:StateManagement()
        local function IsTargetOfTargetTaggedByOther()
            if not UnitExists("targettarget") or UnitIsPlayer("targettarget") then
                return false
            end
            return UnitIsTapped("targettarget") and not UnitIsTappedByPlayer("targettarget")
        end
        self.framesState.updateToTColor = function(self)
            if not UnitExists("targettarget") then
                Setup.totHealthBar:SetFillColor(0, 1, 0)
                return
            end
            if IsTargetOfTargetTaggedByOther() then
                Setup.totHealthBar:SetFillColor(0.5, 0.5, 0.5)
                return
            end
            if self.colorClass and UnitIsPlayer("targettarget") then
                local _, class = UnitClass("targettarget")
                if class and RAID_CLASS_COLORS[class] then
                    local color = RAID_CLASS_COLORS[class]
                    Setup.totHealthBar:SetFillColor(color.r, color.g, color.b)
                    return
                end
            end

            if self.colorReaction then
                local reaction = UnitReaction("player", "targettarget")
                if reaction then
                    if reaction >= 5 then
                        -- friendly (5+) - green
                        Setup.totHealthBar:SetFillColor(0, 1, 0)
                    elseif reaction == 4 then
                        -- neutral (4) - yellow
                        Setup.totHealthBar:SetFillColor(1, 1, 0)
                    elseif reaction <= 3 then
                        -- hostile (1-3) - red
                        Setup.totHealthBar:SetFillColor(1, 0, 0)
                    end
                    return
                end
            end
            Setup.totHealthBar:SetFillColor(0, 1, 0)
        end

        self.framesState.updatePartyColors = function(self)
            for i = 1, 4 do
                if UnitExists("party" .. i) and Setup.partyHealthBars[i] then
                    if self.colorClass then
                        local _, class = UnitClass("party" .. i)
                        if class and RAID_CLASS_COLORS[class] then
                            local color = RAID_CLASS_COLORS[class]
                            Setup.partyHealthBars[i]:SetFillColor(color.r, color.g, color.b)
                        else
                            Setup.partyHealthBars[i]:SetFillColor(0, 1, 0)
                        end
                    else
                        Setup.partyHealthBars[i]:SetFillColor(0, 1, 0)
                    end
                end
            end
        end
        self.framesState.updateAllColors = function(self)
            self:updateToTColor()
            self:updatePartyColors()
        end
    end

    function Setup:HookEvents()
        hooksecurefunc("TargetofTarget_Update", function()
            Setup.framesState:updateToTColor()
        end)
    end

    function Setup:Run()
        self:KillBlizz()
        self:PetFrameSetup()
        self:PetFrameTexts()
        self:TargetOfTargetSetup()
        self:TargetOfTargetTexts()
        self:PartyFramesSetup()
        self:UpdateTexts()
        self:StateManagement()
        self:HookEvents()
        self.UpdatePetTexts()
        self:UpdateTargetOfTargetTexts()
        self:UpdatePetXPBar()
    end

    Setup:Run()

    -- callbacks
    local callbacks = {}

    callbacks.miniTextShow = function(value)
        if value then
            Setup.healthPercentText:Show()
            Setup.healthValueText:Show()
            Setup.manaPercentText:Show()
            Setup.manaValueText:Show()

            Setup.totHealthPercentText:Show()
            Setup.totHealthValueText:Show()
            Setup.totManaPercentText:Show()
            Setup.totManaValueText:Show()

            for i = 1, 4 do
                Setup.partyHealthPercentTexts[i]:Show()
            end
        else
            Setup.healthPercentText:Hide()
            Setup.healthValueText:Hide()
            Setup.manaPercentText:Hide()
            Setup.manaValueText:Hide()

            Setup.totHealthPercentText:Hide()
            Setup.totHealthValueText:Hide()
            Setup.totManaPercentText:Hide()
            Setup.totManaValueText:Hide()

            for i = 1, 4 do
                Setup.partyHealthPercentTexts[i]:Hide()
            end
        end
    end

    callbacks.miniDarkMode = function(value)
        local intensity = DFRL:GetTempDB("Mini", "miniDarkMode")
        local miniColor = DFRL:GetTempDB("Mini", "miniColor")
        local r, g, b = miniColor[1] * (1 - intensity), miniColor[2] * (1 - intensity), miniColor[3] * (1 - intensity)
        local color = value and {r, g, b} or {1, 1, 1}

        PetFrameTexture:SetVertexColor(color[1], color[2], color[3])
        TargetofTargetTexture:SetVertexColor(color[1], color[2], color[3])

        for i = 1, 4 do
            Setup.partyCustomBorders[i]:SetVertexColor(color[1], color[2], color[3])
        end
    end

    callbacks.miniColor = function(value)
        local intensity = DFRL:GetTempDB("Mini", "miniDarkMode")
        local r, g, b = value[1] * (1 - intensity), value[2] * (1 - intensity), value[3] * (1 - intensity)

        PetFrameTexture:SetVertexColor(r, g, b)
        TargetofTargetTexture:SetVertexColor(r, g, b)

        for i = 1, 4 do
            Setup.partyCustomBorders[i]:SetVertexColor(r, g, b)
        end
    end

    callbacks.miniPetTextMaxShow = function(value)
        configCache.miniPetTextMaxShow = value
        configCache.lastUpdate = GetTime()
        Setup.UpdatePetTexts()
    end

    callbacks.miniTotTextMaxShow = function(value)
        configCache.miniTotTextMaxShow = value
        configCache.lastUpdate = GetTime()
        Setup:UpdateTexts()
    end

    callbacks.miniPartyTextMaxShow = function(value)
        configCache.miniPartyTextMaxShow = value
        configCache.lastUpdate = GetTime()
        for i = 1, 4 do
            if UnitExists('party' .. i) and Setup.partyHealthBars[i] then
                local health = UnitHealth('party' .. i)
                local maxHealth = UnitHealthMax('party' .. i)
                local noPartyPercentEnabled = DFRL:GetTempDB('Mini', 'noPartyPercent')
                if noPartyPercentEnabled then
                    Setup.partyHealthPercentTexts[i]:SetText(health .. (value and '/' .. maxHealth or ''))
                else
                    local healthPercent = maxHealth > 0 and math.floor((health / maxHealth) * 100) or 0
                    Setup.partyHealthPercentTexts[i]:SetText(healthPercent .. '%')
                end
            end
        end
    end

    callbacks.noPetPercent = function(value)
        configCache.noPetPercent = value
        configCache.lastUpdate = GetTime()
        Setup.UpdatePetTexts()
    end

    callbacks.noTotPercent = function(value)
        configCache.noTotPercent = value
        configCache.lastUpdate = GetTime()
        Setup:UpdateTargetOfTargetTexts()
    end

    callbacks.noPartyPercent = function(value)
        for i = 1, 4 do
            if UnitExists("party" .. i) and Setup.partyHealthBars[i] then
                local health = UnitHealth("party" .. i)
                local maxHealth = UnitHealthMax("party" .. i)
                Setup.partyHealthBars[i].max = maxHealth
                Setup.partyHealthBars[i]:SetValue(health)

                if value then
                    Setup.partyHealthPercentTexts[i]:SetText(health .. (configCache.miniPartyTextMaxShow and "/" .. maxHealth or ""))
                else
                    local healthPercent = maxHealth > 0 and math.floor((health / maxHealth) * 100) or 0
                    Setup.partyHealthPercentTexts[i]:SetText(healthPercent .. "%")
                end
            end
        end
    end

    callbacks.colorReaction = function(value)
        Setup.framesState.colorReaction = value
        Setup.framesState:updateAllColors()
    end

    callbacks.colorClass = function(value)
        Setup.framesState.colorClass = value
        Setup.framesState:updateAllColors()
    end

    callbacks.frameFont = function(value)
        local fontPath
        if value == "Expressway" then
            fontPath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Expressway.ttf"
        elseif value == "Homespun" then
            fontPath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Homespun.ttf"
        elseif value == "Hooge" then
            fontPath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Hooge.ttf"
        elseif value == "Myriad-Pro" then
            fontPath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Myriad-Pro.ttf"
        elseif value == "Prototype" then
            fontPath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Prototype.ttf"
        elseif value == "PT-Sans-Narrow-Bold" then
            fontPath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\PT-Sans-Narrow-Bold.ttf"
        elseif value == "PT-Sans-Narrow-Regular" then
            fontPath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\PT-Sans-Narrow-Regular.ttf"
        elseif value == "RobotoMono" then
            fontPath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\RobotoMono.ttf"
        elseif value == "BigNoodleTitling" then
            fontPath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\BigNoodleTitling.ttf"
        elseif value == "Continuum" then
            fontPath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\Continuum.ttf"
        elseif value == "DieDieDie" then
            fontPath = "Interface\\AddOns\\DragonflightUI-Reforged\\media\\fnt\\DieDieDie.ttf"
        else
            fontPath = "Fonts\\FRIZQT__.TTF"
        end
        Setup.healthPercentText:SetFont(fontPath, 9, "OUTLINE")
        Setup.healthValueText:SetFont(fontPath, 9, "OUTLINE")
        Setup.manaPercentText:SetFont(fontPath, 8, "OUTLINE")
        Setup.manaValueText:SetFont(fontPath, 8, "OUTLINE")
        Setup.totHealthPercentText:SetFont(fontPath, 9, "OUTLINE")
        Setup.totHealthValueText:SetFont(fontPath, 9, "OUTLINE")
        Setup.totManaPercentText:SetFont(fontPath, 8, "OUTLINE")
        Setup.totManaValueText:SetFont(fontPath, 8, "OUTLINE")
        for i = 1, 4 do
            Setup.partyHealthPercentTexts[i]:SetFont(fontPath, 9, "OUTLINE")
        end
        PetName:SetFont(fontPath, 10, "")
        TargetofTargetName:SetFont(fontPath, 9, "")
        for i = 1, 4 do
            local partyName = getglobal("PartyMemberFrame" .. i .. "Name")
            if partyName then
                partyName:SetFont(fontPath, 10, "")
            end
        end
    end

    callbacks.petFrameScale = function(value)
        PetFrame:SetScale(value)
    end

    callbacks.partyFrameScale = function(value)
        for i = 1, 4 do
            _G['PartyMemberFrame' .. i]:SetScale(value)
        end
    end

    callbacks.totFrameScale = function(value)
        TargetofTargetFrame:SetScale(value)
    end

    callbacks.cutoutColor = function(value)
        if Setup.petHealthBar then Setup.petHealthBar:SetCutoutColor(value[1], value[2], value[3]) end
        if Setup.petManaBar then Setup.petManaBar:SetCutoutColor(value[1], value[2], value[3]) end
        if Setup.totHealthBar then Setup.totHealthBar:SetCutoutColor(value[1], value[2], value[3]) end
        if Setup.totManaBar then Setup.totManaBar:SetCutoutColor(value[1], value[2], value[3]) end
        for i = 1, 4 do
            if Setup.partyHealthBars[i] then Setup.partyHealthBars[i]:SetCutoutColor(value[1], value[2], value[3]) end
            if Setup.partyManaBars[i] then Setup.partyManaBars[i]:SetCutoutColor(value[1], value[2], value[3]) end
        end
    end

    callbacks.pulseColor = function(value)
        if Setup.petHealthBar then Setup.petHealthBar:SetPulseColor(value[1], value[2], value[3]) end
        if Setup.petManaBar then Setup.petManaBar:SetPulseColor(value[1], value[2], value[3]) end
        if Setup.totHealthBar then Setup.totHealthBar:SetPulseColor(value[1], value[2], value[3]) end
        if Setup.totManaBar then Setup.totManaBar:SetPulseColor(value[1], value[2], value[3]) end
        for i = 1, 4 do
            if Setup.partyHealthBars[i] then Setup.partyHealthBars[i]:SetPulseColor(value[1], value[2], value[3]) end
            if Setup.partyManaBars[i] then Setup.partyManaBars[i]:SetPulseColor(value[1], value[2], value[3]) end
        end
    end

    callbacks.enablePulse = function(value)
        if Setup.petHealthBar then Setup.petHealthBar:SetPulseAnimation(value) end
        if Setup.petManaBar then Setup.petManaBar:SetPulseAnimation(value) end
        if Setup.totHealthBar then Setup.totHealthBar:SetPulseAnimation(value) end
        if Setup.totManaBar then Setup.totManaBar:SetPulseAnimation(value) end
        for i = 1, 4 do
            if Setup.partyHealthBars[i] then Setup.partyHealthBars[i]:SetPulseAnimation(value) end
            if Setup.partyManaBars[i] then Setup.partyManaBars[i]:SetPulseAnimation(value) end
        end
    end

    callbacks.enableCutout = function(value)
        if Setup.petHealthBar then Setup.petHealthBar:SetCutoutAnimation(value) end
        if Setup.petManaBar then Setup.petManaBar:SetCutoutAnimation(value) end
        if Setup.totHealthBar then Setup.totHealthBar:SetCutoutAnimation(value) end
        if Setup.totManaBar then Setup.totManaBar:SetCutoutAnimation(value) end
        for i = 1, 4 do
            if Setup.partyHealthBars[i] then Setup.partyHealthBars[i]:SetCutoutAnimation(value) end
            if Setup.partyManaBars[i] then Setup.partyManaBars[i]:SetCutoutAnimation(value) end
        end
    end

    -- event handler
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_HEALTH")
    f:RegisterEvent("UNIT_MANA")
    f:RegisterEvent("UNIT_ENERGY")
    f:RegisterEvent("UNIT_RAGE")
    f:RegisterEvent("UNIT_FOCUS")
    f:RegisterEvent("UNIT_PET")
    f:RegisterEvent("UNIT_PET_EXPERIENCE")  -- Hunter pet XP (from PetXPBar)
    f:RegisterEvent("PARTY_MEMBERS_CHANGED")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")
    f:RegisterEvent("UNIT_TARGET")
    f:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
    f:SetScript("OnEvent", function()
        if event == "PLAYER_TARGET_CHANGED" then
            if Setup.totHealthBar then Setup.totHealthBar:SuppressCutout() end
            if Setup.totManaBar then Setup.totManaBar:SuppressCutout() end
        elseif event == "UPDATE_SHAPESHIFT_FORMS" then
            if Setup.totHealthBar then Setup.totHealthBar:SuppressCutout() end
            if Setup.totManaBar then Setup.totManaBar:SuppressCutout() end
            for i = 1, 4 do
                if Setup.partyHealthBars[i] then Setup.partyHealthBars[i]:SuppressCutout() end
                if Setup.partyManaBars[i] then Setup.partyManaBars[i]:SuppressCutout() end
            end
        end

        -- Hunter pet XP bar update (from PetXPBar)
        if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_PET" or event == "UNIT_PET_EXPERIENCE" then
            Setup:UpdatePetXPBar()
        end

        if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_PET" or
            (event == "UNIT_HEALTH" and arg1 == "pet") or
            (event == "UNIT_MANA" and arg1 == "pet") or
            (event == "UNIT_ENERGY" and arg1 == "pet") or
            (event == "UNIT_RAGE" and arg1 == "pet") or
            (event == "UNIT_FOCUS" and arg1 == "pet") then
            Setup.UpdatePetTexts()
        end
        local partyUpdateTimer = nil
        if event == "PLAYER_ENTERING_WORLD" or event == "PARTY_MEMBERS_CHANGED" or
            (event == "UNIT_HEALTH" and string.find(arg1, "party")) or
            (event == "UNIT_MANA" and string.find(arg1, "party")) or
            (event == "UNIT_ENERGY" and string.find(arg1, "party")) or
            (event == "UNIT_RAGE" and string.find(arg1, "party")) or
            (event == "UNIT_FOCUS" and string.find(arg1, "party")) then
            local now = GetTime()
            if not configCache.noPartyPercent or (now - configCache.lastUpdate > 1) then
                configCache.noPartyPercent = DFRL:GetTempDB("Mini", "noPartyPercent")
                configCache.lastUpdate = now
            end
            local value = configCache.noPartyPercent
            for i = 1, 4 do
                if UnitExists("party" .. i) and Setup.partyHealthBars[i] then
                    if not UnitIsConnected("party" .. i) then
                        Setup.partyHealthBars[i]:Hide()
                        Setup.partyManaBars[i]:Hide()
                        Setup.partyHealthPercentTexts[i]:SetText("")
                        if Setup.partyOfflineBgs and Setup.partyOfflineBgs[i] then
                            Setup.partyOfflineBgs[i]:Show()
                        end
                        if Setup.partyOfflineTexts and Setup.partyOfflineTexts[i] then
                            Setup.partyOfflineTexts[i]:Show()
                        end
                    else
                        if Setup.partyOfflineBgs and Setup.partyOfflineBgs[i] then
                            Setup.partyOfflineBgs[i]:Hide()
                        end
                        if Setup.partyOfflineTexts and Setup.partyOfflineTexts[i] then
                            Setup.partyOfflineTexts[i]:Hide()
                        end
                        local health = UnitHealth("party" .. i)
                        local maxHealth = UnitHealthMax("party" .. i)
                        if maxHealth > 0 and health > 0 then
                            Setup.partyHealthBars[i]:Show()
                            Setup.partyHealthBars[i].max = maxHealth
                            Setup.partyHealthBars[i]:SetValue(health)

                            local mana = UnitMana("party" .. i)
                            local maxMana = UnitManaMax("party" .. i)
                            if Setup.partyManaBars[i] then
                                if maxMana > 0 then
                                    Setup.partyManaBars[i]:Show()
                                    Setup.partyManaBars[i].max = maxMana
                                    Setup.partyManaBars[i]:SetValue(mana > 0 and mana or 0.001)

                                    local powerType = UnitPowerType("party" .. i)
                                    if powerType == 0 then
                                        Setup.partyManaBars[i]:SetFillColor(0, 0, 1)
                                    elseif powerType == 1 then
                                        Setup.partyManaBars[i]:SetFillColor(1, 0, 0)
                                    elseif powerType == 2 then
                                        Setup.partyManaBars[i]:SetFillColor(1, 1, 0)
                                    elseif powerType == 3 then
                                        Setup.partyManaBars[i]:SetFillColor(1, 1, 0)
                                    end
                                else
                                    Setup.partyManaBars[i]:Hide()
                                end
                            end

                            if value then
                                Setup.partyHealthPercentTexts[i]:SetText(health .. (configCache.miniPartyTextMaxShow and "/" .. maxHealth or ""))
                            else
                                local healthPercent = maxHealth > 0 and math.floor((health / maxHealth) * 100) or 0
                                Setup.partyHealthPercentTexts[i]:SetText(healthPercent .. "%")
                            end
                        else
                            Setup.partyHealthBars[i]:Hide()
                            Setup.partyHealthPercentTexts[i]:SetText("")
                            if Setup.partyManaBars[i] then
                                Setup.partyManaBars[i]:Hide()
                            end
                        end
                    end
                else
                    Setup.partyHealthPercentTexts[i]:SetText("")
                    if Setup.partyOfflineBgs and Setup.partyOfflineBgs[i] then
                        Setup.partyOfflineBgs[i]:Hide()
                    end
                    if Setup.partyOfflineTexts and Setup.partyOfflineTexts[i] then
                        Setup.partyOfflineTexts[i]:Hide()
                    end
                end
            end
            if event == "PARTY_MEMBERS_CHANGED" then
                if partyUpdateTimer then
                    partyUpdateTimer:SetScript("OnUpdate", nil)
                else
                    partyUpdateTimer = CreateFrame("Frame")
                end

                partyUpdateTimer:SetScript("OnUpdate", function()
                    Setup.framesState:updatePartyColors()
                    partyUpdateTimer:SetScript("OnUpdate", nil)
                end)
            else
                Setup.framesState:updatePartyColors()
            end
        end
        if event == "PLAYER_ENTERING_WORLD" or
        event == "PLAYER_TARGET_CHANGED" or
        (event == "UNIT_TARGET" and arg1 == "target") or
        (event == "UNIT_HEALTH" and arg1 == "targettarget") then
            Setup.framesState:updateToTColor()
        end
        if event == "PLAYER_ENTERING_WORLD" then
            f:UnregisterEvent("PLAYER_ENTERING_WORLD")
        end
    end)

    -- execute callbacks
    DFRL:NewCallbacks("Mini", callbacks)
end)
