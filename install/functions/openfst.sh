openfst () {
    # Building and installing openfst
    echo
    printf "${Bright_Green}Building and installing openfst...${Bright_White}${NewLine}"
    cd ~/.config/naomi/sources

    if [ ! -f "openfst-1.6.9.tar.gz" ]; then
      wget http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.6.9.tar.gz
    fi
    tar -zxvf openfst-1.6.9.tar.gz
    cd openfst-1.6.9
    autoreconf -i
    ./configure --enable-static --enable-shared --enable-far --enable-lookahead-fsts --enable-const-fsts --enable-pdt --enable-ngram-fsts --enable-linear-fsts --prefix=/usr
    make
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

    if [ -z "$(which fstinfo)" ]; then
      printf "${ERROR} ${Bright_Red}Notice:${Bright_White} openfst not installed${NewLine}" >&2
      exit 1
    fi
}
