---
description: fQRGen의 파일 경로 처리 및 디렉토리 구조 규칙
---

# 경로 및 디렉토리 규칙 (Path & Directory Rules)

## 1. 하드코딩된 절대 경로 금지 (No Hardcoded Absolute Paths)
- **규칙**: `/Users/nowage/...` 또는 `/Users/username/...`과 같은 하드코딩된 절대 경로를 절대 사용하지 마십시오.
- **이유**: 다양한 사용자 환경 및 머신 간의 이식성을 보장하기 위함입니다.
- **해결책**:
  - `FileManager.default.homeDirectoryForCurrentUser` 사용
  - `FileManager.default.urls(for: .documentDirectory, ...)` 사용
  - Application Bundle 또는 Repository Root로부터의 상대 경로 사용

## 2. 동적 설정이 진실의 원천 (Dynamic Configuration Source of Truth)
- **규칙**: 애플리케이션은 데이터 디렉토리를 결정할 때 반드시 사용자 설정(User's Configuration, 예: `UserDefaults`의 `appRootPath` 키)에 의존해야 합니다.
- **금지**: `Logger`, `AppDelegate` 또는 Manager 클래스 내의 기능적 로직에서 `finfra/fQRGen` 또는 `finfra/fQRGenData`를 하드코딩하지 마십시오.
- **기본값**: `AppInitializer.setupDefaults()` 또는 `PreferencesManager`의 초기 등록(Initial Registration) 과정에서만 기본 경로 문자열(예: `~/Documents/finfra/fQRGenData`)이 나타날 수 있습니다. 다른 모든 컴포넌트는 설정된 값을 읽어야 합니다.

## 3. 관례보다 설정 우선 (Configuration Over Convention)
- **규칙**: Snippet의 디렉토리 경로는 `_config.yml` (예: `snippet_base_path`)에 의해 결정되어야 합니다.
- **대체(Fallback)**: 설정이 누락된 경우, 하드코딩된 문자열이 아닌 표준 기본값(`.../fQRGenData/snippets`)으로 대체해야 합니다.

## 4. 규칙 기반 폴더 로딩 (Rule-Based Folder Loading)
- **규칙**: `SnippetFileManager`는 `_rule.yml`이 존재하는 경우 정의된 폴더 로딩을 우선해야 합니다.
- **배경**: 이는 데이터 폴더 내에서 승인되지 않았거나 관련 없는 디렉토리가 로드되는 것을 방지합니다.

## 5. 도구의 일관성 (Tooling Consistency)
- **규칙**: 모든 헬퍼 스크립트(`_tool/`, `.agent/skills/`)는 이 경로 규칙을 준수해야 합니다.
- **검증**: Bash/Python 스크립트에서 `$HOME` 또는 상대 경로 계산을 사용하십시오.

## 6. 임시 파일 및 로그 (Temporary Files & Logs)
- **규칙**: 임시적인 실행 결과, 1회성 테스트 스크립트, 그리고 임시 로그는 프로젝트 루트를 오염시키지 않도록 반드시 특정 폴더에 저장되어야 합니다.
- **경로**:
  - 임시 로그 파일: `logs/tmp/`
  - 임시 코드 및 1회성 스크립트: `_tool/tmp/`
- **관리**: 해당 폴더들은 `.gitignore` 처리되어 레포지토리에 커밋되지 않습니다.

## 7. 샌드박스 컨테이너 데이터 폴더 사용 금지 (No Sandbox Container Data Folder)
- **규칙**: 설정 파일(`.plist`) 및 데이터 접근을 위해 macOS 샌드박스 컨테이너 내부 경로(`~/Library/Containers/com.nowage.nowQRGen/Data/...`)를 직/간접적으로 참조하거나 사용하는 것을 엄격히 금지합니다.
- **이유**: 파일 생성/접근 권한 충돌, UserDefaults 동기화 갱신 지연, 디버깅 혼동 등의 문제를 예방하기 위함입니다.
- **해결책**:
  - 앱 설정 관리는 반드시 글로벌 Preferences 경로(`~/Library/Preferences/com.nowage.nowQRGen.plist`)를 사용하십시오.

## 8. AI 에이전트 파일 관리 원칙 (Agent Workspace Hygiene)
- **규칙**: AI 에이전트(Assitant 등)는 프로젝트 루트(Project Root) 디렉토리에 **어떠한 형태의 임의 파일이나 문서를 생성해서는 안 됩니다.**
  - **작업 계획 문서**: `task.md`, `tasks.md`, `Issue.md` 등은 루트에 두지 않고 지정된 `.gemini/` 등 아티팩트 전용 경로를 활용합니다. (접두사 `Issue` 규칙에 따른 `Issue.md`도 루트에서 관리하지 않음)
  - **임시 테스크/스크립트**: `testdefaults.swift`, `add_resource.rb` 등 Ad-hoc 스크립트 생성 시 반드시 `/tmp/`나 `_tool/tmp/`를 사용합니다.
  - **설계산출물**: 다이어그램(Mermaid 등) 및 문서는 규칙을 위해 `_doc_design/` 또는 `_doc_work/` 와 같이 명시적인 뎁스를 가진 경로 안에 생성해야 합니다.
- **이유**: 무분별한 1회성 스크립트나 마크다운 파일 생성이 프로젝트 루트 디렉토리를 오염시키는 것을 사전에 방지하기 위함입니다.

