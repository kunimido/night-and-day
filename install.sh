#!/bin/zsh

SRC="$(cd $(dirname "$0") && pwd 2>/dev/null)"
PRODUCT=night-and-day
SERVICE=com.github.kunimido.${PRODUCT}
PLIST=${SERVICE}.plist

cd "$SRC"
xcodebuild install DSTROOT="$HOME" INSTALL_PATH="bin" PRODUCT_NAME="$PRODUCT"
xcodebuild clean

cd "$HOME/Library/LaunchAgents/"
sed -E 's=\$INSTALL='"$HOME/bin=" "$SRC/$PLIST" > "$PLIST"
launchctl bootout "gui/$(id -u)/$SERVICE"
launchctl bootstrap gui/$(id -u) $PLIST
