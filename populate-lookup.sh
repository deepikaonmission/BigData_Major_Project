#!/bin/bash

batchid=`cat /home/acadgild/project/logs/current-batch.txt`
LOGFILE=/home/acadgild/project/logs/log_batch_$batchid

echo "Creating Lookup Tables..." >> $LOGFILE

echo "create 'station-geo-map','geo'" | hbase shell
echo "create 'subscribed-users','subscn'" | hbase shell
echo "create 'song-artist-map','artist'" | hbase shell
echo "create 'user-artist-map','artists'" | hbase shell

echo "Populating Lookup Tables..." >> $LOGFILE

#Populating station-geo-map lookup table
file="/home/acadgild/project/lookupfiles/stn-geocd.txt"
while IFS= read -r line
do
	stnid=`echo $line | cut -d',' -f1`
	geocd=`echo $line | cut -d',' -f2`
	echo "put 'station-geo-map','$stnid','geo:geo_cd','$geocd'" | hbase shell
done < "$file"

#Populating subscribed-users lookup table
file="/home/acadgild/project/lookupfiles/user-subscn.txt"
while IFS= read -r line
do
	userid=`echo $line | cut -d',' -f1`
	startdt=`echo $line | cut -d',' -f2`
	enddt=`echo $line | cut -d',' -f3`
	echo "put 'subscribed-users','$userid','subscn:startdt','$startdt'" | hbase shell
	echo "put 'subscribed-users','$userid','subscn:enddt','$enddt'" | hbase shell
done < "$file"

#Populating song-artist-map lookup table
file="/home/acadgild/project/lookupfiles/song-artist.txt"
while IFS= read -r line
do
	songid=`echo $line | cut -d',' -f1`
	artistid=`echo $line | cut -d',' -f2`
	echo "put 'song-artist-map','$songid','artist:artistid','$artistid'" | hbase shell
done < "$file"

#Populating user-artist-map lookup table
file="/home/acadgild/project/lookupfiles/user-artist.txt"
touch /home/cloudera/project/lookupfiles/user-artist1.txt
chmod 775 /home/cloudera/project/lookupfiles/user-artist1.txt
file1="/home/acadgild/project/lookupfiles/user-artist1.txt"
awk '$1=$1' FS="&" OFS=" " $file > $file1
num=1
while IFS= read -r line
do
	userid=`echo $line | cut -d',' -f1`
	artists=`echo $line | cut -d',' -f2`
	for row in $artists
	do
		#artist=`echo $row | cut -d',' -f$num`
		echo "put 'user-artist-map','$userid','artists:artist$num','$row'" | hbase shell
		let "num=num+1"
	done
	num=1
done < "$file1"
