#!/bin/bash

# Helper functions
function try_load_resources() {
  local path="$1"

  [ -f "$path" ] && xrdb -merge "$path"
}

function try_load_modmap() {
  local path="$1"

  [ -f "$path" ] && xmodmap "$path"
}

# Load resources
try_load_resources "/etc/X11/xinit/.Xresources"
try_load_resources "$HOME/.Xresources"

# Load modmaps
try_load_modmap "/etc/X11/xinit/.Xmodmap"
try_load_modmap "$HOME/.Xmodmap"

# Run system scripts from xinitrc.d
if [ -d "/etc/X11/xinit/xinitrc.d" ]; then
  for i in "/etc/X11/xinit/xinitrc.d/?*.sh"; do
    [ -x "$i" ] && . "$i"
  done
fi

# Environment variables
export TERMINAL=urxvtc

# Startup
exec i3
