#!/bin/bash
CREATE_FILE="21501001_ky".txt
echo > $CREATE_FILE 2>&1
echo "=========12.history file check start========"

HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0{print $6}' | sort -u | grep -v '/bin/false' | grep -v 'nologin'|grep -v "#"`

FILES=".sh_history .bash_history .history"

for dir in $HOMEDIRS
	do
		for file in $FILES
		do
			if [ -f $dir/$file ]
				then
					if [ `ls -dal $dir/$file | awk '{print $1}'|grep "...------" |wc -l` -eq 1 ]
						then
							echo "history check result : good" >>history.txt
							ls  -dal $dir/$file >> $CREATE_FILE

						else
							echo "history check result : bad">> history.txt
							ls -dal $dir/$file >> $CREATE_FILE

					fi
				else
					echo "history file not found" >> temp.txt
			fi
		done
	done

echo "=======[Result]========" >>$CREATE_FILE 2>&1
if [ `cat history.txt | grep "bad" | wc -l` -eq 0 ]
	then
		echo "history check result : good" >> $CREATE_FILE
	else
		echo "history check result : bad" >> $CREATE_FILE
fi
echo "==========[END]=========" >> $CREATE_FILE
rm -rf ./history.txt
cat ./$CREATE_FILE

