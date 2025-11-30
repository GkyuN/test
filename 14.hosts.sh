#!/bin/bash
CREATE_FILE="21501001_ky".txt


echo > $CREATE_FILE 2>&1
echo "=========14. hosts permission check start========="

if [ -f /etc/hosts ]
	then
		ls -alL /etc/hosts >> $CREATE_FILE 2>&1
		echo "========[Result]==========" >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/hosts | awk '{print $1}' | grep '...-.--.--.' | wc -l`   -eq 1 ]
			then
				echo "hosts permission check result : good" >>$CREATE_FILE 2>&1
			else
				echo "hosts permission check result : bad" >>$CREATE_FILE 2>&1
		fi

	else
		echo "hosts not found" >>$CREATE_FILE 2>&1

fi
echo "========[END]=========" >> $CREATE_FILE 2>&1

cat ./$CREATE_FILE

