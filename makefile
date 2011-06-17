#--------------------------------------------------------------------------
# luasocket makefile
# Test executable for luasocket library
# Diego Nehab, 28/12/2000
#--------------------------------------------------------------------------

CC = gcc
WARNINGS = -Wall

# Set LUAINC to the Lua include directory and LUALIB to the
# Lua library directory

# SunOS and WinSock do not implement inet_aton. We provide ours.
# ATON = -DLUASOCKET_ATON

LIB = $(LUALIB)/liblualib.a $(LUALIB)/liblua.a -lm
# WinSock needs ws2_32.lib
# SunOS needs the following
# LIB = $(LUALIB)/liblualib.a $(LUALIB)/liblua.a -lm -lsocket -lnsl

# to run the test scripts uncomment this
TEST = -D_DEBUG

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
	rcsclean
	rm -f lua.o luasocket.o luasocket core a.out
