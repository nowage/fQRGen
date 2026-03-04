# Antigravity Rules (규칙)

이 디렉토리는 `nowQRGen` 프로젝트 작업을 수행할 때 Antigravity 에이전트가 준수해야 할 운영 프로토콜과 제약 사항을 정의하는 규칙 파일들을 포함합니다.

모든 에이전트 작업은 이 규칙들을 "Source of Truth"로 간주하고 준수해야 합니다.

## 📚 규칙 목록 (규칙 카탈로그)

### 🧩 핵심 및 기반 (Core & Foundation)
| 규칙 파일                                  | 설명                                               |
| :----------------------------------------- | :------------------------------------------------- |
| **[language_rules.md](language_rules.md)** | 언어 사용 규칙 (한국어 우선 정책, 톤 앤 매너).     |
| **[config_rules.md](config_rules.md)**     | 설정 파일(`appSetting.json` 등) 관리 및 구조 규칙. |
| **[context7_rules.md](context7_rules.md)** | Context7 MCP 활용 및 외부 지식 통합 원칙.          |
| **[path_rules.md](path-rules.md)**         | 파일 경로 처리 및 디렉토리 구조 원칙 (하드코딩 금지). |

### 🛠 개발 및 배포 (Development & Deployment)
| 규칙 파일                                | 설명                                             |
| :--------------------------------------- | :----------------------------------------------- |
| **[issue_rules.md](issue_rules.md)**     | 이슈 라이프사이클 관리, ID 생성, 라벨링 규칙.    |
| **[git_rules.md](git_rules.md)**         | Git 브랜치 전략, 커밋 메시지 컨벤션, Save Point. |
| **[deploy_rules.md](deploy_rules.md)**   | 애플리케이션 빌드, 버전 업, 배포 절차.           |
| **[logging_rules.md](logging_rules.md)** | 로깅 시스템 표준, 로그 레벨(`logC`~`logV`) 정의. |
| **[capture_rules.md](capture_rules.md)** | UI 자동 캡처 표준 및 스크린샷 검증 절차.         |

### ⌨️ 기능 및 도메인 (Feature & Domain)
| 규칙 파일                                        | 설명                                                 |
| :----------------------------------------------- | :--------------------------------------------------- |
| **[snippet_rules.md](snippet_rules.md)**         | 스니펫 파일 명명, 폴더 접두사, 트리거 규칙.          |
| **[import_rules.md](import_rules.md)**           | Alfred 등 외부 스니펫 가져오기 및 변환 규칙.         |
| **[placeholder_rules.md](placeholder_rules.md)** | 스니펫 내 동적 플레이스홀더(`{{...}}`) 구문 및 처리. |
- **[terminal_rules.md](terminal_rules.md)**: Rule from _doc_work/terminal_rules.md
