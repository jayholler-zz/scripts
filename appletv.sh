#!/bin/bash
### Transcode files for iPhone

if [ -z "$1" ]; then
    echo "Usage: `basename $0` filename"
    exit 0
fi

# Wait while any other ffmpeg processes are running
while [ -n "$(ps -ef | egrep "ffmpeg|HandBrakeCLI" | grep -v grep)" ];
do
        echo -e "\n[$(date +%b\ %d\ %Y:\ %H:%M:%S)]\nFound another instance of HandBrake or ffmpeg running, pausing 5 minutes..."
        sleep 300
done

# Get the beginning time from the date cmd.
START=$(date +%D\ %T)

# Email us that the next process has begun 
echo -e "About to start transcoding $1 at $START" > /tmp/emailmessage.txt
/usr/local/bin/email.sh

/usr/bin/HandBrakeCLI -i "$1" -o "$1".mp4 --preset="AppleTV 2"

# Get the ending time of the transcode process from the date cmd.
END=$(date +%D\ %T)

# Inform us with an email that transcoding is completed
echo "Transcoding of $1 was started on $START and completed on $END." > /tmp/emailmessage.txt

if [[ "$1" =~ *.avi ]]; then

  # Move the original file to /tmp
  mv -v "$1" /tmp

  # Chop off the .avi from the filename
  transcodedFile=`echo "$1.mp4" | sed -e 's/\.avi//'`
  mv "$1.mp4" "$transcodedFile"

  # Determine the appropriate place to move the file and do so
  #/usr/local/bin/moveMp4s.sh "$transcodedFile"
  mv $transcodedFile /home/jholler/Downloads
  /usr/local/bin/handleMedia.sh

elif [[ "$1" =~ *.mkv ]]; then

  # Move the original mkv file to the backup at /mkvs
  mv -v "$1" /mkvs

  # Chop off the .mkv from the file name
  transcodedFile=`echo "$1.mp4" | sed -e 's/\.mkv//'`
  mv "$1.mp4" "$transcodedFile"

  # Determine the appropriate place to move the file and do so
  #/usr/local/bin/moveMp4s.sh "$transcodedFile"
  mv $transcodedFile /home/jholler/Downloads
  /usr/local/bin/handleMedia.sh
fi

exit 0
