
---@diagnostic disable: deprecated

-- out of sight out of mind file

APP_IDENTITY = NAME
GFX_WIDTH = 320
GFX_HEIGHT = 180

-- don't really like this, but I also don't like the yellow blob next to the file in the project explorer.
table.unpack = unpack

function table.append(tbl, other)
    for k, v in pairs(other) do
        if not tbl[k] then
            tbl[k] = v
        end
    end

    return tbl
end

function table.map(tbl, func)
    local mapped = {}
    if tbl then
        for k, v in pairs(tbl) do
            local res = func(v)
            if res then
                mapped[k] = res
            end
        end
    end
    return mapped
end

function table.serialise(t, depth)
    assert(type(t) == "table", string.format("Can only serialise a table but got [%s]", type(t)))

    depth = depth or 0
    local indent = ""

    for i = 0, depth - 1 do
        indent = indent .. "\t"
    end

    if type(t) == "table" then
        local s = "{\n"
        for k, v in pairs(t) do
            local fmt = "%s\t%s = %s,\n"
            local val
            if type(v) == "number" or type(v) == "boolean" then
                val = tostring(v)
            elseif type(v) == "string" then
                val = "\"" .. v .. "\""
            elseif type(v)== "table" then
                val = table.serialise(v, depth + 1)
            end

            s = s .. string.format(fmt, indent, k, val)
        end
        s = s .. indent .. "}"
        return s
    end

end

function table.deep_copy(tbl)
    local result = {}

    if not tbl then return result end

    for k, v in pairs(tbl) do
        local val = v
        if type(v) == "table" then
            val = table.deep_copy(v)
        end
        result[k] = val
    end
    return result
end

function math.round(x)
    return math.floor(x + 0.5)
end

function math.lerp(a, b, x)
    return a + (b - a) * x
end

-- all the buttons we might support. Arranged as bitfields so we can pack them together
BTN_UP      =   0x0001
BTN_DOWN    =   0x0002
BTN_LEFT    =   0x0004
BTN_RIGHT   =   0x0008
BTN_A       =   0x0010
BTN_B       =   0x0020
BTN_X       =   0x0040
BTN_Y       =   0x0080
BTN_L1      =   0x0100
BTN_L2      =   0x0200
BTN_L3      =   0x0400
BTN_R1      =   0x0800
BTN_R2      =   0x1000
BTN_R3      =   0x2000
BTN_START   =   0x4000
BTN_SELECT  =   0x8000

