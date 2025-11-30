#!/bin/bash
CREATE_FILE='21501001_ky'.txt
echo > $CREATE_FILE 2>&1
echo "=========[22.session time out check start]=========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ -f /etc/profile ]
	then
		cat /etc/profile | grep -i "TMOUT" | grep "=" >> $CREATE_FILE 2>&1
	else
		echo "/etc/profile not found" >> $CREATE_FILE 2>&1
fi
echo " " >> $CREATE_FILE 2>&1

echo "======[result]=======" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ -f /etc/profile ]

	then
		if [ `cat /etc/profile | grep -v "#" | grep 'TMOUT.*[0-9]' | wc -l` -eq 1 ]
			then
				echo "session time out check result : good" >> $CREATE_FILE 2>&1
			else
				echo "session time out check result : bad" >> $CREATE_FILE 2>&1
		fi

	else
		echo "session time out check result : bad" >>$CREATE_FILE 2>&1
fi

echo " " >> $CREATE_FILE 2>&1
echo "==========[end]=============" >> $CREATE_FILE 2>&1
cat ./$CREATE_FILE

