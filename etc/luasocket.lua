open, err1, err2 = loadlib("luasocket", "luaopen_socket")
if not open then error(err1) end
open()
if not LUASOCKET_LIBNAME then error("LuaSocket init failed") end
