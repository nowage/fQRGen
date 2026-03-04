//
//  QRGeneratorView.swift
//  nowQRGen
//
//  Created by nowage on 2025.06.15.
//

import SwiftUI
import AppKit

struct QRGeneratorView: View {
    @StateObject private var qrGenerator = QRCodeGenerator()
    @EnvironmentObject var history: QRCodeHistory
    @State private var inputText = "https://finfra.kr/en/"
    @State private var qrImage: NSImage?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var scale: Double = 10
    @State private var correctionLevel = "H"
    
    private let correctionLevels = ["L", "M", "Q", "H"]
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack(spacing: 30) {
                // 제목 (웹 버전과 동일)
                Text("QR 코드 생성기")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                
                VStack(spacing: 25) {
                    // 입력 섹션 (웹 버전과 유사한 레이아웃)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("URL 또는 텍스트 입력:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextEditor(text: $inputText)
                            .font(.system(size: 24))
                            .frame(height: 100)
                            .padding(8)
                            .background(Color(NSColor.textBackgroundColor))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                            )
                    }
                    .frame(maxWidth: 600)
                    
                    // 빠른 입력 버튼들 (macOS 12.0 호환)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("빠른 입력:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 8) {
                            HStack(spacing: 10) {
                                QuickInputButton(
                                    title: "웹사이트",
                                    icon: "globe",
                                    color: .blue,
                                    action: { inputText = "https://" }
                                )
                                
                                QuickInputButton(
                                    title: "이메일",
                                    icon: "envelope",
                                    color: .green,
                                    action: { inputText = "mailto:" }
                                )
                                
                                QuickInputButton(
                                    title: "전화번호",
                                    icon: "phone",
                                    color: .orange,
                                    action: { inputText = "tel:" }
                                )
                            }
                            
                            HStack(spacing: 10) {
                                QuickInputButton(
                                    title: "WiFi",
                                    icon: "wifi",
                                    color: .purple,
                                    action: { inputText = "WIFI:T:WPA;S:네트워크명;P:비밀번호;;" }
                                )
                                
                                QuickInputButton(
                                    title: "문자메시지",
                                    icon: "message",
                                    color: .cyan,
                                    action: { inputText = "sms:" }
                                )
                                
                                QuickInputButton(
                                    title: "연락처",
                                    icon: "person.crop.circle",
                                    color: .pink,
                                    action: { 
                                        inputText = """
                                        BEGIN:VCARD
                                        VERSION:3.0
                                        FN:홍길동
                                        TEL:010-1234-5678
                                        EMAIL:hong@example.com
                                        END:VCARD
                                        """ 
                                    }
                                )
                            }
                        }
                    }
                    .frame(maxWidth: 600)
                    
                    // 생성 버튼 (웹 버전과 동일한 텍스트)
                    Button(action: { generateQRCode(proxy: proxy) }) {
                        HStack {
                            Image(systemName: "qrcode")
                            Text("QR 코드 생성")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 250, height: 50)
                        .background(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(10)
                    }
                    .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .buttonStyle(PlainButtonStyle())
                    
                    // QR 코드 결과 표시
                    if let qrImage = qrImage {
                        VStack(spacing: 25) {
                            // 생성된 QR 코드
                            Image(nsImage: qrImage)
                                .interpolation(.none)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 280, height: 280)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8)
                            
                            // 생성된 텍스트 정보
                            VStack(alignment: .leading, spacing: 12) {
                                Text("생성된 QR 코드:")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                ScrollView {
                                    Text(inputText)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(16)
                                        .background(Color(NSColor.controlBackgroundColor))
                                        .cornerRadius(10)
                                }
                                .frame(maxHeight: 100)
                            }
                            .frame(maxWidth: 550)
                            
                            // 액션 버튼들
                            HStack(spacing: 20) {
                                ActionButton(title: "공유", icon: "square.and.arrow.up", color: .blue) {
                                    shareQRCode()
                                }
                                
                                ActionButton(title: "저장", icon: "folder", color: .green) {
                                    saveAsFile()
                                }
                                
                                ActionButton(title: "복사", icon: "doc.on.clipboard", color: .purple) {
                                    copyToClipboard()
                                }
                                
                                ActionButton(title: "다운로드", icon: "arrow.down.circle", color: .orange) {
                                    quickSave()
                                }
                            }
                        }
                        .padding(.top, 10)
                        .id("qrResult")
                    }
                    
                    // 설정 섹션 (접을 수 있는 형태)
                    DisclosureGroup("고급 설정") {
                        VStack(spacing: 16) {
                            HStack {
                                Text("크기:")
                                    .frame(width: 80, alignment: .leading)
                                Text("\(Int(scale))")
                                    .frame(width: 30, alignment: .leading)
                                    .foregroundColor(.blue)

                                Slider(value: $scale, in: 5...20, step: 1)
                            }
                            
                            HStack {
                                Text("오류 정정:")
                                    .frame(width: 80, alignment: .leading)
                                Picker("", selection: $correctionLevel) {
                                    ForEach(correctionLevels, id: \.self) { level in
                                        Text("\(level)").tag(level)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                        }
                        .padding()
                        .background(Color(NSColor.controlBackgroundColor).opacity(0.3))
                        .cornerRadius(10)
                    }
                    .frame(maxWidth: 600)
                }
                
                Spacer(minLength: 30)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 40)
            }
        }
        .alert("알림", isPresented: $showingAlert) {
            Button("확인") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func generateQRCode(proxy: ScrollViewProxy) {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        qrImage = qrGenerator.generateQRCode(
            from: text,
            scale: CGFloat(scale),
            correctionLevel: correctionLevel
        )
        
        if let qrImage = qrImage {
            // 히스토리에 추가
            let item = QRCodeItem(text: text)
            history.addItem(item)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    proxy.scrollTo("qrResult", anchor: .center)
                }
            }
        } else {
            alertMessage = "QR 코드 생성에 실패했습니다.".localized
            showingAlert = true
        }
    }
    
    private func shareQRCode() {
        guard let qrImage = qrImage else { return }
        
        let items: [Any] = [qrImage, inputText]
        SharingService.shareItems(items)
    }
    
    private func saveAsFile() {
        guard let qrImage = qrImage else { return }
        
        let filename = "QR-\(Date().timeIntervalSince1970).png"
        if qrGenerator.saveQRCodeToFile(qrImage, suggestedFilename: filename) {
            alertMessage = "파일이 저장되었습니다.".localized
            showingAlert = true
        } else {
            alertMessage = "파일 저장에 실패했습니다.".localized
            showingAlert = true
        }
    }
    
    private func quickSave() {
        guard let qrImage = qrImage else { return }
        
        let filename = "QR-\(Date().timeIntervalSince1970).png"
        if let fileURL = qrGenerator.quickSaveToDownloads(qrImage, filename: filename) {
            alertMessage = "QR 코드가 다운로드 폴더에 저장되었습니다.".localized + "\n\(fileURL.lastPathComponent)"
            showingAlert = true
        } else {
            alertMessage = "파일 저장에 실패했습니다.".localized
            showingAlert = true
        }
    }
    
    private func copyToClipboard() {
        guard let qrImage = qrImage else { return }
        
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([qrImage])
        
        alertMessage = "QR 코드가 클립보드에 복사되었습니다.".localized
        showingAlert = true
    }
}

// 빠른 입력 버튼 컴포넌트
struct QuickInputButton: View {
    let title: LocalizedStringKey
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.body)
                Text(title)
                    .font(.subheadline)
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(color)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// 액션 버튼 컴포넌트
struct ActionButton: View {
    let title: LocalizedStringKey
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(.white)
            .frame(width: 80, height: 70)
            .background(color)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QRGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        QRGeneratorView()
            .environmentObject(QRCodeHistory())
            .frame(width: 800, height: 900)
    }
}
