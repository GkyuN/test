#!/bin/bash
CREATE_FILE="21501001_KY".txt
echo >  $CREATE_FILE 2>&1
echo "=====06.shell check start ====" >> $CREATE_FILE 2>&1
echo "" >> $CREATE_FILE 2>&1

if [ -f /etc/passwd ]
        then
                cat /etc/passwd | grep -E "^daemon| ^bin| ^sys| ^admin| ^listen| ^nobody| ^nobody4 | ^noaccess | ^diag | ^operator |^games |^gopher" | grep -v "admin" >> $CREATE_FILE 2>&1
                echo "" >>$CREATE_FILE 2>&1
                echo "-----[Result]-----" >>$CREATE_FILE 2>&1
								echo "" >>$CREATE_FILE 2>&1
								
								if [ `cat /etc/passwd | grep -E "^daemon| ^bin| ^sys| ^admin| ^listen| ^nobody| ^nobody4 | ^noaccess | ^diag | ^operator |^games |^gopher" | grep -v "admin" | grep -E "false|nologin" | wc -l` -eq 0 ]
								        then
								                echo "shell check Result : Good" >>$CREATE_FILE 2>&1
								        else
								                echo "shell check result : Bad" >>$CREATE_FILE 2>&1
								
								fi

        else
                echo "/etc/passwd File not found" >> $CREATE_FILE 2>&1

fi



echo "" >>$CREATE_FILE 2>&1
echo "==========[END]=========" >>$CREATE_FILE 2>&1
cat ./$CREATE_FILE
