# nowQRGen - macOS QR 코드 생성기

Node.js 기반 QR 코드 생성 웹앱을 macOS 네이티브 앱으로 포팅한 프로젝트입니다.

## 주요 기능

### 🎯 핵심 기능
* **QR 코드 생성** - 텍스트, URL, 이메일, 전화번호, WiFi 등 다양한 형태
* **실시간 미리보기** - 입력과 동시에 QR 코드 확인
* **다양한 저장 옵션** - 파일 저장, 다운로드 폴더 저장, 클립보드 복사
* **네이티브 공유** - macOS 공유 서비스 완전 지원

### 📱 macOS 네이티브 경험
* **메뉴바 지원** - 빠른 QR 생성 및 클립보드 연동
* **키보드 단축키** - 모든 주요 기능에 단축키 지원
* **설정 저장** - 사용자 기본 설정 자동 저장
* **히스토리 관리** - 생성한 QR 코드 자동 보관

### 🔍 고급 기능
* **오류 정정 레벨** - L, M, Q, H 4단계 지원
* **크기 조절** - 5x ~ 20x 배율 지원
* **검색 기능** - 히스토리에서 QR 코드 검색
* **빠른 입력** - 웹사이트, 이메일, 전화번호, WiFi 템플릿

## 기술 스택

| 구성요소 | 기술 |
|---------|------|
| UI 프레임워크 | SwiftUI |
| QR 생성 | CoreImage CIQRCodeGenerator |
| 데이터 저장 | UserDefaults |
| 파일 관리 | FileManager |
| 공유 기능 | NSSharingServicePicker |

## 프로젝트 구조

```
nowQRGen/
├── nowQRGenApp.swift          # 앱 진입점 및 메뉴바 설정
├── ContentView.swift          # 메인 컨테이너 뷰
├── MainTabView.swift          # 사이드바 네비게이션
├── QRGeneratorView.swift      # QR 생성 메인 화면
├── HistoryView.swift          # 히스토리 관리 화면
├── SettingsView.swift         # 설정 화면
├── QRCodeGenerator.swift     # QR 코드 생성 로직
├── QRCodeItem.swift          # 데이터 모델
├── SharingService.swift      # macOS 공유 기능
└── MenuBarManager.swift      # 메뉴바 관리
```

## 빌드 및 실행

### 요구사항
* **macOS**: 12.0 (Monterey) 이상
* **Xcode**: 14.0 이상
* **Swift**: 5.7 이상

### 빌드 방법
```bash
# 프로젝트 열기
open nowQRGen.xcodeproj

# 또는 명령줄 빌드
xcodebuild -project nowQRGen.xcodeproj -scheme nowQRGen -configuration Release
```

### 실행 방법
1. Xcode에서 프로젝트 열기
2. 타겟을 "My Mac"으로 설정
3. `Cmd + R`로 실행

## 사용법

### 기본 사용법
1. **QR 생성 탭**에서 텍스트 입력
2. 설정 조정 (크기, 오류 정정 레벨)
3. "QR 코드 생성" 버튼 클릭
4. 저장/공유/복사 중 선택

### 키보드 단축키
| 기능 | 단축키 |
|------|--------|
| QR 코드 생성 | `⌘ + Return` |
| 파일로 저장 | `⌘ + S` |
| 공유 | `⌘ + Shift + S` |
| 다운로드 폴더에 저장 | `⌘ + D` |
| 클립보드에 복사 | `⌘ + C` |

### 메뉴바 사용법
1. 상단 메뉴바에서 QR 아이콘 클릭
2. "빠른 QR 생성" 또는 "클립보드에서 QR 생성" 선택
3. 자동으로 다운로드 폴더에 저장

### WiFi QR 코드 생성
```
WIFI:T:WPA;S:네트워크명;P:비밀번호;;
```

### 연락처 QR 코드 생성
```
BEGIN:VCARD
VERSION:3.0
FN:홍길동
TEL:010-1234-5678
EMAIL:hong@example.com
END:VCARD
```

## 원본 Node.js 앱과의 비교

| 기능 | Node.js 원본 | Swift 포팅 |
|------|-------------|-----------|
| QR 생성 | qrcode 라이브러리 | CoreImage 네이티브 |
| 인터페이스 | 웹 브라우저 | 네이티브 macOS 앱 |
| 파일 저장 | 서버 폴더 | 로컬 파일 시스템 |
| 공유 기능 | 다운로드 링크 | macOS 공유 서비스 |
| 히스토리 | 없음 | UserDefaults 저장 |
| 성능 | 웹 서버 필요 | 네이티브 성능 |
| 오프라인 | 불가능 | 완전 오프라인 |

## 향후 개선 계획

### v1.1 계획
- [ ] 배치 QR 생성 (CSV 파일 지원)
- [ ] 커스텀 로고 삽입
- [ ] 색상 커스터마이징
- [ ] Export 형식 확장 (SVG, PDF)

### v1.2 계획
- [ ] iCloud 동기화
- [ ] 단축어(Shortcuts) 앱 연동
- [ ] 웹 API 서버 모드
- [ ] Touch Bar 지원

## 문제 해결

### 일반적인 문제
1. **QR 코드가 생성되지 않을 때**
   - 입력 텍스트가 비어있는지 확인
   - 특수 문자나 이모지 제거 후 재시도

2. **파일 저장이 안될 때**
   - 디스크 공간 확인
   - 폴더 권한 확인

3. **메뉴바 아이콘이 보이지 않을 때**
   - 설정에서 "메뉴바에 아이콘 표시" 옵션 확인

### 성능 최적화
- 대용량 텍스트의 경우 QR 복잡도가 증가하여 생성 시간이 길어질 수 있음
- 히스토리가 많을 경우 앱 시작 시간이 늘어날 수 있음 (정기적인 히스토리 정리 권장)

## 라이선스

MIT License - 자세한 내용은 [LICENSE](LICENSE) 파일 참조

## 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 지원

- **GitHub Issues**: 버그 리포트 및 기능 요청
- **이메일**: nowage@example.com
- **블로그**: https://finfra.kr/nowage

---

**개발자**: nowage  
**최초 릴리스**: 2025.06.15  
**포팅 기반**: Node.js QR Code Generator  
