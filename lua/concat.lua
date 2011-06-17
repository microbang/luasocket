-----------------------------------------------------------------------------
-- Fast concatenation library
-- LuaSocket 1.4 toolkit.
-- Author: Roberto Ierusalimschy (typewriting by Diego Nehab ;^)
-- Date: 4/6/2001
-- Conformimg to: LTN7, LTN9
-- RCS ID: $Id: concat.lua,v 1.2 2001/09/12 18:27:17 diego Exp $
-----------------------------------------------------------------------------

local Private, Public = {}, {}
Concat = Public

-----------------------------------------------------------------------------
-- Creates a new concatenation object
-----------------------------------------------------------------------------
function Public.create()
	local concat = {
		addstring = %Private.addstring,
		getresult = %Private.getresult,
		reset = %Private.reset,
		stack = {n = 0}
	}
	return concat
end

-----------------------------------------------------------------------------
-- Adds a string to the concatenation stack
-- Obs: the 2*strlen is to make sure the number of strings stacked is
-- at most log(total bytes)
-----------------------------------------------------------------------------
function Private.addstring(concat, s)
	local stack = concat.stack
    tinsert(stack, s)
    for i = stack.n-1, 1, -1 do
        if strlen(stack[i]) > 2*strlen(stack[i+1]) then break end
        stack[i] = stack[i] .. tremove(stack)
    end
end

-----------------------------------------------------------------------------
-- Gets the result of the concatenation
-----------------------------------------------------------------------------
function Private.getresult(concat)
	local stack = concat.stack
    for i = stack.n-1, 1, -1 do
        stack[i] = stack[i] .. tremove(stack)
    end
    return stack[1]
end

-----------------------------------------------------------------------------
-- Resets the buffer
-----------------------------------------------------------------------------
function Private.reset(concat)
	local stack = concat.stack
	for i = 1, stack.n do
		stack[i] = nil
	end
	stack.n = 0
end
