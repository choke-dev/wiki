#!/bin/bash
if [[ $UID = 0 ]]
then
    main
else
    echo "Installation script does not have root privilages, Elevating permissions..."
    exec sudo $0 "$@"
    main
fi

Color_Off='\033[0m'       # Text Reset
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
BGreen='\033[1;32m'       # Green
BRed='\033[1;31m'         # Red
On_Purple='\033[45m'      # Purple
On_Blue='\033[44m'        # Blue
On_IYellow='\033[0;103m'  # Yellow

function continue {
  echo -e "\n${On_Green}Synchronizing the package repositories...${Color_Off}\n"
  sudo apt update >/dev/null 2>&1
  sudo apt upgrade -y >/dev/null 2>&1
  echo -e "\n${BGreen}All Package repositories have been updated.${Color_Off}\n"
  echo -e "\n${On_Green}Installing grapejuice dependencies...${Color_Off}\n"
  sudo apt install -y git python3-pip python3-setuptools python3-wheel python3-dev  pkg-config mesa-utils libcairo2-dev gtk-update-icon-cache desktop-file-utils xdg-utils   libgirepository1.0-dev gir1.2-gtk-3.0 gnutls-bin:i386 >/dev/null 2>&1
  echo -e "\n${BGreen}All dependencies installed.${Color_Off}\n"
  echo -e "\n${On_Green}Installing grapejuice...${Color_Off}\n"
  git clone --depth=1 https://gitlab.com/brinkervii/grapejuice.git /tmp/grapejuice >/dev/null 2>&1
  cd /tmp/grapejuice
  python3 ./install.py >/dev/null 2>&1
  echo -e "\n${BGreen}Grapejuice has been successfully installed.${Color_Off}\n"

  echo -e "\n${On_IYellow}Please run grapejuice before continuing.\n"
  read -n 1

  echo -e "\n${On_Green}Installing modified WINE build...${Color_Off}\n"
  cd /tmp
  wget https://pastebin.com/raw/5SeVb005 -O install.py >/dev/null 2>&1
  python3 install.py >/dev/null 2>&1
  echo -e "\n${BGreen}WINE has been installed.${Color_Off}\n"
}

function cancelled {
	echo -e "${On_Red}Installation Cancelled.${Color_Off}"
}

function main {
  echo -n -e "Install ${On_Purple}Grape${On_Blue}juice${Color_Off}? (y/n)? "
  old_stty_cfg=$(stty -g)
  stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty
  if echo "$answer" | grep -iq "^y" ;then
      echo Yes ; continue
  else
      echo No ; cancelled
  fi
}