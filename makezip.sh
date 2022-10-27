#!/bin/sh

if [ -z "$1" ]; then
  echo "$0 <version>"
  exit 1
fi

VERS="$1"
TOP="$PWD"
TMPDIR="$TOP/tmp-$1"
SLICEDIR="$TMPDIR/SliceAdmiral"

if [ -d $TMPDIR ]; then
  echo "$TMPDIR exists... manually delete it to continue."
  exit 1
fi
   
mkdir -p $SLICEDIR

cp -rp *.lua *.xml *.toc .pkgmeta Audio Images $SLICEDIR

cd $SLICEDIR

$TOP/grablibs.sh

cd $TMPDIR
zip -r -9 "SliceAdmiral-$VERS.zip" SliceAdmiral
