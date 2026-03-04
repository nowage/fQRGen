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
   - **다중 캡처 가능**: `1,2,3` 처럼 쉼표로 연결 가능
   - **탭 번호**:
     - `1` 또는 `qr`: QR 생성
     - `2` 또는 `history`: 히스토리
     - `3` 또는 `settings`: 설정
     - `all`: 전체 탭 일괄 캡처

4. **캡처 실행 (Execute Capture)**:
   - `_tool/capture.sh` 스크립트를 사용합니다.

   ```bash
   # 사용법: sh _tool/capture.sh [대상]
   # 대상: 1, 2, 3, all, qr, history, settings

   # 예: QR 생성 탭 캡처
   sh _tool/capture.sh 1

   # 예: 전체 탭 일괄 캡처
   sh _tool/capture.sh all

   # 예: 히스토리 + 설정 연속 캡처
   sh _tool/capture.sh 2,3
   ```

5. **결과 확인 (Check Result)**:
   - 캡처된 이미지는 `capture/` 폴더에 저장됩니다.

   ```bash
   open capture/
   ```

6. **활용 (Usage)**:
   - 캡처된 이미지를 `Issue.md`나 문서에 첨부하여 증거 자료로 활용합니다.
