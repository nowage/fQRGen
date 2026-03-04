//
//  nowQRGenApp.swift
//  nowQRGen
//
//  Created by nowage on 2025.06.15.
//

import SwiftUI

@main
struct nowQRGenApp: App {
    @StateObject private var menuBarManager = MenuBarManager()
    @StateObject private var history = QRCodeHistory()
    @AppStorage("appLanguage") private var appLanguage: String = "ko" // Default to Korean
    
    var body: some Scene {
        WindowGroup {
            MainTabView() // ContentView 대신 MainTabView 사용
                .environmentObject(history)
                .environment(\.locale, Locale(identifier: appLanguage))
                .onAppear {
                    menuBarManager.setupMenuBar()
                }
                .onChange(of: appLanguage) { _ in
                    menuBarManager.refreshMenu()
                }
                .onDisappear {
                    // 앱이 완전히 종료될 때만 메뉴바 아이템 제거
                }
        }
        // macOS 12.0 호환을 위해 windowResizability 제거 (MainTabView의 고정된 frame으로 처리됨)
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button("환경설정...") {
                    NotificationCenter.default.post(name: Notification.Name("OpenSettings"), object: nil)
                }
                .keyboardShortcut(",", modifiers: .command)
            }
            CommandGroup(after: .toolbar) {
                Button("QR 생성") {
                    NotificationCenter.default.post(name: Notification.Name("SelectTab"), object: 0)
                }
                .keyboardShortcut("1", modifiers: .command)

                Button("히스토리") {
                    NotificationCenter.default.post(name: Notification.Name("SelectTab"), object: 1)
                }
                .keyboardShortcut("2", modifiers: .command)

                Button("설정") {
                    NotificationCenter.default.post(name: Notification.Name("SelectTab"), object: 2)
                }
                .keyboardShortcut("3", modifiers: .command)
            }
        }
    }
}