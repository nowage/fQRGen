//
//  HistoryView.swift
//  fQRGen
//
//  Created by nowage on 2025.06.15.
//

import SwiftUI
import AppKit

struct HistoryView: View {
    @EnvironmentObject var history: QRCodeHistory
    @StateObject private var qrGenerator = QRCodeGenerator()
    @State private var selectedItem: QRCodeItem?
    @State private var searchText = ""
    @State private var showingDetailSheet = false
    
    private var filteredItems: [QRCodeItem] {
        if searchText.isEmpty {
            return history.items
        } else {
            return history.items.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 제목
            Text("QR 코드 히스토리")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.blue)
                .padding(.top, 20)
            
            // 검색바
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("QR 코드 검색...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .frame(maxWidth: 600)
            .padding(.horizontal)
            
            // 히스토리 목록 또는 빈 상태
            if filteredItems.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 64))
                        .foregroundColor(.secondary)
                    
                    if searchText.isEmpty {
                        VStack(spacing: 8) {
                            Text("생성된 QR 코드가 없습니다")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("QR 생성 탭에서 QR 코드를 생성해보세요")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        VStack(spacing: 8) {
                            Text("검색 결과가 없습니다")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("다른 검색어를 시도해보세요")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // 히스토리 목록
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredItems, id: \.id) { item in
                            HistoryItemCard(item: item, qrGenerator: qrGenerator) {
                                selectedItem = item
                                showingDetailSheet = true
                            } onShare: {
                                shareItem(item)
                            } onDelete: {
                                history.removeItem(item)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: 800)
                
                // 전체 삭제 버튼
                Button("전체 삭제") {
                    showClearHistoryAlert()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.red)
                .cornerRadius(8)
                .padding()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showingDetailSheet) {
            if let selectedItem = selectedItem {
                QRDetailSheet(item: selectedItem, qrGenerator: qrGenerator)
            }
        }
    }
    
    private func showClearHistoryAlert() {
        let alert = NSAlert()
        alert.messageText = "히스토리 전체 삭제".localized
        alert.informativeText = "모든 QR 코드 히스토리가 삭제됩니다.".localized
        alert.addButton(withTitle: "삭제".localized)
        alert.addButton(withTitle: "취소".localized)
        alert.alertStyle = .warning
        
        if alert.runModal() == .alertFirstButtonReturn {
            history.clearHistory()
        }
    }
    
    private func shareItem(_ item: QRCodeItem) {
        if let qrImage = qrGenerator.generateQRCode(from: item.text) {
            let items: [Any] = [qrImage, item.text]
            SharingService.shareItems(items)
        }
    }
}

// 히스토리 아이템 카드
struct HistoryItemCard: View {
    let item: QRCodeItem
    let qrGenerator: QRCodeGenerator
    let onTap: () -> Void
    let onShare: () -> Void
    let onDelete: () -> Void
    
    private var qrImage: NSImage? {
        qrGenerator.generateQRCode(from: item.text, scale: 3)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // QR 코드 미리보기
            if let qrImage = qrImage {
                Image(nsImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            }
            
            // 텍스트 정보
            VStack(alignment: .leading, spacing: 4) {
                Text(item.text)
                    .font(.body)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                Text(item.timestamp, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 액션 버튼들
            HStack(spacing: 8) {
                Button(action: onShare) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .onTapGesture {
            onTap()
        }
        .contextMenu {
            Button("상세보기") { onTap() }
            Button("공유") { onShare() }
            Divider()
            Button("삭제") { onDelete() }
        }
    }
}

// QR 상세보기 시트
struct QRDetailSheet: View {
    let item: QRCodeItem
    let qrGenerator: QRCodeGenerator
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private var qrImage: NSImage? {
        qrGenerator.generateQRCode(from: item.text, scale: 10)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 헤더
            HStack {
                Text("QR 코드 상세보기")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button("닫기") {
                    dismiss()
                }
            }
            .padding()
            
            // QR 코드 및 정보
            if let qrImage = qrImage {
                VStack(spacing: 20) {
                    Image(nsImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("내용:")
                            .font(.headline)
                        
                        Text(item.text)
                            .font(.body)
                            .padding(12)
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("생성 시간:")
                            .font(.headline)
                        
                        Text(item.timestamp, style: .time)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: 400)
                    
                    // 액션 버튼들
                    HStack(spacing: 16) {
                        ActionButton(title: "공유", icon: "square.and.arrow.up", color: .blue) {
                            shareQRCode()
                        }
                        
                        ActionButton(title: "저장", icon: "folder", color: .green) {
                            saveQRCode()
                        }
                        
                        ActionButton(title: "복사", icon: "doc.on.clipboard", color: .purple) {
                            copyToClipboard()
                        }
                    }
                }
            }
            
            Spacer()
        }
        .frame(width: 500, height: 600)
        .alert("알림", isPresented: $showingAlert) {
            Button("확인") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func shareQRCode() {
        guard let qrImage = qrImage else { return }
        let items: [Any] = [qrImage, item.text]
        SharingService.shareItems(items)
    }
    
    private func saveQRCode() {
        guard let qrImage = qrImage else { return }
        let filename = "QR-\(item.timestamp.timeIntervalSince1970).png"
        if qrGenerator.saveQRCodeToFile(qrImage, suggestedFilename: filename) {
            alertMessage = "파일이 저장되었습니다.".localized
            showingAlert = true
        }
    }
    
    private func copyToClipboard() {
        guard let qrImage = qrImage else { return }
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([qrImage])
        alertMessage = "클립보드에 복사되었습니다.".localized
        showingAlert = true
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(QRCodeHistory())
            .frame(width: 800, height: 600)
    }
}
