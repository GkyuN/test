#!/bin/bash
CREATE_FILE="21501001_ky".txt
echo > $CREATE_FILE 2>&1
echo "=======11.xinetd.conf check start=======" >> $CREATE_FILE 2>&1
if [ -f /etc/xinetd.conf ]
	then
		ls -alL /etc/xinetd.conf >> $CREATE_FILE 2>&1
		echo "=========[Result]==========" >>$CREATE_FILE 2>&1
		if [ `ls -alL /etc/xinetd.conf | awk '{print $1}' |grep '...-----.' | wc -l` -eq 1 ]
			then
				echo "xinetd.conf check result : GOOD" >>$CREATE_FILE 2>&1

			else
				echo "xinetd.conf check result : BAD" >>$CREATE_FILE 2>&1

		fi

	else
		echo "xinetd.conf file not found" >> $CREATE_FILE 2>&1

fi

echo "======[END]=======" >>$CREATE_FILE 2>&1
cat ./$CREATE_FILE

