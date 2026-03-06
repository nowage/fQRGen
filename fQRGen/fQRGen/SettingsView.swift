//
//  SettingsView.swift
//  fQRGen
//
//  Created by nowage on 2025.06.15.
//

import SwiftUI
import AppKit

struct SettingsView: View {
    @AppStorage("defaultScale") private var defaultScale: Double = 10
    @AppStorage("defaultCorrectionLevel") private var defaultCorrectionLevel = "H"
    @AppStorage("appLanguage") private var appLanguage: String = "ko"
    @EnvironmentObject var history: QRCodeHistory
    
    private let correctionLevels = ["L", "M", "Q", "H"]
    private let correctionLabels = [
        "L": "낮음 (~7%)",
        "M": "중간 (~15%)",
        "Q": "높음 (~25%)",
        "H": "최고 (~30%)"
    ]
    
    // 지원하는 언어 목록 (Korean, English, Japanese, German, Spanish, French, Chinese(Simp), Chinese(Trad))
    private let supportedLanguages = [
        ("ko", "한국어"),
        ("en", "English"),
        ("ja", "日本語"),
        ("de", "Deutsch"),
        ("es", "Español"),
        ("fr", "Français"),
        ("zh-Hans", "简体中文"),
        ("zh-Hant", "繁體中文")
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            // 제목
            Text("설정")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.blue)
                .padding(.top, 20)
            
            HStack(alignment: .top, spacing: 30) {
                // 좌측 열
                VStack(spacing: 25) {
                    // 기본 설정
                GroupBox {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("기본 설정")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("기본 QR 코드 크기")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                (Text("크기:") + Text(" \(Int(defaultScale))"))
                                    .frame(width: 100, alignment: .leading)
                                Slider(value: $defaultScale, in: 5...20, step: 1)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("기본 오류 정정 레벨")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Picker("오류 정정 레벨", selection: $defaultCorrectionLevel) {
                                ForEach(correctionLevels, id: \.self) { level in
                                    (Text(level) + Text(" ") + Text(LocalizedStringKey(correctionLabels[level] ?? ""))).tag(level)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        Divider()
                            .padding(.vertical, 4)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("언어 설정")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Picker("언어 선택", selection: $appLanguage) {
                                ForEach(supportedLanguages, id: \.0) { dict in
                                    Text(dict.1).tag(dict.0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 250)
                            .onChange(of: appLanguage) { newValue in
                                // AppleLanguages 값 업데이트 (앱 재시작 없이 즉시/다음 뷰 반영)
                                UserDefaults.standard.set([newValue], forKey: "AppleLanguages")
                                UserDefaults.standard.synchronize()
                            }
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: 500)
                
                // 히스토리 관리
                GroupBox {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("히스토리 관리")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("저장된 QR 코드")
                                    .font(.subheadline)
                                HStack(spacing: 2) {
                                    Text("\(history.items.count)")
                                        .bold()
                                    Text("개")
                                        .bold()
                                }
                                .font(.title2)
                                .foregroundColor(.blue)
                            }
                            
                            Spacer()
                            
                            Button("전체 삭제") {
                                showClearHistoryConfirmation()
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.red)
                            .cornerRadius(8)
                            .disabled(history.items.isEmpty)
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: 500)
                    
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity)
                
                // 우측 열
                VStack(spacing: 25) {
                    // 앱 정보
                GroupBox {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("앱 정보")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 12) {
                            InfoRow(label: "버전", value: "1.0.0")
                            InfoRow(label: "개발자", value: "nowage")
                            InfoRow(label: "출시일", value: "2025.06.15")
                        }
                        
                        Button("GitHub 저장소") {
                            if let url = URL(string: "https://github.com/nowage/qr-code-generator") {
                                NSWorkspace.shared.open(url)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .padding()
                }
                .frame(maxWidth: 500)
                
                // 지원 기능
                GroupBox {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("지원 기능")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            FeatureRow(icon: "photo", text: "PNG 이미지 내보내기")
                            FeatureRow(icon: "slider.horizontal.3", text: "크기 조절 (5x ~ 20x)")
                            FeatureRow(icon: "shield", text: "오류 정정 레벨 (L, M, Q, H)")
                            FeatureRow(icon: "doc.on.clipboard", text: "클립보드 복사")
                            FeatureRow(icon: "square.and.arrow.up", text: "macOS 공유 서비스")
                            FeatureRow(icon: "clock", text: "생성 히스토리")
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: 500)
                    
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private func showClearHistoryConfirmation() {
        let alert = NSAlert()
        alert.messageText = "히스토리 전체 삭제".localized
        alert.informativeText = "모든 QR 코드 히스토리가 삭제됩니다. 이 작업은 되돌릴 수 없습니다.".localized
        alert.addButton(withTitle: "삭제".localized)
        alert.addButton(withTitle: "취소".localized)
        alert.alertStyle = .warning
        
        if alert.runModal() == .alertFirstButtonReturn {
            history.clearHistory()
        }
    }
}

// 정보 행 컴포넌트
struct InfoRow: View {
    let label: LocalizedStringKey
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

// 기능 행 컴포넌트
struct FeatureRow: View {
    let icon: String
    let text: LocalizedStringKey
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(QRCodeHistory())
            .frame(width: 600, height: 700)
    }
}
