naomi_autoupdate() {
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_Magenta}AutoUpdate ${Bright_White}...${NewLine}"
    printf "${Bright_White}=========================================================================${NewLine}"
    echo
    if [ "$(jq '.auto_update' ~/.config/naomi/configs/.naomi_options.json)" = '"true"' ]; then
        printf "${Bright_White}It looks like you have AutoUpdates '${Bright_Green}Enabled${Bright_White}',${NewLine}"
        printf "${Bright_White}would you like to disabled AutoUpdates?${NewLine}"
        echo
        while true; do
            printf "${B_Blue}Choice [${Bright_Magenta}Y${B_Blue}/${Bright_Magenta}N${B_Blue}]: ${Bright_White}"
            read autoupdateChoice
            if [ "$autoupdateChoice" = "y" ] || [ "$autoupdateChoice" = "Y" ]; then
                cat <<< $(jq '.auto_update = "false"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                printf "${Bright_Magenta}Y ${Bright_White}- AutoUpdate Disabled${NewLine}"
                break
            elif [ "$autoupdateChoice" = "n" ] || [ "$autoupdateChoice" = "N" ]; then
                printf "${Bright_Magenta}N ${Bright_White}- No Change${NewLine}"
                break
            else
                printf "${Bright_Red}Notice:${Bright_White} Did not recognize input, try again...${NewLine}"
                echo
            fi
        done
    elif [ "$(jq '.auto_update' ~/.config/naomi/configs/.naomi_options.json)" = '"false"' ]; then
        printf "${Bright_White}It looks like you have AutoUpdates '${Bright_Green}Disabled${Bright_White}',${NewLine}"
        printf "${Bright_White}would you like to enable AutoUpdates?${NewLine}"
        echo
        while true; do
            printf "${B_Blue}Choice [${Bright_Magenta}Y${B_Blue}/${Bright_Magenta}N${B_Blue}]: ${Bright_White}"
            read autoupdateChoice
            if [ "$autoupdateChoice" = "y" ] || [ "$autoupdateChoice" = "Y" ]; then
                cat <<< $(jq '.auto_update = "true"' ~/.config/naomi/configs/.naomi_options.json) > ~/.config/naomi/configs/.naomi_options.json
                printf "${Bright_Magenta}Y ${Bright_White}- AutoUpdate Enabled${NewLine}"
                break
            elif [ "$autoupdateChoice" = "n" ] || [ "$autoupdateChoice" = "N" ]; then
                printf "${Bright_Magenta}N ${Bright_White}- No Change${NewLine}"
                break
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
