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

# Global variables
bins_url="https://gtfobins.github.io/"

if [ -d "/usr/local/share/bins" ] && [ "$(ls -A /usr/local/share/bins)" ]; then
    bins_path="/usr/local/share/bins"
else
    bins_path="./bins"
fi

functions_file="$bins_path/data/functions.json"

# Ctrl + C
trap ctrl_c SIGINT

function ctrl_c(){
    echo -e "\n\n${redColour}[!] Exiting...${endColour}\n"
    exit 1
}

function banner(){
echo -e "${blueColour}____ ____ ____ ____ ____ _  _ ___  _ _  _ ____${endColour}"
echo -e "${purpleColour}[__  |___ |__| |__/ |    |__| |__] | |\ | [__${endColour}${grayColour}"
echo -e "${turquoiseColour}___] |___ |  | |  \ |___ |  | |__] | | \| ___]${endColour}${grayColour}  by Juan Rivas ${endColour}${yellowColour}(@r1vs3c)${endColour}"
}

function helpPanel(){
    banner
    echo -e "\n${redColour}[!] Use: searchbins ${endColour}"
    for i in $(seq 1 80); do echo -ne "${redColour}="; done; echo -ne "${endColour}"
    echo -e "\n\t${yellowColour}[-b]${endColour}${blueColour} Binary to enumerate${endColour}"
    echo -e "\t\t${greenColour}Example: searchbins -b docker${endColour}"
    echo -e "\n\t${yellowColour}[-f]${endColour}${blueColour} Specific function of the binary or binaries${endColour}"
    echo -e "\t\t${greenColour}Example: searchbins -b docker -f shell${endColour}"
    echo -e "\n\t${yellowColour}[-a]${endColour}${blueColour} All available functions of the binary${endColour}"
    echo -e "\t\t${greenColour}Example: searchbins -b docker -a${endColour}"
    echo -e "\n\t${yellowColour}[-l]${endColour}${blueColour} List all available binaries or functions ${endColour}"
    echo -e "\t\t${greenColour}Example: searchbins -l <bins/functions>${endColour}"
    echo -e "\t\t${greenColour}         searchbins -l bins -f suid${endColour}"
    echo -e "\n\t${yellowColour}[-s]${endColour}${blueColour} File to search for binaries ${endColour}"
    echo -e "\t\t${greenColour}Example: searchbins -s <path_to_file>${endColour}"
    echo -e "\n\t${yellowColour}[-h]${endColour}${blueColour} Show this panel${endColour}"
}

function check_dependencies(){
    if [[ ! "$(command -v jq)" ]]; then
        while true; do
	    echo -en "\n${redColour}[!] You need to install the jq tool to run the script. Do you want to install it now? ([y]/n) ${endColour}"
	    read -r
	    REPLY=${REPLY:-"y"}
	    if [[ $REPLY =~ ^[Yy]$ ]]; then
	        echo -e "\n${blueColour}[+] Installing jq...${endColour}\n"
		sleep 1
		sudo apt install jq
                exit 0
	    elif [[ $REPLY =~ ^[Nn]$ ]]; then
                echo
		exit 0
	    else
		echo -e "\n${redColour}[!] Invalid response, please try again${endColour}\n"
	    fi
	done
    fi
}

function list_bin_functions(){
    binary=$1
    cat $bins_path/$binary.json | jq ".functions | keys[]" -r
}

function show_bin_functions(){
    binary=$1
    echo -e "\n${blueColour}[+] Binary:${endColour} ${redColour}$binary\n${endColour}"
    echo -e "${blueColour}[*] Functions:${endColour}${grayColour} ->${endColour}${purpleColour} [${bins_url}gtfobins/${binary}]\n${endColour}"
    for funct in $(list_bin_functions "$binary"); do
        number_codes=$(cat $bins_path/$binary.json | jq ".functions.\"$funct\" | keys | length")
        echo -e "\t${purpleColour}[✔]${endColour} ${yellowColour}$funct${endColour}${redColour} ($number_codes)${endColour}"
    done
    echo -e "\n${turquoiseColour}[*] Execute:${endColour}${grayColour} ->${endColour}${greenColour} searchbins -b $1 -f <function>${endColour}${blueColour} (For a specific function)\n${endColour}"
    echo -e "\t${grayColour}     ->${endColour}${greenColour} searchbins -b $1 -a${endColour}${blueColour} (For all available functions)\n${endColour}"
}

function show_codes(){
    binary=$1
    funct=$2

    if list_bin_functions "$binary" | grep -wqoi "$funct"; then
        number_codes=$(cat $bins_path/$binary.json | jq ".functions.\"$funct\" | keys | length")
        echo -e "\n${blueColour}[+] Binary:${endColour} ${redColour}$binary\n${endColour}"
        for i in $(seq 1 80); do echo -ne "${redColour}="; done; echo -ne "${endColour}"
        echo -e "\n${blueColour}[*] Function:${endColour}${redColour} $funct${endColour}${grayColour} ->${endColour}${purpleColour} [${bins_url}gtfobins/${binary}/#${funct}]\n${endColour}"

        for i in $(seq 0 $(($number_codes - 1))); do
            code="$(cat $bins_path/$binary.json| jq ".functions.\"$funct\".[$i].code" -r)"
            description="$(cat $bins_path/$binary.json | jq ".functions.\"$funct\".[$i].description" -r)"
            if [[ "$description" != "null" ]]; then
                echo -e "${grayColour}$description\n${endColour}"
            fi
            echo -ne "${yellowColour}" && echo "$code" | sed 's/^/| /g' | sed 's/^/\t/g' && echo -ne "${endColour}"
            echo
        done
    else
        echo -e "\n${redColour}[✘] The function \"$funct\" is not available for the binary \"$binary\". Execute${endColour}${blueColour} searchbins -b $binary${endColour}${redColour} to list all available functions for the binary.\n${endColour}"
        exit 1
    fi
}

function show_all_codes(){
    binary=$1
    echo -e "\n${blueColour}[+] Binary:${endColour} ${redColour}$binary\n${endColour}"
    for i in $(seq 1 80); do echo -ne "${redColour}="; done; echo -ne "${endColour}"
    echo
    for funct in $(list_bin_functions "$binary"); do
        number_codes=$(cat $bins_path/$binary.json | jq ".functions.\"$funct\" | keys | length")
        echo -e "${blueColour}[*] Function:${endColour}${redColour} $funct${endColour}${grayColour} ->${endColour}${purpleColour} [${bins_url}gtfobins/${binary}/#${funct}]\n${endColour}"

        for i in $(seq 0 $(($number_codes - 1))); do
            code="$(cat $bins_path/$binary.json | jq ".functions.\"$funct\".[$i].code" -r)"
            description="$(cat $bins_path/$binary.json | jq ".functions.\"$funct\".[$i].description" -r)"
            if [[ "$description" != "null" ]]; then
                echo -e "${grayColour}$description\n${endColour}"
            fi
            echo -ne "${yellowColour}" && echo "$code" | sed 's/^/| /g' | sed 's/^/\t/g' && echo -ne "${endColour}"
            echo
        done

        if [[ "$funct" != "$(list_bin_functions $binary | tail -n1)" ]]; then
            for i in $(seq 1 80); do echo -ne "${redColour}="; done; echo -ne "${endColour}"
            echo
        fi
    done
}

function list_all_bins(){
    if [[ $# -eq 0 ]]; then
        ls -lA "$bins_path" | grep -oP '(^| )\K[^ ]+(?=.json)'
    elif [[ $# -eq 1 ]]; then
        funct=$1
        functions="$(cat $bins_path/data/functions.json | jq "keys[]" -r)"
        for bin in $(list_all_bins); do
            if list_bin_functions "$bin" | grep -wqoxi "$funct"; then
                bins+="$bin\n"
            fi
        done
        echo -e "$bins"
    fi
}

function search_file(){
file=$1
counter=0
binaries_to_search=$(cat $file | awk NF{'print $NF'} FS='/' | sort -u)
match_bins=""

for bin in $binaries_to_search; do
    if list_all_bins | grep -wqoi "$bin"; then
        let counter+=1
        match_bins+="$bin\n"
    fi
done

if [[ $counter -eq 0 ]]; then
    echo -e "\n${redColour}[✘] No matches were detected in the file $file\n${endColour}"
    exit 1
else
    echo -e "\n${blueColour}[✔] Matches:${endColour}${greenColour} $(echo -e $match_bins | tr '\n' ',' | head -c-2)\n${endColour}"
    for i in $(seq 1 80); do echo -ne "${redColour}="; done; echo -ne "${endColour}"
    for match_bin in $(echo -e "$match_bins"); do
        show_bin_functions "$match_bin" | head -n-5
        if [[ "$match_bin" != "$(echo -e $match_bins | tail -n2 | head -n1)" ]]; then
            echo
            for i in $(seq 1 80); do echo -ne "${redColour}="; done; echo -ne "${endColour}"
        fi
    done

    echo
fi

}

counter=0
while getopts "b:f:al:s:h" arg; do
    case $arg in
        b) binary=$OPTARG ;;
        f) funct=$OPTARG ;;
        a) let counter+=1 ;;
        l) list=$OPTARG ;;
        d) download_bins ;;
        s) file=$OPTARG ;;
        h) helpPanel; exit 0 ;;
        *) helpPanel; exit 1 ;;
    esac
done

if [[ $# -eq 0 ]]; then
    helpPanel; exit 1
fi

check_dependencies

if [[ "$binary" ]]; then
    if list_all_bins | grep -wqoxi "$binary"; then
        if [ "$funct" ] && [ $counter -eq 1 ]; then
            helpPanel; exit 1
        elif [[ "$funct" ]]; then
            show_codes "$binary" "$funct"
        elif [[ $counter -eq 1 ]]; then
            show_all_codes "$binary"
        elif [[ "$list" ]]; then
            helpPanel; exit 1
        elif [[ "$file" ]] ;then
            helpPanel; exit 1
        else
            show_bin_functions "$binary"
        fi
    else
        echo -e "\n${redColour}[✘] Binary \"$binary\" not found, execute${endColour}${greenColour} searchbins -l bins ${endColour}${redColour}to list available binaries\n${endColour}"
        exit 1
    fi
elif [[ "$list" ]]; then
    if [[ "$file" ]] ;then
        helpPanel; exit 1
    elif [[ $counter -eq 1 ]]; then
        helpPanel; exit 1
    elif [[ "$list" == "bins" ]]; then
        if [ -d "$bins_path" ] && [ "$(ls -A $bins_path)" ]; then
            if [[ "$funct" ]]; then
                functions="$(cat $bins_path/data/functions.json | jq "keys[]" -r)"
                if echo "$functions" | grep -wqoxi "$funct"; then
                    echo -e "\n${blueColour}[+] Binaries with the ${endColour}${redColour}$funct ${endColour}${blueColour}function:\n${endColour}"
                    echo -ne "${yellowColour}" && list_all_bins "$funct" | column && echo -ne "${endColour}"
                    echo
                else
                    echo -e "\n${redColour}[✘] Function \"$funct\" not found! Execute${endColour}${greenColour} searchbins -l functions${endColour}${redColour} to list all available functions\n${endColour}"
                    exit 1
                fi
            else
                echo -e "\n${blueColour}[+] All available binaries in GTFOBins:\n${endColour}"
                echo -ne "${yellowColour}" && list_all_bins | column && echo -ne "${endColour}"
                echo
            fi
        else
            echo -e "\n${redColour}[✘] The directory $bins_path does not exist. Please run the install.sh script${endColour}\n"
            exit 1
        fi
    elif [[ "$list" == "functions" ]]; then
        if [[ -f $functions_file ]]; then
            echo -e "\n${blueColour}[+] Available functions:\n${endColour}"
            echo -ne "${yellowColour}" && cat $bins_path/data/functions.json | jq "keys[]" -r && echo -ne "${endColour}"
            echo
        else
            echo -e "\n${redColour}[✘] The file $functions_file does not exist. Please run the install.sh script${endColour}\n"
        fi
    elif [ "$list" != "functions" ] || [ "$list" != "bins" ]; then
        echo -e "\n${redColour}[✘] You need to execute ${endColour}${blueColour}searchbins -l functions${endColour}${redColour} or ${endColour}${blueColour}searchbins -l bins\n${endColour}"
        exit 1
    fi
elif [[ $counter -eq 1 ]]; then
    if [[ "$funct" ]]; then
        helpPanel; exit 1
    else
        echo -e "\n${redColour}[✘] You need to specify the binary you want to enumerate:${endColour}${blueColour} searchbins -b <bin> -a\n${endColour}"
        exit 1
    fi
elif [[ "$funct" ]]; then
    echo -e "\n${redColour}[✘] You need to execute ${endColour}${blueColour}searchbins -f <function> -l bins${endColour}${redColour} or${endColour}${blueColour} searchbins -f <function> -b <bin>\n${endColour}"
    exit 1
elif [[ "$file" ]]; then
    if [[ -f "$file" ]]; then
        search_file "$file"
    else
        echo -e "\n${redColour}[✘] File \"$file\" does not exist\n${redColour}"
        exit 1
    fi
else
    helpPanel; exit 1
fi
