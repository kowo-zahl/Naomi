pocketSphinx() {
    # Installing PocketSphinx Python module
    echo
    printf "${Bright_Green}Installing PocketSphinx module...${Bright_White}${NewLine}"
    cd ~/.config/naomi/sources/pocketsphinx-python
    python setup.py install

    cd $NAOMI_DIR
    if [ -z "$(which text2wfreq)" ]; then
      printf "${ERROR} ${Bright_Red}Notice:${Bright_White} text2wfreq does not exist${NewLine}" >&2
      exit 1
    fi
    if [ -z "$(which text2idngram)" ]; then
      printf "${ERROR} ${Bright_Red}Notice:${Bright_White} text2idngram does not exist${NewLine}" >&2
      exit 1
    fi
    if [ -z "$(which idngram2lm)" ]; then
      printf "${ERROR} ${Bright_Red}Notice:${Bright_White} idngram2lm does not exist${NewLine}" >&2
      exit 1
    fi

    # Compiling Translations
    echo
    printf "${Bright_Green}Compiling Translations...${Bright_White}${NewLine}"
    cd ~/Naomi
    chmod a+x compile_translations.sh
    ./compile_translations.sh
}    
