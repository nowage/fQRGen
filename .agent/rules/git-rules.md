# nowQRGen Git 워크플로우 가이드

## Git 워크플로우 (서브태스크 완료 프로토콜)

각 서브태스크 완료 후 **필수 사항**:

1. **변경사항 검토**: `git status` 및 `git diff`로 모든 수정/새 파일 확인
2. **변경사항 스테이징**: `git add .` 또는 선택적 스테이징
3. **컨텍스트가 있는 커밋**: 태스크 참조가 포함된 설명적 커밋 생성
4. **태스크 업데이트**: 태스크 관리 시스템에서 완료 로그

## 이슈 관리 프로세스 (엄격히 준수 필요)

이슈 번호는 유니크하게 관리하고 해결된 이슈는 다음 프로세스에 따라 관리: 

**⚠️ 중요: 단계별 순서를 엄격히 준수하고, 사용자 확인 없이 임의로 커밋하지 말 것**

0. **이슈 시작**: git stash하고 branch생성하고 checkout
1. **구현**: Issue해결을 위한 코딩 작업
2. **내부 테스트**: 빌드 및 기본 동작 확인
3. **사용자 확인 요청**: "잘 작동함. commit해줘" 등의 확인 받기
4. **Issue.md 업데이트**: 해결된 이슈를 Done 섹션으로 이동 (**커밋 전 필수**)
   - 형식: `## issueN. [이슈 제목] (commit: [예정된 hash])`
   - 문제 원인, 해결 방법, 수정 파일, 테스트 결과 포함
5. **커밋**: 이슈 해결과 문서 업데이트를 모두 포함한 의미 있는 커밋 생성
6. **문서 업데이트**: 관련 문서들(README.md, GEMINI.md 등)도 함께 업데이트

**🚫 금지사항:**
- 사용자 확인 없이 임의로 커밋하지 말 것
- Issue.md 업데이트 없이 커밋하지 말 것  
- 테스트 없이 "작동할 것"이라고 가정하고 커밋하지 말 것
- Done 섹션 이동 없이 이슈를 완료 처리하지 말 것

**✅ 필수 확인사항:**
- [ ] 사용자가 기능 테스트를 완료했는가?
- [ ] 사용자가 명시적으로 커밋을 요청했는가?
- [ ] Issue.md에서 해당 이슈가 Done 섹션으로 이동되었는가?
- [ ] 커밋 메시지에 이슈 번호와 상세 내용이 포함되었는가?

## 머지 안전 수칙 (브랜치 번들ID/단일 인스턴스)

- 번들ID 변수화 유지: pbxproj의 설정은 반드시 다음과 같아야 함
  - `PRODUCT_BUNDLE_IDENTIFIER = "kr.finfra.fQRGen$(BUNDLE_ID_SUFFIX)";`  ← 따옴표 필수
- main 머지 시 원복 규칙: main에서는 `BUNDLE_ID_SUFFIX`가 비어 있으므로 원래 ID로 빌드됨(추가 조치 불필요)
- 스크립트는 상주: `_tool/build_branch.sh`, `_tool/run_branch.sh`는 main에 있어도 무방(접미사 비어있으면 원래 ID)
- 단일 인스턴스 가드 범위: 동일 번들ID끼리만 적용됨. 브랜치 빌드는 서로 간섭 없음
- 가드 해제 토글: 환경변수 `ALLOW_MULTIPLE_INSTANCES=1` 또는 `defaults write <bundleId> allowMultipleInstances -bool true`
- 락/알림 분리: 락 파일과 Darwin 알림 이름은 번들ID 포함으로 분리됨(충돌 없음)
- 공유 리소스 주의: 다음은 현재 공유됨(필요 시 분리 작업 별도 진행)
  - 설정/로그 경로: `~/Documents/finfra/nowQRGen/` (YAML `config.yaml`, `logs/`)
  - 캐시: `~/Library/Caches/kr.finfra.fQRGen` (고정 문자열)

### 머지 전 검증 체크리스트
- [ ] pbxproj에 따옴표 포함 상태 확인(위 형식과 동일)
- [ ] `xcodebuild -list -project nowQRGen/nowQRGen.xcodeproj` 파싱 성공
- [ ] main 브랜치에서 디버그 빌드 1회 수행(접미사 비어 있음)
- [ ] 필요 시 파생데이터 정리: `rm -rf ~/Library/Developer/Xcode/DerivedData/nowQRGen-*`
- [ ] 결과 Info.plist의 `CFBundleIdentifier`가 `kr.finfra.fQRGen`인지 확인

### 유용한 명령
- 브랜치 동시 실행: `./_tool/run_branch.sh`
- 브랜치 빌드만: `./_tool/build_branch.sh`
- 접미사 수동 지정: `xcodebuild -scheme nowQRGen -configuration Debug build BUNDLE_ID_SUFFIX=.mybranch`
- 다중 실행 허용(일시): `ALLOW_MULTIPLE_INSTANCES=1 open -n <AppPath>`


## 커밋 메시지 형식
```bash
# 서브태스크의 경우
git commit -m "feat(task-{id}): {서브태스크-설명}

- {구체적인 변경사항}
- {수정/추가된 파일}
- {중요한 참고사항}

Task: {task-id}.{subtask-id}"
```
