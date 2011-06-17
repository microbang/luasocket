#--------------------------------------------------------------------------
# luasocket makefile
# Test executable for luasocket library
# Diego Nehab, 28/12/2000
#--------------------------------------------------------------------------

CC = gcc
WARNINGS = -Wall

# luasocket needs Lua 4.0. set LUA to your Lua-4.0 directory.
LUA = /home/i/diego/public/lib/lua
LUALIB = $(LUA)/lib/$(TEC_UNAME)
LUAINC = $(LUA)/include

# SunOS and WinSock do not implement inet_aton. We provide ours.
# ATON = -DLUASOCKET_ATON

LIB = $(LUALIB)/liblualib.a $(LUALIB)/liblua.a -lm
# WinSock needs ws2_32.lib
# SunOS needs the following
# LIB = $(LUALIB)/liblualib.a $(LUALIB)/liblua.a -lm -lsocket -lnsl

# to run the test scripts uncomment this
# TEST = -D_DEBUG

CFLAGS = $(WARNINGS) $(TEST) $(ATON) -O2

INC = -I$(LUAINC)

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
