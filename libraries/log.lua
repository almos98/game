local log = {}

log.colors = true
log.file = nil
log.redirectToFile = false
log.level = "trace"

local modes = {
    {name = "trace", color = "\27[34m"},
    {name = "debug", color = "\27[36m"},
    {name = "info",  color = "\27[32m"},
    {name = "warn",  color = "\27[33m"},
    {name = "error", color = "\27[31m"},
    {name = "fatal", color = "\27[35m"},
}

local levels = {}
for i, v in next, modes do
    levels[v.name] = i
end

function log.setLevel(d)
    log.level = modes[d].name
end

local seen = {}

-- Convert to string
local function toString(x, q)
    local q = q or false
    if type(x) == 'nil' then
        return "'nil'"
    elseif type(x) == 'boolean' then
        return x and "'true'" or "'false'"
    elseif type(x) == "number" then
        return string.format("%g", x)
    elseif type(x) == "string" then
        if q then
            return '"' .. x .. '"'
        end
        return x
    elseif type(x) == "function" then
        return tostring(x)
    elseif type(x) == "table" then
        if not tostring(x):match("^table: ") then
            return tostring(x)
        end

        local contents = {}
        if not seen[x] then
            seen[x] = true

            for i, v in next, x do
                local str = ""
                if type(i) ~= 'number' then
                    str = str .. toString(i) .. "="
                end
                local append = toString(v, true)
                if append then
                    str = str .. append
                end
                table.insert(contents, str)
            end
        end

        return "{" .. table.concat(contents, ", ") .. "}"
    end
end

-- Message from arguments
local function message(...)
    seen = {}
    local res = {}
    for i = 2, select('#', ...) do
        local x = select(i, ...)
        table.insert(res, toString(x))
    end
    return string.format(select(1, ...), unpack(res))
end

-- Defining the message functions
for i, mode in next, modes do
    log[mode.name] = function(...)
        -- Return early if below log level
        if i < levels[log.level] then
            return
        end

        local msg = message(...)

        local info = debug.getinfo(2, "Sl")
        local lineinfo = info.short_src .. ":" .. info.currentline

        -- Writing to terminal
        if not log.redirectToFile then
            print(("%s[%-6s%s]%s %s: %s"):format(
                log.colors and mode.color or "",
                mode.name:upper(),
                os.date("%H:%M:%S"),
                log.colors and "\27[0m" or "",
                lineinfo,
                msg
            ))
        end

        -- Writing to a file
        if log.file then
            local f = io.open(log.file, "a")
            
            f:write(("[%-6s%s] %s: %s\n"):format(
                mode.name:upper(),
                os.date(),
                lineinfo,
                msg
            ))
            f:close()
        end
    end
end

return log
