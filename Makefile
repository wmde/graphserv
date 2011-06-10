# on solaris, we need -lsocket for socket functions. check for libsocket.
ifneq ($(shell nm -DP /lib/libsocket.so* 2>/dev/null | grep -v UNDEF | grep '^accept[[:space:]]*'),)
	SOCKETLIB=-lsocket
else
	SOCKETLIB=
endif

CCFLAGS=-Wall -Igraphcore/src
LDFLAGS=-lcrypt $(SOCKETLIB)

all: 		Release Debug

Release:	graphserv
Debug:		graphserv.dbg

graphcore/graphcore:	graphcore/src/*
		make -C graphcore Release

graphcore/graphcore.dbg:	graphcore/src/*
		make -C graphcore Debug

graphserv:	src/main.cpp src/*.h graphcore/src/*.h graphcore/graphcore
		g++ $(CCFLAGS) -O3 -fexpensive-optimizations src/main.cpp $(LDFLAGS) -ographserv

graphserv.dbg:	src/main.cpp src/*.h graphcore/src/*.h graphcore/graphcore
		g++ $(CCFLAGS) -DDEBUG_COMMANDS -ggdb src/main.cpp $(LDFLAGS) -ographserv.dbg

# updatelang: update the language files
# running this will generate changes in the repository
updatelang:	#
		./update-lang.sh

# test:		Release Debug
# 		python test/talkback.py test/graphserv.tb ./graphserv

