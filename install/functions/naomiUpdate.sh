naomi_update() {
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_Magenta}Update ${Bright_White}...${NewLine}"
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_Red}Notice: ${Bright_White}You are about to manually update Naomi, is that what you want?${NewLine}"
    echo
    while true; do
        printf "${B_Blue}Choice [${Bright_Magenta}Y${B_Blue}/${Bright_Magenta}N${B_Blue}]: ${Bright_White}"
        read updateChoice
        if [ "$updateChoice" = "y" ] || [ "$updateChoice" = "Y" ]; then
            if [ "$(jq '.use_release' ~/.config/naomi/configs/.naomi_options.json)" = '"nightly"' ]; then
                printf "${Bright_Magenta}$key ${Bright_White}- Forcing Update${NewLine}"
                mv ~/Naomi ~/Naomi-Temp
                cd ~
                git clone $gitURL.git -b naomi-dev Naomi
                cd Naomi
                cat <<< $(jq '.version = "Naomi-'$version'.'$gitVersionNumber'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.date = "'$theDateRightNow'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cd ~
                sudo rm -Rf ~/Naomi-Temp
                break
            elif [ "$(jq '.use_release' ~/.config/naomi/configs/.naomi_options.json)" = '"milestone"' ]; then
                printf "${Bright_Magenta}$key ${Bright_White}- Forcing Update${NewLine}"
                mv ~/Naomi ~/Naomi-Temp
                cd ~
                git clone $gitURL.git -b naomi-dev Naomi
                cd Naomi
                cat <<< $(jq '.version = "Naomi-'$version'.'$gitVersionNumber'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.date = "'$theDateRightNow'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cd ~
                sudo rm -Rf ~/Naomi-Temp
                break
            elif [ "$(jq '.use_release' ~/.config/naomi/configs/.naomi_options.json)" = '"stable"' ]; then
                printf "${Bright_Magenta}$key ${Bright_White}- Forcing Update${NewLine}"
                mv ~/Naomi ~/Naomi-Temp
                cd ~
                git clone $gitURL.git -b master Naomi
                cd Naomi
                cat <<< $(jq '.version = "Naomi-'$version'.'$gitVersionNumber'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.date = "'$theDateRightNow'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cd ~
                sudo rm -Rf ~/Naomi-Temp
                break
            else
                printf "${Bright_Red}Notice:${Bright_White} Error finding your Naomi Options file...${NewLine}"
                echo
            fi
        elif [ "$updateChoice" = "n" ] || [ "$updateChoice" = "N" ]; then
            printf "${Bright_Magenta}N ${Bright_White}- Cancelling Update${NewLine}"
            sleep 5
            exec bash $0
        else
            printf "${Bright_Red}Notice:${Bright_White} Error finding your Naomi Options file...${NewLine}"
        fi
    done
    sleep 5
    exec bash $0
}
