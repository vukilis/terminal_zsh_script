#!/bin/bash

echo "--------------------------------------"
echo "-----    TERMINAL INSTALATION    -----"
echo "--------------------------------------"

# User choise

printf "%s\n\n" "Choose terminal to install:"
echo "1. Terminator"
echo "2. Alacrity"
echo -e "3. Kitty \n"
read -p "Enter [1, 2 or 3]: " NAME
case "$NAME" in 
    [1])
        echo "You choose to install Terminator"
        ;;
    [2])
        echo "You choose to install Alacrity"
        ;;
    [3])
        echo "You choose to install Kitty"
        ;;
    *)
        read -p "Please enter [1, 2 or 3]: " NAME
esac

# if [ "$NAME" == "1" ]
# then 
#     echo "You choose to install Terminator"
# elif [ "$NAME" == "2" ]
# then
#     echo "You choose to install Alacrity"
# elif [ "$NAME" == "3" ]
# then
#     echo "You choose to install Kitty"
# fi