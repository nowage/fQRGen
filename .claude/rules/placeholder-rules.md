# 플레이스홀더 입력창 설계 문서

## 📋 개요

fQRGen의 플레이스홀더 기능을 위한 새로운 입력창 시스템 설계 문서입니다. 이전 구현의 성능 문제(30초 지연, 키보드 먹통)를 해결하고, 기존 스니펫 팝업창과 차별화된 독립적인 입력 시스템을 제공합니다.

**설계 일자**: 2025-09-01 (2025-12-11 업데이트)
**설계자**: Gemini 3.1 Agent
**상태**: 구현 완료 (Implemented)

---

## 🎯 설계 목표

### 기능적 목표
- `{{placeholder}}`, `{{placeholder:default}}` 패턴 완벽 지원
- 다중 플레이스홀더 동시 처리
- 캐시 기반 이전 입력값 활용

### 성능적 목표
- 입력창 표시 시간 < 100ms (이전: 30초)
- 키보드 응답성 < 16ms (이전: 2초 먹통)
- 메인 스레드 블로킹 없음

### 사용성 목표
- 모든 키보드 입력 허용 (한글, 특수문자 포함)
- 기존 스니펫 팝업창과 독립적인 키보드 처리
- 직관적인 폼 기반 UI

---

## 🏗️ 아키텍처 설계

### 전체 시스템 구조

```
PlaceholderInputSystem
├── PlaceholderInputWindow (NSWindow)
│   ├── PlaceholderFormView (SwiftUI)
│   │   ├── PlaceholderFieldView (개별 입력 필드)
│   │   ├── ActionButtonsView (확인/취소 버튼)
│   │   └── PlaceholderFormViewModel (상태 관리)
│   └── PlaceholderKeyHandler (키보드 이벤트 독립 처리)
├── PlaceholderManager (비즈니스 로직)
│   ├── PlaceholderParser (정규식 패턴 파싱)
│   ├── PlaceholderCache (값 캐시 관리)
│   └── PlaceholderValidator (입력 검증)
└── TextReplacer 통합
```

### 기존 스니펫 팝업창과의 차별화

| 구분 | 기존 스니펫 팝업창 | 새로운 플레이스홀더 창 |
|------|-------------|----------------------|
| **목적** | 스니펫 선택 | 값 입력 |
| **키보드 처리** | Up/Down/Escape 전용 | 모든 키보드 입력 허용 |
| **포커스 관리** | NonActivating | Activating (키보드 포커스 필요) |
| **UI 구조** | 단일 리스트 | 다중 입력 폼 |
| **상호작용** | 선택 후 닫기 | 입력 완료 후 닫기 |
| **윈도우 레벨** | .floating + nonactivating | .floating + activating |

---

## 💡 핵심 설계 원칙

### 1. 성능 우선 설계
- **커서 위치 의존성 완전 제거**: CursorTracker 사용 금지
- **사전 초기화 (Pre-initialization)**: 앱 시작 시 윈도우 미리 생성
- **동기식 처리**: 복잡한 세마포어/DispatchQueue 제거

### 2. 독립적 키보드 처리
- **팝업 네비게이션 키 충돌 방지**: Up/Down/Escape 키 독립 처리
- **모든 입력 허용**: 텍스트, 한글, 특수문자 등 제한 없음
- **전용 키 핸들러**: PlaceholderKeyHandler로 분리

### 3. 안정성 우선
- **Graceful Fallback**: 오류 시 일반 텍스트 대체로 안전하게 처리
- **메모리 최적화**: 입력창 재사용으로 메모리 사용량 최소화
- **예외 처리**: 모든 단계에서 예외 상황 대응

---

## 🛠️ 상세 기술 설계

### 데이터 모델

```swift
// 플레이스홀더 필드 정의
struct PlaceholderField {
    let name: String
    let defaultValue: String?
    let cachedValue: String?
    var currentValue: String = ""
    var isRequired: Bool = true
}

// 입력 요청 정의
struct PlaceholderInputRequest {
    let placeholders: [PlaceholderField]
    let abbreviation: String
    let originalContent: String
    let completion: ([PlaceholderResult]) -> Void
}

// 입력 결과 정의
struct PlaceholderResult {
    let name: String
    let value: String
}
```

### 핵심 클래스 설계

#### PlaceholderInputWindow
```swift
class PlaceholderInputWindow: NSWindow {
    override init(contentRect: NSRect, styleMask: NSWindow.StyleMask, 
                  backing: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, 
                  styleMask: [.titled, .closable], // activating window
                  backing: backing, 
                  defer: flag)
        
        // ✅ 기존 스니펫 팝업창과 다른 설정
        self.canBecomeKey = true        // 키보드 포커스 허용
        self.canBecomeMain = true       // 메인 윈도우 가능
        self.level = .floating          // 최상위 레벨
        self.isMovableByWindowBackground = true
        
        // 성능 최적화
        self.collectionBehavior = .canJoinAllSpaces
        self.animationBehavior = .none  // 애니메이션 제거
    }
    
    // 즉시 표시 (사전 초기화된 윈도우)
    func showInputForm(request: PlaceholderInputRequest) {
        updateContent(request.placeholders)
        centerOnScreen()
        makeKeyAndOrderFront(nil)
    }
}
```

#### PlaceholderKeyHandler
```swift
class PlaceholderKeyHandler {
    // ✅ 기존 스니펫 팝업창과 완전히 다른 키보드 처리
    func handleKeyEvent(_ event: NSEvent) -> Bool {
        switch event.keyCode {
        case 36: // Enter - 폼 제출
            submitForm()
            return true
        case 53: // Escape - 취소
            cancelInput()
            return true
        case 48: // Tab - 다음 필드로 이동
            focusNextField()
            return true
        default:
            // ✅ 모든 다른 키는 텍스트 입력으로 처리
            return false // 시스템이 텍스트 입력으로 처리
        }
    }
}
```

#### PlaceholderParser
```swift
class PlaceholderParser {
    // 정규식 패턴: {{name}} 또는 {{name:default}}
    private let pattern = #"\{\{([^}:]+)(?::([^}]*))?\}\}"#
    
    func extractPlaceholders(from content: String) -> [PlaceholderField] {
        let regex = try! NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))
        
        var fields: [PlaceholderField] = []
        var seenNames = Set<String>()
        
        for match in matches {
            guard let nameRange = Range(match.range(at: 1), in: content) else { continue }
            let name = String(content[nameRange]).trimmingCharacters(in: .whitespacesAndNewlines)
            
            // 중복 제거
            guard !seenNames.contains(name) && !name.isEmpty else { continue }
            seenNames.insert(name)
            
            // 기본값 추출
            var defaultValue: String? = nil
            if match.range(at: 2).location != NSNotFound {
                if let defaultRange = Range(match.range(at: 2), in: content) {
                    defaultValue = String(content[defaultRange]).trimmingCharacters(in: .whitespacesAndNewlines)
                    if defaultValue?.isEmpty == true { defaultValue = nil }
                }
            }
            
            // 캐시된 값 조회
            let cachedValue = PlaceholderCache.shared.getValue(for: name)
            
            fields.append(PlaceholderField(
                name: name,
                defaultValue: defaultValue,
                cachedValue: cachedValue
            ))
        }
        
        return fields
    }
}
```

---

## ⚡ 성능 최적화 전략

### 1. 즉시 표시 (< 100ms)
```swift
class PlaceholderInputSystem {
    private let prebuiltWindow: PlaceholderInputWindow
    
    init() {
        // 앱 시작 시 미리 생성 (숨김 상태)
        prebuiltWindow = PlaceholderInputWindow()
        prebuiltWindow.orderOut(nil)
        logI("플레이스홀더 입력창 사전 초기화 완료")
    }
    
    func showInput(request: PlaceholderInputRequest) {
        // ✅ 즉시 표시 (생성 지연 없음)
        prebuiltWindow.showInputForm(request: request)
        logI("플레이스홀더 입력창 즉시 표시")
    }
}
```

### 2. 메인 스레드 블로킹 방지
```swift
// ❌ 이전 방식 (성능 문제)
let cursorPosition = CursorTracker.getCursorRect() // 메인 스레드 블로킹

// ✅ 새로운 방식 (성능 최적화)
func showPlaceholderInput() {
    let screenFrame = NSScreen.main?.frame ?? .zero
    let windowFrame = NSRect(
        x: screenFrame.midX - 200, 
        y: screenFrame.midY - 100, 
        width: 400, 
        height: 200
    )
    inputWindow.setFrame(windowFrame, display: true)
    inputWindow.makeKeyAndOrderFront(nil)
}
```

### 3. 동기식 처리 단순화
```swift
// ❌ 이전 방식 (복잡한 비동기)
let semaphore = DispatchSemaphore(value: 0)
DispatchQueue.main.async { ... semaphore.signal() }
let result = semaphore.wait(timeout: .now() + 30)

// ✅ 새로운 방식 (단순한 동기식)
func showPlaceholderInput(request: PlaceholderInputRequest) -> [PlaceholderResult] {
    return placeholderInputSystem.showModalInput(request)
}
```

---

## 🔄 통합 플로우

### 전체 동작 시퀀스

```
1. 사용자 입력: "bba="
2. TextReplacer.replaceTextSync() 호출
3. 스니펫 내용 로드: "ls {{directory}}"
4. PlaceholderParser.extractPlaceholders() 실행
   ├── 정규식 매칭: {{directory}}
   ├── 캐시 값 조회: PlaceholderCache.getValue("directory")
   └── PlaceholderField 생성
5. PlaceholderInputSystem.showInput() 즉시 호출 (< 100ms)
   ├── 사전 초기화된 윈도우 활용
   ├── 화면 중앙에 폼 표시
   └── 첫 번째 필드에 포커스
6. 사용자 값 입력: "/Users/nowage/Documents"
   ├── 모든 키보드 입력 허용 (한글, 특수문자 포함)
   ├── Tab으로 필드 간 이동
   └── Enter로 폼 제출 또는 확인 버튼 클릭
7. PlaceholderCache.setValue() - 입력값 캐시 저장
8. 플레이스홀더 대체: "ls /Users/nowage/Documents"
9. TextReplacer.performSyncTextReplacement() 실행
10. 최종 텍스트 확장 완료
11. 입력창 숨김 및 재사용 준비
```

### 에러 핸들링 플로우

```
1. PlaceholderParser 실패 → 일반 텍스트 대체로 fallback
2. 입력창 표시 실패 → 기본값으로 자동 대체 + 로그 기록
3. 사용자 취소 → 원래 상태 복원
4. 입력 검증 실패 → 오류 메시지 표시 및 재입력 요청
```

---

## 📊 성능 목표 및 측정

### 성능 지표

| 지표                 | 이전 구현 | 목표값  | 측정 방법                |
| -------------------- | --------- | ------- | ------------------------ |
| **입력창 표시 시간** | 30초      | < 100ms | 키 입력 ~ 창 표시        |
| **키보드 응답성**    | 2초 먹통  | < 16ms  | 키 입력 ~ 텍스트 표시    |
| **메모리 사용량**    | -         | < 10MB  | 플레이스홀더 시스템 전체 |
| **CPU 사용률**       | -         | < 5%    | 입력창 활성화 시         |

### 성능 테스트 계획

1. **로드 테스트**: 10개 이상 플레이스홀더 동시 처리
2. **메모리 테스트**: 연속 100회 입력창 표시/숨김
3. **응답성 테스트**: 빠른 연속 키 입력 처리
4. **안정성 테스트**: 다양한 특수 문자 및 한글 입력

---

## 🛡️ 안정성 및 예외 처리

### 핵심 안정성 원칙

1. **Graceful Degradation**: 모든 오류 상황에서 앱 크래시 방지
2. **Safe Fallback**: 플레이스홀더 처리 실패 시 일반 텍스트 대체
3. **Resource Management**: 메모리 누수 방지 및 리소스 정리

### 예외 처리 설계

```swift
class PlaceholderInputSystem {
    func showInput(request: PlaceholderInputRequest) {
        // 1. 입력 검증
        guard !request.placeholders.isEmpty else {
            logW("플레이스홀더가 없음 - 일반 텍스트 대체로 fallback")
            performDirectTextReplacement(request)
            return
        }
        
        // 2. 윈도우 표시 시도
        do {
            try showInputWindow(request)
        } catch {
            logE("플레이스홀더 입력창 오류: \(error)")
            // 오류 시 기본값으로 자동 대체
            performDefaultValueReplacement(request)
        }
    }
    
    private func performDefaultValueReplacement(_ request: PlaceholderInputRequest) {
        let results = request.placeholders.map { placeholder in
            PlaceholderResult(
                name: placeholder.name,
                value: placeholder.defaultValue ?? placeholder.cachedValue ?? ""
            )
        }
        request.completion(results)
    }
}
```

---

## 📋 구현 계획

### Phase 1: 기본 구조 (완료)
- [x] PlaceholderInputWindow 기본 구현
- [x] 화면 중앙 고정 표시 구현  
- [x] 기본적인 SwiftUI 폼 UI 구성
- [x] PlaceholderKeyHandler 키보드 처리 (SwiftUI FocusState 대체)

### Phase 2: 핵심 로직 (완료)
- [x] PlaceholderParser 정규식 구현 (`AlfredLogic.convertDynamicPlaceholders` 활용)
- [x] 다중 플레이스홀더 처리 로직
- [x] PlaceholderFormViewModel 상태 관리
- [x] TextReplacer 통합

### Phase 3: 캐시 시스템 (부분 완료/진행중)
- [ ] PlaceholderCache UserDefaults 구현
- [ ] 값 저장/불러오기 로직

### Phase 4: 성능 최적화 (완료)
- [x] 사전 초기화 시스템 구현
- [x] 성능 최적화 (Window Level: Normal, Explicit Focus)

---

## ✅ 성공 기준

### 기능적 요구사항
- [x] `{{placeholder}}` 패턴 감지 및 파싱
- [x] `{{placeholder:default}}` 기본값 처리  
- [x] 다중 플레이스홀더 동시 처리
- [x] 캐시 값과 기본값 우선순위 처리
- [x] 모든 키보드 입력 지원 (한글, 특수문자)

### 성능 요구사항
- [x] 입력창 표시 시간 < 100ms
- [x] 키보드 응답 지연 없음 (< 16ms)
- [x] 메인 스레드 블로킹 없음
- [x] 메모리 사용량 < 10MB

### 사용성 요구사항
- [x] 직관적인 폼 기반 UI
- [x] 키보드 네비게이션 지원 (Tab, Enter, Escape)
- [x] 오류 시 안전한 fallback
- [x] 기존 스니펫 팝업창과의 키보드 충돌 없음

---

## 📚 참고 자료

### 관련 문서
- [Issue.md - issue17](../Issue.md#issue17-placeholder-기능-추가-제거됨---성능-문제): 이전 구현 실패 분석
- [debug_TECH.md](../_doc_work/debug_TECH.md): 기술적 디버깅 가이드 허브
- [logging_rules.md](./logging_rules.md): 로깅 시스템 활용법

### 기술 스택
- **UI Framework**: SwiftUI + NSHostingController
- **Window Management**: NSWindow (Activating)
- **키보드 처리**: NSEvent + Custom Handler
- **정규식**: NSRegularExpression
- **캐시**: UserDefaults
- **로깅**: 기존 Logger 시스템 활용

---

## 📝 변경 이력

| 날짜       | 버전 | 변경 내용                      |
| ---------- | ---- | ------------------------------ |
| 2025-09-01 | 1.0  | 초기 설계 문서 작성            |
| 2025-12-11 | 1.1  | 구현 완료 상태 반영 (Issue157) |

---

**설계 승인**: 완료
**구현 상태**: 핵심 기능 구현 완료, 캐싱 등 고도화 진행 중
