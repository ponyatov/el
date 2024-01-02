SHORTSIZE = 1080x1920
SHORTSFPS = 60

TXT = $(wildcard *.txt)
PNG = $(subst .txt,.png,$(TXT))

slides: $(PNG)

# https://imagemagick.org/Usage/text/
%.png: %.txt ../../Makefile
	convert \
		-background '#222222' -fill lightgreen \
		-font monospace -pointsize 24 \
		-size $(SHORTSIZE) \
			text:$< $@
