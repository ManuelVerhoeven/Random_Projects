#!/bin/bash

#content:
#1.     Defining minor functions
#2.     Main functions - Get thumbnails
#3.1    Downloading a single thumbnails
#3.2    Downloading a range of thumbnails
#3.3    Downloading a number of random thumbnails
#3.4    Downloading all Thumbnails
#3.5    Cleaning up all dir/files except for *.sh
#4      menu and exit program and connecting the online and declaring array

#1. Defining minor functions--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Gets the file size in kb (based on getprop question from previous assignment) and outputting that as a variable
#The stat custom command %s is used on the input file to find the size in bytes
#One byte is equal to 0.001 kilobytes, this will be used to convert bytes to kiloytes.
getprop(){
    file_size_b=$(stat -c %s "$1/$2") 
    toKB=0.001 
    file_size_kb=$(echo "$file_size_b*$toKB" | bc) 
    echo "$file_size_kb"
}

#A function that grabs the file size after its been populated by thumbnails and gives an output
total_mb(){
    MB=find | xargs du -sh
    echo "$MB.... in working directory..... (function is almost working)"
}

#pause function, mainly used so that output can be read before going back to main menu, the pause function is used at the end of major function.
pause(){
    read -p "Press [ enter ] to return to menu"
}

#2. Main functions - Get thumbnails------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#The main function of this script, this function downloads, checks and saves thumbnail files from the gallery.
#Requires 3 variable inputs to work (file_number, check_list and save_location)
#It than ransform user input into full file name variable.
#Check if thumbnail to be downloaded is a valid and existing file
#If a valid file check if that file alread exists in the proposed save_location
#If the file alread exists give the option to overide file or skip it
#If the  file does not exist than it download the thumbnail and output the required message.
#If thumbnail_number does not match an existing file it will output that input was unvalid.
get_image(){
    thumbnail_file=DSC0$file_number.jpg
    if [[ "${check_list}" =~ "${thumbnail_file}" ]]; then
        if [[ -f $save_location/$thumbnail_file ]]; then
            echo -e "\nthe file $thumbnail_file already exits in the directory $save_location."
                while true; do
                    read -p "enter [ 1 ] to overide existing file; or [ 2 ] to skip thumbnail: " duplicate
                    case $duplicate in 
                        1) rm $save_location/$thumbnail_file && wget -q -P $save_location "https://secure.ecu.edu.au/service-centres/MACSC/gallery/ml-2018-campus/$thumbnail_file" 
                            echo -e "\nDownloading DSC0$file_number, with the file name $thumbnail_file, with a size of $(getprop $save_location $thumbnail_file) KB ..........File Download Complete"
                            echo -e "file $thumbnail_file has been overidden by: $thumbnail_file"
                            break;;
                        2) echo "file skipped" 
                            break;;
                        *) echo "invalid option entered, try again." 
                    esac
                done
        else    wget -q -P $save_location "https://secure.ecu.edu.au/service-centres/MACSC/gallery/ml-2018-campus/$thumbnail_file" 
                echo -e "\nDownloading DSC0$file_number, with the $thumbnail_file, with a size of" $(getprop $save_location $thumbnail_file) "KB ..........File Download Complete"
        fi
    else echo -e "\nfile unavailble... please enter invalid input"
    fi
}

#3.1. Download a specific thumbnail------------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# List of all valid thumbnail file names for the user to choose from, this list is generated upon script opening.
# Line propt the user for the last 4 digit of a thumbnail file and  where to safe that thumbnail
# Call the get_image file with the three input which were all available
single_img(){
    clear
    echo "---------------------------"
    echo "Aquire a specific thumbnail"
    echo "---------------------------"
echo "List of thumbnails availble:"
echo -e "$check_list\n"
read -p "Please enter the 4 last digits of thumbnail you wish to download: " file_number
read -p "please enter directory you wish to create or save too: " save_location
get_image $check_list $file_number $save_location 
echo ""
pause
}

#3.2 Downloading a range of thumbnails------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Same as previous function, user is presented with all valid thumbnail files.
# and promps the user to enter two sets of 4  digits, a start from and end on to essablish the range. it will also prompt for a save location
# Essablish a c loop starting at the star of the array and ending at the 147 but that doesnt matter as I will explain in a bit.
# esstalishes that the thumbnail_file (input for get_image function) is depended on what number in array the count is, this way it loops through all files.
# essablishing varibles the way I will be using them y adding or removing characters and symbols.
# check if the thumbnail file is equal to the range end on number, if it is download thumbnail with get_image function, it will that communicate that, pause, and end function back to main menu.
# If the the thumnail file is greater that range start from number then get_image, than loop with next variable in array.
range_img(){
echo "----------------------------"
echo "Aquire a range of thumbnails"
echo "----------------------------"
echo "List of thumbnails availble:"
echo -e "$check_list\n"
read -p "Please enter the 4 last digits of thumbnail range you wish to download [ Lower ] [ Higher ]: " range_start range_end
read -p "please enter directory you wish to create or save too: " save_location
echo -e "the range you have selected is from DSC0$range_start to DSC0$range_end and all thumbnails are saved to $save_location.\n"
for (( i=0; i<=147; i++)); do 
    save_location=$save_location
    thumbnail_file=${thumb_array[i]}
    file_number=`echo $thumbnail_file | sed -e 's/^DSC0//g; s/.jpg$//g'`
    array_start=`echo "DSC0$range_start.jpg"`
    array_end=`echo "DSC0$range_end.jpg"`
    if [[ ${thumb_array[i]} =~ "$array_end" ]]; then
       get_image $thumbnail_file $save_location $file_number 
       echo -e "\n------------------------------------------------------------------------------\n" 
       echo -e "Download complete........total size is " $(total_mb $save_location) "\n"
       pause
    elif [[ ${thumb_array[i]} > "$array_start" ]]; then  
       get_image $thumbnail_file $save_location $file_number
    else :    
    fi
done
}

#3.3 Download a number of random thumbnail files------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Promt the user for a random number and a save location to be used as variables
#it checks if the entered random number is a digit, if it does it starts a count loop up to until that entered number is reached, counting up each loop.
#the count loop is made up of two constant variables the user entered random amount and save location
#the dynamic variable is the thumnail file, this is caclulated using and random numer generater variable and applying it to grabing a random variable out of an array.
#the loop uses the get_image function to save a random thumbnail file to a save location for a user input amount of times.
#if the loop has reached the count of the user entered number it downloads the last image, comunicate its carried out the task and allow the user to return to the menu.
#if the user input number is not a number it puts out an incorrect input propt to user.
number_img(){
    echo "-------------------------------"
    echo "Aquire a number of random image"
    echo "-------------------------------"
read -p "please enter number [ 1 - 999 ] of random thumnails to download: " input_num
read -p "please enter directory you wish to create or save too: " save_location
if [[ $input_num =~ ^[[:digit:]]+$ ]]; then
    for (( i=1; i<=$input_num; i++)); do 
        input_num=$input_num
        save_location=$save_location
        rand=$[$RANDOM % ${#thumb_array[@]}]
        thumbnail_file=${thumb_array[rand]}
        file_number=`echo $thumbnail_file | sed -e 's/^DSC0//g; s/.jpg$//g'`
        if [[ $i =~ "$input_num" ]]; then
        get_image $thumbnail_file $save_location $file_number  
        echo -e "\n------------------------------------------------------------------------------\n" 
        echo -e "Download complete....... downloaded $input_num files.......... total size is" $(total_mb $save_location) "\n"
        pause
        else 
        get_image $thumbnail_file $save_location $file_number
        fi  
    done
else read -p "invalid input, enter number.....press [ enter ] to return to menu"
fi
}

#3.4 Download all-----------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Prompt the user the input a save location for all thumbnails to be downloaded too
#using count loop starting at 0 and ending at 147 (all thumbnails in gallery) it loops through the array with thumbnail files.
#alternatively if the variable in the count is equal to DSC00674.jpg than is will use get_image and end the loop as being completed
#Otherise the save location, the array count thumbnail and file number variables are usesed in the get_image function to download all thumbnails from gallery.
all_img(){
    echo ""
    echo "----------------------------------"
    echo "Download all thumbnails in gallery"
    echo "----------------------------------"
echo "Downloading all thumbnails in gallery."
read -p "Enter directory name where all thumnails will be saved too: " save_location
for (( i=0; i<=147; i++)); do 
    save_location=$save_location
    thumbnail_file=${thumb_array[i]}
    file_number=`echo $thumbnail_file | sed -e 's/^DSC0//g; s/.jpg$//g'`
    pre_sum=0
    if [[ ${thumb_array[i]} =~ "DSC00674.jpg" ]]; then
       get_image $thumbnail_file $save_location $file_number
       echo -e "\n-------------------------------------------------------------------\n" 
       echo -e "Download complete........total size is " $(total_mb $save_location) "\n"
       break
    else 
    get_image $thumbnail_file $save_location $file_number
fi
done
pause
}

#3.5 Clean up folder of all files and directories except for *.sh files------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#from the list in current working directory grab everthing that doesnt end in .sh and remove everything else
#comunicate that action has been caried out.
cleanup(){ 
    echo ""
    echo "--------------"
    echo "clean up files"
    echo "--------------"
ls | grep -v .sh$| xargs rm -r
echo -e "all directories and files in the working directory but the getimages.sh script have been deleted\n"
pause
}

#4.0 menu function and options,-----------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#comunicating what the menu options are
menu() {
    clear
    echo "-------------------------"
    echo "   GET IMAGES PROGRAM"
    echo "-------------------------"
    echo "1. Download a specific thumbnail"
    echo "2. Download thumbnails on a specific range"
    echo "3. Download a number of random Thumbnails"
    echo "4. Download all thumbnails"
    echo "5. Clean up files"
    echo "6. Exit program"
    echo ""
}

#propting for user to make a choice by entering number which than runs the main function, notice that 6 exits the script's while loop which exits the program.
options() {
    local choice
    read -p "Select your choice [ 1 - 6 ] " choice
    case $choice in 
        1) single_img ;;
        2) range_img ;;
        3) number_img ;;
        4) all_img ;;
        5) cleanup ;;
        6) exit 0;;
        *) echo -e "incorect option entered, try again."  && sleep 2
    esac
}

#Start of script-----------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#connecting and essalishing array and check list
#Line 22 - 25: Grabbing all thumbnnails ellements form the online gallery and striping eveything but the file names away.
#Line 26 - 27: Declaring an arry named thumb_array and populate with the file names from the thumbnail gallery that were curl into check_list
check_list=$(curl -s -q "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=ml-2018-campus" |\
grep -Eo '(https)://[^"]+' |\
grep ".jpg" |\
sed 's/.*\///g')
declare -a thumb_array
thumb_array=($check_list)

#The script
while true
do
        menu
        options
done

exit 0
