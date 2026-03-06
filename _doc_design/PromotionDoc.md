# PromotionDoc (홍보 및 앱스토어 메타데이터)

이 문서는 `fQRGen`의 홍보 및 앱스토어 등록을 위한 메타데이터 정보를 담고 있습니다.

---

## 1. 앱스토어 메타데이터 (App Store Metadata)

### 프로모션 텍스트 (Promotion Text)
> 클립보드 내용을 복사해서 붙이면 QR 코드가 준비됩니다. Mac 메뉴 막대에서 즉시 QR 코드를 생성하세요!

### 설명 (Description)
**복사해서 붙이면 QR 코드가 준비됩니다.**

fQRGen은 Mac 메뉴 막대에 상주하며 작업의 흐름을 끊지 않고 빠르게 QR 코드를 생성할 수 있게 도와주는 생산성 도구입니다. 메뉴 막대 아이콘을 클릭하면 클립보드에 복사된 텍스트나 URL을 간편하게 QR 코드로 변환할 수 있습니다.

**주요 기능:**
*   **즉각적인 액세스**: 어떤 앱을 사용 중이든 메뉴 막대 아이콘 클릭 한 번으로 QR 생성 패널이 열립니다. 별도의 앱 전환이 필요 없습니다.
*   **클립보드 연동**: 복사한 URL이나 텍스트를 연동하여 결과물을 확인하고 시간을 절약하세요.
*   **다양한 포맷 지원**: 웹용 PNG는 물론, 인쇄 및 스케일링에 최적화된 SVG 포맷을 모두 지원합니다.
*   **히스토리 관리**: 이전에 생성했던 QR 코드들을 히스토리 패널에서 한눈에 확인하고 재사용할 수 있습니다. 마케터와 디자이너에게 필수적인 기능입니다.
*   **사용자 맞춤 설정**: 로그인 시 자동 실행 설정 등 사용자의 워크플로우에 맞게 최적화할 수 있습니다.
*   **REST API 지원**: GUI뿐만 아니라 프로그램 방식으로도 QR 코드를 생성할 수 있는 API를 제공하여 CI/CD나 자동화 스크립트에서도 활용 가능합니다.

**추천 사용자:**
*   웹사이트 주소를 빠르게 공유해야 하는 마케터
*   인쇄물에 고정밀 QR 코드를 삽입해야 하는 디자이너
*   자주 사용하는 링크를 QR로 관리하고 싶은 생산성 매니아

### 키워드 (Keywords)
QR, Code, Generator, Mac, Productivity, MenuBar, SVG, PNG, API, 클립보드

### 지원 URL (Support URL)
[https://finfra.kr/w1/?category_name=fqrgen](https://finfra.kr/w1/?category_name=fqrgen)

### 마케팅 URL (Marketing URL)
[https://finfra.kr/product/fQRGen/index.html](https://finfra.kr/product/fQRGen/index.html)

---

## 2. 홍보 및 사용 가이드

### 3단계 시작하기
1.  **설치**: 앱을 다운로드하여 Applications 폴더로 이동합니다.
2.  **실행**: 메뉴 막대에 아이콘이 나타나면 아이콘을 클릭합니다.
3.  **생성**: 텍스트를 입력하거나 클립보드 복사 후 포맷(PNG/SVG)을 선택해 다운로드합니다.

### REST API 활용 (개발자용)
프로그래밍 방식으로 QR 코드를 생성하려면 다음 엔드포인트를 사용하세요.

- **Endpoint**: `POST /api/generate`
- **Body**: `{"data": "https://example.com", "format": "png"}` (format: 'png' 또는 'svg')

```bash
# PNG 생성 예시
curl -X POST https://[ServiceURL]/api/generate \
     -H "Content-Type: application/json" \
     -d '{"data":"https://finfra.kr", "format":"png"}' \
     --output qrcode.png
```

---
*최종 업데이트: 2026-03-06*
