# Localization Skill

## 개요
fQRGen 앱의 다국어 지원(Localization) 작업을 자동화하는 스킬.
xcstrings 파일 변환, 일반 UI 번역, 설정 UI 번역을 지원합니다.

## 지원 언어
- 한국어 (ko)
- 영어 (en)
- 일본어 (ja)
- 독일어 (de)
- 스페인어 (es)
- 프랑스어 (fr)
- 중국어 간체 (zh-Hans)
- 중국어 번체 (zh-Hant)

## 스크립트 구조

```
.agent/skills/localization/
├── SKILL.md                         # 이 파일
└── scripts/
    ├── localize.sh                  # 진입점 셸 스크립트
    └── python/
        ├── xcstrings-to-strings.py  # xcstrings → .lproj/.strings 변환
        ├── translate-all-strings.py # 일반 UI 번역
        └── translate-settings-strings.py  # 설정 UI 번역
```

## 사용 방법

### 1. xcstrings → .strings 변환
Xcode의 String Catalog (.xcstrings)를 .lproj 폴더 구조로 변환합니다.

```bash
sh .agent/skills/localization/scripts/localize.sh extract
```

### 2. 일반 UI 문자열 번역
QR 생성 탭, 히스토리 탭 등 일반 UI 문자열을 번역합니다.

```bash
sh .agent/skills/localization/scripts/localize.sh translate
```

### 3. 설정 UI 문자열 번역
SettingsView의 설정 UI 문자열을 번역합니다.

```bash
sh .agent/skills/localization/scripts/localize.sh translate-settings
```

## 번역 사전 관리

### translate-all-strings.py
`TRANSLATIONS` 딕셔너리에 일반 UI 문자열을 추가합니다.

```python
TRANSLATIONS = {
    "새 문자열": {
        "ko": "새 문자열",
        "en": "New String",
        "ja": "新しい文字列",
        ...
    }
}
```

### translate-settings-strings.py
`SETTINGS_TRANSLATIONS` 딕셔너리에 설정 UI 문자열을 추가합니다.
기존 .strings 파일에 병합(merge)하는 방식으로 동작합니다.

## 주의 사항
- 스크립트는 프로젝트 루트(`fQRGen/` 상위 디렉토리)에서 실행해야 합니다.
- xcstrings 파일이 없으면 `extract` 명령은 실행되지 않습니다.
  Xcode에서 File > New > String Catalog로 먼저 생성하세요.
- `translate-settings` 는 기존 .strings 파일에 누락된 키만 추가합니다 (기존 번역 보존).
