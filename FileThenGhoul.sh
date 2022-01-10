#!/bin/bash


##
## Info message so people know what's going on
##
zenity --title 'File Then Ghoul' --info --text='This will allow you to play a prerecord,
then automatically start the Ghoul once the prerecord has finished.\n
Make sure the COMP channel is on and faded up and the Ghoul is NOT currently open!'  --width=200 --height=100 2> /dev/null


##
## Get the file to play
##
file=`zenity --file-selection --file-filter='*.mp3' --title 'Select Prerecord' 2> /dev/null`

if [ $? -eq 0 ]; then
	zenity --title 'File Then Ghoul' --info --text='Playing a prerecord then launching the Ghoul\nKeep windows open' &
	echo "Playing $file"
	echo "DO NOT CLOSE THIS WINDOW!"
	vlc "$file" --play-and-exit
	echo "Starting The Ghoul"
        ##
        ## If the Ghoul is already running, kill it
        ##
        ps ax|grep Ghoul > /tmp/ghoul.pid
        PID=`grep Ghoul.py /tmp/ghoul.pid | cut -d " " -f 1`
        echo The Ghoul PID is $PID
        if [ $PID ] ; then
          kill -HUP $PID
          sleep 1;
        fi
	cd /usr/local/bin/GraveyardGhoul
	source env/bin/activate
	python Ghoul.py --autoplay

else
  echo "NO FILE SELECTED, BAILING"
fi

