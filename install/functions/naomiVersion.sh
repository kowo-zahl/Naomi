naomi_version() {
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_Magenta}Version ${Bright_White}...${NewLine}"
    printf "${Bright_White}=========================================================================${NewLine}"
    echo
    if [ "$(jq '.use_release' ~/.config/naomi/configs/.naomi_options.json)" = '"stable"' ]; then
        printf "${Bright_White}It looks like you are using '${Bright_Green}Stable${Bright_White}',${NewLine}"
        printf "${Bright_White}would you like to change versions?${NewLine}"
        echo
        while true; do
            printf "${B_Blue}Choice [${Bright_Magenta}Milestone${B_Blue} or ${Bright_Magenta}Nightly${B_Blue} or ${Bright_Magenta}Quit${B_Blue}]: ${Bright_White}"
            read versionChoice
            if [ "$versionChoice" = "Milestone" ] || [ "$versionChoice" = "MILESTONE" ] || [ "$versionChoice" = "milestone" ]; then
                mv ~/Naomi ~/Naomi-Temp
                cd ~
                git clone $gitURL.git -b naomi-dev Naomi
                cd Naomi
                cat <<< $(jq '.use_release = "milestone"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.version = "Naomi-'$version'.'$gitVersionNumber'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.date = "'$theDateRightNow'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                printf "${Bright_Magenta}Milestone ${Bright_White}- Version Changed${NewLine}"
                sudo rm -Rf ~/Naomi-Temp
                break
            elif [ "$versionChoice" = "Nightly" ] || [ "$versionChoice" = "NIGHTLY" ] || [ "$versionChoice" = "nightly" ]; then
                mv ~/Naomi ~/Naomi-Temp
                cd ~
                git clone $gitURL.git -b naomi-dev Naomi
                cd Naomi
                cat <<< $(jq '.use_release = "nightly"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.version = "Naomi-'$version'.'$gitVersionNumber'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.date = "'$theDateRightNow'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.auto_update = "true"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                printf "${Bright_Magenta}Nightly ${Bright_White}- Version Changed${NewLine}"
                sudo rm -Rf ~/Naomi-Temp
                break
            elif [ "$versionChoice" = "Quit" ] || [ "$versionChoice" = "QUIT" ] || [ "$versionChoice" = "quit" ]; then
                printf "${Bright_Magenta}Quit ${Bright_White}- Cancelling Version Change${NewLine}"
                sleep 5
                exec bash $0
            else
                printf "${Bright_Red}Notice:${Bright_White} Did not recognize input, try again...${NewLine}"
                echo
            fi
        done
    elif [ "$(jq '.use_release' ~/.config/naomi/configs/.naomi_options.json)" = '"milestone"' ]; then
        printf "${Bright_White}It looks like you are using '${Bright_Green}Milestone${Bright_White}',${NewLine}"
        printf "${Bright_White}would you like to change versions?${NewLine}"
        echo
        while true; do
            printf "${B_Blue}Choice [${Bright_Magenta}Stable${B_Blue} or ${Bright_Magenta}Nightly${B_Blue} or ${Bright_Magenta}Quit${B_Blue}]: ${Bright_White}"
            read versionChoice
            if [ "$versionChoice" = "Stable" ] || [ "$versionChoice" = "STABLE" ] || [ "$versionChoice" = "stable" ]; then
                mv ~/Naomi ~/Naomi-Temp
                cd ~
                git clone $gitURL.git -b master Naomi
                cd Naomi
                cat <<< $(jq '.use_release = "stable"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.version = "Naomi-'$version'.'$gitVersionNumber'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.date = "'$theDateRightNow'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                printf "${Bright_Magenta}Stable ${Bright_White}- Version Changed${NewLine}"
                sudo rm -Rf ~/Naomi-Temp
                break
            elif [ "$versionChoice" = "Nightly" ] || [ "$versionChoice" = "NIGHTLY" ] || [ "$versionChoice" = "nightly" ]; then
                mv ~/Naomi ~/Naomi-Temp
                cd ~
                git clone $gitURL.git -b naomi-dev Naomi
                cd Naomi
                cat <<< $(jq '.use_release = "nightly"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.version = "Naomi-'$version'.'$gitVersionNumber'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.date = "'$theDateRightNow'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.auto_update = "true"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                printf "${Bright_Magenta}Nightly ${Bright_White}- Version Changed${NewLine}"
                sudo rm -Rf ~/Naomi-Temp
                break
            elif [ "$versionChoice" = "Quit" ] || [ "$versionChoice" = "QUIT" ] || [ "$versionChoice" = "quit" ]; then
                printf "${Bright_Magenta}Quit ${Bright_White}- Cancelling Version Change${NewLine}"
                sleep 5
                exec bash $0
            else
                printf "${Bright_Red}Notice:${Bright_White} Did not recognize input, try again...${NewLine}"
                echo
            fi
        done
    elif [ "$(jq '.use_release' ~/.config/naomi/configs/.naomi_options.json)" = '"nightly"' ]; then
        printf "${Bright_White}It looks like you are using '${Bright_Green}Nightly${Bright_White}',${NewLine}"
        printf "${Bright_White}would you like to change versions?${NewLine}"
        echo
        while true; do
            printf "${B_Blue}Choice [${Bright_Magenta}Stable${B_Blue} or ${Bright_Magenta}Milestone${B_Blue} or ${Bright_Magenta}Quit${B_Blue}]: ${Bright_White}"
            read versionChoice
            if [ "$versionChoice" = "Stable" ] || [ "$versionChoice" = "STABLE" ] || [ "$versionChoice" = "stable" ]; then
                mv ~/Naomi ~/Naomi-Temp
                cd ~
                git clone $gitURL.git -b master Naomi
                cd Naomi
                cat <<< $(jq '.use_release = "stable"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.version = "Naomi-'$version'.'$gitVersionNumber'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.date = "'$theDateRightNow'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                printf "${Bright_Magenta}Stable ${Bright_White}- Version Changed${NewLine}"
                sudo rm -Rf ~/Naomi-Temp
                break
            elif [ "$versionChoice" = "Milestone" ] || [ "$versionChoice" = "MILESTONE" ] || [ "$versionChoice" = "milestone" ]; then
                mv ~/Naomi ~/Naomi-Temp
                cd ~
                git clone $gitURL.git -b naomi-dev Naomi
                cd Naomi
                cat <<< $(jq '.use_release = "milestone"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.version = "Naomi-'$version'.'$gitVersionNumber'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                cat <<< $(jq '.date = "'$theDateRightNow'"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                printf "${Bright_Magenta}Milestone ${Bright_White}- Version Changed${NewLine}"
                sudo rm -Rf ~/Naomi-Temp
                break
            elif [ "$versionChoice" = "Quit" ] || [ "$versionChoice" = "QUIT" ] || [ "$versionChoice" = "quit" ]; then
                printf "${Bright_Magenta}Quit ${Bright_White}- Cancelling Version Change${NewLine}"
                sleep 5
                exec bash $0
            else
                printf "${Bright_Red}Notice:${Bright_White} Did not recognize input, try again...${NewLine}"
                echo
            fi
        done
    else
        printf "${Bright_Red}Notice:${Bright_White} Error finding your Naomi Options file...${NewLine}"
    fi
    sleep 5
    exec bash $0
}
