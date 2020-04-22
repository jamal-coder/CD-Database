#!/bin/bash

# ---------------- Variables declaration section --------------------------------
title=()
artist=()
tracks=()
type=()
album="o"
price=()
count=0
choice="Y"
myFile=".MyData"
searchTerm=""
option=""

# ---------------- Function to take input of the User ---------------------------
function Input {
	read -p "$1" val
	echo $val
}

function makeEntry {
	clear
	count=0
	echo -e "Welcome to the CD Database\n"
	while [[  true ]]; do
		echo "==========================================================================="
		echo "Please enter the details of the CD."
		echo "==========================================================================="
		title[count]=$(Input "Title                                       : ")
		artist[count]=$(Input "Artist                                      : ")
		tracks[count]=$(Input "Number of tracks                            : ")
		until [[ "$album" == [Ss] || "$album" == [Aa] ]]; do
			album=$(Input "Album or Single (a for album, s for single) : ")
			if [[ $album == [Aa] ]]; then
				type[count]="Album"
			else
				type[count]="Single"
			fi
		done
		# Resetting album to o for next turn
		album="o"
		price[count]=$(Input "Retail price (e.g 4.65)                     : ")
		echo "==========================================================================="
		choice=$(Input "Do you want another entry [Yn]     : ")

		if [[ $choice == [Nn] ]]; then
			break
		fi
		#increment the counter for next turn
		((count++))
	done
	choice=""
	
	choice=$(Input "Do you want to save your data [Yn] : ")
	if [[ $choice == [Yy] ]]; then
		for ((counter=0; counter <= count; counter++)); do
			echo "${title[counter]}:${artist[counter]}:${tracks[counter]}:${type[counter]}:${price[counter]}:" >> $myFile
		done	
		echo -e "\n\nYour data has been saved.....\n\n"
		Input "Press Enter to proceed...."
	fi
}

function viewRecords {
	clear
	count=$(cat $myFile | wc -l) 
	awk -n -F ":" '{printf "%-20s %-20s %-10d %-10s %-10.2f\n", $1, $2, $3, $4, $5}' $myFile | less
}

function editEntry {
	searchRecord

	if [[ $option != [Yy] ]]; then
		searchRecord
	fi

	until [[ $choice -eq 1 || $choice -eq 2 || $choice -eq 3 || $choice -eq 4 || $choice -eq 5 ]]; do
		echo "1 - Title"
		echo "2 - Artist"
		echo "3 - Tracks"
		echo "4 - Type"
		echo "5 - Price"
		echo
		choice=$(Input "Enter Selection [1-5] : ")
	done
	replacementText=$(Input "Enter Changes : ")
	case $choice in
		1)	title=$replacementText;;
		2)	artist=$replacementText;;
		3)	tracks=$replacementText;;
		4)	type=$replacementText;;
		5)	price=$replacementText;;
	esac
	grep -iv "$searchTerm" $myFile > temp
	cat temp > $myFile
	rm temp > /dev/null 2>&1
	echo "$title:$artist:$tracks:$type:$price" >> $myFile
	echo
	Input "Your data has been saved, Press Enter"
}
function searchItem {
	clear
	echo -e "\tSearch Record"
	echo -e "\t-------------"
	echo
	searchTerm=$(Input "Enter Search Text : ")
	clear
	printf "%-20s %-20s %-10s %-10s %-10s\n" "Title" "Artist" "Tracks" "Type" "Price"
	echo "-----------------------------------------------------------------------------"
	grep -i "$searchTerm" $myFile | awk -n -F ":" '{printf "%-20s %-20s %-10d %-10s %-10.2f\n", $1, $2, $3, $4, $5}'
	echo "-----------------------------------------------------------------------------"
	choice=""
	until [[ $choice = [Yy] || $choice = [Nn] ]]; do
		choice=$(Input "Cofirm is it the record you are looking for [Y-N] : ")
	done
	echo "-----------------------------------------------------------------------------"
	if [[ $choice = [Yy] ]]; then
		title=$(grep -i "$searchTerm" $myFile | awk -n -F ":" '{print $1}')
		artist=$(grep -i "$searchTerm" $myFile | awk -n -F ":" '{print $2}')
		tracks=$(grep -i "$searchTerm" $myFile | awk -n -F ":" '{print $3}')
		type=$(grep -i "$searchTerm" $myFile | awk -n -F ":" '{print $4}')
		price=$(grep -i "$searchTerm" $myFile | awk -n -F ":" '{print $5}')
	fi
	option=$choice
}

function searchRecord {
	searchItem

	if [[ $option != [Yy] ]]; then
		searchItem
	fi
}
# ------------------- Main Menu ------------------------
while [[ true ]]; do
	clear
	echo -e "\n\n\t\t\tMain Menu"
	echo -e "\t\t\t----^----"
	echo -e "\n\t\t[1]---> Make Entry"
	echo -e "\t\t[2]---> Edit Entry"
	echo -e "\t\t[3]---> Search Record"
	echo -e "\t\t[4]---> View Records"
	echo -e "\t\t[5]---> Exit Database"
	echo -en "\n\t\tEnter your Selection [1-5] : "
	read choice

	case $choice in 
		1) 
			makeEntry
			;;
		2) editEntry;;
		3) searchRecord;;
		4) 
			viewRecords
			;;
		5)
			clear
			echo -en "\n\n\t\tAllah Hafize\n\n"
			break
			;;
		*)
			Input "Wrong choice, try [1-5], Press Enter"
			;;
	esac		
done


