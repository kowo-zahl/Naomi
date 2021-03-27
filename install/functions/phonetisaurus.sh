phonetisaurus() {
    # Building and installing phonetisaurus
    echo
    printf "${Bright_Green}Installing & Building phonetisaurus...${Bright_White}${NewLine}"
    cd ~/.config/naomi/sources
    if [ ! -d "Phonetisaurus" ]; then
      git clone https://github.com/AdolfVonKleist/Phonetisaurus.git
        if [ $? -ne 0 ]; then
          printf "${ERROR} ${Bright_Red}Notice:${Bright_White} Error cloning Phonetisaurus${NewLine}" >&2
          exit 1
        fi
    fi
    cd Phonetisaurus
    ./configure --enable-python
    make
    printf "${Bright_Green}Installing Phonetisaurus${Bright_White}${NewLine}"
    printf "${Bright_Green}Linking shared libraries${Bright_White}${NewLine}"
    if [ $REQUIRE_AUTH -eq 1 ]; then
      SUDO_COMMAND "sudo make install"
    else
      printf "${Bright_White}${NewLine}"
      sudo make install
    fi

    printf "[$(pwd)]\$ ${Bright_Green}cd python${Bright_White}${NewLine}"
    cd python
    echo $(pwd)
    cp -v ../.libs/Phonetisaurus.so ./
    if [ $REQUIRE_AUTH -eq 1 ]; then
      SUDO_COMMAND "sudo python setup.py install"
    else
      printf "${Bright_White}${NewLine}"
      sudo python setup.py install
    fi

    if [ -z "$(which phonetisaurus-g2pfst)" ]; then
      printf "${ERROR} ${Bright_Red}Notice:${Bright_White} phonetisaurus-g2pfst does not exist${NewLine}" >&2
      exit 1
    fi
}
