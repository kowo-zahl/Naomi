#!/bin/bash

    
virtualEnv(){    
    
    pip3 install --user virtualenv virtualenvwrapper=='4.8.4'
    printf "${Bright_Green}sourcing virtualenvwrapper.sh${Bright_White}${NewLine}"
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    export VIRTUALENVWRAPPER_VIRTUALENV=~/.local/bin/virtualenv
    source ~/.local/bin/virtualenvwrapper.sh
    export VIRTUALENVWRAPPER_ENV_BIN_DIR=bin
    printf "${Bright_Green}checking if Naomi virtualenv exists${Bright_White}${NewLine}"
    
    workon Naomi > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        printf "${Bright_Green}Naomi virtualenv does not exist. Creating.${Bright_White}${NewLine}"
        PATH=$PATH:~/.local/bin mkvirtualenv -p python3 Naomi
    fi
    workon Naomi
    
    
    if [ "$(which pip)" = "$HOME/.virtualenvs/Naomi/bin/pip" ]; then
     
        pip install -r python_requirements.txt
        if [ $? -ne 0 ]; then
            printf "${Bright_Red}Notice:${Bright_White} Error installing python requirements: ${NewLine}${NewLine}$!" >&2
            exit 1
        fi
    else
        printf "${Bright_Red}Notice:${Bright_White} Something went wrong, not in virtual environment...${NewLine}" >&2
        exit 1
    fi
}





    # Create basic folder structures
    echo
    printf "${Bright_Green}Creating File Structure...${Bright_White}${NewLine}"
    mkdir -p ~/.config/naomi/
    mkdir -p ~/.config/naomi/configs/
    mkdir -p ~/.config/naomi/scripts/
    mkdir -p ~/.config/naomi/sources/

    
    
    SUDO_COMMAND "sudo ./naomi_apt_requirements.sh"
    
    
    virtualEnv



  
  
  
  
