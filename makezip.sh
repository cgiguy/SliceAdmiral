#!/bin/sh

if [ -z "$1" ]; then
  echo "$0 <version> [--cleanlibs]"
  exit 1
fi

if [ -n "$2" ]; then
  if [ "$2" = "--cleanlibs" ]; then
    CLEANLIBS=1
  else
    echo "Unknown argument: $2"
    exit 1
  fi
fi

VERS="$1"
export SLICETOP="$PWD"
TMPDIR="$SLICETOP/tmp-$1"
SLICEDIR="$TMPDIR/SliceAdmiral"

if [ -d $TMPDIR ]; then
  echo "$TMPDIR exists... manually delete it to continue."
  exit 1
fi
   
mkdir -p $SLICEDIR

cp -rp *.lua *.xml *.toc .pkgmeta Audio Images $SLICEDIR

cd $SLICEDIR

# If --cleanlibs, then grab all the new dependent libraries, else just copy from current lib directory
if [ -z $CLEANLIBS ]; then
  cp -rp $SLICETOP/lib .
else
  $SLICETOP/grablibs.sh
fi


cd $TMPDIR
zip -r -9 "SliceAdmiral-$VERS.zip" SliceAdmiral
