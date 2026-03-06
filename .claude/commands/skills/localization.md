---
description: "fQRGen 다국어 지원(Localization) 스킬 - xcstrings 변환 및 8개 언어 번역 자동화"
---

# Localization 스킬

## 개요
fQRGen 앱의 다국어 지원 작업을 자동화합니다.
한국어, 영어, 일본어, 독일어, 스페인어, 프랑스어, 중국어(간체/번체) 8개 언어를 지원합니다.

## 사용 가능한 명령어

### extract — xcstrings → .strings 변환
Xcode String Catalog를 각 언어별 .lproj/.strings 파일로 변환합니다.

// turbo
```bash
sh .agent/skills/localization/scripts/localize.sh extract
```

### translate — 일반 UI 번역
QR 생성 탭, 히스토리 탭 등 일반 UI 문자열 번역을 적용합니다.

// turbo
```bash
sh .agent/skills/localization/scripts/localize.sh translate
```

### translate-settings — 설정 UI 번역
SettingsView의 설정 항목 문자열 번역을 적용합니다.

// turbo
```bash
sh .agent/skills/localization/scripts/localize.sh translate-settings
```

## 번역 사전 위치
- **일반 UI**: `.agent/skills/localization/scripts/python/translate-all-strings.py` → `TRANSLATIONS`
- **설정 UI**: `.agent/skills/localization/scripts/python/translate-settings-strings.py` → `SETTINGS_TRANSLATIONS`

## 새 문자열 추가 방법
1. 위 번역 사전 파일에서 해당 딕셔너리에 새 키-값 쌍 추가
2. 8개 언어 모두 번역 입력
3. `translate` 또는 `translate-settings` 명령 실행

## 주의 사항
- 스크립트는 프로젝트 루트에서 실행됩니다 (자동 처리됨)
- xcstrings 파일이 없으면 `extract`는 skip됩니다
- `translate-settings`는 기존 번역을 보존하고 누락된 키만 추가합니다
