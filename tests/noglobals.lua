local G = _G
local set = rawset
local warn = print

local setglobal = function(table, key, value)
	warn("changed " .. key)
    set(table, key, value)
end

setmetatable(G, {
    __newindex = setglobal
})
