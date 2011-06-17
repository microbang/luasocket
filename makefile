#--------------------------------------------------------------------------
# luasocket makefile
# Test executable for luasocket library
# Diego Nehab, 28/12/2000
#--------------------------------------------------------------------------

CC = gcc
WARNINGS = -Wall

# Uncomment this if you are using Lua-4.1-alpha
# FRIENDLY = -DLUASOCKET_41FRIENDLY

# Set LUAINC to the Lua include directory and LUALIB to the
# Lua library directory
LUA = /home/i/diego/public/lib/lua-4.0
LUAINC = $(LUA)/include
LUALIB = $(LUA)/lib/$(TEC_UNAME)

# SunOS and WinSock do not implement inet_aton. We provide ours.
# ATON = -DLUASOCKET_ATON

LIB = $(LUALIB)/liblualib.a $(LUALIB)/liblua.a -lm
# WinSock needs ws2_32.lib
# SunOS needs the following
# LIB = $(LUALIB)/liblualib.a $(LUALIB)/liblua.a -lm -lsocket -lnsl

# to run the test scripts uncomment this
TEST = -D_DEBUG

CFLAGS = $(WARNINGS) $(TEST) $(ATON) $(FRIENDLY) -O2

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
	rcsclean
	rm -f lua.o luasocket.o luasocket core a.out
