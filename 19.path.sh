#!/bin/bash
CREATE_FILE='21501001_ky'.txt

echo > $CREATE_FILE 2>&1
echo "=======[19. Path conf check start]======="

if [ `echo $PATH | grep "\.:" | wc -l` -eq 0 ]
echo $PATH >> $CREATE_FILE 2>&1
	then
		echo "PATH Conf check result : good" >> $CREATE_FILE 2>&1
	else
		echo "PATH Conf check result : bad" >> $CREATE_FILE 2>&1
fi

echo "======[END]=====" >>$CREATE_FILE 2>&1
cat ./$CREATE_FILE

