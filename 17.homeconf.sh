#!/bin/bash

CREATE_FILE='21501001_ky'.txt
echo > $CREATE_FILE 2>&1
echo "==========17. home dir configuration check start========="
echo " " >> $CREATE_FILE 2>&1

HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v '/bin/false' | grep -v 'nologin' | grep -v '#'`

FILES=".profile .cshrc .kshrc .login .bash_profile .bashrc .bash_login .exrc .netrc .history .sh_history .bash_history .dtprofile"

for dir in $HOMEDIRS
	do
		for file in $FILES
			do
				if [ -f $dir/$file ]
					then
						
						ls -alL $dir/$file >> $CREATE_FILE 2>&1

						
						if [ `ls -alL $dir/$file | awk '{print $1}' | grep ".....--.--" | wc -l` -eq 1 ]
						then
							echo "Home Configuration Check Result : good" >> homeconf.txt
						else
							echo "Home Configuration Check Resilt : bad" >> homeconf.txt
						fi
					else
						echo "Home Configuration Check Result : good" >> homeconf.txt
				fi
			done
	done

echo "====[Final result]====" >>$CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ `cat homeconf.txt | grep "bad" | wc -l` -eq 0 ]
	then
		echo "Home configuration check result : good" >> $CREATE_FILE 2>&1
	else
		echo "Home configuration check result : bad" >> $CREATE_FILE 2>&1
fi
cat ./homeconf.txt
rm -rf homeconf.txt
echo " " >> $CREATE_FILE 2>&1
echo "=====[FINAL END]=====" >> $CREATE_FILE 2>&1
cat ./$CREATE_FILE

