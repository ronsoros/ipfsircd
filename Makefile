PREFIX = $(PWD)/run
help:
	@echo "IPFSIRCd Makefile 1.0"
	@echo "Usage: make [all|install PREFIX=$(PREFIX)]"
	@echo " get-ipfs : Retrieve IPFS Binary"
	@echo " install  : Install this."
	@echo " config   : Configure the Next Generation(R) IRCd Server"
	@echo " start    : Start the server"
	@echo " start-all: Start IPFS and the server"
	@echo " start-ipfs Start IPFS"
	@echo " config   : Run the Next Generation(R) IRCd Server Script"
	@echo " genssl   : SSL is required by the IRCd (and OpenSSL)"
	@echo " Sample   : make all install genssl"
	@echo " Info     : The sample command will do what most people want"
	@echo "Makefile-Manual Pages:"
	@grep 'man-.*:' Makefile | grep -v 'grep' | sed 's/:.*//g'
	@echo "For more information do make man-TOPIC"

man-get-ipfs: man-notfound
man-install: man-notfound
man-config: man-notfound
man-readme: 
	cat README

man-notfound:
	@echo "No such manual page."
get-ipfs:
	@echo "Getting IPFS for Linux"
	@echo "Using another platform? Download ipfs manually"
	@echo "Linux32 IPFS Static Binary:"
	wget -4 https://dist.ipfs.io/go-ipfs/v0.4.6/go-ipfs_v0.4.6_linux-386.tar.gz -O/tmp/ipfs.tar.gz
	tar xzf /tmp/ipfs.tar.gz
	mv go-ipfs/ipfs .
	chmod +x ipfs
	./ipfs init

config:
	@./ngircd-eval "./autogen.sh"
	@./ngircd-eval "./configure --prefix=$(PREFIX) --with-openssl --enable-ipv6"

all: config
	@./ngircd-eval "make -j4 all"

install:
	mkdir -p $(PREFIX)
	@./ngircd-eval "make install"
	mkdir -p $(PREFIX)/ipfs-helper
	cp -r ipfs-backend/* $(PREFIX)/ipfs-helper
	-cp ipfs $(PREFIX)/ipfs-helper
	-ln -s $(PREFIX)/etc $(PREFIX)/etc/ssl

start-all: start start-ipfs
daemonize: daemonize.c
	mkdir -p $(PREFIX)
	$(CC) daemonize.c -o $(PREFIX)/daemonize

start: daemonize
	$(PREFIX)/sbin/ngircd
	$(PREFIX)/daemonize "lua $(PREFIX)/ipfs-helper/backend.lua"

start-ipfs: daemonize
	$(PREFIX)/daemonize "$(PREFIX)/ipfs-helper/ipfs daemon --enable-pubsub-experiment"

genssl:
	openssl dhparam -dsaparam -out $(PREFIX)/etc/dhparam.pem 2048
	openssl req -x509 -newkey rsa:4096 -keyout $(PREFIX)/etc/server.key -out $(PREFIX)/etc/server.crt -days 3650 -nodes
