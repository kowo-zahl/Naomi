naomi_uninstall() {
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_Magenta}Uninstall ${Bright_White}...${NewLine}"
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_Red}Notice:${Bright_White} You are about to uninstall Naomi, is that what you want?${NewLine}"
    echo
    while true; do
        printf "${B_Blue}Choice [${Bright_Magenta}Y${B_Blue}/${Bright_Magenta}N${B_Blue}]: ${Bright_White}"
        read uninstallChoice
        if [ "$uninstallChoice" = "y" ] || [ "$uninstallChoice" = "Y" ]; then
            printf "${Bright_Magenta}$key ${Bright_White}- Uninstalling Naomi${NewLine}"
            SUDO_COMMAND "sudo rm -Rf ~/Naomi"
            SUDO_COMMAND "sudo rm -Rf ~/.config/naomi"
            break
        elif [ "$uninstallChoice" = "n" ] || [ "$uninstallChoice" = "N" ]; then
            printf "${Bright_Magenta}N ${Bright_White}- Cancelling Install${NewLine}"
            sleep 5
            exec bash $0
        else
            printf "${Bright_Red}Notice:${Bright_White} Did not recognize input, try again...${NewLine}"
            echo
        fi
    done
}
