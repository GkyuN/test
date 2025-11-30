#!/bin/bash

CREATE_FILE="21501001_KY_09-22.html"

echo "<!DOCTYPE html>" > $CREATE_FILE
echo "<html lang='ko'>" >> $CREATE_FILE
echo "<head><meta charset='UTF-8'><title>시스템 점검 결과</title>" >> $CREATE_FILE
echo "<style>
body{font-family:monospace;background:#f4f4f4;padding:20px;}
h1,h2{color:#0a0a0a; border-bottom: 2px solid #ddd; padding-bottom: 10px; margin-top: 30px;}
pre{background:#222;color:#dff1ff;padding:10px;border-radius:6px;overflow-x:auto;white-space: pre-wrap;}
.good{color:#16a34a;font-weight:bold;}
.bad{color:#dc2626;font-weight:bold;}
</style>" >> $CREATE_FILE
echo "</head><body>" >> $CREATE_FILE
echo "<h1>시스템 점검 결과 (21501001_KY - 09~22번)</h1>" >> $CREATE_FILE

# ===== 09. UMASK Check =====
echo "<h2>09. UMASK Check</h2><pre>" >> $CREATE_FILE
echo "/etc/login.defs File Check" >> $CREATE_FILE
if [ -f /etc/login.defs ]; then
    cat /etc/login.defs | grep -i "umask" | awk -F"0" '$2 >= "22"' | grep -i umask >> $CREATE_FILE
else
    echo "/etc/login.defs File Not Found" >> $CREATE_FILE
fi

if [ `cat /etc/login.defs | grep -i "umask" | grep -v '#' | awk -F"0" '$2 >= "22"' |wc -l` -gt 0 ]; then
    echo "<span class='good'>양호</span> : UMASK가 022로 설정되어, 파일 생성 시 비인가자의 쓰기 권한이 제한된 안전한 상태입니다." >> $CREATE_FILE
else
    echo "<span class='bad'>취약</span> : UMASK가 022로 설정되지 않아, 파일 생성 시 타인에게 쓰기 권한이 부여될 수 있는 취약한 상태입니다." >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 10. SetUID, SetGID Check =====
echo "<h2>10. SetUID, SetGID Check</h2><pre>" >> $CREATE_FILE
FILE="/sbin/dump /user/bin/lpq-lpd /usr/bin/newgrp /sbin/restore /user/bin/lpr /user/sbin/lpc /sbin/unix_chkpwd /user/sbin /lpc-lpd /user/bin/at /user/bin/lprm /user/sbin/traceroute /user/bin/lpq /user/bin/lprm-lpd"

echo "" > set.txt

for check_file in $FILE; do
    if [ -f $check_file ]; then
        if [ `ls -alL $check_file | awk '{print $1}'|grep -i 's'|wc -l` -gt 0 ]; then
            ls -alL $check_file | awk '{print $1}' | grep -i 's' >> set.txt
            ls -alL $check_file >> $CREATE_FILE
        else
            echo "SUID and SGID Not Found in $check_file" >> set.txt
        fi
    fi
done

if [ `cat set.txt | awk '{print $1}' |grep -i 's' | wc -l` -gt 0 ]; then
    echo "<span class='bad'>취약</span> : 불필요한 SetUID/SetGID 파일이 발견되어, root 권한 탈취 공격에 악용될 수 있는 취약한 상태입니다." >> $CREATE_FILE
else
    echo "<span class='good'>양호</span> : 불필요한 SetUID/SetGID가 설정되지 않아, 권한 상승 및 악용 공격의 위험이 없는 안전한 상태입니다." >> $CREATE_FILE
fi
rm -rf ./set.txt
echo "</pre>" >> $CREATE_FILE

# ===== 11. xinetd.conf check =====
echo "<h2>11. xinetd.conf Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/xinetd.conf ]; then
    ls -alL /etc/xinetd.conf >> $CREATE_FILE
    if [ `ls -alL /etc/xinetd.conf | awk '{print $1}' |grep '...-----.' | wc -l` -eq 1 ]; then
        echo "<span class='good'>양호</span> : xinetd.conf 파일의 접근 권한이 적절히 제한되어, 비인가자의 악의적 프로그램 등록 및 root 권한 악용이 방지된 상태입니다." >> $CREATE_FILE
    else
        echo "<span class='bad'>취약</span> : xinetd.conf 파일의 접근 권한이 취약하여, 비인가자가 악의적인 프로그램을 등록해 root 권한을 획득할 위험이 있습니다." >> $CREATE_FILE
    fi
else
    echo "xinetd.conf file not found" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 12. History File Check =====
echo "<h2>12. History File Check</h2><pre>" >> $CREATE_FILE
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0{print $6}' | sort -u | grep -v '/bin/false' | grep -v 'nologin'|grep -v "#"`
FILES=".sh_history .bash_history .history"

echo "" > history.txt

for dir in $HOMEDIRS; do
    for file in $FILES; do
        if [ -f $dir/$file ]; then
            if [ `ls -dal $dir/$file | awk '{print $1}'|grep "...------" |wc -l` -eq 1 ]; then
                echo "history check result : good" >> history.txt
                ls -dal $dir/$file >> $CREATE_FILE
            else
                echo "history check result : bad" >> history.txt
                ls -dal $dir/$file >> $CREATE_FILE
            fi
        
        fi
    done
done

if [ `cat history.txt | grep "bad" | wc -l` -eq 0 ]; then
    echo "<span class='good'>양호</span> : histroy 파일의 권한이 600으로 설정되어, 명령어 사용 기록이 타인에게 노출되지 않는 안전한 상태입니다." >> $CREATE_FILE
else
    echo "<span class='bad'>취약</span> : history 파일의 권한이 600이 아니거나 소유자가 잘못 설정되어, 명령어 사용 기록이 유출될 위험이 있습니다." >> $CREATE_FILE
fi
rm -rf ./history.txt
echo "</pre>" >> $CREATE_FILE

# ===== 13. Profile Permission Check =====
echo "<h2>13. Profile Permission Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/profile ]; then
    ls -alL /etc/profile >> $CREATE_FILE
    if [ `ls -alL /etc/profile | awk '{print $1}' | grep '...-.--.--.' | wc -l` -eq 1 ]; then
        echo "<span class='good'>양호</span> : /etc/profile 파일의 타 사용자 쓰기 권한이 제한되어, 악의적인 환경 설정 변조가 방지된 상태입니다." >> $CREATE_FILE
    else
        echo "<span class='bad'>취약</span> : /etc/profile 파일에 타 사용자 쓰기 권한이 부여되어, 환경 설정 변조를 통한 침해 사고 위험이 있습니다." >> $CREATE_FILE
    fi
else
    echo "profile not found" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 14. Hosts Permission Check =====
echo "<h2>14. Hosts Permission Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/hosts ]; then
    ls -alL /etc/hosts >> $CREATE_FILE
    if [ `ls -alL /etc/hosts | awk '{print $1}' | grep '...-.--.--.' | wc -l` -eq 1 ]; then
        echo "<span class='good'>양호</span> : /etc/hosts 파일의 타 사용자 쓰기 권한이 제한되어, 호스트 정보 위변조가 방지된 상태입니다" >> $CREATE_FILE
    else
        echo "<span class='bad'>취약</span> : /etc/hosts 파일에 타 사용자 쓰기 권한이 부여되어, 변조된 정보를 통해 악의적인 시스템을 신뢰하게 될 위험이 있습니다." >> $CREATE_FILE
    fi
else
    echo "hosts not found" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 15. Issue Permission Check =====
echo "<h2>15. Issue Permission Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/issue ]; then
    ls -alL /etc/issue >> $CREATE_FILE
    if [ `ls -alL /etc/issue | awk '{print $1}' | grep '...-.--.--.' | wc -l` -eq 1 ]; then
        echo "<span class='good'>양호</span> : /etc/issue 파일의 타 사용자 쓰기 권한이 제한되어, 터미널 설정 관련 정보의 변조가 방지된 상태입니다." >> $CREATE_FILE
    else
        echo "<span class='bad'>취약</span> : /etc/issue 파일에 타 사용자 쓰기 권한이 부여되어, 터미널 설정 관련 정보가 변조될 위험이 있습니다." >> $CREATE_FILE
    fi
else
    echo "issue not found" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 16. Home Directory Permission Check =====
echo "<h2>16. Home Directory Permission Check</h2><pre>" >> $CREATE_FILE

HOMEDIRS=`awk -F: '($3 == 0 || $3 >= 1000) {print $6}' /etc/passwd | sort -u`

for dir in $HOMEDIRS; do
    
    if [ -d "$dir" ]; then
        ls -dal "$dir" 2>/dev/null >> $CREATE_FILE
    fi
done


echo "" > home.txt

for dir in $HOMEDIRS; do
    if [ -d "$dir" ]; then
        
        PERM_CHAR=`ls -dal "$dir" 2>/dev/null | awk '{print $1}' | cut -c 9`
        
        
        if [ "$PERM_CHAR" == "w" ]; then
            echo "Home Directory permission Check Result : BAD" >> home.txt
        else
            echo "Home Directory permission Check Result : GOOD" >> home.txt
        fi
    fi
done

if [ `cat home.txt | grep "BAD" | wc -l` -eq 0 ]; then
    
    echo "<span class='good'>양호</span> : 홈 디렉터리의 타 사용자 쓰기 권한이 제한되어, 비인가자의 파일 변조 시도가 차단된 안전한 상태입니다." >> $CREATE_FILE
else
    
    echo "<span class='bad'>취약</span> : 홈 디렉터리에 타 사용자 쓰기 권한이 설정되어, 비인가자가 설정 파일을 변조할 수 있는 취약한 상태입니다." >> $CREATE_FILE
fi

rm -rf home.txt
echo "</pre>" >> $CREATE_FILE

# ===== 17. Home Dir Configuration Check =====
echo "<h2>17. Home Dir Configuration Check</h2><pre>" >> $CREATE_FILE
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v '/bin/false' | grep -v 'nologin' | grep -v '#'`
FILES=".profile .cshrc .kshrc .login .bash_profile .bashrc .bash_login .exrc .netrc .history .sh_history .bash_history .dtprofile"

echo "" > homeconf.txt

for dir in $HOMEDIRS; do
    for file in $FILES; do
        if [ -f $dir/$file ]; then
            ls -alL $dir/$file >> $CREATE_FILE
            if [ `ls -alL $dir/$file | awk '{print $1}' | grep ".....--.--" | wc -l` -eq 1 ]; then
                echo "Home Configuration Check Result : good" >> homeconf.txt
            else
                echo "Home Configuration Check Result : bad" >> homeconf.txt
            fi
        else
            echo "Home Configuration Check Result : good" >> homeconf.txt
        fi
    done
done

if [ `cat homeconf.txt | grep "bad" | wc -l` -eq 0 ]; then
    echo "<span class='good'>양호</span> : 홈 디렉터리 내 환경변수 파일의 타 사용자 쓰기 권한이 제한되어, 비인가자에 의한 환경 변조가 방지된 상태입니다." >> $CREATE_FILE
else
    echo "<span class='bad'>취약</span> : 홈 디렉터리 내 환경변수 파일에 타 사용자 쓰기 권한이 설정되어, 비인가자가 사용자 환경을 변조할 위험이 있습니다." >> $CREATE_FILE
fi
rm -rf homeconf.txt
echo "</pre>" >> $CREATE_FILE

# ===== 18. Directory File Permission Check =====
echo "<h2>18. Directory File Permission Check</h2><pre>" >> $CREATE_FILE
HOMEDIRS="/sbin /etc /bin /usr/bin /usr/sbin"

for dir in $HOMEDIRS; do
    ls -dalL $dir | grep -P '\d.........' >> $CREATE_FILE
done

echo "" > dir.txt

for dir in $HOMEDIRS; do
    if [ -d $dir ]; then
        if [ `ls -dalL $dir | awk '{print $1}' |grep "........-."| wc -l` -eq 0 ]; then
            echo "Dir permission check result : bad" >> dir.txt
        else
            echo "Dir permission check result : good" >> dir.txt
        fi
    else
        echo " Dir permission check result : good" >> dir.txt
    fi
done

if [ `cat dir.txt | grep "bad" | wc -l` -eq 0 ]; then
    echo "<span class='good'>양호</span> : 주요 디렉터리의 타 사용자 쓰기 권한이 제한되어, 비인가자에 의한 환경 변조 및 침해 사고가 방지된 상태입니다." >> $CREATE_FILE
else
    echo "<span class='bad'>취약</span> : 주요 디렉터리에 타 사용자 쓰기 권한이 부여되어, 비인가자가 시스템 환경을 변조하여 침해 사고를 일으킬 위험이 있습니다." >> $CREATE_FILE
fi
rm -rf dir.txt
echo "</pre>" >> $CREATE_FILE

# ===== 19. PATH Conf Check =====
echo "<h2>19. Path Conf Check</h2><pre>" >> $CREATE_FILE
if [ `echo $PATH | grep "\.:" | wc -l` -eq 0 ]; then
echo $PATH >> $CREATE_FILE
    echo "<span class='good'>양호</span> : PATH 환경변수에 현재 디렉터리를 의미하는 '.'이 포함되지 않아, 악성 파일의 비의도적 실행이 방지된 상태입니다.." >> $CREATE_FILE
else
    echo "<span class='bad'>취약</span> : PATH 환경변수에 '.'이 포함되어 있어, 현재 디렉터리에 위치한 악성 파일이 비의도적으로 실행될 위험이 있습니다." >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 20. Root Remote Permission Check =====
echo "<h2>20. Root Remote Permission Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/pam.d/login ]; then
    ls -alL /etc/pam.d/login >> $CREATE_FILE
    if [ `ls -alL /etc/pam.d/login | awk '{print $1}' | grep '........-.'| wc -l` -eq 0 ]; then
        echo "<span class='bad'>취약</span> : root 원격 접근제어 설정 파일에 타 사용자 쓰기 권한이 부여되어, 비인가자가 설정을 변조하여 서비스 장애를 일으킬 위험이 있습니다." >> $CREATE_FILE
    else
        echo "<span class='good'>양호</span> : root 원격 접근제어 설정 파일의 타 사용자 쓰기 권한이 제한되어, 비인가자에 의한 설정 변조가 방지된 상태입니다." >> $CREATE_FILE
    fi
else
    echo "<span class='good'>양호</span> : 관련 파일이 없어 양호로 간주합니다(또는 확인 필요)." >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 21. ETC Files Permission Check =====
echo "<h2>21. ETC Files Permission Check</h2><pre>" >> $CREATE_FILE
DIR744="/etc/rc*.d/* /etc/inittab /etc/syslog.conf /etc/snmp/conf/snmpd.conf"
echo "" > etcfiles.txt

for check_dir in $DIR744; do
    if [ -f $check_dir ]; then
        ls -alL $check_dir >> $CREATE_FILE
        if [ `ls -alL $check_dir | awk '{print $1}' | grep '........w.' | wc -l` -eq 0 ]; then
            echo "ETC files permission check : good" >> etcfiles.txt
        else
            echo "ETC files permission check : bad" >> etcfiles.txt
        fi
    fi
done

if [ `cat etcfiles.txt | grep "bad" | wc -l` -eq 0 ]; then
    echo "<span class='good'>양호</span> : 기타 중요 파일의 타 사용자 쓰기 권한이 제한되어, 비인가자에 의한 시스템 설정 변조가 방지된 상태입니다." >> $CREATE_FILE
else
    echo "<span class='bad'>취약</span> : 기타 중요 파일에 타 사용자 쓰기 권한이 부여되어, 비인가자가 시스템 설정을 변조할 위험이 있습니다." >> $CREATE_FILE
fi
rm -rf etcfiles.txt
echo "</pre>" >> $CREATE_FILE

# ===== 22. Session Timeout Check =====
echo "<h2>22. Session Timeout Check</h2><pre>" >> $CREATE_FILE

echo "/etc/profile 내 세션 타임아웃(TMOUT) 설정 여부 점검" >> $CREATE_FILE

if [ -f /etc/profile ]; then
    cat /etc/profile | grep -i "TMOUT" | grep "=" >> $CREATE_FILE
else
    echo "/etc/profile이 존재하지 않습니다." >> $CREATE_FILE
fi

if [ -f /etc/profile ]; then
    if [ `cat /etc/profile | grep -v "#" | grep 'TMOUT.*[0-9]' | wc -l` -eq 1 ]; then
        echo "<span class='good'>양호</span> : 세션 타임아웃이 설정되어, 일정 시간 미사용 시 세션이 자동 종료되는 안전한 상태입니다." >> $CREATE_FILE
    else
        echo "<span class='bad'>취약</span> : 세션 타임아웃이 설정되지 않아, 유휴 세션 방치로 인한 기밀성 유출 및 가용성 저하 위험이 있습니다." >> $CREATE_FILE
    fi
else
    echo "<span class='bad'>취약</span> : /etc/profile이 존재하지 않습니다.." >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# HTML 종료 태그
echo "</body></html>" >> $CREATE_FILE

echo "HTML 파일 생성 완료: $CREATE_FILE"
