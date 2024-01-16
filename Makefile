# var
MODULE  = $(notdir $(CURDIR))
module  = $(shell echo $(MODULE) | tr A-Z a-z)
OS      = $(shell uname -o|tr / _)
NOW     = $(shell date +%d%m%y)
REL     = $(shell git rev-parse --short=4 HEAD)
BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
CORES  ?= $(shell grep processor /proc/cpuinfo | wc -l)

# version
QUCS_VER    = 2.1.0-1
RHVOICE_VER = 1.8.0

# dirs
CWD = $(CURDIR)
BIN = $(CWD)/bin
DOC = $(CWD)/doc
SRC = $(CWD)/src
TMP = $(CWD)/tmp
GZ  = $(HOME)/gz

# tool
CURL   = curl -L -o
CF     = clang-format
QUCS   = /usr/bin/qucs-s

# all
.PHONY: all
all:

# clean
.PHONY: clean
clean:
	find pcb -type f -regex '.+.ses$$'        -exec rm -rf {} \; &
	find pcb -type f -regex '.+.dsn$$'        -exec rm -rf {} \; &
	find pcb -type d -regex '.+backup.*'      -exec rm -rf {} \; &
	find pcb -type d -regex '.+/autoroute_.+' -exec rm -rf {} \; &
	find pcb -type d -regex '.+/topor$$'      -exec rm -rf {} \; &

# slides
slides:
#	cd shorts/00_hello/txt ; make -f ../../Makefile
	cd shorts/01_carrier/txt ; make -f ../../Makefile

# format
.PHONY: format
format:

# doc
.PHONY: doc
doc:

# install
.PHONY:  install update updev
install: $(OS)_install doc gz
		 $(MAKE) update
update:  $(OS)_update
updev:   update $(OS)_updev

DEBIAN_VER  = $(shell lsb_release -rs)
DEBIAN_NAME = $(shell lsb_release -cs)

.PHONY: GNU_Linux_install GNU_Linux_update GNU_Linux_updev
GNU_Linux_install:
GNU_Linux_update:
ifneq (,$(shell which apt))
	sudo apt update
	sudo apt install -u `cat apt.txt apt.$(DEBIAN_NAME)`
endif
GNU_Linux_updev:
	sudo apt install -yu `cat apt.dev`

# package
.PHONY: gz
gz: qucs rhvoice

QUCS_URL = download.opensuse.org/repositories/home
QUCS_APT = /etc/apt/sources.list.d/home_ra3xdh.list
QUCS_DEB = Debian_11
QUCS_GPG = /etc/apt/trusted.gpg.d/home_ra3xdh.gpg

.PHONY: qucs
qucs: $(QUCS)

$(QUCS): $(GZ)/qucs-s_$(QUCS_VER)_amd64.deb
	sudo dpkg -i $< && sudo touch $@

$(GZ)/qucs-s_$(QUCS_VER)_amd64.deb:
	$(CURL) $@ https://download.opensuse.org/repositories/home:/ra3xdh/Debian_11/amd64/qucs-s_$(QUCS_VER)_amd64.deb

.PHONY: rhvoice
rhvoice: $(GZ)/rhvoice-$(RHVOICE_VER).tar.gz

$(GZ)/rhvoice-$(RHVOICE_VER).tar.gz:
	$(CURL) $@ https://github.com/RHVoice/RHVoice/releases/download/$(RHVOICE_VER)/rhvoice-$(RHVOICE_VER).tar.gz

# merge
MERGE += README.md Makefile .gitignore .doxygen apt.txt apt.dev LICENSE $(S)
MERGE += .vscode bin doc lib inc src tmp

.PHONY: dev
dev:
	git push -v
	git checkout $@
	git pull -v
	git checkout shadow -- $(MERGE)

.PHONY: shadow
shadow:
	git push -v
	git checkout $@
	git pull -v

.PHONY: release
release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	$(MAKE) shadow

.PHONY: zip
zip:
	git archive \
		--format zip \
		--output $(TMP)/$(MODULE)_$(NOW)_$(REL).src.zip \
	HEAD
