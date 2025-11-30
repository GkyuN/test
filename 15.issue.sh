#!/bin/bash
CREATE_FILE="21501001_ky".txt


echo > $CREATE_FILE 2>&1
echo "=========15. issue permission check start========="

if [ -f /etc/issue ]
	then
		ls -alL /etc/issue >> $CREATE_FILE 2>&1
		echo "========[Result]==========" >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/issue | awk '{print $1}' | grep '...-.--.--.' | wc -l`   -eq 1 ]
			then
				echo "issue permission check result : good" >>$CREATE_FILE 2>&1
			else
				echo "issue permission check result : bad" >>$CREATE_FILE 2>&1
		fi

	else
		echo "issue not found" >>$CREATE_FILE 2>&1

fi
echo "========[END]=========" >> $CREATE_FILE 2>&1

cat ./$CREATE_FILE


