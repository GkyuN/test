#!/bin/bash
CREATE_FILE="21501001_KY".txt

echo > $CREATE_FILE 2>&1
echo "=======07. SU check start ======" >> $CREATE_FILE 2>&1

if [ -f /etc/pam.d/su ]
then
    echo "1. /etc/pam.d/su File" >> $CREATE_FILE 2>&1
    cat /etc/pam.d/su >> $CREATE_FILE 2>&1
else
    echo "/etc/pam.d/su FIle not found" >> $CREATE_FILE 2>&1
fi

if [ -f /etc/group ]
then
    echo " 2. /etc/group File" >> $CREATE_FILE 2>&1
    cat /etc/group >> $CREATE_FILE 2>&1

    # 여기서 그룹별 su 권한 여부 확인 추가
    if [ `cat /etc/group | grep -E "^daemon|^bin|^sys|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher" | grep -v "admin" | awk -F: '$4 != ""'| grep -E "user"
` -eq 0 ]
    then
        echo "Group su 권한 확인: GOOD" >> $CREATE_FILE 2>&1
    else
        echo "Group su 권한 확인: BAD" >> $CREATE_FILE 2>&1
    fi

else
    echo "/etc/group FIle not found" >> $CREATE_FILE 2>&1
fi

echo " ---------[Result]--------" >> $CREATE_FILE 2>&1

if [ `cat /etc/pam.d/su | grep -v 'trust' | grep 'pam_wheel.so' | grep 'user_uid' | grep -v '#' | wc -l` -eq 0 ]
then
    echo "SU check result : BAD" >> $CREATE_FILE 2>&1
else
    echo "SU check result : GOOD" >> $CREATE_FILE 2>&1
fi

echo "=========[END]==========" >> $CREATE_FILE 2>&1
cat ./$CREATE_FILE



