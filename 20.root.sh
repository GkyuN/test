!/bin/bash
CREATE_FILE='21501001_ky'.txt

echo > $CREATE_FILE 2>&1
echo "==========[20. root remote permission check start]==========" > $CREATE_FILE 2>&1

if [ -f /etc/pam.d/login ]
	then
		ls -alL /etc/pam.d/login >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/pam.d/login | awk '{print $1}' | grep '........-.'| wc -l` -eq 0 ]
			then
				echo "root remote file permission check : bad" >> $CREATE_FILE 2>&1
			else
				echo "root remote file permission check : good" >> $CREATE_FILE 2>&1
		fi
	else
		echo "root remote file permission check result : good" >> $CREATE_FILE 2>&1
fi

echo "=========[END]==========" >> $CREATE_FILE 2>&1
cat ./$CREATE_FILE

