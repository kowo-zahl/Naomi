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
