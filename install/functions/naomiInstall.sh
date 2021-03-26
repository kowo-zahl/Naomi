naomi_install() {
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_Magenta}Install ${Bright_White}...${NewLine}"
    printf "${Bright_White}=========================================================================${NewLine}"
    echo
    if [ -d ~/.config/naomi ]; then
        printf "${Bright_White}It looks like you already have Naomi installed.${NewLine}"
        printf "${Bright_White}To start Naomi just type '${Bright_Green}Naomi${Bright_White}' in any terminal.${NewLine}"
        echo
        printf "${Bright_White}Running the install process again will create a backup of Naomi${NewLine}"
        printf "${Bright_White}in the '${Bright_Green}~/.config/naomi-backup${Bright_White}' directory and then create a fresh install.${NewLine}"
        printf "${Bright_White}Is this what you want?${NewLine}"
        echo
        while true; do
            printf "${B_Blue}Choice [${Bright_Magenta}Y${B_Blue}/${Bright_Magenta}N${B_Blue}]: ${Bright_White}"
            read installChoice
            if [ "$installChoice" = "y" ] || [ "$installChoice" = "Y" ]; then
                printf "${Bright_Magenta}Y ${Bright_White}- Creating Backup${NewLine}"
                theDateRightNow=$(date +%m-%d-%Y-%H:%M:%S)
                mkdir -p ~/.config/naomi_backup/
                mv ~/Naomi ~/.config/naomi_backup/Naomi-Source
                mv ~/.config/naomi ~/.config/naomi_backup/Naomi-SubDir
                cd ~/.config/naomi_backup/
                zip -r Naomi-Backup.$theDateRightNow.zip ~/.config/naomi_backup/
                sudo rm -Rf ~/.config/naomi_backup/Naomi-Source/
                sudo rm -Rf ~/.config/naomi_backup/Naomi-SubDir/
                printf "${Bright_Magenta}Y ${Bright_White}- Installing Naomi${NewLine}"
                if [ -n "$(command -v apt-get)" ]; then
                    apt_setup_wizard
                elif [ -n "$(command -v yum)" ]; then
                    unknown_os
                else
                    unknown_os
                fi
                break
            elif [ "$installChoice" = "n" ] || [ "$installChoice" = "N" ]; then
                printf "${Bright_Magenta}N ${Bright_White}- Cancelling Install${NewLine}"
                sleep 5
                exec bash $0
            else
                printf "${Bright_Red}Notice:${Bright_White} Did not recognize input, try again...${NewLine}"
                echo
            fi
        done
    elif [ ! -d ~/.config/naomi ]; then
        printf "${Bright_White}This process can take up to 3 hours to complete.${NewLine}"
        printf "${Bright_White}Would you like to continue with the process now or wait for another time?${NewLine}"
        echo
        printf "${Bright_Magenta}  Y${Bright_White})es, I'd like the proceed with the setup.${NewLine}"
        printf "${Bright_Magenta}  N${Bright_White})ope, I will come back at another time.${NewLine}"
        echo
        while true; do
            printf "${B_Blue}Choice [${Bright_Magenta}Y${B_Blue}/${Bright_Magenta}N${B_Blue}]: ${Bright_White}"
            read installChoice
            if [ "$installChoice" = "y" ] || [ "$installChoice" = "Y" ]; then
                printf "${Bright_Magenta}Y ${Bright_White}- Installing Naomi${NewLine}"
                if [ -n "$(command -v apt-get)" ]; then
                    apt_setup_wizard
                elif [ -n "$(command -v yum)" ]; then
                    unknown_os
                else
                    unknown_os
                fi
                break
            elif [ "$installChoice" = "n" ] || [ "$installChoice" = "N" ]; then
                printf "${Bright_Magenta}N ${Bright_White}- Cancelling Install${NewLine}"
                sleep 5
                exec bash $0
            else
                printf "${Bright_Red}Notice:${Bright_White} Did not recognize input, try again...${NewLine}"
                echo
            fi
        done
    fi
}
