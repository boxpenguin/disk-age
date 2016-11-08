#!/bin/bash
TMP="/tmp/disk_age"
WEB="/var/www/html/_admin/Disk_Age.html"
#echo "" > $TMP
#echo "" > $WEB
date > $TMP	# Initialize file and add date
#for i in `lshw -short | grep disk | awk '{print $2}' | grep -v cd`; do	# Gotta make this smarter
for i in a b c d e; do	# Gotta make this smarter
        {
	echo "########################################################"
        smartctl -a /dev/sd$i | egrep 'rpm|Device Model|Model Family|SATA'
	MONTHS=$(smartctl -A /dev/sd$i | grep "Power_On_Hours" | awk '{print "Power On Years: " $10%8760/8760*12}')
	YEARS=$(smartctl -A /dev/sd$i | grep "Power_On_Hours" | awk '{print "Power On Years: " $10/8760}')

	# Need to remove the .###
	echo "Hard Drive age: " $YEARS " Years and " $MONTHS " Months."
	smartctl -A /dev/sd$i | grep "Temp" | awk '{print "Temp : " $10 " C"}'
        lsblk | grep "sd$i"
	} 2>&1 | tee -a $TMP
done
cat $TMP | aha --title "Age" > /var/www/html/_admin/Disk_Age.html	#Push to website
rm $TMP	# Remove temp
