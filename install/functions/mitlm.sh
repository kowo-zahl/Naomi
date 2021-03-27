mitlm() {
    # Building and installing mitlm-0.4.2
    echo
    printf "${Bright_Green}Installing & Building mitlm-0.4.2...${Bright_White}${NewLine}"
    cd ~/.config/naomi/sources
    if [ ! -d "mitlm" ]; then
      git clone https://github.com/mitlm/mitlm.git
      if [ $? -ne 0 ]; then
        printf "${ERROR} ${Bright_Red}Notice:${Bright_White} Error cloning mitlm${NewLine}"
        exit 1
      fi
    fi
    cd mitlm
    ./autogen.sh
    make
    printf "${Bright_Green}Installing mitlm${Bright_White}${NewLine}"
    if [ $REQUIRE_AUTH -eq 1 ]; then
      SUDO_COMMAND "sudo make install"
      if [ $? -ne 0 ]; then
        echo $! >&2
        exit 1
      fi
    else
      printf "${Bright_White}${NewLine}"
      sudo make install
      if [ $? -ne 0 ]; then
        echo $! >&2
        exit 1
      fi
    fi
 } 
