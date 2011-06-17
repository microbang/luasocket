--===========================================================================
-- Compatibility functions for CGILua 3.2
--===========================================================================
-----------------------------------------------------------------------------
-- Converts a comma separated list into a Lua table with one entry for each
-- list element.
-- Input
--   str: string containing the list to be converted
--   tab: table to be filled with entries
-- Returns
--   a table t, where t.n is the number of elements with an entry t[i] 
--   for each element
-----------------------------------------------------------------------------
local fill = function(str, tab)
    gsub(str, "([^%s,]+)", function (w) tinsert(%tab, w) end)
    return tab
end

-----------------------------------------------------------------------------
-- Client mail function, implementing CGILUA 3.2 interface
-----------------------------------------------------------------------------
function mail(cl)
	local message = {}
    message.headers = {}
    message.headers.subject = cl.subject
    message.headers.to = cl.to
    message.headers.from = cl.from
    message.rcpt = {}
    %fill(cl.to, message.rcpt)
    if cl.cc then 
        %fill(cl.cc, message.rcpt) 
        message.headers.cc = cl.cc
    end
    if cl.bcc then %fill(cl.bcc, message.rcpt) end
    message.rcpt.n = nil
	message.from = cl.from
    message.body = cl.message
    message.server = cl.mailserver
    return SMTP.mail(message)
end
