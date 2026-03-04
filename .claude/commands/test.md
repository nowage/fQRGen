---
name: test
description: "표준화된 빌드 및 테스트 프로세스"
---

# Test Workflow

`/test` 명령어를 사용하여 표준화된 테스트 프로세스를 실행합니다.

## 1. 정적 분석 및 컨벤션 검사 (Lint)
문법 오류나 코드 스타일 이슈를 확인합니다. (package.json 지원 시)

```bash
// turbo
npm run lint
```

## 2. 단위/통합 테스트 (Test)
테스트 프레임워크를 통해 작성된 테스트 코드들이 정상 통과하는지 확인합니다.

```bash
// turbo
npm test
```
