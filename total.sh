#!/bin/bash
CREATE_FILE="21501001_KY".txt
echo > $CREATE_FILE 2>&1
echo "================09.UMASK Check Start===================" >>$CREATE_FILE 2>&1

echo "/etc/login.defs FIle Check" >> $CREATE_FILE 2>&1

if [ -f /etc/login.defs ]
	then
		cat /etc/login.defs |grep -i "umask" |awk -F"0" '$2 >= "22"' | grep -i umask >> $CREATE_FILE 2>&1

	else
		echo "/etc/login.defs File Not Found" >> $CREATE_FILE 2>&1
fi

echo "========[Result]==========" >>$CREATE_FILE 2>&1

if [ `cat /etc/login.defs | grep -i "umask" | grep -v '#' | awk -F"0" '$2 >= "22"' |wc -l` -gt 0 ]
	then
		echo "UMASK Check Result : GOOD" >> $CREATE_FILE 2>&1

	else
		echo "UMASK Check Result : BAD" >>$CREATE_FILE 2>&1
fi
echo "=========[END]=============" >>$CREATE_FILE 2>&1
cat ./$CREATE_FILE

#!/bin/bash
CREATE_FILE="21501001_ky".txt
echo > $CREATE_FILE 2>&1
echo "=======10.Set UID, Set GID Check Start======="

FILE="/sbin/dump /user/bin/lpq-lpd /usr/bin/newgrp /sbin/restore /user/bin/lpr /user/sbin/lpc /sbin/unix_chkpwd /user/sbin /lpc-lpd /user/bin/at /user/bin/lprm /user/sbin/traceroute /user/bin/lpq /user/bin/lprm-lpd /home/kyu2/testid.txt"

for check_file in $FILE

do
	if [ -f $check_file ]
		then
			if [ `ls -alL $check_file | awk '{print $1}'|grep -i 's'|wc -l` -gt 0 ]

				then
					ls -alL $check_file | awk '{print $1}' | grep -i 's'>>set.txt
				        ls -alL $check_file >> $CREATE_FILE
			       else
				       echo "SUID and SGID Not Found" >>set.txt
			fi
	fi
done
					       
echo "======[Result]======="

if [ `cat set.txt | awk '{print $1}' |grep -i 's' | wc -l` -gt 0 ]
	then
		echo "SetUID Check Result : BAD" >> $CREATE_FILE 2>&1
	else
		echo "SetUID Check Result : GOOD" >> $CREATE_FILE 2>&1
fi

echo "======[END]======" >> $CREATE_FILE 2>&1
rm -rf ./set.txt
cat ./$CREATE_FILE

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

#!/bin/bash
CREATE_FILE="21501001_ky".txt


echo > $CREATE_FILE 2>&1
echo "=========13.profile permission check start========="

if [ -f /etc/profile ]
	then
		ls -alL /etc/profile >> $CREATE_FILE 2>&1
		echo "========[Result]==========" >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/profile | awk '{print $1}' | grep '...-.--.--.' | wc -l`   -eq 1 ]
			then
				echo "profile permission check result : good" >>$CREATE_FILE 2>&1
			else
				echo "profile permission check result : bad" >>$CREATE_FILE 2>&1
		fi

	else
		echo "profile not found" >>$CREATE_FILE 2>&1

fi
echo "========[END]=========" >> $CREATE_FILE 2>&1

cat ./$CREATE_FILE

#!/bin/bash
CREATE_FILE="21501001_ky".txt


echo > $CREATE_FILE 2>&1
echo "=========14. hosts permission check start========="

if [ -f /etc/hosts ]
	then
		ls -alL /etc/hosts >> $CREATE_FILE 2>&1
		echo "========[Result]==========" >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/hosts | awk '{print $1}' | grep '...-.--.--.' | wc -l`   -eq 1 ]
			then
				echo "hosts permission check result : good" >>$CREATE_FILE 2>&1
			else
				echo "hosts permission check result : bad" >>$CREATE_FILE 2>&1
		fi

	else
		echo "hosts not found" >>$CREATE_FILE 2>&1

fi
echo "========[END]=========" >> $CREATE_FILE 2>&1

cat ./$CREATE_FILE

#!/bin/bash
CREATE_FILE="21501001_ky".txt


echo > $CREATE_FILE 2>&1
echo "=========15. issue permission check start========="

if [ -f /etc/issue ]
	then
		ls -alL /etc/issue >> $CREATE_FILE 2>&1
		echo "========[Result]==========" >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/issue | awk '{print $1}' | grep '...-.--.--.' | wc -l`   -eq 1 ]
			then
				echo "issue permission check result : good" >>$CREATE_FILE 2>&1
			else
				echo "issue permission check result : bad" >>$CREATE_FILE 2>&1
		fi

	else
		echo "issue not found" >>$CREATE_FILE 2>&1

fi
echo "========[END]=========" >> $CREATE_FILE 2>&1

cat ./$CREATE_FILE


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

#!/bin/bash
CREATE_FILE='21501001_ky'.txt

echo > $CREATE_FILE 2>&1
echo "=======[19. Path conf check start]======="

if [ `echo $PATH | grep "\.:" | wc -l` -eq 0 ]
	then
		echo "PATH Conf check result : good" >> $CREATE_FILE 2>&1
	else
		echo "PATH Conf check result : bad" >> $CREATE_FILE 2>&1
fi

echo "======[END]=====" >>$CREATE_FILE 2>&1
cat ./$CREATE_FILE

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

#!/bin/bash
CREATE_FILE='21501001_ky'.txt
echo > $CREATE_FILE 2>&1
echo "=========[22.session time out check start]=========" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ -f /etc/profile ]
	then
		cat /etc/profile | grep -i "TMOUT" | grep "=" >> $CREATE_FILE 2>&1
	else
		echo "/etc/profile not found" >> $CREATE_FILE 2>&1
fi
echo " " >> $CREATE_FILE 2>&1

echo "======[result]=======" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

if [ -f /etc/profile ]

	then
		if [ `cat /etc/profile | grep -v "#" | grep 'TMOUT.*[0-9]' | wc -l` -eq 1 ]
			then
				echo "session time out check result : good" >> $CREATE_FILE 2>&1
			else
				echo "session time out check result : bad" >> $CREATE_FILE 2>&1
		fi

	else
		echo "session time out check result : bad" >>$CREATE_FILE 2>&1
fi

echo " " >> $CREATE_FILE 2>&1
echo "==========[end]=============" >> $CREATE_FILE 2>&1
cat ./$CREATE_FILE

