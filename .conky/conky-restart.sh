#!/bin/bash
killall conky
cd "$HOME/.conky/kayleigh"
conky -c "$HOME/.conky/kayleigh/kayleigh" &
echo "========== Restarted =========="
