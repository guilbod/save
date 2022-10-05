#!/bin/bash

function help {
	echo -e "\E[32m Saving script"
	echo -e "It saves a directory into another one.\E[0m"
	echo "Options :"
	echo " -h for displaying this help ;"
	echo " -s for saving (pattern : -s src/ dest/) with :"
	echo "  source : directory to save (\$2)"
	echo "  destination : saved directory (\$3)."
	echo "  WRITE RELATIVE PATH !"
	echo "  ex : rsync -ad /home/$USER/script /home/$USER/save"
	echo ""
	echo -e "\033[31m Log is in /home/$USER/auto_save.log"
}

function save {
	date=$(date)
	if [ "$#" == 3 ]; then #required amount of args
	#src/ and dest/ exist
		if [ -d "$2" ]; then
			echo -e "\E[32m source OK\E[0m"

			#size check
			size=$(ls -a "$2" | wc -l)
			size=$((size - 2)) # do not count '.' and '..'
			if [ size > 0 ]; then
				echo -e "\E[32m not empty\E[0m"
			else
				echo -e "\033[31m empty, nothing to be saved !\E[0m"
				echo $date "- empty dir" >> /home/$USER/auto_save.log
				exit 0
			fi
		fi

		if [ -d "$3" ]; then #clear
			rm -r "$3"
		fi
		mkdir -p "$3"


		#save with rsync
		rsync -ad "$2" "$3"
		echo -e "\E[32m save OK\E[0m"

		#log
		echo $date ":" $2 "->" $3 >> /home/$USER/auto_save.log


	else #not enough args
		echo $date - "ERROR_ARG" >> /home/$USER/auto_save.log
		echo -e "\033[31m Not enough arguments. -h for help.\E[0m"
		exit 0
	fi
}


#### MAIN

clear
echo "Running $0"
echo "Args : $#."


if [ -f "/home/$USER/auto_save.log" ]; then
	echo -e "\E[32m log OK\E[0m"
else
	touch /home/$USER/auto_save.log
	echo "log created"
fi

date=$(date)

while getopts "hs:" arg; do       # ./auto_save.sh -arg . .
 echo
  case $arg in
   h)
    echo $date ": help" >> /home/$USER/auto_save.log
    help
    ;;
   s)
    save $1 $2 $3
    ;;
   *)
    echo $date "- ERROR_ARG" >> /home/$USER/auto_save.log
    echo -e "\033[31m wrong argument !\E[0m"
    ;;
   esac
done