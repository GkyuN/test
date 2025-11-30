#!/bin/bash
CREATE_FILE="21501001_ky".txt
echo > $CREATE_FILE 2>&1
echo "=======10.Set UID, Set GID Check Start======="

FILE="/sbin/dump /user/bin/lpq-lpd /usr/bin/newgrp /sbin/restore /user/bin/lpr /user/sbin/lpc /sbin/unix_chkpwd /user/sbin /lpc-lpd /user/bin/at /user/bin/lprm /user/sbin/traceroute /user/bin/lpq /user/bin/lprm-lpd /home/kyu2/testid.txt"

for check_file in $FILE

do
	if [ -f $check_file ]
		then
			if [ `ls -alL $check_file | awk '{print $1}'|grep -i 's'|wc -l` -gt 0 ]

				then
					ls -alL $check_file | awk '{print $1}' | grep -i 's'>>set.txt
				        ls -alL $check_file >> $CREATE_FILE
			       else
				       echo "SUID and SGID Not Found" >>set.txt
			fi
	fi
done
					       
echo "======[Result]======="

if [ `cat set.txt | awk '{print $1}' |grep -i 's' | wc -l` -gt 0 ]
	then
		echo "SetUID Check Result : BAD" >> $CREATE_FILE 2>&1
	else
		echo "SetUID Check Result : GOOD" >> $CREATE_FILE 2>&1
fi

echo "======[END]======" >> $CREATE_FILE 2>&1
rm -rf ./set.txt
cat ./$CREATE_FILE

