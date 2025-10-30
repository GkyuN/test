#!/bin/bash
CREATE_FILE="21501001_KY".txt
echo > $CREATE_FILE 2>&1
echo "=======08.shadow check=======" >> $CREATE_FILE 2>&1

if [ -f /etc/shadow ]
	then
		ls -alL /etc/shadow >> $CREATE_FILE 2>&1
		
		echo "---------[Result]-----------" >>$CREATE_FILE 2>&1

		if [ `ls -alL /etc/shadow | awk '{print $1}' | grep "..-----" | wc -l` -eq 1 ]
			then
				echo "shadow check result : good" >> $CREATE_FILE 2>&1
			else
				echo "shadow check result : bad" >> $CREATE_FILE 2>&1

		fi

	else
		echo "/etc/shadow file not found" >> $CREATE_FILE 2>&1
fi
echo "" >> $CREATE_FILE 2>&1


echo "-------------[END]--------------" >>$CREATE_FILE 2>&1
cat ./$CREATE_FILE

