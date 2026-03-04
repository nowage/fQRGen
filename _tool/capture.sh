#!/bin/bash
#
# Usage:
#   sh _tool/capture.sh [대상]
#
# Arguments:
#   대상  : (필수) 캡처할 탭/화면 지정
#           1, qr         - QR 생성 탭
#           2, history     - 히스토리 탭
#           3, settings    - 설정 탭
#           all            - 전체 탭 일괄 캡처
#           1,2,3          - 쉼표로 다중 지정
#
# Examples:
#   sh _tool/capture.sh 1
#   sh _tool/capture.sh all
#   sh _tool/capture.sh 1,3

set -e

APP_NAME="nowQRGen"
CAPTURE_DIR="capture"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$CAPTURE_DIR"

# 앱 실행 확인
if ! pgrep -x "$APP_NAME" > /dev/null 2>&1; then
    echo "❌ $APP_NAME 이 실행 중이 아닙니다. 먼저 앱을 실행하세요."
    exit 1
fi

# 탭 전환 함수
switch_tab() {
    local tab_num=$1
    osascript -e "tell application \"System Events\" to tell process \"$APP_NAME\" to keystroke \"$tab_num\" using command down"
    sleep 1
}

# 윈도우 캡처 함수
capture_window() {
    local target=$1
    local filename="${CAPTURE_DIR}/screen_${target}_${TIMESTAMP}.png"

    # 윈도우 ID 가져오기
    local window_id
    window_id=$(osascript -e "tell application \"System Events\" to tell process \"$APP_NAME\" to get id of window 1" 2>/dev/null || echo "")

    if [ -z "$window_id" ]; then
        echo "⚠️  윈도우를 찾을 수 없습니다. 전체 화면을 캡처합니다."
        screencapture -x "$filename"
    else
        screencapture -l "$window_id" -x "$filename"
    fi

    if [ -f "$filename" ]; then
        echo "✅ 캡처 완료: $filename"
    else
        echo "❌ 캡처 실패: $target"
    fi
}

# 단일 대상 캡처
capture_single() {
    local target=$1

    case "$target" in
        1|qr)
            echo "📸 QR 생성 탭 캡처 중..."
            switch_tab 1
            capture_window "qr"
            ;;
        2|history)
            echo "📸 히스토리 탭 캡처 중..."
            switch_tab 2
            capture_window "history"
            ;;
        3|settings)
            echo "📸 설정 탭 캡처 중..."
            switch_tab 3
            capture_window "settings"
            ;;
        all)
            echo "📸 전체 탭 일괄 캡처 시작..."
            capture_single 1
            capture_single 2
            capture_single 3
            echo "🎉 전체 캡처 완료!"
            ;;
        *)
            echo "❌ 알 수 없는 대상: $target"
            echo "사용 가능: 1(qr), 2(history), 3(settings), all"
            exit 1
            ;;
    esac
}

# 메인 실행
if [ -z "$1" ]; then
    echo "사용법: sh _tool/capture.sh [대상]"
    echo "대상: 1(qr), 2(history), 3(settings), all"
    exit 1
fi

# 쉼표로 분리하여 다중 캡처 처리
IFS=',' read -ra TARGETS <<< "$1"
for target in "${TARGETS[@]}"; do
    target=$(echo "$target" | xargs)  # 공백 제거
    capture_single "$target"
done
