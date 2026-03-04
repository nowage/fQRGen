# Mermaid 클래스 다이어그램 작성 규칙

## 1. 기본 구조

### 파일 시작
```mermaid
classDiagram
    direction TB
```

**주의사항**:
- ❌ YAML frontmatter (`---`) 사용 금지 - 순수 `.mermaid` 파일에서는 지원 안 됨
- ✅ 주석은 `%%`로 시작

## 2. 클래스 정의

### 기본 형식
```mermaid
class ClassName["🎨 DisplayName"] {
    <<stereotype>>
    -privateField: Type
    +publicField: Type
    +method()
}
```

### 필수 규칙
- **일관성 유지**: 모든 클래스에 Display name 사용 또는 모두 생략
- **중괄호 필수**: 멤버가 없어도 `{}` 필요
- **인덴트**: 4칸 공백

## 3. 클래스 멤버

### 접근 제어자
- `+` : public
- `-` : private
- `#` : protected
- `~` : package

### ❌ 금지 사항
```mermaid
@Published property: Type         ❌ Swift property wrapper 금지
property: T                       ❌ 제네릭 타입 금지
method(label:param:)              ❌ Swift labeled parameter 금지
closure: ((Type) -> Void)?        ❌ 복잡한 클로저 타입 금지
property: [String: [String]]      ⚠️  중첩 대괄호 주의 (닫는 괄호 확인)
```

### ✅ 권장 형식
```mermaid
+property: Type                   ✅ 간단한 타입
+method()                         ✅ 파라미터 생략
+closure: Closure                 ✅ 클로저는 단순화
+property: [String]               ✅ 단순 배열
+property: Any                    ✅ 제네릭 대신 Any 사용
```

## 4. 관계 (Relationships)

### 기본 문법
```mermaid
ClassA --> ClassB : label
ClassA ..> ClassB : implements
ClassA --|> ClassB : extends
ClassA --* ClassB : composition
ClassA --o ClassB : aggregation
```

### ❌ 금지 사항
```mermaid
ClassA,ClassB --> ClassC          ❌ 쉼표로 여러 클래스 지정 금지
🎨ClassA --> ClassB               ❌ 이모지만 사용 금지
class["Display"] --> ClassB       ❌ 정의된 클래스 이름 사용
```

### ✅ 올바른 형식
```mermaid
ClassA --> ClassB : relationship
ClassA --> ClassC : relationship
ClassName --> OtherClass : uses   ✅ 실제 클래스 이름 사용
```

**중요**: 관계에서는 클래스 정의의 실제 이름(`ClassName`)을 사용해야 하며, Display name(`"🎨 DisplayName"`)이나 이모지만 사용하면 안 됨!

## 5. 스테레오타입 (Stereotype)

### 형식
```mermaid
<<stereotype>>
```

### 권장 사용
```mermaid
<<interface>>
<<abstract>>
<<singleton>>
<<조정자>>        ✅ 한글 가능
```

## 6. 특수 문자 처리

### 이모지 사용
- ✅ Display name에 사용 가능: `class ClassName["🎨 DisplayName"]`
- ❌ 관계에 단독 사용 금지: `🎨ClassName --> ...`

### 괄호 균형
- 모든 여는 괄호 `( [ {`는 반드시 닫아야 함
- 복잡한 중첩 타입은 닫는 괄호 개수 재확인 필수

## 7. 검증 방법

### mermaid CLI 사용
```bash
# 설치
npm install -g @mermaid-js/mermaid-cli

# 검증
mmdc -i diagram.mermaid -o output.svg
```

### Python 개별 클래스 테스트
```python
# 각 클래스를 개별적으로 테스트하여 문제 클래스 찾기
# (스크립트는 필요시 제공)
```

## 8. 일반적인 오류와 해결책

### "Cannot read properties of undefined (reading 'startsWith')"
**원인**: 클래스 멤버에 잘못된 형식이나 undefined 값 존재
**해결**:
- Swift property wrapper 제거 (`@Published` 등)
- 복잡한 타입 단순화
- 제네릭 타입을 구체적 타입으로 변경

### "Parse error ... got 'PUNCTUATION'"
**원인**: 쉼표(`,`)가 잘못된 위치에 사용됨
**해결**:
- 관계 정의에서 쉼표 제거
- 각 관계를 별도 라인으로 분리

### "Parse error on line X"
**원인**: 특정 라인의 문법 오류
**해결**:
- 해당 라인과 주변 라인 확인
- 괄호 균형 확인
- 인덱트 확인

## 9. 체크리스트

작성 전:
- [ ] YAML frontmatter 없음
- [ ] 모든 클래스가 일관된 형식
- [ ] Swift 전용 문법 제거

작성 후:
- [ ] mermaid CLI로 검증
- [ ] 모든 괄호 닫힘 확인
- [ ] 관계에서 정의된 클래스 이름 사용

## 10. 참고 자료

- [Mermaid 공식 문서](https://mermaid.js.org/syntax/classDiagram.html)
- [Mermaid Live Editor](https://mermaid.live/)
