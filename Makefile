# var
MODULE  = $(notdir $(CURDIR))
module  = $(shell echo $(MODULE) | tr A-Z a-z)
OS      = $(shell uname -o|tr / _)
NOW     = $(shell date +%d%m%y)
REL     = $(shell git rev-parse --short=4 HEAD)
BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
CORES  ?= $(shell grep processor /proc/cpuinfo | wc -l)

# dirs
CWD = $(CURDIR)
BIN = $(CWD)/bin
DOC = $(CWD)/doc
SRC = $(CWD)/src
TMP = $(CWD)/tmp

# tool
CURL   = curl -L -o
CF     = clang-format
QUCS   = /usr/bin/qucs-s

# all
.PHONY: all
all:

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
gz: qucs

QUCS_URL = download.opensuse.org/repositories/home
QUCS_APT = /etc/apt/sources.list.d/home\:ra3xdh.list

.PHONY: qucs
qucs: $(QUCS)

$(QUCS): $(QUCS_APT)
	$(MAKE) $(QUCS_APT)

.PHONY: debian_10
debian_10: $(QUCS_APT)
$(QUCS_APT):
	echo 'deb  http://$(QUCS_URL):/ra3xdh/Debian_10/ /' | sudo tee $(QUCS_APT)
	curl -fsSL https://$(QUCS_URL):ra3xdh/Debian_10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_ra3xdh.gpg > /dev/null

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
