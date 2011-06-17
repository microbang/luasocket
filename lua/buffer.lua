-----------------------------------------------------------------------------
-- Fast concatenation library
-- Author: Roberto Ierusalimschy
-- Date: 4/6/2001
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Creates a new concatenation buffer
-----------------------------------------------------------------------------
function buf_create()
    return { n = 0 }
end

-----------------------------------------------------------------------------
-- Adds a string to the concatenation buffer
-----------------------------------------------------------------------------
function buf_addstring(buf, s)
    tinsert(buf, s)
    for i = buf.n-1, 1, -1 do
        if strlen(buf[i]) > 2*strlen(buf[i+1]) then break end
        buf[i] = buf[i] .. tremove(buf)
    end
end

-----------------------------------------------------------------------------
-- Gets the result of all concatenated strings
-----------------------------------------------------------------------------
function buf_getresult(buf)
	if type(buf) ~= "table" then return nil end
    for i = buf.n-1, 1, -1 do
        buf[i] = buf[i] .. tremove(buf)
    end
    return buf[1]
end
