#--------------------------------------------------------------------------
# luasocket makefile
# Test executable for luasocket library
# Diego Nehab, 28/12/2001
#--------------------------------------------------------------------------

# luasocket needs an ANSI C compiler.
CC = gcc
WARNINGS = -Wall

CFLAGS = $(WARNINGS) -O2 
# or, to run the test scripts
# CFLAGS = $(WARNINGS) -O2 -D_DEBUG -D_DEBUG_BLOCK

# luasocket needs Lua 4.0. set LUA to your Lua-4.0 directory.
LUA = /home/i/diego/lib/lua
LUALIB = $(LUA)/lib
LUAINC = $(LUA)/include

INC = -I$(LUAINC)

LIB = $(LUALIB)/liblualib.a $(LUALIB)/liblua.a -lm
# Depending on your platform, you might need extra libraries
# SunOS
# LIB = $(LUALIB)/liblualib.a $(LUALIB)/liblua.a -lm -lsocket -lnsl

all: luasocket

luasocket: luasocket.o lua.o
	$(CC) $(CFLAGS) -o $@ lua.o luasocket.o $(LIB)

lua.o: lua.c luasocket.h
	$(CC) -c $(CFLAGS) $(INC) -o $@ lua.c

luasocket.o: luasocket.c luasocket.h
	$(CC) -c $(CFLAGS) $(INC) -o $@ luasocket.c

# clean all trash
clean:
	rm -f lua.o luasocket.o luasocket core a.out
