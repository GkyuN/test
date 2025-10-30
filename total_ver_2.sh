#!/bin/bash
# 통합 HTML 출력 스크립트
CREATE_FILE="21501001_KY.html"

# HTML 시작
echo "<!DOCTYPE html>" > $CREATE_FILE
echo "<html lang='ko'>" >> $CREATE_FILE
echo "<head><meta charset='UTF-8'><title>시스템 점검 결과</title>" >> $CREATE_FILE
echo "<style>
body{font-family:monospace;background:#f4f4f4;padding:20px;}
h1,h2{color:#0a0a0a;}
pre{background:#222;color:#0f0;padding:10px;border-radius:6px;overflow-x:auto;}
</style>" >> $CREATE_FILE
echo "</head><body>" >> $CREATE_FILE
echo "<h1>시스템 점검 결과 (21501001_KY)</h1>" >> $CREATE_FILE

# ===== 01. Default ID Check =====
echo "<h2>01. Default ID Check</h2><pre>" >> $CREATE_FILE
if [ `cat /etc/passwd | grep -E "lp:|uucp:|nuucp:" | wc -l` -eq 0 ]; then
    echo "양호: 사용하지 않는 불필요한 기본 계정(lp, uucp, nuucp)이 존재하지 않아 안전합니다." >> $CREATE_FILE
else
		echo "취약: 아래와 같이 사용하지 않는 Default 계정이 발견되었습니다. 패스워드 추측 공격 등에 악용될 수 있으므로 삭제하는 것을 권장합니다." >>$CREATE_FILE
    cat /etc/passwd | grep -E "lp:|uucp:|nuucp:" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 02. Root Management Check =====
echo "<h2>02. Root Management Check</h2><pre>" >> $CREATE_FILE
if [ `awk -F: '$3==0' /etc/passwd | wc -l` -eq 1 ]; then
    echo "양호: UID '0'을 가진 계정은 root가 유일하며, 관리자 계정이 적절하게 관리되고 있습니다.">> $CREATE_FILE
    awk -F: '$3==0 { print $1 " -> UID"$3 }' /etc/passwd >> $CREATE_FILE
else
    echo "취약: root 계정 외에 UID가 '0'인 계정이 발견되었습니다. UID '0'은 관리자 권한을 의미하므로, 비인가 계정에 부여될 경우 시스템 전체가 위험에 노출될 수 있습니다." >> $CREATE_FILE
    awk -F: '$3==0 { print $1 " -> UID"$3 }' /etc/passwd >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 03. Passwd File Permission Check =====
echo "<h2>03. Passwd File Permission Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/passwd ]; then
    ls -alL /etc/passwd >> $CREATE_FILE
    if [ `ls -alL /etc/passwd | awk '{print $1}' | grep ".rw-r--r--" | wc -l` -eq 1 ]; then
        echo "양호: /etc/passwd 파일의 권한이 644(-rw-r--r--)로 안전하게 설정되어 있습니다." >> $CREATE_FILE
    else
        echo "취약:/etc/passwd 파일의 권한 설정이 올바르지 않습니다. 이는 계정 정보 유출 및 권한 상승 공격에 악용될 수 있습니다. " >> $CREATE_FILE
    fi
else
    echo "/etc/passwd file not found" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 04. Group File Permission Check =====
echo "<h2>04. Group File Permission Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/group ]; then
    ls -alL /etc/group >> $CREATE_FILE
    if [ `ls -alL /etc/group | awk '{print $1}' | grep ".rw-r--r--" | wc -l` -eq 1 ]; then
        echo "양호: /etc/group 파일의 권한이 644(-rw-r--r--)로 안전하게 설정되어 있습니다." >> $CREATE_FILE
    else
        echo "취약: /etc/group 파일의 권이 올바르지 않습니다. 공격자가 파일을 변조하여 root 그룹에 사용자를 추가할 경우, root 권한을 획득할 수 있습니다" >> $CREATE_FILE
    fi
else
    echo "/etc/group file not found" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 05. Passwd Rule Check =====
echo "<h2>05. Passwd Rule Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/login.defs ]; then
    grep -v '#' /etc/login.defs | grep -i "PASS_MIN_LEN" >> $CREATE_FILE
    grep -v '#' /etc/login.defs | grep -i "PASS_MAX_DAYS" >> $CREATE_FILE
    grep -v '#' /etc/login.defs | grep -i "PASS_MIN_DAYS" >> $CREATE_FILE
else
    echo "/etc/login.defs file not found" >> $CREATE_FILE
fi

min_len=$(grep '^PASS_MIN_LEN' /etc/login.defs | awk '{print $2}')
max_days=$(grep '^PASS_MAX_DAYS' /etc/login.defs | awk '{print $2}')
min_days=$(grep '^PASS_MIN_DAYS' /etc/login.defs | awk '{print $2}')

if [ "${min_len:-0}" -le 7 ] || [ "${max_days:-99999}" -gt 70 ] || [ "${min_days:-0}" -le 0 ]; then
    result="취약: 패스워드 정책(최소 길이, 사용 기간)이 보안 권고 기준을 만족하지 않습니다. 이는 추측 가능한 취약한 패스워드 사용으로 이어져 계정 탈취의 위험을 높입니다."
else
    result="양호: 패스워드 최소 길이, 최대/최소 사용 기간이 보안 정책에 맞게 설정되었습니다."
fi
echo "========[Result]========" >> $CREATE_FILE
echo "Passwd Rule: $result" >> $CREATE_FILE
echo "========================" >> $CREATE_FILE
echo "</pre>" >> $CREATE_FILE

# ===== 06. Shell Check =====
echo "<h2>06. Shell Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/passwd ]; then
    cat /etc/passwd | grep -E "^daemon|^bin|^sys|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher" | grep -v "admin" >> $CREATE_FILE
    echo "" >> $CREATE_FILE
    if [ `cat /etc/passwd | grep -E "^daemon|^bin|^sys|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher" | grep -v "admin" | grep -E "false|nologin" | wc -l` -eq 0 ]; then
        echo "양호: 로그인이 필요하지 않은 주요 시스템 계정들에 로그인을 차단하는 쉘(/bin/false, /sbin/nologin)이 올바르게 부여되었습니다." >> $CREATE_FILE
    else
        echo "취약: 로그인이 필요하지 않은 일부 시스템 계정에 로그인 가능한 쉘이 부여되었습니다. 이는 시스템에 비인가적인 접근 경로로 악용될 수 있어 침해 가능성을 높입니다." >> $CREATE_FILE
    fi
else
    echo "/etc/passwd file not found" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 07. SU Check =====
echo "<h2>07. SU Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/pam.d/su ]; then
    echo "1. /etc/pam.d/su File" >> $CREATE_FILE
    cat /etc/pam.d/su >> $CREATE_FILE
else
    echo "/etc/pam.d/su file not found" >> $CREATE_FILE
fi

if [ -f /etc/group ]; then
    echo "2. /etc/group File" >> $CREATE_FILE
    cat /etc/group >> $CREATE_FILE
fi

if [ `cat /etc/pam.d/su 2>/dev/null | grep -v 'trust' | grep 'pam_wheel.so' | grep 'user_uid' | grep -v '#' | wc -l` -eq 0 ]; then
    echo "SU Check Result: BAD" >> $CREATE_FILE
else
    echo "SU Check Result: GOOD" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 08. Shadow Check =====
echo "<h2>08. Shadow Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/shadow ]; then
    ls -alL /etc/shadow >> $CREATE_FILE
    if [ `ls -alL /etc/shadow | awk '{print $1}' | grep "..-----" | wc -l` -eq 1 ]; then
        echo "양호: /etc/shadow 파일의 소유자가 root이고, 권한이 400(-r--------)으로 설정되어 암호화된 패스워드 정보를 안전하게 보호하고 있습니다." >> $CREATE_FILE
    else
        echo "취약: /etc/shadow 파일의 소유자 또는 권한이 올바르지 않습니다. root 외의 사용자에게 읽기/쓰기 권한이 부여될 경우, 패스워드 해시가 유출되어 무차별 대입 공격에 악용될 수 있습니다. (권장: root, 400)" >> $CREATE_FILE
    fi
else
    echo "/etc/shadow file not found" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# HTML 종료
echo "</body></html>" >> $CREATE_FILE

echo "HTML 파일 생성 완료: $CREATE_FILE"

