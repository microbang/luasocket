local _loadlib = loadlib

LUA_LIBNAME = LUA_LIBNAME or os.getenv("LUA_LIBNAME") or "?" 
LUA_FUNCNAME = LUA_FUNCNAME or os.getenv("LUA_FUNCNAME") or "?" 

function loadlib(...)
    if arg[1] then arg[1] = string.gsub(LUA_LIBNAME, "?", arg[1]) end
    if arg[2] then arg[2] = string.gsub(LUA_FUNCNAME, "?", arg[2]) end
    return _loadlib(unpack(arg))
end
