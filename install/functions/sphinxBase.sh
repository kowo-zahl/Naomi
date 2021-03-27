sphinxBase(){
    # Installing & Building sphinxbase
    echo
    printf "${Bright_Green}Building and installing sphinxbase...${Bright_White}${NewLine}"
    cd ~/.config/naomi/sources
    if [ ! -d "pocketsphinx-python" ]; then
      git clone --recursive https://github.com/bambocher/pocketsphinx-python.git
      if [ $? -ne 0 ]; then
        printf "${ERROR} ${Bright_Red}Notice:${Bright_White} Error cloning pocketsphinx${NewLine}" >&2
        exit 1
      fi
    fi
    cd pocketsphinx-python/deps/sphinxbase
    ./autogen.sh
    make
    if [ $REQUIRE_AUTH -eq 1 ]; then
      SUDO_COMMAND "sudo make install"
    else
      printf "${Bright_White}${NewLine}"
      sudo make install
    fi

    # Installing & Building pocketsphinx
    echo
    printf "${Bright_Green}Building and installing pocketsphinx...${Bright_White}${NewLine}"
    cd ~/.config/naomi/sources/pocketsphinx-python/deps/pocketsphinx
    ./autogen.sh
    make
    if [ $REQUIRE_AUTH -eq 1 ]; then
      SUDO_COMMAND "sudo make install"
    else
      printf "${Bright_White}${NewLine}"
      sudo make install
    fi
}
