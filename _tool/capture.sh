#!/bin/bash
#
# Usage:
#   sh _tool/capture.sh [대상] [접미사]
#
# Arguments:
#   대상    : (필수) 캡처할 탭/화면 지정
#             1, qr         - QR 생성 탭
#             2, history     - 히스토리 탭
#             3, settings    - 설정 탭
#             all            - 전체 탭 일괄 캡처
#             1,2,3          - 쉼표로 다중 지정
#   접미사  : (옵션) 파일명에 추가할 접미사 (예: ko, en)
#
# 파일명 규칙:
#   기본: screen_{탭번호}_{이름}_{접미사}.png
#   중복 시: screen_{탭번호}_{이름}_{접미사}_{타임스탬프}.png
#
# Examples:
#   sh _tool/capture.sh 1
#   sh _tool/capture.sh all
#   sh _tool/capture.sh 1,3 ko

set -e

APP_NAME="nowQRGen"
CAPTURE_DIR="capture"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SUFFIX="${2:+_$2}"

mkdir -p "$CAPTURE_DIR"

# 앱 실행 확인
if ! pgrep -x "$APP_NAME" > /dev/null 2>&1; then
    echo "❌ $APP_NAME 이 실행 중이 아닙니다. 먼저 앱을 실행하세요."
    exit 1
fi

# 앱 윈도우 ID 가져오기 (CGWindowID via Python Quartz)
get_window_id() {
    python3 -c "
import Quartz
wl = Quartz.CGWindowListCopyWindowInfo(Quartz.kCGWindowListOptionOnScreenOnly, Quartz.kCGNullWindowID)
for w in wl:
    if w.get('kCGWindowOwnerName') == '$APP_NAME' and w.get('kCGWindowLayer', -1) == 0:
        print(int(w['kCGWindowNumber']))
        break
" 2>/dev/null
}

# 파일명 결정 (중복 시 타임스탬프 추가)
resolve_filename() {
    local tab_num=$1
    local name=$2
    local base="${CAPTURE_DIR}/screen_${tab_num}_${name}${SUFFIX}.png"

    if [ -f "$base" ]; then
        echo "${CAPTURE_DIR}/screen_${tab_num}_${name}${SUFFIX}_${TIMESTAMP}.png"
    else
        echo "$base"
    fi
}

# 탭 전환 함수 (View 메뉴 인덱스 기반 - OS 언어 무관)
# View 메뉴 구조: [탭 막대 보기, 모든 탭 보기, separator, QR생성(4), 히스토리(5), 설정(6), ...]
switch_tab() {
    local tab_num=$1
    osascript -e "tell application \"$APP_NAME\" to activate"
    sleep 0.3

    local menu_index=""
    case "$tab_num" in
        1) menu_index=4 ;;
        2) menu_index=5 ;;
        3) menu_index=6 ;;
    esac

    osascript -e "tell application \"System Events\" to tell process \"$APP_NAME\" to click menu item $menu_index of menu 1 of menu bar item 5 of menu bar 1"
    sleep 1.5
}

# 윈도우 캡처 함수
capture_window() {
    local tab_num=$1
    local name=$2
    local filename
    filename=$(resolve_filename "$tab_num" "$name")

    local window_id
    window_id=$(get_window_id)

    if [ -n "$window_id" ]; then
        screencapture -l "$window_id" -x "$filename"
    else
        echo "⚠️  윈도우 ID를 가져올 수 없습니다. 전체 화면을 캡처합니다."
        screencapture -x "$filename"
    fi

    if [ -f "$filename" ]; then
        echo "✅ 캡처 완료: $filename"
    else
        echo "❌ 캡처 실패: $name"
    fi
}

# 단일 대상 캡처
capture_single() {
    local target=$1

    case "$target" in
        1|qr)
            echo "📸 QR 생성 탭 캡처 중..."
            switch_tab 1
            capture_window 1 "qr"
            ;;
        2|history)
            echo "📸 히스토리 탭 캡처 중..."
            switch_tab 2
            capture_window 2 "history"
            ;;
        3|settings)
            echo "📸 설정 탭 캡처 중..."
            switch_tab 3
            capture_window 3 "settings"
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
    echo "사용법: sh _tool/capture.sh [대상] [접미사]"
    echo "대상: 1(qr), 2(history), 3(settings), all"
    echo "접미사: ko, en 등 (옵션)"
    exit 1
fi

# 쉼표로 분리하여 다중 캡처 처리
IFS=',' read -ra TARGETS <<< "$1"
for target in "${TARGETS[@]}"; do
    target=$(echo "$target" | xargs)  # 공백 제거
    capture_single "$target"
done
