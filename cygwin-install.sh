#!/usr/bin/env bash

# cygwin-install.sh - install cygwin repeatably.
# Copyright (C) 2023  Ira Peach
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

error() {
    echo "ERROR: $1" >&2
}

status() {
    echo "$1"
}

warn() {
    echo "WARNING: $1" >&2
}

ARGS=$(getopt -o "i:" --long "install-root:" -n "$(basename "$0")" -- "$@")

if (( $? != 0 )); then
    exit 1
fi

eval set -- "$ARGS"

CYGWIN_INSTALL="$PWD/cygwin"
while true; do
    case "$1" in
        -i|--install-root)
            CYGWIN_INSTALL="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            error "unexpected argument: '$1'"
            exit 1
            ;;
    esac
done

XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

CYGWIN_INSTALL_CACHE="$XDG_CACHE_HOME/cygwin-install"
CYGWIN_SETUP="$CYGWIN_INSTALL_CACHE/setup-x86_64.exe"
CYGWIN_DOWNLOAD_URL="https://cygwin.com/setup-x86_64.exe"

if [[ -f $CYGWIN_SETUP ]]; then
    status "Removing '$CYGWIN_SETUP'"
    rm -f "$CYGWIN_SETUP" || exit $?
fi

if [[ ! -d "$CYGWIN_INSTALL_CACHE" ]]; then
    status "Creating directory '$CYGWIN_INSTALL_CACHE'"
    mkdir -p "$CYGWIN_INSTALL_CACHE" || exit $?
fi

status "Downloading cygwin setup from '$CYGWIN_DOWNLOAD_URL' to '$CYGWIN_SETUP'"
curl -Lso "$CYGWIN_SETUP" "$CYGWIN_DOWNLOAD_URL" || exit $?

if [[ ! -x $CYGWIN_SETUP ]]; then
    chmod +x "$CYGWIN_SETUP"
fi

export MINTTY_OPTIONS='--Title cygwin-portable -o Columns=160 -o Rows=50 -o BellType=0 -o ClicksPlaceCursor=yes -o CursorBlinks=no -o CursorType=Block -o CopyOnSelect=yes -o RightClickAction=Paste -o Font="Lucida Console" -o FontHeight=9 -o FontSmoothing=Default -o ScrollbackLines=10000 -o Transparency=off -o Term=xterm-256color -o Charset=UTF-8 -o Locale'


status "Running cygwin setup"
"$CYGWIN_SETUP" --no-admin --no-shortcuts --arch x86_64 --packages tmux,vim,wget --quiet-mode --root "$CYGWIN_INSTALL"

# copy instead of creating directly so we preserve the same permissions if we
# are using cygwin to run the script
cp -v "$CYGWIN_INSTALL/Cygwin.bat" "$CYGWIN_INSTALL/Cygwin-mintty.bat"

status "Setting contents of Cygwin-mintty.bat to launch mintty"

cat <<'EOF' > "$CYGWIN_INSTALL/etc/minttyrc"
CursorType=block
CursorBlinks=no
EOF

cat <<'EOF' > "$CYGWIN_INSTALL/Cygwin-mintty.bat"
@echo off
setlocal enableextensions
set TERM=
cd /d "%~dp0bin" && .\mintty /bin/bash --login -i
EOF
