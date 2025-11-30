#!/bin/bash
CREATE_FILE='2105001_ky'.txt
echo > $CREATE_FILE 2>&1

echo "=======18. Directory file Permission check start=======" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

HOMEDIRS="/sbin /etc /bin /usr/bin /usr/sbin"

for dir in $HOMEDIRS
	do
		ls -dal $dir | grep -P '\d.........' >> $CREATE_FILE 2>&1

	done
echo " " >>$CREATE_FILE 2>&1
echo " " > dir.txt

echo "=========[Dir result Start]=========" >> dir.txt
echo " " >> dir.txt 2>&1

for dir in $HOMEDIRS
	do
		if [ -d $dir ]
			then
				if [ `ls -dal $dir | awk '{print $1}' |grep "........-."| wc -l` -eq 0 ]
					then
						echo "Dir permission check result : good" >> dir.txt
					else
						echo "Dir permission check result : bad" >> dir.txt
				fi
			else
				echo " Dir permission check result : good" >> dir.txt
		fi
	done
echo " " >> dir.txt 2>&1
echo "=========[Dir result END]==========" >> dir.txt
echo " " >>$CREATE_FILE 2>&1

echo "======[FINAL RESULT]=======" >>$CREATE_FILE 2>&1
echo " " >>$CREATE_FILE 2>&1

if [ `cat dir.txt | grep "bad" | wc -l` -eq 0 ]
	then
		echo "Dir file permission check result : good" >> $CREATE_FILE 2>&1
	else
		echo "Dir file permission check result : bad" >> $CREATE_FILE 2>&1
fi

cat ./dir.txt
rm -rf dir.txt
echo " " >> $CREATE_FILE 2>&1
echo "=========[FINAL END]==========" >> $CREATE_FILE 2>&1
cat ./$CREATE_FILE

