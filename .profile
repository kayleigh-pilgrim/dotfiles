if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Jetbrains Toolbox
export PATH="$PATH:/home/kayleigh/.local/share/JetBrains/Toolbox/scripts"

# cargo
#export PATH="$PATH:/home/kayleigh/.local/bin"
#. "/home/kayleigh/.local/share/cargo/env"

# opam
#test -r /home/kayleigh/.opam/opam-init/init.sh && . /home/kayleigh/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
