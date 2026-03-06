# fQRGen 이슈 트래커
* Issue HWM: 8
* Save Point :
      - 2026.03.05: 40b981d (Close Issue7)
      - 2026.03.05 v1.1 Release (0057d2e)
      - 2026.03.04: f1323ae (Close Issue1)

# 🤔 결정사항

# 🌱 이슈후보

# 🚧 진행중
# 📕 중요
## Issue8: 프로젝트명 변경 (fQRGen → fQRGen) 전체 마이그레이션 (등록: 2026.03.06)
* 목적: 프로젝트명을 fQRGen에서 fQRGen으로 전면 변경 (문서, 코드, Xcode, GitHub)
* 상세:
    - 상위 폴더는 이미 fQRGen/으로 변경 완료
    - 내부 Xcode 폴더(fQRGen/fQRGen/, fQRGen.xcodeproj 등)는 아직 미변경
    - 문서/코드 내 fQRGen 참조를 fQRGen으로 일괄 수정 (71개 파일)
    - Xcode 프로젝트명, scheme, target, 내부 폴더명 변경
    - GitHub 레포지토리 이름을 fQRGen으로 변경 (또는 기존 삭제 후 재생성)
    - 번들 ID(com.nowage.nowQRGen)는 별도 검토 필요 (앱 식별자 변경 시 사용자 데이터 영향)


### Issue8_1: 문서/코드/스크립트 내 fQRGen 참조 일괄 수정 (등록: 2026.03.06)
* 목적: 71개 파일에서 fQRGen 문자열을 fQRGen으로 변경
* 상세:
    - 현재 상태: 상위 폴더(fQRGen/)는 변경 완료, 파일 내용은 아직 fQRGen 참조 유지
    - CLAUDE.md, GEMINI.md, Issue.md 등 프로젝트 문서 수정
    - .claude/rules/*.md, .agent/rules/*.md 등 에이전트 규칙 파일 수정
    - .agent/skills/*/scripts/*.py 등 스크립트 내 경로/이름 수정
    - .claude/commands/*.md 워크플로우 문서 수정
    - _doc_design/*.md 설계 문서 수정
    - _tool/capture.sh 등 도구 스크립트 수정
    - Swift 소스 코드 내 주석/문자열 리터럴 수정 (번들 ID는 별도 검토)

### Issue8_2: Xcode 프로젝트명 fQRGen → fQRGen 변경 (등록: 2026.03.06)
* 목적: Xcode 프로젝트, scheme, target, 내부 폴더명을 fQRGen으로 변경
* 상세:
    - 현재 상태: 상위 폴더는 fQRGen/으로 변경 완료, 내부는 아직 fQRGen 유지
    - fQRGen/fQRGen/ → fQRGen/fQRGen/ 소스 디렉토리 리네임
    - fQRGen/fQRGen.xcodeproj → fQRGen/fQRGen.xcodeproj 리네임
    - project.pbxproj 내부 참조 일괄 수정
    - fQRGen/fQRGenTests/ → fQRGen/fQRGenTests/ 리네임
    - fQRGen/fQRGenUITests/ → fQRGen/fQRGenUITests/ 리네임
    - scheme명 변경 (fQRGen → fQRGen)
    - target명 및 product name 변경
    - 번들 ID 변경 여부는 사용자와 협의 필요 (com.nowage.nowQRGen → com.nowage.fQRGen)

### Issue8_3: GitHub 레포지토리 이름 변경 (fQRGen으로) (등록: 2026.03.06)
* 목적: GitHub 레포지토리명을 fQRGen으로 변경하거나, 기존 삭제 후 재생성
* 상세: 
    - 방법 1: gh repo rename fQRGen으로 기존 레포 이름 변경 시도
    - 방법 2: 이름 변경 불가 시 기존 레포(nowage/qr-code-generator) 삭제 후 nowage/fQRGen으로 재생성
    - git remote origin URL 업데이트
    - 기존 레포의 이슈/PR/릴리즈 등 데이터 보존 여부 확인

# 📙 일반
# 📘 선택

# 🌱 이슈후보

# ✅ 완료
## Issue7: 캡처 스크립트 개선 및 웹페이지 스크린샷 적용 (등록: 2026.03.05) (✅ 완료, 40b981d) ✅
* 목적: capture.sh를 앱 윈도우 전용 캡처로 개선하고, 캡처된 스크린샷을 제품 웹페이지에 적용
* 상세:
    - 전체 화면 캡처 → 앱 윈도우만 캡처 (Python Quartz CGWindowID 활용)
    - 탭 전환 방식: keystroke → View 메뉴 인덱스 클릭 (OS 언어 무관)
    - 파일명 패턴: `screen_{탭번호}_{이름}_{접미사}.png` (중복 시 타임스탬프 추가)
    - 접미사 인자 지원 (ko, en 등)
    - capture/ 폴더 .gitignore 추가
* 구현 명세:
    - `_tool/capture.sh`: `get_window_id()` 함수에 Python Quartz `CGWindowListCopyWindowInfo` 사용, `switch_tab()` 메뉴 인덱스 기반으로 변경, `resolve_filename()` 중복 파일명 처리 추가
    - `.claude/commands/capture.md`: 접미사 인자 설명 및 윈도우 캡처 방식 명시
    - `.gitignore`: `capture/` 폴더 추가

## Issue6: QR 코드 생성 후 결과 영역으로 자동 스크롤 추가 (등록: 2026.03.04) (✅ 완료, 924b756) ✅
* 목적: QR 코드 생성 버튼 클릭 시 생성된 결과로 화면이 자동 스크롤되도록 하여 사용자 편의성을 개선함
* 상세:
    - QRGeneratorView.swift에 ScrollViewReader 추가
    - 코드 생성 버튼 클릭 시 id("qrResult") 요소로 scrollTo 동작 호출
* 구현 명세:
    - `QRGeneratorView.swift` 내의 스크롤 영역을 `ScrollViewReader`로 감싸고, 결과 뷰에 `.id("qrResult")` 부여
    - 버튼 액션 함수 `generateQRCode(proxy: ScrollViewProxy)`에서 코드가 성공적으로 생성되었을 때, `DispatchQueue.main.asyncAfter`와 `withAnimation` 블록 내에서 `proxy.scrollTo("qrResult", anchor: .center)`를 호출
* 완료 항목:
    - [x] ScrollViewReader 추가
    - [x] 스크롤 타겟 ID 설정 및 자동 스크롤 구현

## Issue5: 앱 탭 전환 단축키 추가 (Cmd+1/2/3) (등록: 2026.03.04) (✅ 완료, 9738f2f) ✅
* 목적: Cmd+1(QR 생성), Cmd+2(히스토리), Cmd+3(설정)으로 탭 전환 단축키를 추가하여 키보드 접근성 향상
* 상세:
    - fQRGenApp.swift의 `.commands` 블록에 Cmd+1/2/3 단축키 정의
    - NotificationCenter를 통해 MainTabView의 selectedTab 변경
    - 기존 Cmd+, (설정) 단축키와 동일한 패턴으로 구현
* 구현 명세:
    - `fQRGenApp.swift`: `.commands` 내 `CommandGroup`에 Cmd+1/2/3 Button 추가, 각각 "SelectTab" Notification 발송
    - `MainTabView.swift`: `.onReceive`로 Notification 수신하여 `selectedTab` 값 변경

## Issue4: 입력 초기값 변경 및 폰트 크기 확대 (등록: 2026.03.04) (✅ 완료, 690bdb7) ✅
* 목적: URL 초기값을 https://finfra.kr/en/으로 설정하고, 텍스트 입력 폰트 크기를 늘려 사용성을 개선함
* 상세: 
    - QRGeneratorView.swift의 inputText 초기값을 'https://finfra.kr/en/'으로 변경
    - TextEditor에 .font() 수식어를 사용하여 폰트 크기를 기본 글꼴 대비 약 2배 확대 (예: .title 또는 .system(size: 24) 등 반영)
* 구현 명세:
    - `QRGeneratorView.swift`의 `inputText` 속성 기본값을 `"https://finfra.kr/en/"`으로 수정하여 앱 런칭 시 해당 URL이 기본으로 입력되도록 함
    - 사용자가 입력하는 텍스트가 더 잘 보이도록 `TextEditor`에 `.font(.system(size: 24))`를 추가 적용함
* 완료 항목:
    - [x] 초기 텍스트 값 설정
    - [x] 폰트 사이즈 키우기 적용

## Issue2: cmd+, 설정 단축키가 새 윈도우를 여는 문제 수정 (등록: 2026.03.04) (✅ 완료, 8187371) ✅
* 목적: cmd+, 단축키 입력 시 별도 Settings 윈도우가 열리는 대신, 기존 메인 윈도우의 설정 탭으로 전환되도록 수정
* 상세: 
    - fQRGenApp.swift의 Settings { ... } Scene 제거 (별도 설정 윈도우 생성 원인)
    - cmd+, 키보드 단축키를 MainTabView의 설정 탭(tag 2)으로 전환하도록 처리
    - .commands { CommandGroup } 또는 onReceive 등으로 단축키 바인딩 구현
    - 중복 설정 UI 제거로 UX 일관성 확보
* 구현 명세:
    - `fQRGenApp.swift`에서 `Settings { ... }` 씬을 제거하여 윈도우 분리 방지
    - `.commands`에 `CommandGroup(replacing: .appSettings)`를 재정의하여 `Cmd+,` 입력 시 `OpenSettings` Notification을 발송하도록 설정
    - `MainTabView`에서 `.onReceive`를 통해 알림을 받아 `selectedTab = 2`로 변경하여 설정 탭 활성화 구현
* 완료 항목:
    - [x] Settings Scene 제거
    - [x] NotificationCenter 기반 설정 탭 자동 전환 구현



## Issue3: 설정창 2열 레이아웃 및 창 크기 고정 (등록: 2026.03.04) (✅ 완료, 8187371) ✅
* 목적: 모든 창의 크기를 고정하고, 설정창을 2열 레이아웃으로 변경하여 스크롤 없이 모든 설정 항목을 표시
* 상세: 
    - SettingsView의 VStack 세로 배치를 HStack + VStack 2열 구조로 변경
    - 좌측 열: 기본 설정 + 히스토리 관리, 우측 열: 앱 정보 + 지원 기능
    - MainTabView 및 각 탭 뷰에 고정 frame 적용 (minWidth/maxWidth, minHeight/maxHeight 통일)
    - 히스토리 탭은 내부 List/ScrollView에서 자체 스크롤 처리하므로 창 고정에 영향 없음
    - 외부 창 레벨의 스크롤 제거 (.scrollDisabled 또는 고정 frame)
* 구현 명세:
    - `SettingsView`의 내부 요소를 `HStack` 안에 두 개의 `VStack`을 배치하여 2열 구조로 변경 (좌측: 기본 설정+히스토리 관리, 우측: 앱 정보+지원 기능)
    - `MainTabView`에 `.frame(width: 800, height: 600)`을 적용하여 창 크기를 고정
* 완료 항목:
    - [x] SettingsView 2열 구조 적용
    - [x] 창 크기 고정 및 외부 스크롤 제거

## Issue1: 다국어 지원 기능 (8개 언어) 추가 (등록: 2026.03.04) (✅ 완료, f1323ae) ✅
* 목적: 현재 한국어 전용 SwiftUI 앱에 8개 언어 다국어(i18n) 지원을 추가하여 사용자 접근성 향상
* 상세:
    - 지원 언어: ko, en, ja, de, es, fr, zh-Hans, zh-Hant
    - SwiftUI Text의 LocalizedStringKey 자동 번역 활용
    - 한국어 키 기반 Localizable.strings 파일 생성 (.lproj 구조)
    - Xcode 프로젝트에 knownRegions 및 PBXVariantGroup 등록
* 구현 명세:
    - 일반 UI: QRGeneratorView, HistoryView, MenuBarManager 등 42개 문자열
    - 설정 UI: SettingsView 24개 문자열
    - 번역 스크립트: .agent/skills/localization/scripts/python/
    - 누락 번역 보완: "웹사이트", "고급 설정", "QR 코드 생성" 등 버튼 및 설정 문자열 추가 번역 및 로딩 완료
* 완료 항목:
    - [x] 8개 언어 × Localizable.strings 생성 (각 66개 키)
    - [x] knownRegions 업데이트 (project.pbxproj)
    - [x] PBXFileSystemSynchronizedRootGroup 자동 인식 확인
    - [x] Xcode 빌드 후 UI 번역 동작 확인 (사용자 검증 필요)

### Issue1_1: 앱 내 언어 전환 즉시 반영 구현 (등록: 2026.03.04) (✅ 완료)
* 목적: 언어 선택 UI에서 언어를 변경할 때 앱 UI가 즉시 전환되도록 구현
* 상세: 
    - SettingsView의 appLanguage 변경 시 AppleLanguages UserDefaults 키도 함께 업데이트
    - fQRGenApp.swift에서 @AppStorage("appLanguage") 를 읽어 Bundle/Locale 환경 전파
    - SwiftUI 뷰 계층에 .environment(\.locale, Locale(identifier: appLanguage)) 적용
    - 언어 변경 시 앱 재시작 없이 즉시 반영되는지 검증
    - 재시작이 불가피한 경우 "재시작 안내" 알림 다이얼로그 추가

### Issue1_2: 번역 누락 문자열 보완 (개, 버전, 개발자, 출시일) (등록: 2026.03.04) (✅ 완료)
* 목적: 영어 전환 시 번역되지 않는 누락 문자열을 Localizable.strings에 추가
* 상세: 
    - InfoRow label(버전, 개발자, 출시일) 번역 키 추가
    - Text("\\(history.items.count)개") 의 '개' 단위 처리 (개 → items 또는 포맷 스트링 적용)
    - translate-all-strings.py TRANSLATIONS 사전에 누락 항목 추가 후 재실행

# ⏸️ 보류
# 🚫 취소
# 📜 참고

