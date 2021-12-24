#!/bin/sh
pmset -g batt | grep Internal | perl "/Users/dsyang/dotfiles/tmux/tmux.d/macscripts/batt/batt.pl"
