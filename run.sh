#!/bin/bash

    #python umgebung installieren ... ist das nur loginshell?
    export WORKON_HOME=/home/kowo/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    export VIRTUALENVWRAPPER_VIRTUALENV=~/.local/bin/virtualenv
    source ~/.local/bin/virtualenvwrapper.sh

  workon Naomi
  python Naomi/Naomi.py "$@"
