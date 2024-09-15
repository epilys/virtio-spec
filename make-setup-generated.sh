#! /bin/sh

DATESTR=${DATESTR:-`cat REVISION-DATE 2>/dev/null`}
if [ x"$DATESTR" = x ]; then
    ISODATE=`git show --format=format:'%cd' --date=iso | head -n 1`
    DATESTR=`date -d "$DATE" +'%d %B %Y'`
fi
# PDF date values should be specified in the form “D:YYYYMMDDHHmmSSOHH ’mm’”
# as described in the pdf reference manual [1, §3.8.3, “Dates”].
# Adobe Systems Incorporated. PDF Reference Version 1.6. Adobe Press,
# fifth edition, December 3, 2004. ISBN 0321304748.
# <http://partners.adobe.com/public/developer/en/pdf/PDFReference16.pdf>
# %D:YYYYMMDDHHmmSSOHH ’mm’
PDFDATESTR=`date -d "$DATESTR" +"D:%Y%m%d000000000 '00'"`

case "$1" in
    *-wd*)
	STAGE=wd
	STAGENAME="Working Draft"
	WORKINGDRAFT=`basename "$1" | sed 's/.*-wd//'`
	;;
    *-os*)
	STAGE=os
	STAGENAME="OASIS Standard"
	WORKINGDRAFT=""
	;;
    *-csd*)
	STAGE=csd
	WORKINGDRAFT=`basename "$1" | sed 's/.*-csd//'`
	STAGENAME="Committee Specification Draft $WORKINGDRAFT"
	;;
    *-csprd*)
	STAGE=csprd
	WORKINGDRAFT=`basename "$1" | sed 's/.*-csprd//'`
	STAGENAME="Committee Specification Draft $WORKINGDRAFT"
	STAGEEXTRATITLE=" / \newline Public Review Draft $WORKINGDRAFT"
	STAGEEXTRA=" / Public Review Draft $WORKINGDRAFT"
	;;
    *-cs*)
	STAGE=cs
	WORKINGDRAFT=`basename "$1" | sed 's/.*-cs//'`
	STAGENAME="Committee Specification $WORKINGDRAFT"
	;;
    *)
	echo Unknown doc type >&2
	exit 1
esac

VERSION=`echo "$1"| sed -e 's/virtio-v//' -e 's/-.*//'`

#Prepend OASIS unless already there
case "$STAGENAME" in
	OASIS*)
		OASISSTAGENAME="$STAGENAME"
		;;
	*)
		OASISSTAGENAME="OASIS $STAGENAME"
		;;
esac

cat > setup-generated.tex <<EOF
% define VIRTIO Working Draft number and date
\newcommand{\virtiorev}{$VERSION}
\newcommand{\virtioworkingdraftdate}{$DATESTR}
\newcommand{\virtioworkingdraftdatepdfformat}{$PDFDATESTR}
\newcommand{\virtioworkingdraft}{$WORKINGDRAFT}
\newcommand{\virtiodraftstage}{$STAGE}
\newcommand{\virtiodraftstageextra}{$STAGEEXTRA}
\newcommand{\virtiodraftstageextratitle}{$STAGEEXTRATITLE}
\newcommand{\virtiodraftstagename}{$STAGENAME}
\newcommand{\virtiodraftoasisstagename}{$OASISSTAGENAME}
EOF
