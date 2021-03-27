#!/bin/bash

#########################################
# Installs python and necessary packages
# for deb based Naomi. This script will install python
# into the ~/.config/naomi/local/bin directory and
# install naomi & requirements in their
# respective directories.
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
Bright_Black='\033[1;90m' #Bright Black                      For lower text
Bright_Blue='\033[1;94m' #Bright Blue                        For prompt question
Bright_Magenta='\033[1;95m' #Bright Magenta                        For prompt choices
Bright_White='\033[1;97m' #Bright White                          For standard text output
NewLine="
"
OPTION="0"
SUDO_APPROVE=""
REQUIRE_AUTH=""
version="3.0"
theDateRightNow=$(date +%m-%d-%Y-%H:%M:%S)
gitVersionNumber=$(git rev-parse --short HEAD)
gitURL="https://github.com/naomiproject/naomi"

source "functions/virtualEnv.sh"
source "functions/createMenuEntry.sh"
source "functions/aptSetupFunctions.sh"
source "functions/createNaomiSh.sh"
source "functions/openfst.sh"
source "functions/mitlm.sh"
source "functions/cmuclmtk.sh"
source "functions/phonetisaurus.sh"
source "functions/sphinxBase.sh"
source "functions/pocketSphinx.sh"


setup_wizard() {
    echo
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_White}DEB SETUP WIZARD${NewLine}"
    printf "${Bright_White}This process will first walk you through setting up your device,${NewLine}"
    printf "${Bright_White}installing Naomi, and default plugins.${NewLine}"
    echo
    sleep 3
    echo
    echo

    echo
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_White}LOCALIZATION SETUP:${NewLine}"
    printf "${Bright_White}Let's examine your localization settings.${NewLine}"
    echo
    sleep 3
    echo

    echo
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_White}SECURITY SETUP:${NewLine}"
    printf "${Bright_White}Let's examine a few security settings.${NewLine}"
    echo
    printf "${Bright_White}By default, Naomi is configured to require a password to perform actions as${NewLine}"
    printf "${Bright_White}root (e.g. 'sudo ...') as well as confirm commands before continuing.${NewLine}"
    printf "${Bright_White}This means you will have to watch the setup process to confirm everytime a new${NewLine}"
    printf "${Bright_White}command needs to run.${NewLine}"
    echo
    printf "${Bright_White}However you can enable Naomi to continue the process uninterrupted for a hands off experience${NewLine}"
    echo
    printf "${Bright_White}Would you like the setup to run uninterrupted or would you like to look over the setup process?${NewLine}"
    echo
    printf "${Bright_Magenta}  1${Bright_White}) Allow the process to run uninterrupted${NewLine}"
    printf "${Bright_Magenta}  2${Bright_White}) Require authentication to continue and run commands${NewLine}"
    printf "${B_Blue}Choice [${Bright_Magenta}1${B_Blue}-${Bright_Magenta}2${B_Blue}]: ${Bright_White}"
    while true; do
        read -N1 -s key
        case $key in
         [1])
            printf "${Bright_Magenta}$key ${Bright_White}- Proceeding uninterrupted${NewLine}"
            REQUIRE_AUTH="0"
            SUDO_APPROVE="-y"
            break
            ;;
         [2])
            printf "${Bright_Magenta}$key ${Bright_White}- Requiring authentication${NewLine}"
            REQUIRE_AUTH="1"
            SUDO_APPROVE=""
            break
            ;;
        esac
    done
    echo
    echo
    echo

    echo
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_White}ENVIRONMENT SETUP:${NewLine}"
    printf "${Bright_White}Now setting up the file stuctures & requirements${NewLine}"
    echo
    sleep 3
    echo

    # Create basic folder structures
    echo
    printf "${Bright_Green}Creating File Structure...${Bright_White}${NewLine}"
    mkdir -p ~/.config/naomi/
    mkdir -p ~/.config/naomi/configs/
    mkdir -p ~/.config/naomi/scripts/
    mkdir -p ~/.config/naomi/sources/

    
    # make sure the git command is working
    GIT
    
    
    # Download and setup Naomi Dev repo as default
    echo
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_White}NAOMI SETUP:${NewLine}"
    printf "${Bright_White}Naomi is continuously updated. There are three options to choose from:${NewLine}"
    echo
    printf "${Bright_White}'${Bright_Green}Stable${Bright_White}' versions are thoroughly tested official releases of Naomi. Use${NewLine}"
    printf "${Bright_White}the stable version for your production environment if you don't need the${NewLine}"
    printf "${Bright_White}latest enhancements and prefer a robust system${NewLine}"
    echo
    printf "${Bright_White}'${Bright_Green}Milestone${Bright_White}' versions are intermediary releases of the next Naomi version,${NewLine}"
    printf "${Bright_White}released about once a month, and they include the new recently added${NewLine}"
    printf "${Bright_White}features and bugfixes. They are a good compromise between the current${NewLine}"
    printf "${Bright_White}stable version and the bleeding-edge and potentially unstable nightly version.${NewLine}"
    echo
    printf "${Bright_White}'${Bright_Green}Nightly${Bright_White}' versions are at most 1 or 2 days old and include the latest code.${NewLine}"
    printf "${Bright_White}Use nightly for testing out very recent changes, but be aware some nightly${NewLine}"
    printf "${Bright_White}versions might be unstable. Use in production at your own risk!${NewLine}"
    echo
    printf "${Bright_White}Note: '${Bright_Green}Nightly${Bright_White}' comes with automatic updates by default!${NewLine}"
    echo
    printf "${Bright_Magenta}  1${Bright_White}) Use the recommended ('${Bright_Green}Stable${Bright_White}')${NewLine}"
    printf "${Bright_Magenta}  2${Bright_White}) Monthly releases sound good to me ('${Bright_Green}Milestone${Bright_White}')${NewLine}"
    printf "${Bright_Magenta}  3${Bright_White}) I'm a developer or want the cutting edge, put me on '${Bright_Green}Nightly${Bright_White}'${NewLine}"
    printf "${B_Blue}Choice [${Bright_Magenta}1${B_Blue}-${Bright_Magenta}3${B_Blue}]: ${Bright_White}"
    while true; do
        read -N1 -s key
        case $key in
         1)
            printf "${Bright_Magenta}$key ${Bright_White}- Easy Peasy!${NewLine}"
            cd ~
            if [ ! -f ~/Naomi/README.md ]; then
              printf "${Bright_Green}Downloading 'Naomi'...${Bright_White}${NewLine}"
              cd ~
              git clone $gitURL.git -b master Naomi
              cd Naomi
              echo '{"use_release":"stable", "branch":"master", "version":"Naomi-'$version'.'$gitVersionNumber'", "date":"'$theDateRightNow'", "auto_update":"false"}' > ~/.config/naomi/configs/.naomi_options.json
              cd ~
            else
              mv ~/Naomi ~/Naomi-Temp
              cd ~
              git clone $gitURL.git -b master Naomi
              cd Naomi
              echo '{"use_release":"stable", "branch":"master", "version":"Naomi-'$version'.'$gitVersionNumber'", "date":"'$theDateRightNow'", "auto_update":"false"}' > ~/.config/naomi/configs/.naomi_options.json
              cd ~
            fi
            break
            ;;
         2)
            printf "${Bright_Magenta}$key ${Bright_White}- Good Choice!${NewLine}"
            echo '{"use_release":"milestone", "branch":"naomi-dev", "version":"Naomi-'$version'.'$gitVersionNumber'", "date":"'$theDateRightNow'", "auto_update":"false"}' > ~/.config/naomi/configs/.naomi_options.json
            cd ~
            if [ ! -f ~/Naomi/README.md ]; then
              printf "${Bright_Green}Downloading 'Naomi'...${Bright_White}${NewLine}"
              cd ~
              git clone $gitURL.git -b naomi-dev Naomi
              cd Naomi
              echo '{"use_release":"milestone", "branch":"naomi-dev", "version":"Naomi-'$version'.'$gitVersionNumber'", "date":"'$theDateRightNow'", "auto_update":"false"}' > ~/.config/naomi/configs/.naomi_options.json
              cd ~
            else
              mv ~/Naomi ~/Naomi-Temp
              cd ~
              git clone $gitURL.git -b naomi-dev Naomi
              cd Naomi
              echo '{"use_release":"milestone", "branch":"naomi-dev", "version":"Naomi-'$version'.'$gitVersionNumber'", "date":"'$theDateRightNow'", "auto_update":"false"}' > ~/.config/naomi/configs/.naomi_options.json
              cd ~
            fi
            break
            ;;
         3)
            printf "${Bright_Magenta}$key ${Bright_White}- You know what you are doing!${NewLine}"
            cd ~
            if [ ! -f ~/Naomi/README.md ]; then
              printf "${Bright_Green}Downloading 'Naomi'...${Bright_White}${NewLine}"
              cd ~
              git clone $gitURL.git -b naomi-dev Naomi
              cd Naomi
              echo '{"use_release":"nightly", "branch":"naomi-dev", "version":"Naomi-'$version'.'$gitVersionNumber'", "date":"'$theDateRightNow'", "auto_update":"true"}' > ~/.config/naomi/configs/.naomi_options.json
              cd ~
            else
              mv ~/Naomi ~/Naomi-Temp
              cd ~
              git clone $gitURL.git -b naomi-dev Naomi
              cd Naomi
              echo '{"use_release":"nightly", "branch":"naomi-dev", "version":"Naomi-'$version'.'$gitVersionNumber'", "date":"'$theDateRightNow'", "auto_update":"true"}' > ~/.config/naomi/configs/.naomi_options.json
              cd ~
            fi
            break
            ;;
         S)
            printf "${Bright_Magenta}$key ${Bright_White}- Skipping Section${NewLine}"
            echo '{"use_release":"testing", "version":"Naomi-Development", "version":"Development", "date":"'$theDateRightNow'", "auto_update":"false"}' > ~/.config/naomi/configs/.naomi_options.json
            break
            ;;
        esac
    done
    echo
    echo

    find ~/Naomi -maxdepth 1 -iname '*.py' -type f -exec chmod a+x {} \;
    find ~/Naomi -maxdepth 1 -iname '*.sh' -type f -exec chmod a+x {} \;
    find ~/Naomi/installers -maxdepth 1 -iname '*.sh' -type f -exec chmod a+x {} \;

    NAOMI_DIR="$(cd ~/Naomi && pwd)"

    cd ~/Naomi
    APT=1
    if [ $APT -eq 1 ]; then
      if [ $REQUIRE_AUTH -eq 1 ]; then
        SUDO_COMMAND "sudo apt-get update"
        SUDO_COMMAND "sudo apt upgrade $SUDO_APPROVE"
        SUDO_COMMAND "sudo ./naomi_apt_requirements.sh $SUDO_APPROVE"
        if [ $? -ne 0 ]; then
          printf "${Bright_Red}Notice:${Bright_White} Error installing apt packages${NewLine}" >&2
          exit 1
        fi
      else
        printf "${Bright_White}${NewLine}"
        sudo apt-get update
        sudo apt upgrade $SUDO_APPROVE
        sudo ./naomi_apt_requirements.sh $SUDO_APPROVE
        if [ $? -ne 0 ]; then
          printf "${Bright_Red}Notice:${Bright_White} Error installing apt packages${NewLine}" >&2
          exit 1
        fi
      fi      
    else
      ERROR=""
      if [[ $(CHECK_PROGRAM msgfmt) -ne "0" ]]; then
        ERROR="${ERROR} ${Bright_Red}Notice:${Bright_White} gettext program msgfmt not found${NewLine}"
      fi
      if [[ $(CHECK_HEADER portaudio.h) -ne "0" ]]; then
        ERROR="${ERROR} ${Bright_Red}Notice:${Bright_White} portaudio development file portaudio.h not found${NewLine}"
      fi
      if [[ $(CHECK_HEADER asoundlib.h) -ne "0" ]]; then
        ERROR="${ERROR} ${Bright_Red}Notice:${Bright_White} libasound development file asoundlib.h not found${NewLine}"
      fi
      if [[ $(CHECK_PROGRAM python3) -ne "0" ]]; then
        ERROR="${ERROR} ${Bright_Red}Notice:${Bright_White} python3 not found${NewLine}"
      fi
      if [[ $(CHECK_PROGRAM pip3) -ne "0" ]]; then
        ERROR="${ERROR} ${Bright_Red}Notice:${Bright_White} pip3 not found${NewLine}"
      fi
      if [ ! -z "$ERROR" ]; then
        printf "${Bright_Red}Notice:${Bright_White} Missing dependencies:${NewLine}${NewLine}$ERROR"
        CONTINUE
      fi
    fi

    # make sure pulseaudio is running
    pulseaudio --check
    if [ $? -ne 0 ]; then
      pulseaudio -D
    fi

    
    virtualEnv
    
    # start the naomi setup process
    printf "${Bright_White}${NewLine}"
    echo
    echo
    
    # writing Naomi into .bashrc 
    echo '' >> ~/.bashrc
    echo '' >> ~/.bashrc
    echo '' >> ~/.bashrc
    echo '######################################################################' >> ~/.bashrc
    echo '# Initialize Naomi to start on command' >> ~/.bashrc
    echo '######################################################################' >> ~/.bashrc
    echo 'source ~/Naomi/Naomi.sh' >> ~/.bashrc
    echo
    echo

    createMenuEntry
    
    createNaomiSh

    find ~/Naomi -maxdepth 1 -iname '*.py' -type f -exec chmod a+x {} \;
    find ~/Naomi -maxdepth 1 -iname '*.sh' -type f -exec chmod a+x {} \;
    find ~/Naomi/installers -maxdepth 1 -iname '*.sh' -type f -exec chmod a+x {} \;

    echo
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_White}PLUGIN SETUP${NewLine}"
    printf "${Bright_White}Now we'll tackle the default plugin options available for Text-to-Speech, Speech-to-Text, and more.${NewLine}"
    echo
    sleep 3
    echo

    # Build Phonetisaurus
    
    openfst

    mitlm
      
    cmuclmtk

    phonetisaurus

    sphinxBase

    pocketSphinx

    cd ~
    echo
    echo
    echo
    echo
}

setup_wizard
