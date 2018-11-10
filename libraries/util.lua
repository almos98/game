local util = {}

function util.recursiveEnumerate(folder, file_list)
    local file_list = file_list or {}
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        local fileInfo = love.filesystem.getInfo(file)
        if (fileInfo.type == "file") then
            table.insert(file_list, file)
        elseif (fileInfo.type == "directory") then
            recursiveEnumerate(file, file_list)
        end
    end

    return file_list
end

function util.requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        _G[file:match("/.+"):sub(2)] = require(file)
    end
end

function util.random(x, y)
    local random = love and love.math.random or math.random
    if y then
        local max = math.max(x,y)
        local min = math.min(x,y)
        return random()*(max-min)+min
    end

    -- One argument
    if x then
        return random() * x
    end

    return random()
end

function util.distance(x1, y1, x2, y2)
    return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end

function util.toString(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result.."[\""..k.."\"]".."="
        end

        -- Check the value type
        if type(v) == "table" then
            result = result..util.toString(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
        else
            result = result.."\""..v.."\""
        end
        result = result..","
    end
    -- Remove leading commas from the result
    if result ~= "" then
        result = result:sub(1, result:len()-1)
    end
    return result.."}"
end
-----------
return util