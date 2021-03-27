cmuclmtk(){
    # Building and installing CMUCLMTK
    echo
    printf "${Bright_Green}Installing & Building cmuclmtk...${Bright_White}${NewLine}"
    cd ~/.config/naomi/sources
    svn co https://svn.code.sf.net/p/cmusphinx/code/trunk/cmuclmtk/
    if [ $? -ne 0 ]; then
      printf "${ERROR} ${Bright_Red}Notice:${Bright_White} Error cloning cmuclmtk${NewLine}" >&2
      exit 1
    fi
    cd cmuclmtk
    ./autogen.sh
    make
    printf "${Bright_Green}Installing CMUCLMTK${Bright_White}${NewLine}"
    if [ $REQUIRE_AUTH -eq 1 ]; then
      SUDO_COMMAND "sudo make install"
    else
      printf "${Bright_White}${NewLine}"
      sudo make install
    fi

    printf "${Bright_Green}Linking shared libraries${Bright_White}${NewLine}"
    if [ $REQUIRE_AUTH -eq 1 ]; then
      SUDO_COMMAND "sudo ldconfig"
    else
      printf "${Bright_White}${NewLine}"
      sudo ldconfig
    fi
}
