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
    echo "lp,uucp,nuucp not found" >> $CREATE_FILE
else
    cat /etc/passwd | grep -E "lp:|uucp:|nuucp:" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 02. Root Management Check =====
echo "<h2>02. Root Management Check</h2><pre>" >> $CREATE_FILE
if [ `awk -F: '$3==0' /etc/passwd | wc -l` -eq 1 ]; then
    echo "===== GOOD ====" >> $CREATE_FILE
    awk -F: '$3==0 { print $1 " -> UID"$3 }' /etc/passwd >> $CREATE_FILE
else
    echo "===== BAD ====" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 03. Passwd File Permission Check =====
echo "<h2>03. Passwd File Permission Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/passwd ]; then
    ls -alL /etc/passwd >> $CREATE_FILE
    if [ `ls -alL /etc/passwd | awk '{print $1}' | grep ".rw-r--r--" | wc -l` -eq 1 ]; then
        echo "Passwd File Permission Check: GOOD" >> $CREATE_FILE
    else
        echo "Passwd File Permission Check: BAD" >> $CREATE_FILE
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
        echo "Group File Permission Check: GOOD" >> $CREATE_FILE
    else
        echo "Group File Permission Check: BAD" >> $CREATE_FILE
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
    result="BAD"
else
    result="GOOD"
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
        echo "Shell Check Result: GOOD" >> $CREATE_FILE
    else
        echo "Shell Check Result: BAD" >> $CREATE_FILE
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
        echo "Shadow Check Result: GOOD" >> $CREATE_FILE
    else
        echo "Shadow Check Result: BAD" >> $CREATE_FILE
    fi
else
    echo "/etc/shadow file not found" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# HTML 종료
echo "</body></html>" >> $CREATE_FILE

echo "HTML 파일 생성 완료: $CREATE_FILE"

