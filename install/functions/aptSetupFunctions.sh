CONTINUE() {
    printf "${Bright_White}If you want to allow the process to run uninterrupted type '${Bright_Green}S${Bright_White}'${NewLine}"
    printf "${Bright_White}or press '${Bright_Green}Q${Bright_White}' to quit, any other key to continue:${NewLine}"
    read -n1 -p "" CONTINUE
    echo
    if [ "$CONTINUE" = "q" ] || [ "$CONTINUE" = "Q" ]; then
        echo
        printf "${Bright_Red}EXITING${Bright_White}${NewLine}"
        exit 1
    elif [ "$CONTINUE" = "S" ] || [ "$CONTINUE" = "s" ]; then
        REQUIRE_AUTH="0"
        SUDO_APPROVE="-y"
    fi
}
SUDO_COMMAND() {
    echo
    printf "${Bright_Red}Notice:${Bright_White} this program is about to use sudo to run the following command:${NewLine}"
    printf "[$(pwd)]\$ ${Bright_Green}${1}${Bright_White}${NewLine}"
    echo
    if [ "$SUDO_APPROVE" != "-y" ]; then
        CONTINUE
    fi
    $1
}
CHECK_HEADER() {
    echo "#include <$1>" | cpp $(pkg-config alsa --cflags) -H -o /dev/null > /dev/null 2>&1
    echo $?
}
CHECK_PROGRAM() {
    type -p "$1" > /dev/null 2>&1
    echo $?
}
GIT() {
    echo
    printf "${Bright_Green}Installing 'git'...${Bright_White}${NewLine}"
    if [ $REQUIRE_AUTH -eq 1 ]; then
      SUDO_COMMAND "sudo apt-get install git $SUDO_APPROVE"
    else
      printf "${Bright_White}${NewLine}"
      sudo apt-get install git $SUDO_APPROVE
    fi
    echo
}
