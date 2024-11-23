--[[
---------------------------------------------------
    Copyright (C) wst.pub, All Rights Reserved.
---------------------------------------------------
]]


---@param s string string has redundant spaces
local function delete_spaces(s)
    local del = 0
    for i = 1, #s do
        if string.sub(s, -i, -i) == " " then
            del = del + 1
        else
            break
        end
    end
    return string.sub(s, 1, -del - 1)
end

---@param str string
---@return table
local function split(str)
    local t = {}
    for chunk in string.gmatch(str, "[^\n]+") do
        table.insert(t, chunk)
    end
    return t
end

local function parse_srt(srt_raw)

    local inBlock

    local last_line

    local last_index

    local parsed_srt = {}

    local next_line_to_be_processed = -1

    local srt_raw = split(srt_raw)

    for i = 1, #srt_raw do
        if i >= next_line_to_be_processed then
            if inBlock ~= true then
                local index = tonumber(srt_raw[i])
                if index then
                    inBlock = true
                    last_line = "index"
                    last_index = index
                    parsed_srt[index] = {}
                end
            else
                if last_line == "index" then
                    parsed_srt[last_index]["time"] = srt_raw[i]
                    last_line = "time"
                else
                    if last_line == "time" then
                        parsed_srt[last_index]["text"] = delete_spaces(srt_raw[i])
                        local skip = 1
                        local exit = false
                        repeat
                            local line = srt_raw[i + skip]
                            if line ~= nil and line ~= "" then
                                parsed_srt[last_index]["text"] = parsed_srt[last_index]["text"] .. " " .. delete_spaces(line)
                                skip = skip + 1
                            else
                                exit = true
                            end
                        until exit == true
                        next_line_to_be_processed = i + skip + 1
                        inBlock = false
                    end
                end
            end
        end
    end

    return parsed_srt, tonumber(srt_raw[1]), last_index

end

return parse_srt
