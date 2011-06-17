#include "io.h"
#include "error.h"

/*-------------------------------------------------------------------------*\
* Translate error codes to Lua
* Input
*   err: error code to be passed to Lua
\*-------------------------------------------------------------------------*/
void error_push(lua_State *L, int err)
{
    switch (err) {
        case IO_DONE:
            lua_pushnil(L);
            break;
        case IO_TIMEOUT:
            lua_pushstring(L, "timeout");
            break;
        case IO_LIMITED:
            lua_pushstring(L, "limited");
            break;
        case IO_CLOSED:
            lua_pushstring(L, "closed");
            break;
        case IO_REFUSED:
            lua_pushstring(L, "refused");
            break;
        default:
            lua_pushstring(L, "unknown error");
            break;
    }
}
