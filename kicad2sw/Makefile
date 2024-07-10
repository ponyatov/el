# src
F = $(wildcard *.fs)

# all
.PHONY: all
all: $(F)
	dotnet run

# format
.PHONY: format
format: ../tmp/format_fs
../tmp/format_fs: $(F)
	fantomas $(F) && touch $@
