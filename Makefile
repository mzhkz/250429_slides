TMPDIR=tmp
OUTDIR=out

MAINFILE=moz_rg-en.tex

FILENAME=moz_rg-en
PDFNAME=${FILENAME}.pdf

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
	cd ${TMPDIR} && ${PDFLATEX} ${FILENAME}
	# cd ${TMPDIR} && ${BIBTEX} ${FILENAME} 
	# cd ${TMPDIR} && ${PDFLATEX} ${FILENAME} 
	# cd ${TMPDIR} && ${PDFLATEX} ${FILENAME}
	cp ${TMPDIR}/${PDFNAME} ${OUTDIR}/

tmp:
	mkdir -p ${TMPDIR}
	mkdir -p ${OUTDIR}
	cp -r figs ${TMPDIR}
	cp ${MAINFILE} ${TMPDIR}
	cp -r bib ${TMPDIR}


diff: tmp
	cd ${TMPDIR} && latexdiff-vc -e utf8 --git --flatten --force -r ${COMMITHASH} ${FILENAME}.tex
	cd ${TMPDIR} && gsed -i 's/\\providecommand{\\DIFadd}\[1\]{{\\protect\\color{blue}\\uwave{#1}}} %DIF PREAMBLE/\\providecommand{\\DIFadd}[1]{{\\protect\\color{blue}#1}} %DIF PREAMBLE/'  ${FILENAME}-diff${COMMITHASH}.tex
	cd ${TMPDIR} && gsed -i 's/\\providecommand{\\DIFdel}\[1\]{{\\protect\\color{red}\\sout{#1}}}                      %DIF PREAMBLE/\\providecommand{\\DIFdel}[1]{}                      %DIF PREAMBLE/'  ${FILENAME}-diff${COMMITHASH}.tex
	cd ${TMPDIR} && ${PDFLATEX} -synctex=1 -shell-escape -file-line-error ${FILENAME}-diff${COMMITHASH}.tex
	cd ${TMPDIR} && ${BIBTEX} ${FILENAME}-diff${COMMITHASH}
	cd ${TMPDIR} && ${PDFLATEX} -synctex=1 -shell-escape -file-line-error ${FILENAME}-diff${COMMITHASH}.tex
	cd ${TMPDIR} && ${PDFLATEX} -synctex=1 -shell-escape -file-line-error ${FILENAME}-diff${COMMITHASH}.tex
	cp ${TMPDIR}/${FILENAME}-diff${COMMITHASH}.pdf ${OUTDIR}/

clean:
	rm -rf ${TMPDIR}/*