#!/bin/bash
TMP="/tmp/disk_age"
WEB="/var/www/html/_admin/Disk_Age.html"
echo "" > $TMP
echo "" > $WEB
date >> $TMP
for i in a b c d e; do
        {
	echo "########################################################"
        smartctl -a /dev/sd$i | egrep 'rpm|Device Model|Model Family|SATA'
	smartctl -A /dev/sd$i | grep "Power_On_Hours" | awk '{print "Power On Years: " $10/8760}'
	#echo "/dev/sd"$i
	#HOURS=$(smartctl -A /dev/sd$i | grep "Power_On_Hours" | awk '{print $10}')
	#MONTHS=$(($HOURS/730))
	#YEARS=$(smartctl -A /dev/sd$i | grep "Power_On_Hours" | awk '{print $10/8760}')
	#YEARS_MOD=$(smartctl -A /dev/sd$i | grep "Power_On_Hours" | awk '{print $10/8760}')
	#YEARS_MONTHS=`python -c "print $(HOURS)/8760"`
	#echo "Hours: " $HOURS
	#echo "Months WHOLE: " $MONTHS
	#echo "Years: " $YEARS
	#echo "Years MOD: " $YEARS_MOD
	#echo "Months remain: " $YEARS_MONTH
	smartctl -A /dev/sd$i | grep "Temp" | awk '{print "Temp : " $10 " C"}'
        lsblk | grep "sd$i"
	} 2>&1 | tee -a $TMP
done
cat $TMP | aha --title "Age" > /var/www/html/_admin/Disk_Age.html
