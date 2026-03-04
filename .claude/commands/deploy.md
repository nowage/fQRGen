---
name: deploy
description: "[RELEASE ONLY] 프로덕션 환경 배포 및 구동 확인"
---

> [!CAUTION]
> **릴리스 전용 (Use Only for Releases)**: 이 워크플로우는 프로덕션 서버에 리소스를 세팅하거나 앱을 배포하기 전 의존성을 확인하고 프로덕션 구동이 정상적인지 점검합니다.

1. **프로덕션 모듈 설치 (Install Dependencies)**:
   ```bash
   npm ci --omit=dev
   ```

2. **프로덕션 서버 구동 (Production Run)**:
   ```bash
   NODE_ENV=production npm start
   ```
