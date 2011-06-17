-----------------------------------------------------------------------------
-- Fast concatenation library
-- LuaSocket toolkit.
-- Author: Roberto Ierusalimschy (typewriting by Diego Nehab ;^)
-- Conformimg to: LTN7 (Used to conform to LTN9, but table.concat is better)
-- RCS ID: $Id: concat.lua,v 1.9 2003/08/16 00:06:04 diego Exp $
-----------------------------------------------------------------------------

local Private, Public = { meta = { __index = {} } }, {}
socket.concat = Public

-----------------------------------------------------------------------------
-- Creates a new concatenation object
-----------------------------------------------------------------------------
function Public.create()
	local concat = { stack = {} }
    setmetatable(concat, Private.meta)
	return concat
end

-----------------------------------------------------------------------------
-- Adds a string to the concatenation stack
-----------------------------------------------------------------------------
function Private.meta.__index.addstring(concat, s)
    table.insert(concat.stack, s)
end

-----------------------------------------------------------------------------
-- Gets the result of the concatenation
-----------------------------------------------------------------------------
function Private.meta.__index.getresult(concat)
    local stack = concat.stack
    if table.getn(stack) < 1 then return nil end
    local s = table.concat(stack)
    concat:reset()
    return s
end

-----------------------------------------------------------------------------
-- Resets the buffer
-----------------------------------------------------------------------------
function Private.meta.__index.reset(concat)
    concat.stack = {}
end
