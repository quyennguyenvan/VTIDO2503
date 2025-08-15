#
# using the function in shell
#

say () {

    # Color codes
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    CYAN="\033[0;36m"
    YELLOW="\033[1;33m"
    NC="\033[0m"

    case $1 in
        "-i") echo "${GREEN}INFO:: ${2}";;
        "-d") echo "${YELLOW}DEBUG:: ${2}";;
        "-w") echo "${CYAN}WARN:: ${2}";;
        "-e") echo "${RED}ERROR:: ${2}";;
    esac 

}

menuswtich () {

}
# say $1 $2


say -i "Please selection the menu to access\n\
1 - practices1.\n\
2 - practices2.\n\
3 - practices3.\n"

read menuselect 

echo "you selected ${menuselect}"

menuswtich ${menuselect}