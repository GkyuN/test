#!/bin/bash
CREATE_FILE="21501001_KY".txt
echo > $CREATE_FILE 2>&1
echo "================09.UMASK Check Start===================" >>$CREATE_FILE 2>&1

echo "/etc/login.defs FIle Check" >> $CREATE_FILE 2>&1

if [ -f /etc/login.defs ]
	then
		cat /etc/login.defs |grep -i "umask" |awk -F"0" '$2 >= "22"' | grep -i umask >> $CREATE_FILE 2>&1

	else
		echo "/etc/login.defs File Not Found" >> $CREATE_FILE 2>&1
fi

echo "========[Result]==========" >>$CREATE_FILE 2>&1

if [ `cat /etc/login.defs | grep -i "umask" | grep -v '#' | awk -F"0" '$2 >= "22"' |wc -l` -gt 0 ]
	then
		echo "UMASK Check Result : GOOD" >> $CREATE_FILE 2>&1

	else
		echo "UMASK Check Result : BAD" >>$CREATE_FILE 2>&1
fi
echo "=========[END]=============" >>$CREATE_FILE 2>&1
cat ./$CREATE_FILE

