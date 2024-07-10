# src
F  = $(wildcard *.fs)
P ?= ../pcb/pwm/pwm.kicad_pcb

# all
.PHONY: all
all: $(F)
	dotnet run $(P)

# Lexer.fs: Lexer.fsl
# 	dotnet ~/.nuget/packages/fslexyacc/11.3.0/build/fslex/net6.0/fslex.dll \
# 		-o $@ --module Lexer --unicode $<
# Parser.fs: Parser.fsy
# 	dotnet ~/.nuget/packages/fslexyacc/11.3.0/build/fsyacc/net6.0/fsyacc.dll \
# 		-o $@ --module Parser $<

# format
.PHONY: format
format: ../tmp/format_fs
../tmp/format_fs: $(F)
	fantomas $(F) && touch $@
