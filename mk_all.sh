#!/bin/sh -e

TEMP=/tmp
ALL_FILES=""
DRAFT_FILES=""
FNUM=0

mk_config()
{
	CONFIG=$1

	DISCIPLE=""
	TUTORFNAME=""

	STUDENT01=""
	STUDENT02=""
	STUDENT03=""
	STUDENT04=""
	STUDENT05=""
	STUDENT06=""
	STUDENT07=""
	STUDENT08=""
	STUDENT09=""
	STUDENT10=""
	STUDENT11=""
	STUDENT12=""
	STUDENT13=""
	STUDENT14=""
	STUDENT15=""
	STUDENT16=""
	STUDENT17=""
	STUDENT18=""
	STUDENT19=""

	. $CONFIG

	if [ "${STUDENT01}" = "" ]; then
		echo "empty STUDENT01!" >&2
		exit 1
	fi

	if [ "${DISCIPLE}" = "" ]; then
		echo "empty DISCIPLE!" >&2
		exit 1
	fi

	if [ "${TUTORFNAME}" = "" ]; then
		echo "empty TUTORFNAME!" >&2
		exit 1
	fi

	echo "\\def\\disciple{$DISCIPLE}"
	echo "\\def\\tutorfname{$TUTORFNAME}"

	echo "\\def\\facultyname{$FACULTYNAME}"
	echo "\\def\\groupname{$GROUPNAME}"

	echo "    \\def\\studenti{${STUDENT01}}"
	echo "   \\def\\studentii{${STUDENT02}}"
	echo "  \\def\\studentiii{${STUDENT03}}"
	echo "   \\def\\studentiv{${STUDENT04}}"
	echo "    \\def\\studentv{${STUDENT05}}"
	echo "   \\def\\studentvi{${STUDENT06}}"
	echo "  \\def\\studentvii{${STUDENT07}}"
	echo " \\def\\studentviii{${STUDENT08}}"
	echo "   \\def\\studentix{${STUDENT09}}"
	echo "    \\def\\studentx{${STUDENT10}}"
	echo "   \\def\\studentxi{${STUDENT11}}"
	echo "  \\def\\studentxii{${STUDENT12}}"
	echo " \\def\\studentxiii{${STUDENT13}}"
	echo "  \\def\\studentxiv{${STUDENT14}}"
	echo "   \\def\\studentxv{${STUDENT15}}"
	echo "  \\def\\studentxvi{${STUDENT16}}"
	echo " \\def\\studentxvii{${STUDENT17}}"
	echo "\\def\\studentxviii{${STUDENT18}}"
	echo "  \\def\\studentxix{${STUDENT19}}"
	echo "\\endinput"
}

for i in \
		./2013_fall_013a.conf \
	; do

	echo "= $i ="

	mk_config $i > tpage_conf.tex

	pdflatex title.tex
	pdf2ps title.pdf $TEMP/title.ps
	psnup -m0.2cm -2 -pa4 $TEMP/title.ps $TEMP/title2.ps

	pdflatex main.tex
	pdf2ps main.pdf $TEMP/main.ps
	psnup -b0.2cm -m0.5cm -s0.90 -1 -pa4 $TEMP/main.ps $TEMP/main_a4.ps
	psmerge -o$TEMP/all.ps $TEMP/title2.ps $TEMP/main_a4.ps
	SNAME=$(basename $i .conf)
	ps2pdf $TEMP/all.ps $TEMP/$SNAME.pdf
	ALL_FILES="$ALL_FILES $TEMP/$SNAME.pdf"
	ps2pdf $TEMP/main_a4.ps $TEMP/$SNAME.draft.pdf
	DRAFT_FILES="$DRAFT_FILES $TEMP/$SNAME.draft.pdf"

	rm -f $TEMP/title.ps $TEMP/title2.ps \
		$TEMP/main.ps $TEMP/main_a4.ps \
		$TEMP/all.ps
	let FNUM=FNUM+1
done

if [ "$FNUM" -gt 1 ]; then
	pdfunite $ALL_FILES $TEMP/all.pdf
	pdfunite $DRAFT_FILES $TEMP/draft.pdf
else
	mv $ALL_FILES $TEMP/all.pdf
	mv $DRAFT_FILES $TEMP/draft.pdf
fi

echo
echo "Output files: $TEMP/all.pdf $TEMP/draft.pdf"
