-----------------------------------------------------------------------------
-- LuaSocket helper module
-- Author: Diego Nehab
-- RCS ID: $Id: auxiliar.lua,v 1.2 2003/06/26 18:47:44 diego Exp $
-----------------------------------------------------------------------------
function socket.connect(...)
    local sock, err = socket.tcp()
    if not sock then return nil, err end
    local res, err = sock:connect(unpack(arg))
    if not res then return nil, err end
    return sock
end

function socket.bind(...)
    local sock, err = socket.tcp()
    if not sock then return nil, err end
    local res, err = sock:bind(unpack(arg))
    if not res then return nil, err end
    return sock
end
