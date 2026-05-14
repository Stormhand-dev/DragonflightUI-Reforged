setfenv(1, DFRL:GetEnv())

local Setup = {
    fixed = {
        shaguCore = false,
        shaguExtras = false,
    },

    addons = {
        ["ShaguTweaks"] = "shagu",
        ["ShaguTweaks-extras"] = "shagu",
    },

    processed = {}
}

--=================
-- SHAGU
--=================
function Setup:ShaguCore()
    local T = ShaguTweaks.T
    ShaguTweaks.mods[T["Hide Errors"]].enable = function() end
    ShaguTweaks.mods[T["Darkened UI"]].enable = function() end
    ShaguTweaks.mods[T["Hide Gryphons"]].enable = function() end
    ShaguTweaks.mods[T["MiniMap Clock"]].enable = function() end
    ShaguTweaks.mods[T["MiniMap Tweaks"]].enable = function() end
    ShaguTweaks.mods[T["MiniMap Square"]].enable = function() end
    ShaguTweaks.mods[T["Movable Unit Frames"]].enable = function() end
    ShaguTweaks.mods[T["Real Health Numbers"]].enable = function() end
    ShaguTweaks.mods[T["Unit Frame Big Health"]].enable = function() end
    ShaguTweaks.mods[T["Reduced Actionbar Size"]].enable = function() end
    ShaguTweaks.mods[T["Unit Frame Class Colors"]].enable = function() end
    ShaguTweaks.mods[T["Unit Frame Health Colors"]].enable = function() end
    ShaguTweaks.mods[T["Unit Frame Class Portraits"]].enable = function() end
end

function Setup:ShaguExtras()
    local T = ShaguTweaks.T
    ShaguTweaks.mods[T["Show Bags"]].enable = function() end
    ShaguTweaks.mods[T["Show Micro Menu"]].enable = function() end
    ShaguTweaks.mods[T["Reagent Counter"]].enable = function() end
    ShaguTweaks.mods[T["Show Energy Ticks"]].enable = function() end
    ShaguTweaks.mods[T["Floating Actionbar"]].enable = function() end
    ShaguTweaks.mods[T["Dragonflight Gryphons"]].enable = function() end
    ShaguTweaks.mods[T["Center Vertical Actionbar"]].enable = function() end
end

function Setup:ShaguBagBorders()
    local mod = ShaguTweaks.mods[ShaguTweaks.T["Item Rarity Borders"]]
    if not mod then return end

    local orig = mod.enable
    mod.enable = function(self)
        orig(self)
        local skip = {
            "CharacterBag0Slot","CharacterBag1Slot",
            "CharacterBag2Slot","CharacterBag3Slot",
            "KeyRingButton"
        }
        for _, name in pairs(skip) do
            local btn = _G[name]
            if btn and btn.ShaguTweaks_border then
                btn.ShaguTweaks_border:Hide()
            end
        end
    end
end

function Setup:ShaguGUI()
    GameMenuButtonAdvancedOptions:Hide()
    GameMenuButtonAdvancedOptions:SetScript("OnClick", nil)
    AdvancedSettingsGUI:Hide()
    AdvancedSettingsGUI.Show = function() end
end

function Setup:ShaguMetaData()
    return {
        core = {
            ["Auto Dismount"]            = {true, "checkbox", nil, nil, "automation", 1, "Dismounts automatically when casting a mount", nil, nil},
            ["Auto Stance"]              = {true, "checkbox", nil, nil, "automation", 2, "Auto switch stance when needed in combat", nil, nil},
            ["Enemy Castbars"]           = {true, "checkbox", nil, nil, "castbars & plates", 3, "Show enemy unitframe castbars during cast", nil, nil},
            ["Nameplate Castbar"]        = {true, "checkbox", nil, nil, "castbars & plates", 4, "Show castbar on nameplates for enemies", nil, nil},
            ["Nameplate Scale"]          = {true, "checkbox", nil, nil, "castbars & plates", 5, "Scale nameplates up or down visually", nil, nil},
            ["Chat Hyperlinks"]          = {true, "checkbox", nil, nil, "chat", 6, "Enable clickable item links in chat", nil, nil},
            ["Chat Tweaks"]              = {true, "checkbox", nil, nil, "chat", 7, "Improves chat window behavior and usability", nil, nil},
            ["Social Colors"]            = {true, "checkbox", nil, nil, "chat", 8, "Color names by their social status rank", nil, nil},
            ["Blue Shaman Class Colors"] = {true, "checkbox", nil, nil, "colors", 9, "Use blue as default Shaman class color", nil, nil},
            ["Nameplate Class Colors"]   = {true, "checkbox", nil, nil, "colors", 10, "Use class color on nameplate text", nil, nil},
            ["WorldMap Class Colors"]    = {true, "checkbox", nil, nil, "colors", 11, "Apply class colors to map icons", nil, nil},
            ["Cooldown Numbers"]         = {true, "checkbox", nil, nil, "combat", 12, "Show cooldown timers as numbers always", nil, nil},
            ["Debuff Timer"]             = {true, "checkbox", nil, nil, "combat", 13, "Show durations for active debuffs", nil, nil},
            ["Super WoW Compatibility"]  = {true, "checkbox", nil, nil, "compatibility", 14, "Support addons made for Super WoW", nil, nil},
            ["Turtle WoW Compatibility"] = {true, "checkbox", nil, nil, "compatibility", 15, "Support Turtle WoW custom server", nil, nil},
            ["Equip Compare"]            = {true, "checkbox", nil, nil, "tooltip", 16, "Compare items directly in tooltips", nil, nil},
            ["Item Rarity Borders"]      = {true, "checkbox", nil, nil, "tooltip", 17, "Outline tooltips based on item rarity", nil, nil},
            ["Tooltip Details"]          = {true, "checkbox", nil, nil, "tooltip", 18, "Add extra details to item tooltips", nil, nil},
            ["Sell Junk"]                = {true, "checkbox", nil, nil, "vendor", 19, "Auto sell all gray quality junk", nil, nil},
            ["Vendor Values"]            = {true, "checkbox", nil, nil, "vendor", 20, "Show vendor prices in all tooltips", nil, nil},
            ["WorldMap Coordinates"]     = {true, "checkbox", nil, nil, "worldmap", 21, "Show cursor/player coordinates live", nil, nil},
            ["WorldMap Window"]          = {true, "checkbox", nil, nil, "worldmap", 22, "Movable and windowed world map UI", nil, nil},
        },
        extras = {
            ["Bag Item Click"]           = {true, "checkbox", nil, nil, "bags", 1, "Use right-click actions inside bags", nil, nil},
            ["Bag Search Bar"]           = {true, "checkbox", nil, nil, "bags", 2, "Adds a search bar to all bags", nil, nil},
            ["Center Text Input Box"]    = {true, "checkbox", nil, nil, "chat", 3, "Center the input box in chat frame", nil, nil},
            ["Chat History"]             = {true, "checkbox", nil, nil, "chat", 4, "Save recent chat messages locally", nil, nil},
            ["Chat Timestamps"]          = {true, "checkbox", nil, nil, "chat", 5, "Show time for each chat message", nil, nil},
            ["Enable Text Shadow"]       = {true, "checkbox", nil, nil, "chat", 6, "Add subtle shadow to chat text", nil, nil},
            ["Macro Icons"]              = {true, "checkbox", nil, nil, "macro", 7, "Use icons in macro list display", nil, nil},
            ["Macro Tweaks"]             = {true, "checkbox", nil, nil, "macro", 8, "Minor macro usability improvements added", nil, nil},
            ["Enable Raid Frames"]       = {true, "checkbox", nil, nil, "raid", 9, "Enable fully custom raid frame UI", nil, nil},
            ["Hide Party Frames"]        = {true, "checkbox", nil, nil, "raid", 10, "Hide the default party frames always", nil, nil},
            ["Show Dispel Indicators"]   = {true, "checkbox", nil, nil, "raid", 11, "Mark dispellable debuffs visually", nil, nil},
            ["Use As Party Frames"]      = {true, "checkbox", nil, nil, "raid", 12, "Show party members in raid layout", nil, nil},
            ["Show Group Headers"]       = {true, "checkbox", nil, nil, "raid", 13, "Display headers for each raid group", nil, nil},
            ["Show Healing Predictions"] = {true, "checkbox", nil, nil, "raid", 14, "Display incoming healing predictions", nil, nil},
            ["Show Combat Feedback"]     = {true, "checkbox", nil, nil, "raid", 15, "Show damage/healing feedback on bars", nil, nil},
            ["Show Aggro Indicators"]    = {true, "checkbox", nil, nil, "raid", 16, "Show who has aggro on raid frames", nil, nil},
            ["Use Compact Layout"]       = {true, "checkbox", nil, nil, "raid", 17, "Use tighter compact frame layout", nil, nil},
            -- ["Show Energy Ticks"]        = {true, "checkbox", nil, nil, "tweaks", 18, "Show energy ticks for the rogue or druid class", nil, nil},
            ["Reveal World Map"]         = {true, "checkbox", nil, nil, "worldmap", 19, "Remove fog of war on world map", nil, nil},
        }
    }
end

function Setup:ApplyShagu()
    if not DFRL.addon1 then return end

    if not self.fixed.shaguCore then
        self:ShaguCore()
        self:ShaguBagBorders()
        self:ShaguGUI()
        self.fixed.shaguCore = true
    end

    if DFRL.addon2 and not self.fixed.shaguExtras then
        self:ShaguExtras()
        self.fixed.shaguExtras = true
    end

    if not DFRL.gui.shaguCore then
        DFRL.gui.shaguCoreData = self:ShaguMetaData().core
        DFRL.gui.shaguCore = true
    end

    if DFRL.addon2 and not DFRL.gui.shaguExtras then
        DFRL.gui.shaguExtrasData = self:ShaguMetaData().extras
        DFRL.gui.shaguExtras = true
    end
end

--=================
-- MORE LATER
--=================

--=================
-- INIT
--=================

function Setup:HandleAddon(name)
    if name == "ShaguTweaks" and not (ShaguTweaks and ShaguTweaks.T and ShaguTweaks.mods) then
        return
    end

    local addonType = self.addons[name]
    if addonType == "shagu" then
        self:ApplyShagu()
    end

    self.processed[name] = true
end

function Setup:CheckComplete(f)
    for name, _ in pairs(self.addons) do
        if not self.processed[name] then
            return false
        end
    end
    f:UnregisterEvent("ADDON_LOADED")
    return true
end

function Setup:Init()
    DFRL:OnShaguReady(function()
        self:ApplyShagu()
        self.processed["ShaguTweaks"] = true
    end)

    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function()
        if event == "ADDON_LOADED" and arg1 == "ShaguTweaks-extras" then
            self:HandleAddon(arg1)
            self:CheckComplete(f)
        end
    end)
end

Setup:Init()
