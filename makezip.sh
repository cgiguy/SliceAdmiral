#!/bin/sh

if [ -z "$1" ]; then
  echo "$0 <version>"
  exit 1
fi

VERS="$1"
TMPDIR="$PWD/tmp-$1"
SLICEDIR="$TMPDIR/SliceAdmiral"

if [ -d $TMPDIR ]; then
  echo "$TMPDIR exists... manually delete it to continue."
  exit 1
fi
   
mkdir -p $SLICEDIR

cp -rp *.lua *.xml *.toc .pkgmeta Audio Images $SLICEDIR

cd $SLICEDIR

mkdir lib

svn checkout https://repos.curseforge.com/wow/ace3/trunk/AceAddon-3.0 lib/AceAddon-3.0
svn checkout https://repos.curseforge.com/wow/ace3/trunk/AceConfig-3.0 lib/AceConfig-3.0
svn checkout https://repos.curseforge.com/wow/ace3/trunk/AceConsole-3.0 lib/AceConsole-3.0
svn checkout https://repos.curseforge.com/wow/ace3/trunk/AceDB-3.0 lib/AceDB-3.0
svn checkout https://repos.curseforge.com/wow/ace3/trunk/AceDBOptions-3.0 lib/AceDBOptions-3.0
svn checkout https://repos.curseforge.com/wow/ace3/trunk/AceEvent-3.0 lib/AceEvent-3.0
svn checkout https://repos.curseforge.com/wow/ace3/trunk/AceGUI-3.0 lib/AceGUI-3.0
svn checkout https://repos.curseforge.com/wow/ace-gui-3-0-shared-media-widgets/trunk/AceGUI-3.0-SharedMediaWidgets lib/AceGUI-3.0-SharedMediaWidgets
svn checkout https://repos.curseforge.com/wow/ace3/trunk/AceHook-3.0 lib/AceHook-3.0
svn checkout https://repos.curseforge.com/wow/ace3/trunk/AceLocale-3.0 lib/AceLocale-3.0
svn checkout https://repos.curseforge.com/wow/callbackhandler/trunk/CallbackHandler-1.0 lib/CallbackHandler-1.0
git clone https://repos.curseforge.com/wow/libsmoothstatusbar-1-0 lib/LibSmoothStatusBar-1.0
svn checkout https://repos.curseforge.com/wow/libsharedmedia-3-0/trunk/LibSharedMedia-3.0 lib/LibSharedMedia-3.0
svn checkout https://repos.curseforge.com/wow/ace3/trunk/LibStub lib/LibStub

find ./lib -type d -name .svn -exec rm -rf {} \;
find ./lib -type d -name .git -exec rm -rf {} \;

cd $TMPDIR
zip -r -9 "SliceAdmiral-$VERS.zip" SliceAdmiral
