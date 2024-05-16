#!/usr/bin/bash

DEBIAN_DIR="~/deb"
if [ cd "$DEBIAN_DIR" ]; then
    cd "$DEBIAN_DIR"
else
    mkdir -p "$DEBIAN_DIR"
    cd "$DEBIAN_DIR"
fi

wget $1
ar x *.deb
tar -xvf data.tar.xz
mv usr/* ~/.local/bin/
rm -rf "$DEBIAN_DIR"

