    
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
        echo
        echo
        echo
        echo
        printf "${Bright_White}If you want, we can add the call to start virtualenvwrapper directly${NewLine}"
        printf "${Bright_White}to the end of your ${Bright_Green}~/.bashrc${Bright_White} file, so if you want to use the same${NewLine}"
        printf "${Bright_White}python that Naomi does for debugging or installing additional${NewLine}"
        printf "${Bright_White}dependencies, all you have to type is '${Bright_Green}workon Naomi${Bright_White}'${NewLine}"
        echo
        printf "${Bright_White}Otherwise, you will need to enter:${NewLine}"
        printf "${Bright_White}'${Bright_Green}VIRTUALENVWRAPPER_VIRTUALENV=~/.local/bin/virtualenv${Bright_White}'${NewLine}"
        printf "${Bright_White}'${Bright_Green}source ~/.local/bin/virtualenvwrapper.sh${Bright_White}'${NewLine}"
        printf "${Bright_White}before you will be able activate the Naomi environment with '${Bright_Green}workon Naomi${Bright_White}'${NewLine}"
        echo
        printf "${Bright_White}All of this will be incorporated into the Naomi script, so to simply${NewLine}"
        printf "${Bright_White}launch Naomi, all you have to type is '${Bright_Green}Naomi${Bright_White}' in a terminal regardless of your choice here.${NewLine}"
        echo 
        printf "${Bright_White}Would you like to start VirtualEnvWrapper automatically?${NewLine}"
        echo
        printf "${Bright_Magenta}  Y${Bright_White})es, start virtualenvwrapper whenever I start a shell${NewLine}"
        printf "${Bright_Magenta}  N${Bright_White})o, don't start virtualenvwrapper for me${NewLine}"
        printf "${B_Blue}Choice [${Bright_Magenta}Y${B_Blue}/${Bright_Magenta}N${B_Blue}]: ${Bright_White}"
        export AUTO_START=""
        if [ "$SUDO_APPROVE" = "-y" ]; then
            AUTO_START="Y"
        else
            while [ "$AUTO_START" != "Y" ] && [ "$AUTO_START" != "y" ] && [ "$AUTO_START" != "N" ] && [ "$AUTO_START" != "n" ]; do
                read -e -p 'Please select: ' AUTO_START
                if [ "$AUTO_START" = "" ]; then
                    AUTO_START="Y"
                fi
                if [ "$AUTO_START" != "Y" ] && [ "$AUTO_START" != "y" ] && [ "$AUTO_START" != "N" ] && [ "$AUTO_START" != "n" ]; then
                    printf "${Bright_Red}Notice:${Bright_White} Please choose 'Y' or 'N'"
                fi
            done
        fi
        if [ "$AUTO_START" = "Y" ] || [ "$AUTO_START" = "y" ]; then
            printf "${Bright_White}${NewLine}"
            echo '' >> ~/.bashrc
            echo '' >> ~/.bashrc
            echo '' >> ~/.bashrc
            echo '######################################################################' >> ~/.bashrc
            echo '# Initialize Naomi VirtualEnvWrapper' >> ~/.bashrc
            echo '######################################################################' >> ~/.bashrc
            echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.bashrc
            echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc
            echo "export VIRTUALENVWRAPPER_VIRTUALENV=~/.local/bin/virtualenv" >> ~/.bashrc
            echo "source ~/.local/bin/virtualenvwrapper.sh" >> ~/.bashrc
        fi
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
