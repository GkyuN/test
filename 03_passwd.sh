#!/bin/bash
CREATE_FILE="21501001_KY".txt

echo > $CREATE_FILE 2>&1
echo "====03.Passwd FIle Permission Chec Startk====" >> $CREATE_FILE 2>&1

if [ -f /etc/pass ]
then
    ls -alL /etc/passwd >> $CREATE_FILE 2>&1
    
    if [ `ls -alL /etc/passwd | awk '{print $1}' | grep ".rw-r--r--" | wc -l` -eq 1 ]
    then
        echo "Passwd File Permission CHeck Result : GOOD" >> $CREATE_FILE 2>&1
    else
        echo "Passwd FIle Permission Check Result : BAD" >> $CREATE_FILE 2>&1
    fi

else
    echo "/etc/passwd file not found" >> $CREATE_FILE 2>&1
fi

echo "==================[END]=================" >> $CREATE_FILE 2>&1
cat ./$CREATE_FILE

