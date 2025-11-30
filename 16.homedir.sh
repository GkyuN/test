#!/bin/bash
CREATE_FILE="21501001_ky".txt

echo > $CREATE_FILE 2>&1

echo "========16. home directory permission check start=========" >> $CREATE_FILE 2>&1

echo " ">> $CREATE_FILE 2>&1

HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v '#' | grep -v "/tmp" | grep -v "uucppublic" | uniq`

for dir in $HOMEDIRS
	do
		ls -dal $dir | grep -P '\d.........' >> $CREATE_FILE 2>&1
	done
echo "" >>$CREATE_FILE 2>&1
echo "" > home.txt

echo "==========[HOME DIR Result START]==========" >>home.txt 2>&1

for dir in $HOMEDIRS
	do
		if [ -d "$dir" ]
			then
				if [ $(ls -dal "$dir" | awk '{print $1}' | grep ".....--.--"| wc -l 2>/dev/null) -eq 1 ]
					then echo "HOME Dir permission check result : good" >>home.txt
					else echo "HOME Dir permission check result : bad">>home.txt
				fi
			else
				echo "HOME DIr permission check result : good" >> home.txt
		fi
	done

echo " " >>home.txt 2>&1
echo "===========[END]==============" >> home.txt 2>&1

echo "==========[Final Result]==========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ `cat home.txt | grep "bad" | wc -l` -eq 0 ]
	then
		echo "home dir permission check result : good" >> $CREATE_FILE 2>&1
	else
		echo "home dir permission check result : bad" >> $CREATE_FILE 2>&1
fi
cat ./home.txt
rm -rf home.txt
echo " " >> $CREATE_FILE 2>&1
echo "=========[FInal END]==========" >> $CREATE_FILE 2>&1
cat ./$CREATE_FILE
