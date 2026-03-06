# fQRGen 로깅 시스템 가이드 (2025-12-11 업데이트)

fQRGen의 완전한 로깅 시스템 사용 가이드입니다.

## 📋 로그 레벨

| 레벨     | 값 | 이모지 | 사용 목적        | 전역 함수 |
| -------- | -- | ------ | ---------------- | --------- |
| VERBOSE  | 0  | 💬    | 모든 상세 정보   | `logV()` |
| DEBUG    | 1  | 🐛    | 디버깅 정보      | `logD()` |
| INFO     | 2  | ℹ️    | 일반 정보        | `logI()` |
| WARNING  | 3  | ⚠️   | 경고 메시지      | `logW()` |
| ERROR    | 4  | ❌     | 오류 메시지      | `logE()` |
| CRITICAL | 5  | 🚨    | 치명적 오류      | `logC()` |

## 🧩 모듈 시그니처 이모지 (Module Signatures)
주요 파일 및 모듈은 고유한 **시그니처 이모지**를 가집니다. 이는 `_doc_design/EmojiForFile.csv`에 정의되어 있으며, 로그 메시지의 맨 앞에 표시되어 출처를 즉시 식별하게 해줍니다.

**규칙**:
- **INFO/DEBUG/VERBOSE**: `[시그니처] [메시지]` 형태로 기록됩니다. (예: `🧩 매칭 성공`)
- **WARNING/ERROR**: `[시그니처] [경고/오류이모지] [메시지]` 형태로 강조됩니다. (예: `📂 ❌ 파일 읽기 실패`)

**주요 시그니처 (Source: EmojiForFile.csv)**:
- 🔹 `KeyEventMonitor`
- 🧩 `AbbreviationMatcher`
- 🔑 `TriggerKeyManager`
- 🚀 `ShortcutMgr`
- 🎨 `KeyRenderingManager`
- 🖼️ `AppActivationMonitor`
- 📂 `SnippetFileManager`
- ⚙️ `KeyEventProcessor`
*(전체 목록은 `_doc_design/EmojiForFile.csv` 참조)*

## 🚀 기본 사용법

```swift
// 전역 함수 사용 (권장)
logV("상세한 디버그 정보")
logD("디버그 정보")
logI("일반 정보")
logW("경고 메시지")
logE("오류 메시지")
logC("치명적 오류")

// 문자열 보간 사용 가능
logI("스니펫 로딩 완료: \(count)개")
logD("키 이벤트: keyCode=\(keyCode)")
```

## ⚙️ 로그 레벨 설정

### 설정 파일(config.yaml)을 통한 설정 (권장)
* **파일 경로**: `~/Documents/finfra/fQRGenData/config.yaml`
  * **참고**: `<AppName>`은 `CFBundleName`을 따르며, BundleID는 경로에 포함되지 않습니다.
* **설정 방법**: 파일을 텍스트 에디터로 열어 `log_level` 값을 변경합니다.

# ...

### 로그 파일 확인
```bash
# 메인 로그 파일 경로 (앱 기본값)
~/Documents/finfra/<AppName>/logs/flog.log
# (일반적으로 ~/Documents/finfra/fQRGenData/logs/flog.log)

# 🚨 사용자 정의 경로 (UserDefaults 'appRootPath' 설정 시)
# 예: ~/Documents/finfra/fQRGen_cbhistory/logs/flog.log
# 확인 방법: defaults read com.nowage.nowQRGen appRootPath

# 세션 보관 로그 (자동 생성)
~/Documents/finfra/<AppName>/logs/flog_YYYY-MM-DD_HH-mm-ss.log

# 실시간 확인
tail -f ~/Documents/finfra/<AppName>/logs/flog.log
# 또는 사용자 정의 경로에 맞춰 수정하여 사용
```

### 퍼포먼스 로그 (성능 분석 전용)
- 파일 경로: `~/Documents/finfra/<AppName>/logs/performance.log`
- 활성화 토글:
  - UI: 설정 > 고급 > 디버그 > “성능 모니터링”
  - 설정 파일: `config.yaml`의 `preferences.performance_monitoring: true`
- 기록 포맷: `[YYYY-MM-DD HH:mm:ss.SSS] [duration: 2.31ms] 메시지`
- 기록 예시:
  - `[2025-12-16 12:34:56.789] [duration: 2.31ms] Key Processing: 'a'`
  - `[2025-12-16 12:34:56.912] [duration: 0.45ms] Abbreviation Search: 'bb◊'`
- 코드 사용: 전역 함수 `logPerf(_ message: String, duration: TimeInterval)`
  - 내부에서 `PerformanceLogger.shared.log` 호출, 토글이 꺼져 있으면 기록하지 않음
- 운영 팁:
  - 일반 로그와 분리되어 병목 분석 시 잡음 최소화
  - `tail -f ~/Documents/finfra/<AppName>/logs/performance.log`로 실시간 관찰
  - 세션·시퀀스ID를 flog.log와 함께 사용하면 상관관계 확인이 용이

### 🔧 로깅 설정 (Preferences)
`config.yaml`에서 로깅 동작을 제어하는 핵심 설정입니다. 두 설정은 서로 다른 목적을 가집니다.

#### 1. `debug_logging` (파일 로그 마스터 스위치)
- **기능**: **flog.log 파일 쓰기(Disk I/O) 자체를 제어**하는 마스터 스위치입니다.
- **목적**: `false`로 설정 시, 로그 레벨과 관계없이 파일에 로그를 남기지 않아 성능과 수명을 보호합니다. (터미널/Console.app 출력은 로그 레벨에 따라 유지됨)
- **기본값**: `false` (운영 환경 권장)
- **종속성**: `key_logging`이 켜져 있어도 `debug_logging`이 꺼져 있으면 fkey.log 파일 쓰기가 제한될 수 있습니다.

#### 2. `key_logging` (키 이벤트 정밀 기록)
- **기능**: **별도의 KeyLogger 프로세스**를 실행하여 저수준 키 이벤트를 수집할지 결정합니다.
- **목적**: 키보드 훅킹 이슈, 키 씹힘 등 하드웨어/OS 레벨의 입력 문제를 디버깅하기 위함입니다.
- **기본값**: `false` (보안 및 성능 이유로 평상시 꺼둠)
- **작동 조건**: 
  1. `config.yaml`의 `key_logging: true`
  2. **AND** 현재 로그 레벨이 `DEBUG` 이하일 때 (코드 내 `manageKeyLogger` 참조)
- **참고**: 이 옵션이 켜지면 `fkey.log`가 생성되며, 이는 `flog.log`와 시퀀스 ID로 동기화됩니다.

> [!NOTE] 통일하지 않는 이유
> - `debug_logging`은 앱 내부 로직 추적용(In-App Trace)이며, 디스크 쓰기 방지가 주 목적입니다.
> - `key_logging`은 외부 프로세스(External Process) 실행 여부를 결정하며, 시스템 리소스를 더 많이 사용합니다.
> - 따라서 일반적인 디버깅(`debug_logging`)과 특수 목적의 하드웨어 디버깅(`key_logging`)은 분리되어야 합니다.

### KeyLogger · 보조 로그/파일
- Key 입력 상세 로그: flog.log에 DEBUG/VERBOSE 레벨로 함께 기록
- KeyLogger 전용 로그: `NSTemporaryDirectory()/fkey.log` (기본: `/tmp/fkey.log`)
  - 작성 주체: `_tool/key-code/KeyLogger.swift`
  - 포맷: `[YYYY-MM-DD HH:mm:ss.SSS:SequenceID] name={"key_code":"k"} usage=... misc=flags ...`
  - 실시간 확인: `tail -f /tmp/fkey.log`
- 시퀀스 ID 공유 파일: `NSTemporaryDirectory()/fQRGen_sequence.counter`
  - KeyLogger ↔ 앱 간 동일 키 이벤트에 동일 SequenceID 부여
  - flog.log/Performance.log와 시간·SequenceID로 상호 연계 분석 가능

### Console.app (시스템 로그)
1. **Applications/Utilities/Console.app 실행**
2. **Device > Mac 선택**
3. **Search: fQRGen 입력**

## 🎯 레벨별 활용 가이드

### VERBOSE (개발 중)
```swift
logV("키 입력: '\(char)' (keyCode: \(keyCode))")
logV("버퍼 상태: '\(textBuffer.suffix(20))'")
```

### DEBUG (테스트 중)
```swift
logD("팝업 표시: \(snippets.count)개 후보")
logD("텍스트 대체: '\(abbreviation)' → '\(snippet)'")
```

### INFO (일반 운영)
```swift
logI("앱 시작됨")
logI("설정 변경: 로그 레벨 \(level)")
logI("스니펫 로딩 완료: \(count)개")
```

### WARNING/ERROR/CRITICAL (문제 발생)
```swift
logW("접근성 권한 필요")
logE("파일 읽기 실패: \(error)")
logC("시스템 리소스 부족")
```

## 📝 NSLog 마이그레이션 가이드

### 변환 패턴
```swift
// Before
NSLog("⚠️ 경고 메시지")
NSLog("❌ 오류 메시지")
NSLog("✅ 성공 메시지")
NSLog("🔍 디버그 정보")

// After
logW("경고 메시지")
logE("오류 메시지")
logI("성공 메시지")
logD("디버그 정보")
```

### 레벨 매핑 기준
- ❌🚨 → `logE()/logC()` (오류/치명적)
- ⚠️ → `logW()` (경고)
- ✅🔧📊🎯 → `logI()` (정보)
- 🔍🎮⌨️🌍 → `logD()` (디버그)
- 기타 상세 → `logV()` (상세)

## 🔧 고급 기능

### 조건부 로깅 (성능 최적화)
```swift
// 복잡한 로그 생성은 레벨 체크 후
if logger.currentLogLevel.rawValue <= LogLevel.debug.rawValue {
    let complexInfo = generateComplexDebugInfo()
    logD("복잡한 정보: \(complexInfo)")
}
```

### DEBUG vs RELEASE 모드
- **DEBUG**: 기본 레벨 VERBOSE, 콘솔 출력 활성화
- **RELEASE**: 기본 레벨 INFO, 콘솔 출력 비활성화

### os.log 통합
- Console.app에서 로그 확인 가능
- 시스템 로그와 통합
- 적절한 OSLogType 자동 매핑

### 터미널 실시간 로그 확인
```bash
# 실시간 로그 스트림 확인
log stream --predicate 'subsystem == "com.nowage.nowQRGen"'

# 특정 레벨 이상만 확인 (eventType >= 2는 INFO 이상)
log stream --predicate 'subsystem == "com.nowage.nowQRGen" AND eventType >= 2'
```

## 🎮 디버깅 팁

### 키 이벤트 디버깅
```swift
// KeyEventMonitor에서 상세 로그
logV("키 이벤트: keyCode=\(event.keyCode), chars='\(event.characters ?? "")'")
logD("버퍼 상태: '\(textBuffer.suffix(20))'")
```

### 팝업 상태 디버깅
```swift
// 팝업 표시/숨김 추적
logD("팝업 표시: \(snippets.count)개 후보")
logV("선택된 인덱스: \(selectedIndex)/\(totalCount)")
```

### 텍스트 대체 디버깅
```swift
// 텍스트 대체 과정 추적
logI("텍스트 대체 시작: '\(abbreviation)' → '\(snippet)'")
logD("삭제할 문자 수: \(deleteCount)")
logV("클립보드 내용: '\(clipboardContent.prefix(50))'")
```

## 🚨 트러블슈팅

### 로그가 출력되지 않는 경우
1. **로그 레벨 확인**: 설정된 레벨보다 낮은 로그는 출력되지 않음
2. **설정 확인**: `defaults read com.nowage.nowQRGen LogLevel`
3. **앱 재시작**: 설정 변경 후 앱 재시작 필요
4. **콘솔 출력 설정**: `logger.enableConsoleOutput = true` (코드에서 설정 시)

### Console.app에서 로그가 보이지 않는 경우
```swift
// os.log 서브시스템 확인
let osLog = OSLog(subsystem: "com.nowage.nowQRGen", category: "main")
os_log("테스트 로그", log: osLog, type: .info)
```

### 로그 레벨 동작 확인
- **VERBOSE 모드**: 모든 로그 출력
- **CRITICAL 모드**: CRITICAL만 출력
- **WARNING 모드**: WARNING, ERROR, CRITICAL 출력

## 📈 성능 최적화

### 로그 레벨 조정으로 성능 향상
```swift
// 프로덕션에서는 WARNING 이상만
#if RELEASE
logger.currentLogLevel = .warning
#endif

// 특정 상황에서만 상세 로그
if debugModeEnabled {
    logger.currentLogLevel = .verbose
}
```

### 조건부 로깅 (성능 최적화)
```swift
// 복잡한 로그 생성은 레벨 체크 후
if logger.currentLogLevel.rawValue <= LogLevel.debug.rawValue {
    let complexInfo = generateComplexDebugInfo()
    logD("복잡한 디버그 정보: \(complexInfo)")
}
```

### 성능 고려사항
- **로그 레벨 체크**로 불필요한 문자열 생성 방지
- **메모리 효율적인 Singleton** 패턴 사용
- **os.log 활용**으로 시스템 레벨 최적화
- **레이지 평가 (@autoclosure)** 지원으로 성능 최적화

### 성능 문제 해결
```swift
// 로그 레벨을 WARNING 이상으로 제한
logger.currentLogLevel = .warning
logger.enableConsoleOutput = false
```
