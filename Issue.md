# nowQRGen 이슈 트래커
* Issue HWM: 1

# 🤔 결정사항

# 🌱 이슈후보

# 🚧 진행중
## Issue1: 다국어 지원 기능 (8개 언어) 추가 (등록: 2026.03.04)
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
* 완료 항목:
    - [v] 8개 언어 × Localizable.strings 생성 (각 66개 키)
    - [v] knownRegions 업데이트 (project.pbxproj)
    - [v] PBXFileSystemSynchronizedRootGroup 자동 인식 확인
    - [~] Xcode 빌드 후 UI 번역 동작 확인 (사용자 검증 필요)

### Issue1_1: 앱 내 언어 전환 즉시 반영 구현 (등록: 2026.03.04)
* 목적: 언어 선택 UI에서 언어를 변경할 때 앱 UI가 즉시 전환되도록 구현
* 상세: 
    - SettingsView의 appLanguage 변경 시 AppleLanguages UserDefaults 키도 함께 업데이트
    - nowQRGenApp.swift에서 @AppStorage("appLanguage") 를 읽어 Bundle/Locale 환경 전파
    - SwiftUI 뷰 계층에 .environment(\.locale, Locale(identifier: appLanguage)) 적용
    - 언어 변경 시 앱 재시작 없이 즉시 반영되는지 검증
    - 재시작이 불가피한 경우 "재시작 안내" 알림 다이얼로그 추가

### Issue1_2: 번역 누락 문자열 보완 (개, 버전, 개발자, 출시일) (등록: 2026.03.04)
* 목적: 영어 전환 시 번역되지 않는 누락 문자열을 Localizable.strings에 추가
* 상세: 
    - InfoRow label(버전, 개발자, 출시일) 번역 키 추가
    - Text("\\(history.items.count)개") 의 '개' 단위 처리 (개 → items 또는 포맷 스트링 적용)
    - translate-all-strings.py TRANSLATIONS 사전에 누락 항목 추가 후 재실행

# 📕 중요

# 📙 일반


# 📘 선택

# 🌱 이슈후보

# ✅ 완료
# ⏸️ 보류
# 🚫 취소
# 📜 참고
