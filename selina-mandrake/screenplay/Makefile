FILES = Makefile $(DOCS_SCREENPLAY_XHTML) \
		$(DOCS_SCREENPLAY_TEXT) $(DOCS_SCREENPLAY_DB5) \
		$(ENG_EPUB) $(ENG_DB_PROCESSED) $(ENG_DB_SOURCE) $(ENG_XHTML) \
		style.css style-heb.css \
		README.html

# The-Enemy-English.xhtml \

DOCS_BASE = selina-mandrake-the-slayer

DOCS_SCREENPLAY_TEXT = $(patsubst %,%.screenplay-text.txt,$(DOCS_BASE))
DOCS_SCREENPLAY_XML = $(patsubst %,%.screenplay-xml.xml,$(DOCS_BASE))
DOCS_SCREENPLAY_DB5 = $(patsubst %,%.db5.xml,$(DOCS_BASE))
DOCS_SCREENPLAY_XHTML = $(patsubst %,%.screenplay-text.xhtml,$(DOCS_BASE))
DOCS_SCREENPLAY_FO = $(patsubst %,%.screenplay-text.fo,$(DOCS_BASE))
DOCS_SCREENPLAY_RTF = $(patsubst %,%.screenplay-text.rtf,$(DOCS_BASE))
DOCS_SCREENPLAY_ODT = $(patsubst %,%.odt,$(DOCS_BASE))

DOCBOOK5_XSL_STYLESHEETS_PATH := $(HOME)/Download/unpack/file/docbook/docbook-xsl-ns-snapshot

HOMEPAGE := $(HOME)/Docs/homepage/homepage/trunk
DOCBOOK5_XSL_STYLESHEETS_XHTML_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/xhtml
DOCBOOK5_XSL_STYLESHEETS_FO_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/fo
DOCBOOK5_XSL_CUSTOM_XSLT_STYLESHEET := $(HOMEPAGE)/lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-xhtml-onechunk.xsl
DOCBOOK5_XSL_CUSTOM_FO_XSLT_STYLESHEET := $(HOMEPAGE)/lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-fo.xsl

ENG_DB_DIR = English-Docbook

ENG_EPUB = $(ENG_DB_DIR)/The-Enemy-English.epub
ENG_XHTML = $(ENG_DB_DIR)/The-Enemy-English.xhtml

all: $(DOCS_SCREENPLAY_XHTML) $(ENG_EPUB) $(ENG_XHTML) $(ENG_HTML_FOR_OOO)

odt: $(DOCS_SCREENPLAY_ODT)

upload:
	rsync -v --progress -a $(FILES) $${HOMEPAGE_SSH_PATH}/$(THE_ENEMY_DEST)/

$(DOCS_SCREENPLAY_DB5): %.db5.xml: %.screenplay-xml.xml
	perl -MXML::Grammar::Screenplay::App::ToDocBook -e 'run()' -- \
		-o $@ $<

$(DOCS_SCREENPLAY_XML): %.screenplay-xml.xml: %.screenplay-text.txt
	perl -MXML::Grammar::Screenplay::App::FromProto -e 'run()' -- \
	-o $@ $<

$(DOCS_SCREENPLAY_XHTML): %.screenplay-text.xhtml: %.db5.xml
	xsltproc --stringparam root.filename $@ \
		--stringparam html.stylesheet "style-heb.css" \
		--path $(DOCBOOK5_XSL_STYLESHEETS_XHTML_PATH) \
		-o $@ \
		$(DOCBOOK5_XSL_CUSTOM_XSLT_STYLESHEET) $<
	mv -f $@.html $@

$(DOCS_SCREENPLAY_FO): %.screenplay-text.fo : %.db5.xml
	xsltproc --stringparam root.filename $@ \
		--stringparam html.stylesheet "style-heb.css" \
		--path $(DOCBOOK5_XSL_STYLESHEETS_FO_PATH) \
		-o $@ \
		$(DOCBOOK5_XSL_CUSTOM_FO_XSLT_STYLESHEET) $<

$(DOCS_SCREENPLAY_RTF): %.rtf: %.fo
	fop -fo $< -rtf $@

rtf: $(DOCS_SCREENPLAY_RTF)

$(DOCS_SCREENPLAY_ODT): $(DOCS_SCREENPLAY_DB5)
	docbook2odf $< -o $@

ENG_DB_PROCESSED = $(ENG_DB_DIR)/PROCESSED_The-Enemy-English.db5.xml
ENG_DB_XSLT = $(ENG_DB_DIR)/docbook-epub-preproc.xslt
ENG_DB_SOURCE = $(ENG_DB_DIR)/The-Enemy-English.db5.xml
ENG_HTML_FOR_OOO = $(ENG_DB_DIR)/The-Enemy-English.for-openoffice.html
HEB_HTML_FOR_OOO = The-Enemy-Hebrew.for-openoffice.html

$(ENG_DB_PROCESSED) : $(ENG_DB_XSLT) $(ENG_DB_SOURCE)
	xsltproc --output $@ $(ENG_DB_XSLT) $(ENG_DB_SOURCE)

# DOCBOOK_RNG = http://www.docbook.org/xml/5.0/rng/docbook.rng

DOCBOOK_RNG = ./rng/docbook.rng

# XSL_SNAPSHOT_HOME = $(HOME)/Download/unpack/file/docbook/docbook-xsl-ns-snapshot
XSL_SNAPSHOT_HOME = $(HOME)/Download/unpack/file/docbook/docbook-xsl-snapshot/

EPUB_SCRIPT = $(XSL_SNAPSHOT_HOME)/epub/bin/dbtoepub

$(ENG_EPUB) : $(ENG_DB_PROCESSED)
	ruby $(EPUB_SCRIPT) -o $@ $<

$(ENG_XHTML) : $(ENG_DB_PROCESSED)
	xsltproc --stringparam root.filename $@ --path $(DOCBOOK5_XSL_STYLESHEETS_XHTML_PATH) -o $@ $(DOCBOOK5_XSL_CUSTOM_XSLT_STYLESHEET) $<
	mv -f English-Docbook/English-Docbook/The-Enemy-English.xhtml.html $@

$(ENG_HTML_FOR_OOO): $(ENG_XHTML)
	cat $< | perl -lne 'print unless m{\A<\?xml}' > $@

$(HEB_HTML_FOR_OOO): $(DOCS_SCREENPLAY_XHTML)
	cat $< | perl -lne 's{(</title>)}{$${1}<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />}; print unless m{\A<\?xml}' > $@

oohtml: $(ENG_HTML_FOR_OOO) $(HEB_HTML_FOR_OOO)

openoffice: oohtml
	ooffice3.2 $(ENG_HTML_FOR_OOO)

.PHONY: epub_ff

epub: $(ENG_EPUB)

epub_ff: epub
	firefox $(ENG_EPUB)

%.show:
	@echo "$* = $($*)"

