---
name: capture
description: "앱 UI 캡처 워크플로우 (스크린샷 -> 문서화/검증)"
---

1. **앱 실행 (Run App)**:
   - 앱이 실행 중인지 확인하고, 필요 시 빌드 후 실행합니다.

   ```bash
   # 앱 실행 여부 확인
   pgrep -x nowQRGen || xcodebuild -scheme nowQRGen -project nowQRGen/nowQRGen.xcodeproj -configuration Debug build && open "$(xcodebuild -scheme nowQRGen -project nowQRGen/nowQRGen.xcodeproj -configuration Debug -showBuildSettings 2>/dev/null | grep -m1 'BUILT_PRODUCTS_DIR' | awk '{print $3}')/nowQRGen.app"
   ```

2. **UI 준비 (Prepare Target UI)**:
   - 캡처할 대상 탭/창을 엽니다.

   **A. 메인 탭 전환**
   ```bash
   sleep 2
   # QR 생성 탭 (Cmd+1)
   osascript -e 'tell application "System Events" to tell process "nowQRGen" to keystroke "1" using command down'

   # 히스토리 탭 (Cmd+2)
   osascript -e 'tell application "System Events" to tell process "nowQRGen" to keystroke "2" using command down'

   # 설정 탭 (Cmd+3)
   osascript -e 'tell application "System Events" to tell process "nowQRGen" to keystroke "3" using command down'
   ```

3. **캡처 대상 확인 (Identify Target)**:
   - **인자 파싱**: `$ARGUMENTS`에서 대상과 접미사를 분리합니다.
     - 예: `1,2,3 ko` → 대상=`1,2,3`, 접미사=`ko`
     - 예: `all` → 대상=`all`, 접미사 없음
   - **다중 캡처 가능**: `1,2,3` 처럼 쉼표로 연결 가능
   - **탭 번호**:
     - `1` 또는 `qr`: QR 생성
     - `2` 또는 `history`: 히스토리
     - `3` 또는 `settings`: 설정
     - `all`: 전체 탭 일괄 캡처
   - **접미사** (옵션): `ko`, `en` 등 파일명에 추가할 구분자

4. **캡처 실행 (Execute Capture)**:
   - `_tool/capture.sh` 스크립트를 사용합니다.
   - **앱 윈도우만 캡처**합니다 (전체 화면 아님).
   - Python Quartz로 CGWindowID를 가져와 `screencapture -l` 사용.

   ```bash
   # 사용법: sh _tool/capture.sh [대상] [접미사]
   # 대상: 1, 2, 3, all, qr, history, settings
   # 접미사: ko, en 등 (옵션)

   # 예: QR 생성 탭 캡처
   sh _tool/capture.sh 1

   # 예: 전체 탭 일괄 캡처
   sh _tool/capture.sh all

   # 예: 히스토리 + 설정 연속 캡처 (ko 접미사)
   sh _tool/capture.sh 2,3 ko
   ```

5. **결과 확인 (Check Result)**:
   - 캡처된 이미지는 `capture/` 폴더에 저장됩니다.
   - Read 도구로 캡처 이미지를 확인하여 사용자에게 보여줍니다.

   ```bash
   ls -la capture/screen_*_${TIMESTAMP}*.png
   ```

6. **활용 (Usage)**:
   - 캡처된 이미지를 `Issue.md`나 문서에 첨부하여 증거 자료로 활용합니다.
