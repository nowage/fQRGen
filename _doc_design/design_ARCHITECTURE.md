# fQRGen 시스템 아키텍처 설계 문서

**최초 작성**: 2026-03-04
**최종 업데이트**: 2026-03-04
**상태**: 코드 분석 기반 (As-Is)

---

## 1. 프로젝트 개요

**fQRGen**은 텍스트, URL, 연락처, WiFi 정보 등으로부터 QR 코드를 생성하는 macOS 네이티브 앱입니다.

| 항목 | 내용 |
|------|------|
| 언어 | Swift 5.7+ |
| UI 프레임워크 | SwiftUI |
| QR 생성 엔진 | CoreImage (`CIQRCodeGenerator`) |
| macOS API | AppKit (NSImage, NSSavePanel, NSAlert, NSSharingServicePicker) |
| 데이터 저장 | UserDefaults, @AppStorage |
| 외부 라이브러리 | 없음 (Apple 표준 프레임워크만 사용) |
| 번들 ID | `com.nowage.nowQRGen` |
| 배포 타겟 | macOS 12.0 (Monterey) 이상 |
| 앱 버전 | 1.0.0 |

---

## 2. 파일 구조

```
fQRGen/fQRGen/
├── fQRGenApp.swift         # 앱 진입점, @main, Scene 설정
├── ContentView.swift         # MainTabView 래퍼 (최소화된 컨테이너)
├── MainTabView.swift         # 탭 네비게이션 (QR 생성 / 히스토리 / 설정)
├── QRGeneratorView.swift     # QR 생성 메인 화면 + 하위 컴포넌트
├── HistoryView.swift         # 히스토리 목록/검색/상세보기 + 하위 컴포넌트
├── SettingsView.swift        # 설정 화면 + 하위 컴포넌트
├── QRCodeGenerator.swift     # QR 생성 로직, 파일 저장 (비즈니스 로직)
├── QRCodeItem.swift          # 데이터 모델 + QRCodeHistory ObservableObject
├── MenuBarManager.swift      # 메뉴바 통합 (빠른 QR 생성, 클립보드 연동)
└── SharingService.swift      # macOS NSSharingServicePicker 래퍼
```

---

## 3. 레이어 아키텍처

```
┌─────────────────────────────────────────────────────────┐
│                      UI 레이어 (SwiftUI)                  │
│  MainTabView                                             │
│  ├── QRGeneratorView (+ QuickInputButton, ActionButton)  │
│  ├── HistoryView (+ HistoryItemCard, QRDetailSheet)      │
│  └── SettingsView (+ InfoRow, FeatureRow)                │
├─────────────────────────────────────────────────────────┤
│                  비즈니스 로직 레이어                       │
│  QRCodeGenerator       MenuBarManager                    │
│  SharingService        QRCodeHistory (ObservableObject)  │
├─────────────────────────────────────────────────────────┤
│                    데이터 모델 레이어                       │
│  QRCodeItem (Struct, Identifiable, Codable)             │
├─────────────────────────────────────────────────────────┤
│                  데이터 저장 레이어                         │
│  UserDefaults (히스토리 JSON 직렬화)                       │
│  @AppStorage (설정값: scale, correctionLevel, language)  │
├─────────────────────────────────────────────────────────┤
│                   macOS 시스템 API                        │
│  CoreImage (CIFilter/CIQRCodeGenerator)                  │
│  AppKit (NSImage, NSSavePanel, NSSharingServicePicker)  │
│  FileManager (Downloads 폴더 저장)                        │
└─────────────────────────────────────────────────────────┘
```

---

## 4. 핵심 컴포넌트 상세

### 4.1 `fQRGenApp` (앱 진입점)

- `@main` 어노테이션으로 앱 진입점 지정
- `@StateObject` 로 `MenuBarManager`, `QRCodeHistory` 생성 및 관리
- `@AppStorage("appLanguage")` 로 언어 설정 저장/로드
- `WindowGroup` 에 `MainTabView` 를 루트로 설정
- `.environmentObject(history)` 로 히스토리 객체를 하위 뷰에 전달
- `.environment(\.locale, ...)` 로 런타임 언어 전환 지원
- `Cmd+,` 단축키로 설정 탭 열기 (`OpenSettings` Notification 방식)

### 4.2 `MainTabView` (탭 네비게이션)

- 3개 탭: QR 생성(tag:0), 히스토리(tag:1), 설정(tag:2)
- 창 크기 **800x600으로 고정** (`.frame(width: 800, height: 600)`)
- `NotificationCenter` 수신으로 설정 탭 자동 전환 (`OpenSettings`)

### 4.3 `QRGeneratorView` (QR 생성 화면)

| 상태 | 타입 | 설명 |
|------|------|------|
| `inputText` | `@State String` | 입력 텍스트 (기본값: "https://example.com") |
| `qrImage` | `@State NSImage?` | 생성된 QR 이미지 |
| `scale` | `@State Double` | 크기 배율 (5~20, 기본값: 10) |
| `correctionLevel` | `@State String` | 오류 정정 레벨 (L/M/Q/H, 기본값: H) |

**빠른 입력 버튼 6종**: 웹사이트(`https://`), 이메일(`mailto:`), 전화번호(`tel:`), WiFi(`WIFI:T:WPA;...`), 문자메시지(`sms:`), 연락처(vCard)

**액션 버튼**: 공유, 저장(파일 선택), 복사(클립보드), 다운로드(Downloads 폴더)

### 4.4 `QRCodeGenerator` (핵심 비즈니스 로직)

```swift
// 핵심 메서드
func generateQRCode(from text: String, scale: CGFloat = 10, correctionLevel: String = "H") -> NSImage?
func saveQRCodeToFile(_ image: NSImage, suggestedFilename: String = "QRCode.png") -> Bool
func saveImageToURL(_ image: NSImage, url: URL) -> Bool
func quickSaveToDownloads(_ image: NSImage, filename: String) -> URL?
```

- `CIFilter(name: "CIQRCodeGenerator")` 사용
- `CIContext` 로 이미지 렌더링
- `CGAffineTransform` 으로 스케일 적용
- PNG 포맷으로 저장 (NSBitmapImageRep)
- macOS 11.0+ 호환 처리 (`UTType.png` vs `allowedFileTypes`)

### 4.5 `QRCodeItem` + `QRCodeHistory` (데이터 레이어)

```swift
struct QRCodeItem: Identifiable, Codable {
    let id: UUID        // 자동 생성
    let text: String    // QR 코드 내용
    let timestamp: Date // 생성 시각
    let filename: String? // 저장 파일명 (선택적)
}

class QRCodeHistory: ObservableObject {
    @Published var items: [QRCodeItem]
    // UserDefaults 키: "QRCodeHistory"
    // JSONEncoder/JSONDecoder 사용
    // 최신 항목이 맨 앞에 (insert at 0)
}
```

### 4.6 `HistoryView` (히스토리 화면)

- `@EnvironmentObject var history: QRCodeHistory` 로 데이터 수신
- 검색: `localizedCaseInsensitiveContains` 로 텍스트 필터링
- `HistoryItemCard`: 썸네일(scale:3), 텍스트, 날짜, 공유/삭제 버튼
- `QRDetailSheet`: Sheet 방식 상세보기 (scale:10 으로 재생성)
- 전체 삭제: NSAlert 확인 후 `clearHistory()` 호출

### 4.7 `SettingsView` (설정 화면)

| @AppStorage 키 | 타입 | 기본값 | 설명 |
|----------------|------|--------|------|
| `defaultScale` | Double | 10 | 기본 QR 크기 |
| `defaultCorrectionLevel` | String | "H" | 기본 오류 정정 레벨 |
| `appLanguage` | String | "ko" | 앱 언어 |

**지원 언어 8종**: 한국어(ko), English(en), 日本語(ja), Deutsch(de), Español(es), Français(fr), 简体中文(zh-Hans), 繁體中文(zh-Hant)

**2열 레이아웃**: 좌측(기본 설정 + 히스토리 관리) / 우측(앱 정보 + 지원 기능)

> **참고**: `defaultScale`, `defaultCorrectionLevel` 은 현재 `SettingsView` 에서만 저장되며, `QRGeneratorView` 의 실제 QR 생성 시 로드되지 않음 (별도 연동 미구현)

### 4.8 `MenuBarManager` (메뉴바 통합)

- `NSStatusBar.system.statusItem` 으로 메뉴바 아이콘 설정
- macOS 11.0+ 에서 `NSImage(systemSymbolName: "qrcode")` 사용
- **메뉴 구성**:
  - 빠른 QR 생성 (NSAlert + NSTextField 입력)
  - 클립보드에서 QR 생성 (NSPasteboard 읽기)
  - 앱 열기 / 종료
- 생성된 QR 코드는 Downloads 폴더에 자동 저장

### 4.9 `SharingService` (공유 서비스)

```swift
static func share(_ items: [Any], from sourceView: NSView) // 뷰 기준 위치 공유
static func shareItems(_ items: [Any])                      // 창 중앙 기준 공유
```

- `NSSharingServicePicker` 사용
- `NSApplication.shared.keyWindow` 에서 contentView 참조

---

## 5. 데이터 흐름

```
사용자 입력 텍스트
    │
    ▼
QRGeneratorView.generateQRCode()
    │
    ├──▶ QRCodeGenerator.generateQRCode()  ──▶  NSImage (QR 이미지)
    │         (CIFilter + CIContext)
    │
    ├──▶ QRCodeHistory.addItem()  ──▶  UserDefaults 저장 (JSON)
    │
    └──▶ UI 업데이트 (qrImage 상태 변경)
              │
              └──▶ 저장/공유/복사 액션
                      ├── saveQRCodeToFile() (NSSavePanel)
                      ├── quickSaveToDownloads() (Downloads 폴더)
                      ├── NSPasteboard.general (클립보드)
                      └── SharingService.shareItems() (NSSharingServicePicker)
```

---

## 6. 설정 데이터 흐름

```
@AppStorage("appLanguage")  ──▶  SettingsView Picker
                            ──▶  fQRGenApp .environment(\.locale, ...)
                            ──▶  UserDefaults["AppleLanguages"] 동기화

@AppStorage("defaultScale")         ──▶  SettingsView Slider (표시 전용)
@AppStorage("defaultCorrectionLevel") ──▶  SettingsView Picker (표시 전용)
```

---

## 7. Notification 흐름

```
fQRGenApp (CommandGroup "환경설정...")
    │  Cmd+,  →  NotificationCenter.post("OpenSettings")
    │
MainTabView.onReceive("OpenSettings")
    └──▶  selectedTab = 2  (설정 탭으로 전환)
```

---

## 8. 다국어 지원 구조

```
fQRGen/fQRGen/
├── ko.lproj/Localizable.xcstrings   # 한국어
├── en.lproj/Localizable.xcstrings   # 영어
├── ja.lproj/Localizable.xcstrings   # 일본어
├── de.lproj/Localizable.xcstrings   # 독일어
├── es.lproj/Localizable.xcstrings   # 스페인어
├── fr.lproj/Localizable.xcstrings   # 프랑스어
├── zh-Hans.lproj/                   # 중국어 간체
└── zh-Hant.lproj/                   # 중국어 번체
```

런타임 언어 전환: `@AppStorage("appLanguage")` 변경 → `.environment(\.locale, ...)` 재적용

---

## 9. 알려진 구현 이슈 / 개선 포인트

| 항목 | 현황 | 비고 |
|------|------|------|
| `defaultScale` / `defaultCorrectionLevel` 연동 | `SettingsView` 저장만 하고 `QRGeneratorView` 에서 로드 안 함 | 연동 구현 필요 |
| `MenuBarManager` 내부 `QRCodeHistory` | 앱 전체 히스토리와 별도 인스턴스 | 공유 인스턴스로 통일 필요 |
| `ContentView` | `MainTabView` 래퍼만 담당, 사실상 불필요 | 레거시 구조 |
| `SettingsView` `defaultScale` | `QRGeneratorView` 의 `scale` 초기값이 하드코딩(10) | @AppStorage 읽기 연동 필요 |
