---
title: fQRGen 설정 파일 가이드
description: 프로젝트의 주요 설정 파일(appSetting.json, config.yaml, _rule.yml)의 용도와 정의
date: 2025-12-29
tags: [config, resource, setting]
---

# fQRGen 설정 파일 가이드

이 문서는 프로젝트의 동작을 제어하는 3가지 핵심 설정 파일의 위치와 역할을 정의합니다.

## 1. `_data/appSetting.json`
* **파일 경로**: `fQRGen/fQRGen/_data/appSetting.json`
* **용도**: **Buffer Clear Keys (버퍼 초기화 키) 정의**
* **설명**: 
  - 스니펫 감지 로직(Abbreviation Matcher)이 동작할 때, 입력 버퍼를 초기화하는 키들을 정의합니다.
  - 이 키가 입력되면 지금까지 쌓인 키 입력 버퍼가 비워지며, 새로운 스니펫 감지가 시작됩니다.
  - 기본값: 공백(` `), 엔터(`\n`, `\r`), 탭(`\t`), 쉼표(`,`), 마침표(`.`)
* **관리 클래스**: `BufferClearKeyManager.swift`
* **참조**: [`info_GLOSSARY.md`](./info_GLOSSARY.md) (11. 버퍼 클리어 키)

## 2. `config.yaml`
* **파일 경로**: `fQRGen/fQRGen/config.yaml`
* **용도**: **사용자 기본 설정 (Preferences) 및 시스템 초기값**
* **설명**: 
  - 앱의 전반적인 동작 옵션을 정의하는 YAML 파일입니다.
  - **포함 설정**:
    - **로깅**: 레벨(`log_level`), 디버그 로깅 여부
    - **단축키**: 팝업 호출, 히스토리 뷰어, 일시정지 등
    - **히스토리**: 저장 기간(`retentionDays`), 수집 항목(이미지/파일), 제외 설정
    - **팝업 UI**: 높이, 행 개수, 검색 범위
    - **경로**: 스니펫 기본 경로(`snippet_base_path`)
  - 이 파일은 앱 초기화 시 또는 설정 초기화(Factory Reset) 시 참조되거나, 외부 스크립트 도구들이 설정을 읽을 때 사용됩니다.
* **관리 클래스**: `PreferencesManager.swift`
* **참조**: [`AGENTS.md`](../AGENTS.md) (빌드·테스트·개발 명령 > 설정 조회)

## 3. `_rule.yml`
* **파일 경로**: `fQRGen/fQRGen/_rule.yml`
* **용도**: **특수 폴더 규칙 (Special Folder Rules) 정의**
* **설명**: 
  - `_`로 시작하는 특수 폴더들에 적용될 규칙(Prefix, Suffix, Trigger Bias 등)을 정의합니다.
  - Alfred에서 가져온 스니펫 컬렉션(`collections`)의 매핑 정보도 여기에 저장됩니다.
  - **주요 필드**:
    - `prefix`: 스니펫 앞에 자동 붙는 문자열
    - `suffix`: 스니펫 뒤에 붙는 문자열 (기본 트리거키 `◊` 대체 가능)
    - `trigger_bias`: 입력 감지 시 삭제할 글자 수 조정
* **관리 클래스**: `RuleManager.swift`
* **참조**: [`.agent/rules/snippet_rules.md`](./.agent/rules/snippet_rules.md) (특수 폴더 규칙), [`info_GLOSSARY.md`](./info_GLOSSARY.md) (5. 특수 폴더 시스템)
