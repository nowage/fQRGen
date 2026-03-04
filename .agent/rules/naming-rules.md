---
description: 프로젝트 파일 및 디렉토리 명명 규칙 (Naming Conventions)
---

# Naming Rules (명명 규칙)

이 문서는 nowQRGen 프로젝트의 파일, 디렉토리, 및 리소스 명명에 대한 표준을 정의합니다.

## 1. Skills, Rules, Workflows (Agent Directories)
Agent 관련 디렉토리(`.agent/`) 내의 **모든 파일 및 디렉토리**는 **kebab-case** (소문자 및 하이픈)를 엄격히 준수해야 합니다. **밑줄(`_`) 사용은 엄격히 금지됩니다.**

*   **Skills**: `.agent/skills/skill-name/`
    *   ✅ `.agent/skills/build-doctor/`
    *   ❌ `.agent/skills/build_doctor/`
    *   ❌ `.agent/skills/issue-manager/scripts/issue_manager.py` (파일 내용도 issue-manager.py여야 함)
*   **Rules**: `.agent/rules/rule-name.md`
    *   ✅ `.agent/rules/naming-rules.md`
    *   ❌ `.agent/rules/naming_rules.md`
*   **Workflows**: `.agent/workflows/workflow-name.md`
    *   ✅ `.agent/workflows/issue-fix.md`
    *   ❌ `.agent/workflows/issue_fix.md`

> [!IMPORTANT]
> 향후 `.agent/` 내에 생성되는 모든 파일(스크립트, 리소스 포함)은 절대 `_`를 포함해서는 안 됩니다. (단, 언어별 표준 컨벤션상 불가피한 `__init__.py` 등 제외)

## 2. 이유 (Rationale)
*   **일관성**: CLI 도구 및 URL 등에서 하이픈이 더 널리 사용됨.
*   **가독성**: 밑줄(_)보다 하이픈(-)이 시각적으로 단어를 더 명확하게 구분함.

## 3. 마이그레이션 가이드
기존의 `snake_case`로 작성된 이름은 발견 즉시 `kebab-case`로 변경하고, 관련 참조를 업데이트해야 합니다.
