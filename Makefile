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
	wget https://dist.ipfs.io/go-ipfs/v0.4.6/go-ipfs_v0.4.6_linux-386.tar.gz -O/tmp/ipfs.tar.gz
	tar xzf /tmp/ipfs.tar.gz
	mv go-ipfs/ipfs .
	chmod +x ipfs
	./ipfs init

config:
	@./ngircd-eval "./configure --prefix=$(PREFIX) --with-openssl --enable-ipv6"

all:
	@./ngircd-eval "make -j4 all"

install:
	mkdir -p $(PREFIX)
	@./ngircd-eval "make install"
	cp -r ipfs-backend $(PREFIX)/ipfs-helper
	cp ipfs $(PREFIX)/ipfs-helper

start-all: start start-ipfs

start:
	$(PREFIX)/sbin/ngircd
	

ipfs:
	$(PREFIX)/ipfs-helper daemon --enable-pubsub-experiment
