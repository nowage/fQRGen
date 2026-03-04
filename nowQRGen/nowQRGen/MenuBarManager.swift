//
//  MenuBarManager.swift
//  nowQRGen
//
//  Created by nowage on 2025.06.15.
//

import SwiftUI
import AppKit

class MenuBarManager: NSObject, ObservableObject {
    private var statusBarItem: NSStatusItem?
    private let qrGenerator = QRCodeGenerator()
    private let history = QRCodeHistory()
    
    func setupMenuBar() {
        guard statusBarItem == nil else { return }
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusBarItem?.button {
            if #available(macOS 11.0, *) {
                button.image = NSImage(systemSymbolName: "qrcode", accessibilityDescription: "QR Generator")
            } else {
                button.title = "QR"
            }
            button.toolTip = "QR 코드 생성기"
        }
        
        statusBarItem?.menu = createMenu()
    }
    
    func removeMenuBar() {
        if let statusBarItem = statusBarItem {
            NSStatusBar.system.removeStatusItem(statusBarItem)
            self.statusBarItem = nil
        }
    }
    
    private func createMenu() -> NSMenu {
        let menu = NSMenu()
        
        // 빠른 QR 생성
        let quickGenerate = NSMenuItem(title: "빠른 QR 생성", action: #selector(showQuickGenerate), keyEquivalent: "")
        quickGenerate.target = self
        menu.addItem(quickGenerate)
        
        // 클립보드에서 QR 생성
        let fromClipboard = NSMenuItem(title: "클립보드에서 QR 생성", action: #selector(generateFromClipboard), keyEquivalent: "")
        fromClipboard.target = self
        menu.addItem(fromClipboard)
        
        menu.addItem(NSMenuItem.separator())
        
        // 메인 앱 열기
        let openApp = NSMenuItem(title: "앱 열기", action: #selector(openMainApp), keyEquivalent: "")
        openApp.target = self
        menu.addItem(openApp)
        
        menu.addItem(NSMenuItem.separator())
        
        // 종료
        let quit = NSMenuItem(title: "종료", action: #selector(quitApp), keyEquivalent: "q")
        quit.keyEquivalentModifierMask = [.command]
        quit.target = self
        menu.addItem(quit)
        
        return menu
    }
    
    @objc private func showQuickGenerate() {
        let alert = NSAlert()
        alert.messageText = "빠른 QR 생성"
        alert.informativeText = "QR 코드로 변환할 텍스트를 입력하세요:"
        alert.addButton(withTitle: "생성")
        alert.addButton(withTitle: "취소")
        
        let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        textField.stringValue = "https://"
        alert.accessoryView = textField
        
        alert.window.initialFirstResponder = textField
        
        if alert.runModal() == .alertFirstButtonReturn {
            let text = textField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            if !text.isEmpty {
                generateAndSaveQR(text: text)
            }
        }
    }
    
    @objc private func generateFromClipboard() {
        let pasteboard = NSPasteboard.general
        guard let text = pasteboard.string(forType: .string),
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(title: "클립보드가 비어있습니다", message: "클립보드에 텍스트를 복사한 후 다시 시도하세요.")
            return
        }
        
        generateAndSaveQR(text: text)
    }
    
    private func generateAndSaveQR(text: String) {
        guard let qrImage = qrGenerator.generateQRCode(from: text) else {
            showAlert(title: "QR 생성 실패", message: "QR 코드를 생성할 수 없습니다.")
            return
        }
        
        // 다운로드 폴더에 자동 저장
        let filename = "QR-\(Date().timeIntervalSince1970).png"
        if let fileURL = qrGenerator.quickSaveToDownloads(qrImage, filename: filename) {
            showAlert(title: "QR 생성 완료", message: "QR 코드가 다운로드 폴더에 저장되었습니다.\n\(fileURL.lastPathComponent)")
            
            // 히스토리에 추가
            let item = QRCodeItem(text: text, filename: filename)
            history.addItem(item)
        } else {
            showAlert(title: "저장 실패", message: "QR 코드 저장에 실패했습니다.")
        }
    }
    
    @objc private func openMainApp() {
        NSApp.activate(ignoringOtherApps: true)
        
        // 메인 윈도우가 없으면 새로 생성
        if NSApp.windows.filter({ $0.isVisible }).isEmpty {
            // SwiftUI 앱에서는 자동으로 윈도우가 생성됨
        } else {
            NSApp.windows.first?.makeKeyAndOrderFront(nil)
        }
    }
    
    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.addButton(withTitle: "확인")
            alert.runModal()
        }
    }
}
