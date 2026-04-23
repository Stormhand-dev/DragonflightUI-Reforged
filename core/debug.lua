-- debug system
DFRL.debug.enabled = false
DFRL.debug.maxEntries = 250
DFRL.debug.buffer = {}
DFRL.debug.categories = {
    callback = true,
    profile = true,
    bars = true,
    db = true,
    gui = true
}

local function dbg_tostring(value)
    if value == nil then return 'nil' end
    local kind = type(value)
    if kind == 'boolean' then
        return value and 'true' or 'false'
    elseif kind == 'number' then
        return string.format('%.3f', value)
    elseif kind == 'string' then
        return value
    elseif kind == 'table' then
        return '<table>'
    elseif kind == 'function' then
        return '<function>'
    end
    return tostring(value)
end

local function dbg_echo(msg)
    if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
        DEFAULT_CHAT_FRAME:AddMessage('|cff33ff99DFRL DEBUG:|r ' .. msg)
    end
end

function DFRL:DebugStatusText()
    local state = self.debug.enabled and 'ON' or 'OFF'
    return 'debug=' .. state .. ', entries=' .. table.getn(self.debug.buffer)
end

function DFRL:SetDebugEnabled(enabled)
    self.debug.enabled = enabled and true or false
    if not DFRL_DB_SETUP then DFRL_DB_SETUP = {} end
    DFRL_DB_SETUP.debugEnabled = self.debug.enabled
    dbg_echo(self:DebugStatusText())
end

function DFRL:SetDebugCategory(category, enabled)
    if not category or category == '' then return end
    self.debug.categories[category] = enabled and true or false
    dbg_echo(category .. '=' .. (enabled and 'ON' or 'OFF'))
end

function DFRL:ClearDebugLog()
    self.debug.buffer = {}
    dbg_echo('buffer cleared')
end

function DFRL:DumpDebugLog(limit, category)
    local total = table.getn(self.debug.buffer)
    if total == 0 then
        dbg_echo('buffer empty')
        return
    end

    local count = tonumber(limit) or 20
    if count < 1 then count = 1 end
    if count > total then count = total end

    local startIndex = total - count + 1
    for i = startIndex, total do
        local entry = self.debug.buffer[i]
        if not category or category == '' or entry.category == category then
            dbg_echo(string.format('#%d [%s] %s', i, entry.category, entry.message))
        end
    end
end

function DFRL:DebugLog(category, ...)
    category = category or 'misc'
    if self.debug.categories[category] == false then
        return
    end

    local parts = {}
    for i = 1, select('#', ...) do
        parts[i] = dbg_tostring(select(i, ...))
    end

    local message = table.concat(parts, ' | ')
    local stamp = date('%H:%M:%S')
    local entry = {
        time = stamp,
        category = category,
        message = stamp .. ' | ' .. message
    }

    tinsert(self.debug.buffer, entry)
    while table.getn(self.debug.buffer) > self.debug.maxEntries do
        tremove(self.debug.buffer, 1)
    end

    if self.debug.enabled then
        dbg_echo('[' .. category .. '] ' .. entry.message)
    end
end

local function handle_debug_command(msg)
    local _, _, command, arg1, arg2 = string.find(msg or '', '^(%S*)%s*(%S*)%s*(.-)$')
    command = string.lower(command or '')

    if command == '' or command == 'help' then
        dbg_echo('/dfrldebug on | off | status | clear')
        dbg_echo('/dfrldebug dump [count] [category]')
        dbg_echo('/dfrldebug cat <callback|profile|bars|db|gui> <on|off>')
        return
    elseif command == 'on' then
        DFRL:SetDebugEnabled(true)
    elseif command == 'off' then
        DFRL:SetDebugEnabled(false)
    elseif command == 'status' then
        dbg_echo(DFRL:DebugStatusText())
    elseif command == 'clear' then
        DFRL:ClearDebugLog()
    elseif command == 'dump' then
        DFRL:DumpDebugLog(arg1, arg2)
    elseif command == 'cat' then
        DFRL:SetDebugCategory(arg1, string.lower(arg2 or '') == 'on')
    else
        dbg_echo('unknown command: ' .. command)
    end
end

_G['SLASH_DFRLDEBUG1'] = '/dfrldebug'
_G['SLASH_DFRLDEBUG2'] = '/dfdebug'
_G.SlashCmdList['DFRLDEBUG'] = handle_debug_command

local debugBootstrap = CreateFrame('Frame')
debugBootstrap:RegisterEvent('PLAYER_LOGIN')
debugBootstrap:SetScript('OnEvent', function()
    if DFRL_DB_SETUP and DFRL_DB_SETUP.debugEnabled then
        DFRL.debug.enabled = true
        dbg_echo(DFRL:DebugStatusText())
    end
    DFRL:DebugLog('gui', 'Debug system ready')
end)
