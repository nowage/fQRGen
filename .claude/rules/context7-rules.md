# Context7 MCP 활용 가이드

Context7은 개발 라이브러리와 프레임워크의 최신 문서를 검색하고 조회할 수 있는 강력한 도구입니다. 이 MCP를 효과적으로 활용하는 방법은 **"검색(Resolve) -> 조회(Get Docs)"**의 2단계 프로세스를 따르는 것입니다.

## 1단계: 라이브러리 ID 검색 (`resolve-library-id`)
가장 먼저 원하는 라이브러리의 정확한 "Context7 ID"를 찾아야 합니다.

*   **Tool**: `mcp_context7_resolve-library-id`
*   **Input**: `libraryName` (예: "swift", "react", "pandas")
*   **Output**: 라이브러리 목록과 각 라이브러리의 고유 ID (예: `/swiftlang/swift`)

**사용 예시:**
> "Swift 관련 문서를 보고 싶어."
> -> `resolve-library-id(libraryName: "swift")` 호출
> -> 결과에서 `/swiftlang/swift` ID 확인

## 2단계: 문서 조회 (`get-library-docs`)
획득한 ID를 사용하여 구체적인 문서를 조회합니다.

*   **Tool**: `mcp_context7_get-library-docs`
*   **Inputs**:
    *   `context7CompatibleLibraryID`: 1단계에서 얻은 ID (필수)
    *   `topic`: 궁금한 주제 (예: "Generic", "Hooks", "DataFrame")
    *   `mode`: 문서 유형 선택
        *   `'code'` (기본값): API 레퍼런스, 코드 예제 위주
        *   `'info'`: 개념 설명, 가이드, 아키텍처 설명 위주

**사용 예시:**
> "Swift의 제네릭에 대해 코드 예제를 보여줘."
> -> `get-library-docs(id: "/swiftlang/swift", topic: "Generics", mode: "code")` 호출

## 3단계: 디버깅 활용 가이드 (Debugging)
에러가 발생하거나 동작이 이상할 때, Context7을 "지능형 매뉴얼 검색기"로 활용할 수 있습니다. 저에게 다음과 같이 요청해 주세요.

### 요청 패턴
> **"[라이브러리명]에서 [에러메시지/현상]이 발생해. Context7으로 원인이랑 해결책 찾아줘."**

### 구체적인 활용 예시
1.  **에러 코드 분석**
    *   "SQLite3에서 `SQLITE_BUSY` 에러가 자꾸 떠. Context7으로 `sqlite3`의 locking 모드나 timeout 설정 찾아보고 해결책 알려줘."
2.  **API 사용법 확인**
    *   "`sqlite3_prepare_v2` 함수 인자가 헷갈려. Context7으로 정확한 시그니처랑 예제 코드 확인해줘."
3.  **최적화/모범 사례**
    *   "이 코드 성능이 너무 느린 것 같아. `GRDB.swift` 문서에서 Bulk Insert 최적화 방법(WAL 모드 등)이 있는지 Context7으로 찾아봐줘."

### 제가 수행하는 내부 절차
1.  **Resolve**: 언급하신 라이브러리의 ID 식별 (예: `/stephencelis/sqlite.swift`)
2.  **Get Docs**: 에러 메시지나 키워드로 문서 검색 (예: topic="SQLITE_BUSY", mode="info")
3.  **Solution**: 공식 문서에 기반한 정확한 원인 분석 및 코드 수정 제안

## 활용 팁
1.  **ID가 확실하지 않을 땐 검색부터**: 사용자가 정확한 라이브러리 이름을 모를 수 있으므로 항상 `resolve`를 먼저 수행하여 올바른 버전을 선택하는 것이 좋습니다.
2.  **Mode 활용**:
    *   구현 방법이 궁금할 땐 `code` 모드
    *   개념 이해가 필요할 땐 `info` 모드
3.  **구체적인 토픽**: `topic`을 구체적으로 적을수록(예: "useEffect" vs "Hooks") 더 정확한 결과를 얻을 수 있습니다.
