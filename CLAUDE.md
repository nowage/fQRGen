# nowQRGen 프로젝트

## 프로젝트 개요
텍스트, URL, 연락처, WiFi 정보 등으로부터 QR 코드를 생성하는 **macOS 네이티브 앱**.
SwiftUI 기반 UI, CoreImage QR 생성, 메뉴바 통합, 히스토리 관리 기능을 제공함.

## 기술 스택
- **언어**: Swift 5.7+
- **UI 프레임워크**: SwiftUI
- **QR 생성**: CoreImage (`CIQRCodeGenerator`)
- **macOS API**: AppKit (NSImage, NSSavePanel, NSAlert, NSSharingServicePicker)
- **데이터 저장**: UserDefaults, @AppStorage
- **외부 라이브러리**: 없음 (Apple 표준 프레임워크만 사용)

## 프로젝트 설정
- **번들 ID**: `com.nowage.nowQRGen`
- **배포 타겟**: macOS 12.0 (Monterey) 이상
- **App Sandbox**: 비활성화
- **버전**: 1.0.0

## 프로젝트 구조
```
nowQRGen/nowQRGen/
├── nowQRGenApp.swift       # 앱 진입점, MenuBarManager 초기화, Scene 설정
├── ContentView.swift       # 메인 컨테이너 (MainTabView 래퍼)
├── MainTabView.swift       # 탭 네비게이션 (QR 생성 / 히스토리 / 설정)
├── QRGeneratorView.swift   # QR 생성 메인 화면
├── HistoryView.swift       # 히스토리 목록/검색/상세보기
├── SettingsView.swift      # 설정 화면 (기본값, 앱 정보)
├── QRCodeGenerator.swift   # QR 생성 로직, 파일 저장
├── QRCodeItem.swift        # 데이터 모델, QRCodeHistory ObservableObject
├── MenuBarManager.swift    # 메뉴바 통합 (빠른 QR 생성, 클립보드)
└── SharingService.swift    # macOS NSSharingServicePicker 래퍼
```

## 주요 기능
- **QR 생성**: 텍스트, URL, 이메일(mailto:), 전화(tel:), WiFi, SMS, vCard
- **크기 조절**: 5x ~ 20x 스케일 슬라이더
- **오류 정정 레벨**: L / M / Q / H
- **저장 옵션**: 파일 선택 저장, Downloads 자동 저장, 클립보드 복사
- **히스토리**: UserDefaults 기반 자동 저장, 검색, 삭제
- **메뉴바**: 앱 없이 빠른 QR 생성, 클립보드 연동
- **macOS 공유**: NSSharingServicePicker 네이티브 공유

## 개발 명령어
- **빌드**: Xcode에서 `Cmd+B`
- **실행**: Xcode에서 `Cmd+R`
- **CLI 빌드**: `xcodebuild -scheme nowQRGen -configuration Debug build`
- **프로젝트 경로**: `nowQRGen/nowQRGen.xcodeproj`

## 에이전트 규칙 (Agent Rules)

@.claude/rules/language-rules.md
@.claude/rules/naming-rules.md
@.claude/rules/path-rules.md
@.claude/rules/git-rules.md
@.claude/rules/issue-rules.md
@.claude/rules/context7-rules.md
@.claude/rules/logging-rules.md
@.claude/rules/mermaid-rules.md
@.claude/rules/terminal-rules.md
@.claude/rules/config-rules.md
@.claude/rules/placeholder-rules.md
