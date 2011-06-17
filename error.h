#ifndef ERROR_H
#define ERROR_H

#include <lua.h>

void error_push(lua_State *L, int error);

#endif
