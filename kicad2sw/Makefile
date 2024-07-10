# src
F  = $(wildcard *.fs)
P ?= ../pcb/pwm/pwm.kicad_pcb

# all
.PHONY: all
all: $(F)
	dotnet run $(P)

# FSLEX  = dotnet $(shell find ~/.nuget ~/.dotnet -regex .+/fslex.dll )
# FSYACC = dotnet $(shell find ~/.nuget ~/.dotnet -regex .+/fsyacc.dll)
# Lexer.fs: Lexer.fsl
# 	$(FSLEX) -o $@ --module Lexer --unicode $<
# Parser.fs: Parser.fsy
# 	$(FSYACC) -o $@ --module Parser $<

# format
.PHONY: format
format: ../tmp/format_fs
../tmp/format_fs: $(F)
	fantomas $(F) && touch $@
