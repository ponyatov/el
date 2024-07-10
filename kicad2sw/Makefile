# src
F = $(wildcard *.fs)

# all
.PHONY: all
all: $(F)
	dotnet run

# Lexer.fs: Lexer.fsl
# 	dotnet ~/.nuget/packages/fslexyacc/11.3.0/build/fslex/net6.0/fslex.dll \
# 		-o $@ --module Lexer --unicode $<

# format
.PHONY: format
format: ../tmp/format_fs
../tmp/format_fs: $(F)
	fantomas $(F) && touch $@
