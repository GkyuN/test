#!/bin/bash
CREATE_FILE="21501001_ky".txt


echo > $CREATE_FILE 2>&1
echo "=========13.profile permission check start========="

if [ -f /etc/profile ]
	then
		ls -alL /etc/profile >> $CREATE_FILE 2>&1
		echo "========[Result]==========" >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/profile | awk '{print $1}' | grep '...-.--.--.' | wc -l`   -eq 1 ]
			then
				echo "profile permission check result : good" >>$CREATE_FILE 2>&1
			else
				echo "profile permission check result : bad" >>$CREATE_FILE 2>&1
		fi

	else
		echo "profile not found" >>$CREATE_FILE 2>&1

fi
echo "========[END]=========" >> $CREATE_FILE 2>&1

cat ./$CREATE_FILE

