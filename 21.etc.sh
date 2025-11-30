#!/bin/bash
CREATE_FILE='210501001_ky'.txt
echo > $CREATE_FILE 2>&1
echo "=======[21.ETC files permission check start]=======" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

DIR744="/etc/rc*.d/* /etc/inittab /etc/syslog.conf /etc/snmp/conf/snmpd.conf"

echo " " >> $CREATE_FILE 2>&1
echo " " > etcfiles.txt

echo "-------[ETC files result start]------- >>" $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

for check_dir in $DIR744
	do
		if [ -f $check_dir ]
			then
				ls -alL $check_dir >> $CREATE_FILE 2>&1
				if [ `ls -alL $check_dir | awk '{print $1}' | grep '........w.' | wc -l` -eq 0 ]
					then
						echo "ETC files permission check : good" >> $CREATE_FILE 2>&1
					else
						echo "ETC files permission check : bad" >> $CREATE_FILE 2>&1
						echo "ETC files permission check : bad" >>etcfiles.txt
				fi
		fi
	done

echo " " >> $CREATE_FILE 2>&1
echo "-------[ETC files result end]-------" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1
echo "========[FINAL RESULT]=======" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ `cat etcfiles.txt | grep "bad" | wc -l` -eq 0 ]
	then
		echo "ETC files permission check result : good" >>$CREATE_FILE 2>&1
	else
		echo "ETC files permission check result : bad" >> $CREATE_FILE 2>&1
fi

rm -rf etcfiles.txt
echo " " >> $CREATE_FILE 2>&1
echo "=========[FINAL END]===========" >> $CREATE_FILE 2>&1
cat ./$CREATE_FILE

