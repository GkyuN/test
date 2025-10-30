#!/bin/bash
CREATE_FILE="21501001_KY".txt
echo > $CREATE_FILE 2>&1
echo "====02.root_mgm_start====" >> $CREATE_FILE 2>&1

if [ `awk -F: '$3==0' /etc/passwd | wc -l` -eq 1 ]
then
echo "===== GOOD ====" >> $CREATE_FILE 2>&1
awk -F: '$3==0 { print $1 " -> UID"$3 }' /etc/passwd >> $CREATE_FILE 2>&1

else
echo "" >>$CREATE_FILE 2>&1
echo "===== BAD ====" >> $CREATE_FILE 2>&1
fi
cat ./$CREATE_FILE
