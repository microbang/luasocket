V=2.0

INSTALL_LUA=/usr/local/lua
INSTALL_LUASOCKET=$(INSTALL_LUA)/luasocket

LUAC=luac
BIN2C=bin2c
CC=gcc
OPT=-O2

OBJS= \
	luasocket.o \
	timeout.o \
	buffer.o \
	io.o \
	auxiliar.o \
	select.o \
	inet.o \
	tcp.o \
	udp.o \
	usocket.o 

LUAS= \
	select.lua \
	auxiliar.lua \
	concat.lua \
	code.lua \
	url.lua \
	http.lua \
	smtp.lua \
	ftp.lua 

LCHS= $(addsuffix .lch, $(basename $(LUAS)))
LCS= $(addsuffix .lc, $(basename $(LUAS)))

# Linux
CFLAGS=-O2 -Wall -DLUASOCKET_COMPILED -DLUASOCKET_DEBUG

DYN=libluasocket.so.$(V)
STA=libluasocket.a

$(STA): $(OBJS) makefile
	ar rcu $(STA) $(OBJS)
	ranlib $(STA)

dyn: $(DYN)

$(DYN): $(OBJS) makefile
	gcc -shared -o $(DYN) $(OBJS)

# dependencies
auxiliar.o: auxiliar.c auxiliar.h
buffer.o: buffer.c auxiliar.h buffer.h io.h timeout.h
inet.o: inet.c luasocket.h inet.h socket.h usocket.h
io.o: io.c io.h
luasocket.o: luasocket.c luasocket.h timeout.h buffer.h io.h socket.h \
  usocket.h inet.h tcp.h udp.h
usocket.o: usocket.c socket.h usocket.h
tcp.o: tcp.c luasocket.h auxiliar.h inet.h socket.h usocket.h \
  tcp.h buffer.h io.h timeout.h
timeout.o: timeout.c luasocket.h auxiliar.h timeout.h
udp.o: udp.c luasocket.h auxiliar.h inet.h socket.h usocket.h \
  udp.h timeout.h

luasocket.o: $(LCHS)
select.o: $(LCHS)

.SUFFIXES: .lua .lch .lc

.lua.lc:
	$(LUAC) -o $@ $<

.lc.lch:
	$(BIN2C) $< > $@

install:
	mkdir -p $(INSTALL_LUA)
	mkdir -p $(INSTALL_LUASOCKET)
	cp $(DYN) $(INSTALL_LUASOCKET)
	ln -f -s $(INSTALL_LUASOCKET)/$(DYN) $(INSTALL_LUASOCKET)/libluasocket.so
	cp luasocket.lua $(INSTALL_LUASOCKET)
	cp luasocket.h $(INSTALL_LUASOCKET)
	cp lua.lua $(INSTALL_LUA)

clean:
	rm -f $(OBJS)
	rm -f $(DYN)
	rm -f $(STA)
	rm -f luasocket
	rm -f $(LCS)
	rm -f $(LCHS)
