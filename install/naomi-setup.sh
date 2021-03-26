#!/bin/bash

#########################################
# Determines the OS & Version to direct
# Naomi build process correctly.
#########################################
BLACK='\033[1;30m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
Bright_Cyan='\033[1;96m' #Bright Cyan                           For logo
Bright_Red='\033[1;91m' #Bright Red                            For alerts/errors
Bright_Green='\033[1;92m' #Bright Green                          For initiating a process i.e. "Installing blah blah..." or calling attention to thing in outputs
Bright_Yellow='\033[1;93m' #Bright Yellow                         For urls & emails
B_Black='\033[1;90m' #Bright Black                      For lower text
B_Blue='\033[1;94m' #Bright Blue                        For prompt question
Bright_Magenta='\033[1;95m' #Bright Magenta                        For prompt choices
Bright_White='\033[1;97m' #Bright White                          For standard text output
NewLine="
"
OPTION="0"
SUDO_APPROVE=""
version="3.0"
theDateRightNow=$(date +%m-%d-%Y-%H:%M:%S)
gitVersionNumber=$(git rev-parse --short HEAD)
gitURL="https://github.com/naomiproject/naomi"

source "functions/functions.sh"
source "functions/naomiLogo.sh"
source "functions/naomiInstall.sh"
source "functions/naomiUninstall.sh"
source "functions/aptSetupWizard.sh"
source "functions/yumSetupWizard.sh"
source "functions/naomiAutoUpdate.sh"
source "functions/naomiVersion.sh"


tput reset  #clear the screen
os_detect
curl_check
jq_check
sleep 5
tput reset  #clear the screen


printNaomiLogo


sleep 5

echo

if [ "$1" == "--uninstall" ]; then
	naomi_uninstall
fi

printf "${Bright_White}=========================================================================${NewLine}"
printf "${Bright_White}Welcome to the Naomi Installer. Pick one of the options below to get started:${NewLine}"
echo
printf "${Bright_White}'${Bright_Magenta}Install${Bright_White}':${NewLine}"
printf "${Bright_White}This will fresh install & setup Naomi on your system.${NewLine}"
echo
printf "${Bright_White}'${Bright_Magenta}Uninstall${Bright_White}':${NewLine}"
printf "${Bright_White}This will remove Naomi from your system.${NewLine}"
echo
printf "${Bright_White}'${Bright_Magenta}Update${Bright_White}':${NewLine}"
printf "${Bright_White}This will update Naomi if there is a newer release for your installed version.${NewLine}"
echo
printf "${Bright_White}'${Bright_Magenta}Version${Bright_White}':${NewLine}"
printf "${Bright_White}This will allow you to switch what version of Naomi you have installed.${NewLine}"
echo
printf "${Bright_White}'${Bright_Magenta}AutoUpdate${Bright_White}':${NewLine}"
printf "${Bright_White}This will allow you to enable/disable Naomi auto updates.${NewLine}"
echo
printf "${Bright_White}'${Bright_Magenta}Quit${Bright_White}'${NewLine}"
echo
printf "${B_Blue}Input: ${Bright_White}"
while true; do
    read installerChoice
    if [ "$installerChoice" = "install" ] || [ "$installerChoice" = "INSTALL" ] || [ "$installerChoice" = "Install" ]; then
        naomi_install
        break
    elif [ "$installerChoice" = "uninstall" ] || [ "$installerChoice" = "UNINSTALL" ] || [ "$installerChoice" = "Uninstall" ]; then
        naomi_uninstall
        break
    elif [ "$installerChoice" = "update" ] || [ "$installerChoice" = "UPDATE" ] || [ "$installerChoice" = "Update" ]; then
        naomi_update
        break
    elif [ "$installerChoice" = "version" ] || [ "$installerChoice" = "VERSION" ] || [ "$installerChoice" = "Version" ]; then
        naomi_version
        break
    elif [ "$installerChoice" = "autoupdate" ] || [ "$installerChoice" = "AUTOUPDATE" ] || [ "$installerChoice" = "AutoUpdate" ] || [ "$installerChoice" = "Autoupdate" ] || [ "$installerChoice" = "autoUpdate" ]; then
        naomi_autoupdate
        break
    elif [ "$installerChoice" = "quit" ] || [ "$installerChoice" = "QUIT" ] || [ "$installerChoice" = "Quit" ]; then
        echo "EXITING"
        exit 1
    else
        printf "${Bright_Red}Notice:${Bright_White} Did not recognize input, try again...${NewLine}"
        echo
        printf "${B_Blue}Input: ${Bright_White}"
    fi
done
