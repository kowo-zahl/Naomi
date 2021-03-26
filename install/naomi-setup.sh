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

CONTINUE() {
    read -n1 -p "Press 'q' to quit, any other key to continue: " CONTINUE
    echo
    if [ "$CONTINUE" = "q" ] || [ "$CONTINUE" = "Q" ]; then
        echo "EXITING"
        exit 1
    fi
}
quit() {
    read -n1 -p "Press 'q' to quit, any other key to continue: " CONTINUE
    echo
    if [ "$CONTINUE" = "q" ] || [ "$CONTINUE" = "Q" ]; then
        echo "EXITING"
        exit 1
    else
        exec bash $0
    fi
}
SUDO_COMMAND() {
    echo
    printf "${Bright_Red}Notice:${Bright_White} this program is about to use sudo to run the following command:${NewLine}"
    printf "[$(pwd)]\$ ${Bright_Green}${1}${Bright_White}${NewLine}"
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
unknown_os () {
  printf "${Bright_Red}Notice:${Bright_White} Unfortunately, your operating system distribution and version are not supported by this script at this time.${NewLine}"
  echo
  printf "${Bright_Red}Notice:${Bright_White} You can find a list of supported OSes and distributions on our website: ${Bright_Yellow}https://projectnaomi.com/dev/docs/installation/${NewLine}"
  echo
  printf "${Bright_Red}Notice:${Bright_White} Please join our Discord or email us at ${Bright_Yellow}contact@projectnaomi.com${Bright_White} and let us know if you run into any issues.${NewLine}"
  exit 1
}
os_detect () {
  if [[ ( -z "${os}" ) && ( -z "${dist}" ) ]]; then
    # some systems dont have lsb-release yet have the lsb_release binary and
    # vice-versa
    if [ -e /etc/lsb-release ]; then
      . /etc/lsb-release

      if [ "${ID}" = "raspbian" ]; then
        os=${ID}
        dist=`cut --delimiter='.' -f1 /etc/debian_version`
      else
        os=${DISTRIB_ID}
        dist=${DISTRIB_CODENAME}

        if [ -z "$dist" ]; then
          dist=${DISTRIB_RELEASE}
        fi
      fi

    elif [ `which lsb_release 2>/dev/null` ]; then
      dist=`lsb_release -c | cut -f2`
      os=`lsb_release -i | cut -f2 | awk '{ print tolower($1) }'`

    elif [ -e /etc/debian_version ]; then
      # some Debians have jessie/sid in their /etc/debian_version
      # while others have '6.0.7'
      os=`cat /etc/issue | head -1 | awk '{ print tolower($1) }'`
      if grep -q '/' /etc/debian_version; then
        dist=`cut --delimiter='/' -f1 /etc/debian_version`
      else
        dist=`cut --delimiter='.' -f1 /etc/debian_version`
      fi

    elif [ -e /etc/os-release ]; then
      . /etc/os-release
      os=${ID}
      if [ "${os}" = "poky" ]; then
        dist=`echo ${VERSION_ID}`
      elif [ "${os}" = "sles" ]; then
        dist=`echo ${VERSION_ID}`
      elif [ "${os}" = "opensuse" ]; then
        dist=`echo ${VERSION_ID}`
      elif [ "${os}" = "opensuse-leap" ]; then
        os=opensuse
        dist=`echo ${VERSION_ID}`
      else
        dist=`echo ${VERSION_ID} | awk -F '.' '{ print $1 }'`
      fi

      elif [ `which lsb_release 2>/dev/null` ]; then
        # get major version (e.g. '5' or '6')
        dist=`lsb_release -r | cut -f2 | awk -F '.' '{ print $1 }'`

        # get os (e.g. 'centos', 'redhatenterpriseserver', etc)
        os=`lsb_release -i | cut -f2 | awk '{ print tolower($1) }'`

      elif [ -e /etc/oracle-release ]; then
        dist=`cut -f5 --delimiter=' ' /etc/oracle-release | awk -F '.' '{ print $1 }'`
        os='ol'

      elif [ -e /etc/fedora-release ]; then
        dist=`cut -f3 --delimiter=' ' /etc/fedora-release`
        os='fedora'

      elif [ -e /etc/redhat-release ]; then
        os_hint=`cat /etc/redhat-release  | awk '{ print tolower($1) }'`
        if [ "${os_hint}" = "centos" ]; then
          dist=`cat /etc/redhat-release | awk '{ print $3 }' | awk -F '.' '{ print $1 }'`
          os='centos'
        elif [ "${os_hint}" = "scientific" ]; then
          dist=`cat /etc/redhat-release | awk '{ print $4 }' | awk -F '.' '{ print $1 }'`
          os='scientific'
        else
          dist=`cat /etc/redhat-release  | awk '{ print tolower($7) }' | cut -f1 --delimiter='.'`
          os='redhatenterpriseserver'
        fi

    else
      unknown_os
    fi
  fi

  if [[ ( -z "${os}" ) || ( -z "${dist}" ) ]]; then
    unknown_os
  fi

  # remove whitespace from OS and dist name
  os="${os// /}"
  dist="${dist// /}"

  printf "${Bright_White}Detected operating system as $os/$dist.${NewLine}"
}
curl_check () {
  printf "${Bright_White}Checking for curl...${NewLine}"
  if command -v curl > /dev/null; then
    printf "${Bright_White}Detected curl...${NewLine}"
  else
    printf "${Bright_Green}Installing curl...${NewLine}"
    if [ -n "$(command -v yum)" ]; then
	  printf "${Bright_White}yum found${NewLine}"
      SUDO_COMMAND "yum install -d0 -e0 -y curl"
      if [ "$?" -ne "0" ]; then
        printf "${Bright_Red}Notice:${Bright_White} Unable to install curl! Your base system has a problem; please check your default OS's package repositories because curl should work.${NewLine}"
        printf "${Bright_Red}Notice:${Bright_White} Curl installation aborted.${NewLine}"
        exit 1
      fi
    elif [ -n "$(command -v apt-get)" ]; then
	  printf "${Bright_White}apt found${NewLine}"
      SUDO_COMMAND "sudo apt-get install -q -y curl"
      if [ "$?" -ne "0" ]; then
        printf "${Bright_Red}Notice:${Bright_White} Unable to install curl! Your base system has a problem; please check your default OS's package repositories because curl should work.${NewLine}"
        printf "${Bright_Red}Notice:${Bright_White} Curl installation aborted.${NewLine}"
        exit 1
      fi
    else
      printf "${Bright_Red}Notice:${Bright_White} Neither yum nor apt-get found${NewLine}"
      printf "${Bright_Red}Notice:${Bright_White} Unable to install curl! Your base system has a problem; please check your default OS's package repositories because curl should work.${NewLine}"
      printf "${Bright_Red}Notice:${Bright_White} Curl installation aborted.${NewLine}"
      exit 1
    fi
  fi
}
jq_check () {
  printf "${Bright_White}Checking for jq...${NewLine}"
  if command -v jq > /dev/null; then
    printf "${Bright_White}Detected jq...${NewLine}"
  else
    printf "${Bright_Green}Installing jq...${NewLine}"
    if [ -n "$(command -v yum)" ]; then
	  printf "${Bright_White}yum found${NewLine}"
      SUDO_COMMAND "yum install -d0 -e0 -y jq"
      if [ "$?" -ne "0" ]; then
        printf "${Bright_Red}Notice:${Bright_White} Unable to install jq! Your base system has a problem; please check your default OS's package repositories because jq should work.${NewLine}"
        printf "${Bright_Red}Notice:${Bright_White} jq installation aborted.${NewLine}"
        exit 1
      fi
    elif [ -n "$(command -v apt-get)" ]; then
	  printf "${Bright_White}apt found${NewLine}"
      SUDO_COMMAND "sudo apt-get install -q -y jq"
      if [ "$?" -ne "0" ]; then
        printf "${Bright_Red}Notice:${Bright_White} Unable to install jq! Your base system has a problem; please check your default OS's package repositories because jq should work.${NewLine}"
        printf "${Bright_Red}Notice:${Bright_White} jq installation aborted.${NewLine}"
        exit 1
      fi
    else
      printf "${Bright_Red}Notice:${Bright_White} Neither yum nor apt-get found${NewLine}"
      printf "${Bright_Red}Notice:${Bright_White} Unable to install jq! Your base system has a problem; please check your default OS's package repositories because jq should work.${NewLine}"
      printf "${Bright_Red}Notice:${Bright_White} jq installation aborted.${NewLine}"
      exit 1
    fi
  fi
}
apt_setup_wizard() {
  if [ ! -f ~/Naomi/README.md ]; then
    echo
    printf "${Bright_Green}Starting Naomi Apt Setup Wizard...${NewLine}${Bright_White}"
    . <( wget -O - "https://installers.projectnaomi.com/script.deb.sh" );
    wget_exit_code=$?
    if [ "$wget_exit_code" = "0" ]; then
      echo
      echo
      echo
      echo
      printf "${Bright_White}=========================================================================${NewLine}"
      echo
      printf "${Bright_White}That's all, installation is complete! All that is left is the profile${NewLine}"
      printf "${Bright_White}population process and after that Naomi will start.${NewLine}"
      echo
      printf "${Bright_White}In the future, to start Naomi type '${Bright_Green}Naomi${Bright_White}' in a terminal${NewLine}"
      echo
      printf "${Bright_White}Please type '${Bright_Green}Naomi --repopulate${Bright_White}' on the prompt below to populate your profile...${NewLine}"
      sudo rm -Rf ~/Naomi-Temp
      # Launch Naomi Population
      cd ~/Naomi
      chmod a+x Naomi.sh
      cd ~
      exec bash
    else
      echo
      printf "${Bright_Red}Notice: ${Bright_White}Naomi Apt Setup Wizard Failed.${NewLine}"
      echo
      exit 1
    fi
  elif [ -f ~/Naomi/README.md ] && [ -f ~/Naomi/installers/script.deb.sh ]; then
    chmod a+x ~/Naomi/installers/script.deb.sh
    bash ~/Naomi/installers/script.deb.sh
    script_exit_code=$?
    if [ "$script_exit_code" = "0" ]; then
      echo
      echo
      echo
      echo
      printf "${Bright_White}=========================================================================${NewLine}"
      echo
      printf "${Bright_White}That's all, installation is complete! All that is left is the profile${NewLine}"
      printf "${Bright_White}population process and after that Naomi will start.${NewLine}"
      echo
      printf "${Bright_White}In the future, to start Naomi type '${Bright_Green}Naomi${Bright_White}' in a terminal${NewLine}"
      echo
      printf "${Bright_White}Please type '${Bright_Green}Naomi --repopulate${Bright_White}' on the prompt below to populate your profile...${NewLine}"
      sudo rm -Rf ~/Naomi-Temp
      # Launch Naomi Population
      cd ~/Naomi
      chmod a+x Naomi.sh
      cd ~
      exec bash
    else
      echo
      printf "${Bright_Red}Notice: ${Bright_White}Naomi Apt Setup Wizard Failed.${NewLine}"
      echo
      exit 1
    fi
  else
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_White}It looks like you have Naomi source in the ${Bright_Green}~/Naomi${Bright_White} directory,${NewLine}"
    printf "${Bright_White}however it looks to be out of date. Please update or remove the Naomi${NewLine}"
    printf "${Bright_White}source and try running the installer again.${NewLine}"
    echo
    printf "${Bright_White}Please join our Discord or email us at ${Bright_Yellow}contact@projectnaomi.com${Bright_White} and let us know if you run into any issues.${NewLine}"
    exit 1
  fi
}
yum_setup_wizard() {
  if [ ! -f ~/Naomi/README.md ]; then
    echo
    echo
    echo
    echo
    printf "${Bright_Green}Starting Naomi Yum Setup Wizard...${NewLine}${Bright_White}"
    . <( wget -O - "https://installers.projectnaomi.com/script.rpm.sh" );
    wget_exit_code=$?
    if [ "$wget_exit_code" = "0" ]; then
      echo
      echo
      echo
      echo
      printf "${Bright_White}=========================================================================${NewLine}"
      echo
      printf "${Bright_White}That's all, installation is complete! All that is left is the profile${NewLine}"
      printf "${Bright_White}population process and after that Naomi will start.${NewLine}"
      echo
      printf "${Bright_White}In the future, to start Naomi type '${Bright_Green}Naomi${Bright_White}' in a terminal${NewLine}"
      echo
      printf "${Bright_White}Please type '${Bright_Green}Naomi --repopulate${Bright_White}' on the prompt below to populate your profile...${NewLine}"
      sudo rm -Rf ~/Naomi-Temp
      # Launch Naomi Population
      cd ~/Naomi
      chmod a+x Naomi.sh
      cd ~
      exec bash
    else
      echo
      printf "${Bright_Red}Notice: ${Bright_White}Naomi Yum Setup Wizard Failed.${NewLine}"
      echo
      exit 1
    fi
  elif [ -f ~/Naomi/README.md ] && [ -f ~/Naomi/installers/script.rpm.sh ]; then
    chmod a+x ~/Naomi/installers/script.rpm.sh
    bash ~/Naomi/installers/script.rpm.sh
    script_exit_code=$?
    if [ "$script_exit_code" = "0" ]; then
      echo
      echo
      echo
      echo
      printf "${Bright_White}=========================================================================${NewLine}"
      echo
      printf "${Bright_White}That's all, installation is complete! All that is left is the profile${NewLine}"
      printf "${Bright_White}population process and after that Naomi will start.${NewLine}"
      echo
      printf "${Bright_White}In the future, to start Naomi type '${Bright_Green}Naomi${Bright_White}' in a terminal${NewLine}"
      echo
      printf "${Bright_White}Please type '${Bright_Green}Naomi --repopulate${Bright_White}' on the prompt below to populate your profile...${NewLine}"
      sudo rm -Rf ~/Naomi-Temp
      # Launch Naomi Population
      cd ~/Naomi
      chmod a+x Naomi.sh
      cd ~
      exec bash
    else
      echo
      printf "${Bright_Red}Notice: ${Bright_White}Naomi Yum Setup Wizard Failed.${NewLine}"
      echo
      exit 1
    fi
  else
    printf "${Bright_White}=========================================================================${NewLine}"
    printf "${Bright_White}It looks like you have Naomi source in the ${Bright_Green}~/Naomi${Bright_White} directory,${NewLine}"
    printf "${Bright_White}however it looks to be out of date. Please update or remove the Naomi${NewLine}"
    printf "${Bright_White}source and try running the installer again.${NewLine}"
    echo
    printf "${Bright_White}Please join our Discord or email us at ${Bright_Yellow}contact@projectnaomi.com${Bright_White} and let us know if you run into any issues.${NewLine}"
    exit 1
  fi
}
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

tput reset
os_detect
curl_check
jq_check
sleep 5
tput reset

echo
printf "${Bright_Cyan}      ___           ___           ___           ___                  ${NewLine}"
printf "${Bright_Cyan}     /\__\         /\  \         /\  \         /\__\          ___    ${NewLine}"
printf "${Bright_Cyan}    /::|  |       /::\  \       /::\  \       /::|  |        /\  \   ${NewLine}"
printf "${Bright_Cyan}   /:|:|  |      /:/\:\  \     /:/\:\  \     /:|:|  |        \:\  \  ${NewLine}"
printf "${Bright_Cyan}  /:/|:|  |__   /::\~\:\  \   /:/  \:\  \   /:/|:|__|__      /::\__\ ${NewLine}"
printf "${Bright_Cyan} /:/ |:| /\__\ /:/\:\ \:\__\ /:/__/ \:\__\ /:/ |::::\__\  __/:/\/__/ ${NewLine}"
printf "${Bright_Cyan} \/__|:|/:/  / \/__\:\/:/  / \:\  \ /:/  / \/__/~~/:/  / /\/:/  /    ${NewLine}"
printf "${Bright_Cyan}     |:/:/  /       \::/  /   \:\  /:/  /        /:/  /  \::/__/     ${NewLine}"
printf "${Bright_Cyan}     |::/  /        /:/  /     \:\/:/  /        /:/  /    \:\__\     ${NewLine}"
printf "${Bright_Cyan}     /:/  /        /:/  /       \::/  /        /:/  /      \/__/     ${NewLine}"
printf "${Bright_Cyan}     \/__/         \/__/         \/__/         \/__/                 ${NewLine}"

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
