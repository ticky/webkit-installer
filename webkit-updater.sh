#!/bin/sh

echo Updating WebKit Nightly...
tmpdir=/tmp/webkit-nightly
echo Finding Nightly Build version...
URL=$(curl --progress-bar http://nightly.webkit.org/ | grep dmg | head -1 | perl -pe 's/.*(http.*dmg).*/$1/')
FILE=$(basename $URL)
echo Retrieving \"$URL\"...
mkdir -p $tmpdir &&
cd $tmpdir
if [ ! -f $tmpdir/$FILE ]; then
	echo Downloading...
	curl --progress-bar $URL --remote-name
else
	echo \"$FILE\" already exists.
fi
hdiutil attach -quiet -nobrowse $tmpdir/$FILE &&
mv /Applications/WebKit.app ~/.Trash/WebKit-`date +%Y-%m-%d_%H-%M-%s`.app/
cp -R /Volumes/WebKit/WebKit.app /Applications/ &&
hdiutil detach -quiet /Volumes/WebKit &&
mv $tmpdir/$FILE ~/.Trash/ &&
echo Installed \"$FILE\".
