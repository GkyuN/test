#!/bin/bash
CREATE_FILE="21501001_KY".txt
echo > $CREATE_FILE 2>&1
echo  "=====01.Default ID======" >> $CREATE_FILE 2>&1
echo "">> $CREATE_FILE 2>&1

if [ `cat /etc/passwd | grep -E "lp:|uucp:|nuucp:" | wc -l` -eq 0 ]
then
echo "lp,uucp,nuucp not found" >> $CREATE_FILE 2>&1

else
cat /etc/passwd | grep -E "lp:|uucp:|nuucp:" >> $CREATE_FILE 2>&1
fi
cat ./$CREATE_FILE
#!/bin/bash
CREATE_FILE="21501001_KY".txt
echo > $CREATE_FILE 2>&1
echo "====02.root_mgm_start====" >> $CREATE_FILE 2>&1

if [ `awk -F: '$3==0' /etc/passwd | wc -l` -eq 1 ]
then
echo "===== GOOD ====" >> $CREATE_FILE 2>&1
awk -F: '$3==0 { print $1 " -> UID"$3 }' /etc/passwd >> $CREATE_FILE 2>&1

else
echo "" >>$CREATE_FILE 2>&1
echo "===== BAD ====" >> $CREATE_FILE 2>&1
fi
cat ./$CREATE_FILE
#!/bin/bash
CREATE_FILE="21501001_KY".txt

echo > $CREATE_FILE 2>&1
echo "====03.Passwd FIle Permission Chec Startk====" >> $CREATE_FILE 2>&1

if [ -f /etc/pass ]
then
    ls -alL /etc/passwd >> $CREATE_FILE 2>&1
    
    if [ `ls -alL /etc/passwd | awk '{print $1}' | grep ".rw-r--r--" | wc -l` -eq 1 ]
    then
        echo "Passwd File Permission CHeck Result : GOOD" >> $CREATE_FILE 2>&1
    else
        echo "Passwd FIle Permission Check Result : BAD" >> $CREATE_FILE 2>&1
    fi

else
    echo "/etc/passwd file not found" >> $CREATE_FILE 2>&1
fi

echo "==================[END]=================" >> $CREATE_FILE 2>&1
cat ./$CREATE_FILE

#!/bin/bash
CREATE_FILE="21501001_KY".txt

echo > $CREATE_FILE 2>&1
echo "====04.GROUP file Permission check start====" >> $CREATE_FILE 2>&1

if [ -f /etc/group ]
then
    ls -alL /etc/group >> $CREATE_FILE 2>&1
    
    if [ `ls -alL /etc/group | awk '{print $1}' | grep ".rw-r--r--" | wc -l` -eq 1 ]
    then
        echo "group check result : good" >> $CREATE_FILE 2>&1
        echo >> $CREATE_FILE 2>&1
    else
        echo "group check result : bad" >> $CREATE_FILE 2>&1
        echo >> $CREATE_FILE 2>&1
    fi
else
    echo "/etc/group file not found" >> $CREATE_FILE 2>&1
    echo "" >> $CREATE_FILE 2>&1
    echo "========[Result]========" >> $CREATE_FILE 2>&1
fi

echo "====[END]====" >> $CREATE_FILE 2>&1
cat ./$CREATE_FILE

#!/bin/bash

CREATE_FILE="21501001_KY.txt"

> "$CREATE_FILE"

echo "=====05. Passwd rule check start====" >> "$CREATE_FILE"

if [ -f /etc/login.defs ]; then
    grep -v '#' /etc/login.defs | grep -i "PASS_MIN_LEN" >> "$CREATE_FILE"
    grep -v '#' /etc/login.defs | grep -i "PASS_MAX_DAYS" >> "$CREATE_FILE"
    grep -v '#' /etc/login.defs | grep -i "PASS_MIN_DAYS" >> "$CREATE_FILE"
else
    echo "/etc/login.defs file not found" >> "$CREATE_FILE"
fi


min_len=$(grep '^PASS_MIN_LEN' /etc/login.defs | awk '{print $2}')
max_days=$(grep '^PASS_MAX_DAYS' /etc/login.defs | awk '{print $2}')
min_days=$(grep '^PASS_MIN_DAYS' /etc/login.defs | awk '{print $2}')

if [ "${min_len:-0}" -le 7 ] || \
   [ "${max_days:-99999}" -gt 70 ] || \
   [ "${min_days:-0}" -le 0 ]; then
    result="bad"
else
    result="good"
fi

echo "========[Result]========" >> "$CREATE_FILE"
echo "passwd rule : $result" >> "$CREATE_FILE"
echo "========================" >> "$CREATE_FILE"

cat "$CREATE_FILE"
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
#!/bin/bash
CREATE_FILE="21501001_KY".txt

echo > $CREATE_FILE 2>&1
echo "=======07. SU check start ======" >> $CREATE_FILE 2>&1

if [ -f /etc/pam.d/su ]
then
    echo "1. /etc/pam.d/su File" >> $CREATE_FILE 2>&1
    cat /etc/pam.d/su >> $CREATE_FILE 2>&1
else
    echo "/etc/pam.d/su FIle not found" >> $CREATE_FILE 2>&1
fi

if [ -f /etc/group ]
then
    echo " 2. /etc/group File" >> $CREATE_FILE 2>&1
    cat /etc/group >> $CREATE_FILE 2>&1

    # 여기서 그룹별 su 권한 여부 확인 추가
    if [ `cat /etc/group | grep -E "^daemon|^bin|^sys|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher" | grep -v "admin" | awk -F: '$4 != ""'| grep -E "user"
` -eq 0 ]
    then
        echo "Group su 권한 확인: GOOD" >> $CREATE_FILE 2>&1
    else
        echo "Group su 권한 확인: BAD" >> $CREATE_FILE 2>&1
    fi

else
    echo "/etc/group FIle not found" >> $CREATE_FILE 2>&1
fi

echo " ---------[Result]--------" >> $CREATE_FILE 2>&1

if [ `cat /etc/pam.d/su | grep -v 'trust' | grep 'pam_wheel.so' | grep 'user_uid' | grep -v '#' | wc -l` -eq 0 ]
then
    echo "SU check result : BAD" >> $CREATE_FILE 2>&1
else
    echo "SU check result : GOOD" >> $CREATE_FILE 2>&1
fi

echo "=========[END]==========" >> $CREATE_FILE 2>&1
cat ./$CREATE_FILE



#!/bin/bash
CREATE_FILE="21501001_KY".txt
echo > $CREATE_FILE 2>&1
echo "=======08.shadow check=======" >> $CREATE_FILE 2>&1

if [ -f /etc/shadow ]
	then
		ls -alL /etc/shadow >> $CREATE_FILE 2>&1
		
		echo "---------[Result]-----------" >>$CREATE_FILE 2>&1

		if [ `ls -alL /etc/shadow | awk '{print $1}' | grep "..-----" | wc -l` -eq 1 ]
			then
				echo "shadow check result : good" >> $CREATE_FILE 2>&1
			else
				echo "shadow check result : bad" >> $CREATE_FILE 2>&1

		fi

	else
		echo "/etc/shadow file not found" >> $CREATE_FILE 2>&1
fi
echo "" >> $CREATE_FILE 2>&1


echo "-------------[END]--------------" >>$CREATE_FILE 2>&1
cat ./$CREATE_FILE

