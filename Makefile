# var
MODULE  = $(notdir $(CURDIR))
NOW     = $(shell date +%d%m%y)
REL     = $(shell git rev-parse --short=4 HEAD)
BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
CORES  ?= $(shell grep processor /proc/cpuinfo | wc -l)

# config
HW = microbit
include   hw/$(HW).mk
include  cpu/$(CPU).mk
include arch/$(ARCH).mk

# dirs
CWD = $(CURDIR)
BIN = $(CWD)/bin
DOC = $(CWD)/doc
SRC = $(CWD)/src
TMP = $(CWD)/tmp
GZ  = $(HOME)/gz
CAR = $(HOME)/.cargo

# tool
CURL   = curl -L -o
CF     = clang-format -style=file -i
CC     = $(TARGET)-gcc
CXX    = $(TARGET)-g++
AS     = $(TARGET)-as
LD     = $(TARGET)-ld
OD     = $(TARGET)-objdump
RUSTUP = $(CAR)/bin/rustup
CARGO  = $(CAR)/bin/cargo
QUCS   = /usr/bin/qucs-s

# src
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)
R += $(wildcard src/*.rs)
A += $(wildcard src/*.S)
A += $(wildcard src/hw/*.S)
A += $(wildcard src/cpu/*.S)
A += $(wildcard src/arch/*.S)

OBJ += $(subst src/,tmp/,$(addsuffix .o,$(basename $(A))))

# cfg
LDSCRIPT = hw/$(HW).lds
LDFLAGS += -T $(LDSCRIPT)

# all
.PHONY: all run
all: bin/$(MODULE).hex
run: 
# bin/$(MODULE).hex
	echo $(OBJ)
# $(QEMU) $(QEMU_CFG) -device loader,file=test.hex

.PHONY: format
format:

# rule
bin/$(MODULE).hex: $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $(OBJ)

tmp/%.o: src/%.S
	$(AS) -o $@ -c $<
tmp/%.o: src/arch/%.S
	$(AS) -o $@ -c $<
tmp/%.o: src/cpu/%.S
	$(AS) -o $@ -c $<
tmp/%.o: src/hw/%.S
	$(AS) -o $@ -c $<

# doc
.PHONY: doc
doc:

# install
.PHONY: install update ref gz
install: doc ref gz $(QUCS)
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
ref:
gz:

$(QUCS): \
	/etc/apt/sources.list.d/ra3xdh.list \
	/etc/apt/trusted.gpg.d/ra3xdh.gpg

/etc/apt/sources.list.d/ra3xdh.list:
	echo 'deb http://download.opensuse.org/repositories/home:/ra3xdh/Debian_12/ /' | sudo tee $@
/etc/apt/trusted.gpg.d/ra3xdh.gpg:
	curl -fsSL https://download.opensuse.org/repositories/home:ra3xdh/Debian_12/Release.key | gpg --dearmor | sudo tee $@
