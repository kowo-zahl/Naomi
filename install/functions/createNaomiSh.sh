#!/bin/bash
createNaomiSh() {
    echo
    echo "#!/bin/bash" > ~/Naomi/Naomi.sh
    echo "" >> ~/Naomi/Naomi.sh
    echo "B_W='\033[1;97m' #Bright White  For standard text output" >> ~/Naomi/Naomi.sh
    echo "B_R='\033[1;91m' #Bright Red    For alerts/errors" >> ~/Naomi/Naomi.sh
    echo "B_Blue='\033[1;94m' #Bright Blue For prompt question" >> ~/Naomi/Naomi.sh
    echo "B_M='\033[1;95m' #Bright Magenta For prompt choices" >> ~/Naomi/Naomi.sh
    echo 'NL="' >> ~/Naomi/Naomi.sh
    echo '"' >> ~/Naomi/Naomi.sh
    echo 'version="3.0"' >> ~/Naomi/Naomi.sh
    echo 'theDateRightNow=$(date +%m-%d-%Y-%H:%M:%S)' >> ~/Naomi/Naomi.sh
    echo 'gitURL="https://github.com/naomiproject/naomi"' >> ~/Naomi/Naomi.sh
    echo "" >> ~/Naomi/Naomi.sh
    echo "function Naomi() {" >> ~/Naomi/Naomi.sh
    echo "  if [ \"\$(jq '.auto_update' ~/.config/naomi/configs/.naomi_options.json)\" = '\"true\"' ]; then" >> ~/Naomi/Naomi.sh
    echo '    printf "${Bright_White}=========================================================================${NewLine}"' >> ~/Naomi/Naomi.sh
    echo '    printf "${Bright_White}Checking for Naomi Updates...${NewLine}"' >> ~/Naomi/Naomi.sh
    echo "    cd ~/Naomi" >> ~/Naomi/Naomi.sh
    echo "    git fetch -q " >> ~/Naomi/Naomi.sh
    echo '    if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ] ; then' >> ~/Naomi/Naomi.sh
    echo '      printf "${Bright_White}Downloading & Installing Updates...${NewLine}"' >> ~/Naomi/Naomi.sh
    echo "      git pull" >> ~/Naomi/Naomi.sh
    echo "      sudo apt-get -o Acquire::ForceIPv4=true update -y" >> ~/Naomi/Naomi.sh
    echo "      sudo apt -o upgrade -y" >> ~/Naomi/Naomi.sh
    echo "      sudo ./naomi_apt_requirements.sh -y" >> ~/Naomi/Naomi.sh
    echo "    else" >> ~/Naomi/Naomi.sh
    echo '      printf "${Bright_White}No Updates Found.${NewLine}"' >> ~/Naomi/Naomi.sh
    echo "    fi" >> ~/Naomi/Naomi.sh
    echo "  else" >> ~/Naomi/Naomi.sh
    echo '    printf "${Bright_Red}Notice: ${Bright_White}Naomi Auto Update Failed!${NewLine}"' >> ~/Naomi/Naomi.sh
    echo '    printf "${Bright_Red}Notice: ${Bright_White}Would you like to force update Naomi?${NewLine}"' >> ~/Naomi/Naomi.sh
    echo '    printf "${B_Blue}Choice [${B_M}Y${B_Blue}/${B_M}N${B_Blue}]: ${Bright_White}"' >> ~/Naomi/Naomi.sh
    echo '    while true; do' >> ~/Naomi/Naomi.sh
    echo '      read -N1 -s key' >> ~/Naomi/Naomi.sh
    echo '      case $key in' >> ~/Naomi/Naomi.sh
    echo '        Y)' >> ~/Naomi/Naomi.sh
    echo '          printf "${B_M}$key ${Bright_White}- Forcing Update${NewLine}"' >> ~/Naomi/Naomi.sh
    echo '          mv ~/Naomi ~/Naomi-Temp' >> ~/Naomi/Naomi.sh
    echo '          cd ~' >> ~/Naomi/Naomi.sh
    echo "          if [ \"\$(jq '.use_release' ~/.config/naomi/configs/.naomi_options.json)\" = '\"nightly\"' ]; then" >> ~/Naomi/Naomi.sh
    echo '            printf "${B_M}$key ${Bright_White}- Forcing Update${NewLine}"' >> ~/Naomi/Naomi.sh
    echo '            mv ~/Naomi ~/Naomi-Temp' >> ~/Naomi/Naomi.sh
    echo '            cd ~' >> ~/Naomi/Naomi.sh
    echo "            git clone \$gitURL.git -b naomi-dev Naomi" >> ~/Naomi/Naomi.sh
    echo '            cd Naomi' >> ~/Naomi/Naomi.sh
    echo "            echo '{\"use_release\":\"nightly\", \"branch\":\"naomi-dev\", \"version\":\"Naomi-\$version.\$(git rev-parse --short HEAD)\", \"date\":\"\$theDateRightNow\", \"auto_update\":\"true\"}' > ~/.config/naomi/configs/.naomi_options.json" >> ~/Naomi/Naomi.sh
    echo '            cd ~' >> ~/Naomi/Naomi.sh
    echo '            break' >> ~/Naomi/Naomi.sh
    echo "          elif [ \"\$(jq '.use_release' ~/.config/naomi/configs/.naomi_options.json)\" = '\"milestone\"' ]; then" >> ~/Naomi/Naomi.sh
    echo '            printf "${B_M}$key ${Bright_White}- Forcing Update${NewLine}"' >> ~/Naomi/Naomi.sh
    echo '            mv ~/Naomi ~/Naomi-Temp' >> ~/Naomi/Naomi.sh
    echo '            cd ~' >> ~/Naomi/Naomi.sh
    echo "            git clone \$gitURL.git -b naomi-dev Naomi" >> ~/Naomi/Naomi.sh
    echo '            cd Naomi' >> ~/Naomi/Naomi.sh
    echo "            echo '{\"use_release\":\"milestone\", \"branch\":\"naomi-dev\", \"version\":\"Naomi-\$version.\$(git rev-parse --short HEAD)\", \"date\":\"\$theDateRightNow\", \"auto_update\":\"true\"}' > ~/.config/naomi/configs/.naomi_options.json" >> ~/Naomi/Naomi.sh
    echo '            cd ~' >> ~/Naomi/Naomi.sh
    echo '            break' >> ~/Naomi/Naomi.sh
    echo "          elif [ \"\$(jq '.use_release' ~/.config/naomi/configs/.naomi_options.json)\" = '\"stable\"' ]; then" >> ~/Naomi/Naomi.sh
    echo '            printf "${B_M}$key ${Bright_White}- Forcing Update${NewLine}"' >> ~/Naomi/Naomi.sh
    echo '            mv ~/Naomi ~/Naomi-Temp' >> ~/Naomi/Naomi.sh
    echo '            cd ~' >> ~/Naomi/Naomi.sh
    echo "            git clone \$gitURL.git -b master Naomi" >> ~/Naomi/Naomi.sh
    echo '            cd Naomi' >> ~/Naomi/Naomi.sh
    echo "            echo '{\"use_release\":\"stable\", \"branch\":\"master\", \"version\":\"Naomi-\$version.\$(git rev-parse --short HEAD)\", \"date\":\"\$theDateRightNow\", \"auto_update\":\"false\"}' > ~/.config/naomi/configs/.naomi_options.json" >> ~/Naomi/Naomi.sh
    echo '            cd ~' >> ~/Naomi/Naomi.sh
    echo '          fi' >> ~/Naomi/Naomi.sh
    echo '          break' >> ~/Naomi/Naomi.sh
    echo '          ;;' >> ~/Naomi/Naomi.sh
    echo '         N)' >> ~/Naomi/Naomi.sh
    echo '          printf "${B_M}$key ${Bright_White}- Launching Naomi!${NewLine}"' >> ~/Naomi/Naomi.sh
    echo '          break' >> ~/Naomi/Naomi.sh
    echo '          ;;' >> ~/Naomi/Naomi.sh
    echo '       esac' >> ~/Naomi/Naomi.sh
    echo '   done' >> ~/Naomi/Naomi.sh
    echo "  fi" >> ~/Naomi/Naomi.sh
    echo "  export WORKON_HOME=$HOME/.virtualenvs" >> ~/Naomi/Naomi.sh
    echo "  export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/Naomi/Naomi.sh
    echo "  export VIRTUALENVWRAPPER_VIRTUALENV=~/.local/bin/virtualenv" >> ~/Naomi/Naomi.sh
    echo "  source ~/.local/bin/virtualenvwrapper.sh" >> ~/Naomi/Naomi.sh
    echo "  workon Naomi" >> ~/Naomi/Naomi.sh
    echo "  python $NAOMI_DIR/Naomi.py \"\$@\"" >> ~/Naomi/Naomi.sh
    echo "}" >> ~/Naomi/Naomi.sh
    echo
    echo
    echo
    echo
}
createNaomiSh
