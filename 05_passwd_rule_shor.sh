#!/bin/bash

CREATE_FILE="21501001_KY.txt"

> "$CREATE_FILE"

echo "=====05. Passwd rule check start====" >> "$CREATE_FILE"

if [ -f /etc/login.defs ]; then
    grep -v '#' /etc/login.defs | grep -i "PASS_MIN_LEN" >> "$CREATE_FILE"
    grep -v '#' /etc/login.defs | grep -i "PASS_MAX_DAYS" >> "$CREATE_FILE"
    grep -v '#' /etc/login.defs | grep -i "PASS_MIN_DAYS" >> "$CREATE_FILE"
else
    echo "/etc/login.defs file not found" >> "$CREATE_FILE"
fi


min_len=$(grep '^PASS_MIN_LEN' /etc/login.defs | awk '{print $2}')
max_days=$(grep '^PASS_MAX_DAYS' /etc/login.defs | awk '{print $2}')
min_days=$(grep '^PASS_MIN_DAYS' /etc/login.defs | awk '{print $2}')

if [ "${min_len:-0}" -le 7 ] || \
   [ "${max_days:-99999}" -gt 70 ] || \
   [ "${min_days:-0}" -le 0 ]; then
    result="bad"
else
    result="good"
fi

echo "========[Result]========" >> "$CREATE_FILE"
echo "passwd rule : $result" >> "$CREATE_FILE"
echo "========================" >> "$CREATE_FILE"

cat "$CREATE_FILE"
