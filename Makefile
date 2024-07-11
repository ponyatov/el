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

# version
QUCS_VER = 24.2.1
FLATCAM_VER = 8.5

# dirs
CWD = $(CURDIR)
BIN = $(CWD)/bin
DOC = $(CWD)/doc
SRC = $(CWD)/src
TMP = $(CWD)/tmp
GZ  = $(HOME)/gz
CAR = $(HOME)/.cargo
DISTR  = $(HOME)/distr

# tool
CURL   = curl -L -o
CF     = clang-format -style=file -i
REF    = git clone --depth 1
CC     = $(TARGET)-gcc
CXX    = $(TARGET)-g++
AS     = $(TARGET)-as
LD     = $(TARGET)-ld
OD     = $(TARGET)-objdump
OCP    = $(TARGET)-objcopy
RUSTUP = $(CAR)/bin/rustup
CARGO  = $(CAR)/bin/cargo
QUCS   = /usr/bin/qucs-s

# package
.PHONY: qucs
qucs: $(QUCS)
QUCS_DEB = qucs-s_$(QUCS_VER)-1_amd64.deb
$(QUCS): $(DISTR)/CAD/EDA/$(QUCS_DEB)
	sudo dpkg -i $< && sudo touch $@

FLATCAM_EXE = FlatCAM-Win32-$(FLATCAM_VER)-Install.exe
FLATCAM     = FlatCAM-$(FLATCAM_VER)
FLATCAM_GZ  = $(FLATCAM).zip
.PHONY: flatcam
flatcam: $(DISTR)/CAD/EDA/$(FLATCAM_EXE) $(GZ)/$(FLATCAM_GZ)

# src
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)
R += $(wildcard src/*.rs)
A += $(wildcard src/*.S)
A += $(wildcard src/hw/*.S)
A += $(wildcard src/cpu/*.S)
A += $(wildcard src/arch/*.S)

OBJ += $(shell echo $(addsuffix .o,$(basename $(A))) | bin/objpath )
OBJ = $(shell echo $(A)|bin/objpath)

# cfg
LDSCRIPT = hw/$(HW).lds
LDFLAGS += -T $(LDSCRIPT)
FLAGS   += -g
ASFLAGS += $(FLAGS)

# all
.PHONY: all run
all: bin/$(MODULE).hex tmp/$(MODULE).objdump
run: bin/$(MODULE).hex
	$(QEMU) $(QEMU_CFG) -device loader,file=$< 
# -S -s &
# gdb-multiarch -x .gdbinit tmp/$(MODULE).o

.PHONY: format
format:

# rule
bin/$(MODULE).hex: tmp/$(MODULE).o
	$(OCP) -O ihex $< $@ && file $@
tmp/$(MODULE).o: bin/objpath $(LDSCRIPT) $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $(OBJ)

tmp/%.o: src/%.S
	$(AS) $(ASFLAGS) -o $@ -c $<
tmp/%.o: src/arch/%.S
	$(AS) $(ASFLAGS) -o $@ -c $<
tmp/%.o: src/cpu/%.S
	$(AS) $(ASFLAGS) -o $@ -c $<
tmp/%.o: src/hw/%.S
	$(AS) $(ASFLAGS) -o $@ -c $<

tmp/%.objdump: tmp/%.o
	$(OD) -D $< > $@

bin/objpath: src/objpath.lex
	flex -o tmp/objpath.c $< && gcc -o $@ tmp/objpath.c

# doc
.PHONY: doc
doc: doc/qucs/getstarted.pdf

doc/qucs/getstarted.pdf:
	$(CURL) $@ https://qucs.github.io/docs/tutorial/getstarted.pdf

# install
.PHONY: install update ref gz
install: doc ref gz $(QUCS) bin/objpath
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
ref: \
	ref/STM32_open_pin_data/README.md ref/stm32-svd/README.md
gz: \
	$(QUCS_DEB) flatcam

$(QUCS): \
	/etc/apt/sources.list.d/ra3xdh.list \
	/etc/apt/trusted.gpg.d/ra3xdh.gpg

$(DISTR)/CAD/EDA/$(QUCS_DEB):
	$(CURL) $@ http://ftp.lysator.liu.se/pub/opensuse/repositories/home%3A/ra3xdh/Debian_12/amd64/$(QUCS_DEB)

/etc/apt/sources.list.d/ra3xdh.list:
	echo 'deb http://download.opensuse.org/repositories/home:/ra3xdh/Debian_12/ /' | sudo tee $@
/etc/apt/trusted.gpg.d/ra3xdh.gpg:
	curl -fsSL https://download.opensuse.org/repositories/home:ra3xdh/Debian_12/Release.key | gpg --dearmor | sudo tee $@


ref/STM32_open_pin_data/README.md:
	$(REF) https://github.com/STMicroelectronics/STM32_open_pin_data.git ref/STM32_open_pin_data
ref/stm32-svd/README.md:
	$(REF) https://github.com/ponyatov/stm32-svd ref/stm32-svd

$(DISTR)/CAD/EDA/$(FLATCAM_EXE):
	$(CURL) $@ https://bitbucket.org/jpcgt/flatcam/downloads/$(FLATCAM_EXE)
$(GZ)/$(FLATCAM_GZ):
	$(CURL) $@ https://bitbucket.org/jpcgt/flatcam/downloads/$(FLATCAM_GZ)
