# nowQRGen 이슈 트래커
* Issue HWM: 5

# 🤔 결정사항

# 🌱 이슈후보

# 🚧 진행중
# 📕 중요

# 📙 일반
# 📘 선택

# 🌱 이슈후보

# ✅ 완료
## Issue5: 앱 탭 전환 단축키 추가 (Cmd+1/2/3) (등록: 2026.03.04) (✅ 완료, 9738f2f) ✅
* 목적: Cmd+1(QR 생성), Cmd+2(히스토리), Cmd+3(설정)으로 탭 전환 단축키를 추가하여 키보드 접근성 향상
* 상세:
    - nowQRGenApp.swift의 `.commands` 블록에 Cmd+1/2/3 단축키 정의
    - NotificationCenter를 통해 MainTabView의 selectedTab 변경
    - 기존 Cmd+, (설정) 단축키와 동일한 패턴으로 구현
* 구현 명세:
    - `nowQRGenApp.swift`: `.commands` 내 `CommandGroup`에 Cmd+1/2/3 Button 추가, 각각 "SelectTab" Notification 발송
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
    - nowQRGenApp.swift의 Settings { ... } Scene 제거 (별도 설정 윈도우 생성 원인)
    - cmd+, 키보드 단축키를 MainTabView의 설정 탭(tag 2)으로 전환하도록 처리
    - .commands { CommandGroup } 또는 onReceive 등으로 단축키 바인딩 구현
    - 중복 설정 UI 제거로 UX 일관성 확보
* 구현 명세:
    - `nowQRGenApp.swift`에서 `Settings { ... }` 씬을 제거하여 윈도우 분리 방지
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
    - nowQRGenApp.swift에서 @AppStorage("appLanguage") 를 읽어 Bundle/Locale 환경 전파
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

* Save Point :
      - 2026.03.04: 9738f2f (Close Issue5)
      - 2026.03.04: 690bdb7 (Close Issue4)
      - 2026.03.04: 8187371 (Close Issue2, Issue3)
      - 2026.03.04: f1323ae (Close Issue1)
