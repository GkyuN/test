#!/bin/bash

# 테스트 결과 파일명
CREATE_FILE="test_22_result.html"

# 1. HTML 헤더 및 스타일 생성 (기존 스타일 유지)
echo "<!DOCTYPE html>" > $CREATE_FILE
echo "<html lang='ko'>" >> $CREATE_FILE
echo "<head><meta charset='UTF-8'><title>22번 항목 테스트</title>" >> $CREATE_FILE
echo "<style>
body{font-family:monospace;background:#f4f4f4;padding:20px;}
h2{color:#0a0a0a; border-bottom: 2px solid #ddd; padding-bottom: 10px;}
pre{background:#222;color:#dff1ff;padding:10px;border-radius:6px;overflow-x:auto;white-space: pre-wrap;}
.good{color:#16a34a;font-weight:bold;}
.bad{color:#dc2626;font-weight:bold;}
</style>" >> $CREATE_FILE
echo "</head><body>" >> $CREATE_FILE

# ===== 22. Session Timeout Check 로직 시작 =====
echo "<h2>22. Session Timeout Check (Test)</h2><pre>" >> $CREATE_FILE

# [증거 확보 단계]
if [ -f /etc/profile ]; then
    echo "Checking TMOUT in /etc/profile :" >> $CREATE_FILE
    
    # TMOUT 문자열이 포함된 줄이 있는지 확인
    GREP_CHECK=`grep -i "TMOUT" /etc/profile`
    
    if [ -z "$GREP_CHECK" ]; then
        # 문자열이 아예 없으면 없다고 출력
        echo ">> TMOUT String Not Found in /etc/profile" >> $CREATE_FILE
    else
        # 있으면 해당 줄 출력 (주석 포함)
        echo "$GREP_CHECK" >> $CREATE_FILE
    fi
else
    echo ">> /etc/profile File Not Found" >> $CREATE_FILE
fi

echo " " >> $CREATE_FILE
echo "======[Result]=======" >> $CREATE_FILE

# [결과 판단 로직 단계]
if [ -f /etc/profile ]; then
    # 1단계: 파일 안에 'TMOUT'이라는 글자가 아예 없는지 확인 (최신 리눅스 케이스)
    if [ `grep -i "TMOUT" /etc/profile | wc -l` -eq 0 ]; then
        # 상황 A: 변수 자체가 없음
        echo "<span class='bad'>취약</span> : /etc/profile 파일 내에 TMOUT 변수 자체가 존재하지 않습니다." >> $CREATE_FILE
    else
        # 2단계: 글자는 있음. 유효한 설정인지 확인 (주석 # 없고, 값 설정됨)
        # grep -v "^#" : 맨 앞에 #이 없는 줄만 찾음
        if [ `grep -v "^#" /etc/profile | grep "TMOUT" | grep "=" | wc -l` -ge 1 ]; then
            # 상황 B: 정상 설정 (양호)
            echo "<span class='good'>양호</span> : 세션 타임아웃이 설정되어, 일정 시간 미사용 시 세션이 자동 종료되는 안전한 상태입니다." >> $CREATE_FILE
        else
            # 상황 C: 글자는 있는데 주석처리 되었거나 값이 없음 (취약)
            echo "<span class='bad'>취약</span> : 세션 타임아웃(TMOUT) 변수는 존재하나, 설정이 비활성화(주석 등) 되어 있습니다." >> $CREATE_FILE
        fi
    fi
else
    # 상황 D: 파일 자체가 없음
    echo "<span class='bad'>취약</span> : /etc/profile 파일이 존재하지 않아 확인할 수 없습니다." >> $CREATE_FILE
fi

echo "</pre>" >> $CREATE_FILE
# ===== 로직 끝 =====

echo "</body></html>" >> $CREATE_FILE

echo "테스트 완료! 생성된 파일: $CREATE_FILE"
echo "내용 확인을 위해 'cat $CREATE_FILE'을 입력하거나 브라우저로 파일을 열어보세요."
