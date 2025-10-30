#!/bin/bash
CREATE_FILE="21501001_KY".txt

echo > $CREATE_FILE 2>&1
echo "====04.GROUP file Permission check start====" >> $CREATE_FILE 2>&1

if [ -f /etc/group ]
then
    ls -alL /etc/group >> $CREATE_FILE 2>&1
    
    if [ `ls -alL /etc/group | awk '{print $1}' | grep ".rw-r--r--" | wc -l` -eq 1 ]
    then
        echo "group check result : good" >> $CREATE_FILE 2>&1
        echo >> $CREATE_FILE 2>&1
    else
        echo "group check result : bad" >> $CREATE_FILE 2>&1
        echo >> $CREATE_FILE 2>&1
    fi
else
    echo "/etc/group file not found" >> $CREATE_FILE 2>&1
    echo "" >> $CREATE_FILE 2>&1
    echo "========[Result]========" >> $CREATE_FILE 2>&1
fi

echo "====[END]====" >> $CREATE_FILE 2>&1
cat ./$CREATE_FILE

