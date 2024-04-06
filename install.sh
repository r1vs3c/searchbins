#!/bin/bash

# Author: Juan Rivas (aka @r1vs3c)

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

if [[ $(id -u) -ne 0 ]]; then
    echo -e "\n${redColour}[!] It is necessary to execute the script as root!\n${endColour}"
    exit 1
else
    dependencies=(yq jq)
    for tool in "${dependencies[@]}"; do
        if [[ ! "$(command -v $tool)" ]]; then
            echo -e "\n${blueColour}[+] Installing $tool...\n${endColour}"
            sleep 2
            apt install "$tool" -y
        fi
    done

    if [[ ! -d "/usr/local/share/bins" ]]; then
        echo -e "\n${blueColour}[+] Copying binary files to the path /usr/local/share/bins...\n${endColour}"
        sleep 2
        cp -rv ./bins/ /usr/local/share/bins/
    fi

    if [[ ! "$(command -v searchbins)" ]]; then
        echo -e "\n${blueColour}[+] Copying the script searchbins.sh to the path /usr/local/bin/searchbins...\n${endColour}"
        sleep 2
        cp -v ./searchbins.sh /usr/local/bin/searchbins
    fi

    if [ -d "/usr/local/share/bins" ] && [ "$(command -v searchbins)" ]; then
        echo -e "\n${greenColour}[✔] The tool has been successfully installed. Enjoy :D\n${endColour}"
    fi
fi
