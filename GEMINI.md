# GEMINI.md

## 프로젝트: fQRGen (QR Code Generator)

텍스트나 URL로부터 QR 코드를 생성하는 Node.js 및 Express 기반 웹 애플리케이션입니다. PNG 및 SVG 포맷을 지원하며, 파일 다운로드 및 프로그래밍 방식의 API 접근을 제공합니다.

> **참고**: 본 프로젝트의 문서는 전문용어를 제외하고 모두 **한국어**로 작성하는 것을 원칙으로 합니다.

### 주요 기능 (Key Features)
- **Web Interface**: 텍스트를 입력하고 QR 코드를 생성하는 간단한 UI.
- **Formats**: PNG 및 SVG 지원.
- **Download**: 생성된 QR 이미지 직접 다운로드.
- **API**: QR 코드를 프로그래밍 방식으로 생성하기 위한 REST API 엔드포인트.

### 기술 스택 (Technical Stack)
- **Runtime**: Node.js
- **Framework**: Express.js
- **Template Engine**: EJS
- **Libraries**: `qrcode` (생성), `body-parser`
- **Dev Tools**: `nodemon`

### 프로젝트 구조 (Project Structure)
- `app.js`: 메인 애플리케이션 진입점 및 서버 로직.
- `views/index.ejs`: 메인 UI 템플릿.
- `public/`: 정적 에셋. 생성된 QR 코드는 `public/qr/`에 저장됨.
- `package.json`: 프로젝트 의존성 및 스크립트.

### 설치 및 사용 (Setup & Usage)
1. **의존성 설치 (Install Dependencies)**: `npm install`
2. **개발 서버 실행 (Run Development Server)**: `npm run dev` (`nodemon` 사용, 포트 3014)
   - 서버 주소: `http://localhost:3014`
3. **프로덕션 실행 (Run Production)**: `npm start`

### API 사용 (API Usage)
- **Endpoint**: `POST /api/generate`
- **Body**: `{"data": "https://example.com", "format": "png"}` (format: 'png' 또는 'svg')
