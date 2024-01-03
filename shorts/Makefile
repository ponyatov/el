SHORTSIZE = 1080x1920
SHORTSFPS = 60

LATEX = pdflatex -halt-on-error

TXT  = $(wildcard *.txt)
PNG += $(subst .txt,.png,$(TXT))
TEX  = $(wildcard *.tex)
PNG += $(subst .tex,.png,$(TEX))
# PDF += $(subst .tex,.pdf,$(TEX))

slides: $(PNG) $(PDF)

# https://imagemagick.org/Usage/text/
%.png: %.txt ../../Makefile
	convert \
		-background '#222222' -fill lightgreen \
		-font monospace -pointsize 24 \
		-size $(SHORTSIZE) \
			text:$< $@

%.png: %.pdf
	pdftoppm $< $@ -png

%.pdf: %.tex ../../Makefile
	$(LATEX) $<
