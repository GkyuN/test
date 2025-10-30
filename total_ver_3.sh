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
pre{background:#222;color:#dff1ff;padding:10px;border-radius:6px;overflow-x:auto;}
.good{color:#16a34a;font-weight:bold;}
.bad{color:#dc2626;font-weight:bold;}
</style>" >> $CREATE_FILE
echo "</head><body>" >> $CREATE_FILE
echo "<h1>시스템 점검 결과 (21501001_KY)</h1>" >> $CREATE_FILE

# ===== 01. Default ID Check =====
echo "<h2>01. Default ID Check</h2><pre>" >> $CREATE_FILE
if [ `cat /etc/passwd | grep -E "lp:|uucp:|nuucp:" | wc -l` -eq 0 ]; then
    echo "<span class='good'>양호</span>: 사용하지 않는 불필요한 기본 계정(lp, uucp, nuucp)이 존재하지 않아 안전합니다." >> $CREATE_FILE
else
    echo "<span class='bad'>취약</span>: 아래와 같이 사용하지 않는 Default 계정이 발견되었습니다." >>$CREATE_FILE
    cat /etc/passwd | grep -E "lp:|uucp:|nuucp:" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 02. Root Management Check =====
echo "<h2>02. Root Management Check</h2><pre>" >> $CREATE_FILE
if [ `awk -F: '$3==0' /etc/passwd | wc -l` -eq 1 ]; then
    echo "<span class='good'>양호</span>: UID '0'을 가진 계정은 root가 유일합니다." >> $CREATE_FILE
    awk -F: '$3==0 { print $1 " -> UID"$3 }' /etc/passwd >> $CREATE_FILE
else
    echo "<span class='bad'>취약</span>: root 외에 UID=0 계정이 발견되었습니다." >> $CREATE_FILE
    awk -F: '$3==0 { print $1 " -> UID"$3 }' /etc/passwd >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 03. Passwd File Permission Check =====
echo "<h2>03. Passwd File Permission Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/passwd ]; then
    ls -alL /etc/passwd >> $CREATE_FILE
    if [ `ls -alL /etc/passwd | awk '{print $1}' | grep ".rw-r--r--" | wc -l` -eq 1 ]; then
        echo "<span class='good'>양호</span>: /etc/passwd 권한이 644(-rw-r--r--) 입니다." >> $CREATE_FILE
    else
        echo "<span class='bad'>취약</span>: /etc/passwd 권한이 올바르지 않습니다." >> $CREATE_FILE
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
        echo "<span class='good'>양호</span>: /etc/group 권한이 644(-rw-r--r--) 입니다." >> $CREATE_FILE
    else
        echo "<span class='bad'>취약</span>: /etc/group 권한이 올바르지 않습니다." >> $CREATE_FILE
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
fi

min_len=$(grep '^PASS_MIN_LEN' /etc/login.defs | awk '{print $2}')
max_days=$(grep '^PASS_MAX_DAYS' /etc/login.defs | awk '{print $2}')
min_days=$(grep '^PASS_MIN_DAYS' /etc/login.defs | awk '{print $2}')

if [ "${min_len:-0}" -le 7 ] || [ "${max_days:-99999}" -gt 70 ] || [ "${min_days:-0}" -le 0 ]; then
    echo "<span class='bad'>취약</span>: 패스워드 정책이 보안 권고 기준에 미달합니다." >> $CREATE_FILE
else
    echo "<span class='good'>양호</span>: 패스워드 정책이 적절합니다." >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 06. Shell Check =====
echo "<h2>06. Shell Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/passwd ]; then
    cat /etc/passwd | grep -E "^daemon|^bin|^sys|^listen|^nobody" >> $CREATE_FILE
    echo "" >> $CREATE_FILE
    if [ `cat /etc/passwd | grep -E "^daemon|^bin|^sys|^listen|^nobody" | grep -E "false|nologin" | wc -l` -eq 0 ]; then
        echo "<span class='good'>양호</span>: 불필요 계정에 로그인 차단 쉘이 적용되었습니다." >> $CREATE_FILE
    else
        echo "<span class='bad'>취약</span>: 일부 시스템 계정이 로그인 가능 상태입니다." >> $CREATE_FILE
    fi
else
    echo "/etc/passwd file not found" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 07. SU Check =====
echo "<h2>07. SU Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/pam.d/su ]; then
    cat /etc/pam.d/su >> $CREATE_FILE
else
    echo "/etc/pam.d/su file not found" >> $CREATE_FILE
fi

if [ `cat /etc/pam.d/su 2>/dev/null | grep 'pam_wheel.so' | grep -v '#' | wc -l` -eq 0 ]; then
    echo "<span class='bad'>SU Check Result: BAD</span>" >> $CREATE_FILE
else
    echo "<span class='good'>SU Check Result: GOOD</span>" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# ===== 08. Shadow Check =====
echo "<h2>08. Shadow Check</h2><pre>" >> $CREATE_FILE
if [ -f /etc/shadow ]; then
    ls -alL /etc/shadow >> $CREATE_FILE
    if [ `ls -alL /etc/shadow | awk '{print $1}' | grep "..-----" | wc -l` -eq 1 ]; then
        echo "<span class='good'>양호</span>: /etc/shadow 권한이 안전합니다." >> $CREATE_FILE
    else
        echo "<span class='bad'>취약</span>: /etc/shadow 권한이 잘못되었습니다." >> $CREATE_FILE
    fi
else
    echo "/etc/shadow file not found" >> $CREATE_FILE
fi
echo "</pre>" >> $CREATE_FILE

# HTML 종료
echo "</body></html>" >> $CREATE_FILE

echo "HTML 파일 생성 완료: $CREATE_FILE"

