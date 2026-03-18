# ex.: we have file 'mypodcast.m4a' in current dir
#
# run:
#   make mypodcast.auto
#   mv mypodcast.auto /mnt/player/
#

# convert m4a to mp3
%.mp3: %.m4a
	ffmpeg -i $< -acodec libmp3lame $@

# in case the .m4a file has video, leave audio only: 
# ffmpeg -i infile.m4a -f mp3 -ab 128000 -vn outfile.mp3

# split into chunks by silence
%.silence: %.mp3
	mp3splt -d $@ -s $<

# split into chunks each about 1 minute long, trying to split by silence
%.auto: %.mp3
#	mp3splt -d $@ -t 1.00 -o 0.02 -a -o @n $<
	mp3splt -d $@ -t 1.00 -a -p th=-45,min=0.3,rm=1_1,gap=30,trackjoin=30 -o @n $<

# upload to the XTRAINERZ mp3 player and sort files in the FAT filesystem according to their names (the player respects only natural filesystem order)
%.auto.upload: %.auto
	XTRAINERS_DISK=$(mount | grep XTRAINERZ | awk '{print $1}') \
		       [ -n "${XTRAINERS_DISK}" ] \
		       && cp -R $< /Volumes/XTRAINERZ/ \
		       && diskutil unmountDisk "${XTRAINERS_DISK:?disk not found}" \
		       && sudo fatsort "${XTRAINERS_DISK}" \
		       && echo "Done."

