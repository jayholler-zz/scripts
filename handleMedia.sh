#!/bin/bash -x

#/usr/local/bin/handleMedia.sh
#
# Jay Holler 01-14-2010
# Find files in the Downloads directory and move them to
# the appropriate folder on the NFS share or put them in the Dropbox directory for syncing to iTunes.

## Move to the Downloads directory that SABnzbd uses


## A function for renaming and shuffling TV Shows into the appropriate place
umask 0022
function MOVE_TV_SHOWS() {

storageDir=/home/jholler/TV

cd /home/jholler/Downloads

for i in *.avi
do
myFile="$i"

shopt -s nocasematch
if [[ "$myFile" =~ ([A-Za-z0-9\.]*)\.(S..E..).*.avi ]] ; then
        File=${BASH_REMATCH[2]}.avi
        PreShowName=${BASH_REMATCH[1]}
        ShowName=$(echo $PreShowName | sed 's/\./ /g')
        echo "[*] A new episode of $ShowName is ready for your enjoyment: $File" > /tmp/emailmessage.txt && sleep 2
        [ -d "$storageDir/$ShowName" ] || mkdir -v "$storageDir/$ShowName"
        mv -v $myFile "$storageDir/$ShowName/$ShowName.$File"
        chmod +r "$storageDir/$ShowName/$ShowName.$File"
        #wget http://localhost:49153/web/ushare.cgi?action=refresh
        #notify-send -t 3000 -i /usr/share/icons/gnome/scalable/mimetypes/video-x-generic.svg "`basename $0`" "`cat /tmp/emailmessage.txt`"
	/usr/local/bin/prowl.pl -application="`basename $0`" -event="Done" -notification="`cat /tmp/emailmessage.txt`"
#        /usr/local/bin/email.sh
else
        echo "[+] $myFile does not appear to be a TV show, pushing it to /home/jholler/Movies on lunchbox" > /tmp/emailmessage.txt
        mv -v "$myFile" "/home/jholler/Movies/$myFile"
	/usr/local/bin/prowl.pl -application="`basename $0`" -event="Done" -notification="`cat /tmp/emailmessage.txt`"
#        /usr/local/bin/email.sh
fi
done

}

function MOVE_TV_SHOWS_MKV() {

storageDir=/home/jholler/TV

cd /home/jholler/Downloads

for i in *.mkv
do
myFile="$i"

shopt -s nocasematch
if [[ "$myFile" =~ ([A-Za-z0-9\.]*)\.(S..E..).*.mkv ]] ; then
        File=${BASH_REMATCH[2]}.mkv
        PreShowName=${BASH_REMATCH[1]}
        ShowName=$(echo $PreShowName | sed 's/\./ /g')
        echo "[*] A new episode of $ShowName is ready for your enjoyment: $File" > /tmp/emailmessage.txt && sleep 2
        [ -d "$storageDir/$ShowName" ] || mkdir -v "$storageDir/$ShowName"
        mv -v $myFile "$storageDir/$ShowName/$ShowName.$File"
	chmod +r "$storageDir/$ShowName/$ShowName.$File"
        #wget http://localhost:49153/web/ushare.cgi?action=refresh
        #notify-send -t 3000 -i /usr/share/icons/gnome/scalable/mimetypes/video-x-generic.svg "`basename $0`" "`cat /tmp/emailmessage.txt`"
	/usr/local/bin/prowl.pl -application="`basename $0`" -event="Done" -notification="`cat /tmp/emailmessage.txt`"
#        /usr/local/bin/email.sh
else
        echo "[+] $myFile does not appear to be a TV show, pushing it to /home/jholler/Movies on lunchbox" > /tmp/emailmessage.txt
        mv -v "$myFile" "/home/jholler/Movies/$myFile"
	/usr/local/bin/prowl.pl -application="`basename $0`" -event="Done" -notification="`cat /tmp/emailmessage.txt`"
#        /usr/local/bin/email.sh
fi

shopt -u nocasematch
done

}

function MOVE_MP3() {

storageDir=/home/jholler/Dropbox/new

cd /home/jholler/Downloads

myFile=$(ls */*.mp3 | head -1)

shopt -s nocasematch
if [[ "$myFile" =~ ([A-Za-z0-9].*)\/([A-Za-z0-9].*).mp3 ]] ; then
        AlbumName=${BASH_REMATCH[1]}
        echo "[*] The album $AlbumName is now ready for your enjoyment" > /tmp/emailmessage.txt && sleep 2
        [ -d "$storageDir/$AlbumName" ] || mkdir -v "$storageDir/$AlbumName"
        mv -v  "$AlbumName" "$storageDir/"
	/usr/local/bin/prowl.pl -application="`basename $0`" -event="Done" -notification="`cat /tmp/emailmessage.txt`"
else
        echo "[+] $myFile does not appear to consist of mp3 files, please investigate" > /tmp/emailmessage.txt
	/usr/local/bin/prowl.pl -application="`basename $0`" -event="Done" -notification="`cat /tmp/emailmessage.txt`"
fi

shopt -u nocasematch

}


cd /home/jholler/Downloads

###############################################
## Start the avi matching portion of the script
###############################################

avis=$(ls *.avi 2> /dev/null | wc -l)
avis_dir=$(ls */*.avi 2> /dev/null | wc -l)
avis_Movies_dir=$(ls Movies/*/*.avi 2> /dev/null | wc -l)
avis_TV=$(ls TV/*.avi 2> /dev/null | wc -l)
avis_TV_dir=$(ls TV/*/*.avi 2> /dev/null | wc -l)

if [ $avis -gt 0 ] ; then
  MOVE_TV_SHOWS
fi

if [ $avis_dir -gt 0 ] ; then
  mv */*.avi /home/jholler/Downloads
  MOVE_TV_SHOWS
fi

if [ $avis_Movies_dir -gt 0 ] ; then
  mv Movies/*/*.avi /home/jholler/Downloads
  MOVE_TV_SHOWS
fi 

if [ $avis_TV -gt 0 ] ; then
  mv TV/*.avi /home/jholler/Downloads
  MOVE_TV_SHOWS
fi

if [ $avis_TV_dir -gt 0 ] ; then
  mv TV/*/*.avi /home/jholler/Downloads
  MOVE_TV_SHOWS
fi

#########################################
## End avi matching portion of the script
#########################################

###############################################
## Start the mkv matching portion of the script
###############################################

mkvs=$(ls *.mkv i 2> /dev/null | wc -l)
mkvs_dir=$(ls */*.mkv  2> /dev/null | wc -l)
mkvs_deep_dir=$(ls */*/*.mkv 2> /dev/null | wc -l)
mkvs_Movies_dir=$(ls Movies/*/*.mkv  2> /dev/null | wc -l)
mkvs_TV=$(ls TV/*.mkv  2> /dev/null | wc -l)
mkvs_TV_dir=$(ls TV/*/*.mkv  2> /dev/null | wc -l)

if [ $mkvs -gt 0 ] ; then
  MOVE_TV_SHOWS_MKV
fi

if [ $mkvs_dir -gt 0 ] ; then
  mv */*.mkv /home/jholler/Downloads
  MOVE_TV_SHOWS_MKV
fi

if [ $mkvs_deep_dir -gt 0 ] ; then
  mv ls */*/*.mkv /home/jholler/Downloads
fi

if [ $mkvs_Movies_dir -gt 0 ] ; then
  mv Movies/*/*.mkv /home/jholler/Downloads
  MOVE_TV_SHOWS_MKV
fi

if [ $mkvs_TV -gt 0 ] ; then
  mv TV/*.mkv /home/jholler/Downloads
  MOVE_TV_SHOWS_MKV
fi

if [ $mkvs_TV_dir -gt 0 ] ; then
  mv TV/*/*.mkv /home/jholler/Downloads
  MOVE_TV_SHOWS_MKV
fi

#########################################
## End mkv matching portion of the script
#########################################
###########################################
## Begin mp3 matching portion of the script
###########################################

mp3s=$(ls *.mp3  2> /dev/null | wc -l)
mp3s_dir=$(ls */*.mp3  2> /dev/null | wc -l)
#mp3s_Music=$(ls Music/*.mp3  2> /dev/null | wc -l)
#mp3s_Music_dir=$(ls Music/*/*.mp3  2> /dev/null | wc -l)

if [ $mp3s -gt 0 ] ; then
  MOVE_MP3
fi
if [ $mp3s_dir -gt 0 ] ; then
  MOVE_MP3
fi


#########################################
## End mp3 matching portion of the script
#########################################

###########################################
## Start mkv matching portion of the script
###########################################
if [ -e *.mkv ] ; then
### Transcode 720p H264 mkv files for the Apple TV

for i in *.mkv; do

mv -v $i /home/jholler/Movies

#notify-send -t 3000 -i /usr/share/icons/gnome/scalable/mimetypes/video-x-generic.svg "`basename $0`" "$i is finished transcoding in HD"
/usr/local/bin/prowl.pl -application="`basename $0`" -event="Done" -notification="$i is finished transcoding in HD"

done

fi

#########################################
## End mkv matching portion of the script
#########################################

exit 0
