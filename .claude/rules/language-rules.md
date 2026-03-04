# Language Rule - 언어 및 커뮤니케이션 규칙

## 1. 기본 원칙
* **Primary Language**: **Korean (한국어)**
* 시스템의 모든 출력, 로그, 사용자 알림, 대화, 문서, 주석, 워크플로우 상태 메시지 등은 반드시 **한국어**로 작성합니다.
* **Exception (Technical Terms)**: 기술 용어(Function Name, Class Name, Variable, Library, Framework, Error Code 등)는 명확성을 위해 **English (영어)** 원문을 유지합니다.

## 2. 적용 범위 및 예시

### 2.1 대화 및 생각 (Thinking Process)
* **Bad**: "I will analyze the `checkContextChange` function."
* **Good**: "`checkContextChange` 함수를 분석하겠습니다."

### 2.2 태스크 관리 (Task Boundary)
Task UI에 표시되는 상태 메시지도 한국어로 작성해야 합니다.
* **TaskName**: 작업의 제목
    * **Bad**: "Debugging Build Errors"
    * **Good**: "빌드 오류 디버깅"
* **TaskStatus**: 현재 진행 중인 작업 상태
    * **Bad**: "Running build command..."
    * **Good**: "빌드 명령어를 실행 중입니다..."
* **TaskSummary**: 완료된 작업 요약
    * **Bad**: "Fixed the issue."
    * **Good**: "문제를 해결했습니다."

### 2.3 음성 알림 (TTS)
`say` 명령어를 사용할 때는 영어 사용.

### 2.4 문서 (Artifacts)
* `task.md`, `implementation_plan.md`, `walkthrough.md`, `Issue.md` 등 모든 문서는 한국어로 작성합니다.
* **중요**: System Prompt에 정의된 Artifact 템플릿(예: `# Goal Description`)이 영어로 되어 있더라도, **반드시 해당 섹션 헤더와 내용을 한국어로 번역하여** 작성해야 합니다. (예: `# 목표 설명`)
* 단, 코드 블록 내부의 변수명/함수명은 영어로 유지합니다.

### 2.5 커밋 메시지 (Commit Messages)
이전 규칙과 동일하게 Conventional Commits 형식을 따르되, 설명 부분은 한국어를 권장합니다 (User Preference에 따름). 그러나 일반적으로 커밋 메시지는 **영어**로 작성하는 것이 관례인 경우 프로젝트 규칙(`git_rules.md`)을 따릅니다. 
* *참고: 현재 `User Preferences`에는 "커밋 메시지... 반드시 한국어로"라고 되어 있으므로, 한국어로 작성합니다.*
* **Format**: `Type(Scope): Subject`
* **Example**: `Fix(Core): 앱 전환 시 버퍼 초기화 오류 수정`

## 3. 예외 상황
* 코드 내의 **리터럴 문자열**이 프로그램 로직상 영어여야 하는 경우 (예: URL, 프로토콜 상수, 특정 API 응답값)
* 외부 도구(GitHub CLI, AWS CLI 등)의 명령어 인자가 영어만 허용하는 경우

## 4. 관련 규칙
* **코딩 및 테스트 데이터 정책**: [coding-rules.md](coding-rules.md)
    - 소스 코드 및 테스트 스크립트 내 사용자 데이터 하드코딩 금지
    - 데이터와 로직 분리, 테스트 환경 격리 원칙 준수
