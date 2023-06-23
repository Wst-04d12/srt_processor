--[[
---------------------------------------------------
    Copyright (C) wst.pub, All Rights Reserved.
---------------------------------------------------
]]


local function get_input_file()
    local path = ""
    if #arg ~= 0 then
        for i = 1, #arg do
            path = path .. arg[i]
        end
    else
        print("drag your file that need to be processed down here")
        path = io.stdin:read("*l")
        --#region process path
        if string.sub(path, 1, 1) == "\"" then
            path = string.sub(path, 2, #path)
        end
        if string.sub(path, -1) == "\"" then
            path = string.sub(path, 1, #path - 1)
        end
        --#endregion
    end

    return (
        {
            xpcall(
                function()
                    local f = io.open(path, "r")
                    if type(f) == "userdata" then
                        print("please wait...")
                    else
                        error()
                    end
                    return f
                end,
                function(err)
                    print("check the file path you've input.")
                    os.execute("pause")
                    os.exit()
                end
            )
        }
    )[2]
end

local function txt_to_table(f)
    local rtnstr = {}
    local line_num = 1
    for line in f:lines() do
        table.insert(rtnstr, line_num, line)
        line_num = line_num + 1
    end
    f:close()
    return rtnstr
end

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

local function process_srt(srt_raw)

    local inBlock

    local last_line

    local last_index

    local parsed_srt = {}

    local next_line_to_be_processed = -1

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

local srt = txt_to_table(get_input_file())

local t0 <const> = os.clock()

local parsed_srt = {process_srt(srt)}

local dt <const> = os.clock() - t0

local out <close> = io.open("out.txt", "w+")

out:setvbuf("full")

for i = parsed_srt[2], parsed_srt[3] do
    out:write("\n\n\t\t" .. parsed_srt[1][i].text)
end

print(string.format("done!\nproc time: %.fms", dt * 1000))
