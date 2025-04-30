TMPDIR=tmp
OUTDIR=out

EN_MAINFILE=moz_rg-en.tex
JA_MAINFILE=moz_rg-ja.tex

EN_FILENAME=moz_rg-en
JA_FILENAME=moz_rg-ja

EN_PDFNAME=${EN_FILENAME}.pdf
JA_PDFNAME=${JA_FILENAME}.pdf

TEXLIVEIMAGE=texlive/texlive:TL2023-historic
DOCKER=docker run -v $(CURDIR):/work -w /work/tmp ${TEXLIVEIMAGE}


# PDFLATEX=platex
PDFLATEX=lualatex
BIBTEX=pbibtex
LATEXPAND=latexpand
LATEXDIFF=latexdiff

COMMITHASH=NULL

.PHONY: all pdf tmp clean diff

all: pdf

pdf: tmp
	cd ${TMPDIR} && ${PDFLATEX} ${EN_FILENAME}
	cd ${TMPDIR} && ${PDFLATEX} ${JA_FILENAME}
	cp ${TMPDIR}/${EN_PDFNAME} ${OUTDIR}/
	cp ${TMPDIR}/${JA_PDFNAME} ${OUTDIR}/
combine:
	cd ${OUTDIR} && pdftk ${EN_PDFNAME} ${JA_PDFNAME} cat output 0501-rg-joint-lecture_moz.pdf

tmp:
	mkdir -p ${TMPDIR}
	mkdir -p ${OUTDIR}
	cp -r figs ${TMPDIR}
	cp ${EN_MAINFILE} ${TMPDIR}
	cp ${JA_MAINFILE} ${TMPDIR}
	cp -r bib ${TMPDIR}


clean:
	rm -rf ${TMPDIR}/*