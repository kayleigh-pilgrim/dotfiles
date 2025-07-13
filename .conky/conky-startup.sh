#!/bin/sh

sleep 3s
killall conky
cd "$HOME/.conky/kayleigh"
conky -c "$HOME/.conky/kayleigh/kayleigh" &
exit 0
